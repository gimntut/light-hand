unit SbjColl;

interface

uses SysUtils, Classes, publ, SbjResource;

type
  TCollItem = class (TPersistent)
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
  end;
  ////////////////////// x //////////////////////
  TAddEvent = procedure(Sender:TObject; AItem:TCollItem) of object;
  TDeleteEvent = procedure(Sender:TObject; AItem:TCollItem; AutoFree:Boolean) of object;
  ////////////////////// x //////////////////////
  TColl = class (TPersistent)
  private
    FAutoIndex: Boolean;
    FOnDelete: TDeleteEvent;
    FOnAdd: TAddEvent;
    function GetCount: Integer;
    procedure SetAutoIndex(const Value: Boolean);
    procedure SetOnAdd(const Value: TAddEvent);
    procedure SetOnDelete(const Value: TDeleteEvent);
  protected
    MaxInd: Integer;
    FItem: array of TCollItem;
    function GetItem(Index: Integer): TCollItem;
    procedure SetItem(Index: Integer; const Value: TCollItem);
    function Find(ind: Integer): Integer;
  protected
    procedure DoAdd(AItem:TCollItem); virtual;
    procedure DoDelete(AItem:TCollItem; AutoFree:Boolean); virtual;
    property OnAdd:TAddEvent read FOnAdd write SetOnAdd;
    property OnDelete:TDeleteEvent read FOnDelete write SetOnDelete;
  public
    constructor Create(AutoIndex: Boolean);
    destructor Destroy; override;
    property Item[Index: Integer]: TCollItem read GetItem write SetItem; default;
    property Count: Integer read GetCount;
    property AutoIndex: Boolean read FAutoIndex write SetAutoIndex;
    function Add(AItem: TCollItem): Integer;
    procedure Delete(Index: Integer; AutoFree: Boolean = False); overload;
    procedure Delete(AItem: TCollItem; AutoFree: Boolean = False); overload;
    procedure Swap(Index1, Index2: Integer);
    procedure Clear(AllFree: Boolean = False);
  end;

implementation



{ TColl }

function TColl.Add(AItem: TCollItem): Integer;
var
  i, x: Integer;
begin
 // Добавление нового элемента
  inc(MaxInd);
  SetLength(FItem, Count);
  if FAutoIndex or (AItem = nil) then
    x := MaxInd
  else begin
    x := Find(AItem.ItemIndex);
    if x = -1 then
      x := MaxInd
    else
      for i := MaxInd downto x + 1 do
        FItem[i] := FItem[i - 1];
  end;
  Item[x] := AItem;
  Result := x;
  DoAdd(AItem);
end;

procedure TColl.Clear(AllFree: Boolean);
var
  i: Integer;
begin
 // Удалить все
  if AllFree then
    for i := 0 to MaxInd do
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

procedure TColl.Delete(AItem: TCollItem; AutoFree: Boolean);
var
  i: Integer;
begin
  // Удалить
  if FAutoIndex then
    Delete(AItem.ItemIndex, AutoFree)
  else
    for i := MaxInd downto 0 do
      if AItem = FItem[i] then
        Delete(i, AutoFree);
end;

procedure TColl.Delete(Index: Integer; AutoFree: Boolean);
var
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
    for i := Index to Maxind - 1 do
      FItem[i] := FItem[i + 1];
  SetLength(FItem, MaxInd);
  dec(MaxInd);
end;

destructor TColl.Destroy;
begin
 //LogDec(self.ClassName);
  inherited;
end;

procedure TColl.DoAdd(AItem: TCollItem);
begin
  if Assigned(FOnAdd) then FOnAdd(self, AItem);
end;

procedure TColl.DoDelete(AItem: TCollItem; AutoFree: Boolean);
begin
  if Assigned(FOnDelete) then FOnDelete(self, AItem, AutoFree);
end;

function TColl.Find(ind: Integer): Integer;
var
  i: Integer;
begin
  result := -1;                                   
  for i := 0 to MaxInd do
    if FItem[i] <> nil then
      if FItem[i].ItemIndex > ind then begin
        result := i;
        break;
      end;
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

procedure TColl.SetOnAdd(const Value: TAddEvent);
begin
  FOnAdd := Value;
end;

procedure TColl.SetOnDelete(const Value: TDeleteEvent);
begin
  FOnDelete := Value;
end;

procedure TColl.Swap(Index1, Index2: Integer);
var
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
