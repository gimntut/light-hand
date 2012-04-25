{$WARN UNSAFE_TYPE Off}
{$WARN UNSAFE_CODE Off}
{$WARN UNSAFE_CAST Off}
unit MyStreams;

interface
Uses Windows, SysUtils, Classes, Publ;

Type
 TPartState=(psBegin,psDeleted,psContinue);
 TProgressStage = (psStarting, psRunning, psEnding);
 TProgressEvent=procedure (Sender: TObject; Stage: TProgressStage;
                          PercentDone: Byte) of object;
 TStreams=Class(TFileStream)
 private
  CurBlock:integer;
  CurPart:integer;
  FBegs:array of array of Integer;
  FBlockPosition: Int64;
  FFileName:string;
  FNames: TStrings;
  FOnProgress: TProgressEvent;
  FSizes:array of array of Integer;
  FToken:string;
  MaxInd:integer;
  function GetBegs(Block: integer): integer;
  function GetBlockSize: Int64;
  function GetCurBeg: Integer;
  function GetCurBeg2: Integer;
  function GetCurrentBlock: String;
  function GetEnds(Block: integer): integer;
  function GetParts(Block, Part: integer):Integer;
  function GetPartSize: integer;
  function Posit(Name:string):integer; overload;
  function Posit(x:integer):integer; overload;
  procedure DoProgress(Stage: TProgressStage; PercentDone: Byte);
  procedure IncCount;
  procedure Init;
  procedure SetBegs(Block: integer; const Value: integer);
  procedure SetBlockPosition(const Value: Int64);
  procedure SetCurrentBlock(const Value: String);
 protected
  // Преобразование порядкового номера имени к индексу блока
  function ToInd(Block:integer):integer;
  // Запомнить имя блока и начало в массиве
  procedure AddBlock(Name:string;ABeg:integer);
  // Запомнить начало фрагмента и размер
  procedure AddPart(Name:string;ABeg,ASize:integer);
  // Список начал блоков
  property Begs[Block:integer]:integer read GetBegs write SetBegs;
  // Начало текущего блока
  property CurBeg:Integer read GetCurBeg;
  // Начало текущей фрагмента
  property CurBeg2:Integer read GetCurBeg2;
  // Концы блоков
  property Ends[Block:integer]:integer read GetEnds;
  // Указатели на Фрагменты
  property Parts[Block,Part:integer]:Integer read GetParts;
  // Размеры фрагментов
  property PartSize:integer read GetPartSize;
  // Чтение данных из текущего именованого потока
  function BlockRead(var Buffer; Count: Longint): Longint;
  // Запись данных в текущий именованый поток
  function BlockWrite(const Buffer; Count: Longint): Longint;
  // Добавление именованого потока в файл
  procedure Add(Name:string;Stream:TStream); virtual;
  // Копировать Count данных в поток str
  procedure CopyTo(str:TStream; Count:integer);
  // Удаление потока по имени
  procedure Delete(Name:string); virtual;
  // Уплотнить поток
  procedure Rebuild;
  // Замена именованого потока
  procedure Replace(Name:string;Stream:TStream);
  // Список имён блоков
  property BlockNames:TStrings read FNames;
  // Установка позиции в текущем именованном потоке
  property BlockPosition:Int64 read FBlockPosition write SetBlockPosition;
  // Размер текущего именованного потока
  property BlockSize:Int64 read GetBlockSize;
  // Имя текущего блока
  property CurrentBlock:String read GetCurrentBlock write SetCurrentBlock;
 public
  constructor Create(const FileName: string; Mode: Word; AToken:string);
  destructor Destroy; override;
  // Событие
  property OnProgress:TProgressEvent read FOnProgress write FOnProgress;
  // Внутрений идентификатор файла
  property Token:String read FToken;
 End;

 TSubStream=Class(TStream)
 protected
  FName: String;
  FParent:TStreams;
  FPosition:integer;
  procedure SetSize(const NewSize: Int64); override;
  function GetSize:Int64; override;
 public
  constructor Create(AParent:TStreams;AName:string);
  // см. хелп для стрим
  function Read(var Buffer; Count: Longint): Longint; override;
  function Write(const Buffer; Count: Longint): Longint; override;
  function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; override;
  // Имя блока в мульти-стрим
  property Name:String read FName;
 end;

 TMultiStream=Class(TStreams)
 private
  FSubStreams: array of TStream;
  function GetStreams(Name: String): TStream;
  function GetStreamNames: TStrings;
 public
  function AddStream(Name:string):TStream;
  procedure Add(Name: string; Stream: TStream); override;
  procedure Delete(Name:string); override;
  property StreamNames:TStrings read GetStreamNames;
  property Streams[Name:String]:TStream read GetStreams; default;
 End;

implementation

{ TStreams }

procedure TStreams.Add(Name: string; Stream: TStream);
Var
 l,Ind,p:integer;
 xBlockPosition:integer;
 s:Longint;
 State:TPartState;
 Next:Longint;
 us:boolean;
 Znak:word;
 oldn:string;
begin
 xBlockPosition:=BlockPosition;
 if Size=0 then WriteString(self,FToken);
 p:=Seek(0,soEnd);
 oldn:=CurrentBlock;
 CurrentBlock:=Name;
 us:=CurrentBlock=Name;
 s:=Stream.Size;
 if us then Begin
  BlockPosition:=BlockSize;
  us:=Position+4=Size;
  if not us then Begin
   Read(Next,4);
   Seek(-4,soCurrent);
   Write(p,4);
   State:=psContinue; //Continue of Block
  End;
 End else Begin
  State:=psBegin;    //Begin of Block
  AddBlock(Name,p);
 End;
 if not us then Begin
  Seek(0,soEnd);
  Znak:=$3412;
  Write(Znak,2);
  WriteString(self,Name);
  Write(State,1);
  Write(s,4);
  AddPart(Name,position,s);
 End;
 Stream.Position:=0;
 CopyFrom(Stream,s);
 Next:=-1;
 Write(Next,4);
 if us then Begin
  Ind:=ToInd(CurBlock);
  l:=Length(FSizes[Ind])-1;
  Position:=FBegs[Ind,l+1]-4;
  s:=s+Parts[CurBlock,l];
  Write(s,4);
  FSizes[Ind,l]:=s;
 End;
 CurrentBlock:=oldn;
 BlockPosition:=xBlockPosition;
end;

function TStreams.BlockRead(var Buffer; Count: Integer): Longint;
Var
 l,Next:integer;
 ms:TMemoryStream;
 us:boolean;
begin
 result:=0;
 ms:=TMemoryStream.Create;
 Repeat
  l:=CurBeg2+PartSize-Position;
  if l<Count then Begin
   Count:=Count-l;
   ms.CopyFrom(self,l);
   result:=result+l;
   us:=(position=size);
   FBlockPosition:=FBlockPosition+l;
   if not us then Begin
    Read(Next,4);
    us:=Next=-1;
   End;
   if us then Count:=0 else Begin
    CurPart:=CurPart+1;
    position:=Next;
    Seek(2,soCurrent);
    ReadString(self);
    Seek(5,soCurrent);
   End;
  End else Begin
   result:=result+Count;
   FBlockPosition:=FBlockPosition+Count;
   ms.CopyFrom(self,count);
   Count:=0;
  End;
 Until Count=0;
 ms.position:=0;
 ms.Read(Buffer,Result);
 ms.Free;
end;

function TStreams.BlockWrite(const Buffer; Count: Integer): Longint;
Var
 l,Next:integer;
 ms,ms2:TMemoryStream;
begin
 result:=0;
 ms:=TMemoryStream.Create;
 ms.Write(Buffer,Count);
 ms.position:=0;
 Repeat
  l:=CurBeg2+PartSize-Position;
  if l<Count then Begin
   Count:=Count-l;
   if l>0 then CopyFrom(ms,l);
   result:=result+l;
   Read(Next,4);
   FBlockPosition:=FBlockPosition+l;
   if Next=-1 then Begin
    ms2:=TMemoryStream.Create;
    ms2.CopyFrom(ms,ms.Size-ms.Position);
    Add(CurrentBlock,ms2);
    BlockPosition:=BlockSize;
    ms2.Free;
    result:=result+Count;
    Count:=0;
   End else Begin
    CurPart:=CurPart+1;
    position:=Next;
    Seek(2,soCurrent);
    ReadString(self);
    Seek(5,soCurrent);
   End;
  End else Begin
   result:=result+Count;
   FBlockPosition:=FBlockPosition+Count;
   //ms.Position:=0;
   CopyFrom(ms,count);
   Count:=0;
  End;
 Until Count=0;
 ms.Free;
end;

procedure TStreams.CopyTo(str: TStream; Count:integer);
Var
 p:pointer;
begin
 GetMem(p,Count);
 BlockRead(p^,Count);
 str.Write(p^,Count);
 FreeMem(p,Count);
end;

constructor TStreams.Create(const FileName: string; Mode: Word; AToken:string);
begin
 FFileName:=FileName;
 FToken:=AToken;
 FNames:=TStringList.Create;
 With TStringList(FNames) do Begin
  Sorted:=true;
  CaseSensitive:=false;
  Duplicates:=dupIgnore;
 End;
 if not FileExists(FileName) then Mode:=fmCreate;
 inherited Create(FileName,Mode);
 Init;
end;

procedure TStreams.Delete(Name: string);
Var
 p,p1:integer;
 State:tPartState;
begin
 p1:=Position;
 p:=Posit(Name);
 if p=-1 then Exit;
 Position:=p;
 seek(2,soCurrent);
 ReadString(self);
 State:=psDeleted;
 Write(State,1);
 Position:=p1;
 With FNames do Delete(IndexOf(Name));
end;

destructor TStreams.Destroy;
begin
 if self=nil then Exit;
 FNames.Free;
 inherited;
end;

function TStreams.GetCurrentBlock: String;
begin
 result:='';
 if CurBlock<>-1 then result:=FNames[CurBlock];
end;

procedure TStreams.IncCount;
begin
 Inc(MaxInd);
 SetLength(FSizes,MaxInd+1);
 SetLength(fBegs,MaxInd+1);
 SetLength(fBegs[MaxInd],1);
end;

function TStreams.Posit(Name: string): integer;
Var
 i:integer;
begin
 i:=FNames.IndexOf(Name);
 result:=Posit(i);
end;

function TStreams.Posit(x: integer): integer;
begin
 result:=-1;
 if x=-1 then Exit;
 result:=Begs[x];
end;

procedure TStreams.Rebuild;
Var
 i,s:integer;
 fn,path:string;
 fs:TStreams;
 ms:TMemoryStream;
begin
 path:=ExtractFilePath(FFileName);
 i:=0;
 Repeat
  fn:=path+format('file%d.bak',[i]);
  inc(i);
 Until not FileExists(fn);
 fs:=TStreams.Create(fn,fmCreate,FToken);
 DoProgress(psStarting,0);
 ms:=TMemoryStream.Create;
 s:=0;
 For i:=0 to FNames.Count-1 do Begin
  CurrentBlock:=FNames[i];
  s:=s+BlockSize;
  ms.Size:=0;
  BlockPosition:=0;
  CopyTo(ms,BlockSize);
  DoProgress(psRunning,Round(s*100/Size));
  fs.Add(FNames[i],ms);
 End;
 ms.Free;
 DoProgress(psEnding,100);
 size:=0;
 fs.position:=0;
 CopyFrom(fs,fs.size);
 fs.Free;
 DeleteFile(fn);
 Init;
end;

procedure TStreams.Replace(Name: string; Stream: TStream);
begin
 Delete(Name);
 Add(Name,Stream);
end;

procedure TStreams.SetBlockPosition(const Value: Int64);
Var
 l,i,xSize,xPart,Ind:integer;
begin
 if CurBlock=-1 then Exit;
 if Value>=BlockSize then Begin
  Position:=Ends[CurBlock];
  FBlockPosition:=BlockSize;
  Exit;
 End;
 Ind:=ToInd(CurBlock);
 if Ind=-1 then Exit;
 l:=Length(fSizes[Ind]);
 if l=0 then Exit;
 xSize:=fSizes[ind,0];
 xPart:=0;
 For i:=1 to l-1 do Begin
  xPart:=i;
  xSize:=xSize+FSizes[ind,i];
  if xSize>Value then break;
 End;
 CurPart:=xPart;
 Position:=CurBeg2+(Value+fSizes[ind,xPart]-xSize);
 FBlockPosition := Value;
end;

procedure TStreams.SetCurrentBlock(const Value: String);
Var
 i:integer;
begin
 if CurrentBlock=Value then Exit;
 i:=FNames.IndexOf(Value);
 if i=-1 then Exit;
 CurBlock := i;
 BlockPosition:=0;
end;

function TStreams.GetBlockSize: Int64;
Var
 i,l,Ind:integer;
begin
 result:=-1;
 Ind:=ToInd(CurBlock);
 if Ind=-1 then Exit;
 l:=length(FSizes[Ind])-1;
 result:=0;
 For i:=0 to l do result:=result+FSizes[Ind,i];
end;

procedure TStreams.DoProgress(Stage: TProgressStage; PercentDone: Byte);
begin
 if Assigned(FOnProgress) then FOnProgress(self,Stage,PercentDone);
end;

function TStreams.ToInd(Block: integer): integer;
begin
 if Block=-1
 then result:=-1
 else result:=integer(FNames.Objects[Block]);
end;

procedure TStreams.Init;
Var
 s:string;
 Znak:Word;
 ABeg1,ABeg2,ASize:integer;
 Name:string;
 State:TPartState;
begin
 CurPart:=0;
 FBlockPosition:=0;
 CurBlock:=-1;
 MaxInd:=-1;
 SetLength(FSizes,0);
 SetLength(FBegs,0);
 if Size=0 then Exit;
 Position:=0;
 s:=ReadString(Self);
 if (FToken<>'') and (s<>FToken) then Abort;
 FToken:=S;
 Repeat
  ABeg1:=position;
  Read(Znak,2);
  if Znak<>$3412 then Abort;
  Name:=ReadString(self);
  Read(State,1);
  Read(Asize,4);
  ABeg2:=position;
  Seek(Asize+4,soCurrent);
  if State=psBegin then AddBlock(Name,ABeg1);
  if State<>psDeleted then AddPart(Name,ABeg2,ASize);
 Until position=size;
 if FNames.count>0 then CurrentBlock:=FNames[0];
end;

function TStreams.GetCurBeg: Integer;
Var
 Ind:integer;
begin
 Result:=-1;
 Ind:=ToInd(CurBlock);
 if Ind=-1 then Exit;
 Result:=FBegs[Ind,0];
end;

function TStreams.GetCurBeg2: Integer;
Var
 Ind:integer;
begin
 result:=-1;
 Ind:=ToInd(CurBlock);
 if Ind=-1 then Exit;
 if CurPart=-1 then Exit;
 result:=FBegs[Ind,CurPart+1];
end;

function TStreams.GetParts(Block, Part: integer): Integer;
Var
 Ind:Integer;
begin
 result:=-1;
 Ind:=ToInd(CurBlock);
 if Ind=-1 then Exit;
 if Part=-1 then Exit;
 result:=FSizes[Ind,Part];
end;

function TStreams.GetBegs(Block: integer): integer;
Var
 ind:integer;
begin
 result:=-1;
 ind:=ToInd(Block);
 if Ind=-1 then Exit;
 result:=FBegs[Ind,0];
end;

procedure TStreams.SetBegs(Block: integer; const Value: integer);
Var
 Ind:integer;
begin
 Ind:=ToInd(Block);
 if Ind=-1 then Exit;
 FBegs[Ind,0]:=Value;
end;

function TStreams.GetEnds(Block: integer): integer;
Var
 ind,l:integer;
begin
 result:=-1;
 ind:=ToInd(Block);
 if Ind=-1 then Exit;
 l:=length(FSizes[Ind]);
 result:=FBegs[Ind,l]+FSizes[Ind,l-1];
end;

function TStreams.GetPartSize: integer;
begin
 result:=Parts[CurBlock,CurPart];
end;

procedure TStreams.AddBlock(Name: string; ABeg: integer);
begin
 incCount;
 CurBlock:=FNames.AddObject(Name,TObject(MaxInd));
 Begs[CurBlock]:=ABeg;
end;

procedure TStreams.AddPart(Name: string; ABeg, ASize: integer);
Var
 l,Ind,Block:integer;
begin
 Block:=FNames.IndexOf(Name);
 if Block=-1 then Exit;
 Ind:=ToInd(Block);
 l:=Length(fBegs[Ind]);
 SetLength(fSizes[Ind],l);
 SetLength(fBegs[Ind],l+1);
 fBegs[Ind,l]:=ABeg;
 fSizes[Ind,l-1]:=ASize;
end;

{ TSubStream }

constructor TSubStream.Create(AParent:TStreams;AName:string);
begin
 FParent:=AParent;
 FName:=AName;
 FPosition:=0;
end;

function TSubStream.GetSize: Int64;
begin
 result:=0;
 if self=nil then Exit;
 FParent.CurrentBlock:=FName;
 result:=FParent.BlockSize;
end;

function TSubStream.Read(var Buffer; Count: Integer): Longint;
begin
 result:=0;
 if self=nil then Exit;
 FParent.CurrentBlock:=FName;
 FParent.BlockPosition:=FPosition;
 result:=FParent.BlockRead(Buffer,Count);
 FPosition:=FParent.BlockPosition;
end;

function TSubStream.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
begin
 result:=0;
 if self=nil then Exit;
 FParent.CurrentBlock:=FName;
 Case Origin of
  soBeginning: Begin
   FParent.BlockPosition:=Offset;
   Result:=FParent.BlockPosition;
   FPosition:=Result;
  End;
  soCurrent: result:=Seek(FPosition+Offset,soBeginning);
  soEnd: result:=Seek(FParent.BlockSize+Offset,soBeginning);
 End;
end;

procedure TSubStream.SetSize(const NewSize: Int64);
begin
 raise Exception.Create('Размер потока изменить нельзя');
end;

function TSubStream.Write(const Buffer; Count: Integer): Longint;
begin
 result:=0;
 if self=nil then Exit;
 FParent.CurrentBlock:=FName;
 FParent.BlockPosition:=FPosition;
 result:=FParent.BlockWrite(Buffer,Count);
 FPosition:=FParent.BlockPosition;
end;

{ TMultiStream }

procedure TMultiStream.Add(Name: string; Stream: TStream);
Var
 ind,l:integer;
begin
 ind:=ToInd(BlockNames.IndexOf(Name));
 inherited;
 if ind=-1 then Begin
  ind:=ToInd(BlockNames.IndexOf(Name));
  l:=length(FSubStreams);
  if ind>=l then SetLength(FSubStreams,ind+1);
  FSubStreams[ind]:=TSubStream.Create(self,Name);
 End;
end;

function TMultiStream.AddStream(Name: string): TStream;
Var
 ind:integer;
 ms:TMemoryStream;
begin
 ind:=ToInd(BlockNames.IndexOf(Name));
 if ind=-1 then Begin
  ms:=TMemoryStream.Create;
  Add(Name,ms);
  ms.Free;
 End;
 result:=Streams[Name];
end;

procedure TMultiStream.Delete(Name: string);
Var
 ind:integer;
begin
 ind:=ToInd(BlockNames.IndexOf(Name));
 if ind=-1 then exit;
 inherited;
 FreeAndNil(FSubStreams[ind]);
end;

function TMultiStream.GetStreamNames: TStrings;
begin
 result:=BlockNames;
end;

function TMultiStream.GetStreams(Name: String): TStream;
Var
 ind:integer;
begin
 result:=nil;
 ind:=ToInd(BlockNames.IndexOf(Name));
 if ind=-1 then Exit;
 result:=FSubStreams[ind];
end;

end.
