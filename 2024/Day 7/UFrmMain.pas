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
    FOperandes: TArray< Int64 >;

    function GetInputFileName: string;
    function GetResultat( aResult: Int64; aOperandes: string; aBase: string ): Int64;
    function Compute( aIndice: Integer; aOperateurs: string; aFusion: Boolean = False ): Int64;

    procedure Exercice1;
    procedure Exercice2;
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


function ConversionIntToBase( Value: Int64; Base: string ): string;
var
  BaseLen: Integer;
  pResult: PChar;
begin
  BaseLen := Length( Base );
  if BaseLen >= 0 then
  begin
    if Value >= BaseLen then
    begin
      SetLength( Result, Floor( LogN( BaseLen, Value ) ) + 1 );
      pResult := @Result[ Length( Result ) ];

      while Value > 0 do
      begin
        pResult^ := Base[ Value mod BaseLen + 1 ];
        Value := Value div BaseLen;
        Dec( pResult );
      end;
    end
    else
      Result := Base[ Value + 1 ];
  end
  else
    Result := '';
end;

{ TFrmMain }

procedure TFrmMain.BtnExercice1Click( Sender: TObject );
begin
  Exercice1;
end;

procedure TFrmMain.BtnExercice2Click( Sender: TObject );
begin
  Exercice2;
end;

function TFrmMain.Compute( aIndice: Integer;
  aOperateurs: string; aFusion: Boolean = False ): Int64;
begin
  if aIndice > 0 then
  begin
    if aOperateurs[ aIndice ] = '0' then
    begin
      Result := FOperandes[ aIndice ] + Compute( aIndice - 1, aOperateurs );
    end
    else if aOperateurs[ aIndice ] = '1' then
    begin
      Result := FOperandes[ aIndice ] * Compute( aIndice - 1, aOperateurs );
    end
    else
    begin
      Result := Trunc( IntPower( 10, Length( FOperandes[ aIndice ].ToString ) ) ) * Compute( aIndice - 1, aOperateurs ) + FOperandes[ aIndice ];
    end;
  end
  else
  begin
    Result := FOperandes[ 0 ];
  end;
end;

procedure TFrmMain.Exercice1;
var
  F, L: TArray< string >;
  LTotal: Int64;
begin
  F := TFile.ReadAllLines( GetInputFileName );

  LTotal := 0;

  for var i := 0 to High( F ) do
  begin
    L := F[ i ].Split( [ ':' ] );

    LTotal := LTotal + GetResultat( L[ 0 ].ToInt64, L[ 1 ].Trim, '01' );
  end;

  Edt1.Text := LTotal.ToString;
  Edt1.CopyToClipboard;
end;

procedure TFrmMain.Exercice2;
var
  F, F2, L: TArray< string >;
  LTotal, LResult: Int64;
begin
  MmoLogs.Lines.Clear;

  F := TFile.ReadAllLines( GetInputFileName );

  SetLength( F2, 0 );

  LTotal := 0;

  // On refait la partie de l'exercice 1 pour enlever les lignes résolues
  // avec les 2 seuls opérateurs, ça fait fondre al liste
  for var i := 0 to High( F ) do
  begin
    L := F[ i ].Split( [ ':' ] );

    LResult := GetResultat( L[ 0 ].ToInt64, L[ 1 ].Trim, '01' );

    if ( LResult = 0 ) then
    begin
      SetLength( F2, Length( F2 ) + 1 );
      F2[ High( F2 ) ] := F[ i ];
    end;

    LTotal := LTotal + LResult;
  end;

  MmoLogs.Lines.Add( Length( F ).ToString + ' -> ' + Length( F2 ).ToString );

  // On reprend la liste apurées pour appliquer le nouvel opérateur
  for var i := 0 to High( F2 ) do
  begin
    L := F2[ i ].Split( [ ':' ] );

    LResult := GetResultat( L[ 0 ].ToInt64, L[ 1 ].Trim, '012' );

    LTotal := LTotal + LResult;
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

function TFrmMain.GetResultat( aResult: Int64; aOperandes: string; aBase: string ): Int64;
var
  LOperandes: TArray< string >;
  LGuess: Integer;
  wOpe, wOpeBin: string;
  wResult: Int64;
begin
  LOperandes := aOperandes.Split( [ ' ' ] );

  SetLength( FOperandes, Length( LOperandes ) );

  for var i := 0 to High( LOperandes ) do
  begin
    FOperandes[ i ] := LOperandes[ i ].ToInteger;
  end;

  MmoLogs.Lines.Add( aOperandes );

  LGuess := -1;
  repeat
    Inc( LGuess );

    wOpe := ConversionIntToBase( LGuess, aBase );
    wOpeBin := DupeString( '0', Length( FOperandes ) - 1 - Length( wOpe ) ) + wOpe;

    wResult := Compute( High( FOperandes ), wOpeBin );
  until ( wResult = aResult ) or ( wOpeBin = DupeString( '1', Length( FOperandes ) ) );

  if ( wResult = aResult ) then
  begin
    Result := wResult;
  end
  else
  begin
    Result := 0;
  end;
end;

end.
