program AOC_2024_Day24;

uses
  Vcl.Forms,
  UFrmMain in 'UFrmMain.pas' {FrmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
