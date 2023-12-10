unit UFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Generics.Collections;

type
  TFrmMain = class( TForm )
    Edt1 : TEdit;
    BtnExercice1 : TButton;
    Edt2 : TEdit;
    BtnExercice2 : TButton;
    ChkTests : TCheckBox;
    procedure BtnExercice1Click( Sender : TObject );
    procedure BtnExercice2Click( Sender : TObject );
  private
    { Déclarations privées }
    FMap : TObjectDictionary< string, TArray< string > >;
    FWay : TArray< SmallInt >;

    function GetInputFileName : string;
    function RunWay( aStart : string ) : UInt64;
    function PGCD( a, b : UInt64 ) : UInt64;
    function PPCM( a, b : UInt64 ) : UInt64;

    procedure Exercice1;
    procedure Exercice2;
    procedure InitializeMap;
  public
    { Déclarations publiques }
  end;

var
  FrmMain : TFrmMain;

implementation

uses
  System.IOUtils, System.StrUtils, System.Generics.Defaults, System.Math;

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
  LSomme : UInt64;
  LStep : string;
  Ind : SmallInt;
begin
  try
    InitializeMap;

    LSomme := 0;
    LStep := 'AAA';
    Ind := 0;
    while ( LStep <> 'ZZZ' ) do
    begin
      LStep := FMap[ LStep ][ FWay[ Ind ] ];

      Inc( LSomme );

      Inc( Ind );
      if ( Ind > High( FWay ) ) then
      begin
        Ind := 0;
      end;
    end;

    Edt1.Text := LSomme.ToString;
    Edt1.SelectAll;
    Edt1.CopyToClipboard;
  finally
    FreeAndNil( FMap );
  end;
end;

procedure TFrmMain.Exercice2;
var
  LPair : TPair< string, TArray< string > >;
  LSomme : UInt64;
begin
  try
    InitializeMap;

    LSomme := 1;
    for LPair in FMap do
    begin
      if LPair.Key[ 3 ] = 'A' then
      begin
        LSomme := PPCM( LSomme, RunWay( LPair.Key ) );
      end;
    end;

    Edt2.Text := LSomme.ToString;
    Edt2.SelectAll;
    Edt2.CopyToClipboard;
  finally
    FreeAndNil( FMap );
  end;
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

procedure TFrmMain.InitializeMap;
var
  F : TArray< string >;
  LStep : string;
  LNode : TArray< string >;
  LLine : TArray< string >;
  LArray : TArray< string >;
begin
  F := TFile.ReadAllLines( GetInputFileName );

  FMap := TObjectDictionary< string, TArray< string > >.Create;

  LStep := '';

  for var i := 0 to High( F ) do
  begin
    if ( i > 0 ) and ( F[ i ] <> '' ) then
    begin
      LNode := F[ i ].Split( [ ' = ' ] );

      LLine := LNode[ 1 ].Replace( '(', '', [ ] ).Replace( ')', '', [ ] ).Replace( ' ', '', [ ] ).Split( [ ',' ] );

      LArray := TArray< string >.Create( LLine[ 0 ], LLine[ 1 ] );

      FMap.Add( LNode[ 0 ], LArray );
    end
    else
    begin
      SetLength( FWay, 0 );

      for var j := 1 to F[ 0 ].Length do
      begin
        SetLength( FWay, Length( FWay ) + 1 );

        if ( F[ 0 ][ j ] = 'L' ) then
        begin
          FWay[ high( FWay ) ] := 0;
        end
        else
        begin
          FWay[ high( FWay ) ] := 1;
        end;
      end;
    end;
  end;
end;

function TFrmMain.RunWay( aStart : string ) : UInt64;
var
  LStep : string;
  Ind : Integer;
begin
  Result := 0;
  LStep := aStart;
  Ind := 0;
  while ( LStep[ 3 ] <> 'Z' ) do
  begin
    LStep := FMap[ LStep ][ FWay[ Ind ] ];

    Inc( Result );

    Inc( Ind );
    if ( Ind > High( FWay ) ) then
    begin
      Ind := 0;
    end;
  end;
end;

function TFrmMain.PGCD( a, b : UInt64 ) : UInt64;
var
  LGreatest : UInt64;
  LLowest : UInt64;
  LRemainder : UInt64;
begin
  if ( a > b ) then
  begin
    LGreatest := a;
    LLowest := b;
  end
  else
  begin
    LGreatest := b;
    LLowest := a;
  end;

  Result := LLowest;

  LRemainder := LLowest;
  while ( LRemainder <> 0 ) do
  begin
    Result := LRemainder;
    LRemainder := ( LGreatest mod LLowest );
    LGreatest := LLowest;
    LLowest := LRemainder;
  end;
end;

function TFrmMain.PPCM( a, b : UInt64 ) : UInt64;
begin
  Result := ( a * b ) div PGCD( a, b );
end;

end.
