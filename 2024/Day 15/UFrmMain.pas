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
    FMatrix: TArray< TArray< string > >;
    FMoves: TArray< Char >;
    FPosDepart: TPoint;

    function GetInputFileName: string;
    function DoMove( aStartPoint: TPoint; aMove: Char ): TPoint;
    function TryMove( aStartPoint, aVector: TPoint ): TPoint;

    procedure Exercice1;
    procedure Exercice2;
    procedure LoadFile;
    procedure LoadMatrix;
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

function TFrmMain.DoMove( aStartPoint: TPoint; aMove: Char ): TPoint;
var
  LVector: TPoint;
begin
  Result := aStartPoint;

  case aMove of
    '<':
      begin
        if ( FMatrix[ Result.X, Result.Y - 1 ] <> '#' ) then
        begin
          if ( FMatrix[ Result.X, Result.Y - 1 ] = '.' ) then
          begin
            FMatrix[ Result.X, Result.Y ] := '.';
            Result.Y := Result.Y - 1;
            FMatrix[ Result.X, Result.Y ] := '@';
          end
          else
          begin
            LVector.X := 0;
            LVector.Y := -1;

            Result := TryMove( aStartPoint, LVector );
          end;
        end;
      end;

    '>':
      begin
        if ( FMatrix[ Result.X, Result.Y + 1 ] <> '#' ) then
        begin
          if ( FMatrix[ Result.X, Result.Y + 1 ] = '.' ) then
          begin
            FMatrix[ Result.X, Result.Y ] := '.';
            Result.Y := Result.Y + 1;
            FMatrix[ Result.X, Result.Y ] := '@';
          end
          else
          begin
            LVector.X := 0;
            LVector.Y := 1;

            Result := TryMove( aStartPoint, LVector );
          end;
        end;
      end;

    '^':
      begin
        if ( FMatrix[ Result.X - 1, Result.Y ] <> '#' ) then
        begin
          if ( FMatrix[ Result.X - 1, Result.Y ] = '.' ) then
          begin
            FMatrix[ Result.X, Result.Y ] := '.';
            Result.X := Result.X - 1;
            FMatrix[ Result.X, Result.Y ] := '@';
          end
          else
          begin
            LVector.X := -1;
            LVector.Y := 0;

            Result := TryMove( aStartPoint, LVector );
          end;
        end;
      end;

    'v':
      begin
        if ( FMatrix[ Result.X + 1, Result.Y ] <> '#' ) then
        begin
          if ( FMatrix[ Result.X + 1, Result.Y ] = '.' ) then
          begin
            FMatrix[ Result.X, Result.Y ] := '.';
            Result.X := Result.X + 1;
            FMatrix[ Result.X, Result.Y ] := '@';
          end
          else
          begin
            LVector.X := 1;
            LVector.Y := 0;

            Result := TryMove( aStartPoint, LVector );
          end;
        end;
      end;
  end;
end;

procedure TFrmMain.Exercice1;
var
  LTotal: Int64;
  LPos: TPoint;
begin
  LoadFile;
  LoadMatrix;

  LPos := FPosDepart;

  for var i := 0 to High( FMoves ) do
  begin
    LPos := DoMove( LPos, FMoves[ i ] );
  end;

  for var i := 0 to High( FMatrix ) do
  begin
    MmoLogs.Lines.Add( string.join( '', FMatrix[ i ] ) )
  end;

  LTotal := 0;
  for var i := 0 to High( FMatrix ) do
  begin
    for var j := 0 to High( FMatrix[ i ] ) do
    begin
      if FMatrix[ i, j ] = 'O' then
      begin
        LTotal := LTotal + ( i * 100 ) + j;
      end;
    end;
  end;

  Edt1.Text := LTotal.ToString;
  Edt1.CopyToClipboard;
end;

procedure TFrmMain.Exercice2;
var
  LTotal: Int64;
  LPos: TPoint;
begin
  LoadFile;
  LoadMatrix;

  LPos := FPosDepart;

  for var i := 0 to High( FMoves ) do
  begin
    LPos := DoMove( LPos, FMoves[ i ] );
  end;

  for var i := 0 to High( FMatrix ) do
  begin
    MmoLogs.Lines.Add( string.join( '', FMatrix[ i ] ) )
  end;

  LTotal := 0;
  for var i := 0 to High( FMatrix ) do
  begin
    for var j := 0 to High( FMatrix[ i ] ) do
    begin
      if FMatrix[ i, j ] = 'O' then
      begin
        LTotal := LTotal + ( i * 100 ) + j;
      end;
    end;
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

procedure TFrmMain.LoadFile;
begin
  FFile := TFile.ReadAllLines( GetInputFileName );
end;

procedure TFrmMain.LoadMatrix;
var
  LInd: Integer;
  LPos: Integer;
begin
  SetLength( FMatrix, Length( FFile ), Length( FFile[ 0 ] ) );

  LInd := 0;
  while ( LInd <= High( FFile ) ) and ( FFile[ LInd ] <> '' ) do
  begin
    for var j := 1 to Length( FFile[ LInd ] ) do
    begin
      if ( FFile[ LInd, j ] = '@' ) then
      begin
        FPosDepart.X := LInd;
        FPosDepart.Y := j - 1;
      end;

      FMatrix[ LInd, j - 1 ] := FFile[ LInd, j ];
    end;

    MmoLogs.Lines.Add( FFile[ LInd ] );

    Inc( LInd );
  end;

  SetLength( FMoves, 0 );

  while ( LInd <= High( FFile ) ) do
  begin
    if ( FFile[ LInd ] <> '' ) then
    begin
      LPos := High( FMoves );
      SetLength( FMoves, Length( FMoves ) + Length( FFile[ LInd ] ) );
      for var i := 1 to Length( FFile[ LInd ] ) do
      begin
        FMoves[ LPos + i ] := FFile[ LInd, i ];
      end;
    end;

    Inc( LInd );
  end;
end;

function TFrmMain.TryMove( aStartPoint, aVector: TPoint ): TPoint;
var
  wPoint, wPointBefore: TPoint;
begin
  wPoint := aStartPoint;
  while ( FMatrix[ wPoint.X, wPoint.Y ] <> '#' ) and ( FMatrix[ wPoint.X, wPoint.Y ] <> '.' ) do
  begin
    wPoint := wPoint + aVector;
  end;

  if ( FMatrix[ wPoint.X, wPoint.Y ] = '.' ) then
  begin
    while ( wPoint <> ( aStartPoint + aVector ) ) do
    begin
      wPointBefore := wPoint;
      wPoint := wPoint - aVector;
      FMatrix[ wPointBefore.X, wPointBefore.Y ] := FMatrix[ wPoint.X, wPoint.Y ];
    end;
    FMatrix[ aStartPoint.X, aStartPoint.Y ] := '.';

    Result := aStartPoint + aVector;
  end
  else
  begin
    Result := aStartPoint;
  end;
end;

end.
