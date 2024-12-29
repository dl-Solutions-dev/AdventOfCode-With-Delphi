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
    FLocks: TArray< TArray< integer > >;
    FKeys: TArray< TArray< integer > >;

    function GetInputFileName: string;

    procedure Exercice1;
    procedure Exercice2;
    procedure LoadFile;
    procedure LoadLocksAndKeys;
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
  LFit: Boolean;
begin
  LoadFile;

  LoadLocksAndKeys;

  LTotal := 0;

  for var i := 0 to High( FKeys ) do
  begin
    for var j := 0 to High( FLocks ) do
    begin
      LFit := True;

      for var k := 0 to 4 do
      begin
        // Si la somme des hauteurs d'au moins une colonne de la serrure et de la clé est > 5
        // alors la clé ne peut pas ouvrir la serrure parce qu'il y a chevauchement
        if ( FKeys[ i, k ] + FLocks[ j, k ] > 5 ) then
        begin
          LFit := False;
        end;
      end;

      if LFit then
      begin
        Inc( LTotal );
      end;
    end;
  end;

  Edt1.Text := LTotal.ToString;
  Edt1.CopyToClipboard;
end;

procedure TFrmMain.Exercice2;
var
  LTotal: Int64;
begin
  LoadFile;

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

procedure TFrmMain.LoadLocksAndKeys;
var
  LLine: integer;
begin
  LLine := 0;
  while ( LLine < High( FFile ) ) do
  begin
    if ( FFile[ LLine ] = '#####' ) then
    begin
      SetLength( FLocks, Length( FLocks ) + 1 );
      SetLength( FLocks[ High( FLocks ) ], 5 );

      for var i := 0 to 4 do
      begin
        FLocks[ High( FLocks ), i ] := 0;
      end;

      for var i := LLine + 1 to LLine + 5 do
      begin
        for var j := 1 to Length( FFile[ i ] ) do
        begin
          if ( FFile[ i, j ] = '#' ) then
          begin
            FLocks[ High( FLocks ), j - 1 ] := FLocks[ High( FLocks ), j - 1 ] + 1;
          end;
        end;
      end;

      Inc( LLine, 8 );
    end
    else
    begin
      SetLength( FKeys, Length( FKeys ) + 1 );
      SetLength( FKeys[ High( FKeys ) ], 5 );

      for var i := 0 to 4 do
      begin
        FKeys[ High( FKeys ), i ] := 0;
      end;

      for var i := LLine + 1 to LLine + 5 do
      begin
        for var j := 1 to Length( FFile[ i ] ) do
        begin
          if ( FFile[ i, j ] = '#' ) then
          begin
            FKeys[ High( FKeys ), j - 1 ] := FKeys[ High( FKeys ), j - 1 ] + 1;
          end;
        end;
      end;

      Inc( LLine, 8 );
    end;
  end;
end;

end.
