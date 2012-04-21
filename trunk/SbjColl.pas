unit SbjColl;

interface

Uses SysUtils, Classes, publ, SbjResource;

Type
  TCollItem = Class (TPersistent)
  private
    FItemIndex: Integer;
    function GetIm: TCollItem;
  protected
    procedure SetIndex(const Value: Integer); virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    property ItemIndex: Integer read FItemIndex write SetIndex;
    property Im: TCollItem read GetIm;
  End;
 ////////////////////// x //////////////////////
  TColl = Class (TPersistent)
  private
    FAutoIndex: Boolean;
    function GetCount: Integer;
    procedure SetAutoIndex(const Value: Boolean);
  protected
    MaxInd: Integer;
    FItem: array of TCollItem;
    function GetItem(Index: Integer): TCollItem;
    procedure SetItem(Index: Integer; const Value: TCollItem);
    Function Find(ind: Integer): Integer;
  public
    Constructor Create(AutoIndex: Boolean);
    Destructor Destroy; override;
    property Item[Index: Integer]: TCollItem read GetItem write SetItem; default;
    property Count: Integer read GetCount;
    property AutoIndex: Boolean read FAutoIndex write SetAutoIndex;
    function Add(It: TCollItem): Integer;
    procedure Delete(Index: Integer; AutoFree: Boolean = False); overload;
    procedure Delete(it: TCollItem; AutoFree: Boolean = False); overload;
    procedure Swap(Index1, Index2: Integer);
    procedure Clear(AllFree: Boolean = False);
  End;

implementation



{ TColl }

function TColl.Add(It: TCollItem): Integer;
Var
  i, x: Integer;
begin
 // Добавление нового элемента
  inc(MaxInd);
  SetLength(FItem, Count);
  if FAutoIndex or (it = nil) then
    x := MaxInd
  else Begin
    x := Find(it.ItemIndex);
    if x = -1 then
      x := MaxInd
    else
      For i := MaxInd downto x + 1 do
        FItem[i] := FItem[i - 1];
  End;
  Item[x] := it;
  result := x;
end;

procedure TColl.Clear(AllFree: Boolean);
Var
  i: Integer;
begin
 // Удалить все
  if AllFree then
    For i := 0 to MaxInd do
      FItem[i].Free;
  MaxInd := -1;
  SetLength(FItem, 0);
end;

constructor TColl.Create(AutoIndex: Boolean);
begin
  FAutoIndex := AutoIndex;
  Clear;
 //LogInc(self.ClassName);
end;

procedure TColl.Delete(it: TCollItem; AutoFree: Boolean);
Var
  i: Integer;
begin
 // Удалить
  if FAutoIndex then
    Delete(it.ItemIndex, AutoFree)
  else
    For i := MaxInd downto 0 do
      if it = FItem[i] then
        Delete(i, AutoFree);
end;

procedure TColl.Delete(Index: Integer; AutoFree: Boolean);
Var
  i: Integer;
begin
 // Удалить, если есть
  if (Index < 0) or (Index > MaxInd) then
    Exit;
  if AutoFree then
    FreeAndNil(FItem[Index]);
  if FAutoIndex then
    Item[Index] := FItem[MaxInd]
  else
    For i := Index to Maxind - 1 do
      FItem[i] := FItem[i + 1];
  SetLength(FItem, MaxInd);
  dec(MaxInd);
end;

destructor TColl.Destroy;
begin
 //LogDec(self.ClassName);
  inherited;
end;

function TColl.Find(ind: Integer): Integer;
Var
  i: Integer;
begin
  result := -1;
  For i := 0 to MaxInd do
    if FItem[i] <> nil then
      if FItem[i].ItemIndex > ind then Begin
        result := i;
        break;
      End;
end;

function TColl.GetCount: Integer;
begin
 // Количество элементов
  result := MaxInd + 1;
end;

function TColl.GetItem(Index: Integer): TCollItem;
begin
 // Выдать элемент, если есть
  Result := nil;
  if (Index < 0) or (Index > MaxInd) then
    Exit;
  Result := FItem[Index];
end;

procedure TColl.SetAutoIndex(const Value: Boolean);
begin
  FAutoIndex := Value;
end;

procedure TColl.SetItem(Index: Integer; const Value: TCollItem);
begin
 // Записать элемент и его индекс (если нужно)
  if (Index < 0) or (Index > MaxInd) then
    Exit;
  FItem[Index] := Value;
  if FAutoIndex and (FItem[Index] <> nil) then
    FItem[Index].ItemIndex := Index;
end;

procedure TColl.Swap(Index1, Index2: Integer);
Var
  P: TCollItem;
begin
 // Поменять элементы местами
  P := FItem[Index1];
  Item[Index1] := FItem[Index2];
  Item[Index2] := P;
end;

{ TCollItem }

constructor TCollItem.Create;
begin
 // Элемент не в коллекции
  FItemIndex := -1;
end;

destructor TCollItem.Destroy;
begin
  inherited;
end;

function TCollItem.GetIm: TCollItem;
begin
  result := self;
end;

procedure TCollItem.SetIndex(const Value: Integer);
begin
 // Элемент в коллекции
  FItemIndex := Value;
end;

end.
