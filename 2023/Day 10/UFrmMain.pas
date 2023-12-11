unit UFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Generics.Defaults, System.Generics.Collections,
  Vcl.StdCtrls;

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
    FLabyrinth : TArray< TArray< char > >;
    FPath : TArray< TPoint >;
    FPos : TPoint;
    FRegion : HRGN;

    function GetInputFileName : string;
    function GetNextStep( aPos : TPoint; aSens : char ) : Integer;

    function LoadLabyrinth : TPoint;

    procedure Exercice1;
    procedure Exercice2;
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
  LTILES_NORTH : TSysCharSet = [ 'F', '|', '7' ];
  LTILES_EAST : TSysCharSet = [ '-', '7', 'J' ];
  LTILES_SOUTH : TSysCharSet = [ '|', 'L', 'J' ];
  LTILES_WEST : TSysCharSet = [ '-', 'F', 'L' ];

{$R *.dfm}
  { TFrmMain }

procedure TFrmMain.BtnExercice1Click( Sender : TObject );
begin
  Exercice1;
end;

procedure TFrmMain.BtnExercice2Click( Sender : TObject );
begin
  Exercice2
end;

procedure TFrmMain.Exercice1;
var
  LPos : TPoint;
  LSens : char;
  LDistance : Integer;
begin
  FPos := LoadLabyrinth;
  LPos := FPos;
  SetLength( FPath, 1 );
  FPath[ 0 ] := FPos;
  LSens := ' ';

  // On cherche où commence le chemin
  if ( FPos.X > 0 ) and CharInSet( FLabyrinth[ FPos.X - 1, FPos.Y ], LTILES_NORTH ) then
  begin
    LPos.X := LPos.X - 1;
    LSens := 'N';
  end
  else if ( FPos.Y < High( FLabyrinth[ FPos.X ] ) ) and CharInSet( FLabyrinth[ FPos.X, FPos.Y + 1 ], LTILES_EAST ) then
  begin
    LPos.Y := LPos.Y + 1;
    LSens := 'E';
  end
  else if ( FPos.X < High( FLabyrinth ) ) and CharInSet( FLabyrinth[ FPos.X + 1, FPos.Y ], LTILES_SOUTH ) then
  begin
    LPos.X := LPos.X + 1;
    LSens := 'S';
  end
  else if ( FPos.X > 0 ) and ( FPos.Y > 0 ) and CharInSet( FLabyrinth[ FPos.X, FPos.Y - 1 ], LTILES_WEST ) then
  begin
    LPos.Y := LPos.Y - 1;
    LSens := 'W';
  end;

  if LSens <> ' ' then
  begin
    FPath[ 0 ] := LPos;

    LDistance := GetNextStep( LPos, LSens ) + 1;

    Edt1.Text := ( LDistance div 2 ).ToString;
    Edt1.SelectAll;
    Edt1.CopyToClipboard;
  end
  else
  begin
    DeleteObject( FRegion );
  end;
end;

procedure TFrmMain.Exercice2;
var
  LPos : TPoint;
  LSens : char;
  LSomme : Integer;
begin
  FPos := LoadLabyrinth;
  LPos := FPos;
  SetLength( FPath, 1 );
  FPath[ 0 ] := FPos;
  LSens := ' ';

  // On cherche où commence le chemin
  if ( FPos.X > 0 ) and CharInSet( FLabyrinth[ FPos.X - 1, FPos.Y ], LTILES_NORTH ) then
  begin
    LPos.X := LPos.X - 1;
    LSens := 'N';
  end
  else if ( FPos.Y < High( FLabyrinth[ FPos.X ] ) ) and CharInSet( FLabyrinth[ FPos.X, FPos.Y + 1 ], LTILES_EAST ) then
  begin
    LPos.Y := LPos.Y + 1;
    LSens := 'E';
  end
  else if ( FPos.X < High( FLabyrinth ) ) and CharInSet( FLabyrinth[ FPos.X + 1, FPos.Y ], LTILES_SOUTH ) then
  begin
    LPos.X := LPos.X + 1;
    LSens := 'S';
  end
  else if ( FPos.X > 0 ) and ( FPos.Y > 0 ) and CharInSet( FLabyrinth[ FPos.X - 1, FPos.Y - 1 ], LTILES_WEST ) then
  begin
    LPos.Y := LPos.Y - 1;
    LSens := 'W';
  end;

  if LSens <> ' ' then
  begin
    FPath[ 0 ] := LPos;

    GetNextStep( LPos, LSens );

    for var i := 0 to High( FPath ) do
    begin
      FLabyrinth[ FPath[ i ].X, FPath[ i ].Y ] := '*';
    end;

    FRegion := CreatePolygonRgn( FPath[ 0 ], Length( FPath ), WINDING );
    try
      LSomme := 0;

      for var i := 0 to High( FLabyrinth ) do
      begin
        for var j := 0 to High( FLabyrinth[ i ] ) do
        begin
          if ( FLabyrinth[ i, j ] <> '*' ) then
          begin
            if PtInRegion( FRegion, i, j ) then
            begin
              FLabyrinth[ i, j ] := 'I';
              Inc( LSomme );
            end;
          end;
        end;
      end;
    finally
      DeleteObject( FRegion );
    end;

    Edt2.Text := LSomme.ToString;
    Edt2.SelectAll;
    Edt2.CopyToClipboard;
  end
  else
  begin
    Edt2.Text := 'Départ non trouvé';
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

function TFrmMain.GetNextStep( aPos : TPoint; aSens : char ) : Integer;
var
  LSens : char;
  LStep : SmallInt;
begin
  Result := 0;
  LStep := 1;
  LSens := aSens;

  if ( aPos <> FPos ) then
  begin
    case FLabyrinth[ aPos.X, aPos.Y ] of
      '|' :
        begin
          case aSens of
            'N' :
              begin
                aPos.X := aPos.X - 1;
                LSens := 'N';
              end;
            'S' :
              begin
                aPos.X := aPos.X + 1;
                LSens := 'S';
              end;
          else
            LStep := 0;
          end;
        end;
      '-' :
        begin
          case aSens of
            'W' :
              begin
                aPos.Y := aPos.Y - 1;
                LSens := 'W';
              end;
            'E' :
              begin
                aPos.Y := aPos.Y + 1;
                LSens := 'E';
              end;
          else
            LStep := 0;
          end;
        end;
      'L' :
        begin
          case aSens of
            'S' :
              begin
                aPos.Y := aPos.Y + 1;
                LSens := 'E';
              end;
            'W' :
              begin
                aPos.X := aPos.X - 1;
                LSens := 'N';
              end;
          else
            LStep := 0;
          end;
        end;
      'J' :
        begin
          case aSens of
            'S' :
              begin
                aPos.Y := aPos.Y - 1;
                LSens := 'W';
              end;
            'E' :
              begin
                aPos.X := aPos.X - 1;
                LSens := 'N';
              end;
          else
            LStep := 0;
          end;
        end;
      '7' :
        begin
          case aSens of
            'E' :
              begin
                aPos.X := aPos.X + 1;
                LSens := 'S';
              end;
            'N' :
              begin
                aPos.Y := aPos.Y - 1;
                LSens := 'W';
              end;
          else
            LStep := 0;
          end;
        end;
      'F' :
        begin
          case aSens of
            'N' :
              begin
                aPos.Y := aPos.Y + 1;
                LSens := 'E';
              end;
            'W' :
              begin
                aPos.X := aPos.X + 1;
                LSens := 'S';
              end;
          else
            LStep := 0;
          end;
        end;
      '.' :
        begin
          LStep := 0;
        end;
    end;

    if ( LStep = 1 ) then
    begin
      Result := 1 + GetNextStep( aPos, LSens );

      SetLength( FPath, Result + 1 );
      FPath[ Result ] := aPos;
    end
    Else
    begin
      Result := ( Result + 1 ) * -1;
    end;
  end
  // else
  // begin
  // SetLength( FPath, Length(FPath)+1 );
  // FPath[ High(FPath) - 1 ] := aPos;
  // end;
end;

function TFrmMain.LoadLabyrinth : TPoint;
var
  F : TArray< string >;
begin
  F := TFile.ReadAllLines( GetInputFileName );

  Result.X := 0;
  Result.Y := 0;

  SetLength( FLabyrinth, 0 );

  for var i := 0 to High( F ) do
  begin
    SetLength( FLabyrinth, Length( FLabyrinth ) + 1 );

    for var j := 1 to F[ i ].Length do
    begin
      SetLength( FLabyrinth[ i ], Length( F[ i ] ) );
      FLabyrinth[ i, j - 1 ] := F[ i ][ j ];

      if F[ i ][ j ] = 'S' then
      begin
        Result.X := i;
        Result.Y := j - 1;
      end;
    end;
  end;
end;

end.
