unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, Jpeg, ExtDlgs, ComCtrls,
  Zlib;

type
  TBIMForm = class(TForm)
    ImagePlace: TScrollBox;
    BtnLoad: TBitBtn;
    BtnConvert: TBitBtn;
    OpenImage: TOpenPictureDialog;
    AuthorLbl: TLabel;
    AuthorEdit: TEdit;
    CommentLbl: TLabel;
    CommentEdit: TEdit;
    SaveBIM: TSaveDialog;
    Progress: TProgressBar;
    BtnLoadBim: TButton;
    Pictogram: TImage;
    OpenBIM: TOpenDialog;
    RatioBox: TComboBox;
    CbPassProtect: TCheckBox;
    BtnFullScreen: TSpeedButton;
    procedure BtnLoadClick(Sender: TObject);
    procedure BtnConvertClick(Sender: TObject);
    procedure BtnLoadBimClick(Sender: TObject);
    procedure BtnFullScreenClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
  TBIMHead=packed record
    Signature:Array[0..2]of char;
    Img_Height:DWORD;
    Img_Width:DWORD;
    Author:ShortString;
    Comment:ShortString;
    PassWord:ShortString;
    PassProtect:boolean;
  end;

type
  TPixelColor=packed record
    Color:0..high(TColor);
  end;

type TCompLevel = (clNone, clFastest, clDefault, clMax);

var
  BIMForm: TBIMForm;
  
implementation

{$R *.dfm}

function ProtectString(Text:string):String;
var index:integer;
    temp:string;
begin
  temp:='';
  for index:=1 to length(text) do
    temp:=temp+chr(byte(text[index]) xor byte(text[length(text)-index]));
  result:=Temp;
end;

procedure CompressStream(inStream, outStream :TStream; const Level : TCompLevel = clDefault);
begin
 with TCompressionStream.Create(TCompressionLevel(Level), outStream) do
  try
   CopyFrom(inStream, inStream.Size);
  finally
   Free;
  end;
end;

procedure ExpandStream(inStream, outStream :TStream);
{const
 BufferSize = 4096;  }
var
 Count: integer;
 ZStream: TDecompressionStream;
 Buffer: {array[0..BufferSize-1] of} Byte;
begin
 ZStream:=TDecompressionStream.Create(InStream);
 try
  while true do
   begin    
    Count:=ZStream.Read(Buffer, sizeof(buffer));
    if Count<>0
    then OutStream.WriteBuffer(Buffer, Count)
    else Break;
   end;
  finally
   ZStream.Free;
  end;
end;

procedure TBIMForm.BtnLoadClick(Sender: TObject);
begin
  if OpenImage.Execute then
    pictogram.Picture.LoadFromFile(openimage.FileName);
end;

procedure TBIMForm.BtnConvertClick(Sender: TObject);
var SaveStream:TMemoryStream;
    ImgHead:TBIMHead;
    PixColor:TPixelColor;
    H,W:Integer;
    OutStream:TMemoryStream;
    Level:TCompLevel;
    pass:string;
    index:byte;
begin
  if not SaveBIM.Execute then exit;
  if cbpassprotect.Checked then
  if not inputquery('PassWord',
                    'Enter password for this file',
                    pass)
                                      then begin
                                      pass:='';
                                      savestream.Free;
                                      outstream.Free;
                                      exit;
                                      end;
  pass:=protectstring(pass);
  index:=0;
  progress.Max:=pictogram.Height;
  ImgHead.Signature:='BIM';
  imghead.PassWord:=pass;
  imghead.PassProtect:=CbPassProtect.Checked;
  ImgHead.Img_Height:=Pictogram.Height;
  ImgHead.Img_Width:=Pictogram.Width;
  ImgHead.Author:=AuthorEdit.Text;
  ImgHead.Comment:=CommentEdit.Text;
  SaveStream:=TMemoryStream.Create;
  outStream:=TMemoryStream.Create;
  SaveStream.Clear;
  outstream.Clear;
  SaveStream.Write(ImgHead,sizeof(TBIMHead));
  For h:=0 to pictogram.Height do begin
    for w:=0 to pictogram.Width do
      begin
        if imghead.PassProtect then
          pixcolor.Color:=pictogram.Canvas.Pixels[w,h] xor byte(pass[index])
        else
          pixcolor.Color:=pictogram.Canvas.Pixels[w,h];
        savestream.Write(pixcolor,sizeof(TPixelColor));
        inc(index);
        if index>=length(pass) then index:=0;
      end;
      progress.Position:=h;
    end;

  savestream.Seek(0,soFromBeginning);
  case RatioBox.ItemIndex of
    0:Level:=clNone;
    1:Level:=clFastest;
    2:Level:=clDefault;
    3:Level:=clMax;
  end;
  compressstream(savestream,outstream,Level);
  if uppercase(extractfileext(savebim.FileName))<>'.BIM' then
    outStream.SaveToFile(SaveBIM.FileName+'.BIM')
  else
    outStream.SaveToFile(SaveBIM.FileName);
  outStream.Free;
  savestream.Free;
  progress.Position:=0;
  pass:='';
end;

procedure TBIMForm.BtnLoadBimClick(Sender: TObject);
var LoadStream:TMemoryStream;
    ImgHead:TBIMHead;
    PixColor:TPixelColor;
    H,W:Integer;
    Temp:TMemoryStream;
    pass:string;
    index:byte;
begin
  if not OpenBIM.Execute then exit;
  pictogram.AutoSize:=false;
  pictogram.Picture.bitmap:=nil;
  LoadStream:=TMemoryStream.Create;
  Temp:=TMemoryStream.Create;
  Temp.LoadFromFile(OpenBIM.FileName);
  loadstream.Clear;
  expandstream(temp,loadstream);
  loadstream.Seek(0,soFromBeginning);
  LoadStream.Read(ImgHead,sizeof(TBIMHead));
  if imghead.Signature<>'BIM' then
    begin
      showmessage('There is not BIM image');
      LoadStream.Free;
      Temp.Free;
      pass:='';
      pictogram.AutoSize:=true;
      exit;
    end;
  if imghead.PassProtect then
  if not inputquery('PassWord',
                    'Enter password for this file',
                    pass) then
    begin
      LoadStream.Free;
      Temp.Free;
      pass:='';
      pictogram.AutoSize:=true;
      exit;
    end;
  pass:=protectstring(pass);
  if imghead.PassWord<>pass then
    begin
      Showmessage('Wrong password!!!');
      LoadStream.Free;
      Temp.Free;
      pass:='';
      pictogram.AutoSize:=true;
      exit;
    end;
  index:=0;
  AuthorEdit.Text:=ImgHead.Author;
  CommentEdit.Text:=ImgHead.Comment;
  progress.Max:=imghead.Img_Height;
  pictogram.Height:=imghead.Img_Height;
  pictogram.Width:=imghead.Img_Width;
  for h:=0 to imghead.Img_Height do
    begin
      for w:=0 to imghead.Img_Width do
        begin
          loadstream.Read(pixcolor,sizeof(TPixelColor));
          if imghead.PassProtect then
            pictogram.Canvas.Pixels[w,h]:=pixcolor.Color xor byte(pass[index])
          else
            pictogram.Canvas.Pixels[w,h]:=pixcolor.Color;
          inc(index);
        if index>=length(pass) then index:=0;
        end;
      progress.Position:=h;
    end;
  loadstream.Free;
  pictogram.AutoSize:=true;
  progress.Position:=0;
  pass:='';
end;

procedure TBIMForm.BtnFullScreenClick(Sender: TObject);
var scrForm:TForm;
    pict:TImage;
begin
  if pictogram.Picture<>nil then
    begin
    SCRFORM:=TForm.Create(self);
    pict:=timage.Create(scrform);
    pict.Parent:=scrform;
    pict.Left:=0;
    pict.Top:=0;
    pict.AutoSize:=true;
    pict.Picture:=pictogram.Picture;
    scrform.Caption:=caption+' - Full view';
    scrform.BorderStyle:=bsToolWindow;
    scrform.AutoSize:=true;
    scrform.Position:=poScreenCenter;
    scrform.ShowModal;
    scrform.Free;
    end;
end;

end.
 