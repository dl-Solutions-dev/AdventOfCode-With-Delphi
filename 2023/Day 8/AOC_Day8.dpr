program AOC_Day8;

uses
  Vcl.Forms,
  UFrmMain in '..\..\..\Embarcadero\Studio\Projets\UFrmMain.pas' {FrmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
