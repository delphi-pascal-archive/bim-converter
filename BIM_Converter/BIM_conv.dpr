program BIM_conv;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {BIMForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'BIM converter';
  Application.CreateForm(TBIMForm, BIMForm);
  Application.Run;
end.
