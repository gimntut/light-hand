////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//    Модуль описания взаимосвязи предметов, учителей, уроков и кабинетов     //
//                          в  школьном расписании                            //
//                                                                            //
//                   Разработчик: Гимаев Наиль 2000-2006, 2012г               //
////////////////////////////////////////////////////////////////////////////////

//////////// СЛОВАРИК //////////////
/// substitution - подмена

unit sbjKernel;

interface

uses Windows, SysUtils, Classes, Grids, ComCtrls, SbjColl, Dialogs,
  SbjResource, publ, superobject;

type
 ////////////////////// forward //////////////////////
  TKabinets = class ;
  TKlasses = class ;
  TPlainSubjects = class ;
  TSubject = class ;
  TSubjects = class ;
  TTeachers = class ;
  TTimeTable = class ;
 ////////////////////// x //////////////////////
  TSubs = array of TSubject;
  TCrossRef = array[0..LessCount - 1] of Integer;

  TName = record
    Long: string;
    Short: string;
    Pin: integer;
  end;
 ////////////////////// x //////////////////////
 // TSubjNames - наименования предметов
 // procedure Put(Index: Integer; const S: string); override;
 // property LongName[x:integer]:string read GetLongName write SetLongName;
 // property ShortName[x:integer]:string read GetShortName write SetShortName;
 // property SanPIN[x:integer]:Integer read GetSanPIN write SetSanPIN;
 // function Add(Long,Short:string;PIN:integer):integer; reintroduce; overload;
 // procedure LoadFromStream(Stream:TStream); override;
  TSubjNames = class (TStringList)
  private
    Longs: TStringList;
    function GetLongName(Index: integer): string;
    function GetMaxInd: integer;
    function GetSanPIN(Index: integer): Integer;
    function GetShortName(Index: integer): string;
    procedure SetLongName(Index: integer; const Value: string);
    procedure SetSanPIN(Index: integer; const Value: Integer);
    procedure SetShortName(Index: integer; const Value: string);
  protected
    procedure Put(Index: Integer; const S: string); override;
    property MaxInd: integer read GetMaxInd;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(Long, Short: string; PIN: integer): integer; reintroduce; overload;
    function AsJSonObject:ISuperObject;
    procedure LoadFromStream(Stream: TStream); override;
    property LongName[x: integer]: string read GetLongName write SetLongName;
    property SanPIN[x: integer]: Integer read GetSanPIN write SetSanPIN;
    property ShortName[x: integer]: string read GetShortName write SetShortName;
  end;
 ////////////////////// x //////////////////////
 // TSimpleItem - Упрощёный вариант примитива
 // IsLock(ALesson):boolean - проверка заблокированости;
 // IsCross(ALesson):boolean - проверка наличия пересечения;
 // SwitchLock(x: integer) - переключение заблокированости;
 // Name:string - Имя примитива
 // Lock:TCross - массив заблокированостей
 // Checked:boolean - показан ли примитив в сетке
 // Cross:TCross - массив пересечений
 // SubjectX: - пересекающиеся предметы
  TSimpleItem = class (TCollItem)
  private
    FChecked: boolean;
    FCross: TCross;
    FLock: TCross;
    FName: string;
    FPlainSubjectX: TPlainSubjects;
    FSubjInTT: array[0..LessCount - 1] of TPlainSubjects;
    function GetAvailableSubjects(LessonIndex: integer): TSubjects;
    function GetCross: TCross; virtual;
  ////////////////////// Новые методы //////////////////////
    function GetSubjsInTT(LessonIndex: Integer): TPlainSubjects;
    procedure SetSubjsInTT(LessonIndex: Integer; const Value: TPlainSubjects);
  public
    constructor Create; override;
    destructor Destroy; override;
    function IsCross(ALesson: Integer): boolean;
    function IsLock(ALesson: Integer): boolean;
    procedure SwitchLock(LessonIndex: integer);
    property AvailableSubjects[LessonIndex: integer]: TSubjects read GetAvailableSubjects;
    property Checked: boolean read FChecked write FChecked;
    property Cross: TCross read GetCross write FCross;
    property Lock: TCross read FLock write FLock;
    property Name: string read FName write FName;
    property SubjectX: TPlainSubjects read FPlainSubjectX;
  ////////////////////// Новые свойства (6/10/2006) //////////////////////
    property SubjsInTT[LessonIndex: Integer]: TPlainSubjects read GetSubjsInTT write SetSubjsInTT;
  end;
 ////////////////////// x //////////////////////
 // TTimeTableX - Информация о связи с расписанием
 // Klasses[ALesson]:TIntegers - список классов для заданого объекта,
 // в которых объект данного урока уже в расписании
  TTimeTableX = class (TPersistent)
  private
    FItems: array[0..LessCount - 1] of TIntegers;
    NullItem: TIntegers;
    function GetItems(ALesson: integer): TIntegers;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property Klasses[ALesson: integer]: TIntegers read GetItems; default;
  end;
 ////////////////////// x //////////////////////
 // TRefItem - Усложнёный примитив с множествеными пересечениями
 // DecCross(Lesson)/IncCross(Lesson) - Удаление/добавление числа пересечений этого объекта
 // Cross:TCross - Наличие пересечений
 // CrossRef[Lesson]:Integer - число пересечений;
 // TimeTableX:TTimeTableX - столбцы по классам, где встречается этот элемент;
  TRefItem = class (TSimpleItem)
  private
    FCrossRef: TCrossRef;
    FTimeTableX: TTimeTableX;
    function GetCross: TCross; override;
    function GetCrossRef(Lesson: Integer): Integer;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure DecCross(Lesson: Integer);
    procedure IncCross(Lesson: Integer);
    property Cross: TCross read GetCross;
    property CrossRef[Lesson: Integer]: Integer read GetCrossRef;
    property TimeTableX: TTimeTableX read FTimeTableX;
  end;
 ////////////////////// x //////////////////////
 // TKlass - Информация об экземпляре класса
 // Assign(Source: TPersistent); - копирование информации о другом классе
 // Kabinets:TKabinets - список кабинетов которые может? занять класс
 // LessAbs[LessonIndex:integer]:TSubject - предмет по индексу урока
 // Lessons[WeekDay,LessonNumber:integer]:TSubject - предмет по уроку и дню недели
 // Teachers:TTeachers - список учителей которые преподают? в данном классе
 // WDSanPIN[WD:Integer]:Real - нагруженость класса в зависимости от дня недели
 // Прим.: Общая загруженость класса за неделю = 1
  TKlass = class (TSimpleItem)
  private
    FKabinets: TKabinets;
    FLesson: array[0..LessCount - 1] of TSubject;
    FMaxSanPIN: Integer;
    FTeachers: TTeachers;
    FWDSanPIN: array[0..WDCount - 1] of Integer;
    function GetLessAbs(LessonIndex: integer): TSubject;
    function GetLesson(WeekDay, LessonNumber: integer): TSubject;
    function GetWDSanPIN(WD: Integer): Real;
    procedure FindMaxSanPIN;
    procedure SetLessAbs(LessonIndex: integer; const Value: TSubject);
    procedure SetLesson(WeekDay, LessonNumber: integer; const Value: TSubject);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property Kabinets: TKabinets read FKabinets;
    property LessAbs[LessonIndex: integer]: TSubject read GetLessAbs write SetLessAbs;
    property Lessons[WeekDay, LessonNumber: integer]: TSubject read GetLesson write SetLesson;
    property Teachers: TTeachers read FTeachers;
    property WDSanPIN[WD: Integer]: Real read GetWDSanPIN;
  end;
 ////////////////////// x //////////////////////
 // TKabinet - информация об экземпляре кабинета
 // FullName(): string; - название кабинета с номером
 // Assign(Source) - копирование информации о другом кабинете
 // Num:Integer - номер кабинета
 // Klasses:TKlasses - классы которые занимаются? в данном кабинете
 // Teachers:TTeachers - учителя которые преподают в данном кабинете
 // ShowNum:boolean - показывать ли номер урока в расписании
  TKabinet = class (TRefItem)
  private
    FNum: Integer;
    FKlasses: TKlasses;
    FTeachers: TTeachers;
    FShowNum: boolean;
  public
    constructor Create; override;
    destructor Destroy; override;
    function FullName: string;
    procedure Assign(Source: TPersistent); override;
    property Klasses: TKlasses read FKlasses;
    property Num: Integer read FNum write FNum;
    property ShowNum: boolean read FShowNum write FShowNum;
    property Teachers: TTeachers read FTeachers;
  end;
 ////////////////////// x //////////////////////
 // TTeacher - информация об экземпляре учителя
 // Assign(Source) - копирование информации о другом учителе
 // ShortName():string - фамилия с инициалами
 // KabNum:integer - номер кабинета, где, как правило, преподаёт данный учитель
 // Kabinets:TKabinets - кабинеты в которых ведёт данный преподаватель
 // Klasses:TKlasses - классы в которых ведёт данный преподаватель
  TTeacher = class (TRefItem)
  private
    FKabinets: TKabinets;
    FKabNum: integer;
    FKlasses: TKlasses;
  public
    constructor Create; override;
    destructor Destroy; override;
    function ShortName: string;
    procedure Assign(Source: TPersistent); override;
    property Kabinets: TKabinets read FKabinets;
    property KabNum: integer read FKabNum write FKabNum;
    property Klasses: TKlasses read FKlasses;
  end;
 ////////////////////// x //////////////////////
 // TKlasses - коллекция классов
  TKlasses = class (TColl)
  private
    FFormatString: string;
    sts: TStringList;
    function GetFullKlassName(x: integer): string;
    function GetItem(x: integer): TKlass;
    procedure SetFormatString(const Value: string);
    procedure SetItem(x: integer; const Value: TKlass);
  public
    constructor Create(AutoIndex: boolean);
    destructor Destroy; override;
    function AddNewItem: TKlass;
    function IndexOf(Name: string): integer;
    function Lines(short: boolean): TStrings;
    function AsJSonObject:ISuperObject;
    procedure Assign(Source: TPersistent); override;
    property FormatString: string read FFormatString write SetFormatString;
    property FullKlassName[x: integer]: string read GetFullKlassName;
    property Item[x: integer]: TKlass read GetItem write SetItem; default;
  end;
 ////////////////////// x //////////////////////
 // TKabinets - коллекция кабинетов
  TKabinets = class (TColl)
  private
    AnyKabinet: TKabinet;
    sts: TStringList;
    function GetItem(x: integer): TKabinet;
    procedure SetItem(x: integer; const Value: TKabinet);
  public
    constructor Create(AutoIndex: boolean);
    destructor Destroy; override;
    function AddNewItem: TKabinet;
    function IndexOf(Num: integer): integer;
    function Lines(Short: boolean): TStrings;
    function AsJSonObject:ISuperObject;
    procedure Assign(Source: TPersistent); override;
    procedure Clear(AutoFree: boolean);
    property Item[x: integer]: TKabinet read GetItem write SetItem; default;
  end;
 ////////////////////// x //////////////////////
 // TTeachers - коллекция учитилей
  TTeachers = class (TColl)
  private
    sts: TStringList;
    function GetItem(x: integer): TTeacher;
    procedure SetItem(x: integer; const Value: TTeacher);
  public
    constructor Create(AutoIndex: boolean);
    destructor Destroy; override;
    function AddNewItem: TTeacher;
    function IndexOf(Name: string): integer;
    function Lines(Short: boolean): TStrings;
    procedure Assign(Source: TPersistent); override;
    property Item[x: integer]: TTeacher read GetItem write SetItem; default;
  end;
 ////////////////////// x //////////////////////
  TLessons = set of 0..10;
 ////////////////////// x //////////////////////
 // TSubject - информация об одном предмете
 // ProC SetID(const Value: integer); - Задать индекс предмета
 // prop InTimeTable - количество упоминаний предмета в расписании
 // ProC Add(Teacher: TTeacher; Kabinet: TKabinet); - добавить преподавателя и
 // * кабинет в котором проходит урок
 // ProC Assign(Source: TPersistent); - перенос данных из другого предмета
 // ProC Clear; - очистка списка преподавателей и кабинетов
 // ProC Delete(x:integer); - удалить предмеи и кабинет
 // prop Complexion - Вид урока (Обычный, спаренный, половинный)
 // prop Cross - Пересекающиеся уроки
 // prop Info - Информация о предмете
 // prop Kabinets - список кабинетов
 // prop Klass - класс в котором проходит предмет
 // prop KlassTitle - Класс+(Предмет/Кабинет/Учитель)
 // prop LessonAtWeek - Максимальное число часов в неделю
 // prop LongKlassName - Полное название класса
 // prop LongName - Полное название предмета
 // prop MultiLine - Многострочная информация о предмете (True/False)
 // prop NameIndex - Порядковый номер названия предмета
 // prop Parent - Индекс предмета от которого произошёл текущий
 // prop SanPIN - Балл предмета по СанПИН
 // prop ShortName - Короткое имя предмета
 // prop State - Состояние предмета (вид пересечения)
 // prop TeacherCount - Количество учителей ведущих этот предмет
 // prop Teachers - Список учителей ведущих этот предмет
 // prop TimeTableX -
 // prop Title
 // prop Visible
  TSubject = class (TCollItem)
  private
    FComplexion: integer;
    FInTimeTable: Integer;
    FKabinets: array of TKabinet;
    FKlass: TKlass;
    FLessonAtWeek: Integer;
    FMultiLine: boolean;
    FNameIndex: integer;
    FNames: TSubjNames;
    FParent: TSubject;
    FTeachers: array of TTeacher;
    FTimeTableX: TTimeTableX;
    MaxInd: integer;
    function GetCross: TCross;
    function GetInfo: string;
    function GetKabinets(x: integer): TKabinet;
    function GetKlassTitle(tc: TTableContent): string;
    function GetLongKlassName: string;
    function GetLongName: string;
    function GetSanPIN: integer;
    function GetShortName: string;
    function GetState(Lesson: Integer): TSubjState;
    function GetTeacherCount: integer;
    function GetTeachers(x: integer): TTeacher;
    function GetTitle(tc: TTableContent): string;
    function GetVisible: boolean;
    function ObrTime(t: integer): string;
    procedure IncCount;
    procedure SetInTimeTable(const Value: Integer);
    procedure SeTKabinets(x: integer; const Value: TKabinet);
    procedure SetKlass(const Value: TKlass);
    procedure SetNameIndex(const Value: integer);
    procedure SetTeacherCount(const Value: integer);
    procedure SetTeachers(x: integer; const Value: TTeacher);
  protected
    procedure SetIndex(const Value: integer); override;
    property InTimeTable: Integer read FInTimeTable write SetInTimeTable;
  public
    constructor Create(Names: TSubjNames); reintroduce;
    destructor Destroy; override;
    procedure Add(Teacher: TTeacher; Kabinet: TKabinet);
    procedure Assign(Source: TPersistent); override;
    procedure Clear;
    procedure Delete(x: integer);
    property Complexion: integer read FComplexion write FComplexion;{Complexion = 0,1,2 = Обычный, Спаренный, Половинный}
    property Cross: TCross read GetCross;
    property Info: string read GetInfo;
    property Kabinets[x: integer]: TKabinet read GeTKabinets write SeTKabinets;
    property Klass: TKlass read FKlass write SetKlass;
    property KlassTitle[tc: TTableContent]: string read GetKlassTitle;
    property LessonAtWeek: Integer read FLessonAtWeek write FLessonAtWeek;
    property LongKlassName: string read GetLongKlassName;
    property LongName: string read GetLongName;
    property MultiLine: boolean read FMultiLine write FMultiLine;
    property NameIndex: integer read FNameIndex write SetNameIndex;
    property SanPIN: integer read GetSanPIN;
    property ShortName: string read GetShortName;
    property State[Lesson: Integer]: TSubjState read GetState;
    property TeacherCount: integer read GetTeacherCount write SetTeacherCount;
    property Teachers[x: integer]: TTeacher read GetTeachers write SetTeachers;
    property TimeTableX: TTimeTableX read FTimeTableX;
    property Title[tc: TTableContent]: string read GetTitle;
    property Visible: boolean read GetVisible;
  end;
 ////////////////////// x //////////////////////
 // TPlainSubjects - простая коллекция предметов
  TPlainSubjects = class (TColl)
    function GetItem(x: integer): TSubject;
    procedure SetItem(x: integer; const Value: TSubject);
  public
    constructor Create(AutoIndex: boolean);
    procedure Assign(Source: TPersistent); override;
    property Item[x: integer]: TSubject read GetItem write SetItem; default;
  end;
 ////////////////////// x //////////////////////
 // TTimeTable - Содержимое сетки расписания
  TTimeTable = class (TPersistent)
  private
    FSubjects: TSubjects;
    Klasses: TKlasses;
    Subjs: TSubs;
    function GetForKabinet(KabinetIndex, LessonIndex: integer): TSubs;
    function GetForTeacher(TeacherIndex, LessonIndex: integer): TSubs;
    function GetItems(KlassIndex, LessonIndex: integer): TSubject;
    procedure ClearSubjs;
    procedure SetSubjects(const Value: TSubjects);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(LessonIndex: integer; Subject: TSubject);
    procedure Delete(LessonIndex: integer; Kabinet: TKabinet); overload;
    procedure Delete(LessonIndex: integer; Klass: TKlass); overload;
    procedure Delete(LessonIndex: integer; Subject: TSubject); overload;
    procedure Delete(LessonIndex: integer; Teacher: TTeacher); overload;
    property ForKabinet[KabinetIndex, LessonIndex: integer]: TSubs read GetForKabinet;
    property ForKlasses[KlassIndex, LessonIndex: integer]: TSubject read GetItems;
    property ForTeacher[TeacherIndex, LessonIndex: integer]: TSubs read GetForTeacher;
    property Subjects: TSubjects read FSubjects write SetSubjects;
  end;
 ////////////////////// x //////////////////////
 // TSubjects - информация о всех предметах
  TSubjects = class (TPlainSubjects)
  private
    FTimeTable: TTimeTable;
    FKabinets: TKabinets;
    FKlasses: TKlasses;
    FTeachers: TTeachers;
    FViewMode: TViewMode;
    FColumnMode: TColumnMode;
    FTableContent: TTableContent;
    FWeekDays: TSetWeekDays;
    FLessons: TCross;
    FSubjectNames: TSubjNames;
    FFullView: boolean;
    function DaNet(us: boolean): string;
    function DaNetStr(s: string): boolean;
    function ExTrim(s: string): String;
    function GetSubject(x: integer): TSubject;
    function LoadKabinets(sr: TStream): boolean;
    function LoadKlasses(sr: TStream): boolean;
    function LoadSubjectNames(sr: TStream): boolean;
    function LoadSubjects(sr: TStream): boolean;
    function LoadTeachers(sr: TStream): boolean;
    function LoadTimeTable(sr: TStream): boolean;
    function LoadTxtKabinets(var tx: TextFile): boolean;
    function LoadTxtKlasses(var tx: TextFile): boolean;
    function LoadTxtSubjectNames(var tx: TextFile): boolean;
    function LoadTxtSubjects(var tx: TextFile): boolean;
    function LoadTxtTeachers(var tx: TextFile): boolean;
    function LoadTxtTimeTable(var tx: TextFile): boolean;
    function ReadDaNet(var tx: TextFile): Boolean;
    function ReadEx(var tx: TextFile): String;
    function ReadIntEx(var tx: TextFile): Integer;
    procedure SaveKabinets(sr: TStream);
    procedure SaveKlasses(sr: TStream);
    procedure SaveSubjectNames(sr: TStream);
    procedure SaveSubjects(sr: TStream);
    procedure SaveTeachers(sr: TStream);
    procedure SaveTimeTable(sr: TStream);
    procedure SaveTxtKabinets(var tx: TextFile);
    procedure SaveTxtKlasses(var tx: TextFile);
    procedure SaveTxtSubjectNames(var tx: TextFile);
    procedure SaveTxtSubjects(var tx: TextFile);
    procedure SaveTxtTeachers(var tx: TextFile);
    procedure SaveTxtTimeTable(var tx: TextFile);
    procedure SetSubject(x: integer; const Value: TSubject);
  public
    constructor Create;
    destructor Destroy; override;
    function Add(Subject: TSubject): integer; overload;
    function Add: TSubject; overload;
    function IsCross(subj1, subj2: TSubject): boolean;
    function AsJSonObject:ISuperObject;
    procedure Clear;
    procedure Delete(Subject: TSubject); overload;
    procedure Delete(x: Integer); overload;
    procedure Load(srBig: TStream; var Key: string; var srSmall: TStream);
    procedure LoadFromFile(fn: string);
    procedure LoadFromTextFile(fn: string);
    procedure Save(srBig: TStream; Key: string; srSmall: TStream);
    procedure SaveToFile(fn: string);
    procedure SaveToTextFile(fn: string);
    property ColumnMode: TColumnMode read FColumnMode write FColumnMode;
    property FullView: boolean read FFullView write FFullView;
    property Item[x: integer]: TSubject read GetSubject write SetSubject; default;
    property Kabinets: TKabinets read FKabinets;
    property Klasses: TKlasses read FKlasses;
    property Lessons: TCross read FLessons write FLessons;
    property SubjectNames: TSubjNames read FSubjectNames;
    property TableContent: TTableContent read FTableContent write FTableContent;
    property Teachers: TTeachers read FTeachers;
    property TimeTable: TTimeTable read FTimeTable;
    property ViewMode: TViewMode read FViewMode write FViewMode;
    property WeekDays: TSetWeekDays read FWeekDays write FWeekDays;
  end;
 ////////////////////// x //////////////////////
function ToName(s: string): TName;
function FromName(Long, Short: string; Pin: integer): string;

implementation

uses DateUtils, Math, StrUtils;
//////////////////////////////////////////////////
                  { TSubjNames }
//////////////////////////////////////////////////
{private}
function TSubjNames.GetLongName(Index: integer): string;
begin
  result := '';
  if (Index < 0) or (Index > MaxInd) then
    Exit;
  result := ToName(Strings[Index]).Long;
end;

function TSubjNames.GetMaxInd: integer;
begin
  result := Count - 1;
end;

function TSubjNames.GetSanPIN(Index: integer): Integer;
begin
  result := 0;
  if (Index < 0) or (Index > MaxInd) then
    Exit;
  result := ToName(Strings[Index]).Pin;
end;

function TSubjNames.GetShortName(Index: integer): string;
begin
  result := '';
  if (Index < 0) or (Index > MaxInd) then
    Exit;
  result := ToName(Strings[Index]).Short;
end;

procedure TSubjNames.SetLongName(Index: integer; const Value: string);
var
  sts: TStringList;
begin
  if (Index < 0) or (Index > MaxInd) then
    Exit;
  sts := TStringList.Create;
  sts.CommaText := Strings[Index];
  sts[0] := Value;
  Strings[Index] := sts.CommaText;
  sts.Free;
end;

procedure TSubjNames.SetSanPIN(Index: integer; const Value: Integer);
var
  sts: TStringList;
begin
  if (Index < 0) or (Index > MaxInd) then
    Exit;
  sts := TStringList.Create;
  sts.CommaText := Strings[Index];
  sts[2] := IntToStr(Value);
  Strings[Index] := sts.CommaText;
  sts.Free;
end;

procedure TSubjNames.SetShortName(Index: integer; const Value: string);
var
  sts: TStringList;
begin
  if (Index < 0) or (Index > MaxInd) then
    Exit;
  sts := TStringList.Create;
  sts.CommaText := Strings[Index];
  sts[1] := Value;
  Strings[Index] := sts.CommaText;
  sts.Free;
end;

{protected}
procedure TSubjNames.Put(Index: Integer; const S: string);
var
  Name: TName;
  i: integer;
begin
  if Longs.Find(LongName[index], i) then
    Longs.Delete(i);
  inherited;
  Name := ToName(s);
  Longs.Add(Name.Long);
end;

{public}
function TSubjNames.AsJSonObject: ISuperObject;
var
  I:Integer;
  supArray: TSuperArray;
  supKabinet: ISuperObject;
  SubjName: ISuperObject;
begin
  Result := so;
  Result.I['Count']:=Count;
  Result.O['Items']:=so('[]');
  supArray:=Result.A['Items'];
  for I := 0 to Count - 1 do begin
    SubjName:=so;
    SubjName.S['LongName']:=LongName[I];
    SubjName.S['ShortName']:=ShortName[I];
    SubjName.I['SanPIN']:=SanPIN[I];
    supArray.Add(SubjName);
  end;
end;

constructor TSubjNames.Create;
begin
  Longs := TStringList.Create;
  Longs.CaseSensitive := false;
  Longs.Sorted := true;
  Longs.Duplicates := dupIgnore;
end;

destructor TSubjNames.Destroy;
begin
  Longs.Free;
  inherited;
end;

function TSubjNames.Add(Long, Short: string; PIN: integer): integer;
var
  i, x: integer;
  s: string;
  Name: TName;
begin
  s := FromName(Long, Short, Pin);
  if Longs.Find(Long, x) then begin
    for i := 0 to MaxInd do begin
      Name := ToName(Strings[i]);
      if SameText(Name.Long, Long) then begin
        x := i;
        break;
      end;
    end;
    strings[x] := s;
    result := x;
  end
  else begin
    Longs.Add(Long);
    result := self.Add(s);
  end;
end;

procedure TSubjNames.LoadFromStream(Stream: TStream);
var
  i: integer;
begin
  inherited;
  Longs.Clear;
  for i := 0 to MaxInd do
    Longs.Add(LongName[i]);
end;

//////////////////////////////////////////////////
                  { TSimpleItem }
//////////////////////////////////////////////////
{private}
function TSimpleItem.GetCross: TCross;
begin
  Result := FCross;
end;

{public}
constructor TSimpleItem.Create;
var
  i: integer;
begin
  inherited;
  for i := 0 to LessCount - 1 do
    FSubjInTT[i] := TPlainSubjects.Create(false);
  FName := '';
  FPlainSubjectX := TPlainSubjects.Create(false);
  FChecked := true;
  FLock := [];
  FCross := [];
end;

destructor TSimpleItem.Destroy;
begin
  FPlainSubjectX.Free;
  inherited;
end;

function TSimpleItem.IsCross(ALesson: Integer): boolean;
begin
  result := ALesson in FCross;
end;

function TSimpleItem.IsLock(ALesson: Integer): boolean;
begin
  result := ALesson in FLock;
end;

procedure TSimpleItem.SwitchLock(LessonIndex: integer);
begin
  if self = nil then
    Exit;
  if (LessonIndex < 0) or (LessonIndex > LessCount - 1) then
    Exit;
  if LessonIndex in Lock then
    Lock := Lock - [LessonIndex]
  else
    Lock := Lock + [LessonIndex];
end;

//////////////////////////////////////////////////
                  { TTimeTableX }
//////////////////////////////////////////////////
{private}
function TTimeTableX.GetItems(ALesson: integer): TIntegers;
begin
  if (ALesson < 0) or (ALesson > LessCount - 1) then begin
    NullItem.Clear;
    result := NullItem;
  end
  else
    result := FItems[ALesson];
end;

{public}
constructor TTimeTableX.Create;
var
  i: integer;
begin
  inherited;
  for i := 0 to LessCount - 1 do
    FItems[i] := TIntegers.Create;
  NullItem := TIntegers.Create;
end;

destructor TTimeTableX.Destroy;
var
  i: integer;
begin
  for i := 0 to LessCount - 1 do
    FItems[i].Free;
  NullItem.Free;
  inherited;
end;

procedure TTimeTableX.Assign(Source: TPersistent);
var
  i: integer;
begin
  if Source is TTimeTableX then
    for i := 0 to LessCount - 1 do begin
      FItems[i].Clear;
      FItems[i].Add(TTimeTableX(Source).Klasses[i]);
    end
  else
    inherited Assign(Source);
end;

//////////////////////////////////////////////////
                  { TRefItem }
//////////////////////////////////////////////////
{private}
function TRefItem.GetCross: TCross;
begin
  result := inherited GetCross;
end;

function TRefItem.GetCrossRef(Lesson: Integer): Integer;
begin
  result := 0;
  if (Lesson < 0) or (Lesson >= LessCount) then
    Exit;
  result := FCrossRef[Lesson];
end;

{public}
constructor TRefItem.Create;
begin
  inherited;
  FTimeTableX := TTimeTableX.Create;
end;

destructor TRefItem.Destroy;
begin
  FTimeTableX.Free;
  inherited;
end;

procedure TRefItem.DecCross(Lesson: Integer);
begin
  if (Lesson < 0) or (Lesson >= LessCount) then
    Exit;
  if Lesson in Cross then
    Dec(FCrossRef[Lesson]);
  if FCrossRef[Lesson] = 0 then
    inherited Cross := Cross - [Lesson];
end;

procedure TRefItem.IncCross(Lesson: Integer);
begin
  if (Lesson < 0) or (Lesson > LessCount - 1) then
    Exit;
  Inc(FCrossRef[Lesson]);
  inherited Cross := Cross + [Lesson];
end;

//////////////////////////////////////////////////
                   { TKlass }
//////////////////////////////////////////////////
{private}
function TKlass.GetLessAbs(LessonIndex: integer): TSubject;
begin
  result := nil;
  if (LessonIndex < 0) or (LessonIndex > LessCount - 1) then
    Exit;
  result := FLesson[LessonIndex];
end;

function TKlass.GetLesson(WeekDay, LessonNumber: integer): TSubject;
var
  x: integer;
begin
  x := WeekDay * 11 + LessonNumber;
  result := LessAbs[x];
end;

function TKlass.GetWDSanPIN(WD: Integer): Real;
begin
  result := 0;
  if FMaxSanPIN = 0 then
    Exit;
  result := FWDSanPIN[wd] / FMaxSanPIN;
end;

procedure TKlass.FindMaxSanPIN;
var
  i: integer;
begin
  FMaxSanPIN := 0;
  for i := 0 to WDCount - 1 do
    if FMaxSanPIN < FWDSanPIN[i] then
      FMaxSanPIN := FWDSanPIN[i];
end;

procedure TKlass.SetLessAbs(LessonIndex: integer; const Value: TSubject);
var
  wd, sp: Integer;
begin
  if (LessonIndex < 0) or (LessonIndex > LessCount - 1) then
    Exit;
  wd := LessonIndex div 11;
  if FLesson[LessonIndex] <> nil then begin
    sp := FLesson[LessonIndex].SanPIN;
    FWDSanPIN[wd] := FWDSanPIN[wd] - sp;
  end;
  FLesson[LessonIndex] := Value;
  if Value <> nil then begin
    sp := Value.SanPIN;
    FWDSanPIN[wd] := FWDSanPIN[wd] + sp;
  end;
  if FMaxSanPIN < FWDSanPIN[wd] then
    FMaxSanPIN := FWDSanPIN[wd]
  else
    FindMaxSanPIN;
end;

procedure TKlass.SetLesson(WeekDay, LessonNumber: integer;
  const Value: TSubject);
var
  x: integer;
begin
  x := WeekDay * 11 + LessonNumber;
  LessAbs[x] := Value;
end;

{public}
constructor TKlass.Create;
var
  i: integer;
begin
  inherited;
  FTeachers := TTeachers.Create(false);
  FKabinets := TKabinets.Create(false);
  for i := 0 to LessCount - 1 do
    FLesson[i] := nil;
end;

destructor TKlass.Destroy;
begin
  FTeachers.Free;
  FKabinets.Free;
  inherited;
end;

procedure TKlass.Assign(Source: TPersistent);
var
  i: integer;
begin
  if Source is TKlass then
    with TKlass(Source) do begin
      self.FName := Name;
      self.FTeachers.Assign(Teachers);
      self.FKabinets.Assign(Kabinets);
      self.FPlainSubjectX.Assign(SubjectX);
      self.FChecked := Checked;
      self.FLock := Lock;
      self.FCross := Cross;
      for i := 0 to LessCount - 1 do
        self.FLesson[i] := LessAbs[i];
    end
  else
    inherited Assign(Source);
end;

//////////////////////////////////////////////////
                  { TKabinet }
//////////////////////////////////////////////////
{public}
constructor TKabinet.Create;
begin
  inherited;
  FNum := -1;
  FKlasses := TKlasses.Create(false);
  FTeachers := TTeachers.Create(false);
end;

destructor TKabinet.Destroy;
begin
  FKlasses.free;
  FTeachers.free;
  inherited;
end;

function TKabinet.FullName: string;
begin
  result := FName;
  if FShowNum then
    result := result + ' (' + IntToStr(FNum) + ')';
end;

procedure TKabinet.Assign(Source: TPersistent);
var
  i: integer;
begin
  if Source is TKabinet then
    with TKabinet(Source) do begin
      self.FName := Name;
      self.FNum := Num;
      self.FTimeTableX.Assign(TimeTableX);
      self.FKlasses.Assign(Klasses);
      self.FTeachers.Assign(Teachers);
      self.FPlainSubjectX.assign(SubjectX);
      self.FChecked := Checked;
      self.FLock := Lock;
      self.FShowNum := ShowNum;
      for i := 0 to LessCount - 1 do
        self.FCrossRef := FCrossRef;
    end
  else
    inherited;
end;
//////////////////////////////////////////////////
                  { TTeacher }
//////////////////////////////////////////////////
{public}
constructor TTeacher.Create;
begin
  inherited;
  FKabNum := -1;
  FKabinets := TKabinets.Create(false);
  FKlasses := TKlasses.Create(false);
end;

destructor TTeacher.Destroy;
begin
  FKabinets.Free;
  FKlasses.Free;
  inherited;
end;

function TTeacher.ShortName: string;
var
  s: string;
  p: integer;
begin
  s := fName;
  result := s;
  p := pos(' ', s);
  if p = 0 then
    Exit;
  result := Copy(s, 1, p + 1) + '.';
  Delete(s, 1, p + 1);
  p := pos(' ', s);
  if p = 0 then
    Exit;
  result := result + Copy(s, p + 1, 1) + '.';
end;

procedure TTeacher.Assign(Source: TPersistent);
var
  i: integer;
begin
  if Source is TTeacher then
    with TTeacher(Source) do begin
      self.FName := Name;
      self.FKabNum := KabNum;
      self.FKabinets.Assign(Kabinets);
      self.FKlasses.Assign(Klasses);
      self.FTimeTableX.Assign(TimeTableX);
      self.FPlainSubjectX.Assign(SubjectX);
      self.FChecked := Checked;
      self.FLock := Lock;
      for i := 0 to LessCount - 1 do
        self.FCrossRef := FCrossRef;
    end
  else
    inherited Assign(Source);
end;

//////////////////////////////////////////////////
                 { TKlasses }
//////////////////////////////////////////////////
{private}
function TKlasses.GetFullKlassName(x: integer): string;
begin
  result := '';
  if (x < 0) or (x > MaxInd) then
    Exit;
  if FormatString = '' then
    Result := item[x].Name;
  result := format(FormatString, [item[x].Name]);
end;

function TKlasses.GetItem(x: integer): TKlass;
begin
 // Класс
 ////////////////////////////////////////
 // Текст процедуры изменению не подлежит
  result := TKlass(inherited GetItem(x));
end;

procedure TKlasses.SetFormatString(const Value: string);
begin
 // Вид выдачи названия класса на экран
  if pos('%s', Value) = 0 then
    FFormatString := '%s'
  else
    FFormatString := Value;
end;

procedure TKlasses.SetItem(x: integer; const Value: TKlass);
begin
 // Изменить информацию о классе
 ////////////////////////////////////////
 // Текст процедуры изменению не подлежит
  inherited SetItem(x, Value);
end;

{public}
constructor TKlasses.Create;
begin
  inherited;
  FFormatString := '%s';
  sts := TStringList.Create;
end;

destructor TKlasses.Destroy;
begin
  sts.Free;
  inherited;
end;

function TKlasses.AddNewItem: TKlass;
begin
  Result := TKlass.Create;
  Add(Result);
end;

function TKlasses.IndexOf(Name: string): integer;
var
  i: integer;
begin
 // Найти класс по названию
 ////////////////////////////////////////
 // Текст процедуры изменению не подлежит
  result := -1;
  for i := 0 to MaxInd do
    if SameText(Item[i].Name, Name) then begin
      result := i;
      Exit;
    end;
end;

function TKlasses.Lines(short: boolean): TStrings;
var
  i: integer;
begin
  sts.Clear;
  for i := 0 to MaxInd do
    if short then
      sts.AddObject(Item[i].Name, fItem[i])
    else
      sts.AddObject(FullKlassName[i], fItem[i]);
  result := sts;
end;

function TKlasses.AsJSonObject: ISuperObject;
var
  I: integer;
  supArray: TSuperArray;
  supKlass: ISuperObject;
begin
  Result := so;
  Result.S['FormatString']:=FormatString;
  Result.I['Count']:=Count;
  Result.O['Items']:=so('[]');
  supArray:=Result.A['Items'];
  for I := 0 to Count - 1 do begin
    supKlass:=so;
    supKlass.S['Name']:=Item[I].Name;
    supKlass.S['Lock']:=CrossAsString(Item[I].Lock);
    supKlass.B['Checked']:=Item[I].Checked;
    supArray.Add(supKlass);
  end;
end;

procedure TKlasses.Assign(Source: TPersistent);
var
  Klasses: TKlasses;
  i: integer;
begin
  Clear(false);
  if Source is TKlasses then begin
    Klasses := TKlasses(Source);
    for i := 0 to Klasses.Count - 1 do
      Add(Klasses[i]);
  end
  else
    inherited;
end;

//////////////////////////////////////////////////
                  { TKabinets }
//////////////////////////////////////////////////
{private}
function TKabinets.GetItem(x: integer): TKabinet;
begin
  result := TKabinet(inherited GetItem(x));
end;

procedure TKabinets.SetItem(x: integer; const Value: TKabinet);
begin
  inherited SetItem(x, Value);
end;

{public}
constructor TKabinets.Create(AutoIndex: boolean);
begin
  inherited;
  sts := TSubjNames.Create;
  AnyKabinet := TKabinet.Create;
  with AnyKabinet do begin
    Name := stAnyKabinet;
    Num := -1;
    ShowNum := false;
    Checked := false;
    Add(Im);
  end;
end;

destructor TKabinets.Destroy;
begin
  sts.Free;
  AnyKabinet.Free;
  inherited;
end;

function TKabinets.AddNewItem: TKabinet;
begin
  Result := TKabinet.Create;
  Add(Result);
end;

function TKabinets.IndexOf(Num: integer): integer;
var
  i: integer;
begin
 // Найти кабинет по его коридорному номеру
  result := -1;
  for i := 0 to MaxInd do
    if Item[i].Num = Num then begin
      result := i;
      Exit;
    end;
end;

function TKabinets.Lines(Short: boolean): TStrings;
var
  i: integer;
begin
  sts.Clear;
  for i := 0 to MaxInd do
    if short then
      sts.AddObject(Item[i].Name, fItem[i])
    else
      sts.AddObject(Item[i].FullName, fItem[i]);
  result := sts;
end;

function TKabinets.AsJSonObject: ISuperObject;
var
  I: integer;
  supArray: TSuperArray;
  supKabinet: ISuperObject;
begin
  Result := so;
  Result.I['Count']:=Count;
  Result.O['Items']:=so('[]');
  supArray:=Result.A['Items'];
  for I := 0 to Count - 1 do begin
    supKabinet:=so;
    supKabinet.S['Name']:=Item[I].Name;
    supKabinet.I['Num']:=Item[I].Num;
    supKabinet.S['Lock']:=CrossAsString(Item[I].Lock);
    supKabinet.B['Checked']:=Item[I].Checked;
    supKabinet.B['ShowNum']:=Item[I].ShowNum;
    supArray.Add(supKabinet);
  end;
end;

procedure TKabinets.Assign(Source: TPersistent);
var
  kabs: TKabinets;
  i: integer;
begin
  Clear(false);
  if Source is TKabinets then begin
    Kabs := TKabinets(Source);
    for i := 0 to Kabs.Count - 1 do
      Add(Kabs[i]);
  end
  else
    inherited;
end;

procedure TKabinets.Clear(AutoFree: boolean);
var
  ak: TKabinet;
begin
  ak := nil;
  if AutoFree then begin
    ak := TKabinet.Create;
    ak.Assign(AnyKabinet);
  end;
  inherited;
  if AutoFree then
    AnyKabinet := ak;
  Add(AnyKabinet);
end;

//////////////////////////////////////////////////
                  { TTeachers }
//////////////////////////////////////////////////
{private}
function TTeachers.GetItem(x: integer): TTeacher;
begin
 // Преподаватель
  result := TTeacher(inherited Item[x]);
end;

procedure TTeachers.SetItem(x: integer; const Value: TTeacher);
begin
 // Изменить данные преподавателя
  inherited Item[x] := Value;
end;

{public}
constructor TTeachers.Create(AutoIndex: boolean);
begin
  inherited;
  sts := TStringList.Create;
end;

destructor TTeachers.Destroy;
begin
  sts.Free;
  inherited;
end;

function TTeachers.AddNewItem: TTeacher;
begin
  Result := TTeacher.Create;
  Add(Result);
end;

function TTeachers.IndexOf(Name: string): integer;
var
  i: integer;
begin
 // Найти преподавателя по ФИО
  result := -1;
  for i := 0 to MaxInd do
    if SameText(Item[i].name, Name) then begin
      result := i;
      Exit;
    end;
end;

function TTeachers.Lines(Short: boolean): TStrings;
var
  i: integer;
begin
  sts.Clear;
  for i := 0 to MaxInd do
    if short then
      sts.AddObject(Item[i].ShortName, fItem[i])
    else
      sts.AddObject(Item[i].Name, fItem[i]);
  result := sts;
end;

procedure TTeachers.Assign(Source: TPersistent);
var
  Teachers: TTeachers;
  i: integer;
begin
  Clear(false);
  if Source is TTeachers then begin
    Teachers := TTeachers(Source);
    for i := 0 to Teachers.Count - 1 do
      Add(Teachers[i]);
  end
  else
    inherited;
end;

//////////////////////////////////////////////////
                  { TSubject }
//////////////////////////////////////////////////

function TSubject.GetCross: TCross;
var
  i: integer;
begin
 //////////////////////////////////////////////////
 // Текст процедуры изменению не подлежит
  result := [];
  for i := 0 to MaxInd do begin
    if FTeachers[i] <> nil then
      result := result + FTeachers[i].Cross;
    if FKabinets[i] <> nil then
      result := result + FKabinets[i].Cross;
  end;
end;

function TSubject.GetInfo: string;
var
  st, s: string;
  i: integer;
begin
 // Получить информацию о предмете в виде одной строки
  result := '';
  st := 'Пустая клетка';
  if MaxInd > -1 then begin
    st := Klass.Name + ': ' + LongName + '  ||  ';
    st := st + ObrTime(FLessonAtWeek) + '  ||   ' + tuSt[Complexion] + '  ||   ';
    s := '';
    for i := 0 to TeacherCount - 1 do begin
      if s > '' then
        s := s + ', ';
      if FTeachers[i] <> nil then
        s := s + FTeachers[i].Name;
    end;
    st := st + s;
    s := '';
    for i := 0 to TeacherCount - 1 do begin
      if s > '' then
        s := s + ', ';
      if FKabinets[i] <> nil then
        s := s + FKabinets[i].Name;
    end;
    if s > '' then
      s := '  ||   каб.:' + s;
    st := st + s;
  end;
  result := st;
end;

function TSubject.GetKabinets(x: integer): TKabinet;
begin
 // Список предметов в которых проводится урок
  result := nil;
  if (x < 0) or (x > MaxInd) or (x >= Length(FKabinets)) then
    Exit;
  Result := FKabinets[x];
end;

function TSubject.GetKlassTitle(tc: TTableContent): string;
begin
  result := Klass.Name + ': ' + Title[tc];
end;

function TSubject.GetLongKlassName: string;
begin
  result := Klass.Name + ': ' + LongName;
end;

function TSubject.GetLongName: string;
begin
  result := '';
  if fNames = nil then
    Exit;
  if (FNameIndex < 0) or (FNameIndex > fNames.Count - 1) then
    Exit;
  result := fNames.LongName[FNameIndex];
end;

function TSubject.GetSanPIN: integer;
begin
  result := 0;
  if fNames = nil then
    Exit;
  if (FNameIndex < 0) or (FNameIndex > fNames.Count - 1) then
    Exit;
  result := fNames.SanPIN[FNameIndex];
end;

function TSubject.GetShortName: string;
begin
  result := '';
  if fNames = nil then
    Exit;
  if (FNameIndex < 0) or (FNameIndex > fNames.Count - 1) then
    Exit;
  result := fNames.ShortName[FNameIndex];
end;

function TSubject.GetState(Lesson: Integer): TSubjState;
var
  I: integer;
begin
  Result := [];
  if (Lesson < 0) or (Lesson > LessCount - 1) then
    Exit;
  if InTimeTable >= LessonAtWeek then
    Result := [teTime];
  for I := 0 to TeacherCount - 1 do begin
    if (Teachers[I]<>nil) and (Lesson in Teachers[I].Cross) then
      Result := Result + [teTeachers];
    if (Kabinets[I]<>nil) and (Lesson in Kabinets[I].Cross) then
      Result := Result + [teKabinets];
  end;
  if Lesson in Klass.Cross then
    Result := Result + [teKlass];
end;

function TSubject.GetTeacherCount: integer;
begin
 // Каунт
  result := MaxInd + 1;
end;

function TSubject.GetTeachers(x: integer): TTeacher;
begin
 // Список учителей которые проводят урок
  result := nil;
  if (x < 0) or (x > MaxInd) or (x >= Length(FTeachers)) then
    Exit;
  Result := FTeachers[x];
end;

function TSubject.GetTitle(tc: TTableContent): string;
var
  i: integer;
  st: string;
  sts: TStringList;
begin
  Result := '';
  if TeacherCount = 0 then
    Exit;
  st := '';
  case tc of
    tcSubject:
    begin
      sts := TStringList.Create;
      sts.Duplicates := dupIgnore;
      sts.Sorted := true;
      for i := 0 to TeacherCount - 1 do
        if Kabinets[i].ShowNum then
          sts.Add(IntToStr(Kabinets[i].Num));
      if st <> '' then
        st := st + ')';
      st := sts.CommaText;
      sts.Free;
      if st <> '' then
        st := ' (' + st + ')';
      st := ShortName + st;
    end;
    tcTeacher:
      for i := 0 to TeacherCount - 1 do begin
        if i > 0 then
          st := st + #13#10;
        st := st + Teachers[i].ShortName;
      end;
    tcKabinet:
      for i := 0 to TeacherCount - 1 do begin
        if i > 0 then
          st := st + #13#10;
        st := st + Kabinets[i].FullName;
      end;
  end;
  result := st;
end;

function TSubject.GetVisible: boolean;
begin
  result := true;
end;

function TSubject.ObrTime(t: integer): string;
var
  s: integer;
  st: string;
begin
 // Показать время по русски
 //////////////////////////////////////////////////
 // Текст процедуры изменению не подлежит
  s := t;
  if s in [10..19] then
    s := 0;
  case (S + 9) mod 10 + 1 of
    1:
      st := '';
    2..4:
      st := 'а';
    5..10:
      st := 'ов';
  end;
  result := IntToStr(t) + ' час' + st;
end;

procedure TSubject.incCount;
begin
 // Новый кабинет и преподаватель
  inc(MaxInd);
  SetLength(FKabinets, MaxInd + 1);
  SetLength(FTeachers, MaxInd + 1);
end;

procedure TSubject.SetInTimeTable(const Value: Integer);
begin
  FInTimeTable := Value;
end;

procedure TSubject.SeTKabinets(x: integer; const Value: TKabinet);
begin
 // Задать список кабинетов в которых проходит урок
  if (x < 0) or (x > MaxInd) or (x >= Length(FKabinets)) then
    Exit;
  if FKabinets[x] <> nil then
    FKabinets[x].SubjectX.Delete(self);
  FKabinets[x] := Value;
  if ItemIndex = -1 then
    Exit;
  if FKabinets[x] <> nil then
    FKabinets[x].SubjectX.Add(self);
end;

procedure TSubject.SetKlass(const Value: TKlass);
begin
  if FKlass <> nil then
    FKlass.SubjectX.Delete(self);
  FKlass := Value;
  if ItemIndex = -1 then
    Exit;
  if FKlass <> nil then
    FKlass.SubjectX.Add(self);
end;

procedure TSubject.SetNameIndex(const Value: integer);
begin
  FNameIndex := Value;
end;

procedure TSubject.SetTeacherCount(const Value: integer);
begin
 // Задать количество учителей,которые ведут этот предмет
  MaxInd := Value - 1;
end;

procedure TSubject.SetTeachers(x: integer; const Value: TTeacher);
begin
 // Задать список учителей, которые ведут этот предмет
  if (x < 0) or (x > MaxInd) or (x >= Length(FTeachers)) then
    Exit;
  if FTeachers[x] <> nil then
    FTeachers[x].SubjectX.Delete(self);
  FTeachers[x] := Value;
  if ItemIndex = -1 then
    Exit;
  if FTeachers[x] <> nil then
    FTeachers[x].SubjectX.Add(self);
end;

procedure TSubject.SetIndex(const Value: integer);
var
  i: integer;
begin
  inherited;
  Klass := Klass;
  for i := 0 to TeacherCount - 1 do begin
    Teachers[i] := Teachers[i];
    Kabinets[i] := Kabinets[i];
  end;
end;

constructor TSubject.Create(Names: TSubjNames);
begin
 // Создание нового предмета
  inherited Create;
  fNames := Names;
  fTimeTableX := TTimeTableX.Create;
  FInTimeTable := 0;
  Clear;
end;

destructor TSubject.Destroy;
begin
  FTimeTableX.Free;
  inherited;
end;

procedure TSubject.Add(Teacher: TTeacher; Kabinet: TKabinet);
begin
 // Добавление кабинета и преподавателя в список
  incCount;
  FKabinets[MaxInd] := nil;
  FTeachers[MaxInd] := nil;
  Kabinets[MaxInd] := Kabinet;
  Teachers[MaxInd] := Teacher;
end;

procedure TSubject.Assign(Source: TPersistent);
var
  i: integer;
begin
  if Source is TSubject then
    with TSubject(Source) do begin
      self.Clear;
      for i := 0 to TeacherCount - 1 do
        self.Add(Teachers[i], Kabinets[i]);
      self.Klass := Klass;
      self.LessonAtWeek := LessonAtWeek;
      self.Complexion := Complexion;
      self.TimeTableX.Assign(TimeTableX);
      self.NameIndex := NameIndex;
    end
  else
    inherited Assign(Source);
end;

procedure TSubject.Clear;
var
  i, l: integer;
begin
  l := Length(FTeachers);
  for i := 0 to l - 1 do begin
    Teachers[i] := nil;
    Kabinets[i] := nil;
  end;
  SetLength(FTeachers, 0);
  SetLength(FKabinets, 0);
  MaxInd := -1;
  FComplexion := 0;
  FLessonAtWeek := 0;
  Klass := nil;
  FParent := nil;
end;

procedure TSubject.Delete(x: integer);
var
  i: integer;
begin
 // Удаление кабинета и преподавателя из списка
 //////////////////////////////////////////////////
 // Текст процедуры изменению не подлежит
  if (x < 0) or (x > MaxInd) then
    Exit;
  Teachers[x] := nil;
  Kabinets[x] := nil;
  for i := x to MaxInd - 1 do begin
    FTeachers[i] := FTeachers[i + 1];
    FKabinets[i] := FKabinets[i + 1];
  end;
  SetLength(FTeachers, MaxInd);
  SetLength(FKabinets, MaxInd);
  dec(MaxInd);
end;

//////////////////////////////////////////////////
               { TPlainSubjects }
//////////////////////////////////////////////////
{private}
function TPlainSubjects.GetItem(x: integer): TSubject;
begin
  result := TSubject(inherited GetItem(x));
end;

procedure TPlainSubjects.SetItem(x: integer; const Value: TSubject);
var
  ind: integer;
begin
  ind := -1;
  if Value <> nil then
    ind := Value.ItemIndex;
  inherited SetItem(x, Value);
  if Value <> nil then
    Value.ItemIndex := ind;
end;

{public}
constructor TPlainSubjects.Create(AutoIndex: boolean);
begin
  inherited Create(AutoIndex);
end;

procedure TPlainSubjects.Assign(Source: TPersistent);
var
  Subs: TPlainSubjects;
  i: integer;
begin
  Clear(false);
  if Source is TPlainSubjects then begin
    Subs := TPlainSubjects(Source);
    for i := 0 to Subs.Count - 1 do
      Add(Subs[i]);
  end
  else
    inherited;
end;

//////////////////////////////////////////////////
               { TTimeTable }
//////////////////////////////////////////////////
{private}
function TTimeTable.GetForKabinet(KabinetIndex,
  LessonIndex: integer): TSubs;
var
  i, j, n: integer;
  subj: TSubject;
begin
  n := 0;
  ClearSubjs;
  for i := 0 to Klasses.Count - 1 do begin
    Subj := Klasses[i].LessAbs[LessonIndex];
    if Subj = nil then
      Continue;
    for j := 0 to subj.TeacherCount - 1 do
      if subj.Kabinets[j].ItemIndex = KabinetIndex then begin
        SetLength(Subjs, n + 1);
        Subjs[n] := TSubject.Create(FSubjects.SubjectNames);
        Subjs[n].Assign(subj);
        inc(n);
      end;
  end;
  result := Subjs;
end;

function TTimeTable.GetForTeacher(TeacherIndex,
  LessonIndex: integer): TSubs;
var
  i, j, n: integer;
  subj: TSubject;
begin
  n := 0;
  ClearSubjs;
  for i := 0 to Klasses.Count - 1 do begin
    Subj := Klasses[i].LessAbs[LessonIndex];
    if Subj = nil then
      Continue;
    for j := 0 to subj.TeacherCount - 1 do
      if subj.Teachers[j].ItemIndex = TeacherIndex then begin
        SetLength(Subjs, n + 1);
        Subjs[n] := TSubject.Create(FSubjects.SubjectNames);
        Subjs[n].Assign(subj);
        inc(n);
      end;
  end;
  result := Subjs;
end;

function TTimeTable.GetItems(KlassIndex, LessonIndex: integer): TSubject;
var
  Klass: TKlass;
begin
  result := nil;
  if Subjects = nil then
    Exit;
  if (LessonIndex < 0) or (LessonIndex > LessCount - 1) then
    Exit;
  Klass := Subjects.Klasses[KlassIndex];
  if Klass = nil then
    Exit;
  Result := Klass.LessAbs[LessonIndex];
end;

procedure TTimeTable.ClearSubjs;
var
  i: integer;
begin
  for i := 0 to High(Subjs) do
    Subjs[i].Free;
  SetLength(Subjs, 0);
end;

procedure TTimeTable.SetSubjects(const Value: TSubjects);
begin
  FSubjects := Value;
  Klasses := Value.Klasses;
end;

{public}
constructor TTimeTable.Create;
begin
  SetLength(Subjs, 0);
end;

destructor TTimeTable.Destroy;
begin
  ClearSubjs;
  inherited;
end;

procedure TTimeTable.Add(LessonIndex: integer; Subject: TSubject);
var
  i, ki: integer;
begin
 // Выйти при отсутствии списка предметов
  if Subjects = nil then
    Exit;
 // Выйти если нечего добавлять
  if Subject = nil then
    Exit;
  with Subject do begin
  // Выйти если не определён класс добавляемого предмета
    if Klass = nil then
      Exit;
  // Увеличить сумму часов предмета в расписании
    InTimeTable := InTimeTable + 1;
  // Задать текущие координаты предмета в сетке расписания
    Klass.LessAbs[LessonIndex] := Subject;
  // Отметить номер урока как занятый
    Klass.Cross := Klass.Cross + [LessonIndex];
  // Запомнить номер класса
    ki := Klass.ItemIndex;
  // Запомнить номер класса в числе других для данного урока
    TimeTableX.Klasses[LessonIndex].Add(ki);
  // Проделать то же самое данных Учителей и Кабинетов
    for i := 0 to TeacherCount - 1 do begin
      Teachers[i].TimeTableX.Klasses[LessonIndex].Add(ki);
      Teachers[i].IncCross(LessonIndex);
      Kabinets[i].TimeTableX.Klasses[LessonIndex].Add(ki);
      Kabinets[i].IncCross(LessonIndex);
    end;
  end;
end;

procedure TTimeTable.Delete(LessonIndex: integer; Kabinet: TKabinet);
var
  i: integer;
begin
  for i := 0 to Kabinet.TimeTableX[LessonIndex].Count - 1 do
    Delete(LessonIndex, Klasses[Kabinet.TimeTableX[LessonIndex][i]]);
end;

procedure TTimeTable.Delete(LessonIndex: integer; Klass: TKlass);
begin
  Delete(LessonIndex, Klass.LessAbs[LessonIndex]);
end;

procedure TTimeTable.Delete(LessonIndex: integer; Subject: TSubject);
var
  i, ki: integer;
begin
  if Subject = nil then
    Exit;
  with Subject do begin
    if Klass = nil then
      Exit;
    ki := Klass.ItemIndex;
    InTimeTable := InTimeTable - 1;
    for i := 0 to TeacherCount - 1 do begin
      Teachers[i].TimeTableX.Klasses[LessonIndex].Delete(ki);
      Teachers[i].DecCross(LessonIndex);
      Kabinets[i].TimeTableX.Klasses[LessonIndex].Delete(ki);
      Kabinets[i].DecCross(LessonIndex);
    end;
    Klass.LessAbs[LessonIndex] := nil;
  end;
end;

procedure TTimeTable.Delete(LessonIndex: integer; Teacher: TTeacher);
var
  i: integer;
begin
  for i := 0 to Teacher.TimeTableX[LessonIndex].Count - 1 do
    Delete(LessonIndex, Klasses[Teacher.TimeTableX[LessonIndex][i]]);
end;

//////////////////////////////////////////////////
                { TSubjects }
//////////////////////////////////////////////////
{private}
function TSubjects.DaNet(us: boolean): string;
begin
  Result := IfThen(us, 'Да', 'Нет');
end;

function TSubjects.DaNetStr(s: string): boolean;
begin
  result := AnsiUpperCase(s) = 'ДА';
end;

function TSubjects.ExTrim(s: string): String;
var
  p: integer;
begin
  p := Pos(#9#9#2, s);
  if p > 1 then
    s := Copy(s, 1, p - 1);
  Result := s;
end;

function TSubjects.GetSubject(x: integer): TSubject;
begin
 // Выдать предмет из списка
 //////////////////////////////////////////////////
 // Текст процедуры изменению не подлежит
  result := GetItem(x) as TSubject;
end;

function TSubjects.LoadKabinets(sr: TStream): boolean;
var
  ms: TMemoryStream;
  i, n, p: integer;
  xr: TCross;
  b: Boolean;
  Key: string;
  Kabinet: TKabinet;
begin
  ms := TMemoryStream.create;
  p := sr.Position;
  Load(sr, Key, TStream(ms));
  result := Key = 'Кабинеты';
  if not Result then begin
    sr.Position := p;
    ms.Free;
    Exit;
  end;
  ms.Read(n, 4);
  for i := 1 to n do begin
    Kabinet := TKabinet.Create;
    with Kabinet do begin
      name := ReadString(ms);
      ms.Read(n, 4);
      Num := n;
      ms.Read(xr, SizeOf(xr));
      Lock := xr;
      ms.Read(b, 1);
      Checked := b;
      ms.Read(b, 1);
      ShowNum := b;
    end;
    Kabinets.Add(Kabinet);
  end;
  ms.Free;
end;

function TSubjects.LoadKlasses(sr: TStream): boolean;
var
  ms: TMemoryStream;
  i, p, n: integer;
  xr: TCross;
  b: Boolean;
  Klass: TKlass;
  Key: string;
begin
  ms := TMemoryStream.create;
  p := sr.Position;
  Load(sr, Key, TStream(ms));
  result := Key = 'Классы';
  if not Result then begin
    sr.Position := p;
    ms.Free;
    Exit;
  end;
  Klasses.FormatString := ReadString(ms);
  ms.Read(n, 4);
  for i := 1 to n do begin
    Klass := TKlass.Create;
    with Klass do begin
      Name := ReadString(ms);
      ms.Read(xr, SizeOf(xr));
      Lock := xr;
      ms.Read(b, 1);
      Checked := b;
    end;
    Klasses.Add(Klass);
  end;
  ms.Free;
end;

function TSubjects.LoadSubjectNames(sr: TStream): boolean;
var
  ms: TMemoryStream;
  Key: string;
  p: integer;
begin
  ms := tMemoryStream.Create;
  Load(sr, Key, TStream(ms));
  p := sr.Position;
  result := Key = 'Названия предметов';
  if not Result then begin
    sr.Position := p;
    ms.Free;
    Exit;
  end;
  FSubjectNames.LoadFromStream(ms);
  ms.Free;
end;

function TSubjects.LoadSubjects(sr: TStream): boolean;
var
  i, j, n, bs, xs: integer;
 //xset:integer;
  ms: TMemoryStream;
  Key: string;
  p: integer;
  Subject: TSubject;
  teacher: TTeacher;
  kabinet: TKabinet;
begin
  bs := SizeOf(boolean);
  xs := SizeOf(TCross);
  ms := TMemoryStream.Create;
  p := sr.Position;
  Load(sr, Key, TStream(ms));
  result := Key = 'Предметы';
  if not Result then begin
    sr.Position := p;
    ms.Free;
    Exit;
  end;
  with ms do begin
    Read(FViewMode, SizeOf(TViewMode));
    read(FColumnMode, SizeOf(TColumnMode));
    read(FTableContent, SizeOf(TTableContent));
    Read(FWeekDays, xs);
    Read(FLessons, xs);
    Read(FFullView, bs);
    Read(n, 4);
    for i := 1 to n do begin
      Subject := TSubject.Create(FSubjectNames);
      with Subject do begin
        Read(n, 4);
        FKlass := Klasses[n];
        Read(n, 2);
        for j := 1 to n do begin
          Read(n, 4);
          teacher := self.Teachers[n];
          Read(n, 4);
          kabinet := self.Kabinets[n];
          if (teacher=nil) or (kabinet=nil) then Continue;
          Add(teacher, kabinet);
        end;
        Read(FComplexion, 4);
        Read(FLessonAtWeek, 4);
        Read(FNameIndex, 4);
        Read(FMultiLine, bs);
        Read(FParent, 4);
      end;
      Add(Subject);
    end;
    Free;
  end;
end;

function TSubjects.LoadTeachers(sr: TStream): boolean;
var
  ms: TMemoryStream;
  i, p, n: integer;
  xr: TCross;
  b: Boolean;
  Teacher: TTeacher;
  Key: string;
begin
  ms := TMemoryStream.create;
  p := sr.Position;
  Load(sr, Key, TStream(ms));
  result := Key = 'Учителя';
  if not Result then begin
    sr.Position := p;
    ms.Free;
    Exit;
  end;
  ms.Read(n, 4);
  for i := 1 to n do begin
    Teacher := TTeacher.Create;
    with Teacher do begin
      Name := ReadString(ms);
      ms.Read(n, 4);
      KabNum := n;
      ms.Read(xr, SizeOf(xr));
      Lock := xr;
      ms.Read(b, 1);
      Checked := b;
    end;
    Teachers.Add(Teacher);
  end;
  ms.Free;
end;

function TSubjects.LoadTimeTable(sr: TStream): boolean;
begin
  result := 1 = 1;
end;

function TSubjects.LoadTxtKabinets(var tx: TextFile): boolean;
var
  i, n: integer;
begin
  Readln(tx);//,'*** Информация о кабинетах ***');
  with Kabinets do begin
    Clear(true);
    n := ReadIntEx(tx); // Количество кабинетов
    for i := 0 to n - 1 do
      with AddNewItem do begin
        Name := ReadEx(tx); // Имя кабинета
        Num := ReadIntEx(tx); // Номер кабинета
        Lock := StringAsCross(ReadEx(tx));
        Checked := ReadDaNet(tx); // Показывать кабинет в сетке
        ShowNum := ReadDaNet(tx); // Показывать номер кабинета
        Readln(tx); // Пустая разделительная строка
      end;
  end;
  Readln(tx); // Конец Блока
  Readln(tx); // Пустая разделительная строка
  Result := true;
end;

function TSubjects.LoadTxtKlasses(var tx: TextFile): boolean;
var
  s: string;
  i, n: integer;
begin
  Readln(tx, s);
  with Klasses do begin
    Clear;
    FormatString := ReadEx(tx);
    n := ReadIntEx(tx);
    for i := 0 to n - 1 do
      with AddNewItem do begin
        Name := ReadEx(tx);
        Lock := StringAsCross(ReadEx(tx));
        Checked := ReadDaNet(tx);
        Readln(tx);
      end;
  end;
  Readln(tx);
  Readln(tx);
  Result := true;
end;

function TSubjects.LoadTxtSubjectNames(var tx: TextFile): boolean;
var
  i, n: integer;
begin
  Readln(tx);
  n := ReadIntEx(tx);
  FSubjectNames.Clear;
  for i := 0 to n - 1 do
    FSubjectNames.Add(ReadEx(tx));
  Readln(tx);
  Readln(tx);
  Result := true;
end;

function TSubjects.LoadTxtSubjects(var tx: TextFile): boolean;
var
  i, j, n: integer;
  tch: TTeacher;
  kab: TKabinet;
begin
  Readln(tx);
  FViewMode := TViewMode(Str2Int(ReadEx(tx)));
  FColumnMode := TColumnMode(Str2Int(ReadEx(tx)));
  FTableContent := TTableContent(Str2Int(ReadEx(tx)));
  FWeekDays := StringAsWeekDays(ReadEx(tx));
  FLessons := StringAsCross(ReadEx(tx));
  FFullView := DaNetStr(ReadEx(tx));
  n := Str2Int(ReadEx(tx));
  for i := 0 to n - 1 do
    with Add do begin
      n := Str2Int(ReadEx(tx));
      if n = -1 then
        Klass := nil
      else
        Klass := Klasses[n];
      n := ReadIntEx(tx);
      for j := 0 to n - 1 do begin
        n := ReadIntEx(tx);
        if n = -1 then
          tch := nil
        else
          tch := self.Teachers[n];
        n := ReadIntEx(tx);
        if n = -1 then
          kab := nil
        else
          kab := self.Kabinets[n];
        Add(tch, kab);
      end;
      FComplexion := ReadIntEx(tx);
      FLessonAtWeek := ReadIntEx(tx);
      FNameIndex := ReadIntEx(tx);
      FMultiLine := ReadDaNet(tx);
      Readln(tx); // Порядковый номер родителя
      Readln(tx); // Пустая разделительная строка
    end;
  Readln(tx); // Конец Блока
  Readln(tx); // Пустая разделительная строка
  Result := true;
end;

function TSubjects.LoadTxtTeachers(var tx: TextFile): boolean;
var
  i, n: integer;
begin
  Readln(tx); //,'*** Информация о учителях ***'
  with Teachers do begin
    Clear;
    n := ReadIntEx(tx); //Количесво учителей
    for i := 0 to n - 1 do
      with AddNewItem do begin
        Name := ReadEx(tx); // ФИО учителя
        KabNum := ReadIntEx(tx);  // Номер основного кабинета
        Lock := StringAsCross(ReadEx(tx)); // Уроки заблокированные для учителя'
        Checked := ReadDaNet(tx);
        Readln(tx); // Пустая разделительная строка
      end;
  end;
  Readln(tx); // Конец Блока
  Readln(tx); // Пустая разделительная строка
  Result := true;
end;

function TSubjects.LoadTxtTimeTable(var tx: TextFile): boolean;
begin
  Result := true;
end;

function TSubjects.ReadDaNet(var tx: TextFile): boolean;
begin
  Result := DaNetStr(ReadEx(tx));
end;

function TSubjects.ReadEx(var tx: TextFile): String;
var
  s: string;
begin
  Readln(tx, s);
  Result := ExTrim(s);
end;

function TSubjects.ReadIntEx(var tx: TextFile): Integer;
var
  s: string;
begin
  s := ReadEx(tx);
  Result := Str2Int(s);
end;

procedure TSubjects.SaveKabinets(sr: TStream);
var
  ms: TMemoryStream;
  i, n: integer;
  xr: TCross;
  b: Boolean;
begin
  ms := TMemoryStream.create;
  with Kabinets do begin
    i := Count - 1;
    ms.Write(i, 4);
    for i := 1 to Count - 1 do
      with Item[i] do begin
        WriteString(ms, Name);
        n := Num;
        ms.Write(n, 4);
        xr := Lock;
        ms.Write(xr, SizeOf(xr));
        b := Checked;
        ms.Write(b, 1);
        b := ShowNum;
        ms.Write(b, 1);
      end;
  end;
  Save(sr, 'Кабинеты', ms);
  ms.Free;
end;

procedure TSubjects.SaveKlasses(sr: TStream);
var
  ms: TMemoryStream;
  i: integer;
  xr: TCross;
  b: Boolean;
begin
  ms := TMemoryStream.create;
  with Klasses do begin
    WriteString(ms, FormatString);
    i := Count;
    ms.Write(i, 4);
    for i := 0 to Count - 1 do begin
      WriteString(ms, Item[i].Name);
      xr := Item[i].Lock;
      ms.Write(xr, SizeOf(xr));
      b := Item[i].Checked;
      ms.Write(b, 1);
    end;
  end;
  Save(sr, 'Классы', ms);
  ms.Free;
end;

procedure TSubjects.SaveSubjectNames(sr: TStream);
var
  ms: TMemoryStream;
begin
  ms := tMemoryStream.Create;
  FSubjectNames.SaveToStream(ms);
  Save(sr, 'Названия предметов', ms);
  ms.Free;
end;

procedure TSubjects.SaveSubjects(sr: TStream);
var
  i, j, n, bs, xs: integer;
  ms: TMemoryStream;
begin
  bs := SizeOf(boolean);
  xs := SizeOf(TCross);
  ms := TMemoryStream.Create;
  with ms do begin
    Write(FViewMode, SizeOf(TViewMode));
    Write(FColumnMode, SizeOf(TColumnMode));
    Write(FTableContent, SizeOf(TTableContent));
    Write(FWeekDays, xs);
    Write(FLessons, xs);
    Write(FFullView, bs);
    n := Count;
    Write(n, 4);
    for i := 0 to MaxInd do
      with Item[i] do begin
        if Klass = nil then
          n := -1
        else
          n := Klass.ItemIndex;
        Write(n, 4);
        n := TeacherCount;
        Write(n, 2);
        for j := 0 to n - 1 do begin
          if Teachers[j] = nil then
            n := -1
          else
            n := Teachers[j].ItemIndex;
          Write(n, 4);
          if Kabinets[j] = nil then
            n := -1
          else
            n := Kabinets[j].ItemIndex;
          Write(n, 4);
        end;
        Write(FComplexion, 4);
        Write(FLessonAtWeek, 4);
        Write(FNameIndex, 4);
        Write(FMultiLine, bs);
        Write(FParent, 4);
      end;
    Save(sr, 'Предметы', ms);
    Free;
  end;
end;

procedure TSubjects.SaveTeachers(sr: TStream);
var
  ms: TMemoryStream;
  i, n: integer;
  xr: TCross;
  b: Boolean;
begin
  ms := TMemoryStream.create;
  with Teachers do begin
    i := Count;
    ms.Write(i, 4);
    for i := 0 to Count - 1 do
      with Item[i] do begin
        WriteString(ms, Name);
        n := KabNum;
        ms.Write(n, 4);
        xr := Lock;
        ms.Write(xr, SizeOf(xr));
        b := Checked;
        ms.Write(b, 1);
      end;
  end;
  Save(sr, 'Учителя', ms);
  ms.Free;
end;

procedure TSubjects.SaveTimeTable(sr: TStream);
begin

end;

procedure TSubjects.SaveTxtKabinets(var tx: TextFile);
begin
  Writeln(tx, Kabinets.AsJSonObject.AsJSon(true));
  Writeln(tx); // Пустая разделительная строка
end;

procedure TSubjects.SaveTxtKlasses(var tx: TextFile);
begin
  Writeln(tx, Klasses.AsJSonObject.AsJSon(true));
  Writeln(tx); // Пустая разделительная строка
end;

procedure TSubjects.SaveTxtSubjectNames(var tx: TextFile);
begin
  Write(tx, FSubjectNames.AsJSonObject.AsJSon(true));
  Writeln(tx); // Пустая разделительная строка
end;

procedure TSubjects.SaveTxtSubjects(var tx: TextFile);
begin
  Writeln(tx, AsJSonObject.AsJSon(true));
  Writeln(tx); // Пустая разделительная строка
end;

procedure TSubjects.SaveTxtTeachers(var tx: TextFile);
var
  I: integer;
  sup: ISuperObject;
  supTeachers: TSuperArray;
  supTeacher: ISuperObject;
begin
  with Teachers do begin
    sup := so;
    sup.I['Count']:=Count;
    sup.O['Items']:=so('[]');
    supTeachers:=sup.A['Items'];
    for I := 0 to Count - 1 do
      with Item[I] do begin
        supTeacher := so;
        supTeacher.S['Name']:=Name;
        supTeacher.I['KabNum']:=KabNum;
        supTeacher.S['Lock']:=CrossAsString(Lock);
        supTeacher.B['Checked']:=Checked;
        supTeachers.Add(supTeacher);
      end;
  end;
  Writeln(tx, sup.AsJSon(true)); // Конец Блока
  Writeln(tx); // Пустая разделительная строка
end;

procedure TSubjects.SaveTxtTimeTable(var tx: TextFile);
begin

end;

procedure TSubjects.SetSubject(x: integer; const Value: TSubject);
begin
 // Изменение предмета
 // Убрать пересечения старого предмета и поставить пересечения нового предмета
 //////////////////////////////////////////////////
 // Текст процедуры изменению не подлежит
  SetItem(x, Value);
end;

{public}
constructor TSubjects.Create;
begin
 // Создание пустого списка предметов
 //////////////////////////////////////////////////
 // Текст процедуры изменению не подлежит
  inherited Create(true);
  FFullView := true;
 // Выделение памяти
  FSubjectNames := TSubjNames.Create;
  FTimeTable := TTimeTable.Create;
  FKabinets := TKabinets.Create(true);
  FKlasses := TKlasses.Create(true);
  FTeachers := TTeachers.Create(true);
 //
  FKlasses.FormatString := '%s класс';
  FTimeTable.Subjects := self;
  FViewMode := vmSubjects;
  FColumnMode := cmKlass;
  FTableContent := tcSubject;
  FWeekDays := [wdMonday..wdSaturday];
  FLessons := [1..8];
end;

destructor TSubjects.Destroy;
begin
 //////////////////////////////////////////////////
 // Текст процедуры изменению не подлежит
  Clear;
  FTimeTable.Free;
  FKlasses.Free;
  FTeachers.Free;
  FKabinets.Free;
  FSubjectNames.Free;
  inherited;
end;

function TSubjects.Add(Subject: TSubject): integer;
begin
 // Добавление предмета в список с проверкой эдентичности
 // Установить пересечения по классу, преподавателям и кабинетам
 //////////////////////////////////////////////////
 // Текст процедуры изменению не подлежит
  result := Subject.ItemIndex;
  if result <> -1 then
    if Item[result] = Subject then
      Exit;
  result := inherited Add(Subject);
end;

function TSubjects.Add: TSubject;
begin
 // Добавление места под предмет.
 // Все проверки и учёт пересечений делаются потом.
 //////////////////////////////////////////////////
 // Текст процедуры изменению не подлежит
  result := TSubject.Create(fSubjectNames);
  Add(result);
end;

function TSubjects.AsJSonObject: ISuperObject;
var
  I, J, N: integer;
  supSubjects: TSuperArray;
  supTeachKabs: TSuperArray;
  supSubject: ISuperObject;
  supTeachKab: ISuperObject;
begin
  Result := so;
  Result.S['ViewModeComment']:='0,1,2,3 = Предметы, заголовки, дни недели, номера уроков';
  Result.S['ColumnModeComment']:='0,1,2 = Классы, Учителя, Кабинеты';
  Result.S['TableContentComment']:='0,1,2 = Предметы, Учителя, Кабинеты';
  Result.S['ComplexionComment']:='0,1,2 = Обычный, Спаренный, Половинный';
  Result.I['ViewMode']:=ord(FViewMode);
  Result.I['ColumnMode']:=ord(FColumnMode);
  Result.I['TableContent']:=ord(FTableContent);
  Result.S['WeekDays']:=WeekDaysAsString(FWeekDays);
  Result.S['Lessons']:=CrossAsString(FLessons);
  Result.B['FullView']:=FFullView;
  Result.I['Count']:=Count;
  Result.O['Items']:=so('[]');
  supSubjects := Result.A['Items'];
  for I := 0 to MaxInd do
    with Item[I] do begin
      supSubject := so;
      if Klass = nil then
        N := -1
      else
        N := Klass.ItemIndex;
      supSubject.I['KlassIndex']:=N;
      supSubject.I['TeacherCount']:=TeacherCount;
      supSubject.O['Items']:=so('[]');
      supTeachKabs:=supSubject.A['Items'];
      for J := 0 to TeacherCount - 1 do begin
        supTeachKab := so;
        if Teachers[J] = nil then
          N := -1
        else
          N := Teachers[J].ItemIndex;
        supTeachKab.I['TeacherIndex']:=N;

        if Kabinets[J] = nil then
          N := -1
        else
          N := Kabinets[J].ItemIndex;
        supTeachKab.I['KabinetIndex']:=N;
        supTeachKabs.Add(supTeachKab);
      end;
      supSubject.I['Complexion']:=FComplexion;
      supSubject.I['LessonAtWeek']:=FLessonAtWeek;
      supSubject.I['NameIndex']:=FNameIndex;
      supSubject.B['MultiLine']:=FMultiLine;
      supSubject.I['OriginalSubjectIndex']:=0;
      supSubjects.Add(supSubject);
    end;
end;

function TSubjects.IsCross(subj1, subj2: TSubject): boolean;
var
  i, j: integer;
begin
  result := false;
  if (subj1 = nil) or (subj2 = nil) then
    Exit;
  for i := 0 to subj1.TeacherCount - 1 do
    for j := 0 to subj2.TeacherCount - 1 do begin
      result := result or (subj1.Teachers[i] = subj2.Teachers[j]) or (subj1.Kabinets[i] = subj2.Kabinets[j]);
      if result then
        Exit;
    end;
end;

procedure TSubjects.Clear;
begin
  inherited Clear(true);
  FKlasses.Clear(true);
  FKabinets.Clear(true);
  FTeachers.Clear(true);
  FSubjectNames.Clear;
end;

procedure TSubjects.Delete(Subject: TSubject);
var
  i: integer;
begin
  Subject.Klass := nil;
  for i := 0 to Subject.TeacherCount - 1 do begin
    Subject.Teachers[i] := nil;
    Subject.Kabinets[i] := nil;
  end;
  inherited Delete(Subject, true);
end;

procedure TSubjects.Delete(x: Integer);
begin
 // Удалить все упоминания о предмете в других данных.
 // Удалить предмет из списка.
 //////////////////////////////////////////////////
 // Текст процедуры изменению не подлежит
  if (x < 0) or (x > MaxInd) then
    Exit;
  Delete(item[x]);
end;

procedure TSubjects.Load(srBig: TStream; var Key: string;
  var srSmall: TStream);
var
  l: integer;
begin
  srSmall.Size := 0;
  Key := ReadString(srBig);
  srBig.Read(l, 4);
  if l = 0 then
    Exit;
  srSmall.CopyFrom(srBig, l);
  srSmall.Position := 0;
end;

procedure TSubjects.LoadFromFile(fn: string);
var
  fs: TFileStream;
begin
 // Загрузка данных из файла. В том числе преподаватели, кабинеты и классы
 // TODO 3: LoadFromFile (необходимо прочитать Current-данные)
  if not FileExists(fn) then begin
    ShowMessage('Файл не существует');
    Exit;
  end;
  Clear;
  fs := TFileStream.Create(fn, fmOpenRead);
  repeat
    if not LoadKlasses(fs) then begin
      ShowMessage('Ошибка загрузки классов');
      break;
    end;
    if not LoadKabinets(fs) then begin
      ShowMessage('Ошибка загрузки кабинетов');
      break;
    end;
    if not LoadTeachers(fs) then begin
      ShowMessage('Ошибка загрузки учителей');
      break;
    end;
    if not LoadSubjectNames(fs) then begin
      ShowMessage('Ошибка загрузки названий предметов');
      break;
    end;
    if not LoadSubjects(fs) then begin
      ShowMessage('Ошибка загрузки предметов');
      break;
    end;
    if not LoadTimeTable(fs) then begin
      ShowMessage('Ошибка загрузки расписания');
      break;
    end;
  until true;
  fs.Free;
end;

procedure TSubjects.LoadFromTextFile(fn: string);
var
  tx: TextFile;
begin
 // Чтение абсолютно всех данных из файла
  AssignFile(tx, fn);
  Reset(tx);
  LoadTxtKlasses(tx);
  LoadTxTKabinets(tx);
  LoadTxtTeachers(tx);
  LoadTxtSubjectNames(tx);
  LoadTxtSubjects(tx);
  LoadTxtTimeTable(tx);
  CloseFile(tx);
end;

procedure TSubjects.Save(srBig: TStream; Key: string; srSmall: TStream);
var
  l: integer;
begin
  WriteString(srBig, Key);
  srSmall.Position := 0;
  l := srSmall.Size;
  srBig.Write(l, 4);
  srBig.CopyFrom(srSmall, l);
end;

procedure TSubjects.SaveToFile(fn: string);
var
  fs: TFileStream;
begin
 // Запись абсолютно всех данных в файл
 // TODO 3: SaveToFile (необходимо сохранить Current-данные)
  fs := TFileStream.Create(fn, fmCreate);
  SaveKlasses(fs);
  SaveKabinets(fs);
  SaveTeachers(fs);
  SaveSubjectNames(fs);
  SaveSubjects(fs);
  SaveTimeTable(fs);
  fs.Free;
end;

procedure TSubjects.SaveToTextFile(fn: string);
var
  tx: TextFile;
begin
 // Запись абсолютно всех данных в файл
 // TODO 3: SaveToFile (необходимо сохранить Current-данные)
  AssignFile(tx, fn);
  Rewrite(tx);
  SaveTxtKlasses(tx);
  SaveTxtKabinets(tx);
  SaveTxtTeachers(tx);
  SaveTxtSubjectNames(tx);
  SaveTxtSubjects(tx);
  SaveTxtTimeTable(tx);
  CloseFile(tx);
end;
////////////////////// Вспомогательные функции //////////////////////
function ToName(s: string): TName;
begin
  with TStringList.Create do begin
    CommaText := s;
    result.Long := strings[0];
    result.Short := strings[1];
    result.Pin := StrToInt(strings[2]);
    Free;
  end;
end;

function FromName(Long, Short: string; Pin: integer): string;
begin
  with TStringList.Create do begin
    Add(Long);
    Add(Short);
    Add(IntToStr(Pin));
    result := CommaText;
    Free;
  end;
end;

function TSimpleItem.GetAvailableSubjects(LessonIndex: integer): TSubjects;
begin

end;

function TSimpleItem.GetSubjsInTT(LessonIndex: Integer): TPlainSubjects;
begin
  Result := nil;
  if OutSide(LessonIndex, LessCount) then
    Exit;
  Result := FSubjInTT[LessonIndex];
end;

procedure TSimpleItem.SetSubjsInTT(LessonIndex: Integer;
  const Value: TPlainSubjects);
begin
  if OutSide(LessonIndex, LessCount) then
    Exit;
  FSubjInTT[LessonIndex] := Value;
end;

end.

