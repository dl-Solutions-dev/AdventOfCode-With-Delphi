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
    procedure BtnExercice1Click( Sender : TObject );
    procedure BtnExercice2Click( Sender : TObject );
  private
    { Déclarations privées }
    FFile : TArray< string >;
    FMap : TArray< TArray< string > >;
    FNbGalaxies : Integer;
    FListeGalaxies : TArray< TPoint >;

    function GetInputFileName : string;
    procedure Exercice1;
    procedure Exercice2;
    procedure LoadFile;
    procedure ChargerMap( aCoef : Integer );
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
  GALAXY : string = '#';
  EMPTY_SPACE : string = '.';

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

procedure TFrmMain.ChargerMap( aCoef : Integer );
var
  LGalaxyFound : Boolean;
  LNBEmptyLine : Integer;
  LNBEmptyColmun : Integer;
  LGalaxy : Integer;
begin
  LoadFile;

  SetLength( FMap, Length( FFile ) );

  FNbGalaxies := 0;
  LNBEmptyLine := 0;

  for var i := 0 to High( FFile ) do
  begin
    SetLength( FMap[ i ], FFile[ i ].Length );

    for var j := 1 to FFile[ i ].Length do
    begin
      FMap[ i, j - 1 ] := FFile[ i ][ j ];
    end;
  end;

  // On va charge la map virtuellement
  SetLength( FMap, Length( FFile ) );
  SetLength( FListeGalaxies, 0 );

  for var i := 0 to High( FFile ) do
  begin
    SetLength( FMap[ i ], FFile[ i ].Length );
    LGalaxyFound := False;

    for var j := 1 to FFile[ i ].Length do
    begin
      if FFile[ i ][ j ] = GALAXY then
      begin
        Inc( FNbGalaxies );
        LGalaxyFound := True;

        // On ajoute les coorddonnées de la galaxie
        SetLength( FListeGalaxies, Length( FListeGalaxies ) + 1 );
        FListeGalaxies[ High( FListeGalaxies ) ].X := i + ( LNBEmptyLine * aCoef ); // On ajoute les lignes crées (* par un coef en paramètre)
        FListeGalaxies[ High( FListeGalaxies ) ].Y := j;

        FMap[ i, j - 1 ] := Length( FListeGalaxies ).ToString;
      end
      else
      begin
        FMap[ i, j - 1 ] := FFile[ i ][ j ];
      end;
    end;

    // Si on a pas trouvé de galaxy sur la ligne, alors on incrémente le nombre de lignes sans galaxy
    if not( LGalaxyFound ) then
    begin
      Inc( LNBEmptyLine );
    end;
  end;

  // On va chercher les colonnes sans galaxy
  LNBEmptyColmun := 0;

  if ( Length( FMap ) > 0 ) then
  begin
    for var j := 0 to High( FMap[ 0 ] ) do
    begin
      LGalaxyFound := False;
      for var i := 0 to High( FMap ) do
      begin
        if FMap[ i, j ] <> EMPTY_SPACE then
        begin
          LGalaxyFound := True;
          LGalaxy := FMap[ i, j ].ToInteger;
          FListeGalaxies[ LGalaxy-1 ].Y := FListeGalaxies[ LGalaxy-1 ].Y + ( LNBEmptyColmun * aCoef );  // On ajoute le nombre de colonnes sans gaglaxy (* par un coef passé en paramètre)
        end;
      end;

      // Si on a pas trouvé de galaxy sur la colonne, alors on incrémente le nombre de colonnes sans galaxy
      if not( LGalaxyFound ) then
      begin
        Inc( LNBEmptyColmun );
      end;
    end;
  end;
end;

procedure TFrmMain.Exercice1;
var
  LSomme : Integer;
begin
  ChargerMap( 1 );

  LSomme := 0;

  // On calcul la distance des lignes entre chaque galaxy
  for var i := 0 to High( FListeGalaxies ) do
  begin
    for var j := i + 1 to High( FListeGalaxies ) do
    begin
      LSomme := LSomme + ( Abs( FListeGalaxies[ j ].X - FListeGalaxies[ i ].X ) + Abs( FListeGalaxies[ j ].Y - FListeGalaxies[ i ].Y ) );
    end;
  end;

  Edt1.Text := LSomme.ToString;
  Edt1.SelectAll;
  Edt1.CopyToClipboard;
end;

procedure TFrmMain.Exercice2;
var
  LSomme : Int64;
begin
  ChargerMap( 999999 );

  LSomme := 0;

  // On calcul la distance des lignes entre chaque galaxy
  for var i := 0 to High( FListeGalaxies ) do
  begin
    for var j := i + 1 to High( FListeGalaxies ) do
    begin
      LSomme := LSomme + ( Abs( FListeGalaxies[ j ].X - FListeGalaxies[ i ].X ) + Abs( FListeGalaxies[ j ].Y - FListeGalaxies[ i ].Y ) );
    end;
  end;

  Edt2.Text := LSomme.ToString;
  Edt2.SelectAll;
  Edt2.CopyToClipboard;
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
