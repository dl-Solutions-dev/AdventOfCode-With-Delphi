program AC_2024_Day23;

uses
  Vcl.Forms,
  UFrmMain in 'UFrmMain.pas' {FrmMain},
  Communs.Helpers in '..\..\..\Communs\Base\Communs.Helpers.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
