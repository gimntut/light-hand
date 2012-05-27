////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//    ������ �������� ����������� ���������, ��������, ������ � ���������     //
//                          �  �������� ����������                            //
//                                                                            //
//                   �����������: ������ ����� 2000-2006, 2012�               //
////////////////////////////////////////////////////////////////////////////////

//////////// �������� //////////////
/// substitution - �������

///////////// ����� ����� /////////////
/// 24.04.2012: ���� ���������� �� TimeTable.Lessons:TSubjects � TimeTable.Lessons[LessonIndex]:TSubjects
/// 24.04.2012: ����� ���������� �� LessAbs
/// 02.05.2012: ����� ��������� ��������, ������ � �������� �� 2 ������
/// ������ ����� ����� ������ ��� TSubjects, ������ ����� ����� ��� TTimeTable
/// � ��� ��� ��������� � ��.
/// 03.05.2012 ����� ������� Teachers �� TKlass
/// 26.05.2012 ��� ��������� �� ����. ������� � ���������� �� ��������, ������,
/// ��������, �������������� � �����. � ��, � ���� �������, �� ����,
/// ��� ��������� �� ���.

unit sbjKernel;

interface

uses Windows, SysUtils, Classes, SbjColl, Dialogs,
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
    Pin: Integer;
  end;
 ////////////////////// x //////////////////////
 // TSubjNames - ������������ ���������
 // procedure Put(Index: Integer; const S: string); override;
 // property LongName[x:Integer]:string read GetLongName write SetLongName;
 // property ShortName[x:Integer]:string read GetShortName write SetShortName;
 // property SanPIN[x:Integer]:Integer read GetSanPIN write SetSanPIN;
 // function Add(Long,Short:string;PIN:Integer):Integer; reintroduce; overload;
 // procedure LoadFromStream(Stream:TStream); override;
  TSubjNames = class (TStringList)
  private
    Longs: TStringList;
    function GetLongName(Index: Integer): string;
    function GetMaxInd: Integer;
    function GetSanPIN(Index: Integer): Integer;
    function GetShortName(Index: Integer): string;
    function GetAsJsonObject: ISuperObject;
    procedure SetLongName(Index: Integer; const Value: string);
    procedure SetSanPIN(Index: Integer; const Value: Integer);
    procedure SetShortName(Index: Integer; const Value: string);
    procedure SetAsJsonObject(const Value: ISuperObject);
  protected
    procedure Put(Index: Integer; const S: string); override;
    property MaxInd: Integer read GetMaxInd;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(Long, Short: string; PIN: Integer): Integer; reintroduce; overload;
    procedure LoadFromStream(Stream: TStream); override;
    procedure Clear; override;
    property AsJsonObject: ISuperObject read GetAsJsonObject write SetAsJsonObject;
    property LongName[x: Integer]: string read GetLongName write SetLongName;
    property SanPIN[x: Integer]: Integer read GetSanPIN write SetSanPIN;
    property ShortName[x: Integer]: string read GetShortName write SetShortName;
  end;
 ////////////////////// x //////////////////////
 // TSimpleItem - ��������� ������� ���������
 // IsLock(ALesson):boolean - �������� ����������������;
 // IsCross(ALesson):boolean - �������� ������� �����������;
 // SwitchLock(x: Integer) - ������������ ����������������;
 // Name:string - ��� ���������
 // Lock:TCross - ������ �����������������
 // Checked:boolean - ������� �� �������� � �����
 // Cross:TCross - ������ �����������
 // SubjectX: - �������������� ��������
  TSimpleItem = class (TCollItem)
  private
    FChecked: boolean;
    FCross: TCross;
    FLock: TCross;
    FName: string;
    FSubjects: TPlainSubjects;
    FLessons: TPlainSubjects;
    function GetAvailableSubjects(LessonIndex: Integer): TSubjects;
    function GetCross: TCross; virtual;
  ////////////////////// ����� ������ //////////////////////
    function GetSubjects: TPlainSubjects;
    function GetLessons: TPlainSubjects;
  public
    constructor Create; override;
    destructor Destroy; override;
    function IsCross(ALesson: Integer): boolean;
    function IsLock(ALesson: Integer): boolean;
    procedure SwitchLock(LessonIndex: Integer);
    property AvailableSubjects[LessonIndex: Integer]: TSubjects read GetAvailableSubjects;
    property Checked: boolean read FChecked write FChecked;
    property Cross: TCross read GetCross write FCross;
    property Lock: TCross read FLock write FLock;
    property Name: string read FName write FName;
    property Subjects: TPlainSubjects read GetSubjects;
    property Lessons: TPlainSubjects read GetLessons;
  end;
 ////////////////////// x //////////////////////
 // TTimeTableX - ���������� � ����� � �����������
 // Klasses[ALesson]:TIntegers - ������ ������� ��� �������� �������,
 // � ������� ������ ������� ����� ��� � ����������
 ////////////////////// x //////////////////////
 // TRefItem - ��������� �������� � ������������� �������������
 // DecCross(Lesson)/IncCross(Lesson) - ��������/���������� ����� ����������� ����� �������
 // Cross:TCross - ������� �����������
 // CrossRef[Lesson]:Integer - ����� �����������;
 // TimeTableX:TTimeTableX - ������� �� �������, ��� ����������� ���� �������;
  TRefItem = class (TSimpleItem)
  private
    FCrossRef: TCrossRef;
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
  end;
 ////////////////////// x //////////////////////
 // TKlass - ���������� �� ���������� ������
 // Assign(Source: TPersistent); - ����������� ���������� � ������ ������
 // Kabinets:TKabinets - ������ ��������� ������� �����? ������ �����
 // LessAbs[LessonIndex:Integer]:TSubject - ������� �� ������� �����
 // Lessons[WeekDay,LessonNumber:Integer]:TSubject - ������� �� ����� � ��� ������
 // Teachers:TTeachers - ������ �������� ������� ���������? � ������ ������
 // WDSanPIN[WD:Integer]:Real - ������������ ������ � ����������� �� ��� ������
 // ����.: ����� ������������ ������ �� ������ = 1
  TKlass = class (TSimpleItem)
  private
    FKabinets: TKabinets;
    FMaxSanPIN: Integer;
    FTeachers: TTeachers;
    FWDSanPIN: array[0..WDCount - 1] of Integer;
    function GetWDSanPIN(WD: Integer): Real;
    procedure FindMaxSanPIN;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property Kabinets: TKabinets read FKabinets;
    property WDSanPIN[WD: Integer]: Real read GetWDSanPIN;
  end;

  ////////////////////// x //////////////////////
  // TKabinet - ���������� �� ���������� ��������
  // FullName(): string; - �������� �������� � �������
  // Assign(Source) - ����������� ���������� � ������ ��������
  // Num:Integer - ����� ��������
  // Klasses:TKlasses - ������ ������� ����������? � ������ ��������
  // Teachers:TTeachers - ������� ������� ��������� � ������ ��������
  // ShowNum:boolean - ���������� �� ����� ����� � ����������
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
 // TTeacher - ���������� �� ���������� �������
 // Assign(Source) - ����������� ���������� � ������ �������
 // ShortName():string - ������� � ����������
 // KabNum:Integer - ����� ��������, ���, ��� �������, �������� ������ �������
 // Kabinets:TKabinets - �������� � ������� ���� ������ �������������
 // Klasses:TKlasses - ������ � ������� ���� ������ �������������
  TTeacher = class (TRefItem)
  private
    FKabinets: TKabinets;
    FKabNum: Integer;
    FKlasses: TKlasses;
  public
    constructor Create; override;
    destructor Destroy; override;
    function ShortName: string;
    procedure Assign(Source: TPersistent); override;
    property Kabinets: TKabinets read FKabinets;
    property KabNum: Integer read FKabNum write FKabNum;
    property Klasses: TKlasses read FKlasses;
  end;
 ////////////////////// x //////////////////////
 // TKlasses - ��������� �������
  TKlasses = class (TColl)
  private
    FFormatString: string;
    sts: TStringList;
    function GetFullKlassName(x: Integer): string;
    function GetItem(Index: Integer): TKlass;
    function GetAsJsonObject: ISuperObject;
    procedure SetFormatString(const Value: string);
    procedure SetItem(Index: Integer; const Value: TKlass);
    procedure SetAsJsonObject(const Value: ISuperObject);
  public
    constructor Create(AutoIndex: boolean);
    destructor Destroy; override;
    function AddNewItem: TKlass;
    function IndexOf(Name: string): Integer;
    function Lines(short: boolean): TStrings;
    procedure Assign(Source: TPersistent); override;
    property AsJsonObject: ISuperObject read GetAsJsonObject write SetAsJsonObject;
    property FormatString: string read FFormatString write SetFormatString;
    property FullKlassName[x: Integer]: string read GetFullKlassName;
    property Item[Index: Integer]: TKlass read GetItem write SetItem; default;
  end;
 ////////////////////// x //////////////////////
 // TKabinets - ��������� ���������
  TKabinets = class (TColl)
  private
    AnyKabinet: TKabinet;
    sts: TStringList;
    function GetItem(Index: Integer): TKabinet;
    function GetAsJsonObject: ISuperObject;
    procedure SetItem(Index: Integer; const Value: TKabinet);
    procedure SetAsJsonObject(const Value: ISuperObject);
  public
    constructor Create(AutoIndex: boolean);
    destructor Destroy; override;
    function AddNewItem: TKabinet;
    function IndexOf(Num: Integer): Integer;
    function Lines(Short: boolean): TStrings;
    procedure Assign(Source: TPersistent); override;
    procedure Clear(AutoFree: boolean);
    property AsJsonObject: ISuperObject read GetAsJsonObject write SetAsJsonObject;
    property Item[Index: Integer]: TKabinet read GetItem write SetItem; default;
  end;
 ////////////////////// x //////////////////////
 // TTeachers - ��������� ��������
  TTeachers = class (TColl)
  private
    sts: TStringList;
    function GetItem(x: Integer): TTeacher;
    function GetAsJsonObject: ISuperObject;
    procedure SetItem(x: Integer; const Value: TTeacher);
    procedure SetAsJsonObject(const Value: ISuperObject);
  public
    constructor Create(AutoIndex: boolean);
    destructor Destroy; override;
    function AddNewItem: TTeacher;
    function IndexOf(Name: string): Integer;
    function Lines(Short: boolean): TStrings;
    procedure Assign(Source: TPersistent); override;
    property AsJsonObject: ISuperObject read GetAsJsonObject write SetAsJsonObject;
    property Item[x: Integer]: TTeacher read GetItem write SetItem; default;
  end;
////////////////////// x //////////////////////
  TNumOfLessons = set of 0..10;
 ////////////////////// x //////////////////////
 /// TSubject - ���������� �� ����� ��������
 /// ProC SetID(const Value: Integer); - ������ ������ ��������
 /// prop InTimeTable - ���������� ���������� �������� � ����������
 /// ProC Add(Teacher: TTeacher; Kabinet: TKabinet); - �������� ������������� �
 /// * ������� � ������� �������� ����
 /// ProC Assign(Source: TPersistent); - ������� ������ �� ������� ��������
 /// ProC Clear; - ������� ������ �������������� � ���������
 /// ProC Delete(x:Integer); - ������� ������� � �������
 /// prop Complexion - ��� ����� (�������, ���������, ����������)
 /// prop Cross - �������������� �����
 /// prop Info - ���������� � ��������
 /// prop Kabinets - ������ ���������
 /// prop Klass - ����� � ������� �������� �������
 /// prop KlassTitle - �����+(�������/�������/�������)
 /// prop LessonAtWeek - ������������ ����� ����� � ������
 /// prop LongKlassName - ������ �������� ������
 /// prop LongName - ������ �������� ��������
 /// prop MultiLine - ������������� ���������� � �������� (True/False)
 /// prop NameIndex - ���������� ����� �������� ��������
 /// prop SanPIN - ���� �������� �� ������
 /// prop ShortName - �������� ��� ��������
 /// prop State - ��������� �������� (��� �����������)
 /// prop TeacherCount - ���������� �������� ������� ���� �������
 /// prop Teachers - ������ �������� ������� ���� �������
 /// prop TimeTableX -
 /// prop Title
 /// prop Visible
 ///
 /// prop LessonIndex - ����� ������� � ����������.
 /// prop Parent - ������ �������� �� �������� ��������� �������
  TSubject = class (TRefItem)
  private
    FComplexion: Integer;
    FInTimeTable: Integer;
    FKabinets: array of TKabinet;
    FKlass: TKlass;
    FLessonAtWeek: Integer;
    FMultiLine: boolean;
    FNameIndex: Integer;
    FNames: TSubjNames;
    FTeachers: array of TTeacher;
    MaxInd: Integer;
    function GetCross: TCross; override;
    function GetInfo: string;
    function GetKabinets(x: Integer): TKabinet;
    function GetKlassTitle(tc: TTableContent): string;
    function GetLongKlassName: string;
    function GetLongName: string;
    function GetSanPIN: Integer;
    function GetShortName: string;
    function GetState(Lesson: Integer): TSubjState;
    function GetTeacherCount: Integer;
    function GetTeachers(x: Integer): TTeacher;
    function GetTitle(tc: TTableContent): string;
    function GetVisible: boolean;
    function ObrTime(t: Integer): string;
    procedure IncCount;
    procedure SetInTimeTable(const Value: Integer);
    procedure SetKabinets(x: Integer; const Value: TKabinet);
    procedure SetKlass(const Value: TKlass);
    procedure SetNameIndex(const Value: Integer);
    procedure SetTeacherCount(const Value: Integer);
    procedure SetTeachers(x: Integer; const Value: TTeacher);
  protected
    procedure SetIndex(const Value: Integer); override;
    property InTimeTable: Integer read FInTimeTable write SetInTimeTable;
  public
    constructor Create(Names: TSubjNames); reintroduce;
    destructor Destroy; override;
    procedure Add(Teacher: TTeacher; Kabinet: TKabinet);
    procedure Assign(Source: TPersistent); override;
    procedure Clear;
    procedure Delete(x: Integer);
    property Complexion: Integer read FComplexion write FComplexion; {Complexion = 0,1,2 = �������, ���������, ����������}
    property Cross: TCross read GetCross;
    property Info: string read GetInfo;
    property Kabinets[x: Integer]: TKabinet read GeTKabinets write SetKabinets;
    property Klass: TKlass read FKlass write SetKlass;
    property KlassTitle[tc: TTableContent]: string read GetKlassTitle;
    property LessonAtWeek: Integer read FLessonAtWeek write FLessonAtWeek;
    property LongKlassName: string read GetLongKlassName;
    property LongName: string read GetLongName;
    property MultiLine: boolean read FMultiLine write FMultiLine;
    property NameIndex: Integer read FNameIndex write SetNameIndex;
    property SanPIN: Integer read GetSanPIN;
    property ShortName: string read GetShortName;
    property State[Lesson: Integer]: TSubjState read GetState;
    property TeacherCount: Integer read GetTeacherCount write SetTeacherCount;
    property Teachers[x: Integer]: TTeacher read GetTeachers write SetTeachers;
    property Title[tc: TTableContent]: string read GetTitle;
    property Visible: boolean read GetVisible;
    // �������� ������������ � ����� ����������
  end;
 ////////////////////// x //////////////////////
 // TLesson - ***
  TOnChangeLessonIndex = procedure (Sender: TObject; OldIndex: Integer) of object;
  TLesson = class(TSubject)
  private
    FLessonIndex: Integer;
    FParent: TSubject;
    FOnChangeLessonIndex: TOnChangeLessonIndex;
    procedure SetLessonIndex(const Value: Integer);
    procedure SetParent(const Value: TSubject);
    function GetKlass: TKlass;
    function GetNameIndex: Integer;
    procedure SetOnChangeLessonIndex(const Value: TOnChangeLessonIndex);
  public
    constructor Create(AParent: TSubject; ALessonIndex: Integer); 
    property LessonIndex: Integer read FLessonIndex write SetLessonIndex;
    property Parent: TSubject read FParent;
    property Klass:TKlass read GetKlass;
    property NameIndex:Integer read GetNameIndex;
    property OnChangeLessonIndex:TOnChangeLessonIndex read FOnChangeLessonIndex write SetOnChangeLessonIndex;
  end;
 ////////////////////// x //////////////////////
 // TPlainSubjects - ������� ��������� ���������
  TPlainSubjects = class (TColl)
    function GetItem(Index: Integer): TSubject;
    procedure SetItem(Index: Integer; const Value: TSubject);
  public
    constructor Create(AutoIndex: boolean);
    procedure Assign(Source: TPersistent); override;
    property Item[Index: Integer]: TSubject read GetItem write SetItem; default;
  end;
 ////////////////////// x //////////////////////
 // TPlainSubjects - ������� ��������� ���������
  TLessons = class (TColl)
    function GetItem(Index: Integer): TLesson;
    procedure SetItem(Index: Integer; const Value: TLesson);
  private
    FTimeTable: TTimeTable;
    FLessonIndex: Integer;
    procedure ChangeLessonIndex(Sender: TObject; OldIndex: Integer);
  public
    constructor Create(ATimeTable: TTimeTable; ALessonIndex: Integer);
    procedure Assign(Source: TPersistent); override;
    function CreateLesson(Subject: TSubject): TLesson;
    property Item[Index: Integer]: TLesson read GetItem write SetItem; default;
    property TimeTable:TTimeTable read FTimeTable;
    property LessonIndex: Integer read FLessonIndex;
  end;
 ////////////////////// x //////////////////////
 /// TTimeTable - ���������� ����� ����������
 ///   proc Add(LessonIndex, Subject) - ���������� �������� � ����� ����������
 ///   proc Delete(LessonIndex, Kabinet) - �������� ������� �� ��������
 ///   proc Delete(LessonIndex, Klass) - �������� ������� �� ������
 ///   proc Delete(LessonIndex, Subject) - �������� ������� �� ������ �����
 ///   proc Delete(LessonIndex, Teacher) - �������� ������� �� �������
 ///   prop ForKabinet[KabinetIndex, LessonIndex]: TSubs  (R); - ������� � ��������
 ///   prop ForKlasses[KlassIndex, LessonIndex]: TSubject (R); - ������� � ������
 ///   prop ForTeacher[TeacherIndex, LessonIndex]: TSubs  (R); - ������� �������
 ///   prop Subjects: TSubjects (RW); - ���������� � ���������

  TTimeTable = class (TPersistent)
  private
    FSubjects: TSubjects;
    Subjs: TSubs;
    FLessons: array[0..LessCount-1] of TLessons;
    function GetForKabinet(KabinetIndex, LessonIndex: Integer): TSubs;
    function GetForTeacher(TeacherIndex, LessonIndex: Integer): TSubs;
    function GetForKlasses(KlassIndex, LessonIndex: Integer): TSubject;
    procedure ClearSubjs;
    procedure SetSubjects(const Value: TSubjects);
    function GetKlasses: TKlasses;
    function GetLessons(Index: Integer): TLessons;
  protected
    procedure Add2(LessonIndex: Integer; Subject: TSubject);
    procedure Delete2(LessonIndex: Integer; Kabinet: TKabinet); overload;
    procedure Delete2(LessonIndex: Integer; Teacher: TTeacher); overload;
    property Klasses: TKlasses read GetKlasses;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(LessonIndex: Integer; Subject: TSubject);
    procedure Delete(LessonIndex: Integer; Kabinet: TKabinet); overload;
    procedure Delete(LessonIndex: Integer; Klass: TKlass); overload;
    procedure Delete(LessonIndex: Integer; Lesson: TLesson); overload;
    procedure Delete(LessonIndex: Integer; Subject: TSubject); overload;
    procedure Delete(LessonIndex: Integer; Teacher: TTeacher); overload;
    property ForKabinet[KabinetIndex, LessonIndex: Integer]: TSubs read GetForKabinet;
    property ForKlasses[KlassIndex, LessonIndex: Integer]: TSubject read GetForKlasses;
    property ForTeacher[TeacherIndex, LessonIndex: Integer]: TSubs read GetForTeacher;
    property Subjects: TSubjects read FSubjects write SetSubjects;
    property Lessons[Index:Integer]: TLessons read GetLessons;
  end;
 ////////////////////// x //////////////////////
 // TSubjects - ���������� � ���� ���������
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
    function GetSubject(x: Integer): TSubject;
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
    procedure SetSubject(x: Integer; const Value: TSubject);
    function GetAsJsonObject: ISuperObject;
    procedure SetAsJsonObject(const Value: ISuperObject);
    //
    procedure Load(srBig: TStream; var Key: string; var srSmall: TStream);
    procedure Save(srBig: TStream; Key: string; srSmall: TStream);
  public
    constructor Create;
    destructor Destroy; override;
    function Add(Subject: TSubject): Integer; overload;
    function Add: TSubject; overload;
    function IsCross(subj1, subj2: TSubject): boolean;
    procedure Clear;
    procedure Delete(Subject: TSubject); overload;
    procedure Delete(Index: Integer); overload;
    procedure LoadFromFile(FN: string);
    procedure LoadFromTextFile(FN: string);
    procedure SaveToFile(FN: string);
    procedure SaveToTextFile(FN: string);
    property AsJsonObject: ISuperObject read GetAsJsonObject write SetAsJsonObject;
    property ColumnMode: TColumnMode read FColumnMode write FColumnMode;
    property FullView: boolean read FFullView write FFullView;
    property Item[Index: Integer]: TSubject read GetSubject write SetSubject; default;
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
function FromName(Long, Short: string; Pin: Integer): string;

implementation

uses DateUtils, Math, StrUtils;
//////////////////////////////////////////////////
                  { TSubjNames }
//////////////////////////////////////////////////
{private}
function TSubjNames.GetLongName(Index: Integer): string;
begin
  Result := '';
  if (Index < 0) or (Index > MaxInd) then
    Exit;
  Result := ToName(Strings[Index]).Long;
end;

function TSubjNames.GetMaxInd: Integer;
begin
  Result := Count - 1;
end;

function TSubjNames.GetSanPIN(Index: Integer): Integer;
begin
  Result := 0;
  if (Index < 0) or (Index > MaxInd) then
    Exit;
  Result := ToName(Strings[Index]).Pin;
end;

function TSubjNames.GetShortName(Index: Integer): string;
begin
  Result := '';
  if (Index < 0) or (Index > MaxInd) then
    Exit;
  Result := ToName(Strings[Index]).Short;
end;

procedure TSubjNames.SetAsJsonObject(const Value: ISuperObject);
var
  I: Integer;
  supNames: TSuperArray;
  supSubjName: ISuperObject;
begin
  Clear;
  supNames := Value.A['Items'];
  for I := 0 to supNames.Length - 1 do begin
    supSubjName := supNames[I];
    Add(supSubjName.S['LongName'], supSubjName.S['ShortName'], supSubjName.I['SanPIN']);
  end;
end;

procedure TSubjNames.SetLongName(Index: Integer; const Value: string);
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

procedure TSubjNames.SetSanPIN(Index: Integer; const Value: Integer);
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

procedure TSubjNames.SetShortName(Index: Integer; const Value: string);
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
  I: Integer;
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
  I: Integer;
  supNames: TSuperArray;
  supSubjName: ISuperObject;
begin
  Result := SO;
  Result.I['Count'] := Count;
  Result.O['Items'] := SO('[]');
  supNames := Result.A['Items'];
  for I := 0 to Count - 1 do begin
    supSubjName := SO;
    supSubjName.S['LongName'] := LongName[I];
    supSubjName.S['ShortName'] := ShortName[I];
    supSubjName.I['SanPIN'] := SanPIN[I];
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

function TSubjNames.Add(Long, Short: string; PIN: Integer): Integer;
var
  I, x: Integer;
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
  I: Integer;
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

function TSimpleItem.GetLessons: TPlainSubjects;
begin
  Result := FLessons;
end;

{public}
constructor TSimpleItem.Create;
begin
  inherited;
  FName := '';
  FSubjects := TPlainSubjects.Create(false);
  FLessons := TPlainSubjects.Create(false);
  FChecked := True;
  FLock := [];
  FCross := [];
end;

destructor TSimpleItem.Destroy;
begin
  FSubjects.Free;
  FLessons.Free;
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

procedure TSimpleItem.SwitchLock(LessonIndex: Integer);
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
end;

destructor TRefItem.Destroy;
begin
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
function TKlass.GetWDSanPIN(WD: Integer): Real;
begin
  Result := 0;
  if FMaxSanPIN = 0 then
    Exit;
  Result := FWDSanPIN[wd] / FMaxSanPIN;
end;

procedure TKlass.FindMaxSanPIN;
var
  I: Integer;
begin
  FMaxSanPIN := 0;
  for I := 0 to WDCount - 1 do
    if FMaxSanPIN < FWDSanPIN[I] then
      FMaxSanPIN := FWDSanPIN[I];
end;

{public}
constructor TKlass.Create;
//var
//  I: Integer;
begin
  inherited;
  FTeachers := TTeachers.Create(false);
  FKabinets := TKabinets.Create(false);
//  for I := 0 to LessCount - 1 do
//    FLesson[I] := nil;
end;

destructor TKlass.Destroy;
begin
  FTeachers.Free;
  FKabinets.Free;
  inherited;
end;

procedure TKlass.Assign(Source: TPersistent);
//var
//  I: Integer;
begin
  if Source is TKlass then
    with TKlass(Source) do begin
      self.FName := Name;
      self.FKabinets.Assign(Kabinets);
      self.FSubjects.Assign(Subjects);
      self.FChecked := Checked;
      self.FLock := Lock;
      self.FCross := Cross;
//      for I := 0 to LessCount - 1 do
//        self.FLesson[I] := LessAbs[I];
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
  I: Integer;
begin
  if Source is TKabinet then
    with TKabinet(Source) do begin
      self.FName := Name;
      self.FNum := Num;
      self.FKlasses.Assign(Klasses);
      self.FTeachers.Assign(Teachers);
      // ����� ������� ������
      self.FSubjects.Assign(Subjects);

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
  p: Integer;
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
  I: Integer;
begin
  if Source is TTeacher then
    with TTeacher(Source) do begin
      self.FName := Name;
      self.FKabNum := KabNum;
      self.FKabinets.Assign(Kabinets);
      self.FKlasses.Assign(Klasses);
      self.FSubjects.Assign(Subjects);
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
function TKlasses.GetFullKlassName(x: Integer): string;
begin
  Result := '';
  if (x < 0) or (x > MaxInd) then
    Exit;
  if FormatString = '' then
    Result := item[x].Name;
  Result := format(FormatString, [item[x].Name]);
end;

function TKlasses.GetItem(Index: Integer): TKlass;
begin
 // �����
 ////////////////////////////////////////
 // ����� ��������� ��������� �� ��������
  Result := TKlass(inherited GetItem(Index));
end;

procedure TKlasses.SetAsJsonObject(const Value: ISuperObject);
var
  I: Integer;
  supKlasses: TSuperArray;
  supKlass: ISuperObject;
  Klass: TKlass;
begin
  Clear(True);
  FormatString := Value.S['FormatString'];
  supKlasses := Value.A['Items'];
  for I := 0 to supKlasses.Length - 1 do begin
    supKlass := supKlasses[I];
    Klass := AddNewItem;
    Klass.Name := supKlass.S['Name'];
    Klass.Lock := StringAsCross(supKlass.S['Lock']);
    Klass.Checked := supKlass.B['Checked'];
  end;
end;

procedure TKlasses.SetFormatString(const Value: string);
begin
 // ��� ������ �������� ������ �� �����
  if pos('%s', Value) = 0 then
    FFormatString := '%s'
  else
    FFormatString := Value;
end;

procedure TKlasses.SetItem(Index: Integer; const Value: TKlass);
begin
 // �������� ���������� � ������
 ////////////////////////////////////////
 // ����� ��������� ��������� �� ��������
  inherited SetItem(Index, Value);
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

function TKlasses.IndexOf(Name: string): Integer;
var
  I: Integer;
begin
 // ����� ����� �� ��������
 ////////////////////////////////////////
 // ����� ��������� ��������� �� ��������
  Result := -1;
  for I := 0 to MaxInd do
    if SameText(Item[I].Name, Name) then begin
      Result := I;
      Exit;
    end;
end;

function TKlasses.Lines(short: boolean): TStrings;
var
  I: Integer;
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
  I: Integer;
  supKlasses: TSuperArray;
  supKlass: ISuperObject;
begin
  Result := SO;
  Result.S['FormatString'] := FormatString;
  Result.I['Count'] := Count;
  Result.O['Items'] := SO('[]');
  supKlasses := Result.A['Items'];
  for I := 0 to Count - 1 do begin
    supKlass := SO;
    supKlass.S['Name'] := Item[I].Name;
    supKlass.S['Lock'] := CrossAsString(Item[I].Lock);
    supKlass.B['Checked'] := Item[I].Checked;
    supKlasses.Add(supKlass);
  end;
end;

procedure TKlasses.Assign(Source: TPersistent);
var
  Klasses: TKlasses;
  I: Integer;
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
function TKabinets.GetItem(Index: Integer): TKabinet;
begin
  Result := TKabinet(inherited GetItem(Index));
end;

procedure TKabinets.SetAsJsonObject(const Value: ISuperObject);
var
  I: Integer;
  supKabinets: TSuperArray;
  supKabinet: ISuperObject;
  Kabinet: TKabinet;
begin
  Clear(True);
  supKabinets := Value.A['Items'];
  for I := 0 to supKabinets.Length - 1 do begin
    supKabinet := supKabinets[I];
    if supKabinet.I['Num'] = -1 then
      Continue;
    Kabinet := AddNewItem;
    Kabinet.Name := supKabinet.S['Name'];
    Kabinet.Num := supKabinet.I['Num'];
    Kabinet.Lock := StringAsCross(supKabinet.S['Lock']);
    Kabinet.Checked := supKabinet.B['Checked'];
    Kabinet.ShowNum := supKabinet.B['ShowNum'];
  end;
end;

procedure TKabinets.SetItem(Index: Integer; const Value: TKabinet);
begin
  inherited SetItem(Index, Value);
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

function TKabinets.IndexOf(Num: Integer): Integer;
var
  I: Integer;
begin
 // ����� ������� �� ��� ����������� ������
  Result := -1;
  for I := 0 to MaxInd do
    if Item[I].Num = Num then begin
      Result := I;
      Exit;
    end;
end;

function TKabinets.Lines(Short: boolean): TStrings;
var
  I: Integer;
begin
  sts.Clear;
  for I := 0 to MaxInd do
    if Short then
      sts.AddObject(Item[I].Name, FItem[I])
    else
      sts.AddObject(Item[I].FullName, FItem[I]);
  Result := sts;
end;

function TKabinets.GetAsJsonObject: ISuperObject;
var
  I: Integer;
  supKabinets: TSuperArray;
  supKabinet: ISuperObject;
begin
  Result := SO;
  Result.I['Count'] := Count;
  Result.O['Items'] := SO('[]');
  supKabinets := Result.A['Items'];
  for I := 0 to Count - 1 do begin
    supKabinet := SO;
    supKabinet.S['Name'] := Item[I].Name;
    supKabinet.I['Num'] := Item[I].Num;
    supKabinet.S['Lock'] := CrossAsString(Item[I].Lock);
    supKabinet.B['Checked'] := Item[I].Checked;
    supKabinet.B['ShowNum'] := Item[I].ShowNum;
    supKabinets.Add(supKabinet);
  end;
end;

procedure TKabinets.Assign(Source: TPersistent);
var
  kabs: TKabinets;
  I: Integer;
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
  AK: TKabinet;
begin
  AK := nil;
  if AutoFree then begin
    AK := TKabinet.Create;
    AK.Assign(AnyKabinet);
  end;
  inherited;
  if AutoFree then
    AnyKabinet := AK;
  Add(AnyKabinet);
end;

//////////////////////////////////////////////////
                  { TTeachers }
//////////////////////////////////////////////////
{private}
function TTeachers.GetItem(x: Integer): TTeacher;
begin
 // �������������
  Result := TTeacher(inherited Item[x]);
end;

procedure TTeachers.SetAsJsonObject(const Value: ISuperObject);
var
  I: Integer;
  supTeachers: TSuperArray;
  supTeacher: ISuperObject;
  Teacher: TTeacher;
begin
  Clear(True);
  supTeachers := Value.A['Items'];
  for I := 0 to supTeachers.Length - 1 do begin
    Teacher := AddNewItem;
    supTeacher := supTeachers[I];
    Teacher.Name := supTeacher.S['Name'];
    Teacher.KabNum := supTeacher.I['KabNum'];
    Teacher.Lock := StringAsCross(supTeacher.S['Lock']);
    Teacher.Checked := supTeacher.B['Checked'];
  end;
end;

procedure TTeachers.SetItem(x: Integer; const Value: TTeacher);
begin
 // �������� ������ �������������
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

function TTeachers.IndexOf(Name: string): Integer;
var
  I: Integer;
begin
 // ����� ������������� �� ���
  Result := -1;
  for I := 0 to MaxInd do
    if SameText(Item[I].name, Name) then begin
      Result := I;
      Exit;
    end;
end;

function TTeachers.Lines(Short: boolean): TStrings;
var
  I: Integer;
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
  I: Integer;
  supTeachers: TSuperArray;
  supTeacher: ISuperObject;
begin
  Result := SO;
  Result.I['Count'] := Count;
  Result.O['Items'] := SO('[]');
  supTeachers := Result.A['Items'];
  for I := 0 to Count - 1 do
    with Item[I] do begin
      supTeacher := SO;
      supTeacher.S['Name'] := Name;
      supTeacher.I['KabNum'] := KabNum;
      supTeacher.S['Lock'] := CrossAsString(Lock);
      supTeacher.B['Checked'] := Checked;
      supTeachers.Add(supTeacher);
    end;
end;

procedure TTeachers.Assign(Source: TPersistent);
var
  Teachers: TTeachers;
  I: Integer;
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
  I: Integer;
begin
 //////////////////////////////////////////////////
 // ����� ��������� ��������� �� ��������
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
  I: Integer;
begin
 // �������� ���������� � �������� � ���� ����� ������
  Result := '';
  st := '������ ������';
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
      s := '  ||   ���.:' + s;
    st := st + s;
  end;
  Result := st;
end;

function TSubject.GetKabinets(x: Integer): TKabinet;
begin
 // ������ ��������� � ������� ���������� ����
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

function TSubject.GetSanPIN: Integer;
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
  I: Integer;
begin
  Result := [];
  if (Lesson < 0) or (Lesson > LessCount - 1) then
    Exit;
  if InTimeTable >= LessonAtWeek then
    Result := [teTime];
  for I := 0 to TeacherCount - 1 do begin
    if (Teachers[I] <> nil) and (Lesson in Teachers[I].Cross) then
      Result := Result + [teTeachers];
    if (Kabinets[I] <> nil) and (Lesson in Kabinets[I].Cross) then
      Result := Result + [teKabinets];
  end;
  if Lesson in Klass.Cross then
    Result := Result + [teKlass];
end;

function TSubject.GetTeacherCount: Integer;
begin
 // �����
  Result := MaxInd + 1;
end;

function TSubject.GetTeachers(x: Integer): TTeacher;
begin
 // ������ �������� ������� �������� ����
  Result := nil;
  if (x < 0) or (x > MaxInd) or (x >= Length(FTeachers)) then
    Exit;
  Result := FTeachers[x];
end;

function TSubject.GetTitle(tc: TTableContent): string;
var
  I: Integer;
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

function TSubject.ObrTime(t: Integer): string;
var
  s: Integer;
  st: string;
begin
 // �������� ����� �� ������
 //////////////////////////////////////////////////
 // ����� ��������� ��������� �� ��������
  s := t;
  if s in [10..19] then
    s := 0;
  case (S + 9) mod 10 + 1 of
    1:
      st := '';
    2..4:
      st := '�';
    5..10:
      st := '��';
  end;
  Result := IntToStr(t) + ' ���' + st;
end;

procedure TSubject.incCount;
begin
 // ����� ������� � �������������
  inc(MaxInd);
  SetLength(FKabinets, MaxInd + 1);
  SetLength(FTeachers, MaxInd + 1);
end;

procedure TSubject.SetInTimeTable(const Value: Integer);
begin
  FInTimeTable := Value;
end;

procedure TSubject.SetKabinets(x: Integer; const Value: TKabinet);
begin
 // ������ ������ ��������� � ������� �������� ����
  if (x < 0) or (x > MaxInd) or (x >= Length(FKabinets)) then
    Exit;
  if FKabinets[x] <> nil then
    FKabinets[x].Subjects.Delete(self);
  FKabinets[x] := Value;
  if ItemIndex = -1 then
    Exit;
  if FKabinets[x] <> nil then
    FKabinets[x].Subjects.Add(self);
end;

procedure TSubject.SetKlass(const Value: TKlass);
begin
  if FKlass <> nil then begin
    if self is TLesson then
      FKlass.Lessons.Delete(self)
    else
      FKlass.Subjects.Delete(self);
  end;
  FKlass := Value;
  if ItemIndex = -1 then
    Exit;
  if FKlass <> nil then begin
    if self is TLesson then
      FKlass.Lessons.Add(self)
    else
      FKlass.Subjects.Add(self);
  end;
end;

procedure TSubject.SetNameIndex(const Value: Integer);
begin
  FNameIndex := Value;
end;

procedure TSubject.SetTeacherCount(const Value: Integer);
begin
 // ������ ���������� ��������,������� ����� ���� �������
  MaxInd := Value - 1;
end;

procedure TSubject.SetTeachers(x: Integer; const Value: TTeacher);
begin
 // ������ ������ ��������, ������� ����� ���� �������
  if (x < 0) or (x > MaxInd) or (x >= Length(FTeachers)) then
    Exit;
  if FTeachers[x] <> nil then
    FTeachers[x].Subjects.Delete(self);
  FTeachers[x] := Value;
  if ItemIndex = -1 then
    Exit;
  if FTeachers[x] <> nil then
    FTeachers[x].Subjects.Add(self);
end;

procedure TSubject.SetIndex(const Value: Integer);
var
  I: Integer;
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
 // �������� ������ ��������
  inherited Create;
  FNames := Names;
  FInTimeTable := 0;
  Clear;
end;

destructor TSubject.Destroy;
begin
  inherited;
end;

procedure TSubject.Add(Teacher: TTeacher; Kabinet: TKabinet);
begin
 // ���������� �������� � ������������� � ������
  incCount;
  FKabinets[MaxInd] := nil;
  FTeachers[MaxInd] := nil;
  Kabinets[MaxInd] := Kabinet;
  Teachers[MaxInd] := Teacher;
end;

procedure TSubject.Assign(Source: TPersistent);
var
  I: Integer;
begin
  if Source is TSubject then
    with TSubject(Source) do begin
      self.Clear;
      for I := 0 to TeacherCount - 1 do
        self.Add(Teachers[I], Kabinets[I]);
      self.Klass := Klass;
      self.LessonAtWeek := LessonAtWeek;
      self.Complexion := Complexion;
      self.NameIndex := NameIndex;
      self.FNames:=TSubject(Source).FNames;
    end
  else
    inherited Assign(Source);
end;

procedure TSubject.Clear;
var
  I, l: Integer;
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
end;

procedure TSubject.Delete(x: Integer);
var
  I: Integer;
begin
 // �������� �������� � ������������� �� ������
 //////////////////////////////////////////////////
 // ����� ��������� ��������� �� ��������
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
function TPlainSubjects.GetItem(Index: Integer): TSubject;
begin
  Result := TSubject(inherited GetItem(Index));
end;

procedure TPlainSubjects.SetItem(Index: Integer; const Value: TSubject);
var
  ind: Integer;
begin
  ind := -1;
  if Value <> nil then
    ind := Value.ItemIndex;
  inherited SetItem(Index, Value);
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
  I: Integer;
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
  LessonIndex: Integer): TSubs;
var
  I, j, n: Integer;
  subj: TLesson;
begin
  /// 20-04-2012
  ///  ��������� ��� ������. ���� � ������(��) ���� �������
  ///  � ��� �����, �� ������ ������ ��� �������, � �������
  ///  ���� ������ �������������

  n := 0;
  ClearSubjs;
  for I := 0 to Lessons[LessonIndex].Count - 1 do begin
    Subj := Lessons[LessonIndex][I];
    if Subj = nil then
      Continue;
    if Subj.LessonIndex <> LessonIndex then
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
  LessonIndex: Integer): TSubs;
var
  I, J, n: Integer;
  Subj: TLesson;
begin
  /// ��. �������� � GetForKabinet
  ///  24.04.2012
  ///  ��������� ����������� �� ����������
  n := 0;
  ClearSubjs;
  for I := 0 to Lessons[LessonIndex].Count - 1 do begin
    Subj := Lessons[LessonIndex][I];
    if Subj = nil then
      Continue;
    if Subj.LessonIndex <> LessonIndex then
      Continue;
    for j := 0 to Subj.TeacherCount - 1 do
      if Subj.Teachers[j].ItemIndex = TeacherIndex then begin
        SetLength(Subjs, n + 1);
        Subjs[n] := TSubject.Create(FSubjects.SubjectNames);
        Subjs[n].Assign(Subj);
        inc(n);
      end;
  end;
  Result := Subjs;
end;

function TTimeTable.GetForKlasses(KlassIndex, LessonIndex: Integer): TSubject;
var
//  Klass: TKlass;
  I: Integer;
begin
  /// 24.04.2012
  ///  ����� ������ ������ � ���, �.�. ������� ���������

  Result := nil;
  if Subjects = nil then
    Exit;
  if (LessonIndex < 0) or (LessonIndex > LessCount - 1) then
    Exit;
  for I := 0 to Lessons[LessonIndex].Count - 1 do begin
    if Lessons[LessonIndex][I].Klass.ItemIndex <> KlassIndex then
      Continue;
    Result := Lessons[LessonIndex][I];
    break;
  end;
end;

function TTimeTable.GetKlasses: TKlasses;
begin
  Result := nil;
  if FSubjects = nil then
    Exit;
  Result := FSubjects.Klasses;
end;

function TTimeTable.GetLessons(Index: Integer): TLessons;
begin
  Result:=nil;
  if OutSide(Index,LessCount) then Exit;
  Result:=FLessons[Index];
end;

procedure TTimeTable.Add2(LessonIndex: Integer; Subject: TSubject);
var
  I: Integer;
begin
 // ����� ��� ���������� ������ ���������
  if Subjects = nil then
    Exit;
 // ����� ���� ������ ���������
  if Subject = nil then
    Exit;
  with Subject do begin
  // ����� ���� �� �������� ����� ������������ ��������
    if Klass = nil then
      Exit;
  // ��������� ����� ����� �������� � ����������
    InTimeTable := InTimeTable + 1;
  // ������ ������� ���������� �������� � ����� ����������
    /// 24.04.2012 old -> Klass.LessAbs[LessonIndex] := Subject;
  // �������� ����� ����� ��� �������
    Klass.Cross := Klass.Cross + [LessonIndex];
  // ��������� �� �� ����� ������ �������� � ���������
    for I := 0 to TeacherCount - 1 do begin
      Teachers[I].IncCross(LessonIndex);
      Kabinets[I].IncCross(LessonIndex);
    end;
  end;
end;

procedure TTimeTable.ClearSubjs;
var
  I: Integer;
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
var
  I: Integer;
begin
  SetLength(Subjs, 0);
  for I := 0 to LessCount - 1 do
    FLessons[I] := TLessons.Create(self, I);
end;

destructor TTimeTable.Destroy;
var
  I: Integer;
begin
  ClearSubjs;
  for I := 0 to LessCount - 1 do
    FLessons[I].Free;
  inherited;
end;

procedure TTimeTable.Add(LessonIndex: Integer; Subject: TSubject);
var
  I: Integer;
begin
 // ����� ���� ������ ���������
  if Subject = nil then
    Exit;
  // ����� ���� �� �������� ����� ������������ ��������
  if Subject.Klass = nil then
    Exit;
  // ����� ���� ������� �� ��� �� ����
  if Subject.TeacherCount=0 then Exit;

  // ��������� ����� ����� �������� � ����������
  Subject.InTimeTable := Subject.InTimeTable + 1;

  // �������� ����� ����� ��� �������
  Subject.Klass.Cross := Subject.Klass.Cross + [LessonIndex];
  // ��������� �� �� ����� ������ �������� � ���������
  for I := 0 to Subject.TeacherCount - 1 do begin
    Subject.Teachers[I].IncCross(LessonIndex);
    Subject.Kabinets[I].IncCross(LessonIndex);
  end;
  FLessons[LessonIndex].CreateLesson(Subject);
end;

procedure TTimeTable.Delete(LessonIndex: Integer; Kabinet: TKabinet);
begin
end;

procedure TTimeTable.Delete(LessonIndex: Integer; Klass: TKlass);
var
  Subj: TSubject;
begin
  Subj := ForKlasses[Klass.ItemIndex, LessonIndex];
  Delete(LessonIndex, Subj);
end;

procedure TTimeTable.Delete(LessonIndex: Integer; Subject: TSubject);
var
  I: Integer;
  Lesson: TLesson;
begin
  if Subject = nil then
    Exit;
  Lesson := nil; 
  for I := 0 to Lessons[LessonIndex].Count - 1 do
    if Lessons[LessonIndex][I].Parent = Subject then
      Lesson := Lessons[LessonIndex][I];
  Delete(LessonIndex, Lesson);
end;

procedure TTimeTable.Delete(LessonIndex: Integer; Teacher: TTeacher);
begin
end;

procedure TTimeTable.Delete(LessonIndex: Integer; Lesson: TLesson);
var
  I: Integer;
  Subject: TSubject;
begin
  if Lesson = nil then
    Exit;
  Subject := Lesson.Parent;
  with Subject do begin
    if Klass = nil then
      Exit;
    InTimeTable := InTimeTable - 1;
    for I := 0 to TeacherCount - 1 do begin
      Teachers[I].DecCross(LessonIndex);
      Kabinets[I].DecCross(LessonIndex);
    end;
  end;
  Lessons[LessonIndex].Delete(Lesson, True);
end;

//procedure TTimeTable.Delete2(LessonIndex: Integer; Klass: TKlass);
//begin
//  Delete(LessonIndex, Klass.LessAbs[LessonIndex]);
//end;

procedure TTimeTable.Delete2(LessonIndex: Integer; Kabinet: TKabinet);
begin
end;

procedure TTimeTable.Delete2(LessonIndex: Integer; Teacher: TTeacher);
begin
end;

//procedure TTimeTable.Delete2(LessonIndex: Integer; Subject: TSubject);
//var
//  I, KlassIndex: Integer;
//begin
//  if Subject = nil then
//    Exit;
//  with Subject do begin
//    if Klass = nil then
//      Exit;
//    KlassIndex := Klass.ItemIndex;
//    InTimeTable := InTimeTable - 1;
//    for I := 0 to TeacherCount - 1 do begin
//      Teachers[I].TimeTableX.Klasses[LessonIndex].Delete(KlassIndex);
//      Teachers[I].DecCross(LessonIndex);
//      Kabinets[I].TimeTableX.Klasses[LessonIndex].Delete(KlassIndex);
//      Kabinets[I].DecCross(LessonIndex);
//    end;
//    Klass.LessAbs[LessonIndex] := nil;
//  end;
//end;

//////////////////////////////////////////////////
                { TSubjects }
//////////////////////////////////////////////////
{private}
function TSubjects.GetSubject(x: Integer): TSubject;
begin
 // ������ ������� �� ������
 //////////////////////////////////////////////////
 // ����� ��������� ��������� �� ��������
  Result := GetItem(x) as TSubject;
end;

function TSubjects.LoadKabinets(sr: TStream): boolean;
var
  ms: TMemoryStream;
  I, n, p: Integer;
  xr: TCross;
  b: Boolean;
  Key: string;
  Kabinet: TKabinet;
begin
  ms := TMemoryStream.Create;
  p := sr.Position;
  Load(sr, Key, TStream(ms));
  Result := Key = '��������';
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
  I, p, n: Integer;
  xr: TCross;
  b: Boolean;
  Klass: TKlass;
  Key: string;
begin
  ms := TMemoryStream.create;
  p := sr.Position;
  Load(sr, Key, TStream(ms));
  Result := Key = '������';
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
  p: Integer;
begin
  ms := tMemoryStream.Create;
  Load(sr, Key, TStream(ms));
  p := sr.Position;
  Result := Key = '�������� ���������';
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
  I, j, n, bs, xs: Integer;
 //xset:Integer;
  ms: TMemoryStream;
  Key: string;
  p: Integer;
  Subject: TSubject;
  teacher: TTeacher;
  kabinet: TKabinet;
begin
  bs := SizeOf(boolean);
  xs := SizeOf(TCross);
  ms := TMemoryStream.Create;
  p := sr.Position;
  Load(sr, Key, TStream(ms));
  Result := Key = '��������';
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
          if (teacher = nil) or (kabinet = nil) then
            Continue;
          Add(teacher, kabinet);
        end;
        Read(FComplexion, 4);
        Read(FLessonAtWeek, 4);
        Read(FNameIndex, 4);
        Read(FMultiLine, bs);
        // Read(FParent, 4);
      end;
      Add(Subject);
    end;
    Free;
  end;
end;

function TSubjects.LoadTeachers(sr: TStream): boolean;
var
  ms: TMemoryStream;
  I, p, n: Integer;
  xr: TCross;
  b: Boolean;
  Teacher: TTeacher;
  Key: string;
begin
  ms := TMemoryStream.create;
  p := sr.Position;
  Load(sr, Key, TStream(ms));
  Result := Key = '�������';
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
  I, n: Integer;
  xr: TCross;
  b: Boolean;
begin
  ms := TMemoryStream.Create;
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
  Save(sr, '��������', ms);
  ms.Free;
end;

procedure TSubjects.SaveKlasses(sr: TStream);
var
  ms: TMemoryStream;
  I: Integer;
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
  Save(sr, '������', ms);
  ms.Free;
end;

procedure TSubjects.SaveSubjectNames(sr: TStream);
var
  ms: TMemoryStream;
begin
  ms := tMemoryStream.Create;
  FSubjectNames.SaveToStream(ms);
  Save(sr, '�������� ���������', ms);
  ms.Free;
end;

procedure TSubjects.SaveSubjects(sr: TStream);
var
  I, j, n, bs, xs: Integer;
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
        // Write(FParent, 4);
      end;
    Save(sr, '��������', ms);
    Free;
  end;
end;

procedure TSubjects.SaveTeachers(sr: TStream);
var
  ms: TMemoryStream;
  I, n: Integer;
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
  Save(sr, '�������', ms);
  ms.Free;
end;

procedure TSubjects.SaveTimeTable(sr: TStream);
begin

end;

procedure TSubjects.SetAsJsonObject(const Value: ISuperObject);
var
  I, J: Integer;
  supSubjects: TSuperArray;
  supTeachKabs: TSuperArray;
  supSubject: ISuperObject;
  supTeachKab: ISuperObject;
  Subject: TSubject;
  Kabinet: TKabinet;
  Teacher: TTeacher;
begin
  Clear;
  Klasses.AsJsonObject := Value.O['Klasses'];
  Kabinets.AsJsonObject := Value.O['Kabinets'];
  Teachers.AsJsonObject := Value.O['Teachers'];
  SubjectNames.AsJsonObject := Value.O['SubjectNames'];
  FViewMode := TViewMode(Value.I['ViewMode']);
  FColumnMode := TColumnMode(Value.I['ColumnMode']);
  FTableContent := TTableContent(Value.I['TableContent']);
  FWeekDays := StringAsWeekDays(Value.S['WeekDays']);
  FLessons := StringAsCross(Value.S['Lessons']);
  FFullView := Value.B['FullView'];
  supSubjects := Value.A['Items'];
  for I := 0 to supSubjects.Length - 1 do begin
    Subject := Add;
    supSubject := supSubjects[I];
    Subject.Klass := Klasses[supSubject.I['KlassIndex']];
    supTeachKabs := supSubject.A['Items'];
    for J := 0 to supTeachKabs.Length - 1 do begin
      supTeachKab := supTeachKabs[J];
      Teacher := Teachers[supTeachKab.I['TeacherIndex']];
      Kabinet := Kabinets[supTeachKab.I['KabinetIndex']];
      Subject.Add(Teacher, Kabinet);
    end;
    Subject.FComplexion := supSubject.I['Complexion'];
    Subject.FLessonAtWeek := supSubject.I['LessonAtWeek'];
    Subject.FNameIndex := supSubject.I['NameIndex'];
    Subject.FMultiLine := supSubject.B['MultiLine'];
  end;
end;

procedure TSubjects.SetSubject(x: Integer; const Value: TSubject);
begin
 // ��������� ��������
 // ������ ����������� ������� �������� � ��������� ����������� ������ ��������
 //////////////////////////////////////////////////
 // ����� ��������� ��������� �� ��������
  SetItem(x, Value);
end;

{public}
constructor TSubjects.Create;
begin
 // �������� ������� ������ ���������
 //////////////////////////////////////////////////
 // ����� ��������� ��������� �� ��������
  inherited Create(True);
  FFullView := True;
 // ��������� ������
  FSubjectNames := TSubjNames.Create;
  FTimeTable := TTimeTable.Create;
  FKabinets := TKabinets.Create(True);
  FKlasses := TKlasses.Create(True);
  FTeachers := TTeachers.Create(True);
 //
  FKlasses.FormatString := '%s �����';
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
 // ����� ��������� ��������� �� ��������
  Clear;
  FTimeTable.Free;
  FKlasses.Free;
  FTeachers.Free;
  FKabinets.Free;
  FSubjectNames.Free;
  inherited;
end;

function TSubjects.Add(Subject: TSubject): Integer;
begin
 // ���������� �������� � ������ � ��������� ������������
 // ���������� ����������� �� ������, �������������� � ���������
 //////////////////////////////////////////////////
 // ����� ��������� ��������� �� ��������
  Result := Subject.ItemIndex;
  if Result <> -1 then
    if Item[Result] = Subject then
      Exit;
  Result := inherited Add(Subject);
end;

function TSubjects.Add: TSubject;
begin
 // ���������� ����� ��� �������.
 // ��� �������� � ���� ����������� �������� �����.
 //////////////////////////////////////////////////
 // ����� ��������� ��������� �� ��������
  Result := TSubject.Create(FSubjectNames);
  Add(Result);
end;

function TSubjects.GetAsJsonObject: ISuperObject;
var
  I, J, N: Integer;
  supSubjects: TSuperArray;
  supTeachKabs: TSuperArray;
  supSubject: ISuperObject;
  supTeachKab: ISuperObject;
begin
  Result := SO;
  Result.O['Klasses'] := Klasses.GetAsJsonObject;
  Result.O['Kabinets'] := Kabinets.GetAsJsonObject;
  Result.O['Teachers'] := Teachers.GetAsJsonObject;
  Result.O['SubjectNames'] := SubjectNames.AsJsonObject;
  Result.S['ViewModeComment'] := '0,1,2,3 = ��������, ���������, ��� ������, ������ ������';
  Result.S['ColumnModeComment'] := '0,1,2 = ������, �������, ��������';
  Result.S['TableContentComment'] := '0,1,2 = ��������, �������, ��������';
  Result.S['ComplexionComment'] := '0,1,2 = �������, ���������, ����������';
  Result.I['ViewMode'] := ord(FViewMode);
  Result.I['ColumnMode'] := ord(FColumnMode);
  Result.I['TableContent'] := ord(FTableContent);
  Result.S['WeekDays'] := WeekDaysAsString(FWeekDays);
  Result.S['Lessons'] := CrossAsString(FLessons);
  Result.B['FullView'] := FFullView;
  Result.I['Count'] := Count;
  Result.O['Items'] := SO('[]');
  supSubjects := Result.A['Items'];
  for I := 0 to MaxInd do
    with Item[I] do begin
      supSubject := SO;
      if Klass = nil then
        N := -1
      else
        N := Klass.ItemIndex;
      supSubject.I['KlassIndex'] := N;
      supSubject.I['TeacherCount'] := TeacherCount;
      supSubject.O['Items'] := SO('[]');
      supTeachKabs := supSubject.A['Items'];
      for J := 0 to TeacherCount - 1 do begin
        supTeachKab := SO;
        if Teachers[J] = nil then
          N := -1
        else
          N := Teachers[J].ItemIndex;
        supTeachKab.I['TeacherIndex'] := N;

        if Kabinets[J] = nil then
          N := -1
        else
          N := Kabinets[J].ItemIndex;
        supTeachKab.I['KabinetIndex'] := N;
        supTeachKabs.Add(supTeachKab);
      end;
      supSubject.I['Complexion'] := FComplexion;
      supSubject.I['LessonAtWeek'] := FLessonAtWeek;
      supSubject.I['NameIndex'] := FNameIndex;
      supSubject.B['MultiLine'] := FMultiLine;
      supSubject.I['OriginalSubjectIndex'] := 0;
      supSubjects.Add(supSubject);
    end;
end;

function TSubjects.IsCross(subj1, subj2: TSubject): boolean;
var
  I, j: Integer;
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
  I: Integer;
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
 // ������� ��� ���������� � �������� � ������ ������.
 // ������� ������� �� ������.
 //////////////////////////////////////////////////
 // ����� ��������� ��������� �� ��������
  if (Index < 0) or (Index > MaxInd) then
    Exit;
  Delete(item[Index]);
end;

procedure TSubjects.Load(srBig: TStream; var Key: string;
  var srSmall: TStream);
var
  l: Integer;
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
 // �������� ������ �� �����. � ��� ����� �������������, �������� � ������
 // TODO 3: LoadFromFile (���������� ��������� Current-������)
  if not FileExists(FN) then begin
    ShowMessage('���� �� ����������');
    Exit;
  end;
  Clear;
  fs := TFileStream.Create(FN, fmOpenRead);
  repeat
    if not LoadKlasses(fs) then begin
      ShowMessage('������ �������� �������');
      break;
    end;
    if not LoadKabinets(fs) then begin
      ShowMessage('������ �������� ���������');
      break;
    end;
    if not LoadTeachers(fs) then begin
      ShowMessage('������ �������� ��������');
      break;
    end;
    if not LoadSubjectNames(fs) then begin
      ShowMessage('������ �������� �������� ���������');
      break;
    end;
    if not LoadSubjects(fs) then begin
      ShowMessage('������ �������� ���������');
      break;
    end;
    if not LoadTimeTable(fs) then begin
      ShowMessage('������ �������� ����������');
      break;
    end;
  until True;
  fs.Free;
end;

procedure TSubjects.LoadFromTextFile(FN: string);
var
  SupObj: ISuperObject;
  sts: TStringList;
begin
  sts := TStringList.Create;
  sts.LoadFromFile(FN);
  SupObj := SO(sts.Text);
  AsJsonObject := SupObj;
  sts.Free;
end;

procedure TSubjects.Save(srBig: TStream; Key: string; srSmall: TStream);
var
  l: Integer;
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
 // ������ ��������� ���� ������ � ����
 // TODO 3: SaveToFile (���������� ��������� Current-������)
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
 // ������ ��������� ���� ������ � ����
 // TODO 3: SaveToFile (���������� ��������� Current-������)
  AsJsonObject.SaveTo(FN, True);
end;
////////////////////// ��������������� ������� //////////////////////
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

function FromName(Long, Short: string; Pin: Integer): string;
begin
  with TStringList.Create do begin
    Add(Long);
    Add(Short);
    Add(IntToStr(Pin));
    Result := CommaText;
    Free;
  end;
end;

function TSimpleItem.GetAvailableSubjects(LessonIndex: Integer): TSubjects;
begin
  // ��������
  Result := nil;
end;

function TSimpleItem.GetSubjects: TPlainSubjects;
begin
  Result := FSubjects;
end;

{ TLesson }

constructor TLesson.Create(AParent: TSubject; ALessonIndex: Integer);
begin
  inherited Create(nil);
  SetParent(AParent);
  LessonIndex := ALessonIndex;
end;

function TLesson.GetKlass: TKlass;
begin
  Result := inherited Klass;
end;

function TLesson.GetNameIndex: Integer;
begin
  Result := inherited NameIndex;
end;

procedure TLesson.SetLessonIndex(const Value: Integer);
begin
  FLessonIndex := Value;
end;

procedure TLesson.SetOnChangeLessonIndex(const Value: TOnChangeLessonIndex);
begin
  FOnChangeLessonIndex := Value;
end;

procedure TLesson.SetParent(const Value: TSubject);
begin
  if FParent<>nil then FParent.Subjects.Delete(self);
    /// 28.04.2012
    /// ������: ��� �������� ����� �������� �� ������������, ��� ����� �������
    /// � ��� �� ������
  Assign(Value);
  FParent := Value;
  if Value = nil then
    Exit;
  if Klass <> Value.Klass then
    Exception.Create('����� ������ � ������� ������ ���������');
  Value.Subjects.Add(self);
end;

{ TLessons }

procedure TLessons.Assign(Source: TPersistent);
var
  Subs: TPlainSubjects;
  I: Integer;
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

procedure TLessons.ChangeLessonIndex(Sender: TObject; OldIndex: Integer);
begin
  { TODO -o������ ����� -c����� : ����� �������� ���������� }
end;

constructor TLessons.Create(ATimeTable: TTimeTable; ALessonIndex: Integer);
begin
  inherited Create(true);
end;

function TLessons.CreateLesson(Subject: TSubject): TLesson;
begin
  Result:=TLesson.Create(Subject,LessonIndex);
  Result.OnChangeLessonIndex:=ChangeLessonIndex;
  Add(Result);
end;

function TLessons.GetItem(Index: Integer): TLesson;
begin
  Result := TLesson(inherited GetItem(Index));
end;

procedure TLessons.SetItem(Index: Integer; const Value: TLesson);
var
  ind: Integer;
begin
  ind := -1;
  if Value <> nil then
    ind := Value.ItemIndex;
  inherited SetItem(Index, Value);
  if Value <> nil then
    Value.ItemIndex := ind;
end;

end.
