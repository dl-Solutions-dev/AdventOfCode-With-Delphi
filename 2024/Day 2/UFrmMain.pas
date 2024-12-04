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
    BtnSaveLogs: TButton;
    DlgSaveLogs: TSaveDialog;

    procedure BtnExercice1Click( Sender: TObject );
    procedure BtnExercice2Click( Sender: TObject );
    procedure BtnSaveLogsClick( Sender: TObject );
  private
    { Déclarations privées }
    FFile: TArray< string >;

    function GetInputFileName: string;
    function IsSafeLine( aLine: string; aDampenerActif: Boolean = False ): Integer;

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
  ShellApi;

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

procedure TFrmMain.BtnSaveLogsClick( Sender: TObject );
begin
  if DlgSaveLogs.Execute( ) then
  begin
    MmoLogs.Lines.SaveToFile( DlgSaveLogs.FILENAME );
    ShellExecute( Handle, 'open', PChar( DlgSaveLogs.FILENAME ), nil, nil, SW_SHOWNORMAL );
  end;
end;

procedure TFrmMain.Exercice1;
var
  F: TArray< string >;
  LTotal: Integer;
begin
  F := TFile.ReadAllLines( GetInputFileName );

  LTotal := 0;

  for var i := 0 to High( F ) do
  begin
    LTotal := LTotal + IsSafeLine( F[ i ] );
  end;

  Edt1.Text := LTotal.ToString;
  Edt1.CopyToClipboard;
end;

procedure TFrmMain.Exercice2;
var
  F: TArray< string >;
  LTotal: Integer;
begin
  F := TFile.ReadAllLines( GetInputFileName );

  MmoLogs.Lines.Clear;

  LTotal := 0;

  for var i := 0 to High( F ) do
  begin
    LTotal := LTotal + IsSafeLine( F[ i ], True );
    MmoLogs.Lines.Add( ' ' );
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

function TFrmMain.IsSafeLine( aLine: string; aDampenerActif: Boolean = False ): Integer;
var
  LLevels: TArray< string >;
  LLevelsN: TArray< Integer >;
  i, j: Integer;
  LDiff, LDiffPrec: Integer;
  LNewReport, LSpace: string;
begin
  Result := 1;

  LLevels := aLine.Split( [ ' ' ] );

  SetLength( LLevelsN, 0 );

  for i := 0 to High( LLevels ) do
  begin
    SetLength( LLevelsN, Length( LLevelsN ) + 1 );
    LLevelsN[ High( LLevelsN ) ] := StrToInt( LLevels[ i ] );
  end;

  LDiffPrec := 0;

  for i := 0 to High( LLevelsN ) - 1 do
  begin
    LDiff := LLevelsN[ i + 1 ] - LLevelsN[ i ];

    if ( Abs( LDiff ) < 1 ) or ( Abs( LDiff ) > 3 ) then
    begin
      MmoLogs.Lines.Add( aLine + ' - ' + IntToStr( LLevelsN[ i + 1 ] ) + ' -> ' + IntToStr( LLevelsN[ i ] ) + ' Ecart trop important ' + Abs( LDiff )
        .ToString );

      if aDampenerActif then
      begin
        LNewReport := '';
        LSpace := '';

        for j := 0 to High( LLevelsN ) do
        begin
          if ( j <> i ) then
          begin
            LNewReport := LNewReport + LSpace + IntToStr( LLevelsN[ j ] );
            LSpace := ' ';
          end;
        end;

        MmoLogs.Lines.Add( 'Tentative avec LNewReport ' + LNewReport );

        Result := IsSafeLine( LNewReport );

        if ( Result = 0 ) then
        begin
          LNewReport := '';
          LSpace := '';

          for j := 0 to High( LLevelsN ) do
          begin
            if ( j <> i + 1 ) then
            begin
              LNewReport := LNewReport + LSpace + IntToStr( LLevelsN[ j ] );
              LSpace := ' ';
            end;
          end;

          MmoLogs.Lines.Add( 'Tentative avec LNewReport ' + LNewReport );

          Exit( IsSafeLine( LNewReport ) );
        end
        else
        begin
          Exit( 1 );
        end;
      end
      else
      begin
        Exit( 0 );
      end;
    end;

    if ( LDiffPrec = 0 ) or ( LDiff * LDiffPrec > 0 ) then
    begin
      LDiffPrec := LDiff;
    end
    else
    begin
      MmoLogs.Lines.Add( aLine + ' Inversement' );

      if aDampenerActif then
      begin
        LNewReport := '';
        LSpace := '';

        for j := 0 to High( LLevelsN ) do
        begin
          if ( j <> i ) then
          begin
            LNewReport := LNewReport + LSpace + IntToStr( LLevelsN[ j ] );
            LSpace := ' ';
          end;
        end;

        MmoLogs.Lines.Add( 'Tentative avec LNewReport ' + LNewReport );

        Result := IsSafeLine( LNewReport );

        if ( Result = 0 ) then
        begin
          LNewReport := '';
          LSpace := '';

          for j := 0 to High( LLevelsN ) do
          begin
            if ( j <> i - 1 ) then
            begin
              LNewReport := LNewReport + LSpace + IntToStr( LLevelsN[ j ] );
              LSpace := ' ';
            end;
          end;

          MmoLogs.Lines.Add( 'Tentative avec LNewReport ' + LNewReport );

          Result := IsSafeLine( LNewReport );

          if ( Result = 0 ) then
          begin
            LNewReport := '';
            LSpace := '';

            for j := 0 to High( LLevelsN ) do
            begin
              if ( j <> i + 1 ) then
              begin
                LNewReport := LNewReport + LSpace + IntToStr( LLevelsN[ j ] );
                LSpace := ' ';
              end;
            end;

            MmoLogs.Lines.Add( 'Tentative avec LNewReport ' + LNewReport );

            Exit( IsSafeLine( LNewReport ) );
          end
          else
          begin
            Exit( 1 );
          end;
        end
        else
        begin
          Exit( 1 );
        end;
      end
      else
      begin
        Exit( 0 );
      end;
    end;
  end;

  MmoLogs.Lines.Add( 'Safe' );
end;

procedure TFrmMain.LoadFile;
begin
  FFile := TFile.ReadAllLines( GetInputFileName );
end;

end.
