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
    FFile1: TArray< string >;

    function GetInputFileName: string;
    function GetNbAntiNodes: Integer;

    procedure MarkAntiNodes( aPoint: TPoint; aAntenna: string );
    procedure MarkAntiNodesPart2( aPoint: TPoint; aAntenna: string );
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
  LTotal: Integer;
  wPoint: TPoint;
begin
  LoadFile;

  LTotal := 0;

  for var i := 0 to High( FFile ) do
  begin
    for var j := 1 to Length( FFile[ i ] ) do
    begin
      if ( FFile[ i, j ] <> '.' ) then
      begin
        wPoint.X := i;
        wPoint.Y := j - 1; // Commence à 1

        MarkAntiNodes( wPoint, FFile[ i, j ] );
      end;
    end;
  end;

  LTotal := GetNbAntiNodes;

  TFile.WriteAllLines( '.\Result.txt', FFile1 );

  Edt1.Text := LTotal.ToString;
  Edt1.CopyToClipboard;
end;

procedure TFrmMain.Exercice2;
var
  LTotal: Integer;
  wPoint: TPoint;
begin
  LoadFile;

  LTotal := 0;

  for var i := 0 to High( FFile ) do
  begin
    for var j := 1 to Length( FFile[ i ] ) do
    begin
      if ( FFile[ i, j ] <> '.' ) then
      begin
        wPoint.X := i;
        wPoint.Y := j - 1; // Commence à 1

        MarkAntiNodesPart2( wPoint, FFile[ i, j ] );
      end;
    end;
  end;

  LTotal := GetNbAntiNodes;

  TFile.WriteAllLines( '.\Result.txt', FFile1 );

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

function TFrmMain.GetNbAntiNodes: Integer;
begin
  Result := 0;

  for var i := 0 to High( FFile1 ) do
  begin
    for var j := 1 to Length( FFile1[ i ] ) do
    begin
      if FFile1[ i, j ] = '#' then
      begin
        Inc( Result );

        MmoLogs.Lines.Add( i.ToString + ', ' + j.ToString );
      end;
    end;
  end;
end;

procedure TFrmMain.LoadFile;
begin
  FFile := TFile.ReadAllLines( GetInputFileName );
  FFile1 := TFile.ReadAllLines( GetInputFileName );
end;

procedure TFrmMain.MarkAntiNodes( aPoint: TPoint; aAntenna: string );
var
  wPoint: TPoint;
  wN: TPoint;
begin
  for var i := aPoint.X to High( FFile ) do
  begin
    for var j := 1 to Length( FFile[ i ] ) do
    begin
      wPoint.X := i;
      wPoint.Y := j - 1;

      // Si on trouve une seconde antenne
      if ( FFile[ i, j ] = aAntenna ) and ( wPoint <> aPoint ) then
      begin
        // On calcul les coordonnées de l'antinode au dessus
        wN := aPoint - ( wPoint - aPoint );

        // Si les coordonnées sont dans la matrice, on marque l'antinode (#)
        // sur la copie dela matrice
        if ( wN.X >= 0 ) and ( wN.Y >= 0 ) and ( wN.Y < Length( FFile[ i ] ) ) then
        begin
          FFile1[ wN.X, wN.Y + 1 ] := '#';
        end;

        // On calcul les coordonnées de l'antinode en dessous
        wN := wPoint + ( wPoint - aPoint );

        MmoLogs.Lines.Add( wN.X.ToString + ', ' + wN.Y.ToString );

        // Si les coordonnées sont dans la matrice, on marque l'antinode (#)
        // sur la copie dela matrice
        if ( wN.X >= 0 ) and ( wN.X <= High( FFile ) ) and ( wN.Y >= 0 ) and ( wN.Y < Length( FFile[ i ] ) ) then
        begin
          FFile1[ wN.X, wN.Y + 1 ] := '#';
        end;
      end;
    end;
  end;
end;

procedure TFrmMain.MarkAntiNodesPart2( aPoint: TPoint; aAntenna: string );
var
  wPoint: TPoint;
  wN: TPoint;
  wExit: Boolean;
begin
  for var i := aPoint.X to High( FFile ) do
  begin
    for var j := 1 to Length( FFile[ i ] ) do
    begin
      wPoint.X := i;
      wPoint.Y := j - 1;

      // Si on trouve une seconde antenne
      if ( FFile[ i, j ] = aAntenna ) and ( wPoint <> aPoint ) then
      begin
        // Quelque soit la distance, donc les antennes sont également remplacées
        FFile1[ wPoint.X, wPoint.Y + 1 ] := '#';
        FFile1[ aPoint.X, aPoint.Y + 1 ] := '#';

        wExit := False;
        wN := aPoint;

        while not( wExit ) do
        begin
          // On calcul les coordonnées de l'antinode au dessus
          wN := wN - ( wPoint - aPoint );

          // Si les coordonnées sont dans la matrice, on marque l'antinode (#)
          // sur la copie dela matrice
          if ( wN.X >= 0 ) and ( wN.Y >= 0 ) and ( wN.Y < Length( FFile[ i ] ) ) then
          begin
            FFile1[ wN.X, wN.Y + 1 ] := '#';
          end
          else
          begin
            wExit := True;
          end;
        end;

        wExit := False;
        wN := aPoint;

        while not( wExit ) do
        begin
          // On calcul les coordonnées de l'antinode en dessous
          wN := wN + ( wPoint - aPoint );

          // MmoLogs.lines.Add( wN.X.ToString + ', ' + wN.Y.ToString );

          // Si les coordonnées sont dans la matrice, on marque l'antinode (#)
          // sur la copie dela matrice
          if ( wN.X >= 0 ) and ( wN.X <= High( FFile ) ) and ( wN.Y >= 0 ) and ( wN.Y < Length( FFile[ i ] ) ) then
          begin
            FFile1[ wN.X, wN.Y + 1 ] := '#';
          end
          else
          begin
            wExit := True;
          end;
        end;
      end;
    end;
  end;
end;

end.
