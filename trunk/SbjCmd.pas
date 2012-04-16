unit SbjCmd;

interface

uses Windows, Controls, Classes, ActnList, SbjResource, SbjGrd, SbjSrc;

type
  TActState = (asCheck, asAutoCheck);
  TActSet = set of TActState;
 /////////////////// x ///////////////////
  TSubjImageList = class (TImageList)
  private
    FParent: TComponent;
  protected
    procedure SetParentComponent(Value: TComponent); override;
  public
    function GetParentComponent: TComponent; override;
    function HasParent: Boolean; override;
  end;
 ////////////////////// x //////////////////////
  TSubjCmds = class (TComponent)
  private
    ActionList: TActionList;
    CMActions: array[cmKlass..cmKabinet] of TAction;
    FGrid: TSubjGrid;
    FSubjSource: TSubjSource;
    ImageList: TSubjImageList;
    LockDayAct: TAction;
    LockLessAct: TAction;
    TCActions: array[tcSubject..tcKabinet] of TAction;
    VMActions: array[vmSubjects..vmLessons] of TAction;
    vwFullViewAct: TAction;
    vwSanPINAct: TAction;
    vwTextAct: TAction;
    function GenerateAction(ACategory: string; ATag: Integer; AonExecute: TNotifyEvent; AImageIndex, AGroupIndex: Integer; AActSet: TActSet; ACaption: String; AShortCut: TShortCut): TAction; {end GenerateAction}
    procedure ActUpdate(Sender: TObject);
    procedure CMExecute(Sender: TObject);
    procedure InitActionList;
    procedure InitImList;
    procedure LockExecute(Sender: TObject);
    procedure SetGrid(const Value: TSubjGrid);
    procedure SetSubjSource(const Value: TSubjSource);
    procedure TCExecute(Sender: TObject);
    procedure VMExecute(Sender: TObject);
    procedure VwExecute(Sender: TObject);
  protected
    procedure SetName(const NewName: TComponentName); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Grid: TSubjGrid read FGrid write SetGrid;
    property Source: TSubjSource read FSubjSource write SetSubjSource;
  end;
 /////////////////// x ///////////////////
implementation

uses Graphics;

{$R Images.res}
//////////////////////////////////////////////////
              { TSubjImageList }
//////////////////////////////////////////////////
{protected}
procedure TSubjImageList.SetParentComponent(Value: TComponent);
begin
  FParent := Value;
end;

{public}
function TSubjImageList.GetParentComponent: TComponent;
begin
  Result := FParent;
end;

function TSubjImageList.HasParent: Boolean;
begin
  result := true;
end;

//////////////////////////////////////////////////
               { TSubjCmds }
//////////////////////////////////////////////////
{private}
function TSubjCmds.GenerateAction(ACategory: string;
  ATag: Integer; AonExecute: TNotifyEvent; AImageIndex, AGroupIndex: Integer;
  AActSet: TActSet; ACaption: String; AShortCut: TShortCut): TAction;
begin
  Result := TAction.Create(Owner);
  Result.ActionList := ActionList;
  with Result do begin
    Category := ACategory;
    Tag := ATag;
    onExecute := AonExecute;
    ImageIndex := AImageIndex;
    GroupIndex := AGroupIndex;
    Checked := asCheck in AActSet;
    AutoCheck := asAutoCheck in AActSet;
    Caption := ACaption;
    ShortCut := AShortCut;
  end;
end;

procedure TSubjCmds.ActUpdate(Sender: TObject);
var
  act: TAction;
begin
  act := TAction(Sender);
  if act.Checked then begin
    if act.Caption[1] = ' ' then
      act.Caption := Copy(act.Caption, 4, MaxInt);
  end
  else
  if act.Caption[1] <> ' ' then
    act.Caption := '   ' + act.Caption;
end;

procedure TSubjCmds.CMExecute(Sender: TObject);
begin
  if FSubjSource = nil then
    Exit;
  with FSubjSource do
    case TControl(Sender).tag of
      1:
        ColumnMode := cmKlass;
      2:
        ColumnMode := cmTeacher;
      3:
        ColumnMode := cmKabinet;
    end;
end;

procedure TSubjCmds.InitActionList;
var
  i: integer;
  Exec: TNotifyEvent;
  s1, s2: TActSet;
begin
  ActionList.Images := ImageList;
  Exec := CMExecute;
  s1 := [asCheck, asAutoCheck];
  s2 := [asAutoCheck];
  CMActions[cmKlass] := GenerateAction('Заголовки', 1, Exec, 0, 1,
    s1, cmCapts[cmKlass], scCtrl + VK_F5);
  CMActions[cmTeacher] := GenerateAction('Заголовки', 2, Exec, 1, 1,
    s2, cmCapts[cmTeacher], scCtrl + VK_F6);
  CMActions[cmKabinet] := GenerateAction('Заголовки', 3, Exec, 2, 1,
    s2, cmCapts[cmKabinet], scCtrl + VK_F7);
  Exec := TCExecute;
  TCActions[tcSubject] := GenerateAction('Клетки', 1, Exec, 3, 2,
    s1, tcCapts[tcSubject], scCtrl + VK_F8);
  TCActions[tcTeacher] := GenerateAction('Клетки', 2, Exec, 4, 2,
    s2, tcCapts[tcTeacher], scCtrl + VK_F9);
  TCActions[tcKabinet] := GenerateAction('Клетки', 3, Exec, 5, 2,
    s2, tcCapts[tcKabinet], scCtrl + VK_F10);
  Exec := VMExecute;
  VMActions[vmSubjects] := GenerateAction('Список', 1, Exec, 7, 3,
    s1, vmCapts[vmSubjects], VK_F5);
  VMActions[vmColumns] := GenerateAction('Список', 2, Exec, 8, 3,
    s2, vmCapts[vmColumns], VK_F6);
  VMActions[vmWeekDays] := GenerateAction('Список', 3, Exec, 9, 3,
    s2, vmCapts[vmWeekDays], VK_F7);
  VMActions[vmLessons] := GenerateAction('Список', 4, Exec, 10, 3,
    s2, vmCapts[vmLessons], VK_F8);
  vwFullViewAct := GenerateAction('Вид', 1, VwExecute, 13, 0, [asAutoCheck], stVwFullView, 0);
  vwSanPINAct := GenerateAction('Вид', 2, VwExecute, 14, 0, [asAutoCheck, asCheck], stVwSanPin, 0);
  vwTextAct := GenerateAction('Вид', 3, VwExecute, 15, 0, [asAutoCheck, asCheck], stVwText, 0);
  LockLessAct := GenerateAction('Клетки', 1, LockExecute, 11, 0, [asAutoCheck], stLockLesson, 0);
  LockDayAct := GenerateAction('Клетки', 2, LockExecute, 12, 0, [asAutoCheck], stLockDay, 0);
  for i := 0 to ActionList.ActionCount - 1 do
    ActionList.Actions[i].OnUpdate := ActUpdate;
end;

procedure TSubjCmds.InitImList;
var
  bm: TBitMap;
begin
  ImageList.FreeNotification(self);
  bm := TBitmap.Create;
  bm.LoadFromResourceName(HInstance, 'main');
  ImageList.AddMasked(Bm, clFuchsia);
  bm.Free;
end;

procedure TSubjCmds.LockExecute(Sender: TObject);
begin

end;

procedure TSubjCmds.SetGrid(const Value: TSubjGrid);
begin
  if FGrid <> nil then
    FGrid.RemoveFreeNotification(self);
  FGrid := Value;
  if FGrid <> nil then begin
    FGrid.FreeNotification(self);
    TCActions[FGrid.TableContent].Checked := true;
  end;
end;

procedure TSubjCmds.SetSubjSource(const Value: TSubjSource);
begin
  if FSubjSource <> nil then
    FSubjSource.RemoveFreeNotification(self);
  FSubjSource := Value;
  if FSubjSource <> nil then begin
    FSubjSource.FreeNotification(self);
    CMActions[FSubjSource.ColumnMode].Checked := true;
  end;
end;

procedure TSubjCmds.TCExecute(Sender: TObject);
begin
  if Grid = nil then
    Exit;
  with Grid do
    case TControl(Sender).tag of
      1:
        TableContent := tcSubject;
      2:
        TableContent := tcTeacher;
      3:
        TableContent := tcKabinet;
    end;
end;

procedure TSubjCmds.VMExecute(Sender: TObject);
begin
  if FSubjSource = nil then
    Exit;
  with FSubjSource do
    case TControl(Sender).tag of
      1:
        ViewMode := vmSubjects;
      2:
        ViewMode := vmColumns;
      3:
        ViewMode := vmWeekDays;
      4:
        ViewMode := vmLessons;
    end;
end;

procedure TSubjCmds.VwExecute(Sender: TObject);
begin
  if Grid = nil then
    Exit;
  case TControl(Sender).Tag of
    1:
      Grid.FullView := TAction(Sender).Checked;
    2: ;
    3:
      Grid.ViewText := TAction(Sender).Checked;
  end;
end;

{protected}
procedure TSubjCmds.SetName(const NewName: TComponentName);
begin
  inherited;
  ImageList.Name := NewName + 'ImLst';
  CMActions[cmKlass].Name := NewName + '_CM_Klass';
  CMActions[cmTeacher].Name := NewName + '_CM_Teacher';
  CMActions[cmKabinet].Name := NewName + '_CM_Kabinet';
  TCActions[tcSubject].Name := NewName + '_TC_Subject';
  TCActions[tcTeacher].Name := NewName + '_TC_Teacher';
  TCActions[tcKabinet].Name := NewName + '_TC_Kabinet';
  VMActions[vmSubjects].Name := NewName + '_VM_Subjects';
  VMActions[vmColumns].Name := NewName + '_VM_Columns';
  VMActions[vmWeekDays].Name := NewName + '_VM_WeekDays';
  VMActions[vmLessons].Name := NewName + '_VM_Lessons';
  vwFullViewAct.Name := NewName + '_VW_FullView';
  vwTextAct.Name := NewName + '_VW_TextAct';
  vwSanPINAct.Name := NewName + '_VW_SanPIN';
  LockLessAct.Name := NewName + '_LockLess';
  LockDayAct.Name := NewName + '_LockDay';
end;

procedure TSubjCmds.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (ImageList = AComponent) and (Operation = opRemove) then begin
    ImageList := nil;
    if not (csDestroying in Owner.ComponentState) then begin
      ImageList := TSubjImageList.Create(Owner);
      ImageList.FreeNotification(self);
    end;
  end;
  if (ActionList = AComponent) and (Operation = opRemove) then
    ActionList := nil;
  if (FSubjSource = AComponent) and (Operation = opRemove) then
    FSubjSource := nil;
  if (FGrid = AComponent) and (Operation = opRemove) then
    FGrid := nil;
end;

{public}
constructor TSubjCmds.Create(AOwner: TComponent);
begin
  inherited;
  ImageList := TSubjImageList.Create(AOwner);
  ImageList.SetParentComponent(self);
  InitImList;
  ActionList := TActionList.Create(self);
  InitActionList;
end;

destructor TSubjCmds.Destroy;
begin
  ImageList.Free;
  inherited;
end;

end.
