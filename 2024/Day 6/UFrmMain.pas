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
    FIncLine: Integer;
    FIncCol: Integer;
    FMatrice: TArray< TArray< string > >;
    FBlocs: TArray< TPoint >;

    function GetInputFileName: string;
    function GetCoordinates( aMatrice: TArray< string > ): TPoint;
    function Deplacer( aMatrice: TArray< string >; var aPosition: TPoint; out aIncrement: Integer ): Boolean;
    function Boucle( aIndice: Integer ): Integer;

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

function TFrmMain.Boucle( aIndice: Integer ): Integer;
var
  wPoint, wCurseur: TPoint;
begin
  Result := 0;

  wPoint := FBlocs[ aIndice ];

  if ( wPoint.X >= 0 ) then
  begin
    wCurseur := wPoint;
    wCurseur.X := wCurseur.X - 1;
    while ( wCurseur.X >= 0 ) and ( FMatrice[ wCurseur.X, wCurseur.Y ] = '.' ) do
    begin
      wCurseur.X := wCurseur.X - 1;
    end;

    if ( wPoint.X >= 0 ) and ( FMatrice[ wCurseur.X, wCurseur.Y ] <> '#' ) and
      ( FMatrice[ wCurseur.X, wCurseur.Y ].ToInteger > ( FMatrice[ wPoint.X, wPoint.Y ].ToInteger + 1 ) ) then
    begin
      Inc( Result );
    end;
  end;

  if ( wPoint.X <= high( FMatrice ) ) then
  begin
    wCurseur := wPoint;
    wCurseur.X := wCurseur.X + 1;
    while ( wPoint.X <= high( FMatrice ) ) and ( FMatrice[ wCurseur.X, wCurseur.Y ] = '.' ) do
    begin
      wCurseur.X := wCurseur.X + 1;
    end;

    if ( wPoint.X <= high( FMatrice ) ) and ( FMatrice[ wCurseur.X, wCurseur.Y ] <> '#' ) and ( FMatrice[ wCurseur.X, wCurseur.Y ] <> '^' ) and
      ( FMatrice[ wCurseur.X, wCurseur.Y ].ToInteger > ( FMatrice[ wPoint.X, wPoint.Y ].ToInteger + 1 ) ) then
    begin
      Inc( Result );
    end;
  end;

  // ---

  if ( wPoint.Y >= 0 ) then
  begin
    wCurseur := wPoint;
    wCurseur.Y := wCurseur.Y - 1;
    while ( wCurseur.Y >= 0 ) and ( FMatrice[ wCurseur.X, wCurseur.Y ] = '.' ) do
    begin
      wCurseur.Y := wCurseur.Y - 1;
    end;

    if ( wCurseur.Y >= 0 ) and ( FMatrice[ wCurseur.X, wCurseur.Y ] <> '#' ) and ( FMatrice[ wCurseur.X, wCurseur.Y ] <> '^' ) and
      ( FMatrice[ wCurseur.X, wCurseur.Y ].ToInteger > ( FMatrice[ wPoint.X, wPoint.Y ].ToInteger + 1 ) ) then
    begin
      Inc( Result );
    end;
  end;

  if ( wPoint.Y <= high( FMatrice[ 0 ] ) ) then
  begin
    wCurseur := wPoint;
    wCurseur.X := wCurseur.Y + 1;
    while ( wPoint.Y <= high( FMatrice[ 0 ] ) ) and ( FMatrice[ wCurseur.X, wCurseur.Y ] = '.' ) do
    begin
      wCurseur.Y := wCurseur.Y + 1;
    end;

    if ( wPoint.Y <= high( FMatrice[ 0 ] ) ) and ( FMatrice[ wCurseur.X, wCurseur.Y ] <> '#' ) and ( FMatrice[ wCurseur.X, wCurseur.Y ] <> '^' ) and
      ( FMatrice[ wCurseur.X, wCurseur.Y ].ToInteger > ( FMatrice[ wPoint.X, wPoint.Y ].ToInteger + 1 ) ) then
    begin
      Inc( Result );
    end;
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

function TFrmMain.Deplacer( aMatrice: TArray< string >; var aPosition: TPoint; out aIncrement: Integer ): Boolean;
begin
  Result := True;
  aIncrement := 0;

  if ( aPosition.X + FIncLine < 0 ) or ( aPosition.X + FIncLine > High( aMatrice ) ) or ( aPosition.Y + FIncCol < 0 ) or
    ( aPosition.Y + FIncCol > Length( aMatrice[ 0 ] ) ) then
  begin
    Exit( False );
  end;

  while ( aMatrice[ aPosition.X + FIncLine, aPosition.Y + FIncCol ] = '#' ) do
  begin
    SetLength( FBlocs, Length( FBlocs ) + 1 );
    FBlocs[ High( FBlocs ) ].X := aPosition.X;
    FBlocs[ High( FBlocs ) ].Y := aPosition.Y;

    if ( FIncLine = -1 ) then
    begin
      FIncLine := 0;
      FIncCol := 1;
    end
    else if ( FIncCol = 1 ) then
    begin
      FIncCol := 0;
      FIncLine := 1;
    end
    else if ( FIncCol = 0 ) then
    begin
      if ( FIncLine = 1 ) then
      begin
        FIncLine := 0;
        FIncCol := -1;
      end;
    end
    else if ( FIncCol = -1 ) then
    begin
      FIncCol := 0;
      FIncLine := -1;
    end;
  end;

  if ( aPosition.X + FIncLine < 0 ) or ( aPosition.X + FIncLine > High( aMatrice ) ) or ( aPosition.Y + FIncCol < 0 ) or
    ( aPosition.Y + FIncCol > Length( aMatrice[ 0 ] ) ) then
  begin
    Exit( False );
  end;

  aPosition.X := aPosition.X + FIncLine;
  aPosition.Y := aPosition.Y + FIncCol;

  if ( aMatrice[ aPosition.X ][ aPosition.Y ] <> 'I' ) then
  begin
    aMatrice[ aPosition.X ][ aPosition.Y ] := 'I';
    aIncrement := 1;
  end;
end;

procedure TFrmMain.Exercice1;
var
  F, L: TArray< string >;
  LTotal: LongInt;
  LPosition: TPoint;
  wInc: Integer;
begin
  F := TFile.ReadAllLines( GetInputFileName );

  LTotal := 1;
  MmoLogs.Clear;

  LPosition := GetCoordinates( F );

  F[ LPosition.X ][ LPosition.Y ] := 'I';

  FIncLine := -1;
  FIncCol := 0;

  while Deplacer( F, LPosition, wInc ) do
  begin
    LTotal := LTotal + wInc;
  end;

  for var i := 0 to High( F ) do
  begin
    MmoLogs.lines.Add( FormatFloat( '000', i ) + ' - ' + F[ i ] );
  end;

  Edt1.Text := LTotal.ToString;
  Edt1.CopyToClipboard;
end;

procedure TFrmMain.Exercice2;
var
  F: TArray< string >;
  LTotal: LongInt;
  LPosition: TPoint;
  wInc: Integer;
  LFile: TArray< string >;
begin
  F := TFile.ReadAllLines( GetInputFileName );

  SetLength( FMatrice, Length( F ), Length( F[ 0 ] ) );

  for var i := 0 to High( F ) do
  begin
    for var j := 1 to Length( F[ i ] ) do
    begin
      FMatrice[ i, j - 1 ] := F[ i, j ];
    end;
  end;

  LTotal := 1;
  MmoLogs.Clear;

  LPosition := GetCoordinates( F );

  SetLength( FBlocs, 1 );
  FBlocs[ 0 ] := LPosition;

  F[ LPosition.X ][ LPosition.Y ] := 'I';

  FIncLine := -1;
  FIncCol := 0;

  while Deplacer( F, LPosition, wInc ) do
  begin
    LTotal := LTotal + wInc;
    if ( wInc <> 0 ) then
    begin
      FMatrice[ LPosition.X, LPosition.Y - 1 ] := LTotal.ToString;
    end;
  end;

  SetLength( LFile, 0 );

  for var i := 0 to High( FMatrice ) do
  begin
    SetLength( LFile, Length( LFile ) + 1 );

    LFile[ High( LFile ) ] := String.Join( '|', FMatrice[ i ] );
  end;

  TFile.WriteAllLines( '.\Matrice.dat', LFile );

  LTotal := 0;

  for var i := 0 to High( FBlocs ) do
  begin
    LTotal := LTotal + Boucle( i );
  end;

  for var i := 0 to High( FBlocs ) do
  begin
    MmoLogs.lines.Add( FBlocs[ i ].X.ToString + ' , ' + FBlocs[ i ].Y.ToString );
  end;

  Edt2.Text := LTotal.ToString;
  Edt2.CopyToClipboard;
end;

function TFrmMain.GetCoordinates( aMatrice: TArray< string > ): TPoint;
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

procedure TFrmMain.LoadFile;
begin
  FFile := TFile.ReadAllLines( GetInputFileName );
end;

end.
