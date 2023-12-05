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
    procedure Exercice1( aMaxRed, aMaxGreen, aMaxBlue : SmallInt );
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

{$R *.dfm}


procedure TFrmMain.BtnExercice1Click( Sender : TObject );
begin
  Exercice1( 12, 13, 14 );
end;

procedure TFrmMain.BtnExercice2Click( Sender : TObject );
begin
  Exercice2;
end;

procedure TFrmMain.Exercice1( aMaxRed, aMaxGreen, aMaxBlue : SmallInt );
var
  F : TArray< string >;
  wGame : TArray< string >;
  wCouleur : TArray< string >;
  wGameOk : Boolean;
  wSomme : Integer;
  wF : TextFile;
begin
  F := TFile.ReadAllLines( FILENAME );

  wGameOk := True;

  wSomme := 0;
  for var i := 0 to High( F ) do
  begin
    wGame := F[ i ].Split( [ ':', ';', ',' ] );

    for var j := 1 to High( wGame ) do
    begin
      wCouleur := wGame[ j ].Trim.Split( [ ' ' ] );
      wGameOk := ( ( wCouleur[ 1 ].ToUpper = 'RED' ) and ( wCouleur[ 0 ].ToInteger <= aMaxRed )
        or ( wCouleur[ 1 ].ToUpper = 'GREEN' ) and ( wCouleur[ 0 ].ToInteger <= aMaxGreen )
        or ( wCouleur[ 1 ].ToUpper = 'BLUE' ) and ( wCouleur[ 0 ].ToInteger <= aMaxBlue )
        );

      if not( wGameOk ) then
        Break;
    end;

    if wGameOk then
    begin
      wSomme := wSomme + ( i + 1 );
      Writeln( wF, 'Game : ' + ( i + 1 ).ToString + ' ok. Somme = ' + wSomme.ToString );
    end
    else
    begin
      Writeln( wF, 'Game : ' + ( i + 1 ).ToString + ' KO' );
    end;
  end;

  Edt1.Text := wSomme.ToString;

  CloseFile( wF );
end;

procedure TFrmMain.Exercice2;
var
  F : TArray< string >;
  wGame : TArray< string >;
  wCouleur : TArray< string >;
  wProduit, wSomme : Integer;
  wMaxCouleur : TObjectDictionary< string, Integer >;
  wMax : TPair< string, Integer >;
begin
  F := TFile.ReadAllLines( FILENAME );

  wMaxCouleur := TObjectDictionary< string, Integer >.Create;

  wSomme := 0;
  for var i := 0 to High( F ) do
  begin
    wGame := F[ i ].Split( [ ':', ';', ',' ] );

    for var j := 1 to High( wGame ) do
    begin
      wCouleur := wGame[ j ].Trim.Split( [ ' ' ] );
      if wMaxCouleur.ContainsKey( wCouleur[ 1 ] ) then
      begin
        if ( wCouleur[ 0 ].ToInteger > wMaxCouleur[ wCouleur[ 1 ] ] ) then
        begin
          wMaxCouleur[ wCouleur[ 1 ] ] := wCouleur[ 0 ].ToInteger;
        end;
      end
      else
      begin
        wMaxCouleur.Add( wCouleur[ 1 ], wCouleur[ 0 ].ToInteger );
      end;
    end;

    wProduit := 1;
    for wMax in wMaxCouleur do
    begin
      wProduit := wProduit * wMax.Value
    end;
    wMaxCouleur.Clear;

    wSomme := wSomme + wProduit;
  end;

  Edt2.Text := wSomme.ToString;
end;

end.
