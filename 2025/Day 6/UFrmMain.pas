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

    procedure Exercice1;
    procedure Exercice2;
    procedure LoadFile;
    procedure LoadMatrix;
    procedure LoadMatrix2;
    procedure CheckColumn( aPos: Integer );
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
  Exercice1;
end;

procedure TFrmMain.BtnExercice2Click( Sender: TObject );
begin
  Exercice2;
end;

procedure TFrmMain.CheckColumn( aPos: Integer );
begin
  for var i := 1 to High( FFile ) do
  begin
    if FFile[ i ][ aPos ] <> ' ' then
    begin
      Exit;
    end;
  end;

  for var i := 0 to High( FFile ) do
  begin
    FFile[ i ][ aPos ] := '|';
  end;
end;

procedure TFrmMain.Exercice1;
var
  LTotal: Int64;
  LOpe: string;
  LCalcul: Int64;
begin
  LoadFile;
  LoadMatrix;

  LTotal := 0;

  for var i := 0 to High( FMatrix[ 0 ] ) do
  begin
    LOpe := FMatrix[ High( FMatrix ), i ];
    LCalcul := FMatrix[ High( FMatrix ) - 1, i ].ToInt64;

    for var j := High( FMatrix ) - 2 downto 0 do
    begin
      if ( LOpe = '+' ) then
      begin
        LCalcul := LCalcul + FMatrix[ j, i ].ToInteger;
      end
      else
      begin
        LCalcul := LCalcul * FMatrix[ j, i ].ToInteger;
      end;
    end;

    LTotal := LTotal + LCalcul;
  end;

  Edt1.Text := LTotal.ToString;
  Edt1.CopyToClipboard;
end;

procedure TFrmMain.Exercice2;
var
  LTotal: Int64;
  LOpe: string;
  LNumber: string;
  LCalcul: Int64;
begin
  LoadFile;
  LoadMatrix2;

  LTotal := 0;

  for var i := 0 to High( FMatrix[ 0 ] ) do
  begin
    LOpe := FMatrix[ High( FMatrix ), i ].Trim;

    LCalcul := -1;
    for var k := 1 to Length( FMatrix[ 0, i ] ) do
    begin
      LNumber := '';
      for var j := 0 to High( FMatrix ) - 1 do
      begin
        LNumber := LNumber + FMatrix[ j, i ][ k ];
      end;
      if ( LCalcul = -1 ) then
      begin
        LCalcul := LNumber.Trim.ToInt64;
      end
      else
      begin
        if ( LOpe = '*' ) then
        begin
          LCalcul := LCalcul * LNumber.Trim.ToInt64;
        end
        else
        begin
          LCalcul := LCalcul + LNumber.Trim.ToInt64;
        end;
      end;
    end;

    LTotal := LTotal + LCalcul;
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
var
  LCol, LLength: Integer;
begin
  SetLength( FMatrix, Length( FFile ), 0 );

  for var i := 0 to High( FFile ) do
  begin
    FMatrix[ i ] := FFile[ i ].Trim.Split( [ ' ' ] );
  end;

  for var i := 0 to High( FMatrix ) do
  begin
    LCol := 0;
    while LCol < High( FMatrix[ i ] ) do
    begin
      if ( FMatrix[ i, LCol ].Trim = '' ) then
      begin
        FMatrix[ i ] := TArray.Extract<string>( FMatrix[ i, LCol ], FMatrix[ i ] );
      end
      else
      begin
        Inc( LCol );
      end;
    end;
  end;

  LLength := Length( FMatrix[ 0 ] );

  for var i := 1 to High( FMatrix ) do
  begin
    if ( Length( FMatrix[ i ] ) <> LLength ) then
    begin
      ShowMessage( 'La ligne ' + i.ToString + ' n''a pas le même nombre d''éléments' );
    end;
  end;
end;

procedure TFrmMain.LoadMatrix2;
begin
  SetLength( FMatrix, Length( FFile ), 0 );

  for var j := 1 to High( FFile[ 0 ] ) do
  begin
    if FFile[ 0 ][ j ] = ' ' then
    begin
      CheckColumn( j );
    end;
  end;

  for var i := 0 to High( FFile ) do
  begin
    FMatrix[ i ] := FFile[ i ].Split( [ '|' ] );
  end;
end;

end.

