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
  Communs.Helpers;

type
  TComputer = class
  private
    FName: string;
    FLinkTo: TArray< string >;

    procedure SetLinkTo( const Value: TArray< string > );
    procedure SetName( const Value: string );
  public
    constructor Create;
    destructor Destroy; override;

    procedure AddLink( aComputer: string );

    property Name: string read FName write SetName;
    property LinkTo: TArray< string > read FLinkTo write SetLinkTo;
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
    FComputers: TObjectDictionary< string, TComputer >;

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
  LCouple: TArray< string >;
  LComputer1, LComputer2: TComputer;
  LComp1: TPair< string, TComputer >;
  LTab1: TArray< string >;
  LList: TStringList;
begin
  MmoLogs.Lines.Clear;

  LoadFile;

  FComputers.Clear;

  for var i := 0 to High( FFile ) do
  begin
    LCouple := FFile[ i ].Split( [ '-' ] );

    if not( FComputers.TryGetValue( LCouple[ 0 ], LComputer1 ) ) then
    begin
      LComputer1 := TComputer.Create;
      LComputer1.Name := LCouple[ 0 ];
      // LComputer1.AddLink( LCouple[ 0 ] );

      FComputers.Add( LCouple[ 0 ], LComputer1 );
    end;

    LComputer1.AddLink( LCouple[ 1 ] );

    if not( FComputers.TryGetValue( LCouple[ 1 ], LComputer2 ) ) then
    begin
      LComputer2 := TComputer.Create;
      LComputer2.Name := LCouple[ 1 ];
      // LComputer2.AddLink( LCouple[ 1 ] );

      FComputers.Add( LCouple[ 1 ], LComputer2 );
    end;

    LComputer2.AddLink( LCouple[ 0 ] );
  end;

  for LComp1 in FComputers do
  begin
    MmoLogs.Lines.Add( LComp1.Value.Name + ' : ' + string.join( '-', LComp1.Value.LinkTo ) );
  end;

  LList := TStringList.Create;
  LList.Sorted := True;
  LList.Duplicates := dupIgnore;

  LTotal := 0;

  for LComp1 in FComputers do
  begin
    for var i := 0 to High( LComp1.Value.LinkTo ) - 1 do
    begin
      if FComputers.TryGetValue( LComp1.Value.LinkTo[ i ], LComputer1 ) then
      begin
        for var j := i + 1 to High( LComp1.Value.LinkTo ) do
        begin

          if ( TArray.IndexOf< string >( LComputer1.LinkTo, LComp1.Value.LinkTo[ j ] ) <> -1 ) then
          begin
            if ( LComp1.Value.Name[ 1 ] = 't' ) or ( LComp1.Value.LinkTo[ i ][ 1 ] = 't' ) or ( LComp1.Value.LinkTo[ j ][ 1 ] = 't' ) then
            begin
              SetLength( LTab1, 0 );
              TArray.Add< string >( LTab1, LComp1.Value.Name );
              TArray.Add< string >( LTab1, LComp1.Value.LinkTo[ i ] );
              TArray.Add< string >( LTab1, LComp1.Value.LinkTo[ j ] );
              TArray.Sort< string >( LTab1 );

              LList.Add( string.join( '-', LTab1 ) );
            end;
          end;
        end;
      end
      else
      begin
        MmoLogs.Lines.Add( 'No line for ' + LComp1.Value.LinkTo[ i ] );
      end;
    end;
  end;

  LTotal := LList.Count;

  for var i := 0 to LList.Count - 1 do
  begin
    MmoLogs.Lines.Add( LList[ i ] );
  end;

  Edt1.Text := LTotal.ToString;
  Edt1.CopyToClipboard;

  FreeAndNil( LList );
end;

procedure TFrmMain.Exercice2;
var
  LTotal: Int64;
begin
  LoadFile;

  for var i := 0 to High( FFile ) do
  begin

  end;

  Edt2.Text := LTotal.ToString;
  Edt2.CopyToClipboard;
end;

procedure TFrmMain.FormClose( Sender: TObject; var Action: TCloseAction );
begin
  FreeAndNil( FComputers );
end;

procedure TFrmMain.FormCreate( Sender: TObject );
begin
  FComputers := TObjectDictionary< string, TComputer >.Create;
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
  SetLength( FFile, 0 );

  FFile := TFile.ReadAllLines( GetInputFileName );
end;

{ TComputer }

procedure TComputer.AddLink( aComputer: string );
begin
  TArray.Add< string >( FLinkTo, aComputer );
end;

constructor TComputer.Create;
begin
  SetLength( FLinkTo, 0 );
end;

destructor TComputer.Destroy;
begin

  inherited;
end;

procedure TComputer.SetLinkTo( const Value: TArray< string > );
begin
  FLinkTo := Value;
end;

procedure TComputer.SetName( const Value: string );
begin
  FName := Value;
end;

end.
