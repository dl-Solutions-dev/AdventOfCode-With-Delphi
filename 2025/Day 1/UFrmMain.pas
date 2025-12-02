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

    function GetInputFileName: string;

    procedure Exercice1;
    procedure Exercice2;
    procedure LoadFile;
  public
    { Déclarations publiques }
  end;

var
  FrmMain: TFrmMain;

implementation

uses
  System.IOUtils,
  System.StrUtils,
  System.Math,
  Communs.Helpers;

const
  FILENAME: string = '.\input.txt';
  TESTS_FILENAME: string = '.\input_Tests.txt';

{$R *.dfm}

  { TFrmMain }

procedure TFrmMain.BtnExercice1Click( Sender: TObject );
begin
  Exercice1; // 234 pas assez
end;

procedure TFrmMain.BtnExercice2Click( Sender: TObject );
begin
  Exercice2;
end;

procedure TFrmMain.Exercice1;
var
  LTotal: Integer;
  LPosition: Integer;
  LSens: string;
  LNb: SmallInt;
  LResult: TArray<string>;
begin
  LoadFile;

  LTotal := 0;
  LPosition := 50;

  TArray.Add<string>( LResult, 'Start -> 50' );

  for var i := 0 to High( FFile ) do
  begin
    LSens := FFile[ i ][ 1 ];
    LNb := FFile[ i ].Substring( 1 ).ToInteger;

    if ( LSens = 'L' ) then
    begin
      LPosition := LPosition - LNb;
    end
    else
    begin
      LPosition := LPosition + LNb;
    end;

    LPosition := ( LPosition + 100 ) mod 100;

    if ( LPosition = 0 ) then
    begin
      Inc( LTotal );
      TArray.Add<string>( LResult, FFile[ i ] + ' -> ' + LPosition.ToString + '***' );
    end
    else
    begin
      TArray.Add<string>( LResult, FFile[ i ] + ' -> ' + LPosition.ToString );
    end;
  end;

  TFile.WriteAllLines( ExtractFilePath( ParamStr( 0 ) ) + 'Result.txt', LResult );

  Edt1.Text := LTotal.ToString;
  Edt1.CopyToClipboard;
end;

procedure TFrmMain.Exercice2;
var
  LTotal: Int64;
  LPosition: Integer;
  LSens: string;
  LNb: SmallInt;
  LResult: TArray<string>;
begin
  LoadFile;

  LTotal := 0;
  LPosition := 50;

  TArray.Add<string>( LResult, 'Start -> 50' );

  for var i := 0 to High( FFile ) do
  begin
    LSens := FFile[ i ][ 1 ];
    LNb := FFile[ i ].Substring( 1 ).ToInteger;

    for var j := 1 to LNb do
    begin
      if ( LSens = 'L' ) then
      begin
        LPosition := ( LPosition - 1 ) mod 100;
      end
      else
      begin
        LPosition := ( LPosition + 1 ) mod 100;
      end;

      if ( LPosition = 0 ) then
      begin
        Inc( LTotal );

        TArray.Add<string>( LResult, 'Total = ' + LTotal.ToString );
      end;

      TArray.Add<string>( LResult, FFile[ i ] + ' -> ' + LPosition.ToString );
    end;
  end;

  TFile.WriteAllLines( ExtractFilePath( ParamStr( 0 ) ) + 'Result.txt', LResult );

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

end.

