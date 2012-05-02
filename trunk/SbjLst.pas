unit SbjLst;

interface

uses Windows, Messages, Classes, ComCtrls, SbjSrc, Controls, SbjResource;

type
  TSubjList = Class (TCustomListView)
  private
    EdKlass: boolean;
    FSubjSource: TSubjSource;
    imgCheck: TImageList;
    ImgKabinet: TImageList;
    ImgKlass: TImageList;
    ImgTeacher: TImageList;
    LockState: Boolean;
    SubjLink: TSubjLink;
    function GetViewMode: TViewMode;
    procedure ChangeColumnMode(Sender: TObject; cm: TColumnMode);
    procedure ChangeCurrentKabinet(Sender: TObject);
    procedure ChangeCurrentKlass(Sender: TObject);
    procedure ChangeCurrentLesson(Sender: TObject);
    procedure ChangeCurrentSubject(Sender: TObject);
    procedure ChangeCurrentTeacher(Sender: TObject);
    procedure ChangeKabinets(Sender: TObject; KabinetIndex: integer);
    procedure ChangeKlasses(Sender: TObject; KlassIndex: integer);
    procedure ChangeSubjects(Sender: TObject);
    procedure ChangeTeachers(Sender: TObject; TeacherIndex: integer);
    procedure ChangeViewMode(Sender: TObject; vm: TViewMode);
    procedure CheckKabinet(Sender: TObject; KabinetIndex: integer);
    procedure CheckKlass(Sender: TObject; KlassIndex: integer);
    procedure CheckLesson(Sender: TObject; LessonIndex: integer);
    procedure CheckTeacher(Sender: TObject; TeacherIndex: integer);
    procedure CheckUp(it: TListItem);
    procedure CheckWeekDay(Sender: TObject; WeekDayIndex: integer);
    procedure Click2;
    procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;
    procedure CreateKlass;
    procedure Edited(Sender: TObject; Item: TListItem; var S: string);
    procedure Editing(Sender: TObject; Item: TListItem; var AllowEdit: Boolean);
    procedure InitSubjLink;
    procedure Out(vm: TViewMode);
    procedure OutColumns;
    procedure OutKabinets;
    procedure OutKlasses;
    procedure OutLessons;
    procedure OutSubjects;
    procedure OutTeachers;
    procedure OutWeekDays;
    procedure Refresh(Sender: TObject);
    procedure RefreshStates;
    procedure SetState(Item: TListItem);
    procedure SetSubjSource(const Value: TSubjSource);
    procedure SetViewMode(const Value: TViewMode);
    procedure WMChar(var Msg: TWMChar); message WM_CHAR;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
  protected
    procedure DoEnter; override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  Published
    property Align;
    property Color;
    property SubjSource: TSubjSource read FSubjSource write SetSubjSource;
    property ViewMode: TViewMode read GetViewMode write SetViewMode;
  end;

implementation

Uses SbjKernel, publ, SbjColl, CommCtrl, SysUtils, menus, Graphics;
//////////////////////////////////////////////////
                { TSubjList }
//////////////////////////////////////////////////
{private}
function TSubjList.GetViewMode: TViewMode;
begin
  Result := vmSubjects;
  if SubjSource = nil then
    Exit;
  result := SubjSource.ViewMode;
end;

procedure TSubjList.ChangeColumnMode(Sender: TObject; cm: TColumnMode);
begin
  if SubjSource = nil then
    Exit;
  case SubjSource.ViewMode of
    vmColumns:
      OutColumns;
    vmSubjects:
      OutSubjects;
  end;
end;

procedure TSubjList.ChangeCurrentKabinet(Sender: TObject);
var
  i: integer;
begin
  if SubjSource = nil then
    Exit;
  if Focused and (Selected <> nil) and (Selected.Data = SubjSource.CurrentKabinet) then
    Exit;
  case ViewMode of
    vmSubjects:
      OutSubjects;
    vmColumns:
    begin
      if SubjSource.ColumnMode <> cmKabinet then
        Exit;
      for i := 0 to Items.Count - 1 do
        with Items[i] do begin
          if Data <> SubjSource.CurrentKabinet then
            Continue;
          Selected := true;
          break;
        end;
    end;
  end;
end;

procedure TSubjList.ChangeCurrentKlass(Sender: TObject);
var
  i, ind: integer;
begin
  if SubjSource = nil then
    Exit;
  if Focused and (Selected <> nil) and (Selected.Data = SubjSource.CurrentKlass) then
    Exit;
  case ViewMode of
    vmSubjects:
      OutSubjects;
    vmColumns:
    begin
      if SubjSource.ColumnMode <> cmKlass then
        Exit;
      ind := SubjSource.CurrentKlass.ItemIndex;
      for i := 0 to Items.Count - 1 do
        with Items[i] do begin
          if Data = nil then
            Continue;
          if TKlass(Data).ItemIndex <> ind then
            Continue;
          Selected := true;
          break;
        end;
    end;
  end;
end;

procedure TSubjList.ChangeCurrentLesson(Sender: TObject);
begin
  if SubjSource = nil then
    Exit;
  if Focused and (Selected <> nil) then begin
    if ViewMode = vmSubjects then
      RefreshStates;
    Exit;
  end;
  with Selected, SubjSource do
    case ViewMode of
      vmSubjects:
        if LockState = SubjSource.Locked then
          RefreshStates
        else begin
          LockState := SubjSource.Locked;
          OutSubjects;
        end;
      vmLessons:
        ItemIndex := CurrentLesson mod 11;
      vmWeekDays:
        ItemIndex := CurrentLesson div 11;
    end;
end;

procedure TSubjList.ChangeCurrentSubject(Sender: TObject);
begin
  Dummy;
end;

procedure TSubjList.ChangeCurrentTeacher(Sender: TObject);
var
  i, ind: integer;
begin
  if SubjSource = nil then
    Exit;
  if Focused and (Selected <> nil) and (Selected.Data = SubjSource.CurrentTeacher) then
    Exit;
  case ViewMode of
    vmSubjects:
      OutSubjects;
    vmColumns:
    begin
      if SubjSource.ColumnMode <> cmTeacher then
        Exit;
      ind := SubjSource.CurrentTeacher.ItemIndex;
      for i := 0 to Items.Count - 1 do
        with Items[i] do begin
          if Data = nil then
            Continue;
          if tTeacher(Data).ItemIndex <> ind then
            Continue;
          Selected := true;
          break;
        end;
    end;
  end;
end;

procedure TSubjList.ChangeKabinets(Sender: TObject; KabinetIndex: integer);
var
  item: TListItem;
begin
  if SubjSource = nil then
    Exit;
  if ViewMode <> vmColumns then
    Exit;
  if SubjSource.ColumnMode <> cmKabinet then
    Exit;
  if KabinetIndex = -1 then
    Out(ViewMode);
  if KabinetIndex = -1 then
    Exit;
  Item := Items[KabinetIndex - 1];
  if item.Data = nil then
    with Items.Add do begin
      Caption := stAddKabinet;
      StateIndex := 3;
    end;
  with Item, SubjSource do begin
    Caption := Kabinets[KabinetIndex].FullName;
    Kabinets[KabinetIndex].Checked := false;
    Data := Kabinets[KabinetIndex];
    CheckUpKabinet(TKabinet(Data));
  end;
end;

procedure TSubjList.ChangeKlasses(Sender: TObject; KlassIndex: integer);
var
  item: TListItem;
begin
  if SubjSource = nil then
    Exit;
  if ViewMode <> vmColumns then
    Exit;
  if SubjSource.ColumnMode <> cmKlass then
    Exit;
  if KlassIndex = -1 then
    Out(ViewMode);
  if KlassIndex = -1 then
    Exit;
  Item := Items[KlassIndex];
  if item.Data = nil then
    with Items.Add do begin
      Caption := stAddKlass;
      StateIndex := 3;
    end;
  Item.CancelEdit;
  with Item, SubjSource do begin
    Caption := Klasses.FullKlassName[KlassIndex];
    Klasses[KlassIndex].Checked := false;
    Data := Klasses[KlassIndex];
    CheckUpKlass(Klasses[KlassIndex]);
  end;
end;

procedure TSubjList.ChangeSubjects(Sender: TObject);
begin
  OutSubjects;
end;

procedure TSubjList.ChangeTeachers(Sender: TObject; TeacherIndex: integer);
var
  item: TListItem;
begin
  if SubjSource = nil then
    Exit;
  if ViewMode <> vmColumns then
    Exit;
  if SubjSource.ColumnMode <> cmTeacher then
    Exit;
  if TeacherIndex = -1 then
    Out(ViewMode);
  if TeacherIndex = -1 then
    Exit;
  Item := Items[TeacherIndex];
  if item.Data = nil then
    with Items.Add do begin
      Caption := stAddTeacher;
      StateIndex := 3;
    end;
  with Items[TeacherIndex], SubjSource do begin
    Caption := Teachers[TeacherIndex].Name;
    Teachers[TeacherIndex].Checked := false;
    Data := Teachers[TeacherIndex];
    CheckUpTeacher(TTeacher(Data));
  end;
end;

procedure TSubjList.ChangeViewMode(Sender: TObject; vm: TViewMode);
begin
  if SubjSource = nil then
    Exit;
  out(vm);
end;

procedure TSubjList.CheckKabinet(Sender: TObject; KabinetIndex: integer);
var
  i: integer;
begin
  if SubjSource = nil then
    Exit;
  if SubjSource.ViewMode <> vmColumns then
    Exit;
  if SubjSource.ColumnMode <> cmKabinet then
    Exit;
  for i := 0 to Items.Count - 1 do
    with Items[i] do begin
      if Items[i] = nil then
        Continue;
      if Data = nil then
        Continue;
      if tKabinet(Data).ItemIndex <> KabinetIndex then
        Continue;
      StateIndex := ord(tKabinet(Data).Checked);
      break;
    end;
end;

procedure TSubjList.CheckKlass(Sender: TObject; KlassIndex: integer);
var
  i: integer;
begin
  if SubjSource = nil then
    Exit;
  if SubjSource.ViewMode <> vmColumns then
    Exit;
  if SubjSource.ColumnMode <> cmKlass then
    Exit;
  for i := 0 to Items.Count - 1 do begin
    if Items[i] = nil then
      Continue;
    with Items[i] do begin
      if Data = nil then
        Continue;
      if TKlass(Data).ItemIndex <> KlassIndex then
        Continue;
      StateIndex := ord(TKlass(Data).Checked);
    end;
    break;
  end;
end;

procedure TSubjList.CheckLesson(Sender: TObject; LessonIndex: integer);
begin
  if SubjSource = nil then
    Exit;
  if SubjSource.ViewMode <> vmLessons then
    Exit;
  Items[LessonIndex].StateIndex := ord(LessonIndex in SubjSource.Lessons);
end;

procedure TSubjList.CheckTeacher(Sender: TObject; TeacherIndex: integer);
var
  i: integer;
begin
  if SubjSource = nil then
    Exit;
  if SubjSource.ViewMode <> vmColumns then
    Exit;
  if SubjSource.ColumnMode <> cmTeacher then
    Exit;
  for i := 0 to Items.Count - 1 do
    with Items[i] do begin
      if Items[i] = nil then
        Continue;
      if Data = nil then
        Continue;
      if tTeacher(Data).ItemIndex <> TeacherIndex then
        Continue;
      StateIndex := ord(tTeacher(Data).Checked);
      break;
    end;
end;

procedure TSubjList.CheckUp(it: TListItem);
begin
  if it = nil then
    Exit;
  if SubjSource = nil then
    Exit;
  with SubjSource do
    case ViewMode of
      vmSubjects:
        it.Selected := true;
      vmLessons:
        CheckUpLesson(it.Index);
      vmWeekDays:
        CheckUpWeekDay(TWeekDay(it.Index));
      vmColumns:
        case ColumnMode of
          cmKlass:
            CheckUpKlass(it.Data);
          cmKabinet:
            CheckUpKabinet(it.Data);
          cmTeacher:
            CheckUpTeacher(it.Data);
        end
    end;
end;

procedure TSubjList.CheckWeekDay(Sender: TObject; WeekDayIndex: integer);
begin
  if SubjSource = nil then
    Exit;
  if SubjSource.ViewMode <> vmWeekDays then
    Exit;
  Items[WeekDayIndex].StateIndex := ord(TWeekDay(WeekDayIndex) in SubjSource.WeekDays);
end;

procedure TSubjList.Click2;
var
  it: TListItem;
  x: integer;
begin
  if SubjSource = nil then
    Exit;
  if StateImages = nil then
    Exit;
  it := Selected;
  if it = nil then
    Exit;
  x := it.Index;
  if x = Items.Count - 1 then
    case ViewMode of
      vmSubjects:
        SubjSource.Add(todSubject);
      vmColumns:
        case SubjSource.ColumnMode of
          cmKlass:
            CreateKlass;
          cmTeacher:
            SubjSource.Add(todTeacher);
          cmKabinet:
            SubjSource.Add(todKabinet);
        end;
    end
  else
    case ViewMode of
      vmSubjects:
        with SubjSource do
          AddCell(CurrentLesson, it.Data);
      vmColumns:
        case SubjSource.ColumnMode of
          // Нет ни каких действий. Так должно быть?
          cmKlass: ;
          cmTeacher: ;
          cmKabinet: ;
        end;
    end;
end;

procedure TSubjList.CNNotify(var Message: TWMNotify);
var
  item: TListItem;
  it: TCollItem;
  ls: integer;
begin
  Repeat
    if SubjSource = nil then
      break;
    ls := LVIS_SELECTED;
    with Message do
      if NMHdr^.Code = LVN_ITEMCHANGED then
        with PNMListView(NMHdr)^ do begin
          if (uOldState and ls <> 0) or (uNewState and ls = 0) then
            break;
          Item := Items[iItem];
          if Item = nil then
            break;
          item.focused := true;
          with SubjSource do
            case ViewMode of
              vmLessons:
                CurrentLesson := CurrentLesson div 11 * 11 + item.Index;
              vmWeekDays:
                CurrentLesson := CurrentLesson mod 11 + item.Index * 11;
            end;
          it := TCollItem(Item.Data);
          if it = nil then
            break;
          with SubjSource do
            case ViewMode of
              vmSubjects:
                CurrentSubject := TSubject(it);
              vmColumns:
                case ColumnMode of
                  cmKlass:
                    CurrentKlass := TKlass(it);
                  cmTeacher:
                    CurrentTeacher := TTeacher(it);
                  cmKabinet:
                    CurrentKabinet := TKabinet(it);
                end;
            end;
        end;
  Until true;
  inherited;
end;

procedure TSubjList.CreateKlass;
begin
  if Selected = nil then
    Exit;
  with Selected do begin
    Caption := 'Напишите название класса';
    EdKlass := true;
    EditCaption;
    Caption := stAddKlass;
  end;
end;

procedure TSubjList.Edited(Sender: TObject; Item: TListItem; var S: string);
begin
  if SubjSource = nil then
    Exit;
  if item.Data = nil then
    SubjSource.AddKlass(S)
  else
    SubjSource.ChangeKlass(TKlass(Item.Data), S);
  s := Item.Caption;
  EdKlass := false;
end;

procedure TSubjList.Editing(Sender: TObject; Item: TListItem;
  var AllowEdit: Boolean);
begin
  AllowEdit := edKlass;
end;

procedure TSubjList.InitSubjLink;
begin
  with SubjLink do begin
    onChangeSubjects := ChangeSubjects;
    onChangeViewMode := ChangeViewMode;
    onChangeColumnMode := ChangeColumnMode;
    onChangeKlasses := ChangeKlasses;
    onChangeKabinets := ChangeKabinets;
    onChangeTeachers := ChangeTeachers;
    onChangeCurrentSubject := ChangeCurrentSubject;
    onChangeCurrentKlass := ChangeCurrentKlass;
    onChangeCurrentKabinet := ChangeCurrentKabinet;
    onChangeCurrentTeacher := ChangeCurrentTeacher;
    onChangeCurrentLesson := ChangeCurrentLesson;
    onCheckKabinet := CheckKabinet;
    onCheckKlass := CheckKlass;
    onCheckTeacher := CheckTeacher;
    onCheckLesson := CheckLesson;
    onCheckWeekDay := CheckWeekDay;
    onRefresh := Refresh;
  end;
end;

procedure TSubjList.Out;
begin
  if VM in [vmColumns, vmSubjects] then
    Font.Name := 'Times New Roman'
  else
    Font.Name := 'Courier New';
  case VM of
    vmSubjects:
      OutSubjects;
    vmWeekDays:
      OutWeekDays;
    vmLessons:
      OutLessons;
    vmColumns:
      OutColumns;
  end;
end;

procedure TSubjList.OutColumns;
begin
 // Вывод списка колонок отображаемых в сетке расписания
 //////////////////////////////////////////////////
 // Текст процедуры изменению не подлежит
  if SubjSource = nil then
    Exit;
  StateImages := imgCheck;
  case SubjSource.ColumnMode of
    cmKlass:
      OutKlasses;
    cmTeacher:
      OutTeachers;
    cmKabinet:
      OutKabinets;
  end;
end;

procedure TSubjList.OutKabinets;
var
  i: integer;
begin
 // Вывод списка кабинетов
 //////////////////////////////////////////////////
 // Текст процедуры изменению не подлежит
  with SubjSource, items do begin
    BeginUpdate;
    Clear;
    for i := 0 to Kabinets.Count - 1 do begin
      if Kabinets[i].num = -1 then
        Continue;
      with Add do begin
        Caption := Kabinets[i].FullName;
        Data := Kabinets[i];
        StateIndex := ord(Kabinets[i].Checked);
        Selected := Data = CurrentKabinet;
      end;
    end;
    with Add do begin
      Caption := stAddKabinet;
      StateIndex := 3;
    end;
    EndUpdate;
  end;
end;

procedure TSubjList.OutKlasses;
var
  i: integer;
begin
 // Вывод списка классов
 //////////////////////////////////////////////////
 // Текст процедуры изменению не подлежит
  with SubjSource, items do begin
    BeginUpdate;
    Clear;
    for i := 0 to Klasses.Count - 1 do
      with Add do begin
        Caption := Klasses.FullKlassName[i];
        Data := Klasses[i];
        StateIndex := ord(Klasses[i].Checked);
        Selected := Data = CurrentKlass;
      end;
    with Add do begin
      Caption := stAddKlass;
      StateIndex := 3;
    end;
    EndUpdate;
  end;
end;

procedure TSubjList.OutLessons;
var
  i: integer;
  s: string;
begin
 // Вывод списка уроков
 //////////////////////////////////////////////////
 // Текст процедуры изменению не подлежит
  StateImages := imgCheck;
  with items do begin
    BeginUpdate;
    Clear;
    for i := 0 to 10 do begin
      case i of
        0, 1, 4, 5, 9, 10:
          s := 'ый';
        2, 6..8:
          s := 'ой';
        3:
          s := 'ий';
      end;
      with add do begin
        Caption := Format('%d-%s урок', [i, s]);
        StateIndex := ord(i in SubjSource.Lessons);
        Selected := SubjSource.CurrentLesson mod 11 = i;
      end;
    end;
    EndUpdate;
  end;
end;

procedure TSubjList.OutSubjects;
var
  i: integer;
  sx: TPlainSubjects;
  SimpleItem: TSimpleItem;
begin
 // Вывод списка предметов для заданой колонки
 //////////////////////////////////////////////////
 // Текст процедуры изменению не подлежит
 // Не вывододить список предметов, если не тот режим
  if ViewMode <> vmSubjects then
    Exit;
 // Показать галочки в списке
  StateImages := imgCheck;
 // ?
  sx := nil;
 // Выход, если нет списка предметов
  if SubjSource = nil then
    Exit;
  with SubjSource do begin
  // Определить текущий столбец
    case ColumnMode of
      cmKlass:
        SimpleItem := CurrentKlass;
      cmTeacher:
        SimpleItem := CurrentTeacher;
      cmKabinet:
        SimpleItem := CurrentKabinet;
    else
      SimpleItem := nil;
    end;
  // Если столбец определён
    if SimpleItem <> nil then
   // и текущая клетка не заблокирована, то запомнить предмет в текущей клетке
      if not SimpleItem.IsLock(CurrentLesson) then
        sx := SimpleItem.SubjectX;
  // Показать значки пересечений
    case SubjSource.ColumnMode of
      cmKlass:
        StateImages := ImgKlass;
      cmTeacher:
        StateImages := ImgTeacher;
      cmKabinet:
        StateImages := ImgKabinet;
    end;
    with items do begin
   // Начать изменение
      BeginUpdate;
   // Очистить список
      Clear;
   // Если есть текущий предмет, то
      if sx <> nil then begin
    // перебрать все предметы пересекающиеся с текущим
        for i := 0 to sx.Count - 1 do
          with Add do begin
     // Добавить новый пункт в список
     // Выдать краткое или полное название предмета
            if SubjSource.ColumnMode = cmKlass then
              Caption := sx[i].LongName
            else
              Caption := sx[i].LongKlassName;
     // Связать пункт списка с пересекающимся предметом
            Data := sx[i];
     // Выделить текущий предмет
            if Data = CurrentSubject then
              Selected := true;
     // Показать состояние предмета
            SetState(items[i]);
          end;
    // Добавить пункт "Добавить"
        with Add do begin
          StateIndex := 8;
          Caption := stAddSubject;
        end;
      end
      else
        with Add do begin
    // Если нет пересекающихся предметов,
    // то показать что клетка заблокирована
          StateImages := nil;
          Caption := stLockedCell;
        end;
   // Конец вывода информации
      EndUpdate;
    end;
  end;
end;

procedure TSubjList.OutTeachers;
var
  i: integer;
begin
 // Вывод списка учителей
 //////////////////////////////////////////////////
 // Текст процедуры изменению не подлежит
  with SubjSource, items do begin
    BeginUpdate;
    Clear;
    for i := 0 to Teachers.Count - 1 do
      with Add do begin
        Caption := Teachers[i].Name;
        Data := Teachers[i];
        StateIndex := ord(Teachers[i].Checked);
        Selected := Data = CurrentTeacher;
      end;
    with Add do begin
      Caption := stAddTeacher;
      StateIndex := 3;
    end;
    EndUpdate;
  end;
end;

procedure TSubjList.OutWeekDays;
var
  i: TWeekDay;
begin
 // Вывод списка дней недели
 //////////////////////////////////////////////////
 // Текст процедуры изменению не подлежит
  StateImages := imgCheck;
  with items do begin
    BeginUpdate;
    Clear;
    for i := wdMonday to wdSunday do
      with add do begin
        Caption := WeekDayNames[i];
        StateIndex := ord(i in SubjSource.WeekDays);
        Selected := SubjSource.CurrentLesson div 11 = ord(i);
      end;
    EndUpdate;
  end;
end;

procedure TSubjList.Refresh(Sender: TObject);
begin
  Out(ViewMode);
end;

procedure TSubjList.RefreshStates;
var
  i: integer;
begin
  for i := 0 to Items.Count - 1 do
    SetState(Items[i]);
end;

procedure TSubjList.SetState(Item: TListItem);
var
  st: TSubjState;
  x: Integer;
begin
 // Выход, если не определён пункт списка
  if Item = nil then
    Exit;
 // Выход, если к пункту не прикреплён предмет
  if Item.Data = nil then
    Exit;
 // Определить состояние предмета на данной строчке
  st := SubjSource.StateOf(TSubject(Item.data), SubjSource.CurrentLesson);
 // Порядковый номер картинки состояние
  x := 0;
 // Если время истекло, то высветить часы
  if teTime in st then
    x := x + 2;
 // Если пересечение по кабинету высветить кабинет
 // Если пересечение по преподавателю, то высветить преподавателя
 // Если пересечение по классу, то высветить класс
  case SubjSource.ColumnMode of
    cmKlass:
    begin
      if teKabinets in st then
        x := x + 1;
      if teTeachers in st then
        x := x + 4;
    end;
    cmTeacher:
    begin
      if teKabinets in st then
        x := x + 1;
      if teKlass in st then
        x := x + 4;
    end;
    cmKabinet:
    begin
      if teKlass in st then
        x := x + 1;
      if teTeachers in st then
        x := x + 4;
    end;
  end;
 // Показать картинку
  Item.StateIndex := x;
end;

procedure TSubjList.SetSubjSource(const Value: TSubjSource);
begin
  if FSubjSource <> nil then begin
    FSubjSource.SubjLinks.Delete(SubjLink);
    RemoveFreeNotification(self);
  end;
  FSubjSource := Value;
  if Value <> nil then begin
    Value.FreeNotification(self);
    FSubjSource.SubjLinks.Add(SubjLink);
    Out(ViewMode);
  end;
end;

procedure TSubjList.SetViewMode(const Value: TViewMode);
begin
  if SubjSource = nil then
    Exit;
  SubjSource.ViewMode := Value;
end;

procedure TSubjList.WMChar(var Msg: TWMChar);
begin
  inherited;
end;

procedure TSubjList.WMLButtonDblClk(var Message: TWMLButtonDblClk);
var
  th: THitTests;
begin
  inherited;
  with Message do begin
    th := GetHitTestInfoAt(XPos, YPos);
    if (htOnItem in th) or (htOnStateIcon in th) then
      GetItemAt(XPos, YPos).Selected := true;
  end;
  Click2;
end;

procedure TSubjList.WMLButtonDown(var Message: TWMLButtonDown);
var
  It: TListItem;
begin
  inherited;
  if SubjSource = nil then
    Exit;
  with Message do begin
    it := GetItemAt(XPos, YPos);
    if it = nil then
      Exit;
    if htOnStateIcon in GetHitTestInfoAt(XPos, YPos) then
      CheckUp(it);
  end;
end;

{protected}
procedure TSubjList.DoEnter;
begin
  inherited;
  if (items.Count > 0) and (selected = nil) then
    items[0].Selected := true;
end;

procedure TSubjList.KeyPress(var Key: Char);
begin
  inherited;
  case Key of
    #13:
      Click2;
    ' ':
      CheckUp(Selected);
  end;
end;

procedure TSubjList.KeyUp(var Key: Word; Shift: TShiftState);
var
  it: TCollItem;
  ItNum, ind1, ind2, x: integer;
begin
  inherited;
  ItNum := -1;
  case ShortCut(Key, Shift) of
    scCtrl + vk_Up:
      if Selected <> nil then
        ItNum := Selected.Index;
    scCtrl + vk_Down:
      if Selected <> nil then
        ItNum := Selected.Index - 1;
    vk_Insert:
      if ViewMode in [vmSubjects, vmColumns] then begin
        Items[Items.Count - 1].Selected := true;
        Click2;
      end;
    vk_F2:
    begin
      if Selected = nil then
        Exit;
      it := TCollItem(Selected.Data);
      if it = nil then
        Exit;
      with SubjSource do
        case ViewMode of
          vmSubjects:
            Change(it);
          vmColumns:
            case ColumnMode of
              cmTeacher, cmKabinet:
                Change(it);
              cmKlass:
                with Selected do begin
                  Caption := TKlass(it).Name;
                  EdKlass := true;
                  EditCaption;
                  Caption := Klasses.FullKlassName[it.ItemIndex];
                end;
            end;
        end;
    end;
    vk_Delete:
    begin
      if Selected = nil then
        Exit;
      it := TCollItem(Selected.Data);
      if it = nil then
        Exit;
      with SubjSource do
        case ViewMode of
          vmSubjects:
            Delete(it);
          vmColumns:
            case ColumnMode of
              cmTeacher: ; // Вызов диалога
              cmKabinet: ; // согласия на
              cmKlass: ;   // уничтожение предметов
            end;
        end;
    end;
  end;
  if (itNum >= 0) and (itNum < items.Count - 2) then begin
    ind1 := TCollItem(items[itNum].Data).ItemIndex;
    ind2 := TCollItem(items[itNum + 1].Data).ItemIndex;
    x := Selected.Index;
    with SubjSource do
      case ViewMode of
        vmSubjects:
          Swap(todSubject, ind1, ind2);
        vmColumns:
          case ColumnMode of
            cmTeacher:
              Swap(todTeacher, ind1, ind2);
            cmKabinet:
              Swap(todKabinet, ind1, ind2);
            cmKlass:
              Swap(todKlass, ind1, ind2);
          end;
      end;
    items[x].Selected := true;
    items[x].Focused := true;
  end;
end;

procedure TSubjList.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (AComponent = SubjSource) and (Operation = opRemove) then
    SubjSource := nil;
  inherited;
end;

{public}
constructor TSubjList.Create;
var
  bm: TBitmap;
  img: TImageList;
  s: string;
  i: integer;
begin
  inherited Create(AOwner);
  LockState := false;
  EdKlass := false;
  RowSelect := true;
  HideSelection := false;
  OnEdited := Edited;
  onEditing := Editing;
  SubjLink := TSubjLink.Create;
  InitSubjLink;
  Color := $E6E6FF;
  ViewStyle := vsReport;
  ShowColumnHeaders := false;
  with Columns.Add do
    AutoSize := true;
  Width := Width + 1;
  Font.Name := 'Courier New';
  Font.Size := 10;
  bm := TBitmap.Create;
  for i := 1 to 4 do begin
    case i of
      1:
        s := 'Klass';
      2:
        s := 'Teacher';
      3:
        s := 'Kabinet';
      4:
        s := 'Check';
    end;
    if i < 4 then
      Img := TImageList.CreateSize(32, 16)
    else
      Img := TImageList.Create(self);
    bm.LoadFromResourceName(HInstance, s);
    Img.AddMasked(Bm, clWhite);
    case i of
      1:
        ImgKlass := img;
      2:
        ImgTeacher := img;
      3:
        ImgKabinet := img;
      4:
        imgCheck := img;
    end;
  end;
  bm.Free;
end;

destructor TSubjList.Destroy;
begin
  ImgKlass.Free;
  ImgKabinet.Free;
  ImgTeacher.Free;
  imgCheck.Free;
  if FSubjSource <> nil then
    FSubjSource.SubjLinks.Delete(SubjLink);
  SubjLink.Free;
  Inherited;
end;

end.
