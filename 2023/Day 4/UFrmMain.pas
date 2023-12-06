unit UFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFrmMain = class( TForm )
    Edt1 : TEdit;
    BtnExercice1 : TButton;
    Edt2 : TEdit;
    BtnExercice2 : TButton;
    procedure BtnExercice1Click( Sender : TObject );
    procedure BtnExercice2Click( Sender : TObject );
  private
    { Déclarations privées }
    function NbNumbers( aResults : string; aGame : TArray< string > ) : Integer;

    procedure Exercice1;
    procedure Exercice2;
  public
    { Déclarations publiques }
  end;

var
  FrmMain : TFrmMain;

implementation

uses
  System.IOUtils, System.StrUtils, System.Generics.Collections;

const
  FILENAME : string = '.\input.txt';

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
  F : TArray< string >;
  LLigne : string;
  LSomme : Integer;
  LCard : TArray< string >;
  LGame : TArray< string >;
  LWorth : Single;
begin
  F := TFile.ReadAllLines( FILENAME );

  LSomme := 0;

  for var i := 0 to High( F ) do
  begin
    LCard := F[ i ].Split( [ ':', '|' ] );
    LGame := LCard[ 2 ].Split( [ ' ' ], '''', '''', TStringSplitOptions.ExcludeEmpty );
    LWorth := 0.5;
    for var j := 0 to High( LGame ) do
    begin
      if ( LGame[ j ].Length = 1 ) then
      begin
        LGame[ j ] := '  ' + LGame[ j ];
      end
      else
      begin
        LGame[ j ] := ' ' + LGame[ j ];
      end;

      if LCard[ 1 ].IndexOf( LGame[ j ], 0 ) > -1 then
      begin
        LWorth := LWorth * 2;
      end;
    end;

    LSomme := LSomme + Trunc( LWorth );
  end;

  Edt1.Text := LSomme.ToString;
end;

procedure TFrmMain.Exercice2;
var
  F : TArray< string >;
  LLigne : string;
  LSomme : Integer;
  LCards : TArray< Integer >;
  LNb : Integer;
  LCard : TArray< string >;
  LGame : TArray< string >;
begin
  F := TFile.ReadAllLines( FILENAME );

  SetLength( LCards, Length( F ) );

  LSomme := 0;

  for var i := 0 to High( F ) do
  begin
    LCards[ i ] := 1;
  end;

  for var i := 0 to High( F ) do
  begin
    LCard := F[ i ].Split( [ ':', '|' ] );
    LGame := LCard[ 2 ].Split( [ ' ' ], '''', '''', TStringSplitOptions.ExcludeEmpty );

    LNb := NbNumbers( LCard[ 1 ], LGame );

    for var j := i + 1 to i + LNb do
    begin
      LCards[ j ] := LCards[ j ] + LCards[ i ];
    end;
  end;

  LSomme := 0;
  for var i := 0 to High( LCards ) do
  begin
    LSomme := LSomme + LCards[ i ];
  end;

  Edt2.Text := LSomme.ToString;
end;

function TFrmMain.NbNumbers( aResults : string; aGame : TArray< string > ) : Integer;
begin
  Result := 0;

  for var j := 0 to High( aGame ) do
  begin
    if ( aGame[ j ].Length = 1 ) then
    begin
      aGame[ j ] := '  ' + aGame[ j ];
    end
    else
    begin
      aGame[ j ] := ' ' + aGame[ j ];
    end;

    if aResults.IndexOf( aGame[ j ], 0 ) > -1 then
    begin
      Inc( Result );
    end;
  end;
end;

end.
