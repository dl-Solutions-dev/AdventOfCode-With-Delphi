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
  TOperation = class
  private
    FOperat: string;
    FOperand2: string;
    FOperand1: string;
    FVarResult: string;

    procedure SetOperand1( const Value: string );
    procedure SetOperand2( const Value: string );
    procedure SetOperat( const Value: string );
    procedure SetVarResult( const Value: string );
  public
    function Resolve( AVariables: TStringList ): string;

    property Operand1: string read FOperand1 write SetOperand1;
    property Operand2: string read FOperand2 write SetOperand2;
    property Operat: string read FOperat write SetOperat;
    property VarResult: string read FVarResult write SetVarResult;
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
    procedure FormCreate( Sender: TObject );
    procedure FormClose( Sender: TObject; var Action: TCloseAction );
  private
    { Déclarations privées }
    FFile: TArray< string >;
    FMatrix: TArray< TArray< string > >;
    FVars: TStringList;
    FOperations: TObjectList< TOperation >;

    function GetInputFileName: string;

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
  System.Math;

const
  FILENAME: string = '.\input.txt';
  TESTS_FILENAME: string = '.\input_Tests.txt';

{$R *.dfm}


function BinToInt( AValue: string ): Int64;
var
  I: Integer;
begin
  Result := 0;
  for I := 1 to Length( AValue ) do
  begin
    Result := Result + Trunc( StrToInt( AValue[ I ] ) * IntPower( 2, Length( AValue ) - I ) );
  end;
end;

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
  LLine: TArray< string >;
  LPart: SmallInt;
  wOperation: TOperation;
  LOpe, LVar: Integer;
  LResult: string;
begin
  FOperations.Clear;

  LoadFile;

  LPart := 0;
  for var I := 0 to High( FFile ) do
  begin
    if ( FFile[ I ] = '' ) then
    begin
      LPart := 1;
    end;

    if ( LPart = 0 ) then
    begin
      LLine := FFile[ I ].Split( [ ': ' ] );
      FVars.Values[ LLine[ 0 ] ] := LLine[ 1 ];
    end
    else if ( LPart = 1 ) then
    begin
      LPart := 2;
    end
    else
    begin
      wOperation := TOperation.Create;
      LLine := FFile[ I ].Split( [ ' -> ' ] );
      wOperation.VarResult := LLine[ 1 ];
      LLine := LLine[ 0 ].Split( [ ' ' ] );
      wOperation.Operand1 := LLine[ 0 ];
      wOperation.Operat := LLine[ 1 ];
      wOperation.Operand2 := LLine[ 2 ];

      FOperations.Add( wOperation );
    end;
  end;

  while ( FOperations.Count > 0 ) do
  begin
    LOpe := 0;
    while ( LOpe < FOperations.Count ) do
    begin
      wOperation := FOperations[ LOpe ];

      if ( FVars.Values[ wOperation.Operand1 ] <> '' ) and ( FVars.Values[ wOperation.Operand2 ] <> '' ) then
      begin
        FVars.Values[ wOperation.VarResult ] := wOperation.Resolve( FVars );
        FOperations.Delete( LOpe );
      end
      else
      begin
        Inc( LOpe );
      end;
    end;
  end;

  for var I := 0 to FVars.Count - 1 do
  begin
    MmoLogs.Lines.Add( FVars.Names[ I ] + ' -> ' + FVars.ValueFromIndex[ I ] );
  end;

  LResult := '';
  LVar := 0;
  while ( FVars.Values[ 'Z' + FormatFloat( '00', LVar ) ] <> '' ) do
  begin
    LResult := FVars.Values[ 'Z' + FormatFloat( '00', LVar ) ] + LResult;

    Inc( LVar );
  end;

  MmoLogs.Lines.Add( LResult );

  LTotal := BinToInt( LResult );

  Edt1.Text := LTotal.ToString;
  Edt1.CopyToClipboard;
end;

procedure TFrmMain.Exercice2;
var
  LTotal: Int64;
begin
  LoadFile;

  for var I := 0 to High( FMatrix ) do
  begin

  end;

  Edt2.Text := LTotal.ToString;
  Edt2.CopyToClipboard;
end;

procedure TFrmMain.FormClose( Sender: TObject; var Action: TCloseAction );
begin
  FreeAndNil( FVars );
  FreeAndNil( FOperations );
end;

procedure TFrmMain.FormCreate( Sender: TObject );
begin
  FVars := TStringList.Create;
  FOperations := TObjectList< TOperation >.Create;
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

{ TOperation }

function TOperation.Resolve( AVariables: TStringList ): string;
begin
  if ( Operat = 'AND' ) then
  begin
    if ( AVariables.Values[ Operand1 ] = '1' ) and ( AVariables.Values[ Operand2 ] = '1' ) then
    begin
      Result := '1';
    end
    else
    begin
      Result := '0';
    end;
  end
  else if ( Operat = 'OR' ) then
  begin
    if ( AVariables.Values[ Operand1 ] = '1' ) or ( AVariables.Values[ Operand2 ] = '1' ) then
    begin
      Result := '1';
    end
    else
    begin
      Result := '0';
    end;
  end
  else
  begin
    if ( AVariables.Values[ Operand1 ] <> AVariables.Values[ Operand2 ] ) then
    begin
      Result := '1';
    end
    else
    begin
      Result := '0';
    end;
  end;
end;

procedure TOperation.SetOperand1( const Value: string );
begin
  FOperand1 := Value;
end;

procedure TOperation.SetOperand2( const Value: string );
begin
  FOperand2 := Value;
end;

procedure TOperation.SetOperat( const Value: string );
begin
  FOperat := Value;
end;

procedure TOperation.SetVarResult( const Value: string );
begin
  FVarResult := Value;
end;

end.
