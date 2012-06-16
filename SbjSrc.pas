unit SbjSrc;

interface

uses SbjColl, Classes, SbjKernel, SbjResource, ViewLog;

type
 ////////////////////// Enums //////////////////////
  TSubjEvent = (seChangeTimeTable, seChangeSubjects, seChangeColumnMode,
    seChangeViewMode, seChangeCurrentSubject, seChangeCurrentKlass,
    seChangeCurrentKabinet, seChangeCurrentTeacher,
    seChangeCurrentLesson, seCheckKabinet, seCheckKlass,
    seCheckTeacher, seCheckLesson, seCheckWeekDay, seChangeKlasses,
    seChangeTeachers, seChangeKabinets, seRefresh);
  TSetLessons = set of (lsZero, lsFirst, lsSecond, lsThird, lsFourth,
    lsFifth, lsSixth, lsSeventh, lsEighth, lsNinth, lsTenth);
 ////////////////////// Events //////////////////////
  TChColumnMode = procedure(Sender: TObject; ColumnModeIndex: TColumnMode) of object;
  TCheckEvent = procedure(Sender: TObject; Index: integer) of object;
  TChViewMode = procedure(Sender: TObject; ViewModeIndex: TViewMode) of object;
  TError = (erNotKlasses, erNotKabinets, erNotTeachers, erNotWeekDays, erNotLessons);
  TErrorEvent = procedure(Sender: TObject; Error: TError) of object;
 ////////////////////// x //////////////////////
  s11 = set of 0..10;
 ////////////////////// x //////////////////////
  TSubjLink = class (TCollItem)
  private
    FOnChangeColumnMode: TchColumnMode;
    FOnChangeCurrentKabinet: TNotifyEvent;
    FOnChangeCurrentKlass: TNotifyEvent;
    FOnChangeCurrentLesson: TNotifyEvent;
    FOnChangeCurrentSubject: TNotifyEvent;
    FOnChangeCurrentTeacher: TNotifyEvent;
    FOnChangeKabinets: TCheckEvent;
    FOnChangeKlasses: TCheckEvent;
    FOnChangeSubjects: TNotifyEvent;
    FOnChangeTeachers: TCheckEvent;
    FOnChangeTimeTable: TNotifyEvent;
    FOnChangeViewMode: TchViewMode;
    FOnCheckKabinet: TCheckEvent;
    FOnCheckKlass: TCheckEvent;
    FOnCheckLesson: TCheckEvent;
    FOnCheckTeacher: TCheckEvent;
    FOnCheckWeekDay: TCheckEvent;
    FOnRefresh: TNotifyEvent;
  protected
    procedure DoChangeCM(Info: Integer);
    procedure DoChangeVM(Info: Integer);
    procedure DoCheck(Event: TCheckEvent; Info: Integer);
    procedure DoNotify(Event: TNotifyEvent);
  public
    procedure SubjEvent(Event: TSubjEvent; Info: integer);
    property OnChangeColumnMode: TchColumnMode read FOnChangeColumnMode write FOnChangeColumnMode;
    property OnChangeCurrentKabinet: TNotifyEvent read FOnChangeCurrentKabinet write FOnChangeCurrentKabinet;
    property OnChangeCurrentKlass: TNotifyEvent read FOnChangeCurrentKlass write FOnChangeCurrentKlass;
    property OnChangeCurrentLesson: TNotifyEvent read FOnChangeCurrentLesson write FOnChangeCurrentLesson;
    property OnChangeCurrentSubject: TNotifyEvent read FOnChangeCurrentSubject write FOnChangeCurrentSubject;
    property OnChangeCurrentTeacher: TNotifyEvent read FOnChangeCurrentTeacher write FOnChangeCurrentTeacher;
    property OnChangeKabinets: TCheckEvent read FOnChangeKabinets write FOnChangeKabinets;
    property OnChangeKlasses: TCheckEvent read FOnChangeKlasses write FOnChangeKlasses;
    property OnChangeSubjects: TNotifyEvent read FOnChangeSubjects write FOnChangeSubjects;
    property OnChangeTeachers: TCheckEvent read FOnChangeTeachers write FOnChangeTeachers;
    property OnChangeTimeTable: TNotifyEvent read FOnChangeTimeTable write FOnChangeTimeTable;
    property OnChangeViewMode: TchViewMode read FOnChangeViewMode write FOnChangeViewMode;
    property OnCheckKabinet: TCheckEvent read FOnCheckKabinet write FOnCheckKabinet;
    property OnCheckKlass: TCheckEvent read FOnCheckKlass write FOnCheckKlass;
    property OnCheckLesson: TCheckEvent read FOnCheckLesson write FOnCheckLesson;
    property OnCheckTeacher: TCheckEvent read FOnCheckTeacher write FOnCheckTeacher;
    property OnCheckWeekDay: TCheckEvent read FOnCheckWeekDay write FOnCheckWeekDay;
    property OnRefresh: TNotifyEvent read FOnRefresh write FOnRefresh;
  end;
 ////////////////////// x //////////////////////
  TSubjLinks = class (TColl)
  private
    function GetItems(x: integer): TSubjLink;
    procedure SetItems(x: integer; const Value: TSubjLink);
  public
    property Items[x: integer]: TSubjLink read GetItems write SetItems; default;
  end;
 ////////////////////// x //////////////////////
  TSubjSource = class ;
 ////////////////////// x //////////////////////
  TSubjCustomManager = class (TComponent)
  private
    FLesson: Integer;
    FSource: TSubjSource;
    FState: TSubjState;
    FSubject: TSubject;
  public
    function Run: boolean; virtual;
    property Lesson: Integer read FLesson write FLesson;
    property Source: TSubjSource read FSource write FSource;
    property State: TSubjState read FState write FState;
    property Subject: TSubject read FSubject write FSubject;
  end;
 ////////////////////// x //////////////////////
  TCollisionEvent = procedure(Sender: TObject; ALesson: integer; ASubject: TSubject; AState: TSubjState; var CanAdd: boolean) of object;
 ////////////////////// x //////////////////////
  TSubjSource = class (TComponent)
  private
    FActivate: boolean;
    FColumnMode: TColumnMode;
    FCurrentKabinet: TKabinet;
    FCurrentKlass: TKlass;
    FCurrentLesson: integer;
    FCurrentSubject: TSubject;
    FCurrentTeacher: TTeacher;
    FFileName: String;
    FOnError: TErrorEvent;
    FViewMode: TViewMode;
    IndexOfChangeKlass: integer;
    KlassChangeGood: boolean;
    FSubjLinks: TSubjLinks;
    Subjs: TSubjects;
    FManager: TSubjCustomManager;
    FOnCollision: TCollisionEvent;
    function DoCollision(ALesson: integer; ASubject: TSubject; AState: TSubjState): boolean;
    function GetKabinets: TKabinets;
    function GetKlasses: TKlasses;
    function GetLessonCount: integer;
    function GetLessons: s11;
    function GetLocked: boolean;
    function GetTeachers: TTeachers;
    function GetTimeTable: TTimeTable;
    function GetWeekDayCount: integer;
    function GetWeekDays: TSetWeekDays;
    function RunEvents(ALesson: integer; ASubject: TSubject; AState: TSubjState): boolean;
    function RunManager(ALesson: integer; ASubject: TSubject; AState: TSubjState): boolean;
    procedure _Change(Sender: TObject; TypeOfSubj: TTypeOfData; Index: Integer);
    procedure _Delete(Sender: TObject; TypeOfSubj: TTypeOfData; Index: Integer);
    procedure _GetList(Sender: TObject; TypeOfSubj: TTypeOfData; short: boolean; Strings: TStrings);
    procedure _Insert(Sender: TObject; TypeOfSubj: TTypeOfData);
    procedure ChangeKabinet(Kabinet: TKabinet);
    procedure ChangeSubject(Subject: TSubject);
    procedure ChangeLesson(Lesson: TLesson);
    procedure ChangeTeacher(Teacher: TTeacher);
    procedure CreateKabinet;
    procedure CreateSubject;
    procedure CreateTeacher;
    procedure DeleteKabinet(Kabinet: TKabinet);
    procedure DeleteSubject(Subject: TSubject);
    procedure DeleteTeacher(Teacher: TTeacher);
    procedure InitKabinetDlg;
    procedure InitSubjDlg;
    procedure InitTeacherDlg;
    procedure KlassClick(Sender: TObject);
    procedure KlassEnter(Sender: TObject);
    procedure KlassExit(Sender: TObject);
    procedure KlassUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure NotifyLink(Event: TSubjEvent; info: integer = -1);
    procedure SetActivate(const Value: boolean);
    procedure SetColumnMode(const Value: TColumnMode);
    procedure SetCurrentKabinet(const Value: TKabinet);
    procedure SetCurrentKlass(const Value: TKlass);
    procedure SetCurrentLesson(const Value: integer);
    procedure SetCurrentSubject(const Value: TSubject);
    procedure SetCurrentTeacher(const Value: TTeacher);
    procedure SetFileName(const Value: String);
    procedure SetLessons(const Value: s11);
    procedure SetManager(const Value: TSubjCustomManager);
    procedure SetViewMode(const Value: TViewMode);
    procedure SetWeekDays(const Value: TSetWeekDays);
    procedure SwapKabinets(ind1, ind2: integer);
    procedure SwapKlasses(ind1, ind2: integer);
    procedure SwapSubjects(ind1, ind2: integer);
    procedure SwapTeachers(ind1, ind2: integer);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function AddKlass(st: String): integer;
    function IsCross(sub1, sub2: TSubject): boolean;
    function StateOf(ASubject: TSubject; ALesson: Integer): TSubjState;
    procedure Add(TypeOfSubj: TTypeOfData);
    procedure AddCell(Lesson: integer; Subject: TSubject);
    procedure Change(Item: TCollItem);
    procedure ChangeKlass(Klass: TKlass; s: string);
    procedure CheckUp(Item: TCollItem);
    procedure CheckUpKabinet(Kabinet: TKabinet);
    procedure CheckUpKlass(Klass: TKlass);
    procedure CheckUpLesson(LessonIndex: integer);
    procedure CheckUpTeacher(Teacher: TTeacher);
    procedure CheckUpWeekDay(WDIndex: TWeekDay);
    procedure Delete(Item: TCollItem);
    procedure DeleteCell(Lesson: integer; Kabinet: TKabinet); overload;
    procedure DeleteCell(Lesson: integer; Klass: TKlass); overload;
    procedure DeleteCell(Lesson: integer; Subject: TSubject); overload;
    procedure DeleteCell(Lesson: integer; Teacher: TTeacher); overload;
    procedure Load(AFileName: string = '');
    procedure LoadTxt(AFileName: string = '');
    procedure Save(AFileName: string = '');
    procedure SaveTxt(AFileName: string = '');
    procedure Swap(TypeOfSubj: TTypeOfData; Ind1, Ind2: integer);
    procedure SwitchLock;
    property CurrentKabinet: TKabinet read FCurrentKabinet write SetCurrentKabinet;
    property CurrentKlass: TKlass read FCurrentKlass write SetCurrentKlass;
    property CurrentLesson: integer read FCurrentLesson write SetCurrentLesson;
    property CurrentSubject: TSubject read FCurrentSubject write SetCurrentSubject;
    property CurrentTeacher: TTeacher read FCurrentTeacher write SetCurrentTeacher;
    property Kabinets: TKabinets read GetKabinets;
    property Klasses: TKlasses read GetKlasses;
    property Locked: boolean read GetLocked;
    property Teachers: TTeachers read GetTeachers;
    property TimeTable: TTimeTable read GetTimeTable;
    property SubjLinks: TSubjLinks read FSubjLinks;
  published
    property Activate: boolean read FActivate write SetActivate;
    property ColumnMode: TColumnMode read FColumnMode write SetColumnMode;
    property FileName: String read FFileName write SetFileName;
    property LessonCount: integer read GetLessonCount;
    property Lessons: s11 read GetLessons write SetLessons;
    property Manager: TSubjCustomManager read FManager write SetManager;
    property OnCollision: TCollisionEvent read FOnCollision write FOnCollision;
    property OnError: TErrorEvent read FOnError write FOnError;
    property ViewMode: TViewMode read FViewMode write SetViewMode;
    property WeekDayCount: integer read GetWeekDayCount;
    property WeekDays: TSetWeekDays read GetWeekDays write SetWeekDays;
  end;

implementation

uses Windows, SysUtils, Menus, publ, StrUtils, SbjKabDlg, SbjSubjDlg,
  SbjTeachDlg;

{$R Text.res}
//////////////////////////////////////////////////
               { TSubjLink }
//////////////////////////////////////////////////
{protected}
procedure TSubjLink.DoChangeCM(Info: Integer);
begin
  if Assigned(FonChangeColumnMode) then
    FonChangeColumnMode(self, TColumnMode(Info));
end;

procedure TSubjLink.DoChangeVM(Info: Integer);
begin
  if Assigned(FonChangeViewMode) then
    FonChangeViewMode(self, TViewMode(Info));
end;

procedure TSubjLink.DoCheck(Event: TCheckEvent; Info: Integer);
begin
  if Assigned(Event) then
    Event(self, Info);
end;

procedure TSubjLink.DoNotify(Event: TNotifyEvent);
begin
  if Assigned(Event) then
    Event(self);
end;

{public}
procedure TSubjLink.SubjEvent(Event: TSubjEvent; Info: integer);
begin
  case Event of
    seChangeColumnMode:
      DoChangeCM(Info);
    seChangeViewMode:
      DoChangeVM(Info);
    seChangeCurrentKabinet:
      DoNotify(FOnChangeCurrentKabinet);
    seChangeCurrentKlass:
      DoNotify(FOnChangeCurrentKlass);
    seChangeCurrentLesson:
      DoNotify(FOnChangeCurrentLesson);
    seChangeCurrentSubject:
      DoNotify(FOnChangeCurrentSubject);
    seChangeCurrentTeacher:
      DoNotify(FOnChangeCurrentTeacher);
    seChangeSubjects:
      DoNotify(FOnChangeSubjects);
    seChangeTimeTable:
      DoNotify(FOnChangeTimeTable);
    seRefresh:
      DoNotify(FonRefresh);
    seChangeKlasses:
      DoCheck(FOnChangeKlasses, info);
    seChangeTeachers:
      DoCheck(FOnChangeTeachers, info);
    seChangeKabinets:
      DoCheck(FOnChangeKabinets, info);
    seCheckKlass:
      DoCheck(FOnCheckKlass, info);
    seCheckTeacher:
      DoCheck(FOnCheckTeacher, info);
    seCheckKabinet:
      DoCheck(FOnCheckKabinet, info);
    seCheckWeekDay:
      DoCheck(FOnCheckWeekDay, info);
    seCheckLesson:
      DoCheck(FOnCheckLesson, info);
  end;
end;

//////////////////////////////////////////////////
              { TSubjLinks }
//////////////////////////////////////////////////
{private}
function TSubjLinks.GetItems(x: integer): TSubjLink;
begin
  result := TSubjLink(GetItem(x));
end;

procedure TSubjLinks.SetItems(x: integer; const Value: TSubjLink);
begin
  inherited SetItem(x, Value);
end;

//////////////////////////////////////////////////
             { TSubjCustomManager }
//////////////////////////////////////////////////
{public}
function TSubjCustomManager.Run: boolean;
begin
  result := true;
end;

//////////////////////////////////////////////////
                { TSubjSource }
//////////////////////////////////////////////////
{private}
function TSubjSource.DoCollision(ALesson: integer; ASubject: TSubject;
  AState: TSubjState): boolean;
begin
  if FManager <> nil then
    result := RunManager(ALesson, ASubject, AState)
  else
    result := RunEvents(ALesson, ASubject, AState);
end;

function TSubjSource.GetKabinets: TKabinets;
begin
  result := Subjs.Kabinets;
end;

function TSubjSource.GetKlasses: TKlasses;
begin
  result := Subjs.Klasses;
end;

function TSubjSource.GetLessonCount: integer;
var
  I: integer;
begin
  result := 0;
  for I := 0 to 10 do
    if I in Subjs.Lessons then
      inc(Result);
end;

function TSubjSource.GetLessons: s11;
begin
  Result := subjs.Lessons;
end;

function TSubjSource.GetLocked: boolean;
var
  si: TSimpleItem;
begin
  result := true;
  case ColumnMode of
    cmKlass:
      si := CurrentKlass;
    cmTeacher:
      si := CurrentTeacher;
    cmKabinet:
      si := CurrentKabinet;
  else
    Exit;
  end;
  if si = nil then
    Exit;
  result := si.IsLock(CurrentLesson);
end;

function TSubjSource.GetTeachers: TTeachers;
begin
  result := Subjs.Teachers;
end;

function TSubjSource.GetTimeTable: TTimeTable;
begin
  Result := Subjs.TimeTable;
end;

function TSubjSource.GetWeekDayCount: integer;
var
  I: TWeekDay;
begin
  result := 0;
  for I := wdMonday to wdSunday do
    if I in Subjs.WeekDays then
      inc(Result);
end;

function TSubjSource.GetWeekDays: TSetWeekDays;
begin
  result := Subjs.WeekDays;
end;

function TSubjSource.RunEvents(ALesson: integer; ASubject: TSubject;
  AState: TSubjState): boolean;
begin
  Result := true;
  if Assigned(FOnCollision) then
    FOnCollision(self, ALesson, ASubject, AState, Result);
end;

function TSubjSource.RunManager(ALesson: integer; ASubject: TSubject;
  AState: TSubjState): boolean;
begin
  result := true;
  if FManager = nil then
    Exit;
  FManager.Source := self;
  FManager.Lesson := ALesson;
  FManager.Subject := ASubject;
  FManager.State := AState;
  Result := FManager.Run;
end;

procedure TSubjSource._Change(Sender: TObject; TypeOfSubj: TTypeOfData;
  Index: Integer);
var
  Teacher: TTeacher;
  Kabinet: TKabinet;
begin
  case TypeOfSubj of
    todTeacher:
    begin
      Teacher := Subjs.Teachers[Index];
      if Teacher = nil then
        Exit;
      ChangeTeacher(Teacher);
    end;
    todKabinet:
    begin
      Kabinet := Subjs.Kabinets[Index];
      if Kabinet = nil then
        Exit;
      ChangeKabinet(Kabinet);
    end;
    todKlass:
      if Sender is TSubjectDlg then
        with SubjectDlg do begin
          IndexOfChangeKlass := cbKlass.ItemIndex;
          if IndexOfChangeKlass = -1 then
            Exit;
          if edKlass.Enabled then
            edKlass.SetFocus;
        end;
  end;
end;

procedure TSubjSource._Delete(Sender: TObject; TypeOfSubj: TTypeOfData;
  Index: Integer);
var
  Teacher: TTeacher;
  Kabinet: TKabinet;
begin
  case TypeOfSubj of
    todTeacher:
    begin
      Teacher := Subjs.Teachers[Index];
      DeleteTeacher(Teacher);
    end;
    todKabinet:
    begin
      Kabinet := Subjs.Kabinets[Index];
      DeleteKabinet(Kabinet);
    end;
  end;
end;

procedure TSubjSource._GetList(Sender: TObject; TypeOfSubj: TTypeOfData;
  short: boolean; Strings: TStrings);
var
  sts: TStrings;
begin
  case TypeOfSubj of
    todKlass:
      sts := Klasses.Lines(short);
    todTeacher:
      sts := Teachers.Lines(short);
    todKabinet:
      sts := Kabinets.Lines(short);
    todName:
      sts := Subjs.SubjectNames;
  else
    Exit;
  end;
  Strings.Assign(sts);
end;

procedure TSubjSource._Insert(Sender: TObject; TypeOfSubj: TTypeOfData);
begin
  case TypeOfSubj of
    todTeacher:
      CreateTeacher;
    todKabinet:
      CreateKabinet;
    todKlass:
      if Sender is TSubjectDlg then
        with SubjectDlg do begin
          IndexOfChangeKlass := -1;
          if edKlass.Enabled then
            edKlass.SetFocus;
        end;
    todName:
      if Sender is TSubjectDlg then
        with SubjectDlg do
          Subjs.SubjectNames.Add(edLongName.Text, edShortName.Text
            , StrToInt(edSanPIN.Text));
  end;
end;

procedure TSubjSource.ChangeKabinet(Kabinet: TKabinet);
begin
  if Kabinet = nil then
    Exit;
  InitKabinetDlg;
  if KabinetDlg.Execute(Kabinet) then begin
    Kabinet.Name := KabinetDlg.Kabinet.Name;
    Kabinet.Num := KabinetDlg.Kabinet.Num;
    Kabinet.ShowNum := KabinetDlg.Kabinet.ShowNum;
    NotifyLink(seChangeKabinets, Kabinet.ItemIndex);
  end;
end;

procedure TSubjSource.ChangeSubject(Subject: TSubject);
begin
  if Subject = nil then
    Exit;
  InitSubjDlg;
  if SubjectDlg.Execute(Subject, nil) then begin
    Subject.Assign(SubjectDlg.Subject);
    NotifyLink(seChangeSubjects, Subject.ItemIndex);
  end;
end;

procedure TSubjSource.ChangeTeacher(Teacher: TTeacher);
begin
  if Teacher = nil then
    Exit;
  InitTeacherDlg;
  if TeacherDlg.Execute(Teacher) then begin
    Teacher.Name := TeacherDlg.Teacher.Name;
    Teacher.KabNum := TeacherDlg.Teacher.KabNum;
    NotifyLink(seChangeTeachers, Teacher.ItemIndex);
  end;
end;

procedure TSubjSource.CheckUpKabinet(Kabinet: TKabinet);
begin
  if Kabinet = nil then
    Exit;
  Kabinet.Checked := not Kabinet.Checked;
  NotifyLink(seCheckKabinet, Kabinet.ItemIndex);
end;

procedure TSubjSource.CheckUpKlass(Klass: TKlass);
begin
  if Klass = nil then
    Exit;
  Klass.Checked := not Klass.Checked;
  NotifyLink(seCheckKlass, Klass.ItemIndex);
end;

procedure TSubjSource.CheckUpTeacher(Teacher: TTeacher);
begin
  if Teacher = nil then
    Exit;
  Teacher.Checked := not Teacher.Checked;
  NotifyLink(seCheckTeacher, Teacher.ItemIndex);
end;

procedure TSubjSource.CreateKabinet;
var
  Kabinet: TKabinet;
begin
  InitKabinetDlg;
  if KabinetDlg.Execute(nil) then begin
    Kabinet := TKabinet.Create;
    Kabinet.Assign(KabinetDlg.Kabinet);
    CurrentKabinet := Kabinet;
    NotifyLink(seChangeKabinets, Kabinets.Add(Kabinet));
  end;
end;

procedure TSubjSource.CreateSubject;
var
  Subject: TSubject;
  Curr: TSimpleItem;
begin
  InitSubjDlg;
  Curr := nil;
  case ColumnMode of
    cmKlass:
      Curr := CurrentKlass;
    cmTeacher:
      Curr := CurrentTeacher;
    cmKabinet:
      Curr := CurrentKabinet;
  end;
  if SubjectDlg.Execute(nil, Curr) then begin
    Subject := Subjs.Add;
    Subject.Assign(SubjectDlg.Subject);
    CurrentSubject := Subject;
    NotifyLink(seChangeSubjects, Subjs.Add(Subject));
  end;
end;

procedure TSubjSource.CreateTeacher;
var
  Teacher: TTeacher;
begin
  InitTeacherDlg;
  if TeacherDlg.Execute(nil) then begin
    Teacher := TTeacher.Create;
    Teacher.Assign(TeacherDlg.Teacher);
    CurrentTeacher := Teacher;
    NotifyLink(seChangeTeachers, Teachers.Add(Teacher));
  end;
end;

procedure TSubjSource.DeleteKabinet(Kabinet: TKabinet);
begin
  if Kabinet = nil then
    Exit;
end;

procedure TSubjSource.DeleteSubject(Subject: TSubject);
begin
  Subjs.Delete(Subject);
  FCurrentSubject := nil;
  NotifyLink(seChangeSubjects, -1);
end;

procedure TSubjSource.DeleteTeacher(Teacher: TTeacher);
begin
  if Teacher = nil then
    Exit;
end;

procedure TSubjSource.InitKabinetDlg;
begin
  KabinetDlg.onGetList := _GetList;
end;

procedure TSubjSource.InitSubjDlg;
begin
  with SubjectDlg do begin
    onInsert := _Insert;
    onChange := _Change;
    onDelete := _Delete;
    onGetList := _GetList;
    edKlass.onEnter := KlassEnter;
    edKlass.onExit := KlassExit;
    edKlass.onKeyUp := KlassUp;
    btKlass.onClick := KlassClick;
  end;
end;

procedure TSubjSource.InitTeacherDlg;
begin
  with TeacherDlg do begin
    onInsert := _Insert;
    onChange := _Change;
    onDelete := _Delete;
    onGetList := _GetList;
  end;
end;

procedure TSubjSource.KlassClick(Sender: TObject);
begin
  with SubjectDlg do begin
    KlassChangeGood := true;
    if cbKlass.Enabled then
      cbKlass.SetFocus;
  end;
end;

procedure TSubjSource.KlassEnter(Sender: TObject);
begin
  with SubjectDlg do begin
    KeyPreview := false;
    KlassChangeGood := true;
    if IndexOfChangeKlass <> -1 then
      edKlass.Text := cbKlass.Text;
    Panel8.BringToFront;
    edKlass.SelectAll;
  end;
end;

procedure TSubjSource.KlassExit(Sender: TObject);
begin
  with SubjectDlg do begin
    if KlassChangeGood and (edKlass.Text <> '') then begin
      if IndexOfChangeKlass = -1 then
        IndexOfChangeKlass := AddKlass(edKlass.Text)
      else
        ChangeKlass(Klasses[IndexOfChangeKlass], edKlass.Text);
      todGetList(todKlass, true, cbKlass.Items);
      cbKlass.ItemIndex := IndexOfChangeKlass;
    end;
    edKlass.Text := '';
    KeyPreview := true;
    cbKlass.BringToFront;
  end;
end;

procedure TSubjSource.KlassUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  sc: Word;
begin
  sc := ShortCut(Key, Shift);
  with SubjectDlg do
    case sc of
      vk_Return:
        KlassClick(Sender);
      vk_Escape:
      begin
        KlassChangeGood := false;
        if cbKlass.Enabled then
          cbKlass.SetFocus;
      end;
    end;
end;

procedure TSubjSource.NotifyLink(Event: TSubjEvent; info: integer);
var
  I: integer;
begin
  for I := 0 to SubjLinks.Count - 1 do
    SubjLinks[I].SubjEvent(Event, Info);
end;

procedure TSubjSource.SetActivate(const Value: boolean);
begin
  FActivate := Value;
  if Value then
    Load;
end;

procedure TSubjSource.SetColumnMode(const Value: TColumnMode);
begin
  if FColumnMode = Value then
    Exit;
  FColumnMode := Value;
  NotifyLink(seChangeColumnMode, Integer(Value));
end;

procedure TSubjSource.SetCurrentKabinet(const Value: TKabinet);
begin
  if FCurrentKabinet = Value then
    Exit;
  FCurrentKabinet := Value;
  NotifyLink(seChangeCurrentKabinet);
end;

procedure TSubjSource.SetCurrentKlass(const Value: TKlass);
begin
  if FCurrentKlass = Value then
    Exit;
  FCurrentKlass := Value;
  NotifyLink(seChangeCurrentKlass);
end;

procedure TSubjSource.SetCurrentLesson(const Value: integer);
begin
  if FCurrentLesson = Value then
    Exit;
  FCurrentLesson := Value;
  NotifyLink(seChangeCurrentLesson);
end;

procedure TSubjSource.SetCurrentSubject(const Value: TSubject);
begin
  if FCurrentSubject = Value then
    Exit;
  FCurrentSubject := Value;
  NotifyLink(seChangeCurrentSubject);
end;

procedure TSubjSource.SetCurrentTeacher(const Value: TTeacher);
begin
  if FCurrentTeacher = Value then
    Exit;
  FCurrentTeacher := Value;
  NotifyLink(seChangeCurrentTeacher);
end;

procedure TSubjSource.SetFileName(const Value: String);
begin
  if FFileName = Value then
    Exit;
  FFileName := Value;
  Activate := false;
end;

procedure TSubjSource.SetLessons(const Value: s11);
var
  I: integer;
  ls: s11;
begin
  ls := Subjs.Lessons + Value - Subjs.Lessons * Value;
  Subjs.Lessons := [] + Value;
  for I := 0 to 10 do
    if I in ls then
      NotifyLink(seCheckLesson, I);
end;

procedure TSubjSource.SetManager(const Value: TSubjCustomManager);
begin
  FManager := Value;
end;

procedure TSubjSource.SetViewMode(const Value: TViewMode);
begin
  if FViewMode = Value then
    Exit;
  FViewMode := Value;
  NotifyLink(seChangeViewMode, Integer(Value));
end;

procedure TSubjSource.SetWeekDays(const Value: TSetWeekDays);
var
  wd, dif: TSetWeekDays;
  I: TWeekDay;
begin
  wd := Value;
  dif := Subjs.WeekDays + wd - Subjs.WeekDays * wd;
  Subjs.WeekDays := wd;
  for I := wdMonday to wdSunday do
    if I in dif then
      NotifyLink(seCheckWeekDay, ord(I));
end;

procedure TSubjSource.SwapKabinets(ind1, ind2: integer);
begin
  Kabinets.Swap(ind1, ind2);
  NotifyLink(seChangeKabinets, -1);
end;

procedure TSubjSource.SwapKlasses(ind1, ind2: integer);
begin
  Klasses.Swap(ind1, ind2);
  NotifyLink(seChangeKlasses, -1);
end;

procedure TSubjSource.SwapSubjects(ind1, ind2: integer);
begin
  Subjs.Swap(ind1, ind2);
  NotifyLink(seChangeSubjects, -1);
end;

procedure TSubjSource.SwapTeachers(ind1, ind2: integer);
begin
  Teachers.Swap(ind1, ind2);
  NotifyLink(seChangeTeachers, -1);
end;

{public}
constructor TSubjSource.Create(AOwner: TComponent);
var
  rs: TResourceStream;
begin
  inherited Create(AOwner);
  Subjs := TSubjects.Create;
  rs := TResourceStream.Create(HInstance, 'Subjects', RT_RCDATA);
  Subjs.SubjectNames.LoadFromStream(rs);
  rs.Free;
  FSubjLinks := TSubjLinks.Create(true);
  if SubjectDlg = nil then
    SubjectDlg := TSubjectDlg.Create(nil);
  if KabinetDlg = nil then
    KabinetDlg := TKabinetDlg.Create(nil);
  if TeacherDlg = nil then
    TeacherDlg := TTeacherDlg.Create(nil);
end;

destructor TSubjSource.Destroy;
begin
  Subjs.Free;
  FreeAndNil(SubjectDlg);
  FreeAndNil(KabinetDlg);
  FreeAndNil(TeacherDlg);
  inherited;
  SubjLinks.Free;
end;

function TSubjSource.AddKlass(st: String): integer;
begin
  with Klasses.AddNewItem do begin
    Name := st;
    result := ItemIndex;
  end;
  NotifyLink(seChangeKlasses, result);
end;

function TSubjSource.IsCross(sub1, sub2: TSubject): boolean;
begin
  result := false;
  if Subjs <> nil then
    result := Subjs.IsCross(sub1, sub2);
end;

function TSubjSource.StateOf(ASubject: TSubject; ALesson: Integer): TSubjState;
var
  I: integer;
  Lesson: TLesson;
//  Item: TRefItem;
  Ints: TIntegers;
begin
 //todo 1 : StateOf - Подлежит изменению

 /// 25.04.2012
 /// функция расчитывает какие из предметов конфликтуют с заданным
 /// чтобы у предмета не было конфликта с самим собой, убираем его
 /// из расписания, а после расчетов возвращаем обратно

 // Список чисел
  Ints := TIntegers.Create;
 // Неопределён текущий столбец
//  Item := nil;
 // Определить текущий столбец
  case ColumnMode of
  // Если заголовки столбцов - классы,
  // то запомнить текущий класс в списке чисел
    cmKlass:
      if CurrentKlass <> nil then
        Ints.Add(CurrentKlass.ItemIndex);
//    cmKabinet:
//      Item := CurrentKabinet;
//    cmTeacher:
//      Item := CurrentTeacher;
  end;
 // Перебрать все классы
  for I := 0 to Ints.Count - 1 do begin
  // Определить предмет находящийся в текущей классе,
  // текущего урока

  // 25.04.2012 old -> sbj := Klasses[ints[I]].LessAbs[ALesson];
    Lesson := TimeTable.ForKlasses[Ints[I],ALesson];
    Ints.Objects[I] := Lesson;
    if Lesson = nil then
      Continue;
  // Удалить предмет из расписания
    TimeTable.DeleteFromState(ALesson, Lesson);
  end;
 // Определить состояние одного из предметов основного списка
  Result := ASubject.State[ALesson];
 // Перебрать уроки
  for I := 0 to LessonCount - 1 do
  // Если для одного из уроков есть предмет,
  // то вернуть его в сетку расписания
    Lesson := TLesson(Ints.Objects[I]);
    if Lesson <> nil then
      TimeTable.AddToState(ALesson, Lesson);
  Ints.Free;
end;

procedure TSubjSource.Add(TypeOfSubj: TTypeOfData);
begin
  case TypeOfSubj of
    todSubject:
      CreateSubject;
    todTeacher:
      CreateTeacher;
    todKabinet:
      CreateKabinet;
  end;
end;

procedure TSubjSource.AddCell(Lesson: integer; Subject: TSubject);
var
  st: TSubjState;
  us: Boolean;
begin
  if (Lesson < 0) or (Lesson >= LessCount) then
    Exit;
  st := StateOf(Subject, Lesson);
  us := st = [];
  us := us or (not us and DoCollision(Lesson, Subject, St));
  if not us then
    Exit;
  TimeTable.Add(Lesson, Subject);
  NotifyLink(seChangeTimeTable);
end;

procedure TSubjSource.Change(Item: TCollItem);
begin
  if Item is TSubject then
    ChangeSubject(TSubject(Item))
  else
  if Item is TLesson then
    ChangeSubject(TLesson(Item))
  else
  if Item is TTeacher then
    ChangeTeacher(TTeacher(Item))
  else
  if Item is TKabinet then
    ChangeKabinet(TKabinet(Item));
end;

procedure TSubjSource.ChangeKlass(Klass: TKlass; s: string);
begin
  Klass.Name := s;
  NotifyLink(seChangeKlasses, Klass.ItemIndex);
end;

procedure TSubjSource.ChangeLesson(Lesson: TLesson);
begin
  if Lesson = nil then
    Exit;
  InitSubjDlg;
  if SubjectDlg.Execute(Lesson, nil) then begin
    Lesson.Assign(SubjectDlg.Subject);
    NotifyLink(seChangeSubjects, Lesson.ItemIndex);
  end;
end;

procedure TSubjSource.CheckUp(Item: TCollItem);
begin
  if Item is TKlass then
    CheckUpKlass(TKlass(Item))
  else
  if Item is TTeacher then
    CheckUpTeacher(TTeacher(Item))
  else
  if Item is TKabinet then
    CheckUpKabinet(TKabinet(Item));
end;

procedure TSubjSource.CheckUpLesson(LessonIndex: integer);
begin
  if LessonIndex in Subjs.Lessons then
    Subjs.Lessons := Subjs.Lessons - [LessonIndex]
  else
    Subjs.Lessons := Subjs.Lessons + [LessonIndex];
  NotifyLink(seCheckLesson, LessonIndex);
end;

procedure TSubjSource.CheckUpWeekDay(WDIndex: TWeekDay);
begin
  if WDIndex in Subjs.WeekDays then
    Subjs.WeekDays := Subjs.WeekDays - [WDIndex]
  else
    Subjs.WeekDays := Subjs.WeekDays + [WDIndex];
  NotifyLink(seCheckWeekDay, ord(WDIndex));
end;

procedure TSubjSource.Delete(Item: TCollItem);
begin
  if Item is TSubject then
    DeleteSubject(TSubject(Item))
  else
  if Item is TTeacher then
    DeleteTeacher(TTeacher(Item))
  else
  if Item is TKabinet then
    DeleteKabinet(TKabinet(Item));
end;

procedure TSubjSource.DeleteCell(Lesson: integer; Kabinet: TKabinet);
begin
  if (Lesson < 0) or (Lesson >= LessCount) then
    Exit;
  TimeTable.Delete(Lesson, Kabinet);
  NotifyLink(seChangeTimeTable);
end;

procedure TSubjSource.DeleteCell(Lesson: integer; Klass: TKlass);
begin
  TimeTable.Delete(Lesson, Klass);
  NotifyLink(seChangeTimeTable);
end;

procedure TSubjSource.DeleteCell(Lesson: integer; Subject: TSubject);
begin
  if (Lesson < 0) or (Lesson >= LessCount) then
    Exit;
  TimeTable.Delete(Lesson, Subject);
  NotifyLink(seChangeTimeTable);
end;

procedure TSubjSource.DeleteCell(Lesson: integer; Teacher: TTeacher);
begin
  TimeTable.Delete(Lesson, Teacher);
  NotifyLink(seChangeTimeTable);
end;

procedure TSubjSource.Load(AFileName: string);
var
  FN: String;
begin
  FN := IfThen(AFileName = '', FFileName, AFileName);
  if FN <> '' then
    Subjs.LoadFromFile(FN);
  NotifyLink(seRefresh);
end;

procedure TSubjSource.LoadTxt(AFileName: string);
var
  FN: String;
begin
  FN := IfThen(AFileName = '', FFileName + '.txt', AFileName);
  if FN <> '' then
    Subjs.LoadFromTextFile(FN);
  NotifyLink(seRefresh);
end;

procedure TSubjSource.Save(AFileName: string);
var
  FN: String;
begin
  FN := IfThen(AFileName = '', FFileName, AFileName);
  if FN <> '' then
    Subjs.SaveToFile(FN);
end;

procedure TSubjSource.SaveTxt(AFileName: string);
var
  FN: String;
begin
  FN := IfThen(AFileName = '', FFileName + '.txt', AFileName);
  if FN <> '' then
    Subjs.SaveToTextFile(FN);
end;

procedure TSubjSource.Swap(TypeOfSubj: TTypeOfData; Ind1, Ind2: integer);
begin
  case TypeOfSubj of
    todSubject:
      SwapSubjects(Ind1, Ind2);
    todKlass:
      SwapKlasses(Ind1, Ind2);
    todTeacher:
      SwapTeachers(Ind1, Ind2);
    todKabinet:
      SwapKabinets(Ind1, Ind2);
  end;
end;

procedure TSubjSource.SwitchLock;
var
  ls: Integer;
begin
  ls := CurrentLesson;
  case ColumnMode of
    cmKlass:
      CurrentKlass.SwitchLock(ls);
    cmTeacher:
      CurrentTeacher.SwitchLock(ls);
    cmKabinet:
      CurrentKabinet.SwitchLock(ls);
  end;
  NotifyLink(seChangeCurrentLesson);
end;

end.
