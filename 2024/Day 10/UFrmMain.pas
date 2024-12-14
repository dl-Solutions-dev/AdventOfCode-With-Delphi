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
    function Explore( aBegin: TPoint; aIdRound: Integer; aMark:Boolean= True ): Integer;

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
  LTotal: Int64;
  wPoint: TPoint;
  LRound: Integer;
  LLn: string;
begin
  LoadFile;

  setlength( FFile1, Length( FFile ) );
  LLn := DupeString(' ', Length( FFile[ 0 ]));

  LTotal := 0;
  LRound := 1;

  for var i := 0 to High( FFile ) do
  begin
    for var j := 1 to Length( FFile[ i ] ) do
    begin
      if FFile[ i, j ] = '0' then
      begin
        wPoint.X := i;
        wPoint.Y := j;

        for var k := 0 to High( FFile1 ) do
        begin
          FFile1[ k ] := LLn;
        end;

        LTotal := LTotal + Explore( wPoint, LRound );
      end;
    end;
  end;

  Edt1.Text := LTotal.ToString;
  Edt1.CopyToClipboard;
end;

procedure TFrmMain.Exercice2;
var
  LTotal: Int64;
  wPoint: TPoint;
  LRound: Integer;
  LLn: string;
begin
  LoadFile;

  setlength( FFile1, Length( FFile ) );
  LLn := DupeString(' ', Length( FFile[ 0 ]));

  LTotal := 0;
  LRound := 1;

  for var i := 0 to High( FFile ) do
  begin
    for var j := 1 to Length( FFile[ i ] ) do
    begin
      if FFile[ i, j ] = '0' then
      begin
        wPoint.X := i;
        wPoint.Y := j;

        for var k := 0 to High( FFile1 ) do
        begin
          FFile1[ k ] := LLn;
        end;

        LTotal := LTotal + Explore( wPoint, LRound, False );
      end;
    end;
  end;

  Edt2.Text := LTotal.ToString;
  Edt2.CopyToClipboard;
end;

function TFrmMain.Explore( aBegin: TPoint; aIdRound: Integer; aMark:Boolean ): Integer;
var
  wPoint: TPoint;
  wActual: Integer;
  wNext: Integer;
begin
  Result := 0;

  wActual := StrToInt( FFile[ aBegin.X, aBegin.Y ] );

  if ( aBegin.X > 0 ) then
  begin
    wNext := StrToInt( FFile[ aBegin.X - 1, aBegin.Y ] );

    if ( wNext - wActual = 1 ) then
    begin
      if ( wNext = 9 ) then
      begin
        wPoint.X := aBegin.X - 1;
        wPoint.Y := aBegin.Y;

        if not(aMark) or ( ( FFile1[ wPoint.X, wPoint.Y ] ) = ' ')  then
        begin
          FFile1[ wPoint.X, wPoint.Y ] := aIdRound.ToString[ 1 ];
          Result := Result + 1;
        end;
      end
      else
      begin
        wPoint.X := aBegin.X - 1;
        wPoint.Y := aBegin.Y;

        Result := Result + Explore( wPoint, aIdRound, aMark )
      end;
    end;
  end;

  if ( aBegin.X < High( FFile ) ) then
  begin
    wNext := StrToInt( FFile[ aBegin.X + 1, aBegin.Y ] );

    if ( wNext - wActual = 1 ) then
    begin
      if ( wNext = 9 ) then
      begin
        wPoint.X := aBegin.X + 1;
        wPoint.Y := aBegin.Y;

        if not(aMark) or ( ( FFile1[ wPoint.X, wPoint.Y ] ) = ' ')  then
        begin
          FFile1[ wPoint.X, wPoint.Y ] := aIdRound.ToString[ 1 ];
          Result := Result + 1;
        end;
      end
      else
      begin
        wPoint.X := aBegin.X + 1;
        wPoint.Y := aBegin.Y;

        Result := Result + Explore( wPoint, aIdRound, aMark )
      end;
    end;
  end;

  if ( aBegin.Y > 1 ) then
  begin
    wNext := StrToInt( FFile[ aBegin.X, aBegin.Y - 1 ] );

    if ( wNext - wActual = 1 ) then
    begin
      if ( wNext = 9 ) then
      begin
        wPoint.X := aBegin.X;
        wPoint.Y := aBegin.Y - 1;

        if not(aMark) or ( ( FFile1[ wPoint.X, wPoint.Y ] ) = ' ')  then
        begin
          FFile1[ wPoint.X, wPoint.Y ] := aIdRound.ToString[ 1 ];
          Result := Result + 1;
        end;
      end
      else
      begin
        wPoint.X := aBegin.X;
        wPoint.Y := aBegin.Y - 1;

        Result := Result + Explore( wPoint, aIdRound, aMark )
      end;
    end;
  end;

  if ( aBegin.Y < Length( FFile[ 0 ] ) ) then
  begin
    wNext := StrToInt( FFile[ aBegin.X, aBegin.Y + 1 ] );

    if ( wNext - wActual = 1 ) then
    begin
      if ( wNext = 9 ) then
      begin
        wPoint.X := aBegin.X;
        wPoint.Y := aBegin.Y + 1;

        if not(aMark) or ( ( FFile1[ wPoint.X, wPoint.Y ] ) = ' ') then
        begin
          FFile1[ wPoint.X, wPoint.Y ] := aIdRound.ToString[ 1 ];
          Result := Result + 1;
        end;
      end
      else
      begin
        wPoint.X := aBegin.X;
        wPoint.Y := aBegin.Y + 1;

        Result := Result + Explore( wPoint, aIdRound, aMark )
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
  FFile1 := TFile.ReadAllLines( GetInputFileName );
end;

end.
