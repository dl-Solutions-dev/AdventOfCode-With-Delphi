unit UGardianWalk;

interface

uses
  WinAPI.Windows,
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  Communs.Helpers;

type
  TGuardianWalk = class( TThread )
  private
    FRoom: TArray< string >;
    FIncLine: Integer;
    FIncCol: Integer;
    FBlocs: TArray< TPoint >;
    FWay: TArray< TArray< Char > >;

    FPath: TArray< TPoint >;
    FEndProc: TProc< Integer, TArray< string >, TArray< TPoint >, Boolean >;

    function GetCoordinates( aMatrice: TArray< string > ): TPoint;
    function Deplacer( aMatrice: TArray< string >; var aPosition: TPoint; out aIncrement: Integer; out aLoop: Boolean ): Boolean;

    procedure SetRoom( const Value: TArray< string > );
    procedure SetEndProc(
      const Value: TProc< Integer, TArray< string >, TArray< TPoint >, Boolean > );
  protected
    procedure Execute; override;
  public
    property EndProc: TProc< Integer, TArray< string >, TArray< TPoint >, Boolean > read FEndProc write SetEndProc;
    property Room: TArray< string > read FRoom write SetRoom;
  end;

implementation

{ TGuardianWalk }

function TGuardianWalk.Deplacer( aMatrice: TArray< string >; var aPosition: TPoint;
  out aIncrement: Integer; out aLoop: Boolean ): Boolean;
var
  LWay: Char;
  LTabWay: TArray< Char >;
  LInd: Integer;
begin
  Result := True;
  aLoop := False;
  aIncrement := 0;

  // Si le déplacement fait sortir de la matrice, alors on sort avec résultat False
  if ( aPosition.X + FIncLine < 0 ) or ( aPosition.X + FIncLine > High( aMatrice ) ) or ( aPosition.Y + FIncCol < 1 ) or
    ( aPosition.Y + FIncCol > Length( aMatrice[ 0 ] ) ) then
  begin
    Exit( False );
  end;

  // Tant qu'on a un obstacle devant soit, on applique le comportement :
  // On tourne toujours vers la droite par rapport à sa situation actuelle
  while ( aMatrice[ aPosition.X + FIncLine, aPosition.Y + FIncCol ] = '#' ) do
  begin
    // on définit le nouveau déplacemnt dans la matrice
    if ( FIncLine = -1 ) then
    begin
      FIncLine := 0;
      FIncCol := 1;
      LWay := 'E';
    end
    else if ( FIncCol = 1 ) then
    begin
      FIncCol := 0;
      FIncLine := 1;
      LWay := 'S';
    end
    else if ( FIncCol = 0 ) then
    begin
      if ( FIncLine = 1 ) then
      begin
        FIncLine := 0;
        FIncCol := -1;
        LWay := 'O';
      end;
    end
    else if ( FIncCol = -1 ) then
    begin
      FIncCol := 0;
      FIncLine := -1;
      LWay := 'N';
    end;

    // On mémorise l'obstacle (le block) et le sens où on va
    LInd := TArray.IndexOf< TPoint >( FBlocs, aPosition );

    if ( LInd = -1 ) then
    begin
      // Le bloc n'existait pas, on a'ajoute ainsi que le sens dans lequel on va
      TArray.Add< TPoint >( FBlocs, aPosition );
      SetLength( FWay, Length( FWay ) + 1 );
      TArray.Add< Char >( FWay[ High( FWay ) ], LWay );
    end
    else if ( TArray.IndexOf< Char >( FWay[ LInd ], LWay ) = -1 ) then
    begin
      // Si le block a déjà été mémorisé mais qu'on ne va pas dans le même sens, on ajoute ce sens
      TArray.Add< Char >( FWay[ LInd ], LWay );
    end
    else
    begin
      // Si on connait déjà ce bloc et qu'on va dans un sens déjà emprunté, alors on boucle
      aLoop := True;
      Exit( False );
    end;
  end;

  aPosition.X := aPosition.X + FIncLine;
  aPosition.Y := aPosition.Y + FIncCol;

  // Si on est pas déjà passé par cette position, on la marque dans la matrice et on la mémorise dans le chemin
  if ( aMatrice[ aPosition.X ][ aPosition.Y ] <> 'I' ) and ( aMatrice[ aPosition.X ][ aPosition.Y ] <> '^' ) then
  begin
    aMatrice[ aPosition.X ][ aPosition.Y ] := 'I';
    aIncrement := 1;

    // On ajpute le point au chemin
    TArray.Add< TPoint >( FPath, aPosition );
  end;
end;

procedure TGuardianWalk.Execute;
var
  LPosition: TPoint;
  LTotal: LongInt;
  LInc: Integer;
  LLoop: Boolean;
begin
  NameThreadForDebugging( 'ThrdWalk' );

  // On va chercher la position de départ
  LPosition := GetCoordinates( FRoom );

  SetLength( FPath, 0 );
  SetLength( FBlocs, 0 );
  SetLength( FWay, 0 );

  LTotal := 1;
  FIncLine := -1;
  FIncCol := 0;

  // Tant qu'on se déplace on incrémente le total de pas
  while Deplacer( FRoom, LPosition, LInc, LLoop ) do
  begin
    LTotal := LTotal + LInc;
  end;

  // Lorsqu'on à terminé on appel la méthode du thread principal pour envoyer les résultats
  Synchronize(
    procedure
    begin
      FEndProc( LTotal, FRoom, FPath, LLoop );
    end
    );

  SetLength( FRoom, 0 );
end;

function TGuardianWalk.GetCoordinates( aMatrice: TArray< string > ): TPoint;
var
  i, j: Integer;
begin
  for i := 0 to High( aMatrice ) do
  begin
    for j := 1 to Length( aMatrice[ i ] ) do
    begin
      if ( aMatrice[ i, j ] = '^' ) then
      begin
        Result.X := i;
        Result.Y := j;

        Exit;
      end;
    end;
  end;

end;

procedure TGuardianWalk.SetEndProc(
  const Value: TProc< Integer, TArray< string >, TArray< TPoint >, Boolean > );
begin
  FEndProc := Value;
end;

procedure TGuardianWalk.SetRoom( const Value: TArray< string > );
begin
  SetLength( FRoom, Length( Value ) );
  TArray.Copy< string >( Value, FRoom, Length( Value ) );
end;

end.
