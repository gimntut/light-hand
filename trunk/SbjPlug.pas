unit SbjPlug;
interface
Uses SbjSrc, Classes, SbjColl, SbjGrd;
Type
 TSubjCustomPlugin=Class
 private
  FSubjSource: TSubjSource;
  procedure SetSubjSource(const Value: TSubjSource);
 public
  property SubjSource:TSubjSource read FSubjSource write SetSubjSource;
  procedure Run; virtual; abstract;
 End;

 TPluginClass=Class of TSubjCustomPlugin;
 TGetClassProc=function:TPluginClass;
 TStrProc=function: PChar;
 ////////////////////// x //////////////////////
 TSubjPlgState=set of (zzzzzzzz);
 ////////////////////// x //////////////////////
 TSubjPlgItem=Class(TCollItem)
 private
  FDescription: String;
  FName: String;
  FState: TSubjPlgState;
  FFileName: String;
  procedure SetDescription(const Value: String);
  procedure SetName(const Value: String);
  procedure SetState(const Value: TSubjPlgState);
  procedure SetFileName(const Value: String);
 public
  property Name:String read FName write SetName;
  property Description:String read FDescription write SetDescription;
  property State:TSubjPlgState read FState write SetState;
  property FileName:String read FFileName write SetFileName;
 End;
 ////////////////////// x //////////////////////
 TSubjPlgList=Class(TColl)
 private
  function GetItems(x: integer): TSubjPlgItem;
  procedure SetItems(x: integer; const Value: TSubjPlgItem);
 public
  Property Items[x:integer]:TSubjPlgItem read GetItems write SetItems; default;
 End;
 ////////////////////// x //////////////////////
 TSubjPluginSupport=Class(TComponent)
 private
  FSource: TSubjSource;
  FPlgList:TSubjPlgList;
  FGrid: TSubjGrid;
  FFileExt: String;
  FPath: String;
  procedure SetSource(const Value: TSubjSource);
  procedure SetGrid(const Value: TSubjGrid);
  procedure SetFileExt(const Value: String);
  procedure SetPath(const Value: String);
  function GetPath: String;
 protected
  procedure Notification(AComponent: TComponent; Operation: TOperation); override;
 public
  constructor Create(AOwner: TComponent); override;
  destructor Destroy; override;
  property PluginsList:TSubjPlgList read FPlgList;
  procedure Run(Index:Integer);
  procedure RefreshList;
 published
  property Source:TSubjSource read FSource write SetSource;
  property Grid:TSubjGrid read FGrid write SetGrid;
  property FileExt:String read FFileExt write SetFileExt;
  property Path:String read GetPath write SetPath;
 End;
 ////////////////////// x //////////////////////
Const
 stToken='Nail of the program';
implementation

uses Windows, SysUtils, ExptIntf, publ;

{ TSubjCustomPlugin }

procedure TSubjCustomPlugin.SetSubjSource(const Value: TSubjSource);
begin
 FSubjSource := Value;
end;

{ TSubjPluginSupport }
constructor TSubjPluginSupport.Create(AOwner: TComponent);
begin
 inherited;
 FPlgList:=TSubjPlgList.Create(true);
 if ToolServices <> nil
  then Begin
   FPath:=ToolServices.GetProjectName;
   FPath:=ExtractFilePath(FPath);
  End else FPath:=ProgramPath;
 FFileExt:='RPL';
 RefreshList;
end;

destructor TSubjPluginSupport.Destroy;
begin
 FPlgList.Clear(true);
 FPlgList.Free;
 inherited;
end;

function TSubjPluginSupport.GetPath: String;
begin
 if (FPath='') and not (csDesigning in ComponentState)
 then Result:=ProgramPath
 else Result:=FPath;
end;

procedure TSubjPluginSupport.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
 inherited;
 if Operation=opRemove then Begin
  if AComponent=FSource then FSource:=nil;
  if AComponent=FGrid then FGrid:=nil;
 End;
end;

procedure TSubjPluginSupport.RefreshList;
Var
 fs,fs2:TSearchRec;
 r:integer;
 us:boolean;
 dll:Cardinal;
 AName,ADiscript,AToken:TStrProc;
begin
 FPlgList.Clear(true);
 r:=FindFirst(Path+'*.'+FFileExt,$2f,fs2);
 While r=0 do Begin
  fs:=fs2;
  r:=FindNext(fs2);
  dll:=SafeLoadLibrary(PChar(Path+fs.Name));
  if dll=0 then Exit;
  @AToken:=GetProcAddress(dll,'Token');
  us:=Assigned(AToken);
  if us then us:=AToken=stToken;
  if not us then Begin
   FreeLibrary(dll);
   Continue;
  End;
  @AName:=GetProcAddress(dll,'GetName');
  @ADiscript:=GetProcAddress(dll,'GetDiscription');
  With TSubjPlgItem.Create do Begin
   FPlgList.Add(Im);
   if Assigned(AName) then Name:=AName;
   if Assigned(ADiscript) then Description:=ADiscript;
   FileName:=Path+fs.Name;
   State:=[];
  End;
  FreeLibrary(dll);
 End;
end;

procedure TSubjPluginSupport.Run(Index:Integer);
Var
 s:String;
 plg:TSubjCustomPlugin;
 dll:Cardinal;
 plgProc:TGetClassProc;
begin
 if (Index<0) or (Index>PluginsList.Count-1) then Exit;
 s:=PluginsList[index].FFileName;
 dll:=SafeLoadLibrary(s);
 if dll<>0 then Begin
  @plgProc:=GetProcAddress(dll,'GetPlugin');
  if Assigned(plgProc) then Begin
   plg:=plgProc.Create;
   plg.SubjSource:=Source;
   plg.Run;
   plg.Free;
  End;
  FreeLibrary(dll);
 End;
end;

procedure TSubjPluginSupport.SetFileExt(const Value: String);
begin
 FFileExt := Value;
 RefreshList;
end;

procedure TSubjPluginSupport.SetGrid(const Value: TSubjGrid);
begin
 if FGrid<>nil then FGrid.RemoveFreeNotification(self);
 FGrid := Value;
 if FGrid<>nil then FGrid.FreeNotification(self);
end;

procedure TSubjPluginSupport.SetPath(const Value: String);
begin
 FPath := Value;
 RefreshList;
end;

procedure TSubjPluginSupport.SetSource(const Value: TSubjSource);
begin
 if FSource<>nil then FSource.RemoveFreeNotification(self);
 FSource := Value;
 if FSource<>nil then FSource.FreeNotification(self);
end;

{ TSubjPlgItem }

procedure TSubjPlgItem.SetDescription(const Value: String);
begin
  FDescription := Value;
end;

procedure TSubjPlgItem.SetFileName(const Value: String);
begin
 FFileName:=Value;
end;

procedure TSubjPlgItem.SetName(const Value: String);
begin
 FName := Value;
end;

procedure TSubjPlgItem.SetState(const Value: TSubjPlgState);
begin
 FState := Value;
end;

{ TSubjPlgList }

function TSubjPlgList.GetItems(x: integer): TSubjPlgItem;
begin
 result:=TSubjPlgItem(inherited item[x]);
end;

procedure TSubjPlgList.SetItems(x: integer; const Value: TSubjPlgItem);
begin
 inherited item[x]:=Value;
end;

end.
