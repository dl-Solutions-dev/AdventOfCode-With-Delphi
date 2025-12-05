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
    FMatrix: TArray<TArray<string>>;

    function GetInputFileName: string;
    function NbRolls( x, y: Integer ): Int64;

    procedure Exercice1;
    procedure Exercice2;
    procedure LoadFile;
    procedure LoadMatrix;
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
  Communs.Helpers;

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
begin
  LoadFile;
  LoadMatrix;

  LTotal := 0;

  MmoLogs.Lines.BeginUpdate;
  try
    for var i := 0 to High( FMatrix ) do
    begin
      for var j := 0 to High( FMatrix[ i ] ) do
      begin
        if ( FMatrix[ i, j ] = '@' ) then
        begin
          if NbRolls( i, j ) < 4 then
          begin
            Inc( LTotal );
          end;
        end;
      end;
    end;
  finally
    MmoLogs.Lines.EndUpdate;
  end;

  Edt1.Text := LTotal.ToString;
  Edt1.CopyToClipboard;
end;

procedure TFrmMain.Exercice2;
var
  LTotal, LSubTotal: Int64;
  LMatrix: TArray<TArray<string>>;
begin
  LoadFile;
  LoadMatrix;

  LTotal := 0;

  MmoLogs.Lines.BeginUpdate;
  try
    // On sauvegarde la matrice
    LMatrix := TArray.CopyMatrix<string>( FMatrix );

    // On boucle jusqu'à ne trouver aucun rouleau
    repeat
      LSubTotal := 0;

      for var i := 0 to High( FMatrix ) do
      begin
        for var j := 0 to High( FMatrix[ i ] ) do
        begin
          if ( FMatrix[ i, j ] = '@' ) then
          begin
            if NbRolls( i, j ) < 4 then
            begin
              Inc( LSubTotal );

              // On enlève le rouleau de la matricé copiée
              LMatrix[ i, j ] := '.';
            end;
          end;
        end;
      end;

      // On remplace la matrice par celle modifiée pour le prochain passage
      FMatrix := TArray.CopyMatrix<string>( LMatrix );

      // On ajoute le nombre de rouleaux trouvés
      LTotal := LTotal + LSubTotal;
    until ( LSubTotal = 0 );
  finally
    MmoLogs.Lines.EndUpdate;
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

function TFrmMain.NbRolls( x, y: Integer ): Int64;
var
  LPoint: TPoint;
begin
  Result := 0;

  LPoint.x := x;
  LPoint.Y := y;

  // On compte la ligne du dessus si il y en a une
  if ( LPoint.x > 0 ) then
  begin
    LPoint.X := LPoint.x - 1;

    if ( LPoint.y > 0 ) then
    begin
      LPoint.Y := LPoint.Y - 1;
    end
    else
    begin
      LPoint.Y := LPoint.Y;
    end;

    repeat
      if ( FMatrix[ LPoint.x, LPoint.Y ] = '@' ) then
      begin
        Inc( Result );
      end;
      LPoint.Y := LPoint.Y + 1;
    until ( LPoint.Y > y + 1 ) or ( LPoint.y > High( FMatrix[ x ] ) );

    LPoint.X := x;
  end;

  // On compte de part et d'autre du point sur la même ligne
  LPoint.Y := y;

  if ( LPoint.y > 0 ) then
  begin
    if ( FMatrix[ LPoint.x, LPoint.Y - 1 ] = '@' ) then
    begin
      Inc( Result );
    end;
  end;

  if ( LPoint.y < High( FMatrix[ x ] ) ) then
  begin
    if ( FMatrix[ LPoint.x, LPoint.Y + 1 ] = '@' ) then
    begin
      Inc( Result );
    end;
  end;

  LPoint.X := x;

  // On compte la ligne d'après si il y en a une
  if ( LPoint.X < High( FMatrix ) ) then
  begin
    LPoint.X := LPoint.X + 1;

    if ( LPoint.y > 0 ) then
    begin
      LPoint.Y := LPoint.Y - 1;
    end
    else
    begin
      LPoint.Y := LPoint.Y;
    end;

    repeat
      if ( FMatrix[ LPoint.x, LPoint.Y ] = '@' ) then
      begin
        Inc( Result );
      end;
      LPoint.Y := LPoint.Y + 1;
    until ( LPoint.Y > y + 1 ) or ( LPoint.y > High( FMatrix[ x ] ) );
  end;

  MmoLogs.Lines.Add( x.ToString + ', ' + y.ToString + ' = ' + Result.ToString );
end;

end.

