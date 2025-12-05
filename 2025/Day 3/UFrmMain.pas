unit UFrmMain;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  System.Generics.Defaults,
  System.Generics.Collections;

type
  TFrmMain = class( TForm )
    Edt1: TEdit;
    BtnExercice1: TButton;
    Edt2: TEdit;
    BtnExercice2: TButton;
    ChkTests: TCheckBox;
    MmoLogs: TMemo;

    procedure BtnExercice1Click( Sender: TObject );
    procedure BtnExercice2Click( Sender: TObject );
  private
    { Déclarations privées }
    FFile: TArray<string>;
    FMatrix: TArray<TArray<string>>;

    function GetInputFileName: string;
    function MaxJoltage( aBank: Integer ): Int64;

    procedure Exercice1;
    procedure Exercice2;
    procedure LoadFile;
    procedure LoadMatrix;
  public
    { Déclarations publiques }
  end;

var
  FrmMain: TFrmMain;

implementation

uses
  System.IOUtils,
  System.StrUtils,
  System.Math;

const
  FILENAME: string = '.\input.txt';
  TESTS_FILENAME: string = '.\input_Tests.txt';

{$R *.dfm}

  { TFrmMain }

procedure TFrmMain.BtnExercice1Click( Sender: TObject );
begin
  Exercice1;
end;

procedure TFrmMain.BtnExercice2Click( Sender: TObject );
begin
  Exercice2;
end;

procedure TFrmMain.Exercice1;
var
  LTotal: Int64;
begin
  LoadFile;
  LoadMatrix;

  LTotal := 0;

  for var i := 0 to High( FMatrix ) do
  begin
    LTotal := LTotal + MaxJoltage( i );
  end;


  Edt1.Text := LTotal.ToString;
  Edt1.CopyToClipboard;
end;

procedure TFrmMain.Exercice2;
var
  LTotal: Int64;
begin
  LoadFile;
  LoadMatrix;

  LTotal := 0;

  for var i := 0 to High( FMatrix ) do
  begin

  end;

  Edt2.Text := LTotal.ToString;
  Edt2.CopyToClipboard;
end;

function TFrmMain.GetInputFileName: string;
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

procedure TFrmMain.LoadMatrix;
begin
  SetLength( FMatrix, Length( FFile ), Length( FFile[ 0 ] ) );

  for var i := 0 to High( FFile ) do
  begin
    for var j := 1 to Length( FFile[ i ] ) do
    begin
      FMatrix[ i, j - 1 ] := FFile[ i, j ];
    end;
  end;
end;

function TFrmMain.MaxJoltage( aBank: Integer ): Int64;
var
  LMax: Int64;
  LDigit1, LDigit2, LJoltage: string;
begin
  LMax := 0;

  for var i := 0 to High( FMatrix[ aBank ] ) do
  begin
    LDigit1 := FMatrix[ aBank, i ];
    LDigit2 := '';

    for var j := i + 1 to High( FMatrix[ aBank ] ) do
    begin
      if FMatrix[ aBank, j ] <> LDigit2 then
      begin
        LDigit2 := FMatrix[ aBank, j ];

        LJoltage := LDigit1 + LDigit2;

        if LJoltage.ToInteger > LMax then
        begin
          LMax := LJoltage.ToInteger;
        end;
      end;
    end;
  end;

  Result := LMax;
end;

end.

