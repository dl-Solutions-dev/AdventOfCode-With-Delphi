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

    function GetInputFileName: string;
    function GetSumInvalidId( aMin, aMax: Int64 ): Int64;
    function GetSumInvalidId2( aMin, aMax: Int64 ): Int64;
    function InvalidId( aId: string ): Int64;

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
  LDebut, LFin: string;
begin
  LoadFile;

  LTotal := 0;

  for var i := 0 to High( FFile ) do
  begin
    LDebut := FFile[ i ].Substring( 0, FFile[ i ].IndexOf( '-' ) );
    LFin := FFile[ i ].Substring( FFile[ i ].IndexOf( '-' ) + 1 );

    LTotal := LTotal + GetSumInvalidId( LDebut.ToInt64, LFin.ToInt64 );
  end;

  Edt1.Text := LTotal.ToString;
  Edt1.CopyToClipboard;
end;

procedure TFrmMain.Exercice2;
var
  LTotal: Int64;
  LDebut, LFin: string;
begin
  LoadFile;

  LTotal := 0;

  for var i := 0 to High( FFile ) do
  begin
    LDebut := FFile[ i ].Substring( 0, FFile[ i ].IndexOf( '-' ) );
    LFin := FFile[ i ].Substring( FFile[ i ].IndexOf( '-' ) + 1 );

    LTotal := LTotal + GetSumInvalidId2( LDebut.ToInt64, LFin.ToInt64 );
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

function TFrmMain.GetSumInvalidId( aMin, aMax: Int64 ): Int64;
var
  LLength: Integer;
  LPart1, LPart2: Int64;
begin
  Result := 0;

  for var i := aMin to aMax do
  begin
    LLength := ( i.ToString ).Length;

    // Si le nombre de chiffres n'est pas pair il ne peux pas y avoi 2 parties égales
    if ( LLength mod 2 = 0 ) then
    begin
      LPart1 := ( i div Trunc( Power( 10, ( LLength div 2 ) ) ) );
      LPart2 := ( i mod Trunc( Power( 10, ( LLength div 2 ) ) ) );

      if ( LPart1 = LPart2 ) then
      begin
        Result := Result + i;
      end;
    end;
  end;
end;

function TFrmMain.GetSumInvalidId2( aMin, aMax: Int64 ): Int64;
var
  LLength: Integer;
  LResult: Int64;
begin
  Result := 0;

  for var i := aMin to aMax do
  begin
    LResult := InvalidId( i.ToString );
    if ( LResult <> 0 ) then
    begin
      Result := Result + LResult;
    end;
  end;
end;

function TFrmMain.InvalidId( aId: string ): Int64;
var
  LId: Int64;
  i, j: Integer;
  LPart1, LPart2: string;
begin
  LId := 0;

  i := 1;

  // On cherche les égalités par groupe de 1, de 2, ...
  // On ne peut plus avoir d'égalité si la longueur du premier
  // groupe est > la moitié de la longueur totale de la chaine
  while ( LId = 0 ) and ( i <= aId.Length div 2 ) do
  begin
    // On s'assure que le nombre de caractère est un multiplicateur du nombre de caractère du groupe
    if ( aID.Length mod i = 0 ) then
    begin
      LId := aId.ToInt64;

      j := 1;

      // On compare bloc par bloc
      while j <= ( Length( aId ) - i ) do
      begin
        LPart1 := aId.Substring( j - 1, i );
        LPart2 := aId.Substring( ( j - 1 ) + i, i );

        // Si un bloc est différent du suivatn, on arrête, l'Id est valide
        if LPart1 <> LPart2 then
        begin
          LId := 0;
          Break;
        end;

        Inc( j, i );
      end;
    end;

    Inc( i );
  end;

  Result := LId;
end;

procedure TFrmMain.LoadFile;
var
  LInput: TextFile;
  LLine: string;
  LRanges: TArray<string>;
begin
  // On part du principe que tous le puzzle est sur une ligne
  AssignFile( LInput, GetInputFileName );
  Reset( LInput );
  Readln( LInput, LLine );

  FFile := LLine.Split( [ ',' ] );

  CloseFile( LInput );
end;

end.

