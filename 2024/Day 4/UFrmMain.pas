unit UFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Generics.Defaults, System.Generics.Collections;

type
  TFrmMain = class( TForm )
    Edt1 : TEdit;
    BtnExercice1 : TButton;
    Edt2 : TEdit;
    BtnExercice2 : TButton;
    ChkTests : TCheckBox;
    MmoLogs: TMemo;
    procedure BtnExercice1Click( Sender : TObject );
    procedure BtnExercice2Click( Sender : TObject );
  private
    { Déclarations privées }
    FFile : TArray< string >;

    function GetInputFileName : string;

    procedure Exercice1;
    procedure Exercice2;
    procedure LoadFile;
  public
    { Déclarations publiques }
  end;

var
  FrmMain : TFrmMain;

implementation

uses
  System.IOUtils, System.StrUtils, System.Math;

const
  FILENAME : string = '.\input.txt';
  TESTS_FILENAME : string = '.\input_Tests.txt';

{$R *.dfm}

  { TFrmMain }

procedure TFrmMain.BtnExercice1Click( Sender : TObject );
begin
  Exercice1;
end;

procedure TFrmMain.BtnExercice2Click( Sender : TObject );
begin
  Exercice2;
end;

procedure TFrmMain.Exercice1;
var
  F: TArray< string >;
  LTotal: LongInt;
begin
  MmoLogs.Lines.Clear;

  F := TFile.ReadAllLines( GetInputFileName );

  LTotal := 0;

end;

procedure TFrmMain.Exercice2;
begin

end;

function TFrmMain.GetInputFileName : string;
begin
  if ChkTests.Checked then
  begin
    Result := TESTS_FILENAME;
  end
  else
  begin
    Result := FILENAME;
  end;
end;

procedure TFrmMain.LoadFile;
begin
  FFile := TFile.ReadAllLines( GetInputFileName );
end;

end.
