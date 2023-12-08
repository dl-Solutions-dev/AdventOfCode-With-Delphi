unit UFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm3 = class( TForm )
    Edt1 : TEdit;
    BtnExercice1 : TButton;
    Edt2 : TEdit;
    BtnExercice2 : TButton;
    procedure BtnExercice1Click( Sender : TObject );
    procedure BtnExercice2Click( Sender : TObject );
  private
    { Déclarations privées }
    function GetNumberWays( aTime, aBestMillimeters : Int64 ) : Int64;

    procedure Exercice1;
    procedure Exercice2;
    procedure ExtractValuesOfLine( aLine : string; var aTab : TArray< string > );
  public
    { Déclarations publiques }
  end;

var
  Form3 : TForm3;

implementation

uses
  System.IOUtils, System.StrUtils;

const
  FILENAME : string = '.\input.txt';
  DIGITS : TSysCharSet = [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' ];

{$R *.dfm}
  { TForm3 }

procedure TForm3.BtnExercice1Click( Sender : TObject );
begin
  Exercice1;
end;

procedure TForm3.BtnExercice2Click( Sender : TObject );
begin
  Exercice2
end;

procedure TForm3.Exercice1;
var
  F : TArray< string >;
  LTab : TArray< TArray< string > >;
  LResult : Int64;
  LNbFois : Integer;
begin
  F := TFile.ReadAllLines( FILENAME );

  SetLength( LTab, 2 );
  ExtractValuesOfLine( F[ 0 ], LTab[ 0 ] );
  ExtractValuesOfLine( F[ 1 ], LTab[ 1 ] );

  LResult := 1;

  for var i := 0 to High( LTab[ 0 ] ) do
  begin
    LNbFois := GetNumberWays( LTab[ 0, i ].ToInteger, LTab[ 1, i ].ToInteger );
    if ( LNbFois > 0 ) then
    begin
      LResult := LResult * LNbFois;
    end;
  end;

  Edt1.Text := LResult.ToString;
end;

procedure TForm3.Exercice2;
var
  F : TArray< string >;
  LTab : TArray< string >;
begin
  F := TFile.ReadAllLines( FILENAME );

  SetLength( LTab, 2 );
  LTab[ 0 ] := F[ 0 ].Split( [ ':' ] )[ 1 ].Replace( ' ', '', [ rfReplaceAll ] );
  LTab[ 1 ] := F[ 1 ].Split( [ ':' ] )[ 1 ].Replace( ' ', '', [ rfReplaceAll ] );

  Edt2.Text := GetNumberWays( LTab[ 0 ].ToInt64, LTab[ 1 ].ToInt64 ).ToString;
end;

procedure TForm3.ExtractValuesOfLine( aLine : string; var aTab : TArray< string > );
var
  LLine : TArray< string >;
begin
  LLine := aLine.Split( [ ' ' ] );

  SetLength( aTab, 0 );
  for var i := 1 to High( LLine ) do
  begin
    if ( LLine[ i ].Length > 0 ) and ( CharInSet( LLine[ i ][ 1 ], DIGITS ) ) then
    begin
      SetLength( aTab, Length( aTab ) + 1 );

      aTab[ High( aTab ) ] := LLine[ i ];
    end;
  end;
end;

function TForm3.GetNumberWays( aTime, aBestMillimeters : Int64 ) : Int64;
begin
  Result := 0;
  for var i := 1 to aTime do
  begin
    if ( i - 1 ) * ( ( aTime - i ) + 1 ) > aBestMillimeters then
    begin
      Result := Result + 1;
    end;
  end;
end;

end.
