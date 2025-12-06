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
  TRange = record
    RangeInf: Int64;
    RangeSup: Int64;

    function IsInRange( aId: Int64 ): Boolean;
  end;

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
    FRanges: TArray<TRange>;
    FListesID: TArray<Int64>;

    function GetInputFileName: string;

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
  SetLength( FListesID, 0 );
  SetLength( FRanges, 0 );

  LoadFile;
  LoadMatrix;

  LTotal := 0;

  for var i := 0 to High( FListesID ) do
  begin
    for var j := 0 to High( FRanges ) do
    begin
      if FRanges[ j ].IsInRange( FListesID[ i ] ) then
      begin
        Inc( LTotal );

        Break;
      end;
    end;
  end;

  Edt1.Text := LTotal.ToString;
  Edt1.CopyToClipboard;
end;

procedure TFrmMain.Exercice2;
var
  LTotal: Int64;
  LRanges: TArray<TRange>;
begin
  LoadFile;
  LoadMatrix;

  TArray.Add<TRange>( LRanges, FRanges[ 0 ] );

  for var i := 1 to High( FRanges ) do
  begin
    for var j := 0 to High( LRanges ) do
    begin
      if ( FRanges[ i ].RangeSup - FRanges[ i ].RangeInf > 0 ) then
      begin
        if ( FRanges[ i ].RangeInf < LRanges[ j ].RangeInf ) then
        begin
          if ( FRanges[ i ].RangeSup > LRanges[ j ].RangeInf ) then
          begin
            LRanges[ i ].RangeInf := FRanges[ i ].RangeInf;
          end
          else // Il n'y a pas de chevauchement
          begin
            TArray.Add<TRange>( LRanges, FRanges[ i ] );
          end;
        end;

        if ( FRanges[ i ].RangeSup > LRanges[ j ].RangeSup ) then
        begin
          if ( FRanges[ i ].RangeInf < LRanges[ j ].RangeSup ) then
          begin
            LRanges[ i ].RangeSup := FRanges[ i ].RangeSup;
          end
          else // Il n'y a pas de chevauchement
          begin
            TArray.Add<TRange>( LRanges, FRanges[ i ] );
          end;
        end;
      end;
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

procedure TFrmMain.LoadFile;
begin
  FFile := TFile.ReadAllLines( GetInputFileName );
end;

procedure TFrmMain.LoadMatrix;
var
  LRangeSt: TArray<string>;
begin
  for var i := 0 to High( FFile ) do
  begin
    if ( FFile[ i ].Trim <> '' ) then
    begin
      if ( FFile[ i ].IndexOf( '-' ) > 0 ) then
      begin
        LRangeSt := FFile[ i ].Split( [ '-' ] );

        SetLength( FRanges, Length( FRanges ) + 1 );
        FRanges[ High( FRanges ) ].RangeInf := LRangeSt[ 0 ].ToInt64;
        FRanges[ High( FRanges ) ].RangeSup := LRangeSt[ 1 ].ToInt64;
      end
      else
      begin
        TArray.Add<Int64>( FListesID, FFile[ i ].ToInt64 );
      end;
    end;
  end;
end;

{ TRange }

function TRange.IsInRange( aId: Int64 ): Boolean;
begin
  Result := ( aId >= RangeInf ) and ( aId <= RangeSup );
end;

end.

