program AOC_Day6;

uses
  Vcl.Forms,
  UFrmMain in 'UFrmMain.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
