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
    FFile: TArray<string>;
    FMatrix: TArray<TArray<string>>;

    function GetInputFileName: string;
    function NbDiv( aPosition: TPoint ): Int64;
    function NbDiv2( aPosition: TPoint ): Int64;

    procedure Exercice1;
    procedure Exercice2;
    procedure LoadFile;
    procedure LoadMatrix;
    procedure LogMatrix;
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
  LPosDepart: tpoint;
  LLine: string;
begin
  LoadFile;
  LoadMatrix;

  LPosDepart.X := 0;

  for var j := 0 to High( FMatrix[ 0 ] ) do
  begin
    if ( FMatrix[ 0, j ] = 'S' ) then
    begin
      LPosDepart.Y := j;
      Break;
    end;
  end;

  LTotal := NbDiv( LPosDepart );

  LogMatrix;

  Edt1.Text := LTotal.ToString;
  Edt1.CopyToClipboard;
end;

procedure TFrmMain.Exercice2;
var
  LTotal: Int64;
  LPosDepart: tpoint;
  LLine: string;
begin
  LoadFile;
  LoadMatrix;

  LPosDepart.X := 0;

  for var j := 0 to High( FMatrix[ 0 ] ) do
  begin
    if ( FMatrix[ 0, j ] = 'S' ) then
    begin
      LPosDepart.Y := j;
      Break;
    end;
  end;

  LTotal := 1 + NbDiv2( LPosDepart );

  LogMatrix;

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
begin
  SetLength( FMatrix, Length( FFile ), Length( FFile[ 0 ] ) );

  for var i := 0 to High( FFile ) do
  begin
    for var j := 1 to Length( FFile[ i ] ) do
    begin
      FMatrix[ i, j - 1 ] := FFile[ i, j ];
    end;
  end;
end;

procedure TFrmMain.LogMatrix;
var
  LLine: string;
begin
  MmoLogs.Clear;

  for var i := 0 to High( FMatrix ) do
  begin
    LLine := '';
    for var j := 0 to High( FMatrix[ i ] ) do
    begin
      LLine := LLine + FMatrix[ i, j ];
    end;

    MmoLogs.Lines.Add( LLine );
  end;
end;

function TFrmMain.NbDiv( aPosition: TPoint ): Int64;
var
  LLg: Integer;
  LPos: Integer;
  LNbLeft, LNbRight: Integer;
begin
  Result := 0;

  LLg := aPosition.X + 1;

  Result := 0;
  LNbLeft := 0;
  LNbRight := 0;

  while ( LLg <= High( FMatrix ) ) and ( FMatrix[ LLg, aPosition.Y ] <> '^' ) do
  begin
    FMatrix[ LLg, aPosition.Y ] := '|';

    Inc( LLg );
  end;

  if ( LLg <= High( FMatrix ) ) and ( aPosition.Y - 1 >= 0 ) and ( aPosition.Y + 1 <= High( FMatrix[ aPosition.X ] ) ) then
  begin
    LPos := aPosition.Y - 1;

    if ( FMatrix[ LLg, LPos ] <> '|' ) and ( FMatrix[ LLg, LPos ] <> '^' ) then
    begin
      FMatrix[ LLg, LPos ] := '|';

      aPosition.Y := LPos;
      aPosition.X := LLg;

      LNbLeft := 1 + NbDiv( aPosition );
      Result := LNbLeft;
    end;

    LPos := LPos + 2;

    if ( FMatrix[ LLg, LPos ] <> '|' ) and ( FMatrix[ LLg, LPos ] <> '^' ) then
    begin
      FMatrix[ LLg, LPos ] := '|';

      aPosition.Y := LPos;
      aPosition.X := LLg;

      LNbRight := NbDiv( aPosition );

      Result := Result + LNbRight;

      // Il ne faut pas compter 2 fois le split
      if ( LNbLeft = 0 ) then
      begin
        Result := Result + 1;
      end;
    end;
  end;
end;

function TFrmMain.NbDiv2( aPosition: TPoint ): Int64;
var
  LLg: Integer;
  LPos: Integer;
  LNbLeft, LNbRight: Integer;
begin
  Result := 0;

  LLg := aPosition.X + 1;

  Result := 0;
  LNbLeft := 0;
  LNbRight := 0;

  while ( LLg <= High( FMatrix ) ) and ( FMatrix[ LLg, aPosition.Y ] <> '^' ) do
  begin
    FMatrix[ LLg, aPosition.Y ] := '|';

    Inc( LLg );
  end;

  if ( LLg <= High( FMatrix ) ) and ( aPosition.Y - 1 >= 0 ) and ( aPosition.Y + 1 <= High( FMatrix[ aPosition.X ] ) ) then
  begin
    LPos := aPosition.Y - 1;

    if ( FMatrix[ LLg, LPos ] <> '^' ) then
    begin
      FMatrix[ LLg, LPos ] := '|';

      aPosition.Y := LPos;
      aPosition.X := LLg;

      LNbLeft := 1 + NbDiv2( aPosition );
    end;

    LPos := LPos + 2;

    if  ( FMatrix[ LLg, LPos ] <> '^' ) then
    begin
      FMatrix[ LLg, LPos ] := '|';

      aPosition.Y := LPos;
      aPosition.X := LLg;

      LNbRight := NbDiv2( aPosition );
    end;

    Result := LNbLeft + LNbRight;
  end;
end;

end.

