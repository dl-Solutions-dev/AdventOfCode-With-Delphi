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
    FMap: TArray< Integer >;
    FBlocs: TArray< TQueue< Integer > >;

    function GetInputFileName: string;
    function CreateMap( aDisk: string ): TArray< Integer >;
    function MoveBlock( aSize, aFileId, aPos: Integer; out aPosFin: Integer ): Boolean;

    procedure Exercice1;
    procedure Exercice2;
    procedure LoadFile;
    procedure Defragmenter;
    procedure DefragmenterMieux;
    procedure LogMap;
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

function TFrmMain.CreateMap( aDisk: string ): TArray< Integer >;
var
  LIdFile: Integer;
  LFile: Boolean;
  LCar, LPos, LSize, LInd: Integer;
begin
  SetLength( Result, 0 );

  LIdFile := -1;
  LFile := True;

  for var i := 1 to Length( aDisk ) do
  begin
    if LFile then
    begin
      inc( LIdFile );
      LCar := LIdFile;
    end
    else
    begin
      LCar := -1;
    end;

    LPos := Length( Result );

    SetLength( Result, Length( Result ) + StrToInt( aDisk[ i ] ) );

    LSize := 0;
    LInd := LPos;
    for var j := 0 to StrToInt( aDisk[ i ] ) - 1 do
    begin
      Result[ LPos ] := LCar;
      inc( LPos );
      inc( LSize );
    end;

    LFile := not( LFile );
  end;
end;

procedure TFrmMain.Defragmenter;
var
  LCurLeft, LCurRight: Integer;
begin
  LCurLeft := 0;
  LCurRight := High( FMap );

  while ( LCurLeft < LCurRight ) do
  begin
    while ( LCurLeft < LCurRight ) and ( FMap[ LCurLeft ] <> -1 ) do
    begin
      inc( LCurLeft );
    end;

    if ( FMap[ LCurLeft ] = -1 ) then
    begin
      FMap[ LCurLeft ] := FMap[ LCurRight ];
      FMap[ LCurRight ] := -1;

      while ( LCurRight > LCurLeft ) and ( FMap[ LCurRight ] = -1 ) do
      begin
        Dec( LCurRight );
      end;
    end;
  end;
end;

procedure TFrmMain.DefragmenterMieux;
var
  LCurRight, LMFile, LSize, LEnd, LPosFin: Integer;
  LFileMoved: TArray< Integer >;
begin
  LCurRight := High( FMap );

  while ( LCurRight > 0 ) do
  begin
    while ( FMap[ LCurRight ] = -1 ) and ( LCurRight > 0 ) do
    begin
      Dec( LCurRight );
    end;

    LMFile := FMap[ LCurRight ];
    if ( TArray.IndexOf< Integer >( LFileMoved, LMFile ) = -1 ) then
    begin
      LEnd := LCurRight;
      LSize := 0;
      while ( LCurRight > 0 ) and ( FMap[ LCurRight ] = LMFile ) do
      begin
        inc( LSize );
        Dec( LCurRight );
      end;

      if MoveBlock( LSize, LMFile, LCurRight, LPosFin ) then
      begin
        TArray.Add< Integer >( LFileMoved, LMFile );

        for var i := LCurRight + 1 to LEnd do
        begin
          FMap[ i ] := -1;
        end;
      end;
    end
    else
    begin
      Dec( LCurRight );
    end;

    //LogMap;
  end;
end;

procedure TFrmMain.Exercice1;
var
  LTotal: Int64;
begin
  LoadFile;

  FMap := CreateMap( FFile[ 0 ] );

  Defragmenter;

  LTotal := 0;

  for var i := 0 to High( FMap ) do
  begin
    if FMap[ i ] = -1 then
    begin
      Break;
    end;

    LTotal := LTotal + ( i * FMap[ i ] );
  end;

  Edt1.Text := LTotal.ToString;
  Edt1.CopyToClipboard;
end;

// TODO: à revoir, trop long et ne fonctione peut-être même pas
procedure TFrmMain.Exercice2;
var
  LTotal: Int64;
begin
  LoadFile;

  // MmoLogs.clear;

  FMap := CreateMap( FFile[ 0 ] );

  DefragmenterMieux;

  LogMap;

  LTotal := 0;

  for var i := 0 to High( FMap ) do
  begin
    if FMap[ i ] <> -1 then
    begin
      LTotal := LTotal + ( i * FMap[ i ] );
    end;
  end;

  Edt2.Text := LTotal.ToString;
  Edt2.CopyToClipboard;

  // 6362722794017 -> trop grand
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

procedure TFrmMain.LogMap;
var
  LMap: string;
begin
  LMap := '';

  for var i := 0 to High( FMap ) do
  begin
    if ( FMap[ i ] <> -1 ) then
    begin
      LMap := LMap + FMap[ i ].ToString;
    end
    else
    begin
      LMap := LMap + '.';
    end;
  end;

  MmoLogs.Lines.Add( LMap );
end;

function TFrmMain.MoveBlock( aSize, aFileId, aPos: Integer; out aPosFin: Integer ): Boolean;
var
  LDestBegin, LBegin, LPlace, LInc: Integer;

begin
  LDestBegin := -1;
  Result := False;

  LInc := 0;
  while ( LInc < aPos ) do
  begin
    while ( LInc < aPos ) and ( FMap[ LInc ] <> -1 ) do
    begin
      inc( LInc );
    end;

    if ( LInc < aPos ) then
    begin
      LBegin := LInc;

      LPlace := 0;

      while ( LInc < aPos ) and ( FMap[ LInc ] = -1 ) do
      begin
        inc( LPlace );

        inc( LInc );
      end;

      if ( LPlace >= aSize ) then
      begin
        for var i := LBegin to LBegin + aSize - 1 do
        begin
          FMap[ i ] := aFileId;
        end;

        aPosFin := LBegin + aSize;

        Exit( True );
      end;
    end;
  end;
end;

end.
