program AOC_2024_Day6;

uses
  Vcl.Forms,
  UFrmMain in 'UFrmMain.pas' {FrmMain},
  UGardianWalk in 'UGardianWalk.pas',
  Communs.Helpers in '..\..\..\Communs\Base\Communs.Helpers.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.
