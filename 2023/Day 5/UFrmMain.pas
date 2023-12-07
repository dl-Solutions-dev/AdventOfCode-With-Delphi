unit UFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, UClasses;

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
    function GetLocation( F : TArray< string >; var aSeeds : TArray< Int64 >; var aTranslators : TArray< TTranslator > ) : Int64;

    procedure Exercice1;
    procedure Exercice2;
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
  DIGITS : TSysCharSet = [ '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' ];

{$R *.dfm}
  { TFrmMain }

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
  LSeeds : TArray< Int64 >;
  LLigne : TArray< String >;
  LTranslators : TArray< TTranslator >;
  LRanges : TArray< string >;
begin
  F := TFile.ReadAllLines( FILENAME );

  // Creation des translateurs
  for var i := 2 to High( F ) do
  begin
    if ( F[ i ].Length > 0 ) and ( F[ i ][ 1 ] <> ' ' ) then
    begin
      if ( CharInSet( F[ i ][ 1 ], DIGITS ) ) then
      begin
        LRanges := F[ i ].Split( [ ' ' ] );
        LTranslators[ High( LTranslators ) ].AddRule( LRanges[ 1 ].ToInt64, LRanges[ 0 ].ToInt64, LRanges[ 2 ].ToInt64 );
      end
      else
      begin
        SetLength( LTranslators, Length( LTranslators ) + 1 );
        LTranslators[ High( LTranslators ) ] := TTranslator.Create;
      end;
    end;
  end;

  LLigne := F[ 0 ].Split( [ ':', ' ' ] );
  SetLength( LSeeds, Length( LLigne ) - 2 );

  for var i := 2 to High( LLigne ) do
  begin
    LSeeds[ i - 2 ] := LLigne[ i ].ToInt64;
  end;

  Edt1.Text := GetLocation( F, LSeeds, LTranslators ).ToString;

  // On libère les tranlateurs
  for var i := 0 to High( LTranslators ) do
  begin
    LTranslators[ i ].Free;
  end;
end;

procedure TFrmMain.Exercice2;
var
  F : TArray< string >;
  LLigne : TArray< String >;
  i : Integer;
  LTranslators : TArray< TTranslator >;
  LSeeds : TArray< Int64 >;
  LRanges : TArray< string >;
  LMinLocation : Int64;
  LLocation : Int64;
begin
  Screen.Cursor := crHourGlass;
  try
    F := TFile.ReadAllLines( FILENAME );

    // Creation des translateurs
    for i := 2 to High( F ) do
    begin
      if ( F[ i ].Length > 0 ) and ( F[ i ][ 1 ] <> ' ' ) then
      begin
        if ( CharInSet( F[ i ][ 1 ], DIGITS ) ) then
        begin
          LRanges := F[ i ].Split( [ ' ' ] );
          LTranslators[ High( LTranslators ) ].AddRule( LRanges[ 1 ].ToInt64, LRanges[ 0 ].ToInt64, LRanges[ 2 ].ToInt64 );
        end
        else
        begin
          SetLength( LTranslators, Length( LTranslators ) + 1 );
          LTranslators[ High( LTranslators ) ] := TTranslator.Create;
        end;
      end;
    end;

    LLigne := F[ 0 ].Split( [ ':', ' ' ] );

    LMinLocation := 9223372036854775807;

    i := 2;
    while i < high( LLigne ) - 1 do
    begin
      SetLength( LSeeds, LLigne[ i + 1 ].ToInt64 );

      for var j := 0 to LLigne[ i + 1 ].ToInt64 - 1 do
      begin
        LSeeds[ j ] := LLigne[ i ].ToInt64 + j;
      end;

      LLocation := GetLocation( F, LSeeds, LTranslators );

      if ( LLocation < LMinLocation ) then
      begin
        LMinLocation := LLocation;
      end;

      inc( i, 2 );
    end;

    Edt2.Text := LMinLocation.ToString;

    // On libère les tranlateurs
    for i := 0 to High( LTranslators ) do
    begin
      LTranslators[ i ].Free;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

function TFrmMain.GetLocation( F : TArray< string >; var aSeeds : TArray< Int64 >; var aTranslators : TArray< TTranslator > ) : Int64;
var
  LLocation : Int64;
begin
  Result := 9223372036854775807;

  for var i := 0 to High( aSeeds ) do
  begin
    LLocation := aSeeds[ i ];
    for var j := 0 to High( aTranslators ) do
    begin
      LLocation := aTranslators[ j ].Translate( LLocation );
    end;

    if ( LLocation < Result ) then
    begin
      Result := LLocation;
    end;
  end;
end;

end.
