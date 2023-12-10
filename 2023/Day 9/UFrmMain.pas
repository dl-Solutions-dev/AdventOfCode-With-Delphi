unit UFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.Generics.Defaults, System.Generics.Collections;

type
  TForm4 = class( TForm )
    Edt1 : TEdit;
    BtnExercice1 : TButton;
    Edt2 : TEdit;
    BtnExercice2 : TButton;
    ChkTests : TCheckBox;
    procedure BtnExercice1Click( Sender : TObject );
    procedure BtnExercice2Click( Sender : TObject );
  private
    { Déclarations privées }
    function GetInputFileName : string;
    function AddTable( var aTable : TArray< int64 > ) : int64;

    procedure Exercice1;
    procedure Exercice2;
  public
    { Déclarations publiques }
  end;

var
  Form4 : TForm4;

implementation

uses
  System.IOUtils, System.StrUtils, System.Math;

const
  FILENAME : string = '.\input.txt';
  TESTS_FILENAME : string = '.\input_Tests.txt';

{$R *.dfm}
  { TForm4 }

function TForm4.AddTable( var aTable : TArray< int64 > ) : int64;
var
  LArray : TArray< int64 >;
  LIsLineZero : Boolean;
begin
  SetLength( LArray, 0 );

  LIsLineZero := True;

  for var i := 0 to High( aTable ) - 1 do
  begin
    SetLength( LArray, Length( LArray ) + 1 );
    LArray[ High( LArray ) ] := ( aTable[ i + 1 ] - aTable[ i ] );
    LIsLineZero := LIsLineZero and ( aTable[ i ] = 0 );
  end;

  if not( LIsLineZero ) then
  begin
    Result := aTable[ high( aTable ) ] + AddTable( LArray );
  end
  else
  begin
    Result := aTable[ high( aTable ) ];
  end;
end;

procedure TForm4.BtnExercice1Click( Sender : TObject );
begin
  Exercice1;
end;

procedure TForm4.BtnExercice2Click( Sender : TObject );
begin
  Exercice2;
end;

procedure TForm4.Exercice1;
var
  F : TArray< string >;
  LSuite : TArray< string >;
  LTable : TArray< int64 >;
  LSomme : int64;
begin
  F := TFile.ReadAllLines( GetInputFileName );

  LSomme := 0;
  for var i := 0 to High( F ) do
  begin
    LSuite := F[ i ].Split( [ ' ' ] );

    SetLength( LTable, Length( LSuite ) );
    for var j := 0 to High( LSuite ) do
    begin
      LTable[ j ] := LSuite[ j ].toInt64;
    end;

    LSomme := LSomme + AddTable( LTable );
  end;

  Edt1.Text := LSomme.ToString;
  Edt1.SelectAll;
  Edt1.CopyToClipboard;
end;

procedure TForm4.Exercice2;
var
  F : TArray< string >;
  LSuite : TArray< string >;
  LTable : TArray< int64 >;
  LSomme : int64;
  LInd : smallint;
begin
  F := TFile.ReadAllLines( GetInputFileName );

  LSomme := 0;
  for var i := 0 to High( F ) do
  begin
    LSuite := F[ i ].Split( [ ' ' ] );

    SetLength( LTable, Length( LSuite ) );
    LInd := 0;
    for var j := High( LSuite ) downto 0 do
    begin
      LTable[ LInd ] := LSuite[ j ].toInt64;
      Inc( LInd );
    end;

    LSomme := LSomme + AddTable( LTable );
  end;

  Edt2.Text := LSomme.ToString;
  Edt2.SelectAll;
  Edt2.CopyToClipboard;
end;

function TForm4.GetInputFileName : string;
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

end.
