unit UFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFrmMain = class( TForm )
    Edt1 : TEdit;
    BtnExercice1 : TButton;
    Edt2 : TEdit;
    BtnExercice2 : TButton;
    procedure BtnExercice1Click( Sender : TObject );
    procedure BtnExercice2Click( Sender : TObject );
  private
    { Déclarations privées }
    procedure Exercice1;
    procedure Exercice2;

    function IsPartNumber( aNumber : string; aFile : TArray< string >; aLine, aColumn : SmallInt ) : Boolean;
    function NumberDigits( aFile : TArray< string >; aLine, aColumn : SmallInt ) : SmallInt;
    function Ratio( aFile : TArray< string >; aLine, aColumn : SmallInt ) : Integer;
    function GetPartNumber( aString : string; aColumn : SmallInt ) : Integer;
  public
    { Déclarations publiques }
  end;

var
  FrmMain : TFrmMain;

implementation

uses
  System.IOUtils, System.StrUtils, System.Generics.Collections;

const
  FILENAME : string = '.\input.txt';
  DIGITS : Set Of Char = [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' ];
  OTHERS : Set Of Char = [ '.', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' ];
  GEAR : Char = '*';

{$R *.dfm}


procedure TFrmMain.BtnExercice1Click( Sender : TObject );
begin
  Exercice1;
end;

procedure TFrmMain.BtnExercice2Click( Sender : TObject );
begin
  Exercice2;
end;

procedure TFrmMain.Exercice1;
var
  F : TArray< string >;
  LLigne : string;
  LNumber : string;
  LColumn : SmallInt;
  LSomme : Integer;
begin
  F := TFile.ReadAllLines( FILENAME );

  LSomme := 0;

  for var i := 0 to High( F ) do
  begin
    LNumber := '';
    LLigne := F[ i ];
    for var j := 1 to Length( LLigne ) do
    begin
      if not( LLigne[ j ] in DIGITS ) then
      begin
        if ( LNumber <> '' ) and IsPartNumber( LNumber, F, i, j - Length( LNumber ) ) then
        begin
          LSomme := LSomme + LNumber.ToInteger;
        end;

        LNumber := '';
      end
      else
      begin
        if LNumber = '' then
        begin
          LColumn := j;
        end;

        LNumber := LNumber + LLigne[ j ];
      end;
    end;

    if ( LNumber <> '' ) and IsPartNumber( LNumber, F, i, Length( LLigne ) - Length( LNumber ) ) then
    begin
      LSomme := LSomme + LNumber.ToInteger;
    end;
  end;

  Edt1.Text := LSomme.ToString;
end;

procedure TFrmMain.Exercice2;
var
  F : TArray< string >;
  LLigne : string;
  LSomme : Integer;
begin
  F := TFile.ReadAllLines( FILENAME );

  LSomme := 0;

  for var i := 0 to High( F ) do
  begin
    LLigne := F[ i ];
    for var j := 1 to Length( LLigne ) do
    begin
      // On trouve une étoile et elle est adjacente à 3 part numbers
      if ( LLigne[ j ] = GEAR ) and ( NumberDigits( F, i, j ) = 2 ) then
      begin
        LSomme := LSomme + Ratio( F, i, j );
      end;
    end;
  end;

  Edt2.Text := LSomme.ToString;
end;

function TFrmMain.GetPartNumber( aString : string; aColumn : SmallInt ) : Integer;
var
  LColumn : SmallInt;
  LResult : string;
begin
  // On cherche la colonne de départ
  LColumn := aColumn;
  if LColumn > 1 then
  begin
    while ( ( LColumn - 1 ) > 0 ) and ( aString[ LColumn - 1 ] in DIGITS ) do
    begin
      Dec( LColumn );
    end;
  end;

  // On extrait le part number
  Dec( LColumn );

  LResult := '';
  repeat
    Inc( LColumn );

    LResult := LResult + aString[ LColumn ];
  until ( ( LColumn + 1 > aString.Length ) or not( aString[ LColumn + 1 ] in DIGITS ) );

  if ( LResult <> '' ) then
  begin
    Result := LResult.ToInteger;
  end;
end;

function TFrmMain.IsPartNumber( aNumber : string; aFile : TArray< string >; aLine,
  aColumn : SmallInt ) : Boolean;
var
  LBeginColumn,
    LEndColumn,
    LBeginLine,
    LEndLine : SmallInt;
begin
  Result := False;

  // On détermine le coin supérieur gauche
  LBeginColumn := aColumn - 1;
  if ( LBeginColumn < 1 ) then
    LBeginColumn := 1;

  LEndColumn := ( aColumn - 1 ) + aNumber.Length + 1;
  if ( LEndColumn > aFile[ aLine ].Length ) then
    LEndColumn := aFile[ aLine ].Length;

  // On détermine la ligne de début et la ligne de fin pour la recherche
  LBeginLine := aLine - 1;
  if ( LBeginLine < 0 ) then
    LBeginLine := 0;

  LEndLine := aLine + 1;
  if LEndLine > High( aFile ) then
    LEndLine := LEndLine - 1;

  for var i := LBeginLine to LEndLine do
  begin
    for var j := LBeginColumn to LEndColumn do
    begin
      if not( aFile[ i ][ j ] in OTHERS ) then
      begin
        Exit( True );
      end;
    end;
  end;
end;

function TFrmMain.NumberDigits( aFile : TArray< string >; aLine,
  aColumn : SmallInt ) : SmallInt;
begin
  Result := 0;

  // On compte combien de part number au dessus du gear
  if aLine > 0 then
  begin
    if ( aFile[ aLine - 1 ][ aColumn ] in DIGITS ) then
    begin
      Inc( Result );
    end
    else
    begin
      if ( aColumn > 1 ) and ( aFile[ aLine - 1 ][ aColumn - 1 ] in DIGITS ) then
      begin
        Inc( Result );
      end;
      if ( aColumn < aFile[ aLine ].Length ) and ( aFile[ aLine - 1 ][ aColumn + 1 ] in DIGITS ) then
      begin
        Inc( Result );
      end;
    end;
  end;

  // On compte combien de part number à côté du gear
  if ( aColumn > 1 ) and ( aFile[ aLine ][ aColumn - 1 ] in DIGITS ) then
  begin
    Inc( Result );
  end;
  if ( aColumn < aFile[ aLine ].Length ) and ( aFile[ aLine ][ aColumn + 1 ] in DIGITS ) then
  begin
    Inc( Result );
  end;

  // On compte combien de part number en dessous du gear
  if aLine < High( aFile ) then
  begin
    if ( aFile[ aLine + 1 ][ aColumn ] in DIGITS ) then
    begin
      Inc( Result );
    end
    else
    begin
      if ( aColumn > 1 ) and ( aFile[ aLine + 1 ][ aColumn - 1 ] in DIGITS ) then
      begin
        Inc( Result );
      end;
      if ( aColumn < aFile[ aLine ].Length ) and ( aFile[ aLine + 1 ][ aColumn + 1 ] in DIGITS ) then
      begin
        Inc( Result );
      end;
    end;
  end;
end;

function TFrmMain.Ratio( aFile : TArray< string >; aLine,
  aColumn : SmallInt ) : Integer;
begin
  Result := 1;

  // On compte combien de part number au dessus du gear
  if aLine > 0 then
  begin
    if ( aFile[ aLine - 1 ][ aColumn ] in DIGITS ) then
    begin
      Result := Result * GetPartNumber( aFile[ aLine - 1 ], aColumn );
    end
    else
    begin
      if ( aColumn > 1 ) and ( aFile[ aLine - 1 ][ aColumn - 1 ] in DIGITS ) then
      begin
        Result := Result * GetPartNumber( aFile[ aLine - 1 ], aColumn - 1 );
      end;
      if ( aColumn < aFile[ aLine ].Length ) and ( aFile[ aLine - 1 ][ aColumn + 1 ] in DIGITS ) then
      begin
        Result := Result * GetPartNumber( aFile[ aLine - 1 ], aColumn + 1 );
      end;
    end;
  end;

  // On compte combien de part number à côté du gear
  if ( aColumn > 1 ) and ( aFile[ aLine ][ aColumn - 1 ] in DIGITS ) then
  begin
    Result := Result * GetPartNumber( aFile[ aLine ], aColumn - 1 );
  end;
  if ( aColumn < aFile[ aLine ].Length ) and ( aFile[ aLine ][ aColumn + 1 ] in DIGITS ) then
  begin
    Result := Result * GetPartNumber( aFile[ aLine ], aColumn + 1 );
  end;

  // On compte combien de part number en dessous du gear
  if aLine < High( aFile ) then
  begin
    if ( aFile[ aLine + 1 ][ aColumn ] in DIGITS ) then
    begin
      Result := Result * GetPartNumber( aFile[ aLine + 1 ], aColumn );
    end
    else
    begin
      if ( aColumn > 1 ) and ( aFile[ aLine + 1 ][ aColumn - 1 ] in DIGITS ) then
      begin
        Result := Result * GetPartNumber( aFile[ aLine + 1 ], aColumn - 1 );
      end;
      if ( aColumn < aFile[ aLine ].Length ) and ( aFile[ aLine + 1 ][ aColumn + 1 ] in DIGITS ) then
      begin
        Result := Result * GetPartNumber( aFile[ aLine + 1 ], aColumn + 1 );
      end;
    end;
  end;
end;

end.
