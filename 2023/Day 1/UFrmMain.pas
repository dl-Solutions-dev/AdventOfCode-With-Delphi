unit UFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFrmMain = class( TForm )
    Edt1 : TEdit;
    BtnTraitement1 : TButton;
    BtnTraitement2 : TButton;
    Edt2 : TEdit;
    procedure BtnTraitement1Click( Sender : TObject );
    procedure BtnTraitement2Click( Sender : TObject );
  private
    { Déclarations privées }
    function GetFirstDigitof( aString : string; out aPosition : Cardinal ) : Cardinal;
    function GetFirstDigitLetterof( aString : string; aDigitsList : TArray< string > ) : Cardinal;
  public
    { Déclarations publiques }
  end;

var
  FrmMain : TFrmMain;

implementation

uses
  System.IOUtils, System.StrUtils;

const
  FILENAME : string = '.\input.txt';
  DIGITS : set of Char = [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' ];
  DIGITS_LETTER : TArray< string > = [ 'ZERO', 'ONE', 'TWO', 'THREE', 'FOUR', 'FIVE', 'SIX', 'SEVEN', 'EIGHT', 'NINE' ];
  DIGITS_LETTER_INV : TArray< string > = [ 'OREZ', 'ENO', 'OWT', 'EERHT', 'RUOF', 'EVIF', 'XIS', 'NEVES', 'THGIE', 'ENIN' ];

{$R *.dfm}


procedure TFrmMain.BtnTraitement1Click( Sender : TObject );
var
  F : TArray< string >;
  wSomme : Integer;
  wPos : Cardinal;
begin
  F := TFile.ReadAllLines( FILENAME );

  wSomme := 0;

  for var i := 0 to High( F ) do
  begin
    wSomme := wSomme + ( GetFirstDigitof( F[ i ], wPos ) * 10 ) + GetFirstDigitof( ReverseString( F[ i ] ), wPos );
  end;

  Edt1.Text := wSomme.ToString;
end;

procedure TFrmMain.BtnTraitement2Click( Sender : TObject );
var
  F : TArray< string >;
  wSomme : Integer;
begin
  F := TFile.ReadAllLines( FILENAME );

  wSomme := 0;

  for var i := 0 to High( F ) do
  begin
    wSomme := wSomme + ( GetFirstDigitLetterof( F[ i ].ToUpper, DIGITS_LETTER ) * 10 ) + GetFirstDigitLetterof( ReverseString( F[ i ] ).ToUpper,
      DIGITS_LETTER_INV );
  end;

  Edt2.Text := wSomme.ToString;
end;

function TFrmMain.GetFirstDigitLetterof( aString : string; aDigitsList : TArray< string > ) : Cardinal;
var
  wPos : Integer;
  wFirst : Integer;
  i, wPosDigit : Cardinal;
begin
  wFirst := 999;

  for i := 0 to High( aDigitsList ) do
  begin
    wPos := pos( aDigitsList[ i ], aString );
    if ( wPos > 0 ) and ( wPos < wFirst ) then
    begin
      wFirst := wPos;
      Result := i;
    end;
  end;

  i := GetFirstDigitof( aString, wPosDigit );
  if ( wPosDigit < wFirst ) then
  begin
    Result := i;
  end;
end;

function TFrmMain.GetFirstDigitof( aString : string; out aPosition : Cardinal ) : Cardinal;
begin
  aPosition := 999;

  for var i := 1 to Length( aString ) do
  begin
    if aString[ i ] in DIGITS then
    begin
      aPosition := i;
      Exit( StrToInt( aString[ i ] ) );
    end;
  end;
end;

end.
