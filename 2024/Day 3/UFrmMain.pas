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
    function GetMultiplication( aOperation: string ): LongInt;

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
  System.Math,
  RegularExpressions;

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
  F: TArray< string >;
  LTotal: LongInt;
  LMatch: TMatch;
begin
  MmoLogs.Lines.Clear;

  F := TFile.ReadAllLines( GetInputFileName );

  LTotal := 0;

  for var i := 0 to High( F ) do
  begin
    LMatch := TRegEx.Match( F[ i ], 'mul\([ ]*[\d]*[ ]*\,[ ]*[\d]*[ ]*\)' );

    while LMatch.Success do
    begin
      LTotal := LTotal + GetMultiplication( LMatch.Value );

      LMatch := LMatch.NextMatch;
    end;
  end;

  Edt1.Text := LTotal.ToString;
  Edt1.CopyToClipboard;
end;

procedure TFrmMain.Exercice2;
var
  F: TArray< string >;
  LTotal: LongInt;
  LMatch: TMatch;
  LPatern1, LPatern2, LPatern3: string;
  LEnabled: Boolean;
begin
  MmoLogs.Lines.Clear;

  F := TFile.ReadAllLines( GetInputFileName );

  LTotal := 0;

  LPatern1 := 'do\(\)';
  LPatern2 := 'don\' + '''' + 't\(\)';
  LPatern3 := 'mul\([ ]*[\d]*[ ]*\,[ ]*[\d]*[ ]*\)';

  LEnabled := True;

  for var i := 0 to High( F ) do
  begin
    LMatch := TRegEx.Match( F[ i ], LPatern1 + '|' + LPatern2 + '|' + LPatern3 );

    while LMatch.Success do
    begin
      if LMatch.Value = 'do()' then
      begin
        LEnabled := True;
      end
      else if LMatch.Value = 'don''t()' then
      begin
        LEnabled := False;
      end
      else if LEnabled then
      begin
        LTotal := LTotal + GetMultiplication( LMatch.Value );
      end;

      LMatch := LMatch.NextMatch;
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

function TFrmMain.GetMultiplication( aOperation: string ): LongInt;
var
  LMatch: TMatch;
  wOpe1, wOpe2: Integer;
begin
  wOpe1 := 0;
  wOpe2 := 0;

  LMatch := TRegEx.Match( aOperation, '[\d]*' );

  if LMatch.Success then
  begin
    wOpe1 := LMatch.Value.ToInteger;
  end;

  LMatch := LMatch.NextMatch;

  if LMatch.Success then
  begin
    wOpe2 := LMatch.Value.ToInteger;
  end;

  Result := wOpe1 * wOpe2;

  MmoLogs.Lines.Add( aOperation + ' -> ' + wOpe1.ToString + ' * ' + wOpe2.ToString + ' = ' + Result.ToString );
end;

procedure TFrmMain.LoadFile;
begin
  FFile := TFile.ReadAllLines( GetInputFileName );
end;

end.
