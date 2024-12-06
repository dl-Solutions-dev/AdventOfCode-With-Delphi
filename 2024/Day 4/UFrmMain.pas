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

    function GetInputFileName: string;
    function GetNextLetter( aLetter: string ): string;
    function NbMots( aMatrice: TArray< string >; aLigne, aColonne: Integer ): Integer;

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
  MOT: TArray< string > = [ 'X', 'M', 'A', 'S' ];

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
  F, L: TArray< string >;
  LTotal, LNb: LongInt;
begin
  F := TFile.ReadAllLines( GetInputFileName );

  LTotal := 0;

  for var i := 0 to High( F ) do
  begin
    for var j := 1 to Length( F[ i ] ) do
    begin
      if ( F[ i ][ j ] = 'X' ) then
      begin
        LNb := NbMots( F, i, j );
        if LNb > 0 then
        begin
          MmoLogs.Lines.Add( i.ToString + ', ' + j.ToString + ' -> ' + LNb.ToString );
        end;
        LTotal := LTotal + LNb;
      end;
    end;
  end;

  Edt1.Text := LTotal.ToString;
  Edt1.CopyToClipboard;
end;

procedure TFrmMain.Exercice2;
var
  F, L: TArray< string >;
  LTotal, LNb: LongInt;
  wMot1, wMot2: string;
begin
  F := TFile.ReadAllLines( GetInputFileName );

  LTotal := 0;

  for var i := 1 to High( F ) - 1 do
  begin
    for var j := 2 to Length( F[ i ] ) - 1 do
    begin
      if ( F[ i ][ j ] = 'A' ) then
      begin
        wMot1 := F[ i - 1 ][ j - 1 ] + 'A' + F[ i + 1 ][ j + 1 ];
        wMot2 := F[ i - 1 ][ j + 1 ] + 'A' + F[ i + 1 ][ j - 1 ];

        if ( ( wMot1 = 'MAS' ) or ( wMot1 = 'SAM' ) ) and ( ( wMot2 = 'MAS' ) or ( wMot2 = 'SAM' ) ) then
        begin
          MmoLogs.Lines.Add( i.ToString + ', ' + j.ToString + ' -> ' + wMot1 + ', ' + wMot2 + ' = OK' );
          Inc( LTotal );
        end
        else
        begin
          MmoLogs.Lines.Add( i.ToString + ', ' + j.ToString + ' -> ' + wMot1 + ', ' + wMot2 + ' =    NOK' );
        end;
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

function TFrmMain.GetNextLetter( aLetter: string ): string;
var
  LLetter: string;
  LFound: Boolean;
begin
  Result := '';
  LFound := False;

  for LLetter in MOT do
  begin
    if LFound then
    begin
      Exit( LLetter );
    end;

    if ( LLetter = aLetter ) then
    begin
      LFound := True;
    end;
  end;
end;

procedure TFrmMain.LoadFile;
begin
  FFile := TFile.ReadAllLines( GetInputFileName );
end;

function TFrmMain.NbMots( aMatrice: TArray< string >; aLigne, aColonne: Integer ): Integer;
var
  LFirstLine, LEndLine,
    LFirstCol, LEndCol: Integer;
  i, j: Integer;
  LSearchletter, LNextLetter: string;
  LIncLg, LIncCol: Integer;
  LNextLg, LNextCol: Integer;
begin
  Result := 0;

  LSearchletter := GetNextLetter( aMatrice[ aLigne ][ aColonne ] );

  if ( aLigne > 0 ) then
  begin
    LFirstLine := ( aLigne - 1 );
  end
  else
  begin
    LFirstLine := aLigne;
  end;

  if ( aLigne < High( aMatrice ) ) then
  begin
    LEndLine := ( aLigne + 1 );
  end
  else
  begin
    LEndLine := High( aMatrice );
  end;

  if ( aColonne > 1 ) then
  begin
    LFirstCol := ( aColonne - 1 );
  end
  else
  begin
    LFirstCol := aColonne;
  end;

  if ( aColonne < Length( aMatrice[ 0 ] ) ) then
  begin
    LEndCol := ( aColonne + 1 );
  end
  else
  begin
    LEndCol := Length( aMatrice );
  end;

  for i := LFirstLine to LEndLine do
  begin
    for j := LFirstCol to LEndCol do
    begin
      if ( ( i <> aLigne ) or ( j <> aColonne ) ) and ( aMatrice[ i ][ j ] = LSearchletter ) then
      begin
        LIncLg := ( i - aLigne );
        LIncCol := ( j - aColonne );

        LNextLetter := GetNextLetter( LSearchletter );

        LNextLg := i + LIncLg;
        LNextCol := j + LIncCol;

        while ( LNextLg >= 0 ) and ( LNextLg <= High( aMatrice ) ) and ( LNextCol > 0 ) and ( LNextCol <= Length( aMatrice[ 0 ] ) ) and
          ( LNextLetter <> '' ) and ( LNextLetter <> 'S' ) and ( aMatrice[ LNextLg ][ LNextCol ] = LNextLetter ) do
        begin
          LNextLetter := GetNextLetter( LNextLetter );

          LNextLg := LNextLg + LIncLg;
          LNextCol := LNextCol + LIncCol;
        end;

        if ( LNextLg >= 0 ) and ( LNextLg <= High( aMatrice ) ) and ( LNextCol > 0 ) and ( LNextCol <= Length( aMatrice[ 0 ] ) ) and
          ( aMatrice[ LNextLg ][ LNextCol ] = 'S' ) and ( LNextLetter = 'S' ) then
        begin
          Inc( Result );
        end;
      end;
    end;
  end;
end;

end.
