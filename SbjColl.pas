unit SbjColl;

interface

Uses SysUtils, Classes, publ, SbjResource;

Type
  TCollItem = Class (TPersistent)
  private
    FItemIndex: integer;
    function GetIm: TCollItem;
  protected
    procedure SetIndex(const Value: integer); virtual;
  public
    Constructor Create; virtual;
    Destructor Destroy; override;
    property ItemIndex: integer read FItemIndex write SetIndex;
    property Im: TCollItem read GetIm;
  End;
 ////////////////////// x //////////////////////
  TColl = Class (TPersistent)
  private
    FAutoIndex: Boolean;
    function GetCount: integer;
    procedure SetAutoIndex(const Value: boolean);
  protected
    MaxInd: integer;
    FItem: array of TCollItem;
    function GetItem(x: integer): TCollItem;
    procedure SetItem(x: integer; const Value: TCollItem);
    Function Find(ind: integer): integer;
  public
    Constructor Create(AutoIndex: boolean);
    Destructor Destroy; override;
    property Item[x: integer]: TCollItem read GetItem write SetItem; default;
    property Count: integer read GetCount;
    property AutoIndex: boolean read FAutoIndex write SetAutoIndex;
    function Add(It: TCollItem): integer;
    procedure Delete(x: integer; AutoFree: boolean = false); overload;
    procedure Delete(it: TCollItem; AutoFree: boolean = false); overload;
    procedure Swap(a, b: integer);
    procedure Clear(AllFree: boolean = false);
  End;

implementation



{ TColl }

function TColl.Add(It: TCollItem): integer;
Var
  i, x: integer;
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

procedure TColl.Clear(AllFree: boolean);
Var
  i: integer;
begin
 // Удалить все
  if AllFree then
    For i := 0 to MaxInd do
      FItem[i].Free;
  MaxInd := -1;
  SetLength(FItem, 0);
end;

constructor TColl.Create(AutoIndex: boolean);
begin
  FAutoIndex := AutoIndex;
  Clear;
 //LogInc(self.ClassName);
end;

procedure TColl.Delete(it: TCollItem; AutoFree: boolean);
Var
  i: integer;
begin
 // Удалить
  if FAutoIndex then
    Delete(it.ItemIndex, AutoFree)
  else
    For i := MaxInd downto 0 do
      if it = FItem[i] then
        Delete(i, AutoFree);
end;

procedure TColl.Delete(x: integer; AutoFree: boolean);
Var
  i: integer;
begin
 // Удалить, если есть
  if (x < 0) or (x > MaxInd) then
    Exit;
  if AutoFree then
    FreeAndNil(FItem[x]);
  if FAutoIndex then
    Item[x] := FItem[MaxInd]
  else
    For i := x to Maxind - 1 do
      FItem[i] := FItem[i + 1];
  SetLength(FItem, MaxInd);
  dec(MaxInd);
end;

destructor TColl.Destroy;
begin
 //LogDec(self.ClassName);
  inherited;
end;

function TColl.Find(ind: integer): integer;
Var
  i: integer;
begin
  result := -1;
  For i := 0 to MaxInd do
    if FItem[i] <> nil then
      if FItem[i].ItemIndex > ind then Begin
        result := i;
        break;
      End;
end;

function TColl.GetCount: integer;
begin
 // Количество элементов
  result := MaxInd + 1;
end;

function TColl.GetItem(x: integer): TCollItem;
begin
 // Выдать элемент, если есть
  Result := nil;
  if (x < 0) or (x > MaxInd) then
    Exit;
  Result := FItem[x];
end;

procedure TColl.SetAutoIndex(const Value: boolean);
begin
  FAutoIndex := Value;
end;

procedure TColl.SetItem(x: integer; const Value: TCollItem);
begin
 // Записать элемент и его индекс (если нужно)
  if (x < 0) or (x > MaxInd) then
    Exit;
  FItem[x] := Value;
  if FAutoIndex and (FItem[x] <> nil) then
    FItem[x].ItemIndex := x;
end;

procedure TColl.Swap(a, b: integer);
Var
  P: TCollItem;
begin
 // Поменять элементы местами
  P := FItem[a];
  Item[a] := FItem[b];
  Item[b] := P;
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

procedure TCollItem.SetIndex(const Value: integer);
begin
 // Элемент в коллекции
  FItemIndex := Value;
end;

end.
