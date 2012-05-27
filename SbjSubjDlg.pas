unit SbjSubjDlg;

interface

uses
  Windows, Messages, SysUtils, variants, Classes, Graphics, Controls, Forms,
  Dialogs, MyDialog, StdCtrls, ExtCtrls, Grids, ValEdit, SbjKernel, SbjColl,
  SbjResource, Menus, MyLists, Buttons;

type
  TSubjectDlg = class (TDialog)
    Panel4: TPanel;
    rgLessonPos: TRadioGroup;
    rgLessonType: TRadioGroup;
    Label1: TLabel;
    pn3: TPanel;
    sgTeachKab: TSuperGrid;
    Panel6: TPanel;
    lbHelp: TLabel;
    pnKlass: TPanel;
    Panel8: TPanel;
    edKlass: TEdit;
    btKlass: TSpeedButton;
    pn2: TPanel;
    lbxListOfChoice: TListBox;
    pn1: TPanel;
    edSanPin: TLabeledEdit;
    edLongName: TListEdit;
    edShortName: TLabeledEdit;
    edTime: TLabeledEdit;
    Label3: TLabel;
    cbKlass: TComboBox;
    Panel3: TPanel;
    Bevel1: TBevel;
    btnPlus: TBitBtn;
    procedure cbKlassKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure gdTeachKabKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ComponentEnter(Sender: TObject);
    procedure edLongNameChange(Sender: TObject);
    procedure edLongNameChangeIndex(Sender: TObject; Index: Integer;
      Data: TObject);
    procedure cbKlassKeyPress(Sender: TObject; var Key: Char);
    procedure sgTeachKabChangeCell(Sender: TObject; ACol, ARow: Integer);
    procedure sgTeachKabBeforeChangeCell(Sender: TObject; ACol,
      ARow: Integer);
    procedure edTimeKeyPress(Sender: TObject; var Key: Char);
    procedure edTimeChange(Sender: TObject);
    procedure edTimeKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ComponentExit(Sender: TObject);
    procedure lbxListOfChoiceKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sgTeachKabSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure lbxListOfChoiceClick(Sender: TObject);
    procedure lbxListOfChoiceDblClick(Sender: TObject);
    procedure btnPlusClick(Sender: TObject);
    procedure lbxListOfChoiceEnter(Sender: TObject);
    procedure lbxListOfChoiceExit(Sender: TObject);
    procedure edLongNameKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    function GetListIndex: integer;
  private
    FSubject: TSubject;
    FOnChange: TChangeEvent;
    FOnDelete: TChangeEvent;
    FOnInsert: TInsertEvent;
    FOnGetList: TGetListEvent;
    stsTeacher: TStringList;
    stsKabinet: TStringList;
    stsNames: TStringList;
    AdList: TStringList;
    NewLine: boolean;
    AutoKab: boolean;
    Control: TWinControl;
    Curr: TCollItem;
    procedure Del(x, y: integer);
    procedure DelLine(ARow: integer);
    procedure Information(s: string);
    procedure Warning(s: string);
    function SimpCheck(ed: TWinControl): boolean;
    function GetSubject: TSubject;
    procedure FreshTeachKab;
    procedure Resort;
    function GetNameLong(x: integer): string;
    function GetNamePIN(x: integer): integer;
    function GetNameShort(x: integer): string;
    property NameLong[x: integer]: string read GetNameLong;
    property NameShort[x: integer]: string read GetNameShort;
    property NamePIN[x: integer]: integer read GetNamePIN;
    property ListIndex: integer read GetListIndex;
    procedure View(sts: TStrings);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Subject: TSubject read GetSubject;
    function Execute(ASubject: TSubject; Current: TSimpleItem): boolean;
    property OnInsert: TInsertEvent read FOnInsert write FOnInsert;
    property OnChange: TChangeEvent read FOnChange write FOnChange;
    property OnDelete: TChangeEvent read FOnDelete write FOnDelete;
    property OnGetList: TGetListEvent read FOnGetList write FOnGetList;
    procedure TodGetList(TypeOfData: TTypeOfData; Short: boolean; Strings: TStrings);
    procedure TodChange(TypeOfData: TTypeOfData; Index: Integer);
    procedure TodInsert(TypeOfData: TTypeOfData);
    procedure TodDelete(TypeOfData: TTypeOfData; Index: Integer);
  end;

var
  SubjectDlg: TSubjectDlg = nil;

resourcestring
  HelpKlass = 'Выберите класс в котором будет проходить этот предмет'#13#10 + 'Alt+Вниз - посмотреть список.'#13#10 + 'F2 - исправить название класса. '#13#10 + 'Insert - добавить новый класс. Delete - удалить лишний класс';
  HelpLongName = 'Напишите полное название предмета. Например, "Химия" или ' + '"Физическая культура". Если в классе часть Химии проходит в одном кабиненте,' + ' а часть в другом, то рекомендуется использовать название "Химия №1" или ' + '"Химия в к. Истории" для одного кабинета, и, скажем, "Химия №2" для другого';
  HelpShortName = 'Напишите короткое название предмета. Например, "Лит-ра".' + #13#10'Желательно, чтобы названия одинаковых предметов было одинаковым. В ' + 'случае "Химия №1" и "Химия №2", короткое название будет "Химия". Это ' + 'название для учеников';
  HelpTime = 'Укажите сколько часов в неделю будет предмет в этом классе. В ' + 'случае разделения предмета на несколько, время нужно указывать отдельно для ' + 'каждой части (см. подсказку к "Полное название"):'#13#10 + 'Химия №1 - 3 часа, а Химия №2 - 2 часа в неделю';
  HelpSanPIN = 'Укажите балл сложножности даваемый предмету в соответствии с ' + 'санитарными нормами';
  HelpTeachKab = 'Alt+Вниз - посмотреть список.'#13#10 + 'Enter - выбрать строку из списка. Esc - закрыть список не выбирая'#13#10 + 'F2 - исправить строку. '#13#10 + 'Insert - добавить имя или кабинет.';
  HelpLessonPos = '';
  HelpLessonType = '';
  WarnKlass = 'Обязательно выберите класс.'#13#10 + 'Для добавления нового класса нажите Insert'#13#10 + 'Для изменения неверного класса нажмите F2';
  WarnLongName = 'Обязательно напишите полное название предмета.';
  WarnShortName = 'Обязательно напишите короткое название предмета.';
  WarnTeachKab = 'Обязательно выберите хотя бы одного преподавателя.';
  ColumnTitle = 'Преподаватели,Кабинеты';
  TitleNewSubj = 'Создание нового предмета';
  TitleChangeSubj = 'Изменение предмета';
  NoTeacher = 'Нет преподавателя!';
  SaveOrCancel = '"Сохранить предмет","Отменить изменения"';

const
  stHelp: array[1..8] of string =
    (HelpKlass, HelpLongName, HelpShortName, HelpSanPIN, HelpTime, HelpTeachKab
    , HelpLessonPos, HelpLessonType);

implementation

{$R *.dfm}

{ TSubjectDlg }

constructor TSubjectDlg.Create(AOwner: TComponent);
begin
  inherited;
  FSubject := TSubject.Create(nil);
  stsNames := tStringList.Create;
  stsTeacher := tStringList.Create;
  stsKabinet := tStringList.Create;
  AdList := tStringList.Create;
  sgTeachKab.Rows[0].CommaText := ColumnTitle;
  AutoKab := true;
end;

destructor TSubjectDlg.Destroy;
begin
  AdList.Free;
  stsTeacher.Free;
  stsKabinet.Free;
  stsNames.Free;
  FSubject.Free;
  inherited;
end;

function TSubjectDlg.Execute(ASubject: TSubject; Current: TSimpleItem): boolean;
var
  s: string;
  i: integer;
  us: Boolean;
begin
  Curr := Current;
  with sgTeachKab do begin
    RowCount := 2;
    Rows[1].Clear;
  end;
  FSubject.Clear;
  TodGetList(todKlass, true, cbKlass.items);
  TodGetList(todName, false, stsNames);
  TodGetList(todTeacher, false, stsTeacher);
  sgTeachKab.ComboCol[0] := stsTeacher;
  TodGetList(todKabinet, false, stsKabinet);
  sgTeachKab.ComboCol[1] := stsKabinet;
  if ASubject = nil then begin
    Caption := TitleNewSubj;
    cbKlass.Text := '';
    edLongName.text := '';
    edShortName.text := '';
    edTime.Text := '0';
    edSanPin.Text := '0';
  end
  else begin
    Caption := TitleChangeSubj;
    if ASubject.Klass = nil then
      cbKlass.Text := ''
    else
      cbKlass.itemindex := ASubject.Klass.ItemIndex;
    edLongName.text := ASubject.LongName;
    edShortName.text := ASubject.ShortName;
    edTime.Text := IntToStr(ASubject.LessonAtWeek);
    edSanPin.Text := IntToStr(ASubject.SanPIN);
    for i := 0 to ASubject.TeacherCount - 1 do begin
      sgTeachKab.ToCell(0, i + 1, ASubject.Teachers[i].Name, ASubject.Teachers[i]);
      sgTeachKab.ToCell(1, i + 1, ASubject.Kabinets[i].Name, ASubject.Kabinets[i]);
    end;
  end;
  sgTeachKab.Col := 0;
  us:=not (ASubject is TLesson);
  cbKlass.Enabled:=us;
  edKlass.Enabled:=us;
  edSanPin.Enabled:=us;
  edLongName.Enabled:=us;
  edShortName.Enabled:=us;
  edTime.Enabled:=us;
  if us then begin
    if Current is TKlass then begin
      ActiveControl := edLongName;
      s := TKlass(Current).Name;
      cbKlass.ItemIndex := cbKlass.items.IndexOf(s);
    end
    else
      ActiveControl := cbKlass;
  end
  else ActiveControl := sgTeachKab;
  if Current is TTeacher then
    with sgTeachKab do begin
      s := TTeacher(Current).Name;
      ToCell(0, 1, s, Current);
    end;
  AutoKab := not (Current is TKabinet);
  if not AutoKab then
    with sgTeachKab do begin
      s := TKabinet(Current).Name;
      Cells[0, 1] := NoTeacher;
      ToCell(1, 1, s, Current);
    end;
  // Модальный вызов
  result := inherited Execute;
  // Обработка результа вызова
  if not result then
    Exit;
  FSubject.Assign(ASubject);
  with FSubject do begin
    while TeacherCount > 0 do
      Delete(0);
    TodInsert(todName);
    TodGetList(todName, false, stsNames);
    NameIndex := stsNames.IndexOf(FromName(edLongName.Text, edShortName.text
      , StrToInt(edSanPin.Text)));
    Klass := TKlass(cbKlass.Items.Objects[cbKlass.ItemIndex]);
    LessonAtWeek := StrToInt(edTime.Text);
    with sgTeachKab do
      for i := 1 to RowCount - 2 do
        Add(TTeacher(Objects[0, i]), TKabinet(Objects[1, i]));
  end;
end;

procedure TSubjectDlg.cbKlassKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  sc: Word;
begin
  inherited;
  sc := ShortCut(Key, Shift);
  case sc of
    VK_DELETE:
      TodDelete(todKlass, cbKlass.ItemIndex);
    VK_INSERT:
      TodInsert(todKlass);
    VK_F2:
      TodChange(todKlass, cbKlass.ItemIndex);
    VK_F9:
      lbxListOfChoice.SetFocus;
  end;
end;

procedure TSubjectDlg.gdTeachKabKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Tod: TTypeOfData;
  x: integer;
  sc: word;
  s: String;
  sts: TStringList;
  dt: TObject;
begin
  inherited;
  x := -1;
  with sgTeachKab do begin
    if col = 0 then
      Tod := todTeacher
    else
      Tod := todKabinet;
    if Objects[Col, Row] <> nil then
      x := TCollItem(Objects[Col, Row]).ItemIndex;
    sc := ShortCut(Key, Shift);
    case sc of
      VK_DELETE:
        DelLine(sgTeachKab.Row);
      VK_INSERT:
        TodInsert(tod);
      VK_F2:
        TodChange(tod, x);
      vk_f9:
        lbxListOfChoice.SetFocus;
    end;
    if not (sc in [vk_Insert, vk_f2]) then
      Exit;
    FreshTeachKab;
    case Col of
      0:
        sts := stsTeacher;
      1:
        sts := stsKabinet;
    else
      sts := nil;
    end;
    if sc = vk_Insert then
      x := sts.Count - 1;
    with sts do begin
      s := Strings[x];
      dt := Objects[x];
    end;
    Cells[Col, Row] := '';
    ToCell(Col, Row, s, dt);
  end;
end;

procedure TSubjectDlg.ComponentEnter(Sender: TObject);
var
  Tg: integer;
  us: boolean;
  sts: TStringList;
begin
  inherited;
  Tg := TControl(Sender).tag;
  Information(stHelp[tg]);
  case Tg of
    1:
    begin
      sts := TStringList.Create;
      TodGetList(todKlass, false, sts);
      View(sts);
      sts.Free;
    end;
    2, 3, 4:
      View(edLongName.items);
    5:
      lbxListOfChoice.items.CommaText := '1 2 3 4 5 6 7 8 9 10 11 12 13 14 15';
    6:
      with sgTeachKab do begin
        KeyPreview := true;
        us := true;
        if Assigned(onSelectCell) then
          OnSelectCell(sgTeachKab, Col, Row, us);
      end;
    7:
      lbxListOfChoice.items.CommaText := SaveOrCancel;
  else
    lbxListOfChoice.items.Clear;
  end;
end;

procedure TSubjectDlg.edLongNameChange(Sender: TObject);
var
  us: boolean;
begin
  inherited;
  us := edLongName.Text <> '';
  us := us and (edShortName.Text <> '');
  us := us and (edSanPin.Text <> '0');
  us := us and (edLongName.ItemIndex = -1);
  btnPlus.Visible := us;
end;

procedure TSubjectDlg.edLongNameChangeIndex(Sender: TObject;
  Index: Integer; Data: TObject);
begin
  inherited;
  if Index = -1 then begin
    edShortName.Text := '';
    edSanPin.Text := '0';
  end
  else begin
    edShortName.Text := NameShort[Index];
    edSanPin.Text := IntToStr(NamePIN[Index]);
  end;
end;

procedure TSubjectDlg.cbKlassKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if Key = #13 then
    Key := #0;
end;

procedure TSubjectDlg.sgTeachKabChangeCell(Sender: TObject; ACol,
  ARow: Integer);
var
  i, x: integer;
  Data: TObject;
  s: string;
begin
  inherited;
  if ACol = 1 then
    Exit;
  if sgTeachKab.Cells[0, ARow] = '' then begin
    DelLine(ARow);
    Exit;
  end;
  if not AutoKab then
    Exit;
  with sgTeachKab, ComboCol[0] do begin
    x := IndexOf(Cells[0, ARow]);
    if x <> -1 then
      Delete(x);
    if sgTeachKab.Objects[0, ARow] = nil then
      x := -1
    else
      x := TTeacher(sgTeachKab.Objects[0, ARow]).KabNum;
  end;
  Data := stsKabinet.Objects[0];
  s := stsKabinet[0];
  with stsKabinet do
    for i := 0 to Count - 1 do
      if TKabinet(Objects[i]).Num = x then begin
        Data := Objects[i];
        s := stsKabinet[i];
        break;
      end;
  with sgTeachKab do begin
    Cells[1, ARow] := s;
    Objects[1, ARow] := Data;
    if NewLine then begin
      RowCount := RowCount + 1;
      Rows[RowCount - 1].Clear;
    end;
  end;
  NewLine := false;
end;

procedure TSubjectDlg.sgTeachKabBeforeChangeCell(Sender: TObject; ACol,
  ARow: Integer);
begin
  inherited;
  NewLine := sgTeachKab.Cells[ACol, ARow] = '';
  Del(ACol, ARow);
end;

procedure TSubjectDlg.Del(x, y: integer);
begin
  if x = 1 then
    Exit;
  with sgTeachKab.ComboCol[0], sgTeachKab do begin
    if (cells[0, y] = '') or (Objects[0, y] = nil) then
      Exit;
    AddObject(Cells[0, y], Objects[0, y]);
    Cells[0, y] := '';
  end;
end;

procedure TSubjectDlg.DelLine(ARow: integer);
var
  i: integer;
begin
  with sgTeachKab do
    if ARow < RowCount - 1 then begin
      Del(0, ARow);
      for i := ARow to RowCount - 2 do
        Rows[i] := Rows[i + 1];
      Rows[RowCount - 1].Clear;
      RowCount := RowCount - 1;
    end;
end;

procedure TSubjectDlg.Information(s: string);
begin
  with lbHelp do begin
    FOnt.Size := 8;
    FOnt.Color := clBlack;
    FOnt.Style := [];
    Caption := s;
  end;
  Panel4.Color := $E6FFE6;
end;

procedure TSubjectDlg.Warning(s: string);
begin
  with lbHelp do begin
    FOnt.Size := 10;
    FOnt.Color := clWhite;
    FOnt.Style := [fsBold];
    Caption := s;
  end;
  Panel4.Color := clMaroon;
end;

procedure TSubjectDlg.edTimeKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if Key in ['0'..'9', #8] then
    Exit;
  Key := #0;
end;

procedure TSubjectDlg.edTimeChange(Sender: TObject);
begin
  inherited;
  if TEdit(Sender).Text = '' then
    TEdit(Sender).Text := '0';
end;

procedure TSubjectDlg.edTimeKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Edit: TEdit;
  x: integer;
  sc: word;
begin
  Edit := TEdit(Sender);
  x := StrToInt(Edit.Text);
  inherited;
  sc := ShortCut(Key, Shift);
  case sc of
    vk_Up:
      if x < 999 then
        inc(x);
    vk_Down:
      if x > 0 then
        dec(x);
  end;
  if sc in [vk_up, vk_down] then
    Edit.Text := IntToStr(x);
end;

function TSubjectDlg.SimpCheck(ed: TWinControl): boolean;
var
  s: string;
begin
  if ed.tag = 1 then
    result := TComboBox(ed).Text = ''
  else
    result := TEdit(ed).Text = '';
  if not Result then
    Exit;
  if ed.Enabled then
    ed.SetFocus;
  case ed.tag of
    1:
      s := WarnKlass;
    2:
      s := WarnLongName;
    3:
      s := WarnShortName;
  end;
  Warning(s);
end;

function TSubjectDlg.GetSubject: TSubject;
begin
  result := nil;
  if ModalResult <> mrOk then
    Exit;
  result := FSubject;
end;

procedure TSubjectDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  if ModalResult = mrCancel then
    Exit;
  Action := caNone;
  if SimpCheck(cbKlass) then
    Exit;
  if SimpCheck(edLongName) then
    Exit;
  if SimpCheck(edShortName) then
    Exit;
  if sgTeachKab.Objects[0, 1] = nil then begin
    sgTeachKab.SetFocus;
    Warning(WarnTeachKab);
    sgTeachKab.Col := 0;
    Exit;
  end;
  Action := caHide;
end;

procedure TSubjectDlg.TodChange(TypeOfData: TTypeOfData; Index: Integer);
begin
  if Assigned(FOnChange) then
    FOnChange(self, TypeOfData, Index);
end;

procedure TSubjectDlg.TodDelete(TypeOfData: TTypeOfData; Index: Integer);
begin
  if Assigned(FOnDelete) then
    FOnDelete(self, TypeOfData, Index);
end;

procedure TSubjectDlg.TodGetList(TypeOfData: TTypeOfData; Short: boolean; Strings: TStrings);
begin
  if Assigned(FOnGetList) then
    FOnGetList(self, TypeOfData, short, Strings);
  if TypeOfData = todName then
    Resort;
end;

procedure TSubjectDlg.TodInsert(TypeOfData: TTypeOfData);
begin
  if Assigned(FOnInsert) then
    FOnInsert(self, TypeOfData);
end;

procedure TSubjectDlg.FreshTeachKab;
var
  i, j: integer;
begin
  with sgTeachKab do begin
    TodGetList(todTeacher, false, stsTeacher);
    ComboCol[0] := stsTeacher;
    for i := ComboCol[0].Count - 1 downto 0 do
      for j := 1 to RowCount - 2 do
        if ComboCol[0].Objects[i] = Objects[0, j] then begin
          ComboCol[0].Delete(i);
          break;
        end;
    TodGetList(todKabinet, false, stsKabinet);
    ComboCol[1] := stsKabinet;
  end;
end;

procedure TSubjectDlg.ComponentExit(Sender: TObject);
begin
  inherited;
  Control := TWinControl(sender);
end;

procedure TSubjectDlg.lbxListOfChoiceKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  sc: word;
begin
  inherited;
  sc := ShortCut(Key, Shift);
  with lbxListOfChoice do
    case sc of
      vk_Return:
        if Assigned(onDblClick) then
          OnDblClick(self);
      vk_Insert, vk_Delete, vk_F2:
        case Control.tag of
          1:
            cbKlass.onKeyUp(Control, Key, Shift);
          2, 3, 4:
            case sc of
              vk_Insert:
              begin
                edLongName.Text := '';
                edLongName.SetFocus;
              end;
            end;
          6:
            sgTeachKab.onKeyUp(Control, Key, Shift);
        end;
    end;
end;

procedure TSubjectDlg.ReSort;
var
  sts: TStringList;
  i: integer;
begin
  sts := TStringList.Create;
  for i := 0 to stsNames.Count - 1 do
    sts.Add(NameLong[i]);
  edLongName.Items := sts;
  sts.Free;
end;

function TSubjectDlg.GetNameLong(x: integer): string;
begin
  result := '';
  if (x < 0) or (x >= stsNames.Count) then
    Exit;
  result := ToName(stsNames[x]).Long;
end;

function TSubjectDlg.GetNamePIN(x: integer): integer;
begin
  Result := 0;
  if (x < 0) or (x >= stsNames.Count) then
    Exit;
  result := ToName(stsNames[x]).PIN;
end;

function TSubjectDlg.GetNameShort(x: integer): string;
begin
  if (x < 0) or (x >= stsNames.Count) then
    Exit;
  result := ToName(stsNames[x]).Short;
end;

procedure TSubjectDlg.sgTeachKabSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  View(sgTeachKab.ComboCol[ACol]);
end;

procedure TSubjectDlg.lbxListOfChoiceClick(Sender: TObject);
var
  i: integer;
begin
  inherited;
  case Control.tag of
    1:
      with lbxListOfChoice do
        cbKlass.ItemIndex := ListIndex;
    2, 3, 4:
      with lbxListOfChoice do
        edLongName.Text := Items[ItemIndex];
    5:
      with lbxListOfChoice do
        edTime.Text := Items[ItemIndex];
    6:
      with sgTeachKab, lbxListOfChoice do begin
        i := ListIndex;
        ToCell(Col, Row, ComboCol[Col][i], ComboCol[Col].Objects[i]);
        if Col = 0 then
          View(ComboCol[Col]);
      end;
    7:
      with lbxListOfChoice do
        if ItemIndex = 0 then
          btnOk.SetFocus
        else
          btnCancel.SetFocus;
  end;
end;

procedure TSubjectDlg.lbxListOfChoiceDblClick(Sender: TObject);
begin
  inherited;
  case Control.tag of
    1:
      edLongName.SetFocus;
    2, 3, 4:
      edTime.SetFocus;
    5:
      if not (Curr is TTeacher) then
        with sgTeachKab do begin
          Col := 0;
          SetFocus;
        end
      else
        btnOk.SetFocus;
    6:
      with sgTeachKab do
        if (Col = 0) and (TTeacher(Objects[1, Row]).KabNum = -1) then
          Col := 1
        else
          btnOk.SetFocus;
    7:
      TButton(Control).Click;
  end;
end;

procedure TSubjectDlg.btnPlusClick(Sender: TObject);
begin
  inherited;
  TodInsert(todName);
  TodGetList(todName, false, stsNames);
  if Control.tag in [2, 3, 4] then
    View(edLongName.Items);
  edLongName.SetFocus;
  btnPlus.visible := false;
end;

function TSubjectDlg.GetListIndex: integer;
begin
  result := -1;
  with lbxListOfChoice do
    if ItemIndex <> -1 then
      result := adList.IndexOf(items[ItemIndex]);
end;

procedure TSubjectDlg.View(sts: TStrings);
begin
  lbxListOfChoice.sorted := true;
  lbxListOfChoice.Items.Assign(sts);
  lbxListOfChoice.sorted := false;
  adList.Assign(sts);
end;

procedure TSubjectDlg.lbxListOfChoiceEnter(Sender: TObject);
begin
  inherited;
  KeyPreview := false;
end;

procedure TSubjectDlg.lbxListOfChoiceExit(Sender: TObject);
begin
  inherited;
  KeyPreview := true;
end;

procedure TSubjectDlg.edLongNameKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  sc: Word;
begin
  inherited;
  sc := ShortCut(Key, Shift);
  case sc of
    vk_F9:
      lbxListOfChoice.SetFocus;
  end;
end;

end.
