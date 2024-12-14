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
  TPoint64 = record
    X: Int64;
    Y: Int64;
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

    function GetInputFileName: string;
    function Resolve( aButtonA, aButtonB, aPrize: TPoint64 ): Int64;
    function CountCost( aGrowth: Int64 ): Int64;

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

function TFrmMain.CountCost( aGrowth: Int64 ): Int64;
var
  LLineType: SmallInt;
  LButtonA, LButtonB: TPoint64;
  LPrize: TPoint64;
  LLine: TArray< string >;
  LValue: TArray< string >;
begin
  Result := 0;

  LLineType := 0;
  for var i := 0 to High( FFile ) + 1 do
  begin
    Inc( LLineType );

    case LLineType of
      1:
        begin
          LLine := FFile[ i ].Split( [ ':' ] );
          LLine := LLine[ 1 ].Split( [ ', ' ] );
          LValue := LLine[ 0 ].Split( [ '+' ] );
          LButtonA.X := LValue[ 1 ].ToInt64;
          LValue := LLine[ 1 ].Split( [ '+' ] );
          LButtonA.Y := LValue[ 1 ].ToInt64;
        end;
      2:
        begin
          LLine := FFile[ i ].Split( [ ':' ] );
          LLine := LLine[ 1 ].Split( [ ', ' ] );
          LValue := LLine[ 0 ].Split( [ '+' ] );
          LButtonB.X := LValue[ 1 ].ToInt64;
          LValue := LLine[ 1 ].Split( [ '+' ] );
          LButtonB.Y := LValue[ 1 ].ToInt64;
        end;
      3:
        begin
          LLine := FFile[ i ].Split( [ ':' ] );
          LLine := LLine[ 1 ].Split( [ ', ' ] );
          LValue := LLine[ 0 ].Split( [ '=' ] );
          LPrize.X := LValue[ 1 ].ToInt64 + aGrowth;
          LValue := LLine[ 1 ].Split( [ '=' ] );
          LPrize.Y := LValue[ 1 ].ToInt64 + aGrowth;
        end;
      4:
        begin
          Result := Result + Resolve( LButtonA, LButtonB, LPrize );
          LLineType := 0;
        end;
    end;
  end;
end;

procedure TFrmMain.Exercice1;
var
  LTotal: Int64;
begin
  LoadFile;

  LTotal := CountCost( 0 );

  Edt1.Text := LTotal.ToString;
  Edt1.CopyToClipboard;
end;

procedure TFrmMain.Exercice2;
var
  LTotal: Int64;
begin
  LoadFile;

  LTotal := CountCost( 10000000000000 );

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

// Resolution de 2 équations à 2 inconnues
function TFrmMain.Resolve( aButtonA, aButtonB, aPrize: TPoint64 ): Int64;
var
  La, Lb, Lc, Ld, Le, Lf, LX, LY: Double;
begin
  Result := 0;

  La := aButtonA.X;
  Lb := aButtonB.X;
  Lc := aPrize.X;
  Ld := aButtonA.Y;
  Le := aButtonB.Y;
  Lf := aPrize.Y;

  LY := ( Lf * La - Ld * Lc ) / ( La * Le - Ld * Lb );
  LX := ( Lc - Lb * LY ) / La;

  if ( LX >= 0 ) and ( LY >= 0 ) and ( Trunc( LX ) = LX ) and ( Trunc( LY ) = LY ) then
  begin
    Result := Trunc( LX * 3 + LY );
  end;
end;

end.
