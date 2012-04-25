unit SbjGrd;

interface

uses Windows, Messages, Classes, Buttons, StdCtrls, Graphics, Grids, SbjResource,
  SbjColl, SbjSrc, Types, ExtCtrls, Menus, SbjKernel, Controls;

type
  Tx = (xCross, xFixed, xFullView, xMain, xNotFullView, xSanPinLesson, xSanPinWeekDay
    , xText, xSelect, xSelectText, xSelectSanPinLesson, xSelectSanPinWeekDay, xAll);

  TChangeColor = procedure(Sender: TObject; iks: Tx; Color: TColor) of object;
  ////////////////////// x //////////////////////
  TGridColors = class (TPersistent)
  private
    FCross: TColor;
    FFixed: TColor;
    FFullView: TColor;
    FMain: TColor;
    FNotFullView: TColor;
    FOnChange: TChangeColor;
    FSanPinLesson: TColor;
    FSanPinWeekDay: TColor;
    FSelect: TColor;
    FSelectSanPinLesson: TColor;
    FSelectText: TColor;
    FText: TColor;
    procedure SetCross(const Value: TColor);
    procedure SetFixed(const Value: TColor);
    procedure SetFullView(const Value: TColor);
    procedure SetMain(const Value: TColor);
    procedure SetNotFullView(const Value: TColor);
    procedure SetOnChange(const Value: TChangeColor);
    procedure SetSanPinLesson(const Value: TColor);
    procedure SetSanPinWeekDay(const Value: TColor);
    procedure SetSelect(const Value: TColor);
    procedure SetSelectSanPinLesson(const Value: TColor);
    procedure SetSelectText(const Value: TColor);
    procedure SetText(const Value: TColor);
  protected
    procedure DoChange(iks: Tx; Color: TColor);
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
    property OnChange: TChangeColor read FOnChange write SetOnChange;
  published
    property Cross: TColor read FCross write SetCross;
    property Fixed: TColor read FFixed write SetFixed;
    property FullView: TColor read FFullView write SetFullView;
    property Main: TColor read FMain write SetMain;
    property NotFullView: TColor read FNotFullView write SetNotFullView;
    property SanPinLesson: TColor read FSanPinLesson write SetSanPinLesson;
    property SanPinWeekDay: TColor read FSanPinWeekDay write SetSanPinWeekDay;
    property Select: TColor read FSelect write SetSelect;
    property SelectSanPinLesson: TColor read FSelectSanPinLesson write SetSelectSanPinLesson;
    property SelectText: TColor read FSelectText write SetSelectText;
    property Text: TColor read FText write SetText;
  end;
  /////////////////// x ///////////////////
  s77 = array[0..LessCount] of String;
  /////////////////// x ///////////////////
  TLayerType = (ltMain, ltFixed, ltRedFixed, ltSelected, ltLocked, ltSanPin, ltText, ltFocused);
  TLayerTypeSet = set of TLayerType;
  /////////////////// x ///////////////////
  TSubjGrid = class (TCustomDrawGrid)
  private
    bmIcons: TBitmap;
    //btnFullView: TSpeedButton;
    //btnTC: TSpeedButton;
    imgFullView: TImage;
    CellLayer: TBitMap;
    ComboBox: TComboBox;
    Darks: TLayerTypeSet;
    Edit: TEdit;
    FCells: array of s77;
    FColors: TGridColors;
    FFullView: Boolean;
    FHeaders: array of TCollItem;
    FKabinetColWidth: Integer;
    FKlassColWidth: Integer;
    FSubjSource: TSubjSource;
    FTableContent: TTableContent;
    FTeacherColWidth: Integer;
    FViewText: Boolean;
    Layers: array[TColumnMode, TLayerType] of TBitMap;
    Mults: array of TPoint;
    Panel: TPanel;
    Popup: TPopupMenu;
    SubjLink: TSubjLink;
    Tik: Integer;
    TikCount: Integer;
    Timer: TTimer;
    SpeedButtonPaintCount: Integer;
    //IsMistakes:boolean;
    /////////////////// GetSetProperty ///////////////////
    function GetCells(ACol, ARow: Integer): string;
    function GetCellState(ACol, ARow: Integer): TGridDrawState;
    function GetColumnMode: TColumnMode;
    function GetHeaders(ACol: Integer): TCollItem;
    function GetLessons: TSetLessons;
    function GetWeekDays: TSetWeekDays;
    procedure SetCells(ACol, ARow: Integer; const Value: string);
    procedure SetColors(const Value: TGridColors);
    procedure SetColumnMode(const Value: TColumnMode);
    procedure SetFullView(const Value: Boolean);
    procedure SetHeaders(ACol: Integer; const Value: TCollItem);
    procedure SetKlassColWidth(const Value: Integer);
    procedure SetLessons(const Value: TSetLessons);
    procedure SetSubjectColWidth(const Value: Integer);
    procedure SetSubjSource(const Value: TSubjSource);
    procedure SetTableContent(const Value: TTableContent);
    procedure SetTeacherColWidth(const Value: Integer);
    procedure SetViewText(const Value: Boolean);
    procedure SetWeekDays(const Value: TSetWeekDays);
    /////////////////// LinkEvents ///////////////////
    procedure ChangeColumnMode(Sender: TObject; cm: TColumnMode);
    procedure ChangeCurrentKabinet(Sender: TObject);
    procedure ChangeCurrentKlass(Sender: TObject);
    procedure ChangeCurrentLesson(Sender: TObject);
    procedure ChangeCurrentSubject(Sender: TObject);
    procedure ChangeCurrentTeacher(Sender: TObject);
    procedure ChangeKabinets(Sender: TObject; KabinetIndex: Integer);
    procedure ChangeKlasses(Sender: TObject; KlassIndex: Integer);
    procedure ChangeSubjects(Sender: TObject);
    procedure ChangeTeachers(Sender: TObject; TeacherIndex: Integer);
    procedure ChangeTimeTable(Sender: TObject);
    procedure CheckKabinet(Sender: TObject; KabinetIndex: Integer);
    procedure CheckKlass(Sender: TObject; KlassIndex: Integer);
    procedure CheckLesson(Sender: TObject; LessonIndex: Integer);
    procedure CheckTeacher(Sender: TObject; TeacherIndex: Integer);
    procedure CheckWeekDay(Sender: TObject; WeekDayIndex: Integer);
    /////////////////// Other Events //////////////
    procedure ImageClick(Sender: TObject);
    /////////////////// Another ///////////////////
    function LastLessonIn(ARow: Integer): boolean;
    function RowToLesson(ARow: Integer): Integer;
    function To3String(Subs: TSubs): String;
    procedure ChangeColor(Sender: TObject; iks: Tx; AColor: TColor);
    procedure FillIcon(Glyph: TBitmap; index: Integer);
    procedure FullViewClick(Sender: TObject);
    procedure InitPopup;
    procedure InitSubjLink;
    procedure OutTimeTable;
    procedure OutTimeTableKabinets;
    procedure OutTimeTableKlasses;
    procedure OutTimeTableTeachers;
    procedure Plato(ARect: TRect);
    procedure PopupClick(Sender: TObject);
    procedure RedrawCell(ACol, ARow: Integer);
    procedure RedrawCells;
    procedure RedrawCol(ACol: Integer);
    procedure RedrawFixed;
    procedure RedrawRow(ARow: Integer);
    procedure Refresh(Sender: TObject);
    procedure TikTimer(Sender: TObject);
    procedure WMChar(var Msg: TWMChar); message WM_CHAR;
  /////////////////// Layers ///////////////////
    procedure BorderLayer(ACol, ARow: Integer);
    procedure DrawLayer(ABitMap: TBitMap; AColor: TColor); overload;
    procedure DrawLayer(ACanvas: TCanvas; ARect: TRect; AColor: TColor); overload;
    procedure FocusedLayer(ACol, ARow: Integer; s: String = '');
    procedure InitLayer(AWidth, AHeight: Integer);
    procedure InitMainLayer;
    procedure CreateLayerBitMaps;
    procedure DestroyLayerBitMaps;
    procedure ResetLayerCanvas;
    procedure TextLayer(ACol, ARow: Integer);
    procedure RedrawLayer(cm: TColumnMode; lt: TLayerType);
    procedure RedrawLayers(cm: TColumnMode); overload;
    procedure RedrawLayers(lt: TLayerType); overload;
    procedure RedrawLayers; overload;
    procedure SanPin(ACol, ARow: Integer);
    procedure FixedLayer(ACol, ARow: Integer);
  protected
    function SelectCell(ACol, ARow: Longint): Boolean; override;
    procedure _Test;
    // Процедура отвечающая за красоту происходящего
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
    procedure KeyPress(var Key: Char); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Cells[ACol, ARow: Integer]: string read GetCells write SetCells;
    property CellState[ACol, ARow: Integer]: TGridDrawState read GetCellState;
    property Headers[ACol: Integer]: TCollItem read GetHeaders write SetHeaders;
  published
    property Align default alClient;
    property Colors: TGridColors read FColors write SetColors stored true;
    property ColumnMode: TColumnMode read GetColumnMode write SetColumnMode;
    property FullView: Boolean read FFullView write SetFullView stored true;
    property KlassColWidth: Integer read FKlassColWidth write SetKlassColWidth default 70;
    property Lessons: TSetLessons read GetLessons write SetLessons stored false;
    property SubjectColWidth: Integer read FKabinetColWidth write SetSubjectColWidth default 100;
    property SubjSource: TSubjSource read FSubjSource write SetSubjSource;
    property TableContent: TTableContent read FTableContent write SetTableContent;
    property TeacherColWidth: Integer read FTeacherColWidth write SetTeacherColWidth default 100;
    property ViewText: Boolean read FViewText write SetViewText default true;
    property WeekDays: TSetWeekDays read GetWeekDays write SetWeekDays stored false;
  end;

 ////////////////////// x //////////////////////
implementation

uses Math, SysUtils, PublGraph, publ, Variants;

{$R GridBackGround.res}
//////////////////////////////////////////////////
                 { TGridColors }
//////////////////////////////////////////////////
{private}
procedure TGridColors.SetCross(const Value: TColor);
begin
  FCross := Value;
  DoChange(xCross, Value);
end;

procedure TGridColors.SetFixed(const Value: TColor);
begin
  FFixed := Value;
  DoChange(xFixed, Value);
end;

procedure TGridColors.SetFullView(const Value: TColor);
begin
  FFullView := Value;
  DoChange(xFullView, Value);
end;

procedure TGridColors.SetMain(const Value: TColor);
begin
  FMain := Value;
  DoChange(xMain, Value);
end;

procedure TGridColors.SetNotFullView(const Value: TColor);
begin
  FNotFullView := Value;
  DoChange(xNotFullView, Value);
end;

procedure TGridColors.SetonChange(const Value: TChangeColor);
begin
  FonChange := Value;
  DoChange(xAll, 0);
end;

procedure TGridColors.SetSanPinLesson(const Value: TColor);
begin
  FSanPinLesson := Value;
  DoChange(xSanPinLesson, Value);
end;

procedure TGridColors.SetSanPinWeekDay(const Value: TColor);
begin
  FSanPinWeekDay := Value;
  DoChange(xSanPinWeekDay, Value);
end;

procedure TGridColors.SetSelect(const Value: TColor);
begin
  FSelect := Value;
  DoChange(xSelect, Value);
end;

procedure TGridColors.SetSelectSanPinLesson(const Value: TColor);
begin
  FSelectSanPinLesson := Value;
  DoChange(xSelectSanPinLesson, Value);
end;

procedure TGridColors.SetSelectText(const Value: TColor);
begin
  FSelectText := Value;
  DoChange(xSelectText, Value);
end;

procedure TGridColors.SetText(const Value: TColor);
begin
  FText := Value;
  DoChange(xText, Value);
end;

{protected}
procedure TGridColors.DoChange(iks: Tx; Color: TColor);
begin
  if Assigned(fonChange) then
    fonChange(self, iks, Color);
end;

{public}
constructor TGridColors.Create;
begin
  inherited;
 //Fixed
  Cross := $EE97F0;
  Fixed := $FF9D9D;
 // Grid
  Main := $FFE6E6;
  NotFullView := clRed;
  SanPinLesson := $0079CCFD;
  SanPinWeekDay := clGreen;
  FullView := clLime;
  Text := clBlack;
 //Select
  Select := clBlue;
  SelectText := clYellow;
  SelectSanPinLesson := clNavy;
end;

procedure TGridColors.Assign(Source: TPersistent);
begin
  if Source is TGridColors then begin
    Cross := TGridColors(Source).Cross;
    SelectText := TGridColors(Source).SelectText;
    Main := TGridColors(Source).Main;
    NotFullView := TGridColors(Source).NotFullView;
    Select := TGridColors(Source).Select;
    SanPinLesson := TGridColors(Source).SanPinLesson;
    SanPinWeekDay := TGridColors(Source).SanPinWeekDay;
    FullView := TGridColors(Source).FullView;
    Text := TGridColors(Source).Text;
    Fixed := TGridColors(Source).Fixed;
    fonChange := TGridColors(Source).onChange;
  end
  else
    inherited;
end;

//////////////////////////////////////////////////
                 { TSubjGrid }
//////////////////////////////////////////////////
{private}
/////////////////// GetSetProperty ///////////////////
function TSubjGrid.GetCells(ACol, ARow: Integer): string;
var
  Lesson: Integer;
begin
  result := '';
  if (ACol < 0) or (ACol > ColCount - 1) then
    Exit;
  if (ARow < 0) or (ARow > RowCount - 1) then
    Exit;
  if (ColumnMode = cmKlass) and (ARow = 1) then
    if ACol = 0 then
      Result := '> > >'
    else
      Result := ''
  else begin
    Lesson := RowToLesson(ARow);
    result := FCells[ACol, Lesson + 1];
  end;
end;

function TSubjGrid.GetCellState(ACol, ARow: Integer): TGridDrawState;
begin
  Result := [];
  if (ACol < FixedCols) or (ARow < FixedRows) then
    Result := [gdFixed];
  if (ACol = Col) and (ARow = Row) then
    Result := Result + [gdFocused];
  with Selection do
    if (Left <= ACol) and (Right - 1 >= ACol) and (Top <= ARow) and (Bottom - 1 >= ARow) then
      Result := Result + [gdSelected];
end;

function TSubjGrid.GetColumnMode: TColumnMode;
begin
  result := cmKlass;
  if SubjSource <> nil then
    result := SubjSource.ColumnMode;
end;

function TSubjGrid.GetHeaders(ACol: Integer): TCollItem;
var
  l: Integer;
begin
  l := Length(FHeaders);
  result := nil;
  if (ACol < 0) or (ACol >= ColCount) or (ACol >= L) then
    Exit;
  result := FHeaders[ACol];
end;

function TSubjGrid.GetLessons: TSetLessons;
begin
  result := [];
  if SubjSource = nil then
    Exit;
  result := TSetLessons(SubjSource.Lessons);
end;

function TSubjGrid.GetWeekDays: TSetWeekDays;
begin
  result := [];
  if SubjSource = nil then
    Exit;
  result := SubjSource.WeekDays;
end;

procedure TSubjGrid.SetCells(ACol, ARow: Integer; const Value: string);
var
  i, l: Integer;
  Lesson: Integer;
begin
 // Если произошёл выход за бока экранной сеткм - выход
  if (ACol < 0) or (ACol > ColCount - 1) then
    Exit;                                  
 // Если произошёл выход за верх-низ экранной сетки - выход
  if (ARow < 0) or (ARow > RowCount - 1) or (ARow > LessCount) then
    Exit;
 // Установка соотвествия ширина таблицы в памяти и на экране
  if Length(fCells) <> ColCount then {}
    SetLength(fCells, ColCount);
  Lesson := RowToLesson(ARow) + 1;
 // Если в ячейке уже есть эти данные - выход
  if FCells[ACol, Lesson] = Value then
    Exit;
 // Зопомнить количество многострочных клеток
  l := length(Mults);
 // Перебрать их все
  for i := 0 to l - 1 do
    if (Mults[i].x = ACol) and (Mults[i].y = Lesson) then begin
   // то уменьшить число таких клеток,
      dec(l);
   // перенести последнюю, на место уничтоженой
      Mults[i] := Mults[l];
   // уменьшить длину списка на 1
      SetLength(Mults, l);
   // больше не искать многострочных клеток
      break;
    end// Если приходится заполнять многострочную клетку,
  ;
 // Если в новом тексте, есть перевод каретки,
  if pos(#13#10, Value) > 0 then begin
  // увеличить число многострочных клеток
    inc(l);
  // удленить список многострочных клеток
    SetLength(Mults, l);
  // запомнить новую клетку, как многострочную
    Mults[l - 1] := Point(ACol, Lesson);
  end;
 // Запомнить новый текст
  FCells[ACol, Lesson] := Value;
 // Перерисовать обновлёную клетку
  RedrawCell(ACol, Lesson);
end;

procedure TSubjGrid.SetColors(const Value: TGridColors);
begin
  FColors.Assign(Value);
  InitMainLayer;
end;

procedure TSubjGrid.SetColumnMode(const Value: TColumnMode);
begin
  if SubjSource = nil then
    Exit;
  SubjSource.ColumnMode := Value;
end;

procedure TSubjGrid.SetFullView(const Value: Boolean);
begin
  FFullView := Value;
  OutTimeTable;
  // BtnFullView.Down := Not Value and (ColCount > 2) and (RowCount > 2);
  // todo: Нарисовать "кнопку"
  RedrawCell(Col, Row);
end;

procedure TSubjGrid.SetHeaders(ACol: Integer;
  const Value: TCollItem);
var
  l: Integer;
begin
  l := Length(FHeaders);
  if (ACol < 0) or (ACol >= ColCount) then
    Exit;
  if ACol >= l then
    SetLength(FHeaders, ColCount);
  FHeaders[ACol] := Value;
end;

procedure TSubjGrid.SetKlassColWidth(const Value: Integer);
begin
  FKlassColWidth := Value;
end;

procedure TSubjGrid.SetLessons(const Value: TSetLessons);
begin
  if SubjSource = nil then
    Exit;
  SubjSource.Lessons := s11(Value);
end;

procedure TSubjGrid.SetSubjectColWidth(const Value: Integer);
begin
  FKabinetColWidth := Value;
end;

procedure TSubjGrid.SetSubjSource(const Value: TSubjSource);
begin
  if FSubjSource <> nil then begin
    RemoveFreeNotification(self);
    FSubjSource.SubjLinks.Delete(SubjLink);
  end;
  FSubjSource := Value;
  if Value <> nil then begin
    Value.FreeNotification(self);
    FSubjSource.SubjLinks.Add(SubjLink);
    OutTimeTable;
  end;
end;

procedure TSubjGrid.SetTableContent(const Value: TTableContent);
var
  x: Integer;
begin
  FTableContent := Value;
  case Value of
    tcSubject:
      x := 3;
    tcTeacher:
      x := 4;
    tcKabinet:
      x := 5;
  else
    x := -1;
  end;
  // FillIcon(btnTC.Glyph, x);
  FillIcon(imgFullView.Picture.Bitmap, x);
  OutTimeTable;
end;

procedure TSubjGrid.SetTeacherColWidth(const Value: Integer);
begin
  FTeacherColWidth := Value;
end;

procedure TSubjGrid.SetViewText(const Value: Boolean);
begin
  FViewText := Value;
  InvalidateGrid;
 //RedrawCells;
end;

procedure TSubjGrid.SetWeekDays(const Value: TSetWeekDays);
begin
  if SubjSource = nil then
    Exit;
  SubjSource.WeekDays := Value;
end;

  /////////////////// LinkEvents ///////////////////
procedure TSubjGrid.ChangeColumnMode(Sender: TObject; cm: TColumnMode);
begin
  if SubjSource = nil then
    Exit;
  OutTimeTable;
end;

procedure TSubjGrid.ChangeCurrentKabinet(Sender: TObject);
var
  i: Integer;
begin
  if SubjSource = nil then
    Exit;
  if ColumnMode <> cmKabinet then
    Exit;
  if Focused then
    Exit;
  with SubjSource do
    for i := 1 to ColCount - 1 do
      if Headers[i] = CurrentKabinet then begin
        Col := i;
        break;
      end;
end;

procedure TSubjGrid.ChangeCurrentKlass(Sender: TObject);
var
  i: Integer;
begin
  if SubjSource = nil then
    Exit;
  if ColumnMode <> cmKlass then
    Exit;
  if Focused then
    Exit;
  with SubjSource do
    for i := 1 to ColCount - 1 do
      if Headers[i] = CurrentKlass then begin
        Col := i;
        break;
      end;
end;

procedure TSubjGrid.ChangeCurrentLesson(Sender: TObject);
var
  i: Integer;
begin
  if SubjSource = nil then
    Exit;
  if not (SubjSource.ViewMode in [vmLessons, vmWeekDays]) then
    Exit;
  if Focused then
    Exit;
  with SubjSource do
    for i := 1 to RowCount - 1 do
      if RowToLesson(i) = CurrentLesson then begin
        Row := i;
        break;
      end;
end;

procedure TSubjGrid.ChangeCurrentSubject(Sender: TObject);
begin
  if SubjSource = nil then
    Exit;
  OutTimeTable;
  RedrawFixed;
end;

procedure TSubjGrid.ChangeCurrentTeacher(Sender: TObject);
var
  i: Integer;
begin
  if SubjSource = nil then
    Exit;
  if ColumnMode <> cmTeacher then
    Exit;
  if Focused then
    Exit;
  with SubjSource do
    for i := 1 to ColCount - 1 do
      if Headers[i] = CurrentTeacher then begin
        Col := i;
        break;
      end;
end;

procedure TSubjGrid.ChangeKabinets(Sender: TObject; KabinetIndex: Integer);
begin
  if (ColumnMode <> cmKabinet) and (TableContent = tcTeacher) then
    Exit;
  OutTimeTable;
end;

procedure TSubjGrid.ChangeKlasses(Sender: TObject; KlassIndex: Integer);
begin
 //todo 3 -cПроцедура:ChangeKlasses
  if (ColumnMode <> cmKlass) and (TableContent <> tcSubject) then
    Exit;
  OutTimeTable;
end;

procedure TSubjGrid.ChangeSubjects(Sender: TObject);
begin
  OutTimeTable;
end;

procedure TSubjGrid.ChangeTeachers(Sender: TObject; TeacherIndex: Integer);
begin
  if (ColumnMode = cmTeacher) or (TableContent = tcTeacher) then
    OutTimeTable;
end;

procedure TSubjGrid.ChangeTimeTable(Sender: TObject);
var
  i, j, x: Integer;
begin
  OutTimeTable;
  x := IfThen(ColumnMode = cmKlass, 2, 1);
  if Row < RowCount - 1 then
    Row := Row + 1
  else
  if Col < ColCount - 1 then begin
    Col := Col + 1;
    Row := x;
  end
  else begin
    Col := 1;
    Row := x;
  end;
  SelectCell(Col, Row);
  for i := 0 to ColCount - 1 do
    for j := 0 to RowCount - 1 do
      RedrawCell(i, j);
end;

procedure TSubjGrid.CheckKabinet(Sender: TObject; KabinetIndex: Integer);
begin
  OutTimeTable;
end;

procedure TSubjGrid.CheckKlass(Sender: TObject; KlassIndex: Integer);
begin
  OutTimeTable;
end;

procedure TSubjGrid.CheckLesson(Sender: TObject; LessonIndex: Integer);
var
  i, j: Integer;
begin
  OutTimeTable;
  for i := 0 to ColCount - 1 do
    for j := 0 to RowCount - 1 do
      RedrawCell(i, j);
end;

procedure TSubjGrid.CheckTeacher(Sender: TObject; TeacherIndex: Integer);
begin
  OutTimeTable;
end;

procedure TSubjGrid.CheckWeekDay(Sender: TObject; WeekDayIndex: Integer);
begin
  OutTimeTable;
end;

/////////////////// Another ///////////////////
function TSubjGrid.LastLessonIn(ARow: Integer): boolean;
begin
  result := false;
  if SubjSource = nil then
    Exit;
  if SubjSource.LessonCount = 0 then
    Exit;
  if ColumnMode = cmKlass then
    dec(ARow);
  result := ARow mod SubjSource.LessonCount = 0;
end;

function TSubjGrid.RowToLesson(ARow: Integer): Integer;
var
  i, l: Integer;
  a: array[0..10] of Integer;
begin
  result := -1;
 // Одна строка - заголовок
  dec(ARow);
 // В режиме просмотра классов имеется двухстрочный заголовок
  if ColumnMode = cmKlass then
    dec(ARow);
 // Если попали на заголовок, то обработка не нужна
  if ARow < 0 then
    Exit;
 // Если нет источника, то нет скрытых уроков
  if SubjSource = nil then
    Exit;
 // Подсчёт видимых уроков
  l := 0;
  for i := 0 to 10 do
    if i in SubjSource.Lessons then begin
      a[l] := i;
      inc(l);
    end;
  if l = 0 then
    Exit;
  result := (ARow div l) * 11 + a[ARow mod l];
end;

function TSubjGrid.To3String(Subs: TSubs): string;
var
  i: Integer;
  us: boolean;
begin
  result := '';
  us := false;
  for i := 0 to High(Subs) do begin
    if Subs[i] = nil then
      Continue;
    if result <> '' then
      result := result + #13#10;
    result := result + Subs[i].KlassTitle[FTableContent];
    us := us or SubjSource.IsCross(SubjSource.CurrentSubject, Subs[i]);
  end;
  if result = '' then
    Exit;
  if not FullView then
    if not us then
      result := '~~~~~';
end;

procedure TSubjGrid.ChangeColor(Sender: TObject; iks: Tx; AColor: TColor);
begin
  case iks of
    xCross:
      RedrawFixed;
    xFixed:
    begin
      RedrawLayers(ltFixed);
      Panel.Color := AColor;
      FixedColor := AColor;
    end;
    xMain:
    begin
      RedrawLayers(ltMain);
      Color := AColor;
    end;
    xFullView, xNotFullView:
      RedrawCell(Col, Row);
    xSelect, xSelectText
      , xSelectSanPinLesson, xSelectSanPinWeekDay:
    begin
      RedrawLayers(ltSelected);
      RedrawCell(Col, Row);
    end;
    xText:
      Font.Color := AColor;
    xSanPinLesson, xSanPinWeekDay, xAll:
    begin
      FixedColor := Colors.Fixed;
      Color := Colors.Main;
      OutTimeTable;
    end;
  end;
end;

procedure TSubjGrid.FillIcon(Glyph: TBitmap; Index: Integer);
var
  bm: TBitMap;
  x: Integer;
begin
  x := Index;
  bm := TBitMap.Create;
  with bm do begin
    Width := 16;
    Height := 16;
    Canvas.CopyRect(Rect(0, 0, 16, 16), bmIcons.Canvas, Rect(x * 16, 0, x * 16 + 16, 16));
    Transparent := true;
    TransparentColor := clFuchsia;
    Glyph.Assign(bm);
    Free;
  end;
end;

procedure TSubjGrid.FullViewClick(Sender: TObject);
begin
  FullView := not FullView;
end;

procedure TSubjGrid.InitPopup;
var
  PopupItem: TMenuItem;
begin
  PopupItem := TMenuItem.Create(Popup);
  with PopupItem do begin
    Caption := tcCapts[tcSubject];
    FillIcon(Bitmap, 3);
    tag := 1;
    onClick := PopupClick;
  end;
  Popup.Items.Add(PopupItem);
  PopupItem := TMenuItem.Create(Popup);
  with PopupItem do begin
    Caption := tcCapts[tcTeacher];
    FillIcon(Bitmap, 4);
    tag := 2;
    onClick := PopupClick;
  end;
  Popup.Items.Add(PopupItem);
  PopupItem := TMenuItem.Create(Popup);
  with PopupItem do begin
    Caption := tcCapts[tcKabinet];
    FillIcon(Bitmap, 5);
    tag := 3;
    onClick := PopupClick;
  end;
  Popup.Items.Add(PopupItem);
end;

procedure TSubjGrid.InitSubjLink;
begin
  with SubjLink do begin
    onChangeSubjects := ChangeSubjects;
    onChangeTimeTable := ChangeTimeTable;
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

procedure TSubjGrid.OutTimeTable;
var
  wi: TWeekDay;
  i, j, n: Integer;
  wd, ls: Integer;
begin
 // Вывод расписания в соответствии с выбранными режимами просмотра:
 // ColumnMode, TableContent
 // DONE  :OutTimeTable
  if SubjSource = nil then
    Exit;
  wd := 0;
  for wi := wdMonday to wdSunday do
    if wi in SubjSource.WeekDays then
      inc(wd);
  if wd = 0 then begin
    ColCount := 2;
    RowCount := 2;
    Cells[0, 0] := 'Все';
    Cells[1, 0] := 'дни';
    Cells[0, 1] := 'недели';
    Cells[1, 1] := 'скрыты';
    Panel.Visible := false;
    Exit;
  end;
  ls := 0;
  for i := 0 to 10 do
    if i in SubjSource.Lessons then
      inc(ls);
  if ls = 0 then begin
    ColCount := 2;
    RowCount := 2;
    Cells[0, 0] := 'Все';
    Cells[1, 0] := 'уроки';
    Cells[0, 1] := 'скрыты';
    Cells[1, 1] := '';
    Panel.Visible := false;
    Exit;
  end;
  if ColumnMode = cmKlass then begin
    n := 1;
    Cells[0, 1] := '> > >';
  end
  else
    n := 0;
  RowCount := wd * ls + 1 + n;
  for wi := wdMonday to wdSunday do
    if wi in SubjSource.WeekDays then
      for j := 0 to 10 do
        if j in SubjSource.Lessons then begin
          inc(n);
          Cells[0, n] := Format('%s - %d', [weda[wi], j]);
        end;
  Panel.Visible := true;
  Cells[0, 0] := '';
  ColWidths[0] := 46;
  case ColumnMode of
    cmKlass:
      OutTimeTableKlasses;
    cmTeacher:
      OutTimeTableTeachers;
    cmKabinet:
      OutTimeTableKabinets;
  end;
end;

procedure TSubjGrid.OutTimeTableKabinets;
var
  wi: TWeekDay;
  i, j1, j2, n, m: Integer;
  CurCol: Integer;
begin
  with SubjSource do begin
    n := 1;
    for i := 0 to Kabinets.Count - 1 do
      if Kabinets[i].Checked then
        inc(n);
    ColCount := Max(n, 2);
    if n = 1 then begin
      Cells[0, 0] := 'Нет';
      Cells[1, 0] := 'кабинетов';
      Headers[1] := nil;
      Panel.Visible := false;
      Exit;
    end;
    Panel.Visible := true;
    FixedRows := 1;
    n := 1;
    CurCol := -1;
    for i := 0 to Kabinets.Count - 1 do
      with SubjSource do
        if Kabinets[i].Checked then begin
          ColWidths[n] := FKabinetColWidth;
          InitMainLayer;
          with Kabinets[i] do
            Cells[n, 0] := format('%d) %s', [Num, Name]);
          Headers[n] := Kabinets[i];
          if Headers[n] = CurrentKabinet then
            CurCol := n;
          m := 0;
          for wi := wdMonday to wdSunday do
            for j2 := 0 to 10 do
              if (j2 in Lessons) and (wi in WeekDays) then begin
                inc(m);
                j1 := ord(wi) * 11 + j2;
                Cells[n, m] := To3String(TimeTable.ForKabinet[i, j1]);
              end;
          inc(n);
        end;
  end;
  if SubjSource.CurrentKabinet = nil then
    SelectCell(1, 1)
  else
  if (CurCol <> Col) and (CurCol <> -1) then
    Col := CurCol;
end;

procedure TSubjGrid.OutTimeTableKlasses;
var
  wi: TWeekDay;
  i, j1, j2, n, m: Integer;
  CurCol: Integer;
  sbj: TSubject;
  s: string;
begin
  // todo: Исправить вывод данных в сетку расписания
  n := 1;
  for i := 0 to SubjSource.Klasses.Count - 1 do
    if SubjSource.Klasses[i].Checked then
      inc(n);
  ColCount := Max(n, 2);
  FixedRows := 2;
  if n = 1 then begin
    Cells[0, 0] := 'Нет';
    Cells[1, 0] := 'классов';
    Headers[1] := nil;
    Panel.Visible := false;
    Exit;
  end;
  Panel.Visible := true;
  n := 1;
  CurCol := -1;
  for i := 0 to SubjSource.Klasses.Count - 1 do
    with SubjSource do
      if Klasses[i].Checked then begin
        ColWidths[n] := FKlassColWidth;
        InitMainLayer;
        Cells[n, 0] := Klasses.FullKlassName[i];
        Headers[n] := Klasses[i];
        if CurrentKlass <> nil then
          if Headers[n] = CurrentKlass then
            CurCol := n;
        m := 1;
        for wi := wdMonday to wdSunday do
          for j2 := 0 to 10 do
            if (j2 in Lessons) and (wi in WeekDays) then begin
              inc(m);
              j1 := ord(wi) * 11 + j2;
              sbj := TimeTable.ForKlasses[i, j1];
              if sbj = nil then
                s := ''
              else
              if FullView or IsCross(CurrentSubject, sbj) then
                s := sbj.Title[FTableContent]
              else
                s := '~~~~~';
              Cells[n, m] := s;
            end;
        inc(n);
      end;
  if SubjSource.CurrentKlass = nil then
    SelectCell(1, 1)
  else
  if (CurCol <> Col) and (CurCol <> -1) then
    Col := CurCol;
end;

procedure TSubjGrid.OutTimeTableTeachers;
var
  wi: TWeekDay;
  i, j1, j2, n, m: Integer;
  CurCol: Integer;
begin
  with SubjSource do begin
    n := 1;
    for i := 0 to Teachers.Count - 1 do
      if Teachers[i].Checked then
        inc(n);
    ColCount := Max(n, 2);
    if n = 1 then begin
      Cells[0, 0] := 'Нет';
      Cells[1, 0] := 'учителей';
      Headers[1] := nil;
      Panel.Visible := false;
      Exit;
    end;
    Panel.Visible := true;
    FixedRows := 1;
    n := 1;
    CurCol := -1;
    for i := 0 to Teachers.Count - 1 do
      if Teachers[i].Checked then begin
        ColWidths[n] := FTeacherColWidth;
        InitMainLayer;
        Cells[n, 0] := Teachers[i].ShortName;
        Headers[n] := Teachers[i];
        if Headers[n] = SubjSource.CurrentTeacher then
          CurCol := n;
        m := 0;
        for wi := wdMonday to wdSunday do
          for j2 := 0 to 10 do
            if (j2 in Lessons) and (wi in WeekDays) then begin
              inc(m);
              j1 := ord(wi) * 11 + j2;
              Cells[n, m] := To3String(TimeTable.ForTeacher[i, j1]);
            end;
        inc(n);
      end;
  end;
  if SubjSource.CurrentTeacher = nil then
    SelectCell(1, 1)
  else
  if (CurCol <> Col) and (CurCol <> -1) then
    Col := CurCol;
end;

procedure TSubjGrid.Plato(ARect: TRect);
var
  r1, r2, r3, r4: TRect;
begin
  with ARect do begin
    r1 := Rect(Left, Top - 10, Right, Top);
    r2 := Rect(Left, Bottom, Right, Bottom + 10);
    r3 := Rect(Left - 10, Top, Left, Bottom);
    r4 := Rect(Right, Top, Right + 10, Bottom);
  end;
  Tramplin(Canvas, r1, clWhite, drDown);
  Tramplin(Canvas, r2, clBlack, drUp);
  Tramplin(Canvas, r3, clWhite, drRight);
  Tramplin(Canvas, r4, clBlack, drLeft);
  DrawLayer(Canvas, ARect, Color);
end;

procedure TSubjGrid.PopupClick(Sender: TObject);
begin
  case TControl(Sender).tag of
    1:
      TableContent := tcSubject;
    2:
      TableContent := tcTeacher;
    3:
      TableContent := tcKabinet;
  end;
end;

procedure TSubjGrid.RedrawCell(ACol, ARow: Integer);
begin
  if (ACol = -1) or (ARow = -1) then
    Exit;
  if Parent = nil then
    Exit;
  DrawCell(ACol, ARow, CellRect(ACol, ARow), CellState[ACol, ARow]);
end;

procedure TSubjGrid.RedrawCells;
var
  i, j: Integer;
begin
  for i := 0 to ColCount - 1 do
    for j := 0 to RowCount - 1 do
      if Cells[i, j] <> '' then
        RedrawCell(i, j);
end;

procedure TSubjGrid.RedrawCol(ACol: Integer);
begin

end;

procedure TSubjGrid.RedrawFixed;
var
  i: Integer;
begin
  for i := 0 to ColCount - 1 do
    ReDrawCell(i, 0);
  for i := 1 to RowCount - 1 do
    ReDrawCell(0, i);
end;

procedure TSubjGrid.RedrawRow(ARow: Integer);
begin

end;

procedure TSubjGrid.Refresh(Sender: TObject);
begin
  OutTimeTable;
end;

procedure TSubjGrid.TikTimer(Sender: TObject);
var
  i, l: Integer;
begin
  Tik := (Tik + 1) mod TikCount;
  l := Length(Mults) - 1;
  for i := 0 to l do
    with Mults[i] do
      RedrawCell(x, y);
end;

procedure TSubjGrid.WMChar(var Msg: TWMChar);
begin
  inherited;
end;

/////////////////// Layers ///////////////////
procedure TSubjGrid.BorderLayer(ACol, ARow: Integer);
begin
  ResetLayerCanvas;
  with CellLayer, Canvas do begin
    Pen.Style := psSolid;
    Pen.Color := Colors.Text;
    CellLayer.Canvas.MoveTo(CellLayer.Width - 1, 0);
    CellLayer.Canvas.LineTo(CellLayer.Width - 1, CellLayer.Height - 1);
    if LastLessonIn(ARow) or (gdFixed in CellState[ACol, ARow]) then
      CellLayer.Canvas.LineTo(-1, CellLayer.Height - 1)
    else begin
      if Assigned(FSubjSource) then
        if RowToLesson(ARow + 1) - RowToLesson(ARow) > 1 then begin
          Pen.Style := psDot;
          Pen.Color := Colors.Text;
          Brush.Color := Colors.Main;
          CellLayer.Canvas.LineTo(-1, CellLayer.Height - 1);
        end;
      CellLayer.Canvas.LineTo(CellLayer.Width - 1, CellLayer.Height);
    end;
  end;
end;

procedure TSubjGrid.DrawLayer(ABitMap: TBitMap; AColor: TColor);
var
  c, cg: TColor;
begin
  cg := RGBToGray(AColor);
  with ABitMap do
    if cg < clGray then begin
      c := Mix(AColor, clWhite, 0.5);
      OutSimpleBtn(Canvas, Rect(0, 0, Width, Height), [c, c, c, AColor], 0.1, 0.3);
    end
    else begin
      c := Mix(AColor, clBlack, 0.2);
      OutSimpleBtn(ABitMap.Canvas, Rect(0, 0, Width, Height), [AColor, c, c, c], 0.9, 0.7);
    end;
end;

procedure TSubjGrid.DrawLayer(ACanvas: TCanvas; ARect: TRect; AColor: TColor);
var
  Bmp: TBitmap;
begin
  Bmp := TBitmap.Create;
  with ARect do begin
    Bmp.Width := Right - Left;
    Bmp.Height := Bottom - Top;
  end;
  DrawLayer(bmp, AColor);
  with ARect.TopLeft do
    ACanvas.Draw(x, y, Bmp);
  Bmp.Free;
end;

procedure TSubjGrid.FocusedLayer(ACol, ARow: Integer; s: String);
begin
 //SelectedLayer(ACol,ARow,s);
  ResetLayerCanvas;
  with CellLayer, Canvas do begin
    if FullView then
      Pen.Color := FColors.FullView
    else
      Pen.Color := FColors.NotFullView;
    Brush.Style := bsClear;
    Rectangle(0, 0, Width - 1, Height - 1);
    BorderLayer(ACol, ARow);
  end;
end;

procedure TSubjGrid.ImageClick(Sender: TObject);
begin
  Popup.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;

procedure TSubjGrid.InitLayer(AWidth, AHeight: Integer);
begin
  with CellLayer do begin
    Width := AWidth + 1;
    Height := AHeight + 1;
  end;
  ClearBitMap(CellLayer, clWhite);
  ResetLayerCanvas;
end;

procedure TSubjGrid.InitMainLayer;
begin
{ if ColCount<2 then Exit;
 with bmMainLayer do begin
  Width:=ColWidths[1];
  Height:=DefaultRowHeight+1;
  DrawLayer(bmMainLayer.Canvas,Rect(0,0,Width,Height));
 end;}
end;

procedure TSubjGrid.CreateLayerBitMaps;
var
  cm: TColumnMode;
  lt: TLayerType;
begin
  CellLayer := TBitMap.Create;
  for cm := cmKlass to cmKabinet do
    for lt := ltMain to ltLocked do
      Layers[cm, lt] := TBitMap.Create;
  RedrawLayers;
end;

procedure TSubjGrid.DestroyLayerBitMaps;
var
  cm: TColumnMode;
  lt: TLayerType;
begin
  CellLayer.Free;
  for cm := cmKlass to cmKabinet do
    for lt := ltMain to ltLocked do
      Layers[cm, lt].Free;
end;

procedure TSubjGrid.ResetLayerCanvas;
begin
  with CellLayer.Canvas do begin
    with Font do begin
      Color := clBlack;
      Style := [];
    end;
    with Brush do begin
      Color := clWhite;
      Style := bsSolid;
    end;
    with Pen do begin
      Color := clBlack;
      Style := psSolid;
      Width := 1;
    end;
  end;
end;

procedure TSubjGrid.TextLayer(ACol, ARow: Integer);
var
  sts: TStringList;
  i, h, dy, gh: Integer;
  s: string;
  sl: Boolean;
  AState: TGridDrawState;
begin
  ResetLayerCanvas;
  AState := CellState[ACol, ARow];
  if not (FViewText or (gdFixed in AState)) then
    Exit;
  sl := [gdFocused, gdSelected] * AState <> [];
  if not (gdFixed in AState) then
    if (ColumnMode = cmKlass) and not ViewText and not sl then
      Exit;
  s := Cells[ACol, ARow];
  with CellLayer, Canvas do begin
    if gdFixed in AState then begin
      Font.Color := clBlack;
      Font.Style := [fsBold];
    end
    else
    if sl then
      Font.Color := FColors.SelectText
    else
      Font.Color := FColors.Text;
    Brush.Style := bsClear;
    if pos(#13#10, s) > 0 then begin
      sts := TStringList.Create;
      sts.Text := s;
      gh := 0;
      for i := 0 to sts.Count - 1 do
        gh := gh + TextHeight(sts[i]);
      h := gh - 18;
      dy := abs(h - 2 * h * Tik div TikCount);
      h := 0;
      for i := 0 to sts.Count - 1 do begin
        TextOut(2, h - dy, sts[i]);
        h := h + TextHeight(sts[i]);
      end;
      sts.Free;
    end
    else
      TextOut(2, 2, s);
    Brush.Style := bsSolid;
  end;
end;

procedure TSubjGrid.RedrawLayer(cm: TColumnMode; lt: TLayerType);
var
  bmp: TBitmap;
  w, h: Integer;
  C, tc: TColor;
begin
  if lt > ltLocked then
    Exit;
  if (lt = ltSanPin) and (cm <> cmKlass) then
    Exit;
  case cm of
    cmKlass:
      w := FKlassColWidth;
    cmTeacher:
      w := FTeacherColWidth;
    cmKabinet:
      w := FKabinetColWidth;
  else
    w := 0;
  end;
  h := RowHeights[0];
  bmp := Layers[cm, lt];
  bmp.Width := w;
  bmp.Height := h;
  case lt of
    ltMain:
      c := Colors.Main;
    ltFixed:
      c := Colors.Fixed;
    ltRedFixed:
      c := Colors.Cross;
    ltSelected:
      c := Colors.Select;
    ltLocked:
      with bmp, canvas do begin
        c := clRed;
        tc := clWhite;
        ClearBitMap(bmp, tc);
        Pen.Color := c;
        Pen.Width := 2;
        MoveTo(5, Top + h div 2);
        LineTo(w - 5, Top + h div 2);
        Transparent := true;
        TransparentColor := tc;
        Exit;
      end;
    ltFocused:
      with bmp, canvas do begin
        if FullView then
          c := Colors.FullView
        else
          c := Colors.NotFullView;
        if c = clWhite then
          tc := clBlack
        else
          tc := clWhite;
        ClearBitMap(bmp, tc);
        Pen.Color := c;
        pen.Width := 1;
        Rectangle(0, 0, w, h);
        Transparent := true;
        TransparentColor := tc;
        Exit;
      end;
  else
    Exit;
  end;
  if IsDark(c) then
    Darks := Darks + [lt]
  else
    Darks := Darks - [lt];
  DrawLayer(bmp, C);
end;

procedure TSubjGrid.RedrawLayers(cm: TColumnMode);
var
  lt: TLayerType;
begin
  for lt := ltMain to ltFocused do
    RedrawLayer(cm, lt);
end;

procedure TSubjGrid.RedrawLayers(lt: TLayerType);
var
  cm: TColumnMode;
begin
  for cm := cmKlass to cmKabinet do
    RedrawLayer(cm, lt);
end;

procedure TSubjGrid.RedrawLayers;
var
  cm: TColumnMode;
begin
  for cm := cmKlass to cmKabinet do
    RedrawLayers(cm);
end;

procedure TSubjGrid.SanPin(ACol, ARow: Integer);
var
  x: Integer;
  ls, m, f, l: Integer;
  sbj: TSubject;
  AState: TGridDrawState;
begin
 // Установка стандартых цветов и шрифта
  //ResetLayerCanvas;
 // Определение состояния клетки
  AState := CellState[ACol, ARow];
 // Определение координат клетки
 // Определение номера урока в этой клетке
  ls := RowToLesson(ARow);
 // Если заголовок, то ни чего не делаем
  if ls = -1 then
    Exit;
  with CellLayer, Canvas do
    if SubjSource <> nil then
      with SubjSource.TimeTable do
        if ColumnMode = cmKlass then begin
    // Если заголовок - выход
          if gdFixed in AState then
            Exit;
    // Если столбец не к чему не привязан - выход
          if Headers[ACol] = nil then
            Exit;
    // Определение номера урока для данного столбца
          x := Headers[ACol].ItemIndex;
    // Определение предмета
          sbj := ForKlasses[x, ls];
    // Если нет предмета, то СанПин=0
          if sbj = nil then
            m := 0
          else
            m := sbj.SanPIN;
    // Если урок нулевой, то СанПИН предыдущего равен -СанПИН,
          if ls mod 11 = 0 then
            f := -m
          else begin
     // иначе определяем предыдущий предмет
            sbj := ForKlasses[x, ls - 1];
     // и определяем его СанПИН
            if sbj = nil then
              f := 0
            else
              f := sbj.SanPIN;
          end;
    // Если урок последний, то СанПИН следующего равен -СанПИН,
          if ls mod 11 = 10 then
            l := -m
          else begin
     // то определяем следующий урок
            sbj := ForKlasses[x, ls + 1];
     // и определяем его СанПИН
            if sbj = nil then
              l := 0
            else
              l := sbj.SanPIN;
          end;
    // Если СанПИН предыдущего, текущего и следующего равны 0 - выход
          if f or m or l = 0 then
            Exit;
    // Если клетка выделена,
          if [gdSelected, gdFocused] * AState <> [] then begin
     // то задать цвет для выделеной ячейки,
            Brush.Color := Colors.SelectSanPinLesson;
            Pen.Color := Colors.SelectSanPinLesson;
          end
          else begin
     // Если показан текст,
            if ViewText
     // то установить цвет для не выделенной клетки,
            then
              Brush.Color := Colors.SanPinLesson
     // иначе установить цвет для выделенной клетки
            else
              Brush.Color := Colors.SelectSanPinLesson;
     // рамка СанПИНа белая
            Pen.Color := clWhite;
          end;
    // Закраска сплошным цветом
          Brush.Style := bsSolid;
    // Находим точки пересечения линий, на границе уроков
          f := (f + m) * 2;
          l := (l + m) * 2;
    // Находим пик СанПИН
          m := m * 4;
    // Рисуем СанПИН
          Polygon([Point(0, 0), Point(f, 0), Point(m, (0 + Height) div 2)
            , Point(l, Height), Point(0, Height)]);
        end// Если есть источник данных
  ;
end;

{protected}
function TSubjGrid.SelectCell(ACol, ARow: Longint): Boolean;
var
  cl: Integer;
  kl: TKlass;
begin
  result := inherited SelectCell(ACol, ARow);
  if not result then
    Exit;
  if SubjSource = nil then
    Exit;
  with SubjSource do begin
    cl := RowToLesson(ARow);
    if cl = -1 then
      cl := CurrentLesson;
    case ColumnMode of
      cmKlass:
      begin
        kl := TKlass(Headers[ACol]);
        if kl <> nil then begin
          // 25.04.2012 old -> CurrentSubject := kl.LessAbs[cl];
          CurrentSubject := TimeTable.ForKlasses[kl.ItemIndex, cl];  
        end;
        CurrentKlass := kl;
      end;
      cmTeacher:
        CurrentTeacher := TTeacher(Headers[ACol]);
      cmKabinet:
        CurrentKabinet := TKabinet(Headers[ACol]);
    end;
    CurrentLesson := cl;
  end;
end;

procedure TSubjGrid._Test;
begin
  Plato(Rect(15, 60, 200, 200));
end;

procedure TSubjGrid.DrawCell(ACol, ARow: Integer; ARect: TRect;
  AState: TGridDrawState);
var
 //ls:Integer;
 //s:string;
 //us:boolean;
  HeadObj: TObject;
 //cm:TColumnMode;
  lt: TLayerType;
  slt: TLayerTypeSet;
  lay: TBitMap;
begin
  if SpeedButtonPaintCount > 0 then begin
    dec(SpeedButtonPaintCount);
    Exit;
  end;
  if (ACol > 0) and (ARect.Left = 0) then
    Exit;
  if (ARow > 0) and (ARect.Top = 0) then
    Exit;

 { DONE  -oOwner -cCategory :Сделать рисование
 1. Выделеной ячейки
 2. Сфокусированой ячейки
 3. Фиксед-ячейки }
  with Canvas do begin
  // Определение номера урока
  // ls:=RowToLesson(Arow);
  // Клетка не заблокирована
  //us:=ACol>0;
  // Не первый столбец?
  //if us then
    begin
      HeadObj := Headers[ACol];
   // Заголовок привязан к объекту?
      if (HeadObj <> nil) and (HeadObj is TSimpleItem) then;
    // Определить заблокирована ли клетка
    // us:=ls in TSimpleItem(HeadObj).Lock;
    end;
  // Очистить клетку
    InitLayer(ColWidths[ACol], RowHeights[ARow]);
    if AState = [gdFixed] then
      slt := [ltFixed]
    else
      slt := [ltMain, ltSanPin];
    if gdSelected in AState then
      slt := [ltSelected, ltSanPin];
    if gdFocused in AState then
      slt := [ltSelected, ltFocused, ltSanPin];
    slt := slt + [ltText];
  //Cells[ACol,ARow]:=format('%d %d',[CellLayer.Width,CellLayer.Height]);
    for Lt := ltMain to ltFocused do begin
      if not (lt in slt) then
        continue;
      case lt of
        ltSanPIN:
          SanPin(ACol, ARow);
        ltText:
          TextLayer(ACol, ARow);
        ltFocused:
          FocusedLayer(ACol, ARow);
      else
      begin
        lay := Layers[ColumnMode, lt];
        if lt in Darks then
          CellLayer.Canvas.Draw(0, 0, lay)
        else
          CellLayer.Canvas.Draw(CellLayer.Width - Lay.Width, CellLayer.Height - Lay.Height, lay);
      end;
      end;
      if lt in [ltFixed, ltRedFixed] then
        FixedLayer(ACol, ARow);
    end;
    BorderLayer(ACol, ARow);
    with ARect.TopLeft do
      Draw(x, y, CellLayer);
  end;
 // todo: Перерисовать "кнопки" в сетке
  if (ACol = 0) and (ARow = 0) then begin
    // btnTC.Invalidate;
    // btnFullView.Invalidate;
  end;
end;

procedure TSubjGrid.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
end;

procedure TSubjGrid.KeyUp(var Key: Word; Shift: TShiftState);
var
  sc: Word;
  ls: Integer;
begin
  inherited;
  sc := ShortCut(Key, Shift);
  ls := RowToLesson(Row);
  if SubjSource <> nil then
    with SubjSource do
      case sc of
        scCtrl + VK_SPACE:
        begin
          SwitchLock;
          RedrawCell(Col, Row);
        end;
        VK_Delete:
        begin
          case ColumnMode of
            cmKlass:
              DeleteCell(ls, CurrentKlass);
            cmTeacher:
              DeleteCell(ls, CurrentTeacher);
            cmKabinet:
              DeleteCell(ls, CurrentKabinet);
          end;
          RedrawCell(Col, Row);
        end;
        VK_F2: begin
          case ColumnMode of
            cmKlass:
              Change(TimeTable.ForKlasses[CurrentKlass.ItemIndex,ls]);
            cmTeacher:
              Change(TimeTable.ForTeacher[CurrentTeacher.ItemIndex,ls][0]);
            cmKabinet:
              Change(TimeTable.ForKabinet[CurrentKabinet.ItemIndex,ls][0]);
          end;

        end;
      end;
end;

procedure TSubjGrid.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if (AComponent = SubjSource) and (Operation = opRemove) then
    SubjSource := nil;
  inherited;
end;

{public}
constructor TSubjGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetLength(FCells, ColCount);
  SubjLink := TSubjLink.Create;
  InitSubjLink;
  FSaveCellExtents := false;
  ParentCtl3D := false;
  Ctl3D := false;
  DefaultRowHeight := 18;
  DefaultDrawing := false;
  RowHeights[0] := 21;
  Timer := TTimer.Create(Self);
  Timer.onTimer := TikTimer;
  Timer.Interval := 200;
  Tik := 0;
  TikCount := 20;
  FViewText := true;
  bmIcons := TBitMap.Create;
  bmIcons.LoadFromResourceName(HInstance, 'Main');
  bmIcons.Transparent := true;
  Panel := TPanel.Create(self);
  with Panel do begin
    BoundsRect := Rect(0, 0, 46, 21);
    BevelOuter := bvNone;
    Color := FixedColor;
    if 1 = 1 then
      Parent := Self
    else begin
      Left := Self.Left;
      Top := Self.Top;
      Parent := Self.Parent;
      Caption := 'Текст'; {Отладка. Удалить}
      BringToFront;
    end;
  end;
  Popup := TPopupMenu.Create(self);
  InitPopup;
//  btnTC := TSpeedButton.Create(self);
//  with btnTC do begin
//    FillIcon(Glyph, 0);
//    Flat := true;
//    BoundsRect := Rect(1, 0, 22, 21);
//    parent := Panel;
//    onClick := TCClick;
//    Visible := false;
//  end;
//  btnFullView := TSpeedButton.Create(self);
//  with btnFullView do begin
//    Flat := true;
//    BoundsRect := Rect(24, 0, 45, 21);
//    parent := Panel;
//    Glyph.LoadFromResourceName(HInstance, 'eye');
//    NumGlyphs := 4;
//    GroupIndex := 1;
//    AllowAllUp := true;
//    onClick := FullViewClick;
//    Visible := false;
//  end;

  imgFullView := TImage.Create(Self);
  imgFullView.BoundsRect := Rect(3, 3, 18, 18);
  FillIcon(imgFullView.Picture.Bitmap, 0);
  imgFullView.Transparent := true;
  imgFullView.PopupMenu := Popup;
  imgFullView.Hint := 'OK';
  imgFullView.OnClick := ImageClick;
  imgFullView.ShowHint := true;
  imgFullView.Parent := Panel;

  FColors := TGridColors.Create;
  FKlassColWidth := 70;
  FTeacherColWidth := 100;
  FKabinetColWidth := 100;
  CreateLayerBitMaps;
  FColors.onChange := ChangeColor;
  Align := alClient;
  Options := [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine
    , goDrawFocusSelected, goThumbTracking];
  Edit := TEdit.Create(self);
  Edit.Visible := false;
  ComboBox := TComboBox.Create(self);
  ComboBox.Visible := false;
end;

destructor TSubjGrid.Destroy;
begin
  FColors.Free;
  if FSubjSource <> nil then
    FSubjSource.SubjLinks.Delete(SubjLink);
  SubjLink.Free;
  bmIcons.Free;
  DestroyLayerBitMaps;
  inherited;
end;

procedure TSubjGrid.FixedLayer(ACol, ARow: Integer);
var
  i, x1, x2, y: Integer;
  kl: TKlass;
begin
  ResetLayerCanvas;
  with CellLayer, Canvas do
    while (ARow = 1) and (ACol > 0) and (ColumnMode = cmKlass) do begin
      if SubjSource = nil then
        break;
      kl := TKlass(Headers[ACol]);
      if kl = nil then
        break;
      Brush.Style := bsSolid;
      Brush.Color := Colors.SanPinWeekDay;
      for i := 0 to WDCount - 1 do begin
        x1 := i * CellLayer.Width div WDCount;
        x2 := (i + 1) * CellLayer.Width div WDCount + 1;
        y := Round((1 - kl.WDSanPIN[i]) * CellLayer.Height);
        Rectangle(x1, CellLayer.Height, x2, y);
      end;
      break;
    end;
end;

end.
