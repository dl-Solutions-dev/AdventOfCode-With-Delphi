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
    FRegles: TArray< TArray< integer > >;
    FModifications: TArray< string >;

    function GetInputFileName: string;
    function GetMiddleListe( aModification: string; aReOrder: Boolean = False ): integer;
    function OrdreOK( aListe: TArray< string >; aInd: integer ): Boolean; overload;
    function OrdreOK( aListe: TArray< string >; aCandidat: string ): Boolean; overload;
    function SortModifications( aListe: TArray< string > ): TArray< string >;

    procedure ChargerRegles( aListe: TArray< string > );
    procedure ChargerModifications( aListe: TArray< string > );
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


function IsNumberInArray( const ANumber: integer;
  const AArray: array of integer ): Boolean;
var
  i: integer;
begin
  for i := Low( AArray ) to High( AArray ) do
    if ANumber = AArray[ i ] then
      Exit( True );
  Result := False;
end;

{ TFrmMain }

procedure TFrmMain.BtnExercice1Click( Sender: TObject );
begin
  Exercice1;
end;

procedure TFrmMain.BtnExercice2Click( Sender: TObject );
begin
  Exercice2;
end;

procedure TFrmMain.ChargerModifications( aListe: TArray< string > );
var
  LChargeOk: Boolean;
begin
  LChargeOk := False;

  SetLength( FModifications, 0 );

  for var i := 0 to High( aListe ) do
  begin
    if LChargeOk then
    begin
      SetLength( FModifications, Length( FModifications ) + 1 );
      FModifications[ High( FModifications ) ] := aListe[ i ];
    end;

    if ( aListe[ i ] = '' ) then
    begin
      LChargeOk := True;
    end;
  end;
end;

procedure TFrmMain.ChargerRegles( aListe: TArray< string > );
var
  LRegle: TArray< string >;
begin
  SetLength( FRegles, 0 );

  for var i := 0 to High( aListe ) do
  begin
    if aListe[ i ] = '' then
    begin
      Exit;
    end;

    // MmoLogs.Lines.Add( aListe[ i ] );

    LRegle := aListe[ i ].Split( [ '|' ] );
    if ( LRegle[ 0 ].ToInteger > Length( FRegles ) ) then
    begin
      SetLength( FRegles, LRegle[ 0 ].ToInteger + 1 );
    end;

    SetLength( FRegles[ LRegle[ 0 ].ToInteger ], Length( FRegles[ LRegle[ 0 ].ToInteger ] ) + 1 );

    FRegles[ LRegle[ 0 ].ToInteger, High( FRegles[ LRegle[ 0 ].ToInteger ] ) ] := LRegle[ 1 ].ToInteger;
  end;
end;

procedure TFrmMain.Exercice1;
var
  F, L: TArray< string >;
  LTotal, LNb: LongInt;
begin
  F := TFile.ReadAllLines( GetInputFileName );

  ChargerRegles( F );
  ChargerModifications( F );

  LTotal := 0;

  for var i := 0 to High( FModifications ) do
  begin
    LTotal := LTotal + GetMiddleListe( FModifications[ i ] );
  end;

  Edt1.Text := LTotal.ToString;
  Edt1.CopyToClipboard;
end;

procedure TFrmMain.Exercice2;
var
  F, L: TArray< string >;
  LTotal, LNb: LongInt;
begin
  F := TFile.ReadAllLines( GetInputFileName );

  ChargerRegles( F );
  ChargerModifications( F );

  LTotal := 0;

  for var i := 0 to High( FModifications ) do
  begin
    LTotal := LTotal + GetMiddleListe( FModifications[ i ], True );
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

function TFrmMain.GetMiddleListe( aModification: string; aReOrder: Boolean ): integer;
var
  LPages: TArray< string >;
  LInd: integer;
begin
  Result := 0;

  LPages := aModification.Split( [ ',' ] );
  LInd := 0;
  while ( LInd < High( LPages ) ) and OrdreOK( LPages, LInd ) do
  begin
    Inc( LInd );
  end;

  if ( LInd = High( LPages ) ) then
  begin
    if not( aReOrder ) then
    begin
      Result := LPages[ ( Length( LPages ) div 2 ) ].ToInteger;
    end;
  end
  else
  begin
    if aReOrder then
    begin
      LPages := SortModifications( LPages );

      Result := LPages[ ( Length( LPages ) div 2 ) ].ToInteger;

      // Pour vérification
      if ( GetMiddleListe( string.Join( ',', LPages ) ) = 0 ) then
      begin
        MmoLogs.Lines.Add( aModification );
      end;
    end;
  end;
end;

procedure TFrmMain.LoadFile;
begin
  FFile := TFile.ReadAllLines( GetInputFileName );
end;

function TFrmMain.OrdreOK( aListe: TArray< string >; aCandidat: string ): Boolean;
begin
  Result := True;

  for var i := 0 to High( aListe ) do
  begin
    if ( aListe[ i ] <> aCandidat ) and not( IsNumberInArray( aListe[ i ].ToInteger, FRegles[ aCandidat.ToInteger ] ) ) then
    begin
      Exit( False );
    end;
  end;
end;

function TFrmMain.OrdreOK( aListe: TArray< string >; aInd: integer ): Boolean;
var
  LCandidate: integer;
begin
  Result := True;

  LCandidate := aListe[ aInd ].ToInteger;

  for var i := aInd + 1 to High( aListe ) do
  begin
    if not( IsNumberInArray( aListe[ i ].ToInteger, FRegles[ LCandidate ] ) ) then
    begin
      Exit( False );
    end;
  end;
end;

function TFrmMain.SortModifications( aListe: TArray< string > ): TArray< string >;
var
  LModifs: TArray< string >;
  LInd: integer;
begin
  while ( Length( Result ) < Length( aListe ) ) do
  begin
    SetLength( LModifs, 0 );
    for var i := 0 to High( aListe ) do
    begin
      if aListe[ i ] <> '' then
      begin
        SetLength( LModifs, Length( LModifs ) + 1 );
        LModifs[ High( LModifs ) ] := aListe[ i ];
      end;
    end;

    LInd := 0;
    while not( OrdreOK( LModifs, LModifs[ LInd ] ) ) do
    begin
      Inc( LInd );
    end;

    SetLength( Result, Length( Result ) + 1 );
    Result[ High( Result ) ] := LModifs[ LInd ];

    for var i := 0 to High( aListe ) do
    begin
      if ( aListe[ i ] = LModifs[ LInd ] ) then
      begin
        aListe[ i ] := '';

        Break;
      end;
    end;
  end;
end;

end.
