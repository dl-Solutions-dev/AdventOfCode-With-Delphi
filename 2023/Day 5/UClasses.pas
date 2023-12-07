unit UClasses;

interface

type

TRange = record
    LowerBound : Int64;
    UpperBound : Int64;
  end;

  TRule = record
    Origine : TRange;
    Destination : TRange;
  end;

  TTranslator = class
  private
    FRules : TArray< TRule >;
  public
    constructor Create;

    function Translate( aSearchValue : Int64 ) : Int64;

    procedure AddRule( aOrigine, adestination, aCount : Int64 );
  end;

implementation

{ TTranslator }

procedure TTranslator.AddRule( aOrigine, adestination, aCount : Int64 );
begin
  SetLength( FRules, Length( FRules ) + 1 );

  FRules[ High( FRules ) ].Origine.LowerBound := aOrigine;
  FRules[ High( FRules ) ].Origine.UpperBound := aOrigine + aCount - 1;

  FRules[ High( FRules ) ].Destination.LowerBound := adestination;
  FRules[ High( FRules ) ].Destination.UpperBound := adestination + aCount - 1;
end;

constructor TTranslator.Create;
begin
  SetLength( FRules, 0 );
end;

function TTranslator.Translate( aSearchValue : Int64 ) : Int64;
var
  wRule : Integer;
  wTarget : Int64;
begin
  wRule := -1;

  for var i := 0 to High( FRules ) do
  begin
    if ( FRules[ i ].Origine.LowerBound <= aSearchValue ) and ( aSearchValue <= FRules[ i ].Origine.UpperBound ) then
    begin
      wRule := i;
      Break;
    end;
  end;

  if ( wRule <> -1 ) then
  begin
    wTarget := aSearchValue - FRules[ wRule ].Origine.LowerBound;
    Result := FRules[ wRule ].Destination.LowerBound + wTarget;
  end
  else
  begin
    Result := aSearchValue;
  end;
end;

end.
