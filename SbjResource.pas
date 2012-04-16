unit SbjResource;

interface

uses Classes;

type
  TViewMode = (vmSubjects, vmColumns, vmWeekDays, vmLessons);
  TColumnMode = (cmKlass, cmTeacher, cmKabinet);
  TTableContent = (tcSubject, tcTeacher, tcKabinet);
  TSubjErr = (teTeachers, teKabinets, teTime, teKlass, teSomeTeachers, teSomeKabinet);
  TSubjState = set of TSubjErr;
  TWeekDay = (wdMonday, wdTuesday, wdWednesday, wdThursday, wdFriday, wdSaturday, wdSunday);
  TTypeOfData = (todKlass, todTeacher, todKabinet, todName, todSubject);
  TSetWeekDays = set of TWeekDay;

resourcestring
  stNormal = '�������';
  stTwin = '���������';
  stHalf = '����������';
  stAnyKabinet = '- ����� ��������� ������� -';
  SLongDayNameMon = '�����������';
  SLongDayNameTue = '�������';
  SLongDayNameWed = '�����';
  SLongDayNameThu = '�������';
  SLongDayNameFri = '�������';
  SLongDayNameSat = '�������';
  SLongDayNameSun = '�����������';
  MonSt = '��';
  TueSt = '��';
  WedSt = '��';
  ThuSt = '��';
  FriSt = '��';
  SatSt = '��';
  SunSt = '��';
  stAddSubject = '�������� �������';
  stAddKlass = '�������� �����';
  stAddTeacher = '�������� �������';
  stAddKabinet = '�������� �������';
  stKlassFmt = '%s �����';
  stCMKlass = '���������: ������';
  stCMTeacher = '���������: �������������';
  stCMKabinet = '���������: ��������';
  stTCSubject = '������: ��������';
  stTCTeacher = '������: �������������';
  stTCKabinet = '������: ��������';
  stVMSubject = '������: ��������';
  stVMColumn = '������: �������';
  stVMWeekDays = '������: ��� ������';
  stVMLessons = '������: �����';
  stVwFullView = '�������� ��������';
  stVwText = '���/���� �����';
  stVwSanPin = '���/���� ������';
  stLockLesson = '������������� ����';
  stLockDay = '������������� ����';
  stLockedCell = '������ �������������';
  stSanPin = '������';

const
  cmCapts: array[cmKlass..cmKabinet] of String =
    (stCMKlass, stCMTeacher, stCMKabinet);
  tcCapts: array[tcSubject..tcKabinet] of String =
    (stTCSubject, stTCTeacher, stTCKabinet);
  vmCapts: array[vmSubjects..vmLessons] of String =
    (stVMSubject, stVMColumn, stVMWeekDays, stVMLessons);
  WeekDayNames: array[wdMonday..wdSunday] of String = (
    SLongDayNameMon, SLongDayNameTue, SLongDayNameWed,
    SLongDayNameThu, SLongDayNameFri,
    SLongDayNameSat, SLongDayNameSun);
  WeDa: array[wdMonday..wdSunday] of String =
    (MonSt, TueSt, WedSt, ThuSt, FriSt, SatSt, SunSt);
  TuSt: array[0..2] of string = (stNormal, stTwin, stHalf);
  LessInDay = 11;
  WDCount = 7;
  LessCount = LessInDay * WDCount;

type
  TCross = set of 0..LessCount - 1;
  TGetListEvent = procedure(Sender: TObject; TypeOfData: TTypeOfData; Short: Boolean; Strings: TStrings) of object;
  TChangeEvent = procedure(Sender: TObject; TypeOfData: TTypeOfData; index: integer) of object;
  TInsertEvent = procedure(Sender: TObject; TypeOfData: TTypeOfData) of object;

function StringAsCross(s: string): TCross;
function CrossAsString(cr: TCross): string;
function WeekDaysAsString(wd: TSetWeekDays): string;
function StringAsWeekDays(s: string): TSetWeekDays;

implementation

uses StrUtils;

function StringAsCross(s: string): TCross;
var
  i: 0..LessCount - 1;
begin
  Result := [];
  for i := 0 to LessCount - 1 do
    if s[ord(i) + 1] = '1' then
      Result := Result + [i];
end;

function CrossAsString(cr: TCross): string;
var
  i: 0..LessCount - 1;
begin
  Result := '';
  for i := 0 to LessCount - 1 do
    Result := Result + IfThen(i in cr, 'X', '-');
end;

function WeekDaysAsString(wd: TSetWeekDays): string;
var
  i: TWeekDay;
begin
  Result := '';
  for i := wdMonday to wdSunday do
    Result := Result + IfThen(i in wd, 'X', '-');
end;

function StringAsWeekDays(s: string): TSetWeekDays;
var
  i: TWeekDay;
begin
  Result := [];
  for i := wdMonday to wdSunday do
    if s[ord(i) + 1] = '1' then
      Result := Result + [i];
end;

end.

