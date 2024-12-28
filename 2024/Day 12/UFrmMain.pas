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
  TRegion = record
    PlantType: string;
    Polygon: HRGN;
    Perimetre: Integer;
    NbPlant: Integer;
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
    FMatrix: TArray< TArray< string > >;
    FRegions: TArray< TRegion >;

    function GetInputFileName: string;
    function IsInRegion( aPoint: TPoint ): Boolean;

    procedure LoadMatrix;
    procedure Exercice1;
    procedure Exercice2;
    procedure LoadFile;
    procedure CreateRegion( wPointDepart: TPoint );
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

procedure TFrmMain.CreateRegion( wPointDepart: TPoint );
begin
  SetLength( FRegions, Length( FRegions ) + 1 );

end;

procedure TFrmMain.Exercice1;
var
  LTotal: Int64;
  LMPlant: string;
  wPoint: TPoint;
begin
  LoadFile;
  LoadMatrix;

  LMPlant := '';

  for var i := 0 to High( FMatrix ) do
  begin
    for var j := 0 to High( FMatrix[ i ] ) do
    begin
      if ( FMatrix[ i, j ] <> LMPlant ) then
      begin
        wPoint.X := i;
        wPoint.Y := j;

        if not( IsInRegion( wPoint ) ) then
        begin
          CreateRegion( wPoint );
        end;

        LMPlant := FMatrix[ i, j ];
      end;
    end;
  end;

  Edt1.Text := LTotal.ToString;
  Edt1.CopyToClipboard;
end;

procedure TFrmMain.Exercice2;
var
  LTotal: Int64;
begin
  LoadFile;

  LTotal := 0;

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

function TFrmMain.IsInRegion( aPoint: TPoint ): Boolean;
begin
  Result := False;

  for var i := 0 to High( FRegions ) do
  begin
    if PtInRegion( FRegions[ i ].Polygon, aPoint.X, aPoint.Y ) or ( FRegions[ i ].PlantType <> FMatrix[ aPoint.X, aPoint.Y ] ) then
    begin
      Exit( True );
    end;
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

end.
