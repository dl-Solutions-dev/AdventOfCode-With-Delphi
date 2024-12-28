unit UFrmMain;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.Types,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  System.Generics.Defaults,
  System.Generics.Collections;

type
  TRobot = record
    StartPoint: TPointF;
    Vector: TPointF;

    function StepLength: Double;
  end;

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
    FMatrix: array [ 0 .. 100, 0 .. 102 ] of Integer;
    FRobots: TArray< TRobot >;

    function GetInputFileName: string;
    function DistanceChemin( aRobot: TRobot ): Double;
    function Sqr( aValue: Double ): Double; inline;

    procedure Exercice1;
    procedure Exercice2;
    procedure LoadFile;
    procedure LoadRobots;
    procedure InitMatrix;
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

function TFrmMain.DistanceChemin( aRobot: TRobot ): Double;
var
  LPointB: TPointF;
  LA, LB: Extended;
  LV1, LV2, LH1, LH2: TPointF;
  LStart, LEnd: TPointF;
  LDistanceParcours, LRemainingDist: Double;
  LX2, LR, LStep: TPointF;
  LT: Extended;
  LgX, LgY, LNbSeconds: Integer;
begin
  LgX := 11;
  LgY := 7;
  LNbSeconds := 100;

  LPointB := aRobot.StartPoint + aRobot.Vector;

  // Y = LA*X + LB
  LA := ( LPointB.Y - aRobot.StartPoint.Y ) / ( LPointB.X - aRobot.StartPoint.X );
  LB := aRobot.StartPoint.Y - LA * aRobot.StartPoint.X;

  // On calcul les points d'intersection de la droite suivie avec les bords de la matrice
  LR.X := ( LgX / 2 );
  LR.Y := ( LgY / 2 );

  LV1.X := 0;
  LV1.Y := LB;

  LV2.X := LgX;
  LV2.Y := LgX * LA + LB;

  LH1.X := -LB / LA;
  LH1.Y := 0;

  LH2.X := ( LgY - LB ) / LA;
  LH2.Y := LgY;

  LStart.X := -1;
  LEnd.X := -1;

  if ( LV1.Y >= 0 ) and ( LV1.Y <= LgY ) then
  begin
    LStart := LV1;
  end;

  if ( LV2.Y >= 0 ) and ( LV2.Y <= LgY ) then
  begin
    if ( LStart.X = -1 ) then
    begin
      LStart := LV2;
    end
    else
    begin
      LEnd := LV2;
    end;
  end;

  if ( LH1.X >= 0 ) and ( LH1.X <= LgX ) then
  begin
    if ( LStart.X = -1 ) then
    begin
      LStart := LH1;
    end
    else
    begin
      LEnd := LH1;
    end;
  end;

  if ( LH2.X >= 0 ) and ( LH2.X <= LgX ) then
  begin
    if ( LEnd.X = -1 ) then
    begin
      LEnd := LH2;
    end;
  end;

  // Distance parcouru par la droite dans la matrice
  LDistanceParcours := LStart.Distance( LEnd );

  // Reste à parcourir après avoir fait n tours
  LRemainingDist := FMod( ( aRobot.StepLength * LNbSeconds ), LDistanceParcours );

  // Calcul du point d'arrivée  (la formule ne doit pas être bonne)
  //
  // // Détermination du X
  // LX2.X := ( -( LA * LB - LA * LStart.Y - LStart.X ) + Sqrt( Sqr( LA * LB - LA * LStart.Y - LStart.X ) - ( 1 + Sqr( LA ) ) *
  // ( Sqr( LStart.X ) + Sqr( LB - LStart.Y ) - Sqr( LRemainingDist ) ) ) ) / ( 1 + Sqr( LA ) );
  //
  // // Détermination du y
  // LX2.Y := LA * LX2.X + LB;

  if ( aRobot.Vector.Y >= 0 ) then
  begin
    LStep := LStart;
    while LStart.Distance( LStep ) < LRemainingDist do
    begin
      LStep.X := LStep.X + aRobot.Vector.X;
      LStep.Y := LStep.Y + aRobot.Vector.Y;
    end;
  end
  else
  begin
    LStep := LEnd;
    while LStart.Distance( LStep ) < LRemainingDist do
    begin
      LStep.X := LStep.X - aRobot.Vector.X;
      LStep.Y := LStep.Y - aRobot.Vector.Y;
    end;
  end;

  FMatrix[ Trunc( LStep.X ), Trunc( LStep.Y ) ] := FMatrix[ Trunc( LStep.X ), Trunc( LStep.Y ) ] + 1;
end;

procedure TFrmMain.Exercice1;
var
  LTotal: Int64;
begin
  InitMatrix;

  LoadFile;

  SetLength( FRobots, Length( FFile ) );
  LoadRobots;

  LTotal := 0;

  for var i := 0 to High( FRobots ) do
  begin
    DistanceChemin( FRobots[ i ] );
  end;

  for var i := 0 to High( FMatrix ) do
  begin
    var
      LLg: string := '';

    for var j := 0 to High( FMatrix ) do
    begin
      if ( FMatrix[ i, j ] = 0 ) then
      begin
        LLg := LLg + '.';
      end
      else
      begin
        LLg := LLg + FMatrix[ i, j ].ToString;
      end;
    end;

    MmoLogs.Lines.Add( LLg );
  end;

  Edt1.Text := LTotal.ToString;
  Edt1.CopyToClipboard;
end;

procedure TFrmMain.Exercice2;
var
  LTotal: Int64;
  wStep: TPointF;
begin
  LoadFile;

  for var i := 0 to High( FFile ) do
  begin

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

procedure TFrmMain.InitMatrix;
begin
  for var i := 0 to 100 do
  begin
    for var j := 0 to 102 do
    begin
      FMatrix[ i, j ] := 0;
    end;
  end;
end;

procedure TFrmMain.LoadFile;
begin
  FFile := TFile.ReadAllLines( GetInputFileName );
end;

procedure TFrmMain.LoadRobots;
var
  LLine: TArray< string >;
  LCoord: TArray< string >;
begin
  for var i := 0 to High( FFile ) do
  begin
    LLine := FFile[ i ].Split( [ ' ' ] );

    // chargement position départ
    LCoord := LLine[ 0 ].Split( [ '=' ] );
    LCoord := LCoord[ 1 ].Split( [ ',' ] );
    with FRobots[ i ] do
    begin
      StartPoint.X := LCoord[ 0 ].ToInteger;
      StartPoint.Y := LCoord[ 1 ].ToInteger;
    end;

    // chargement du vecteur de déplacement
    LCoord := LLine[ 1 ].Split( [ '=' ] );
    LCoord := LCoord[ 1 ].Split( [ ',' ] );
    with FRobots[ i ] do
    begin
      Vector.X := LCoord[ 0 ].ToInteger;
      Vector.Y := LCoord[ 1 ].ToInteger;
    end;
  end;
end;

function TFrmMain.Sqr( aValue: Double ): Double;
begin
  Result := Power( aValue, 2 );
end;

{ TRobot }

function TRobot.StepLength: Double;
begin
  Result := StartPoint.Distance( StartPoint + Vector );
end;

end.
