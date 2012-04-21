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
    function GetAsJsonObject:ISuperObject;
    procedure SetLongName(Index: integer; const Value: string);
    procedure SetSanPIN(Index: integer; const Value: Integer);
    procedure SetShortName(Index: integer; const Value: string);
    procedure SetAsJsonObject(const Value: ISuperObject);
  protected
    procedure Put(Index: Integer; const S: string); override;
    property MaxInd: integer read GetMaxInd;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(Long, Short: string; PIN: integer): integer; reintroduce; overload;
    procedure LoadFromStream(Stream: TStream); override;
    procedure Clear; override;
    property AsJsonObject:ISuperObject read GetAsJsonObject write SetAsJsonObject;
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
    function GetAsJsonObject:ISuperObject;
    procedure SetFormatString(const Value: string);
    procedure SetItem(x: integer; const Value: TKlass);
    procedure SetAsJsonObject(const Value: ISuperObject);
  public
    constructor Create(AutoIndex: boolean);
    destructor Destroy; override;
    function AddNewItem: TKlass;
    function IndexOf(Name: string): integer;
    function Lines(short: boolean): TStrings;
    procedure Assign(Source: TPersistent); override;
    property AsJsonObject:ISuperObject read GetAsJsonObject write SetAsJsonObject;
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
    function GetAsJsonObject:ISuperObject;
    procedure SetItem(x: integer; const Value: TKabinet);
    procedure SetAsJsonObject(const Value: ISuperObject);
  public
    constructor Create(AutoIndex: boolean);
    destructor Destroy; override;
    function AddNewItem: TKabinet;
    function IndexOf(Num: integer): integer;
    function Lines(Short: boolean): TStrings;
    procedure Assign(Source: TPersistent); override;
    procedure Clear(AutoFree: boolean);
    property AsJsonObject:ISuperObject read GetAsJsonObject write SetAsJsonObject;
    property Item[x: integer]: TKabinet read GetItem write SetItem; default;
  end;
 ////////////////////// x //////////////////////
 // TTeachers - коллекция учитилей
  TTeachers = class (TColl)
  private
    sts: TStringList;
    function GetItem(x: integer): TTeacher;
    function GetAsJsonObject: ISuperObject;
    procedure SetItem(x: integer; const Value: TTeacher);
    procedure SetAsJsonObject(const Value: ISuperObject);
  public
    constructor Create(AutoIndex: boolean);
    destructor Destroy; override;
    function AddNewItem: TTeacher;
    function IndexOf(Name: string): integer;
    function Lines(Short: boolean): TStrings;
    procedure Assign(Source: TPersistent); override;
    property AsJsonObject: ISuperObject read GetAsJsonObject write SetAsJsonObject;
    property Item[x: integer]: TTeacher read GetItem write SetItem; default;
  end;
 ////////////////////// x //////////////////////
  TLessons = set of 0..10;
 ////////////////////// x //////////////////////
 /// TSubject - информация об одном предмете
 /// ProC SetID(const Value: integer); - Задать индекс предмета
 /// prop InTimeTable - количество упоминаний предмета в расписании
 /// ProC Add(Teacher: TTeacher; Kabinet: TKabinet); - добавить преподавателя и
 /// * кабинет в котором проходит урок
 /// ProC Assign(Source: TPersistent); - перенос данных из другого предмета
 /// ProC Clear; - очистка списка преподавателей и кабинетов
 /// ProC Delete(x:integer); - удалить предмеи и кабинет
 /// prop Complexion - Вид урока (Обычный, спаренный, половинный)
 /// prop Cross - Пересекающиеся уроки
 /// prop Info - Информация о предмете
 /// prop Kabinets - список кабинетов
 /// prop Klass - класс в котором проходит предмет
 /// prop KlassTitle - Класс+(Предмет/Кабинет/Учитель)
 /// prop LessonAtWeek - Максимальное число часов в неделю
 /// prop LongKlassName - Полное название класса
 /// prop LongName - Полное название предмета
 /// prop MultiLine - Многострочная информация о предмете (True/False)
 /// prop NameIndex - Порядковый номер названия предмета
 /// prop SanPIN - Балл предмета по СанПИН
 /// prop ShortName - Короткое имя предмета
 /// prop State - Состояние предмета (вид пересечения)
 /// prop TeacherCount - Количество учителей ведущих этот предмет
 /// prop Teachers - Список учителей ведущих этот предмет
 /// prop TimeTableX -
 /// prop Title
 /// prop Visible
 ///
 /// prop LessonIndex - Номер занятия в расписании.
 /// prop Parent - Индекс предмета от которого произошёл текущий
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
    FLessonIndex: Integer;
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
    procedure SetKabinets(x: integer; const Value: TKabinet);
    procedure SetKlass(const Value: TKlass);
    procedure SetNameIndex(const Value: integer);
    procedure SetTeacherCount(const Value: integer);
    procedure SetTeachers(x: integer; const Value: TTeacher);
    procedure SetLessonIndex(const Value: Integer);
    procedure SetParent(const Value: TSubject);
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
    property Kabinets[x: integer]: TKabinet read GeTKabinets write SetKabinets;
    property Klass: TKlass read FKlass write SetKlass;
    property KlassTitle[tc: TTableContent]: string read GetKlassTitle;
    property LessonAtWeek: Integer read FLessonAtWeek write FLessonAtWeek;
    property LessonIndex:Integer read FLessonIndex write SetLessonIndex;
    property LongKlassName: string read GetLongKlassName;
    property LongName: string read GetLongName;
    property MultiLine: boolean read FMultiLine write FMultiLine;
    property NameIndex: integer read FNameIndex write SetNameIndex;
    property Parent:TSubject read FParent write SetParent;
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
 /// TTimeTable - Содержимое сетки расписания
 ///   proc Add(LessonIndex, Subject) - Добавление предмета в сетку расписания
 ///   proc Delete(LessonIndex, Kabinet) - Удаление занятий из кабинета
 ///   proc Delete(LessonIndex, Klass) - Удаление занятий из класса
 ///   proc Delete(LessonIndex, Subject) - Удаление занятия по номеру урока
 ///   proc Delete(LessonIndex, Teacher) - Удаление занятий из учителя
 ///   prop ForKabinet[KabinetIndex, LessonIndex]: TSubs  (R); - Занятия в кабинете
 ///   prop ForKlasses[KlassIndex, LessonIndex]: TSubject (R); - Занятия в классе
 ///   prop ForTeacher[TeacherIndex, LessonIndex]: TSubs  (R); - Занятия учителя
 ///   prop Subjects: TSubjects (RW); - Информация о предметах

  TTimeTable = class (TPersistent)
  private
    FSubjects: TSubjects;
    Subjs: TSubs;
    FLessons: TPlainSubjects;
    function GetForKabinet(KabinetIndex, LessonIndex: integer): TSubs;
    function GetForTeacher(TeacherIndex, LessonIndex: integer): TSubs;
    function GetForKlasses(KlassIndex, LessonIndex: integer): TSubject;
    procedure ClearSubjs;
    procedure SetSubjects(const Value: TSubjects);
    function GetKlasses: TKlasses;
  protected
    procedure Add2(LessonIndex: integer; Subject: TSubject);
    procedure Delete2(LessonIndex: integer; Kabinet: TKabinet); overload;
    procedure Delete2(LessonIndex: integer; Klass: TKlass); overload;
    procedure Delete2(LessonIndex: integer; Subject: TSubject); overload;
    procedure Delete2(LessonIndex: integer; Teacher: TTeacher); overload;
    property Klasses:TKlasses read GetKlasses;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(LessonIndex: integer; Subject: TSubject);
    procedure Delete(LessonIndex: integer; Kabinet: TKabinet); overload;
    procedure Delete(LessonIndex: integer; Klass: TKlass); overload;
    procedure Delete(LessonIndex: integer; Subject: TSubject); overload;
    procedure Delete(LessonIndex: integer; Teacher: TTeacher); overload;
    property ForKabinet[KabinetIndex, LessonIndex: integer]: TSubs read GetForKabinet;
    property ForKlasses[KlassIndex, LessonIndex: integer]: TSubject read GetForKlasses;
    property ForTeacher[TeacherIndex, LessonIndex: integer]: TSubs read GetForTeacher;
    property Subjects: TSubjects read FSubjects write SetSubjects;
    property Lessons: TPlainSubjects read FLessons;
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
    function GetSubject(x: integer): TSubject;
    function LoadKabinets(sr: TStream): boolean;
    function LoadKlasses(sr: TStream): boolean;
    function LoadSubjectNames(sr: TStream): boolean;
    function LoadSubjects(sr: TStream): boolean;
    function LoadTeachers(sr: TStream): boolean;
    function LoadTimeTable(sr: TStream): boolean;
    procedure SaveKabinets(sr: TStream);
    procedure SaveKlasses(sr: TStream);
    procedure SaveSubjectNames(sr: TStream);
    procedure SaveSubjects(sr: TStream);
    procedure SaveTeachers(sr: TStream);
    procedure SaveTimeTable(sr: TStream);
    procedure SetSubject(x: integer; const Value: TSubject);
    function GetAsJsonObject: ISuperObject;
    procedure SetAsJsonObject(const Value: ISuperObject);
    //
    procedure Load(srBig: TStream; var Key: string; var srSmall: TStream);
    procedure Save(srBig: TStream; Key: string; srSmall: TStream);
  public
    constructor Create;
    destructor Destroy; override;
    function Add(Subject: TSubject): integer; overload;
    function Add: TSubject; overload;
    function IsCross(subj1, subj2: TSubject): boolean;
    procedure Clear;
    procedure Delete(Subject: TSubject); overload;
    procedure Delete(Index: Integer); overload;
    procedure LoadFromFile(FN: string);
    procedure LoadFromTextFile(FN: string);
    procedure SaveToFile(FN: string);
    procedure SaveToTextFile(FN: string);
    property AsJsonObject:ISuperObject read GetAsJsonObject write SetAsJsonObject;
    property ColumnMode: TColumnMode read FColumnMode write FColumnMode;
    property FullView: boolean read FFullView write FFullView;
    property Item[Index: integer]: TSubject read GetSubject write SetSubject; default;
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
  Result := '';
  if (Index < 0) or (Index > MaxInd) then
    Exit;
  Result := ToName(Strings[Index]).Long;
end;

function TSubjNames.GetMaxInd: integer;
begin
  Result := Count - 1;
end;

function TSubjNames.GetSanPIN(Index: integer): Integer;
begin
  Result := 0;
  if (Index < 0) or (Index > MaxInd) then
    Exit;
  Result := ToName(Strings[Index]).Pin;
end;

function TSubjNames.GetShortName(Index: integer): string;
begin
  Result := '';
  if (Index < 0) or (Index > MaxInd) then
    Exit;
  Result := ToName(Strings[Index]).Short;
end;

procedure TSubjNames.SetAsJsonObject(const Value: ISuperObject);
var
  I:Integer;
  supNames: TSuperArray;
  supSubjName: ISuperObject;
begin
  Clear;
  supNames:=Value.A['Items'];
  for I := 0 to supNames.Length - 1 do begin
    supSubjName:=supNames[I];
    Add(supSubjName.S['LongName'],supSubjName.S['ShortName'],supSubjName.I['SanPIN']);
  end;
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
  I: integer;
begin
  if Longs.Find(LongName[index], I) then
    Longs.Delete(I);
  inherited;
  Name := ToName(s);
  Longs.Add(Name.Long);
end;

{public}
function TSubjNames.GetAsJsonObject: ISuperObject;
var
  I:Integer;
  supNames: TSuperArray;
  supSubjName: ISuperObject;
begin
  Result := SO;
  Result.I['Count']:=Count;
  Result.O['Items']:=SO('[]');
  supNames:=Result.A['Items'];
  for I := 0 to Count - 1 do begin
    supSubjName:=SO;
    supSubjName.S['LongName']:=LongName[I];
    supSubjName.S['ShortName']:=ShortName[I];
    supSubjName.I['SanPIN']:=SanPIN[I];
    supNames.Add(supSubjName);
  end;
end;

procedure TSubjNames.Clear;
begin
  Longs.Clear;
  inherited;
end;

constructor TSubjNames.Create;
begin
  Longs := TStringList.Create;
  Longs.CaseSensitive := false;
  Longs.Sorted := True;
  Longs.Duplicates := dupIgnore;
end;

destructor TSubjNames.Destroy;
begin
  Longs.Free;
  inherited;
end;

function TSubjNames.Add(Long, Short: string; PIN: integer): integer;
var
  I, x: integer;
  s: string;
  Name: TName;
begin
  s := FromName(Long, Short, Pin);
  if Longs.Find(Long, x) then begin
    for I := 0 to MaxInd do begin
      Name := ToName(Strings[I]);
      if SameText(Name.Long, Long) then begin
        x := I;
        break;
      end;
    end;
    strings[x] := s;
    Result := x;
  end
  else begin
    Longs.Add(Long);
    Result := self.Add(s);
  end;
end;

procedure TSubjNames.LoadFromStream(Stream: TStream);
var
  I: integer;
begin
  inherited;
  Longs.Clear;
  for I := 0 to MaxInd do
    Longs.Add(LongName[I]);
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
  I: integer;
begin
  inherited;
  for I := 0 to LessCount - 1 do
    FSubjInTT[I] := TPlainSubjects.Create(false);
  FName := '';
  FPlainSubjectX := TPlainSubjects.Create(false);
  FChecked := True;
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
  Result := ALesson in FCross;
end;

function TSimpleItem.IsLock(ALesson: Integer): boolean;
begin
  Result := ALesson in FLock;
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
    Result := NullItem;
  end
  else
    Result := FItems[ALesson];
end;

{public}
constructor TTimeTableX.Create;
var
  I: integer;
begin
  inherited;
  for I := 0 to LessCount - 1 do
    FItems[I] := TIntegers.Create;
  NullItem := TIntegers.Create;
end;

destructor TTimeTableX.Destroy;
var
  I: integer;
begin
  for I := 0 to LessCount - 1 do
    FItems[I].Free;
  NullItem.Free;
  inherited;
end;

procedure TTimeTableX.Assign(Source: TPersistent);
var
  I: integer;
begin
  if Source is TTimeTableX then
    for I := 0 to LessCount - 1 do begin
      FItems[I].Clear;
      FItems[I].Add(TTimeTableX(Source).Klasses[I]);
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
  Result := inherited GetCross;
end;

function TRefItem.GetCrossRef(Lesson: Integer): Integer;
begin
  Result := 0;
  if (Lesson < 0) or (Lesson >= LessCount) then
    Exit;
  Result := FCrossRef[Lesson];
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
  Result := nil;
  if (LessonIndex < 0) or (LessonIndex > LessCount - 1) then
    Exit;
  Result := FLesson[LessonIndex];
end;

function TKlass.GetLesson(WeekDay, LessonNumber: integer): TSubject;
var
  x: integer;
begin
  x := WeekDay * 11 + LessonNumber;
  Result := LessAbs[x];
end;

function TKlass.GetWDSanPIN(WD: Integer): Real;
begin
  Result := 0;
  if FMaxSanPIN = 0 then
    Exit;
  Result := FWDSanPIN[wd] / FMaxSanPIN;
end;

procedure TKlass.FindMaxSanPIN;
var
  I: integer;
begin
  FMaxSanPIN := 0;
  for I := 0 to WDCount - 1 do
    if FMaxSanPIN < FWDSanPIN[I] then
      FMaxSanPIN := FWDSanPIN[I];
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
  I: integer;
begin
  inherited;
  FTeachers := TTeachers.Create(false);
  FKabinets := TKabinets.Create(false);
  for I := 0 to LessCount - 1 do
    FLesson[I] := nil;
end;

destructor TKlass.Destroy;
begin
  FTeachers.Free;
  FKabinets.Free;
  inherited;
end;

procedure TKlass.Assign(Source: TPersistent);
var
  I: integer;
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
      for I := 0 to LessCount - 1 do
        self.FLesson[I] := LessAbs[I];
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
  Result := FName;
  if FShowNum then
    Result := Result + ' (' + IntToStr(FNum) + ')';
end;

procedure TKabinet.Assign(Source: TPersistent);
var
  I: integer;
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
      for I := 0 to LessCount - 1 do
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
  Result := s;
  p := pos(' ', s);
  if p = 0 then
    Exit;
  Result := Copy(s, 1, p + 1) + '.';
  Delete(s, 1, p + 1);
  p := pos(' ', s);
  if p = 0 then
    Exit;
  Result := Result + Copy(s, p + 1, 1) + '.';
end;

procedure TTeacher.Assign(Source: TPersistent);
var
  I: integer;
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
      for I := 0 to LessCount - 1 do
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
  Result := '';
  if (x < 0) or (x > MaxInd) then
    Exit;
  if FormatString = '' then
    Result := item[x].Name;
  Result := format(FormatString, [item[x].Name]);
end;

function TKlasses.GetItem(x: integer): TKlass;
begin
 // Класс
 ////////////////////////////////////////
 // Текст процедуры изменению не подлежит
  Result := TKlass(inherited GetItem(x));
end;

procedure TKlasses.SetAsJsonObject(const Value: ISuperObject);
var
  I: integer;
  supKlasses: TSuperArray;
  supKlass: ISuperObject;
  Klass: TKlass;
begin
  Clear(True);
  FormatString:=Value.S['FormatString'];
  supKlasses:=Value.A['Items'];
  for I := 0 to supKlasses.Length - 1 do begin
    supKlass:=supKlasses[I];
    Klass:=AddNewItem;
    Klass.Name:=supKlass.S['Name'];
    Klass.Lock:=StringAsCross(supKlass.S['Lock']);
    Klass.Checked:=supKlass.B['Checked'];
  end;
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
  I: integer;
begin
 // Найти класс по названию
 ////////////////////////////////////////
 // Текст процедуры изменению не подлежит
  Result := -1;
  for I := 0 to MaxInd do
    if SameText(Item[I].Name, Name) then begin
      Result := I;
      Exit;
    end;
end;

function TKlasses.Lines(short: boolean): TStrings;
var
  I: integer;
begin
  sts.Clear;
  for I := 0 to MaxInd do
    if short then
      sts.AddObject(Item[I].Name, fItem[I])
    else
      sts.AddObject(FullKlassName[I], fItem[I]);
  Result := sts;
end;

function TKlasses.GetAsJsonObject: ISuperObject;
var
  I: integer;
  supKlasses: TSuperArray;
  supKlass: ISuperObject;
begin
  Result := SO;
  Result.S['FormatString']:=FormatString;
  Result.I['Count']:=Count;
  Result.O['Items']:=SO('[]');
  supKlasses:=Result.A['Items'];
  for I := 0 to Count - 1 do begin
    supKlass:=SO;
    supKlass.S['Name']:=Item[I].Name;
    supKlass.S['Lock']:=CrossAsString(Item[I].Lock);
    supKlass.B['Checked']:=Item[I].Checked;
    supKlasses.Add(supKlass);
  end;
end;

procedure TKlasses.Assign(Source: TPersistent);
var
  Klasses: TKlasses;
  I: integer;
begin
  Clear(false);
  if Source is TKlasses then begin
    Klasses := TKlasses(Source);
    for I := 0 to Klasses.Count - 1 do
      Add(Klasses[I]);
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
  Result := TKabinet(inherited GetItem(x));
end;

procedure TKabinets.SetAsJsonObject(const Value: ISuperObject);
var
  I: integer;
  supKabinets: TSuperArray;
  supKabinet: ISuperObject;
  Kabinet: TKabinet;
begin
  Clear(True);
  supKabinets:=Value.A['Items'];
  for I := 0 to supKabinets.Length - 1 do begin
    supKabinet:=supKabinets[I];
    if supKabinet.I['Num']=-1 then Continue;
    Kabinet:=AddNewItem;
    Kabinet.Name:=supKabinet.S['Name'];
    Kabinet.Num:=supKabinet.I['Num'];
    Kabinet.Lock:=StringAsCross(supKabinet.S['Lock']);
    Kabinet.Checked:=supKabinet.B['Checked'];
    Kabinet.ShowNum:=supKabinet.B['ShowNum'];
  end;
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
  I: integer;
begin
 // Найти кабинет по его коридорному номеру
  Result := -1;
  for I := 0 to MaxInd do
    if Item[I].Num = Num then begin
      Result := I;
      Exit;
    end;
end;

function TKabinets.Lines(Short: boolean): TStrings;
var
  I: integer;
begin
  sts.Clear;
  for I := 0 to MaxInd do
    if short then
      sts.AddObject(Item[I].Name, fItem[I])
    else
      sts.AddObject(Item[I].FullName, fItem[I]);
  Result := sts;
end;

function TKabinets.GetAsJsonObject: ISuperObject;
var
  I: integer;
  supKabinets: TSuperArray;
  supKabinet: ISuperObject;
begin
  Result := SO;
  Result.I['Count']:=Count;
  Result.O['Items']:=SO('[]');
  supKabinets:=Result.A['Items'];
  for I := 0 to Count - 1 do begin
    supKabinet:=SO;
    supKabinet.S['Name']:=Item[I].Name;
    supKabinet.I['Num']:=Item[I].Num;
    supKabinet.S['Lock']:=CrossAsString(Item[I].Lock);
    supKabinet.B['Checked']:=Item[I].Checked;
    supKabinet.B['ShowNum']:=Item[I].ShowNum;
    supKabinets.Add(supKabinet);
  end;
end;

procedure TKabinets.Assign(Source: TPersistent);
var
  kabs: TKabinets;
  I: integer;
begin
  Clear(false);
  if Source is TKabinets then begin
    Kabs := TKabinets(Source);
    for I := 0 to Kabs.Count - 1 do
      Add(Kabs[I]);
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
  Result := TTeacher(inherited Item[x]);
end;

procedure TTeachers.SetAsJsonObject(const Value: ISuperObject);
var
  I: integer;
  supTeachers: TSuperArray;
  supTeacher: ISuperObject;
  Teacher: TTeacher;
begin
  Clear(True);
  supTeachers:=Value.A['Items'];
  for I := 0 to supTeachers.Length - 1 do begin
    Teacher := AddNewItem;
    supTeacher := supTeachers[I];
    Teacher.Name:=supTeacher.S['Name'];
    Teacher.KabNum:=supTeacher.I['KabNum'];
    Teacher.Lock:=StringAsCross(supTeacher.S['Lock']);
    Teacher.Checked:=supTeacher.B['Checked'];
  end;
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
  I: integer;
begin
 // Найти преподавателя по ФИО
  Result := -1;
  for I := 0 to MaxInd do
    if SameText(Item[I].name, Name) then begin
      Result := I;
      Exit;
    end;
end;

function TTeachers.Lines(Short: boolean): TStrings;
var
  I: integer;
begin
  sts.Clear;
  for I := 0 to MaxInd do
    if short then
      sts.AddObject(Item[I].ShortName, fItem[I])
    else
      sts.AddObject(Item[I].Name, fItem[I]);
  Result := sts;
end;

function TTeachers.GetAsJsonObject: ISuperObject;
var
  I: integer;
  supTeachers: TSuperArray;
  supTeacher: ISuperObject;
begin
  Result := SO;
  Result.I['Count']:=Count;
  Result.O['Items']:=SO('[]');
  supTeachers:=Result.A['Items'];
  for I := 0 to Count - 1 do
    with Item[I] do begin
      supTeacher := SO;
      supTeacher.S['Name']:=Name;
      supTeacher.I['KabNum']:=KabNum;
      supTeacher.S['Lock']:=CrossAsString(Lock);
      supTeacher.B['Checked']:=Checked;
      supTeachers.Add(supTeacher);
    end;
end;

procedure TTeachers.Assign(Source: TPersistent);
var
  Teachers: TTeachers;
  I: integer;
begin
  Clear(false);
  if Source is TTeachers then begin
    Teachers := TTeachers(Source);
    for I := 0 to Teachers.Count - 1 do
      Add(Teachers[I]);
  end
  else
    inherited;
end;

//////////////////////////////////////////////////
                  { TSubject }
//////////////////////////////////////////////////

function TSubject.GetCross: TCross;
var
  I: integer;
begin
 //////////////////////////////////////////////////
 // Текст процедуры изменению не подлежит
  Result := [];
  for I := 0 to MaxInd do begin
    if FTeachers[I] <> nil then
      Result := Result + FTeachers[I].Cross;
    if FKabinets[I] <> nil then
      Result := Result + FKabinets[I].Cross;
  end;
end;

function TSubject.GetInfo: string;
var
  st, s: string;
  I: integer;
begin
 // Получить информацию о предмете в виде одной строки
  Result := '';
  st := 'Пустая клетка';
  if MaxInd > -1 then begin
    st := Klass.Name + ': ' + LongName + '  ||  ';
    st := st + ObrTime(FLessonAtWeek) + '  ||   ' + tuSt[Complexion] + '  ||   ';
    s := '';
    for I := 0 to TeacherCount - 1 do begin
      if s > '' then
        s := s + ', ';
      if FTeachers[I] <> nil then
        s := s + FTeachers[I].Name;
    end;
    st := st + s;
    s := '';
    for I := 0 to TeacherCount - 1 do begin
      if s > '' then
        s := s + ', ';
      if FKabinets[I] <> nil then
        s := s + FKabinets[I].Name;
    end;
    if s > '' then
      s := '  ||   каб.:' + s;
    st := st + s;
  end;
  Result := st;
end;

function TSubject.GetKabinets(x: integer): TKabinet;
begin
 // Список предметов в которых проводится урок
  Result := nil;
  if (x < 0) or (x > MaxInd) or (x >= Length(FKabinets)) then
    Exit;
  Result := FKabinets[x];
end;

function TSubject.GetKlassTitle(tc: TTableContent): string;
begin
  Result := Klass.Name + ': ' + Title[tc];
end;

function TSubject.GetLongKlassName: string;
begin
  Result := Klass.Name + ': ' + LongName;
end;

function TSubject.GetLongName: string;
begin
  Result := '';
  if FNames = nil then
    Exit;
  if (FNameIndex < 0) or (FNameIndex > FNames.Count - 1) then
    Exit;
  Result := FNames.LongName[FNameIndex];
end;

function TSubject.GetSanPIN: integer;
begin
  Result := 0;
  if FNames = nil then
    Exit;
  if (FNameIndex < 0) or (FNameIndex > FNames.Count - 1) then
    Exit;
  Result := FNames.SanPIN[FNameIndex];
end;

function TSubject.GetShortName: string;
begin
  Result := '';
  if FNames = nil then
    Exit;
  if (FNameIndex < 0) or (FNameIndex > FNames.Count - 1) then
    Exit;
  Result := FNames.ShortName[FNameIndex];
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
  Result := MaxInd + 1;
end;

function TSubject.GetTeachers(x: integer): TTeacher;
begin
 // Список учителей которые проводят урок
  Result := nil;
  if (x < 0) or (x > MaxInd) or (x >= Length(FTeachers)) then
    Exit;
  Result := FTeachers[x];
end;

function TSubject.GetTitle(tc: TTableContent): string;
var
  I: integer;
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
      sts.Sorted := True;
      for I := 0 to TeacherCount - 1 do
        if Kabinets[I].ShowNum then
          sts.Add(IntToStr(Kabinets[I].Num));
      if st <> '' then
        st := st + ')';
      st := sts.CommaText;
      sts.Free;
      if st <> '' then
        st := ' (' + st + ')';
      st := ShortName + st;
    end;
    tcTeacher:
      for I := 0 to TeacherCount - 1 do begin
        if I > 0 then
          st := st + #13#10;
        st := st + Teachers[I].ShortName;
      end;
    tcKabinet:
      for I := 0 to TeacherCount - 1 do begin
        if I > 0 then
          st := st + #13#10;
        st := st + Kabinets[I].FullName;
      end;
  end;
  Result := st;
end;

function TSubject.GetVisible: boolean;
begin
  Result := True;
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
  Result := IntToStr(t) + ' час' + st;
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

procedure TSubject.SetKabinets(x: integer; const Value: TKabinet);
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
  if Parent<>nil then Exception.Create('Нельзя менять класс в сетке расписания');

  if FKlass <> nil then
    FKlass.SubjectX.Delete(self);
  FKlass := Value;
  if ItemIndex = -1 then
    Exit;
  if FKlass <> nil then
    FKlass.SubjectX.Add(self);
end;

procedure TSubject.SetLessonIndex(const Value: Integer);
begin
  FLessonIndex := Value;
end;

procedure TSubject.SetNameIndex(const Value: integer);
begin
  if Parent<>nil then Exception.Create('Нельзя название предмета в сетке расписания');
  FNameIndex := Value;
end;

procedure TSubject.SetParent(const Value: TSubject);
begin
  FParent := Value;
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
  I: integer;
begin
  inherited;
  Klass := Klass;
  for I := 0 to TeacherCount - 1 do begin
    Teachers[I] := Teachers[I];
    Kabinets[I] := Kabinets[I];
  end;
end;

constructor TSubject.Create(Names: TSubjNames);
begin
 // Создание нового предмета
  inherited Create;
  FNames := Names;
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
  I: integer;
begin
  if Source is TSubject then
    with TSubject(Source) do begin
      self.Clear;
      for I := 0 to TeacherCount - 1 do
        self.Add(Teachers[I], Kabinets[I]);
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
  I, l: integer;
begin
  l := Length(FTeachers);
  for I := 0 to l - 1 do begin
    Teachers[I] := nil;
    Kabinets[I] := nil;
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
  I: integer;
begin
 // Удаление кабинета и преподавателя из списка
 //////////////////////////////////////////////////
 // Текст процедуры изменению не подлежит
  if (x < 0) or (x > MaxInd) then
    Exit;
  Teachers[x] := nil;
  Kabinets[x] := nil;
  for I := x to MaxInd - 1 do begin
    FTeachers[I] := FTeachers[I + 1];
    FKabinets[I] := FKabinets[I + 1];
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
  Result := TSubject(inherited GetItem(x));
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
  I: integer;
begin
  Clear(false);
  if Source is TPlainSubjects then begin
    Subs := TPlainSubjects(Source);
    for I := 0 to Subs.Count - 1 do
      Add(Subs[I]);
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
  I, j, n: integer;
  subj: TSubject;
begin
  /// 20-04-2012
  ///  Проверить все классы. Если у класса(ов) есть занятия
  ///  в это время, то выдать список тех занятий, в котором
  ///  есть нужный преподователь

  n := 0;
  ClearSubjs;
  for I := 0 to Klasses.Count - 1 do begin
    Subj := Klasses[I].LessAbs[LessonIndex];
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
  Result := Subjs;
end;

function TTimeTable.GetForTeacher(TeacherIndex,
  LessonIndex: integer): TSubs;
var
  I, j, n: integer;
  subj: TSubject;
begin
  /// См. описание к GetForKabinet
  n := 0;
  ClearSubjs;
  for I := 0 to Klasses.Count - 1 do begin
    Subj := Klasses[I].LessAbs[LessonIndex];
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
  Result := Subjs;
end;

function TTimeTable.GetForKlasses(KlassIndex, LessonIndex: integer): TSubject;
var
  Klass: TKlass;
begin
  Result := nil;
  if Subjects = nil then
    Exit;
  if (LessonIndex < 0) or (LessonIndex > LessCount - 1) then
    Exit;
  Klass := Subjects.Klasses[KlassIndex];
  if Klass = nil then
    Exit;
  Result := Klass.LessAbs[LessonIndex];
end;

function TTimeTable.GetKlasses: TKlasses;
begin
  Result := nil;
  if FSubjects=nil then Exit;
  Result:=FSubjects.Klasses;
end;

procedure TTimeTable.Add2(LessonIndex: integer; Subject: TSubject);
var
  I, KlassIndex: integer;
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
    KlassIndex := Klass.ItemIndex;
  // Запомнить номер класса в числе других для данного урока
    TimeTableX.Klasses[LessonIndex].Add(KlassIndex);
  // Проделать то же самое данных Учителей и Кабинетов
    for I := 0 to TeacherCount - 1 do begin
      Teachers[I].TimeTableX.Klasses[LessonIndex].Add(KlassIndex);
      Teachers[I].IncCross(LessonIndex);
      Kabinets[I].TimeTableX.Klasses[LessonIndex].Add(KlassIndex);
      Kabinets[I].IncCross(LessonIndex);
    end;
  end;
end;

procedure TTimeTable.ClearSubjs;
var
  I: integer;
begin
  for I := 0 to High(Subjs) do
    Subjs[I].Free;
  SetLength(Subjs, 0);
end;

procedure TTimeTable.SetSubjects(const Value: TSubjects);
begin
  FSubjects := Value;
end;

{public}
constructor TTimeTable.Create;
begin
  SetLength(Subjs, 0);
  FLessons := TPlainSubjects.Create(True);
end;

destructor TTimeTable.Destroy;
begin
  ClearSubjs;
  FLessons.Free;
  inherited;
end;

procedure TTimeTable.Add(LessonIndex: integer; Subject: TSubject);
var
  I, KlassIndex: integer;
  Subj:TSubject;
begin
 // Выйти при отсутствии списка предметов
  if Subjects = nil then
    Exit;
 // Выйти если нечего добавлять
  if Subject = nil then
    Exit;

  // Выйти если не определён класс добавляемого предмета
    if Subject.Klass = nil then
      Exit;

  // Увеличить сумму часов предмета в расписании
    Subject.InTimeTable := Subject.InTimeTable + 1;

///  // Задать текущие координаты предмета в сетке расписания
///    Subject.Klass.LessAbs[LessonIndex] := Subject;

  // Отметить номер урока как занятый
    Subject.Klass.Cross := Subject.Klass.Cross + [LessonIndex];
  // Запомнить номер класса
    KlassIndex := Subject.Klass.ItemIndex;
  // Запомнить номер класса в числе других для данного урока
    Subject.TimeTableX.Klasses[LessonIndex].Add(KlassIndex);
  // Проделать то же самое данных Учителей и Кабинетов
    for I := 0 to Subject.TeacherCount - 1 do begin
      Subject.Teachers[I].TimeTableX.Klasses[LessonIndex].Add(KlassIndex);
      Subject.Teachers[I].IncCross(LessonIndex);
      Subject.Kabinets[I].TimeTableX.Klasses[LessonIndex].Add(KlassIndex);
      Subject.Kabinets[I].IncCross(LessonIndex);
    end;
    Subj := TSubject.Create(Subject.FNames);
    Subj.Assign(Subject);
    Subj.FParent := Subject;
    Subj.LessonIndex:=LessonIndex;
    FLessons.Add(Subj);
end;

procedure TTimeTable.Delete(LessonIndex: integer; Kabinet: TKabinet);
var
  I: integer;
begin
  for I := 0 to Kabinet.TimeTableX[LessonIndex].Count - 1 do
    Delete(LessonIndex, Klasses[Kabinet.TimeTableX[LessonIndex][I]]);
end;

procedure TTimeTable.Delete(LessonIndex: integer; Klass: TKlass);
begin
  Delete(LessonIndex, Klass.LessAbs[LessonIndex]);
end;

procedure TTimeTable.Delete(LessonIndex: integer; Subject: TSubject);
var
  I, KlassIndex: integer;
  Lesson:TSubject;
begin
  if Subject = nil then
    Exit;
  Lesson := Subject;
  if Lesson.Parent<>nil then Subject := Lesson.Parent else
    for I := 0 to Lessons.Count - 1 do begin
      if Lessons[I].Parent=Subject then Lesson:=Lessons[I];
    end;
  with Subject do begin
    if Klass = nil then
      Exit;
    KlassIndex := Klass.ItemIndex;
    InTimeTable := InTimeTable - 1;
    for I := 0 to TeacherCount - 1 do begin
      Teachers[I].TimeTableX.Klasses[LessonIndex].Delete(KlassIndex);
      Teachers[I].DecCross(LessonIndex);
      Kabinets[I].TimeTableX.Klasses[LessonIndex].Delete(KlassIndex);
      Kabinets[I].DecCross(LessonIndex);
    end;
    Lessons.Delete(Lesson,True);
  end;
end;

procedure TTimeTable.Delete(LessonIndex: integer; Teacher: TTeacher);
var
  I: integer;
begin
  for I := 0 to Teacher.TimeTableX[LessonIndex].Count - 1 do
    Delete(LessonIndex, Klasses[Teacher.TimeTableX[LessonIndex][I]]);
end;

procedure TTimeTable.Delete2(LessonIndex: integer; Klass: TKlass);
begin
  Delete(LessonIndex, Klass.LessAbs[LessonIndex]);
end;

procedure TTimeTable.Delete2(LessonIndex: integer; Kabinet: TKabinet);
var
  I: integer;
begin
  for I := 0 to Kabinet.TimeTableX[LessonIndex].Count - 1 do
    Delete(LessonIndex, Klasses[Kabinet.TimeTableX[LessonIndex][I]]);
end;

procedure TTimeTable.Delete2(LessonIndex: integer; Teacher: TTeacher);
var
  I: integer;
begin
  for I := 0 to Teacher.TimeTableX[LessonIndex].Count - 1 do
    Delete(LessonIndex, Klasses[Teacher.TimeTableX[LessonIndex][I]]);
end;

procedure TTimeTable.Delete2(LessonIndex: integer; Subject: TSubject);
var
  I, KlassIndex: integer;
begin
  if Subject = nil then
    Exit;
  with Subject do begin
    if Klass = nil then
      Exit;
    KlassIndex := Klass.ItemIndex;
    InTimeTable := InTimeTable - 1;
    for I := 0 to TeacherCount - 1 do begin
      Teachers[I].TimeTableX.Klasses[LessonIndex].Delete(KlassIndex);
      Teachers[I].DecCross(LessonIndex);
      Kabinets[I].TimeTableX.Klasses[LessonIndex].Delete(KlassIndex);
      Kabinets[I].DecCross(LessonIndex);
    end;
    Klass.LessAbs[LessonIndex] := nil;
  end;
end;

//////////////////////////////////////////////////
                { TSubjects }
//////////////////////////////////////////////////
{private}
function TSubjects.GetSubject(x: integer): TSubject;
begin
 // Выдать предмет из списка
 //////////////////////////////////////////////////
 // Текст процедуры изменению не подлежит
  Result := GetItem(x) as TSubject;
end;

function TSubjects.LoadKabinets(sr: TStream): boolean;
var
  ms: TMemoryStream;
  I, n, p: integer;
  xr: TCross;
  b: Boolean;
  Key: string;
  Kabinet: TKabinet;
begin
  ms := TMemoryStream.create;
  p := sr.Position;
  Load(sr, Key, TStream(ms));
  Result := Key = 'Кабинеты';
  if not Result then begin
    sr.Position := p;
    ms.Free;
    Exit;
  end;
  ms.Read(n, 4);
  for I := 1 to n do begin
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
  I, p, n: integer;
  xr: TCross;
  b: Boolean;
  Klass: TKlass;
  Key: string;
begin
  ms := TMemoryStream.create;
  p := sr.Position;
  Load(sr, Key, TStream(ms));
  Result := Key = 'Классы';
  if not Result then begin
    sr.Position := p;
    ms.Free;
    Exit;
  end;
  Klasses.FormatString := ReadString(ms);
  ms.Read(n, 4);
  for I := 1 to n do begin
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
  Result := Key = 'Названия предметов';
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
  I, j, n, bs, xs: integer;
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
  Result := Key = 'Предметы';
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
    for I := 1 to n do begin
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
  I, p, n: integer;
  xr: TCross;
  b: Boolean;
  Teacher: TTeacher;
  Key: string;
begin
  ms := TMemoryStream.create;
  p := sr.Position;
  Load(sr, Key, TStream(ms));
  Result := Key = 'Учителя';
  if not Result then begin
    sr.Position := p;
    ms.Free;
    Exit;
  end;
  ms.Read(n, 4);
  for I := 1 to n do begin
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
  Result := 1 = 1;
end;

procedure TSubjects.SaveKabinets(sr: TStream);
var
  ms: TMemoryStream;
  I, n: integer;
  xr: TCross;
  b: Boolean;
begin
  ms := TMemoryStream.create;
  with Kabinets do begin
    I := Count - 1;
    ms.Write(I, 4);
    for I := 1 to Count - 1 do
      with Item[I] do begin
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
  I: integer;
  xr: TCross;
  b: Boolean;
begin
  ms := TMemoryStream.create;
  with Klasses do begin
    WriteString(ms, FormatString);
    I := Count;
    ms.Write(I, 4);
    for I := 0 to Count - 1 do begin
      WriteString(ms, Item[I].Name);
      xr := Item[I].Lock;
      ms.Write(xr, SizeOf(xr));
      b := Item[I].Checked;
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
  I, j, n, bs, xs: integer;
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
    for I := 0 to MaxInd do
      with Item[I] do begin
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
  I, n: integer;
  xr: TCross;
  b: Boolean;
begin
  ms := TMemoryStream.create;
  with Teachers do begin
    I := Count;
    ms.Write(I, 4);
    for I := 0 to Count - 1 do
      with Item[I] do begin
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

procedure TSubjects.SetAsJsonObject(const Value: ISuperObject);
var
  I, J: integer;
  supSubjects: TSuperArray;
  supTeachKabs: TSuperArray;
  supSubject: ISuperObject;
  supTeachKab: ISuperObject;
  Subject:TSubject;
  Kabinet:TKabinet;
  Teacher:TTeacher;
begin
  Clear;
  Klasses.AsJsonObject:=Value.O['Klasses'];
  Kabinets.AsJsonObject:=Value.O['Kabinets'];
  Teachers.AsJsonObject:=Value.O['Teachers'];
  SubjectNames.AsJsonObject:=Value.O['SubjectNames'];
  FViewMode:=TViewMode(Value.I['ViewMode']);
  FColumnMode:=TColumnMode(Value.I['ColumnMode']);
  FTableContent:=TTableContent(Value.I['TableContent']);
  FWeekDays:=StringAsWeekDays(Value.S['WeekDays']);
  FLessons:=StringAsCross(Value.S['Lessons']);
  FFullView:=Value.B['FullView'];
  supSubjects := Value.A['Items'];
  for I := 0 to supSubjects.Length - 1 do begin
    Subject := Add;
    supSubject := supSubjects[I];
    Subject.Klass:=Klasses[supSubject.I['KlassIndex']];
    supTeachKabs:=supSubject.A['Items'];
    for J := 0 to supTeachKabs.Length - 1 do begin
      supTeachKab := supTeachKabs[J];
      Teacher := Teachers[supTeachKab.I['TeacherIndex']];
      Kabinet := Kabinets[supTeachKab.I['KabinetIndex']];
      Subject.Add(Teacher,Kabinet);
    end;
    Subject.FComplexion:=supSubject.I['Complexion'];
    Subject.FLessonAtWeek:=supSubject.I['LessonAtWeek'];
    Subject.FNameIndex:=supSubject.I['NameIndex'];
    Subject.FMultiLine:=supSubject.B['MultiLine'];
  end;
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
  inherited Create(True);
  FFullView := True;
 // Выделение памяти
  FSubjectNames := TSubjNames.Create;
  FTimeTable := TTimeTable.Create;
  FKabinets := TKabinets.Create(True);
  FKlasses := TKlasses.Create(True);
  FTeachers := TTeachers.Create(True);
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
  Result := Subject.ItemIndex;
  if Result <> -1 then
    if Item[Result] = Subject then
      Exit;
  Result := inherited Add(Subject);
end;

function TSubjects.Add: TSubject;
begin
 // Добавление места под предмет.
 // Все проверки и учёт пересечений делаются потом.
 //////////////////////////////////////////////////
 // Текст процедуры изменению не подлежит
  Result := TSubject.Create(fSubjectNames);
  Add(Result);
end;

function TSubjects.GetAsJsonObject: ISuperObject;
var
  I, J, N: integer;
  supSubjects: TSuperArray;
  supTeachKabs: TSuperArray;
  supSubject: ISuperObject;
  supTeachKab: ISuperObject;
begin
  Result := SO;
  Result.O['Klasses']:=Klasses.GetAsJsonObject;
  Result.O['Kabinets']:=Kabinets.GetAsJsonObject;
  Result.O['Teachers']:=Teachers.GetAsJsonObject;
  Result.O['SubjectNames']:=SubjectNames.AsJsonObject;
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
  Result.O['Items']:=SO('[]');
  supSubjects := Result.A['Items'];
  for I := 0 to MaxInd do
    with Item[I] do begin
      supSubject := SO;
      if Klass = nil then
        N := -1
      else
        N := Klass.ItemIndex;
      supSubject.I['KlassIndex']:=N;
      supSubject.I['TeacherCount']:=TeacherCount;
      supSubject.O['Items']:=SO('[]');
      supTeachKabs:=supSubject.A['Items'];
      for J := 0 to TeacherCount - 1 do begin
        supTeachKab := SO;
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
  I, j: integer;
begin
  Result := false;
  if (subj1 = nil) or (subj2 = nil) then
    Exit;
  for I := 0 to subj1.TeacherCount - 1 do
    for j := 0 to subj2.TeacherCount - 1 do begin
      Result := Result or (subj1.Teachers[I] = subj2.Teachers[j]) or (subj1.Kabinets[I] = subj2.Kabinets[j]);
      if Result then
        Exit;
    end;
end;

procedure TSubjects.Clear;
begin
  inherited Clear(True);
  FKlasses.Clear(True);
  FKabinets.Clear(True);
  FTeachers.Clear(True);
  FSubjectNames.Clear;
end;

procedure TSubjects.Delete(Subject: TSubject);
var
  I: integer;
begin
  Subject.Klass := nil;
  for I := 0 to Subject.TeacherCount - 1 do begin
    Subject.Teachers[I] := nil;
    Subject.Kabinets[I] := nil;
  end;
  inherited Delete(Subject, True);
end;

procedure TSubjects.Delete(Index: Integer);
begin
 // Удалить все упоминания о предмете в других данных.
 // Удалить предмет из списка.
 //////////////////////////////////////////////////
 // Текст процедуры изменению не подлежит
  if (Index < 0) or (Index > MaxInd) then
    Exit;
  Delete(item[Index]);
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

procedure TSubjects.LoadFromFile(FN: string);
var
  fs: TFileStream;
begin
 // Загрузка данных из файла. В том числе преподаватели, кабинеты и классы
 // TODO 3: LoadFromFile (необходимо прочитать Current-данные)
  if not FileExists(FN) then begin
    ShowMessage('Файл не существует');
    Exit;
  end;
  Clear;
  fs := TFileStream.Create(FN, fmOpenRead);
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
  until True;
  fs.Free;
end;

procedure TSubjects.LoadFromTextFile(FN: string);
var
  SupObj: ISuperObject;
  sts:TStringList;
begin
  sts:=TStringList.Create;
  sts.LoadFromFile(FN);
  SupObj := SO(sts.Text);
  AsJsonObject:= SupObj;
  sts.Free;
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

procedure TSubjects.SaveToFile(FN: string);
var
  fs: TFileStream;
begin
 // Запись абсолютно всех данных в файл
 // TODO 3: SaveToFile (необходимо сохранить Current-данные)
  fs := TFileStream.Create(FN, fmCreate);
  SaveKlasses(fs);
  SaveKabinets(fs);
  SaveTeachers(fs);
  SaveSubjectNames(fs);
  SaveSubjects(fs);
  SaveTimeTable(fs);
  fs.Free;
end;

procedure TSubjects.SaveToTextFile(FN: string);
begin
 // Запись абсолютно всех данных в файл
 // TODO 3: SaveToFile (необходимо сохранить Current-данные)
  AsJsonObject.SaveTo(FN,True);
end;
////////////////////// Вспомогательные функции //////////////////////
function ToName(s: string): TName;
begin
  with TStringList.Create do begin
    CommaText := s;
    Result.Long := strings[0];
    Result.Short := strings[1];
    Result.Pin := StrToInt(strings[2]);
    Free;
  end;
end;

function FromName(Long, Short: string; Pin: integer): string;
begin
  with TStringList.Create do begin
    Add(Long);
    Add(Short);
    Add(IntToStr(Pin));
    Result := CommaText;
    Free;
  end;
end;

function TSimpleItem.GetAvailableSubjects(LessonIndex: integer): TSubjects;
begin
  // Заглушка
  Result:=nil;
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

