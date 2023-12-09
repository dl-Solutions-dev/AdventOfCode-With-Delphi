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
    ChkTests : TCheckBox;

    procedure BtnExercice1Click( Sender : TObject );
    procedure BtnExercice2Click( Sender : TObject );
    procedure FormCreate( Sender : TObject );
    procedure FormClose( Sender : TObject; var Action : TCloseAction );
  private
    FValueCard : TStrings;
    FCountCards : TStrings;

    { Déclarations privées }
    function GetInputFileName : string;
    function GetTypeHand( aHand : string; aJoker : char ) : int64;
    function GetValueHand( aHand : string; aJoker : char ) : int64;
    function GetSomme( F : TArray< string >; aJoker : char ) : int64;

    procedure Exercice1;
    procedure Exercice2;
  public
    { Déclarations publiques }
  end;

var
  FrmMain : TFrmMain;

implementation

uses
  System.IOUtils, System.StrUtils, System.Generics.Defaults, System.Generics.Collections, System.Math;

const
  FILENAME : string = '.\input.txt';
  TESTS_FILENAME : string = '.\input_Tests.txt';
  CARD : TSysCharSet = [ '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'T' ];
  TYPE_HAND : TSysCharSet = [ 'A', 'B' ];

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
  LHands : TArray< string >;
  LGame : TArray< TArray< int64 > >;
  LSomme : int64;
begin
  // On initialise les valeur des cartes
  FValueCard := TStringList.Create;
  FValueCard.Values[ 'A' ] := '14';
  FValueCard.Values[ 'K' ] := '13';
  FValueCard.Values[ 'Q' ] := '12';
  FValueCard.Values[ 'J' ] := '11';
  FValueCard.Values[ 'T' ] := '10';
  FValueCard.Values[ '9' ] := '9';
  FValueCard.Values[ '8' ] := '8';
  FValueCard.Values[ '7' ] := '7';
  FValueCard.Values[ '6' ] := '6';
  FValueCard.Values[ '5' ] := '5';
  FValueCard.Values[ '4' ] := '4';
  FValueCard.Values[ '3' ] := '3';
  FValueCard.Values[ '2' ] := '2';

  // Appel sans joker
  Edt1.Text := GetSomme( F, ' ' ).ToString;
end;

procedure TFrmMain.Exercice2;
var
  F : TArray< string >;
  LHands : TArray< string >;
  LGame : TArray< TArray< int64 > >;
  LSomme : int64;
begin
  // On initialise les valeur des cartes
  FValueCard := TStringList.Create;
  FValueCard.Values[ 'A' ] := '14';
  FValueCard.Values[ 'K' ] := '13';
  FValueCard.Values[ 'Q' ] := '12';
  FValueCard.Values[ 'J' ] := '1';
  FValueCard.Values[ 'T' ] := '10';
  FValueCard.Values[ '9' ] := '9';
  FValueCard.Values[ '8' ] := '8';
  FValueCard.Values[ '7' ] := '7';
  FValueCard.Values[ '6' ] := '6';
  FValueCard.Values[ '5' ] := '5';
  FValueCard.Values[ '4' ] := '4';
  FValueCard.Values[ '3' ] := '3';
  FValueCard.Values[ '2' ] := '2';

  // Appel avec joker
  Edt2.Text := GetSomme( F, 'J' ).ToString;
end;

procedure TFrmMain.FormClose( Sender : TObject; var Action : TCloseAction );
begin
  FreeAndNil( FValueCard );
  FreeAndNil( FCountCards );
end;

procedure TFrmMain.FormCreate( Sender : TObject );
begin

  FCountCards := TStringList.Create;
end;

function TFrmMain.GetInputFileName : string;
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

function TFrmMain.GetSomme( F : TArray< string >; aJoker : char ) : int64;
var
  LHands : TArray< string >;
  LGame : TArray< TArray< int64 > >;
begin
  try
    F := TFile.ReadAllLines( GetInputFileName );

    SetLength( LGame, 0 );

    for var i := 0 to High( F ) do
    begin
      LHands := F[ i ].Split( [ ' ' ] );

      SetLength( LGame, Length( LGame ) + 1 );
      SetLength( LGame[ High( LGame ) ], 2 );

      // On valorise la carte
      LGame[ High( LGame ) ][ 0 ] := GetValueHand( LHands[ 0 ], aJoker );
      // On stocke son bid amount
      LGame[ High( LGame ) ][ 1 ] := LHands[ 1 ].ToInteger;
    end;
  finally
    FreeAndNil( FValueCard );
  end;

  // On tri le tableau obtenu sur le poids des cartes
  TArray.Sort < TArray < int64 >> ( TArray< TArray< int64 > >( LGame ), TComparer < TArray < int64 >>.Construct(
    function( const aLeft, aRight : TArray< int64 > ) : Integer
    begin
      if ( aLeft[ 0 ] < aRight[ 0 ] ) then
      begin
        Result := -1
      end
      else if ( aLeft[ 0 ] > aRight[ 0 ] ) then
      begin
        Result := 1;
      end
      else
      begin
        Result := 0;
      end;
    end ) );

  // On multiplie les valeur par leur rank et on additionne
  Result := 0;
  for var i := 0 to High( LGame ) do
  begin
    Result := Result + ( LGame[ i, 1 ] * ( i + 1 ) );
  end;
end;

function TFrmMain.GetTypeHand( aHand : string; aJoker : char ) : int64;
var
  LCountCards : TArray< Integer >;
  LSumCounts : TArray< Integer >;
  LJokers : smallint;
  LMax, LIndiceMax : smallint;
begin
  SetLength( LCountCards, 90 );
  SetLength( LSumCounts, 6 );
  LJokers := 0;

  // On compte les cartes identiques et on compte le joker à part
  for var i := 1 to High( aHand ) do
  begin
    if ( ord( aHand[ i ] ) <> ord( aJoker ) ) then
    begin
      Inc( LCountCards[ ord( aHand[ i ] ) ] );
    end
    else
    begin
      Inc( LJokers );
    end;
  end;

  // On va ajouter le joker à la plus grosse possibilité
  if ( aJoker <> ' ' ) and ( LJokers > 0 ) then
  begin
    if LJokers = 5 then
    begin
      // Si il y a 5 jokers alors ça donne forcément un Five of kind
      LCountCards[ 0 ] := 5;
    end
    else
    begin
      // On ajoute les jokers à la carte ayant le type donnant le plus de points
      LMax := 0;
      LIndiceMax := -1;
      for var i := 0 to High( LCountCards ) do
      begin
        if ( LCountCards[ i ] > LMax ) then
        begin
          LMax := LCountCards[ i ];
          LIndiceMax := i;
        end;
      end;

      if LIndiceMax > -1 then // au cas où
      begin
        LCountCards[ LIndiceMax ] := LCountCards[ LIndiceMax ] + LJokers;
      end;
    end;
  end;

  // On regarde combien on a de pair, de high card, etc
  for var i := 0 to High( LCountCards ) do
  begin
    case LCountCards[ i ] of
      1 :
        Inc( LSumCounts[ 1 ] );
      2 :
        Inc( LSumCounts[ 2 ] );
      3 :
        Inc( LSumCounts[ 3 ] );
      4 :
        Inc( LSumCounts[ 4 ] );
      5 :
        Inc( LSumCounts[ 5 ] );
    end;
  end;

  Result := 0;

  if LSumCounts[ 1 ] = 5 then
  begin
    Result := 15; // High Card
  end
  else if LSumCounts[ 2 ] = 1 then
  begin
    if LSumCounts[ 3 ] = 1 then
    begin
      Result := 19; // FullHouse
    end
    else
    begin
      Result := 16; // One Pair
    end;
  end
  else if LSumCounts[ 2 ] = 2 then
  begin
    Result := 17; // Two pair
  end
  else if ( LSumCounts[ 3 ] = 1 ) then
  begin
    Result := 18; // Three of a kinf
  end
  else if ( LSumCounts[ 4 ] = 1 ) then
  begin
    Result := 20; // Four of a kind
  end
  else if ( LSumCounts[ 5 ] = 1 ) then
  begin
    Result := 21; // Five of a kind
  end;
end;

function TFrmMain.GetValueHand( aHand : string; aJoker : char ) : int64;
begin
  // On va voir le poids lié au type de main
  Result := GetTypeHand( aHand, aJoker );

  // On constitue le poids total en ajoutant le poids de chaque carte au poids du type de main
  for var i := 1 to High( aHand ) do
  begin
    Result := Result * 100 + FValueCard.Values[ aHand[ i ] ].ToInteger;
  end;
end;

end.
