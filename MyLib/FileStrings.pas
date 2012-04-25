unit FileStrings;

interface

Uses SysUtils, Classes;

type
  TFileStrData = class
    Position: Integer;
    Length: Integer;
    SortIndex: Integer;
    Index: Integer;
  End;

  TFileStrings = class (TStrings)
  private
    FFileName: TFileName;
    FList: TList;
    FSortedList: TList;
    FStream: TStream;
    FSorted: Boolean;
    function GetSortedItem(Ind: Integer): String;
  protected
    function Get(Index: Integer): String; override;
    function GetCount: Integer; override;
    function GetCapacity: Integer; override;
    function Memorize(Position: integer; S: String): integer;
    function Compare(ind: Integer; obj: TObject): Integer;
    function Find(S: string; Var Index: Integer): boolean;
    property SortedItem[Ind: Integer]: String read GetSortedItem;
  public
    constructor Create(AFileName: TFileName);
    destructor Destroy; override;
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    procedure Insert(Index: Integer; const S: String); override;
    property FileName: TFileName read FFileName;
    property Sorted: Boolean read FSorted write FSorted;
  End;

implementation

uses Types, publ;

{ TFileStrings }

procedure TFileStrings.Clear;
Var
  i: integer;
begin
  For i := 0 to Count - 1 do
    TObject(FList[i]).Free;
  FSortedList.Clear;
  FList.Clear;
end;

function TFileStrings.Compare(ind: Integer; obj: TObject): Integer;
Var
  s: string;
begin
  s := String(obj);
  Result := CompareText(SortedItem[Ind], s);
end;

constructor TFileStrings.Create(AFileName: TFileName);
Var
  i, n, p: integer;
  ch: Char;
  cl: String[2];
  s: string;
begin
  FList := TList.Create;
  FSortedList := TList.Create;
  FStream := TFileStream.Create(AFileName, fmOpenReadWrite);
  if FStream.Size = 0 then
    Exit;
  cl := #0#0;
  SetLength(s, 5000);
  n := 1;
  p := 0;
  For i := 0 to FStream.Size - 1 do Begin
    FStream.Read(ch, 1);
    cl[1] := cl[2];
    cl[2] := ch;
    s[n] := ch;
    inc(n);
    if (cl = CRLF) or (n = 5001) then Begin
      Memorize(p, copy(s, 1, n - 3));
      n := 1;
      p := i + 1;
    End;
  End;
  if n > 2 then
    Memorize(p, copy(s, 1, n - 3));
end;

procedure TFileStrings.Delete(Index: Integer);
Var
  ind, sind: integer;
  fsd: TFileStrData;
begin
  if FSorted then
    fsd := TFileStrData(FSortedList[Index])
  else
    fsd := TFileStrData(FList[Index]);
  ind := fsd.Index;
  sind := fsd.SortIndex;
  FList.Delete(ind);
  FSortedList.Delete(sind);
end;

destructor TFileStrings.Destroy;
begin
  Clear;
  FList.Free;
  FSortedList.Free;
  inherited Destroy;
end;

function TFileStrings.Find(S: string; var Index: Integer): boolean;
begin
  Result := publ.Find(TObject(s), Count, nil, Index);
end;

function TFileStrings.Get(Index: Integer): String;
Var
  fsd: TFileStrData;
  l: Integer;
begin
  if Sorted then
    fsd := FSortedList[Index]
  Else
    fsd := FList[Index];
  l := fsd.Length;
  SetLength(Result, l);
  if l = 0 then
    Exit;
  FStream.Position := fsd.Position;
  FStream.Read(Result[1], l);
end;

function TFileStrings.GetCapacity: Integer;
begin
  Result := FList.Capacity;
end;

function TFileStrings.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TFileStrings.GetSortedItem(Ind: Integer): String;
begin

end;

procedure TFileStrings.Insert(Index: Integer; const S: String);
begin

end;

function TFileStrings.Memorize(Position: integer; S: String): integer;
Var
  l: Integer;
  fsd: TFileStrData;
begin
  l := Length(s);
  fsd := TFileStrData.Create;
  fsd.Length := l;
  fsd.Position := Position;
  fsd.Index := FList.Add(fsd);
  fsd.SortIndex := 0;
  if Sorted then
    Result := fsd.SortIndex
  else
    Result := fsd.Index;
end;

end.
