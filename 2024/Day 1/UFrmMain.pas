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
    Memo1: TMemo;

    procedure BtnExercice1Click( Sender: TObject );
    procedure BtnExercice2Click( Sender: TObject );
  private
    { Déclarations privées }
    FFile: TArray< string >;

    function GetInputFileName: string;

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
  System.Math,
  System.Threading;

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
  F, Lg: TArray< string >;
  L, R: TArray< Integer >;
  wTotal: Integer;
begin
  F := TFile.ReadAllLines( GetInputFileName );

  SetLength( L, 0 );
  SetLength( R, 0 );

  for var i := 0 to High( F ) do
  begin
    Lg := F[ i ].Split( [ '   ' ] );

    SetLength( L, Length( L ) + 1 );
    L[ High( L ) ] := Lg[ 0 ].ToInteger;

    SetLength( R, Length( R ) + 1 );
    R[ High( R ) ] := Lg[ 1 ].ToInteger;
  end;

  TParallelArray.Sort< Integer >( L );
  TParallelArray.Sort< Integer >( R );

  wTotal := 0;

  for var i := 0 to High( L ) do
  begin
    wTotal := wTotal + abs( L[ i ] - R[ i ] );
  end;

  Edt1.Text := wTotal.ToString;
  Edt1.CopyToClipboard;
end;

procedure TFrmMain.Exercice2;
var
  F, Lg: TArray< string >;
  L, R: TArray< Integer >;
  wTotal, wNbFois: Integer;
  IndL, IndR, Nbre: Integer;
begin
  F := TFile.ReadAllLines( GetInputFileName );

  SetLength( L, 0 );
  SetLength( R, 0 );

  for var i := 0 to High( F ) do
  begin
    Lg := F[ i ].Split( [ '   ' ] );

    SetLength( L, Length( L ) + 1 );
    L[ High( L ) ] := Lg[ 0 ].ToInteger;

    SetLength( R, Length( R ) + 1 );
    R[ High( R ) ] := Lg[ 1 ].ToInteger;
  end;

  TParallelArray.Sort< Integer >( L );
  TParallelArray.Sort< Integer >( R );

  wTotal := 0;

  IndL := 0;
  IndR := 0;

  while IndL <= High( L ) do
  begin
    wNbFois := 0;

    Nbre := L[ IndL ];

    while ( IndR <= High( R ) ) and ( R[ IndR ] < Nbre ) do
    begin
      Inc( IndR );
    end;

    while ( IndR <= High( R ) ) and ( R[ IndR ] = Nbre ) do
    begin
      Inc( IndR );
      Inc( wNbFois );
    end;

    repeat
      wTotal := wTotal + ( wNbFois * Nbre );
      Inc( IndL );
    until ( IndL > High( L ) ) or ( L[ IndL ] <> Nbre );
  end;

  Edt2.Text := wTotal.ToString;
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

end.
