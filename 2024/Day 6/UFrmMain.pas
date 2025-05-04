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
  System.Generics.Collections,
  UGardianWalk,
  Communs.Helpers;

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
    FIncLine: Integer;
    FIncCol: Integer;
    FBlocs: TArray< TPoint >;
    FRoom: TArray< string >;
    FPath: TArray< TPoint >;
    FNbPossibleLoops: Integer;

    function GetInputFileName: string;

    procedure Exercice1;
    procedure Exercice2;
    procedure LoadFile;
    procedure ShowResult( aNbStep: Integer; aNewMatrice: TArray< string >; aPath: TArray< TPoint >; aLoop: Boolean );
    procedure CheckLoop( aNbStep: Integer; aNewMatrice: TArray< string >; aPath: TArray< TPoint >; aLoop: Boolean );
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

procedure TFrmMain.ShowResult( aNbStep: Integer;
  aNewMatrice: TArray< string >; aPath: TArray< TPoint >; aLoop: Boolean );
begin
  for var i := 0 to High( aNewMatrice ) do
  begin
    MmoLogs.lines.Add( FormatFloat( '000', i ) + ' - ' + aNewMatrice[ i ] );
  end;

  FRoom := aNewMatrice;
  FPath := aPath;
  Edt1.Text := aNbStep.ToString;
  Edt1.CopyToClipboard;
end;

procedure TFrmMain.BtnExercice1Click( Sender: TObject );
begin
  Exercice1;
end;

procedure TFrmMain.BtnExercice2Click( Sender: TObject );
begin
  Exercice2;
end;

procedure TFrmMain.CheckLoop( aNbStep: Integer; aNewMatrice: TArray< string >;
  aPath: TArray< TPoint >; aLoop: Boolean );
begin
  if aLoop then
  begin
    Inc( FNbPossibleLoops );
  end;

  // SetLength( aPath, 0 );
  // SetLength( aNewMatrice, 0 );
end;

procedure TFrmMain.Exercice1;
var
  F: TArray< string >;
  LThread: TGuardianWalk;
begin
  F := TFile.ReadAllLines( GetInputFileName );

  MmoLogs.Clear;

  LThread := TGuardianWalk.Create( True );
  LThread.Room := F;
  LThread.EndProc := ShowResult;
  LThread.Start;

  LThread.WaitFor;

  FreeAndNil( LThread );
end;

procedure TFrmMain.Exercice2;
var
  F, LRoom: TArray< string >;
  LThread: TGuardianWalk;
  LThreadList: TThreadList< TGuardianWalk >;
begin
  F := TFile.ReadAllLines( GetInputFileName );

  FNbPossibleLoops := 0;

  MmoLogs.Clear;

  // partie 1 On mémorise le parcours du garde
  SetLength( LRoom, Length( F ) );
  TArray.Copy< string >( F, LRoom, Length( F ) );

  LThread := TGuardianWalk.Create( True );
  LThread.Room := LRoom;
  LThread.EndProc := ShowResult;
  LThread.Start;

  LThread.WaitFor;

  FreeAndNil( LThread );

  LThreadList := TThreadList< TGuardianWalk >.Create;

  // Partie 2 : on va faire tous les parcours en plaçant un bloc à chaque step
  for var i := 1 to High( FPath ) do
  begin
    SetLength( LRoom, Length( F ) );
    TArray.Copy< string >( F, LRoom, Length( F ) );

    // On ajoute le bloc
    LRoom[ FPath[ i ].X, FPath[ i ].Y ] := '#';

    // On fait le parcours pour voir si ça boucle
    LThread := TGuardianWalk.Create( True );
    LThread.Room := LRoom;
    LThread.EndProc := CheckLoop;
    LThread.Start;

    LThreadList.Add( LThread );

    // On limite à 100 threads simultanés
    with LThreadList.LockList do
    begin
      if Count > 100 then
      begin
        for var j := 0 to Count - 1 do
        begin
          Items[ j ].WaitFor;
        end;

        Clear;
      end;
    end;
    LThreadList.UnlockList;
  end;

  // On attend la fin de l'exécution, des derniers threads
  with LThreadList.LockList do
  begin
    for var i := 0 to Count - 1 do
    begin
      Items[ i ].WaitFor;
    end;

    Clear;
  end;

  Edt2.Text := FNbPossibleLoops.ToString;
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

end.
