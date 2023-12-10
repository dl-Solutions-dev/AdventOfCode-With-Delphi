program AOC_Day9;

uses
  Vcl.Forms,
  UFrmMain in 'UFrmMain.pas' {Form4};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
