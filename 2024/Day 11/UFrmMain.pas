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
    FFile: TArray< string >;
    FMap: TStringList;

    function GetInputFileName: string;
    function GetNbStones( var aStatus: string ): Int64;
    function CutString( aString: string ): TArray< string >;
    function GetNewMap( aStrings: TStringList ): TStringList;

    procedure Exercice1;
    procedure Exercice2;
    procedure LoadFile;
    procedure AddMap( aNumber: string );
    procedure RemoveMap( aNumber: string );
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

procedure TFrmMain.AddMap( aNumber: string );
begin
  if FMap.Values[ aNumber ] = '' then
  begin
    FMap.Values[ aNumber ] := '1';
  end
  else
  begin
    FMap.Values[ aNumber ] := ( FMap.Values[ aNumber ].ToInteger + 1 ).ToString;
  end;
end;

procedure TFrmMain.BtnExercice1Click( Sender: TObject );
begin
  Exercice1;
end;

procedure TFrmMain.BtnExercice2Click( Sender: TObject );
begin
  Exercice2;
end;

function TFrmMain.CutString( aString: string ): TArray< string >;
var
  LMid: Integer;
begin
  LMid := aString.Length div 2;

  while ( aString[ LMid ] <> ' ' ) and ( LMid < aString.Length ) do
  begin
    Inc( LMid );
  end;

  SetLength( Result, 2 );
  Result[ 0 ] := Copy( aString, 1, LMid - 1 );
  Result[ 1 ] := Copy( aString, LMid + 1 );
end;

procedure TFrmMain.Exercice1;
var
  LTotal: Int64;
  LStatus: string;
begin
  LoadFile;

  LStatus := FFile[ 0 ];

  LTotal := 0;

  for var i := 1 to 25 do
  begin
    LTotal := GetNbStones( LStatus );
  end;

  Edt1.Text := LTotal.ToString;
  Edt1.CopyToClipboard;
end;

procedure TFrmMain.Exercice2;
var
  LTotal: Int64;
  LStatus: string;
  LStrings, LResult: TArray< string >;
  LMap: TStringList;
begin
  LoadFile;

  FMap := TStringList.Create;

  LStatus := FFile[ 0 ];

  LTotal := 0;

  LStrings := LStatus.Split( [ ' ' ] );

  for var i := 0 to High( LStrings ) do
  begin
    AddMap( LStrings[ i ] );
  end;

  for var i := 0 to 75 do
  begin
    LMap := GetNewMap( FMap );

    FMap.Clear;
    FMap.AddStrings( LMap );
    FreeAndNil( LMap );
  end;
  // Faire un tableau associatif Chiffre/Nombre : nb occurrences et balayer le tableau

  // LStrings := CutString( LStatus );
  // LResult := GetNbStonesInArray( LStrings, 75 );
  //
  // LTotal := Length( LResult );

  Edt2.Text := LTotal.ToString;
  Edt2.CopyToClipboard;

  FreeAndNil( FMap );
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

function TFrmMain.GetNbStones( var aStatus: string ): Int64;
var
  LArray: TArray< string >;
begin
  LArray := aStatus.Split( [ ' ' ] );

  aStatus := '';
  Result := 0;

  for var i := 0 to High( LArray ) do
  begin
    if ( LArray[ i ] = '0' ) then
    begin
      aStatus := aStatus + '1' + ' ';
      Inc( Result );
    end
    else if ( ( LArray[ i ].Length mod 2 ) = 0 ) then
    begin
      aStatus := aStatus + Copy( LArray[ i ], 1, LArray[ i ].Length div 2 ) + ' ';
      aStatus := aStatus + Copy( LArray[ i ], ( LArray[ i ].Length div 2 ) + 1, LArray[ i ].Length ).ToInt64.ToString + ' ';
      Inc( Result, 2 );
    end
    else
    begin
      aStatus := aStatus + ( LArray[ i ].ToInt64 * 2024 ).ToString + ' ';
      Inc( Result );
    end;
  end;

  aStatus := aStatus.Trim;
end;

function TFrmMain.GetNewMap( aStrings: TStringList ): TStringList;
begin

end;

procedure TFrmMain.LoadFile;
begin
  FFile := TFile.ReadAllLines( GetInputFileName );
end;

procedure TFrmMain.RemoveMap( aNumber: string );
begin
  if ( FMap.Values[ aNumber ] <> '' ) then
  begin
    FMap.Values[ aNumber ] := ( FMap.Values[ aNumber ].ToInteger - 1 ).ToString;
  end;
end;

end.
