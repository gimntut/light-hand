{$WARN UNSAFE_TYPE Off}
{$WARN UNSAFE_CODE Off}
{$WARN UNSAFE_CAST Off}
unit publ;

interface

uses Windows, Messages,
  Math, TlHelp32, Clipbrd,
     /////////////////// x ///////////////////
  shlObj, ActiveX, Classes, SysUtils, StdCtrls, ComObj,
  Controls, Variants, Graphics;

const
  ImpossibleInt: integer = Low(Integer);
  ImpossibleDateTime: Double = NAN;
  ImpossibleFloat: Real = NAN;
  ImpossibleCurrency: Currency = Low(Int64) div 10000;
  CRLF: String = #13#10;
  HexSet: set of char = ['0'..'9', 'A'..'F'];

type
  ai = array of integer;
  aai = array of ai;
  ar = array of Extended;
  aar = array of ar;
  ast = array of String;
  sb = set of Byte;
 ////////////////////// x //////////////////////
  TRealPoint = record
    X, Y: Real;
  end;
 ////////////////////// x //////////////////////
  TRealRect = record
    Left, Top, Right, Bottom: Real;
  end;
  TTimeDat = (tdHour, tdMinute, tdSecond, tdMilliSecond);
  TTimeDats = set of TTimeDat;
 // Простые виды событий
  TBoolEvent = procedure(Sender: TObject; Value: boolean) of object;
  TBoolVarEvent = procedure(Sender: TObject; var Value: boolean) of object;
  TIntEvent = procedure(Sender: TObject; Value: Integer) of object;
  TIntVarEvent = procedure(Sender: TObject; var Value: Integer) of object;
  TStrEvent = procedure(Sender: TObject; Value: String) of object;
  TStrVarEvent = procedure(Sender: TObject; var Value: string) of object;
  TVarEvent = procedure(Sender: TObject; ind: integer; var Value) of object;
  TFloatEvent = procedure(Sender: TObject; ind: integer; Value: Extended) of object;
  TVarFloatEvent = procedure(Sender: TObject; ind: integer; var Value: Extended) of object;
 //

  TCustomCompare = function(ind: Integer; obj: TObject): Integer of object;
  TIndCompare = function(ind1, ind2: Integer): Integer of object;
 //
  TSwapProc = procedure(ind1, ind2: Integer) of object;
 //
  TStreamProc = procedure(ms: TStream) of object;
 // Виды событий поиска фалов
  TffEvent = (ffStart, ffFile, ffDir);
 // Событие поиска файлов
  TFileFindEvent = procedure(Name: string; ffEvent: TffEvent;
    var StopSearch: boolean) of object;
 // Событие добавления файла
  TFileAddEvent = procedure(var Name: string) of object;
 // Компонент автоматического подключения модуля
  TPubl = class (TComponent)
  end;
 // Список строк с нулевым символом
  TNullStrList = class (TStringList)
  protected
    procedure SetTextStr(const Value: String); override;
    function GetTextStr: String; override;
  end;
 // Список строк с правильной сортировкой чисел
  TDirection = (drLeft, drTop, drRight, drBottom, drIncrease, drDecrease, drUp, drDown);
  TSortType = (stAsText, stAsNumbers);

  TNumStrList = class (TStringList)
  private
    FDirection: TDirection;
    FSortType: TSortType;
    procedure SetDirection(const Value: TDirection);
    function GetIam: TNumStrList;
    function GetValues(x: integer): Integer;
    procedure SetValues(x: integer; const Value: Integer);
  protected
    function CompareStrings(const S1: String; const S2: String): Integer; override;
  public
    constructor Create;
    property Direction: TDirection read FDirection write SetDirection;
    property Iam: TNumStrList read GetIam;
    property Values[x: integer]: Integer read GetValues write SetValues;
    property SortType: TSortType read FSortType write FSortType default stAsNumbers;
  end;
 ////////////////////// x //////////////////////
  TIntegers = class
  private
    FInts: array of TPoint; // Сортированый массив чисел, Х - числа, Y - индексы в неотсортированом массиве
    FObjects: array of TObject;
    FValues: ai;
    Inds: ai; // Индексы чисел в массиве FInts
    MaxInd: integer;
  // Нахождение положения числа в массиве FInts
    function FindX(Num: integer; var Ind: integer): boolean;
    function GetCount: integer;
    function GetIntegers(ind: integer): integer;
    function GetObjects(Ind: integer): TObject;
    function GetValues(Ind: integer): integer;
    procedure IncCount;
    procedure SetIntegers(ind: integer; const Value: integer);
    procedure SetObjects(Ind: integer; const Value: TObject);
    procedure SetValues(Ind: integer; const Value: integer);
  public
    constructor Create;
  // Добавленеие числа в конец Integers
    function Add(Num: integer): integer; overload;
  // Нахождение положение числа в массиве Integers
    function Find(Num: integer; out Ind: integer): boolean;
  // Нахождение положение числа в массиве Integers
    function IndexOf(Num: integer): integer;
  // Добавление числа в Integers
    function Insert(Ind, Num: integer): integer;
  // Проверка наличия числа в массиве
    function IsIn(Num: integer): boolean;
  // Обмен двух чисел местами
    function Swap(Num1, Num2: integer): boolean;
  // Добавление чисел из другого массва
    procedure Add(Ints: TIntegers); overload;
  // Очистка массива
    procedure Clear;
  // Удаление массива чисел
    procedure Delete(Ints: TIntegers); overload;
  // Удаление числа из массива
    procedure Delete(Num: integer); overload;
  // Оставить только совпадающие числа двух массивов
    procedure KeepEquals(Ints: TIntegers);
  // Проверка целостности массива
    procedure Test;
    property Count: integer read GetCount;
  // Массив чисел
    property Integers[ind: integer]: integer read GetIntegers write SetIntegers; default;
  // Массив объектов
    property Objects[Ind: integer]: TObject read GetObjects write SetObjects;
  // Массив значений
    property Values[Ind: integer]: integer read GetValues write SetValues;
  end;
 ////////////////////// x //////////////////////
  TExtClipboard = class (TClipboard)
  public
    procedure SetBuffer(Format: Word; var Buffer; Size: Integer);
  end;
 /////////////////// x ///////////////////
 // Компонент используемый с TPersistent-свойствами
 // которые, в свою очередь пытаются получить доступ
 // к визуальным компонентам  в DesignTime
 // Предназначен для хранения данных о компоненте
 // и очистки поля, при его удалении
  TListener = class (TComponent)
  private
    FComponent: TComponent;
    procedure SetComponent(const Value: TComponent);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    property Component: TComponent read FComponent write SetComponent;
  end;
 ////////////////////// x //////////////////////
 // Класс обмена сообщениями между разнородными классами
 // OnChange - событие задаваемое владельцем связи
 //  вызывается при измении данных в классе-собеседнике
 // OnGetValue - событие задаваемое владельцем связи
 //  вызывается, если классу-собеседнику нужно получить
 //  информацию от владельца связи
 // GetValue - вызывается классом-собеседником для получения данных
 // DoChange - вызывается классом-собеседником при изменении
 //  собствкнных данных
  TSimpleLink = class
  private
    FOnChange: TIntVarEvent;
    FOnGetValue: TVarEvent;
  public
    property OnChange: TIntVarEvent read FOnChange write FOnChange;
    property OnGetValue: TVarEvent read FOnGetValue write FOnGetValue;
    procedure GetValue(ind: integer; out x);
    function DoChange(x: integer = 0): integer;
  end;
// Запись и чтение строки в/из потока
procedure WriteString(sr: TStream; s: string);
function ReadString(sr: TStream): string;
// Преобразование строки в DOS кодировку
function ToOEM(s: string): string;
// Преобразование строки в WinDOwS кодировку
function ToAnsi(s: string): string;
// Добавление пробелов к строке с нужной стороны
function LSpace(s: string; len: integer; Cut: boolean = true): string; // - слева
function RSpace(s: string; len: integer; Cut: boolean = true): string; // - справа
// Запись числа прописными буквами
function propis(x: real): string;
function TextFromValue(value: extended): string;
// Создание массива целых чисел
procedure SetAI(var a: ai; x: array of const);
procedure MergeAI(var a: ai; x: array of ai);
// Создание массива целых чисел
procedure SetAR(var a: ar; x: array of const);
// Создание массива строк
procedure GroupStrings(var asts: ast; x: array of String);
// Разворот TrueType шрифта
function CreateRotatedFont(F: TFont; Angle: Integer): hFont;
// Создание ссылки на файл
procedure CreateLink(const PathObj, PathLink, Desc, Param: string);
// Поиск файлов на диске
// 1) Поиск по всем дискам
procedure FindFilesFromAll(FileMask: string; sts: TStrings;
  FileFindEvent: TFileFindEvent = nil;
  FileAddEvent: TFileAddEvent = nil;
  subdir: boolean = true);
// 2) Поиск перебором
procedure FindFiles(path, FileMask: string; sts: TStrings;
  FileFindEvent: TFileFindEvent = nil;
  FileAddEvent: TFileAddEvent = nil;
  subdir: boolean = true);
// 3) Поиск по уровням вложености папок
function FindF(path, FileMask: string; sts: TStrings;
  Level: integer;
  FileFindEvent: TFileFindEvent = nil;
  FileAddEvent: TFileAddEvent = nil
  ): boolean;
// Начало поиска по уровням
procedure SearchFiles(path, FileMask: string; sts: TStrings;
  FileFindEvent: TFileFindEvent = nil;
  FileAddEvent: TFileAddEvent = nil);
// Проверка наличия запущеной программы
function IsProgramRun(s: string): boolean;
// Удаление папки с файлами
function RemoveSubDirs(Path: String; ErrStr: string = ''): boolean;
// Строка в число с нулями спереди
function ToZeroStr(n, l: integer): String;
// Время в долях часов
function FromTime(h, m: integer): currency; overload;
function FromTime(Time: TDateTime): currency; overload;
// Сравнение строк начинающихся с числа
function CompNumStr(List: TStringList; Index1, Index2: Integer): Integer; overload;
function CompNumText(List: TStringList; Index1, Index2: Integer): Integer; overload;
function CompNumStr(s1, s2: string): Integer; overload;
function CompNumText(s1, s2: string): Integer; overload;
// Сравнение прямоугольников
function CompareRect(rct1, rct2: TRect): boolean;
function ContStr(s1, Separator, s2: string): String;
// Преобразование кода сообщения в название сообщения
function MsgToStr(Msg: Cardinal): String;
// 16to10
function HexToInt(p_strHex: string): integer;
// Установка фокуса на дочерний объект
procedure SetFocusTo(root: TWinControl; s: string);
// Нахождение числового корня
function Koren(x: integer): integer;
// Вывод сообщения
procedure MessageBox(Title, Text: String);
procedure ShowMessage(Text: String; Title: String = ''); overload;
// Изменение строки разделённой ззапятыми
function ChangeCommaText(S, subS: string; index: integer): string;
// Элемент строки с разделителями
function ItemOfCommaText(S: string; index: integer): string;
// Вариант в число
function VarToInt(v: Variant; ADefault: integer = 0): integer;
// TStrings.Text без #13#10
function SolidText(sts: TStrings): string;
// Обмен значениями двух переменных
procedure Exchange(var x1, x2: integer); overload;
procedure Exchange(var p1, p2: pointer); overload;
// Сравнение двух величин
function Equal(var a; var b; Size: integer): boolean;
// Проверка наличия элемента в массиве
function EnteringP(p: pointer; ps: array of pointer): integer;
function EnteringI(p: integer; ps: array of integer): integer;
function EnteringS(S: String; ps: array of String): integer;
// Преобразование данных в строку и обратно
function Int2Str(Value: Integer): string;
function Date2Str(Value: TDateTime): string;
function Time2Str(Value: TDateTime; TimeDats: TTimeDats = [tdHour..tdSecond]): string;
function DateTime2Str(Value: TDateTime): string;
function Float2Str(Value: Extended; Digits: integer = 2): string;
function Str2Int(Value: String): Integer;
function Str2Date(Value: String): TDateTime;
function Str2Time(Value: String): TDateTime;
function Str2DateTime(Value: String): TDateTime;
function Str2Float(Value: String): Extended;
// Округление с учётом невозможных чисел
function Round_(Value: Real): Integer;
// Список методов заданого класса
procedure GetMethodList(AClass: TClass; List: TStrings; IncludeParents: boolean);
// Сохранение и загрузка файла с восстановлением
procedure SaveToFileEx(fn: String; sp: TStreamProc);
procedure LoadFromFileEx(fn: String; sp: TStreamProc; ErrStr: string = '');
// Получение версии программы
function GetVersion(Name: string): string;
// Проверка соответсвия классов аналогичная оператору Is
function IsIt(obj: TObject; c: TClass): boolean;
// Путь папки временных файлов
function GetTempPath: String;
// Бинарный поиск в отсортитрованом массиве
function Find(obj: TObject; Count: Integer; Compare: TCustomCompare; out Index: Integer): Boolean;
// Быстрая сортировка данных
procedure QuickSort(L, R: Integer; SCompare: TIndCompare; Swap: TSwapProc);
// Запись и чтение файла из/в строки(у)
procedure SaveStrToFile(s, FileName: String);
procedure AppendStrToFile(s, FileName: String);
function LoadStrFromFile(FileName: String): String;
// Пустая процедура
procedure Dummy;
// Проверка на выход из границ
function OutSide(Ind, MaxInd: integer): boolean; overload;
function OutSide(Ind, MinInd, MaxInd: integer): boolean; overload;
// Преобразование от чисел к записи вещественных точки и прямоугольника
function RealRect(Left, Top, Right, Bottom: Real): TRealRect;
function RealPoint(X, Y: Real): TRealPoint;
// Функция возвращающая дизайнер объекта
procedure GetDesigner(Obj: TPersistent; out Result: IDesignerNotify);
//
function FiltKey(Text: String; SelStart: integer; Key: char): char; overload;
function FiltKey(Sender: TObject; Key: char): char; overload;
//
procedure Cycle(var x: integer; MaxValue: Integer = MaxInt; MinValue: integer = 0); overload;
procedure Cycle(var x: word; MaxValue: word = MAXWORD; MinValue: word = 0); overload;
////////////////////// x //////////////////////

var
  ProgramPath: string;
  DayCountInMonth: array[1..12] of byte = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);

implementation

uses Types, StrUtils;

procedure WriteString(sr: TStream; s: string);
var
  l: integer;
begin
  if sr = nil then
    Exit;
  l := length(s);
  sr.Write(l, 2);
  if Length(s) > 0 then
    sr.Write(s[1], l);
end;

function ReadString(sr: TStream): string;
var
  l: integer;
begin
  l := 0;
  sr.Read(l, 2);
  SetLength(result, l);
  if l > 0 then
    sr.Read(result[1], l);
  sr.position := sr.position;
end;

function ToOEM(s: string): string;
begin
  s := s + #0;
  SetLength(result, Length(s));
  CharToOEM(PChar(s), PChar(result));
  SetLength(result, Length(s) - 1);
end;

function ToAnsi(s: string): string;
begin
  s := s + #0;
  SetLength(result, Length(s));
  OEMToChar(PChar(s), PChar(result));
  SetLength(result, Length(s) - 1);
end;

function propis(x: real): string;
var
  i, j: integer;
  s: string;
  r: real;
  tetr: array[1..6] of string[3];
  cisl: array[1..3] of string[1];
begin
  for i := 1 to 6 do
    tetr[i] := '000';
  r := int(x);
  s := floattostr(r);
  i := length(s);
  i := i mod 3;
  case i of
    1:
      s := '00' + s;
    2:
      s := '0' + s;
  end;
  j := round(length(s) / 3);
  for i := 1 to j do begin
    tetr[i] := copy(s, length(s) - 2, 3);
    delete(s, length(s) - 2, 3);
  end;
  s := '';
  repeat
    cisl[1] := copy(tetr[j], 1, 1);
    cisl[2] := copy(tetr[j], 2, 1);
    cisl[3] := copy(tetr[j], 3, 1);
    if cisl[1] <> '0' then
      case strtoint(cisl[1]) of
        1:
          s := s + 'сто ';
        2:
          s := s + 'двести ';
        3:
          s := s + 'триста ';
        4:
          s := s + 'четыреста ';
        5:
          s := s + 'пятьсот ';
        6:
          s := s + 'шестьсот ';
        7:
          s := s + 'семьсот ';
        8:
          s := s + 'восемьсот ';
        9:
          s := s + 'девятьсот ';
      end;
    if cisl[2] <> '0' then
      case strtoint(cisl[2]) of
        1:
          case strtoint(cisl[3]) of
            1:
              s := s + 'одинадцать ';
            2:
              s := s + 'двенадцать ';
            3:
              s := s + 'тринадцать ';
            4:
              s := s + 'четырнадцать ';
            5:
              s := s + 'пятнадцать ';
            6:
              s := s + 'шестнадцать ';
            7:
              s := s + 'семнадцать ';
            8:
              s := s + 'восемнадцать ';
            9:
              s := s + 'девятнадцать ';
            0:
              s := s + 'десять ';
          end;
        2:
          s := s + 'двадцать ';
        3:
          s := s + 'тридцать ';
        4:
          s := s + 'сорок ';
        5:
          s := s + 'пятьдесят ';
        6:
          s := s + 'шестьдесят ';
        7:
          s := s + 'семьдесят ';
        8:
          s := s + 'восемьдесят ';
        9:
          s := s + 'девяносто ';
      end;
    if (cisl[3] <> '0') and (cisl[2] <> '1') then
      case strtoint(cisl[3]) of
        1:
          if j <> 2 then
            s := s + 'один '
          else
            s := s + 'одна ';
        2:
          if j <> 2 then
            s := s + 'два '
          else
            s := s + 'две ';
        3:
          s := s + 'три ';
        4:
          s := s + 'четыре ';
        5:
          s := s + 'пять ';
        6:
          s := s + 'шесть ';
        7:
          s := s + 'семь ';
        8:
          s := s + 'восемь ';
        9:
          s := s + 'девять ';
      end;
    if strtoint(cisl[1] + cisl[2] + cisl[3]) <> 0 then
      case j of
        2:
          case strtoint(cisl[3]) of
            1:
              if strtoint(cisl[2]) <> 1 then
                s := s + 'тысяча '
              else
                s := s + 'тысяч ';
            2..4:
              if strtoint(cisl[2]) <> 1 then
                s := s + 'тысячи '
              else
                s := s + 'тысяч ';
          else
            s := s + 'тысяч ';
          end;
        3:
          case strtoint(cisl[3]) of
            1:
              if strtoint(cisl[2]) <> 1 then
                s := s + 'миллион '
              else
                s := s + 'миллионов ';
            2..4:
              if strtoint(cisl[2]) <> 1 then
                s := s + 'миллиона '
              else
                s := s + 'миллионов ';
          else
            s := s + 'миллионов ';
          end;
        4:
          case strtoint(cisl[2] + cisl[3]) of
            1:
              if strtoint(cisl[2]) <> 1 then
                s := s + 'миллиард '
              else
                s := s + 'миллиардов ';
            2..4:
              if strtoint(cisl[2]) <> 1 then
                s := s + 'миллиарда '
              else
                s := s + 'миллиардов ';
          else
            s := s + 'миллиардов ';
          end;
        5:
          case strtoint(cisl[2] + cisl[3]) of
            1:
              if strtoint(cisl[2]) <> 1 then
                s := s + 'трилион '
              else
                s := s + 'трилионов ';
            2..4:
              if strtoint(cisl[2]) <> 1 then
                s := s + 'трилиона '
              else
                s := s + 'трилионов ';
          else
            s := s + 'трилионов ';
          end;
        6:
          case strtoint(cisl[2] + cisl[3]) of
            1:
              s := s + 'трилиард ';
            2..4:
              s := s + 'трилиарда ';
          else
            s := s + 'трилиардов ';
          end;
      end;
    j := j - 1;
  until j = 0;
  propis := s;
end;

function TextFromValue(value: extended): string;
var
  IntegerPartLen: integer;
  IntegerText: string;
  s1, s2, s3: string;
  StrAll: string[12];
  Counter: integer;
  st_1: string;//0-999
  st_2: string;//1 000-999 999
  st_3: string;//1 000 000-999 999 999
  st_4: string;//1 000 000 000 - 999 999 999 999
const
  Array_1: array[0..9] of string =
    ('', ' один', ' два', ' три', ' четыре', ' пять',
    ' шесть', ' семь', ' восемь', ' девять');
  Array_1_2: array[0..9] of string =
    ('', ' одна', ' две', ' три', ' четыре', ' пять',
    ' шесть', ' семь', ' восемь', ' девять');
//...
  Array_11_19: array[1..9] of string =
    (' одиннадцать', ' двенадцать', ' тринадцать',
    ' четырнадцать', ' пятнадцать', ' шестнадцать',
    ' семнадцать', ' восемнадцать',
    ' девятнадцать');
//...
  Array_10_90: array[0..9] of string =
    ('', ' десять', ' двадцать', ' тридцать',
    ' сорок', ' пятьдесят', ' шестьдесят',
    ' семьдесят', ' восемьдесят',
    ' девяносто');
//...
  Array_E: array[0..9] of string =
    ('', ' сто', ' двести', ' триста',
    ' четыреста', ' пятьсот', ' шестьсот',
    ' семьсот', ' восемьсот',
    ' девятьсот');

  function IntegerPart(value: extended): string;
  var
    Counter: integer;
    ResStr: string[1];
    ValueStr: string;
    r: string;
  begin
    Counter := 1;
    r := '';
    ValueStr := FormatFloat('0.00', value);
    repeat
      ResStr := ValueStr[counter];
      Inc(Counter);
      if (ResStr = ',') or (ResStr = '.') then
        break;
      if ResStr = ' ' then
        continue;
      r := r + ResStr;
    until (ResStr = ',') or (ResStr = '.');
    Result := r;
  end;
//................................................
//................
  function Return_1(var sStr: string): string;
  var
    vv: integer;
    code: integer;
    sCheck: string[2];
    cc: integer;
  begin
    Val(sStr[1], vv, code);
    s3 := Array_E[vv];
 //...
    sCheck := Copy(sStr, 2, 2);
    Val(sCheck, cc, code);
    if cc in [11..19] then begin
      s2 := Array_11_19[cc - 10];
      Result := s3 + s2;
      exit;
    end
    else begin
      Val(sStr[2], vv, code);
      s2 := Array_10_90[vv];
    //...
      Val(sStr[3], vv, code);
      s1 := Array_1[vv];
    //...
    end;
    Result := s3 + s2 + s1;
  end;//func 1
//.......
  function Return_2(var sStr: string): string;
  var
    vv: integer;
    code: integer;
    sCheck: string[2];
    cc: integer;
    LastWord: string;
  begin
    Val(sStr[1], vv, code);
    s3 := Array_E[vv];
 //...
    sCheck := Copy(sStr, 2, 2);
    Val(sCheck, cc, code);
    if cc in [11..19] then begin
      s2 := Array_11_19[cc - 10];
      Result := s3 + s2 + ' тысяч';
      exit;
    end
    else begin
      Val(sStr[2], vv, code);
      s2 := Array_10_90[vv];
    //...
      Val(sStr[3], vv, code);
      s1 := Array_1_2[vv];
    //...
    end;
    LastWord := ' тысяч';
    if vv = 4 then
      LastWord := ' тысячи';
    if vv = 3 then
      LastWord := ' тысячи';
    if vv = 2 then
      LastWord := ' тысячи';
    if vv = 1 then
      LastWord := ' тысяча';
    if (s3 = '') and (s2 = '') and (s1 = '') then
      lastWord := '';
    Result := s3 + s2 + s1 + LastWord;
  end;//func 1

  function Return_3(var sStr: string): string;
  var
    vv: integer;
    code: integer;
    sCheck: string[2];
    cc: integer;
    LastWord: string;
  begin
    Val(sStr[1], vv, code);
    s3 := Array_E[vv];
 //...
    sCheck := Copy(sStr, 2, 2);
    Val(sCheck, cc, code);
    if cc in [11..19] then begin
      s2 := Array_11_19[cc - 10];
      Result := s3 + s2 + ' миллионов';
      exit;
    end
    else begin
      Val(sStr[2], vv, code);
      s2 := Array_10_90[vv];
    //...
      Val(sStr[3], vv, code);
      s1 := Array_1[vv];
    //...
    end;
    LastWord := ' миллионов';
    if vv = 4 then
      LastWord := ' миллиона';
    if vv = 3 then
      LastWord := ' миллиона';
    if vv = 2 then
      LastWord := ' миллиона';
    if vv = 1 then
      LastWord := ' миллион';
    if (s3 = '') and (s2 = '') and (s1 = '') then
      lastWord := '';
    Result := s3 + s2 + s1 + LastWord;
  end;//func 1
//.......
//.......
  function Return_4(var sStr: string): string;
  var
    vv: integer;
    code: integer;
    sCheck: string[2];
    cc: integer;
    LastWord: string;
  begin
    Val(sStr[1], vv, code);
    s3 := Array_E[vv];
 //...
    sCheck := Copy(sStr, 2, 2);
    Val(sCheck, cc, code);
    if cc in [11..19] then begin
      s2 := Array_11_19[cc - 10];
      Result := s3 + s2 + ' миллиардов';
      exit;
    end
    else begin
      Val(sStr[2], vv, code);
      s2 := Array_10_90[vv];
    //...
      Val(sStr[3], vv, code);
      s1 := Array_1[vv];
    //...
    end;
    LastWord := ' миллиардов';
    if vv = 4 then
      LastWord := ' миллиарда';
    if vv = 3 then
      LastWord := ' миллиарда';
    if vv = 2 then
      LastWord := ' миллиарда';
    if vv = 1 then
      LastWord := ' миллиард';
    if (s3 = '') and (s2 = '') and (s1 = '') then
      lastWord := '';
    Result := s3 + s2 + s1 + LastWord;
  end;//func 1
//Main function body
//.......
var
  Txt: string;
  OneChar: string;
  s: string;
begin
  Result := 'Очень большое значение!';
  if Value > 999999999999.99 then
    exit;
  IntegerText := IntegerPart(value);
  IntegerPartLen := Length(IntegerText);
  StrAll := '000000000000';
 // Копируем строку задом наперед
  for Counter := IntegerPartLen downto 1 do
    StrAll[(12 - IntegerPartLen) + Counter] := IntegerText[Counter];
 //...
 //Разбираем число по разрадам
  st_1 := Copy(StrAll, 10, 3);
  st_2 := Copy(StrAll, 7, 3);
  st_3 := Copy(StrAll, 4, 3);
  st_4 := Copy(StrAll, 1, 3);
 //...
  txt := Return_4(st_4) + Return_3(st_3) + Return_2(st_2) + Return_1(st_1);
  if txt <> '' then begin
    OneChar := txt[2];
    s := AnsiUpperCase(OneChar);
    txt[2] := s[1];
  end;
  Result := txt;
end;

procedure SetAI(var a: ai; x: array of const);
var
  i, l: integer;
begin
  l := High(x);
  SetLength(a, l + 1);
  for i := 0 to l do
    a[i] := x[i].VInteger;
end;

procedure MergeAI(var a: ai; x: array of ai);
var
  i, j, n, l: integer;
begin
  l := 0;
  for i := 0 to High(x) do
    l := l + Length(x[i]);
  SetLength(a, l);
  n := 0;
  for i := 0 to High(x) do
    for j := 0 to High(x[i]) do begin
      a[n] := x[i, j];
      inc(n);
    end;
end;

procedure SetAR(var a: ar; x: array of const);
var
  i, l: integer;
begin
  l := High(x);
  SetLength(a, l + 1);
  for i := 0 to l do
    case x[i].VType of
      vtExtended:
        a[i] := x[i].VExtended^;
      vtInteger:
        a[i] := x[i].VInteger;
    end;
end;

procedure GroupStrings(var asts: ast; x: array of String);
var
  i, l: integer;
begin
  l := High(x);
  SetLength(asts, l + 1);
  for i := 0 to l do
    asts[i] := x[i];
end;

function CreateRotatedFont(F: TFont; Angle: Integer): hFont;
var
  LF: TLogFont;
begin
  FillChar(LF, SizeOf(LF), #0);
  with LF do begin
    lfHeight := F.Height;
    lfWidth := 0;
    lfEscapement := Angle * 10;
    lfOrientation := 0;
    if fsBold in F.Style then
      lfWeight := FW_BOLD
    else
      lfWeight := FW_NORMAL;
    lfItalic := Byte(fsItalic in F.Style);
    lfUnderline := Byte(fsUnderline in F.Style);
    lfStrikeOut := Byte(fsStrikeOut in F.Style);
    lfCharSet := DEFAULT_CHARSET;
    StrPCopy(lfFaceName, F.Name);
    lfQuality := DEFAULT_QUALITY;
  {everything else as default}
    lfOutPrecision := OUT_DEFAULT_PRECIS;
    lfClipPrecision := CLIP_DEFAULT_PRECIS;
    case F.Pitch of
      fpVariable:
        lfPitchAndFamily := VARIABLE_PITCH;
      fpFixed:
        lfPitchAndFamily := FIXED_PITCH;
    else
      lfPitchAndFamily := DEFAULT_PITCH;
    end;
  end;
  Result := CreateFontIndirect(LF);
end;

procedure CreateLink(const PathObj, PathLink, Desc, Param: string);
var
  IObject: IUnknown;
  SLink: IShellLink;
  PFile: IPersistFile;
begin
  CreateDir(PathLink);
  IObject := CreateComObject(CLSID_ShellLink);
  SLink := IObject as IShellLink;
  PFile := IObject as IPersistFile;
  with SLink do begin
    SetArguments(PChar(Param));
    SetDescription(PChar(Desc));
    SetPath(PChar(PathObj));
  end;
  PFile.Save(PWChar(WideString(PathLink)), True);
end;

function DoFindEvent(FFE: TFileFindEvent; Name: string; ffEvent: TffEvent): boolean;
begin
  result := false;
  if Assigned(FFE) then
    FFE(Name, ffEvent, result);
end;

function AddEvent(FAE: TFileAddEvent; Name: string): String;
begin
  Result := Name;
  if Assigned(FAE) then
    FAE(Result);
end;

procedure FindFiles(path, FileMask: string; sts: TStrings;
  FileFindEvent: TFileFindEvent = nil; FileAddEvent: TFileAddEvent = nil;
  subdir: boolean = true);
var
  fs: TSearchRec;
  r: integer;
  s: string;
  us: boolean;
begin
  if DoFindEvent(FileFindEvent, Path, ffDir) then
    Exit;
  if RightStr(path, 1) <> '\' then
    path := path + '\';
  r := FindFirst(path + FileMask, faAnyFile - faDirectory, fs);
  while r = 0 do begin
    s := path + fs.Name;
    if sts <> nil then
      sts.Add(AddEvent(FileAddEvent, s));
    if DoFindEvent(FileFindEvent, s, ffFile) then
      Exit;
    r := FindNext(fs);
  end;
  if not subdir then
    Exit;
  r := FindFirst(Path + '*.*', faDirectory, fs);
  while r = 0 do begin
    s := fs.Name;
    us := fs.Attr and faDirectory = 0;
    r := FindNext(fs);
    if us then
      Continue;
    if s[1] = '.' then
      Continue;
    FindFiles(Path + s + '\', FileMask, sts, FileFindEvent, FileAddEvent);
  end;
end;

function FindF(path, FileMask: string; sts: TStrings;
  Level: integer;
  FileFindEvent: TFileFindEvent = nil;
  FileAddEvent: TFileAddEvent = nil
  ): boolean;
var
  fs: TSearchRec;
  r: integer;
  s: string;
  us: boolean;
begin
  result := false;
  if Level = 0 then begin
    if DoFindEvent(FileFindEvent, Path, ffDir) then
      Exit;
    r := FindFirst(path + FileMask, faAnyFile - faDirectory, fs);
    while r = 0 do begin
      s := Path + fs.Name;
      if sts <> nil then
        sts.Add(AddEvent(FileAddEvent, s));
      if DoFindEvent(FileFindEvent, s, ffFile) then
        Exit;
      r := FindNext(fs);
    end;
    result := true;
    Exit;
  end;
  r := FindFirst(Path + '*.*', faDirectory, fs);
  while r = 0 do begin
    s := fs.Name;
    us := fs.Attr and faDirectory = 0;
    r := FindNext(fs);
    if us then
      Continue;
    if s[1] = '.' then
      Continue;
    result := FindF(Path + s + '\', FileMask, sts, Level - 1, FileFindEvent, FileAddEvent);
  end;
end;

procedure SearchFiles(path, FileMask: string; sts: TStrings;
  FileFindEvent: TFileFindEvent = nil;
  FileAddEvent: TFileAddEvent = nil);
var
  Level: integer;
begin
  Level := 0;
  while FindF(path, FileMask, sts, Level, FileFindEvent, FileAddEvent) do
    inc(Level);
end;

function IsProgramRun(s: string): boolean;
var
  ProcessEntry: TProcessEntry32;
  SnapShot: Thandle;
  st: string;
begin
  Result := false;
  SnapShot := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  ProcessEntry.dwSize := SizeOf(ProcessEntry);
  if Process32First(SnapShot, ProcessEntry) then
    repeat
      st := ProcessEntry.szExeFile;
      Result := SameText(ExtractFileName(st), ExtractFileName(s));
      if Result then
        Exit;
    until not Process32Next(SnapShot, ProcessEntry);
end;

function RemoveSubDirs(Path: String; ErrStr: string = ''): boolean;
var
  sts: TStringList;
  i: integer;
begin
  sts := TStringList.Create;
  FindFiles(Path, '*.*', sts);
  Result := true;
  for i := 0 to sts.Count - 1 do
    Result := Result and DeleteFile(sts[i]);
  sts.Free;
  if not Result then begin
    if ErrStr <> '' then
      ShowMessage('Ошибка! Error!', '(X)' + CRLF + ErrStr);
    Exit;
  end;
  try
    RemoveDir(Path);
  except
    on Exception do ;
  end;
end;

function ToZeroStr(n, l: integer): String;
var
  s: string;
  l2: integer;
begin
  s := IntToStr(n);
  Result := StringOfChar('0', l);
  l2 := Length(s);
  if l2 < l then
    Move(s[1], Result[l - l2 + 1], l2)
  else
    Result := s;
end;

function LSpace(s: string; len: integer; Cut: boolean): string; // - слева
var
  l: integer;
begin
  if Cut then
    s := Copy(s, 1, len);
  result := s;
  l := Length(s);
  if l >= len then
    Exit;
  result := StringOfChar(' ', len - l) + s;
end;

function RSpace(s: string; len: integer; Cut: boolean): string; // - справа
var
  l: integer;
begin
  if Cut then
    s := Copy(s, 1, len);
  result := s;
  l := Length(s);
  if l >= len then
    Exit;
  result := s + StringOfChar(' ', len - l);
end;

function FromTime(h, m: integer): currency;
begin
  result := h + m / 60;
end;

function FromTime(Time: TDateTime): currency; overload;
var
  h, m, s, ms: Word;
begin
  DecodeTime(Time, h, m, s, ms);
  result := FromTime(h, m);
end;

function CompNumStr(List: TStringList; Index1, Index2: Integer): Integer;
begin
  result := 0;
  if (Index1 >= 0) and (Index1 < List.Count) and (Index2 >= 0) and (Index2 < List.Count) then
    result := CompNumStr(List[Index1], List[Index2]);
end;

function CompNumText(List: TStringList; Index1, Index2: Integer): Integer;
begin
  result := 0;
  if (Index1 >= 0) and (Index1 < List.Count) and (Index2 >= 0) and (Index2 < List.Count) then
    result := CompNumText(List[Index1], List[Index2]);
end;

function CompNumStr(s1, s2: string): Integer; overload;
var
  s, ns: array[1..2] of string;
  n, x: array[1..2] of int64;
  i, j: integer;
begin
  result := 0;
  if s1 = s2 then
    Exit;
  s[1] := trim(s1);
  s[2] := trim(s2);
  for j := 1 to 2 do begin
    ns[j] := '';
    for i := 1 to Min(18, Length(s[j])) do
      if s[j][1] in ['0'..'9'] then begin
        ns[j] := ns[j] + s[j][1];
        Delete(s[j], 1, 1);
      end
      else
        break;
    if ns[j] <> '' then begin
      x[j] := 1;
      n[j] := StrToInt64(ns[j]);
    end
    else
      x[j] := 2;
  end;
  i := x[1] * 10 + x[2];
  case i of
    11:
    begin
      result := n[1] - n[2];
      if result = 0 then
        result := CompNumStr(s[1], s[2]);
    end;
    12:
      result := -1;
    21:
      result := 1;
    22:
      if (length(s[1]) = 0) or (length(s[2]) = 0) or (s[1][1] <> s[2][1]) then
        result := AnsiCompareStr(s[1], s[2])
      else begin
        while (length(s[1]) > 0) and (length(s[2]) > 0) and (s[1][1] = s[2][1]) and not (s[1][1] in ['0'..'9']) do begin
          Delete(s[1], 1, 1);
          Delete(s[2], 1, 1);
        end;
        result := CompNumStr(s[1], s[2]);
      end;
  else
    result := 0;
  end;
end;

function CompNumText(s1, s2: string): Integer; overload;
var
  s, ns: array[1..2] of string;
  n, x: array[1..2] of int64;
  i, j: integer;
begin
  result := 0;
  if SameText(s1, s2) then
    Exit;
  s[1] := s1;
  s[2] := s2;
  for j := 1 to 2 do begin
    ns[j] := '';
    for i := 1 to Min(Length(s[j]), 18) do
      if s[j][1] in ['0'..'9'] then begin
        ns[j] := ns[j] + s[j][1];
        Delete(s[j], 1, 1);
      end
      else
        break;
    if ns[j] <> '' then begin
      x[j] := 1;
      n[j] := StrToInt64(ns[j]);
    end
    else
      x[j] := 2;
  end;
  i := x[1] * 10 + x[2];
  case i of
    11:
    begin
      result := n[1] - n[2];
      if result = 0 then
        result := CompNumText(s[1], s[2]);
    end;
    12:
      result := -1;
    21:
      result := 1;
    22:
      if (length(s[1]) = 0) or (length(s[2]) = 0) or (s[1][1] <> s[2][1]) then
        result := AnsiCompareStr(s[1], s[2])
      else begin
        while (length(s[1]) > 0) and (length(s[2]) > 0) and (s[1][1] = s[2][1]) and not (s[1][1] in ['0'..'9']) do begin
          Delete(s[1], 1, 1);
          Delete(s[2], 1, 1);
        end;
        result := CompNumText(s[1], s[2]);
      end;
  else
    result := 0;
  end;
end;

function CompareRect(rct1, rct2: TRect): boolean;
begin
  result := (rct1.Left = rct2.Left) and (rct1.Top = rct2.Top) and
    (rct1.Right = rct2.Right) and (rct1.Bottom = rct2.Bottom);
end;

function ContStr(s1, Separator, s2: string): String;
begin
  result := s1;
  if (s1 <> '') and (s2 <> '') then
    result := result + Separator;
  result := result + s2;
end;

function HexToInt(p_strHex: string): integer;
begin
  Result := StrToInt('$' + p_strHex);
end;

function MsgToStr(Msg: Cardinal): String;
begin
  case msg of
    WM_NULL:
      result := 'WM_NULL';
    WM_CREATE:
      result := 'WM_CREATE';
    WM_DESTROY:
      result := 'WM_DESTROY';
    WM_MOVE:
      result := 'WM_MOVE';
    WM_SIZE:
      result := 'WM_SIZE';
    WM_ACTIVATE:
      result := 'WM_ACTIVATE';
    WM_SETFOCUS:
      result := 'WM_SETFOCUS';
    WM_KILLFOCUS:
      result := 'WM_KILLFOCUS';
    WM_ENABLE:
      result := 'WM_ENABLE';
    WM_SETREDRAW:
      result := 'WM_SETREDRAW';
    WM_SETTEXT:
      result := 'WM_SETTEXT';
    WM_GETTEXT:
      result := 'WM_GETTEXT';
    WM_GETTEXTLENGTH:
      result := 'WM_GETTEXTLENGTH';
    WM_PAINT:
      result := 'WM_PAINT';
    WM_CLOSE:
      result := 'WM_CLOSE';
    WM_QUERYENDSESSION:
      result := 'WM_QUERYENDSESSION';
    WM_QUIT:
      result := 'WM_QUIT';
    WM_QUERYOPEN:
      result := 'WM_QUERYOPEN';
    WM_ERASEBKGND:
      result := 'WM_ERASEBKGND';
    WM_SYSCOLORCHANGE:
      result := 'WM_SYSCOLORCHANGE';
    WM_ENDSESSION:
      result := 'WM_ENDSESSION';
    WM_SYSTEMERROR:
      result := 'WM_SYSTEMERROR';
    WM_SHOWWINDOW:
      result := 'WM_SHOWWINDOW';
    WM_CTLCOLOR:
      result := 'WM_CTLCOLOR';
    WM_WININICHANGE:
      result := 'WM_WININICHANGE';
    WM_DEVMODECHANGE:
      result := 'WM_DEVMODECHANGE';
    WM_ACTIVATEAPP:
      result := 'WM_ACTIVATEAPP';
    WM_FONTCHANGE:
      result := 'WM_FONTCHANGE';
    WM_TIMECHANGE:
      result := 'WM_TIMECHANGE';
    WM_CANCELMODE:
      result := 'WM_CANCELMODE';
    WM_SETCURSOR:
      result := 'WM_SETCURSOR';
    WM_MOUSEACTIVATE:
      result := 'WM_MOUSEACTIVATE';
    WM_CHILDACTIVATE:
      result := 'WM_CHILDACTIVATE';
    WM_QUEUESYNC:
      result := 'WM_QUEUESYNC';
    WM_GETMINMAXINFO:
      result := 'WM_GETMINMAXINFO';
    WM_PAINTICON:
      result := 'WM_PAINTICON';
    WM_ICONERASEBKGND:
      result := 'WM_ICONERASEBKGND';
    WM_NEXTDLGCTL:
      result := 'WM_NEXTDLGCTL';
    WM_SPOOLERSTATUS:
      result := 'WM_SPOOLERSTATUS';
    WM_DRAWITEM:
      result := 'WM_DRAWITEM';
    WM_MEASUREITEM:
      result := 'WM_MEASUREITEM';
    WM_DELETEITEM:
      result := 'WM_DELETEITEM';
    WM_VKEYTOITEM:
      result := 'WM_VKEYTOITEM';
    WM_CHARTOITEM:
      result := 'WM_CHARTOITEM';
    WM_SETFONT:
      result := 'WM_SETFONT';
    WM_GETFONT:
      result := 'WM_GETFONT';
    WM_SETHOTKEY:
      result := 'WM_SETHOTKEY';
    WM_GETHOTKEY:
      result := 'WM_GETHOTKEY';
    WM_QUERYDRAGICON:
      result := 'WM_QUERYDRAGICON';
    WM_COMPAREITEM:
      result := 'WM_COMPAREITEM';
    WM_GETOBJECT:
      result := 'WM_GETOBJECT';
    WM_COMPACTING:
      result := 'WM_COMPACTING';
    WM_COMMNOTIFY:
      result := 'WM_COMMNOTIFY';
    WM_WINDOWPOSCHANGING:
      result := 'WM_WINDOWPOSCHANGING';
    WM_WINDOWPOSCHANGED:
      result := 'WM_WINDOWPOSCHANGED';
    WM_POWER:
      result := 'WM_POWER';
    WM_COPYDATA:
      result := 'WM_COPYDATA';
    WM_CANCELJOURNAL:
      result := 'WM_CANCELJOURNAL';
    WM_NOTIFY:
      result := 'WM_NOTIFY';
    WM_INPUTLANGCHANGEREQUEST:
      result := 'WM_INPUTLANGCHANGEREQUEST';
    WM_INPUTLANGCHANGE:
      result := 'WM_INPUTLANGCHANGE';
    WM_TCARD:
      result := 'WM_TCARD';
    WM_HELP:
      result := 'WM_HELP';
    WM_USERCHANGED:
      result := 'WM_USERCHANGED';
    WM_NOTIFYFORMAT:
      result := 'WM_NOTIFYFORMAT';
    WM_CONTEXTMENU:
      result := 'WM_CONTEXTMENU';
    WM_STYLECHANGING:
      result := 'WM_STYLECHANGING';
    WM_STYLECHANGED:
      result := 'WM_STYLECHANGED';
    WM_DISPLAYCHANGE:
      result := 'WM_DISPLAYCHANGE';
    WM_GETICON:
      result := 'WM_GETICON';
    WM_SETICON:
      result := 'WM_SETICON';
    WM_NCCREATE:
      result := 'WM_NCCREATE';
    WM_NCDESTROY:
      result := 'WM_NCDESTROY';
    WM_NCCALCSIZE:
      result := 'WM_NCCALCSIZE';
    WM_NCHITTEST:
      result := 'WM_NCHITTEST';
    WM_NCPAINT:
      result := 'WM_NCPAINT';
    WM_NCACTIVATE:
      result := 'WM_NCACTIVATE';
    WM_GETDLGCODE:
      result := 'WM_GETDLGCODE';
    WM_NCMOUSEMOVE:
      result := 'WM_NCMOUSEMOVE';
    WM_NCLBUTTONDOWN:
      result := 'WM_NCLBUTTONDOWN';
    WM_NCLBUTTONUP:
      result := 'WM_NCLBUTTONUP';
    WM_NCLBUTTONDBLCLK:
      result := 'WM_NCLBUTTONDBLCLK';
    WM_NCRBUTTONDOWN:
      result := 'WM_NCRBUTTONDOWN';
    WM_NCRBUTTONUP:
      result := 'WM_NCRBUTTONUP';
    WM_NCRBUTTONDBLCLK:
      result := 'WM_NCRBUTTONDBLCLK';
    WM_NCMBUTTONDOWN:
      result := 'WM_NCMBUTTONDOWN';
    WM_NCMBUTTONUP:
      result := 'WM_NCMBUTTONUP';
    WM_NCMBUTTONDBLCLK:
      result := 'WM_NCMBUTTONDBLCLK';
    WM_NCXBUTTONDOWN:
      result := 'WM_NCXBUTTONDOWN';
    WM_NCXBUTTONUP:
      result := 'WM_NCXBUTTONUP';
    WM_NCXBUTTONDBLCLK:
      result := 'WM_NCXBUTTONDBLCLK';
    WM_INPUT:
      result := 'WM_INPUT';
    WM_KEYDOWN:
      result := 'WM_KEYDOWN';
    WM_KEYUP:
      result := 'WM_KEYUP';
    WM_CHAR:
      result := 'WM_CHAR';
    WM_DEADCHAR:
      result := 'WM_DEADCHAR';
    WM_SYSKEYDOWN:
      result := 'WM_SYSKEYDOWN';
    WM_SYSKEYUP:
      result := 'WM_SYSKEYUP';
    WM_SYSCHAR:
      result := 'WM_SYSCHAR';
    WM_SYSDEADCHAR:
      result := 'WM_SYSDEADCHAR';
    WM_KEYLAST:
      result := 'WM_KEYLAST';
    WM_INITDIALOG:
      result := 'WM_INITDIALOG';
    WM_COMMAND:
      result := 'WM_COMMAND';
    WM_SYSCOMMAND:
      result := 'WM_SYSCOMMAND';
    WM_TIMER:
      result := 'WM_TIMER';
    WM_HSCROLL:
      result := 'WM_HSCROLL';
    WM_VSCROLL:
      result := 'WM_VSCROLL';
    WM_INITMENU:
      result := 'WM_INITMENU';
    WM_INITMENUPOPUP:
      result := 'WM_INITMENUPOPUP';
    WM_MENUSELECT:
      result := 'WM_MENUSELECT';
    WM_MENUCHAR:
      result := 'WM_MENUCHAR';
    WM_ENTERIDLE:
      result := 'WM_ENTERIDLE';
    WM_MENURBUTTONUP:
      result := 'WM_MENURBUTTONUP';
    WM_MENUDRAG:
      result := 'WM_MENUDRAG';
    WM_MENUGETOBJECT:
      result := 'WM_MENUGETOBJECT';
    WM_UNINITMENUPOPUP:
      result := 'WM_UNINITMENUPOPUP';
    WM_MENUCOMMAND:
      result := 'WM_MENUCOMMAND';
    WM_CHANGEUISTATE:
      result := 'WM_CHANGEUISTATE';
    WM_UPDATEUISTATE:
      result := 'WM_UPDATEUISTATE';
    WM_QUERYUISTATE:
      result := 'WM_QUERYUISTATE';
    WM_CTLCOLORMSGBOX:
      result := 'WM_CTLCOLORMSGBOX';
    WM_CTLCOLOREDIT:
      result := 'WM_CTLCOLOREDIT';
    WM_CTLCOLORLISTBOX:
      result := 'WM_CTLCOLORLISTBOX';
    WM_CTLCOLORBTN:
      result := 'WM_CTLCOLORBTN';
    WM_CTLCOLORDLG:
      result := 'WM_CTLCOLORDLG';
    WM_CTLCOLORSCROLLBAR:
      result := 'WM_CTLCOLORSCROLLBAR';
    WM_CTLCOLORSTATIC:
      result := 'WM_CTLCOLORSTATIC';
    WM_MOUSEMOVE:
      result := 'WM_MOUSEMOVE';
    WM_LBUTTONDOWN:
      result := 'WM_LBUTTONDOWN';
    WM_LBUTTONUP:
      result := 'WM_LBUTTONUP';
    WM_LBUTTONDBLCLK:
      result := 'WM_LBUTTONDBLCLK';
    WM_RBUTTONDOWN:
      result := 'WM_RBUTTONDOWN';
    WM_RBUTTONUP:
      result := 'WM_RBUTTONUP';
    WM_RBUTTONDBLCLK:
      result := 'WM_RBUTTONDBLCLK';
    WM_MBUTTONDOWN:
      result := 'WM_MBUTTONDOWN';
    WM_MBUTTONUP:
      result := 'WM_MBUTTONUP';
    WM_MBUTTONDBLCLK:
      result := 'WM_MBUTTONDBLCLK';
    WM_MOUSEWHEEL:
      result := 'WM_MOUSEWHEEL';
    WM_PARENTNOTIFY:
      result := 'WM_PARENTNOTIFY';
    WM_ENTERMENULOOP:
      result := 'WM_ENTERMENULOOP';
    WM_EXITMENULOOP:
      result := 'WM_EXITMENULOOP';
    WM_NEXTMENU:
      result := 'WM_NEXTMENU';
    WM_SIZING:
      result := 'WM_SIZING';
    WM_CAPTURECHANGED:
      result := 'WM_CAPTURECHANGED';
    WM_MOVING:
      result := 'WM_MOVING';
    WM_POWERBROADCAST:
      result := 'WM_POWERBROADCAST';
    WM_DEVICECHANGE:
      result := 'WM_DEVICECHANGE';
    WM_IME_STARTCOMPOSITION:
      result := 'WM_IME_STARTCOMPOSITION';
    WM_IME_ENDCOMPOSITION:
      result := 'WM_IME_ENDCOMPOSITION';
    WM_IME_COMPOSITION:
      result := 'WM_IME_COMPOSITION';
    WM_IME_SETCONTEXT:
      result := 'WM_IME_SETCONTEXT';
    WM_IME_NOTIFY:
      result := 'WM_IME_NOTIFY';
    WM_IME_CONTROL:
      result := 'WM_IME_CONTROL';
    WM_IME_COMPOSITIONFULL:
      result := 'WM_IME_COMPOSITIONFULL';
    WM_IME_SELECT:
      result := 'WM_IME_SELECT';
    WM_IME_CHAR:
      result := 'WM_IME_CHAR';
    WM_IME_REQUEST:
      result := 'WM_IME_REQUEST';
    WM_IME_KEYDOWN:
      result := 'WM_IME_KEYDOWN';
    WM_IME_KEYUP:
      result := 'WM_IME_KEYUP';
    WM_MDICREATE:
      result := 'WM_MDICREATE';
    WM_MDIDESTROY:
      result := 'WM_MDIDESTROY';
    WM_MDIACTIVATE:
      result := 'WM_MDIACTIVATE';
    WM_MDIRESTORE:
      result := 'WM_MDIRESTORE';
    WM_MDINEXT:
      result := 'WM_MDINEXT';
    WM_MDIMAXIMIZE:
      result := 'WM_MDIMAXIMIZE';
    WM_MDITILE:
      result := 'WM_MDITILE';
    WM_MDICASCADE:
      result := 'WM_MDICASCADE';
    WM_MDIICONARRANGE:
      result := 'WM_MDIICONARRANGE';
    WM_MDIGETACTIVE:
      result := 'WM_MDIGETACTIVE';
    WM_MDISETMENU:
      result := 'WM_MDISETMENU';
    WM_ENTERSIZEMOVE:
      result := 'WM_ENTERSIZEMOVE';
    WM_EXITSIZEMOVE:
      result := 'WM_EXITSIZEMOVE';
    WM_DROPFILES:
      result := 'WM_DROPFILES';
    WM_MDIREFRESHMENU:
      result := 'WM_MDIREFRESHMENU';
    WM_MOUSEHOVER:
      result := 'WM_MOUSEHOVER';
    WM_MOUSELEAVE:
      result := 'WM_MOUSELEAVE';
    WM_NCMOUSEHOVER:
      result := 'WM_NCMOUSEHOVER';
    WM_NCMOUSELEAVE:
      result := 'WM_NCMOUSELEAVE';
    WM_WTSSESSION_CHANGE:
      result := 'WM_WTSSESSION_CHANGE';
    WM_TABLET_FIRST:
      result := 'WM_TABLET_FIRST';
    WM_TABLET_LAST:
      result := 'WM_TABLET_LAST';
    WM_CUT:
      result := 'WM_CUT';
    WM_COPY:
      result := 'WM_COPY';
    WM_PASTE:
      result := 'WM_PASTE';
    WM_CLEAR:
      result := 'WM_CLEAR';
    WM_UNDO:
      result := 'WM_UNDO';
    WM_RENDERFORMAT:
      result := 'WM_RENDERFORMAT';
    WM_RENDERALLFORMATS:
      result := 'WM_RENDERALLFORMATS';
    WM_DESTROYCLIPBOARD:
      result := 'WM_DESTROYCLIPBOARD';
    WM_DRAWCLIPBOARD:
      result := 'WM_DRAWCLIPBOARD';
    WM_PAINTCLIPBOARD:
      result := 'WM_PAINTCLIPBOARD';
    WM_VSCROLLCLIPBOARD:
      result := 'WM_VSCROLLCLIPBOARD';
    WM_SIZECLIPBOARD:
      result := 'WM_SIZECLIPBOARD';
    WM_ASKCBFORMATNAME:
      result := 'WM_ASKCBFORMATNAME';
    WM_CHANGECBCHAIN:
      result := 'WM_CHANGECBCHAIN';
    WM_HSCROLLCLIPBOARD:
      result := 'WM_HSCROLLCLIPBOARD';
    WM_QUERYNEWPALETTE:
      result := 'WM_QUERYNEWPALETTE';
    WM_PALETTEISCHANGING:
      result := 'WM_PALETTEISCHANGING';
    WM_PALETTECHANGED:
      result := 'WM_PALETTECHANGED';
    WM_HOTKEY:
      result := 'WM_HOTKEY';
    WM_PRINT:
      result := 'WM_PRINT';
    WM_PRINTCLIENT:
      result := 'WM_PRINTCLIENT';
    WM_APPCOMMAND:
      result := 'WM_APPCOMMAND';
    WM_THEMECHANGED:
      result := 'WM_THEMECHANGED';
    WM_HANDHELDFIRST:
      result := 'WM_HANDHELDFIRST';
    WM_HANDHELDLAST:
      result := 'WM_HANDHELDLAST';
    WM_PENWINFIRST:
      result := 'WM_PENWINFIRST';
    WM_PENWINLAST:
      result := 'WM_PENWINLAST';
    WM_COALESCE_FIRST:
      result := 'WM_COALESCE_FIRST';
    WM_COALESCE_LAST:
      result := 'WM_COALESCE_LAST';
    WM_DDE_FIRST:
      result := 'WM_DDE_FIRST';
    WM_DDE_TERMINATE:
      result := 'WM_DDE_TERMINATE';
    WM_DDE_ADVISE:
      result := 'WM_DDE_ADVISE';
    WM_DDE_UNADVISE:
      result := 'WM_DDE_UNADVISE';
    WM_DDE_ACK:
      result := 'WM_DDE_ACK';
    WM_DDE_DATA:
      result := 'WM_DDE_DATA';
    WM_DDE_REQUEST:
      result := 'WM_DDE_REQUEST';
    WM_DDE_POKE:
      result := 'WM_DDE_POKE';
    WM_DDE_EXECUTE:
      result := 'WM_DDE_EXECUTE';
    WM_APP:
      result := 'WM_APP';
    WM_USER:
      result := 'WM_USER';
    CM_ACTIVATE:
      result := 'CM_ACTIVATE';
    CM_DEACTIVATE:
      result := 'CM_DEACTIVATE';
    CM_GOTFOCUS:
      result := 'CM_GOTFOCUS';
    CM_LOSTFOCUS:
      result := 'CM_LOSTFOCUS';
    CM_CANCELMODE:
      result := 'CM_CANCELMODE';
    CM_DIALOGKEY:
      result := 'CM_DIALOGKEY';
    CM_DIALOGCHAR:
      result := 'CM_DIALOGCHAR';
    CM_FOCUSCHANGED:
      result := 'CM_FOCUSCHANGED';
    CM_PARENTFONTCHANGED:
      result := 'CM_PARENTFONTCHANGED';
    CM_PARENTCOLORCHANGED:
      result := 'CM_PARENTCOLORCHANGED';
    CM_HITTEST:
      result := 'CM_HITTEST';
    CM_VISIBLECHANGED:
      result := 'CM_VISIBLECHANGED';
    CM_ENABLEDCHANGED:
      result := 'CM_ENABLEDCHANGED';
    CM_COLORCHANGED:
      result := 'CM_COLORCHANGED';
    CM_FONTCHANGED:
      result := 'CM_FONTCHANGED';
    CM_CURSORCHANGED:
      result := 'CM_CURSORCHANGED';
    CM_CTL3DCHANGED:
      result := 'CM_CTL3DCHANGED';
    CM_PARENTCTL3DCHANGED:
      result := 'CM_PARENTCTL3DCHANGED';
    CM_TEXTCHANGED:
      result := 'CM_TEXTCHANGED';
    CM_MOUSEENTER:
      result := 'CM_MOUSEENTER';
    CM_MOUSELEAVE:
      result := 'CM_MOUSELEAVE';
    CM_MENUCHANGED:
      result := 'CM_MENUCHANGED';
    CM_APPKEYDOWN:
      result := 'CM_APPKEYDOWN';
    CM_APPSYSCOMMAND:
      result := 'CM_APPSYSCOMMAND';
    CM_BUTTONPRESSED:
      result := 'CM_BUTTONPRESSED';
    CM_SHOWINGCHANGED:
      result := 'CM_SHOWINGCHANGED';
    CM_ENTER:
      result := 'CM_ENTER';
    CM_EXIT:
      result := 'CM_EXIT';
    CM_DESIGNHITTEST:
      result := 'CM_DESIGNHITTEST';
    CM_ICONCHANGED:
      result := 'CM_ICONCHANGED';
    CM_WANTSPECIALKEY:
      result := 'CM_WANTSPECIALKEY';
    CM_INVOKEHELP:
      result := 'CM_INVOKEHELP';
    CM_WINDOWHOOK:
      result := 'CM_WINDOWHOOK';
    CM_RELEASE:
      result := 'CM_RELEASE';
    CM_SHOWHINTCHANGED:
      result := 'CM_SHOWHINTCHANGED';
    CM_PARENTSHOWHINTCHANGED:
      result := 'CM_PARENTSHOWHINTCHANGED';
    CM_SYSCOLORCHANGE:
      result := 'CM_SYSCOLORCHANGE';
    CM_WININICHANGE:
      result := 'CM_WININICHANGE';
    CM_FONTCHANGE:
      result := 'CM_FONTCHANGE';
    CM_TIMECHANGE:
      result := 'CM_TIMECHANGE';
    CM_TABSTOPCHANGED:
      result := 'CM_TABSTOPCHANGED';
    CM_UIACTIVATE:
      result := 'CM_UIACTIVATE';
    CM_UIDEACTIVATE:
      result := 'CM_UIDEACTIVATE';
    CM_DOCWINDOWACTIVATE:
      result := 'CM_DOCWINDOWACTIVATE';
    CM_CONTROLLISTCHANGE:
      result := 'CM_CONTROLLISTCHANGE';
    CM_GETDATALINK:
      result := 'CM_GETDATALINK';
    CM_CHILDKEY:
      result := 'CM_CHILDKEY';
    CM_DRAG:
      result := 'CM_DRAG';
    CM_HINTSHOW:
      result := 'CM_HINTSHOW';
    CM_DIALOGHANDLE:
      result := 'CM_DIALOGHANDLE';
    CM_ISTOOLCONTROL:
      result := 'CM_ISTOOLCONTROL';
    CM_RECREATEWND:
      result := 'CM_RECREATEWND';
    CM_INVALIDATE:
      result := 'CM_INVALIDATE';
    CM_SYSFONTCHANGED:
      result := 'CM_SYSFONTCHANGED';
    CM_CONTROLCHANGE:
      result := 'CM_CONTROLCHANGE';
    CM_CHANGED:
      result := 'CM_CHANGED';
    CM_DOCKCLIENT:
      result := 'CM_DOCKCLIENT';
    CM_UNDOCKCLIENT:
      result := 'CM_UNDOCKCLIENT';
    CM_FLOAT:
      result := 'CM_FLOAT';
    CM_BORDERCHANGED:
      result := 'CM_BORDERCHANGED';
    CM_BIDIMODECHANGED:
      result := 'CM_BIDIMODECHANGED';
    CM_PARENTBIDIMODECHANGED:
      result := 'CM_PARENTBIDIMODECHANGED';
    CM_ALLCHILDRENFLIPPED:
      result := 'CM_ALLCHILDRENFLIPPED';
    CM_ACTIONUPDATE:
      result := 'CM_ACTIONUPDATE';
    CM_ACTIONEXECUTE:
      result := 'CM_ACTIONEXECUTE';
    CM_HINTSHOWPAUSE:
      result := 'CM_HINTSHOWPAUSE';
    CM_DOCKNOTIFICATION:
      result := 'CM_DOCKNOTIFICATION';
    CM_MOUSEWHEEL:
      result := 'CM_MOUSEWHEEL';
    CM_ISSHORTCUT:
      result := 'CM_ISSHORTCUT';
    CN_BASE:
      result := 'CN_BASE';
    CN_CHARTOITEM:
      result := 'CN_CHARTOITEM';
    CN_COMMAND:
      result := 'CN_COMMAND';
    CN_COMPAREITEM:
      result := 'CN_COMPAREITEM';
    CN_CTLCOLORBTN:
      result := 'CN_CTLCOLORBTN';
    CN_CTLCOLORDLG:
      result := 'CN_CTLCOLORDLG';
    CN_CTLCOLOREDIT:
      result := 'CN_CTLCOLOREDIT';
    CN_CTLCOLORLISTBOX:
      result := 'CN_CTLCOLORLISTBOX';
    CN_CTLCOLORMSGBOX:
      result := 'CN_CTLCOLORMSGBOX';
    CN_CTLCOLORSCROLLBAR:
      result := 'CN_CTLCOLORSCROLLBAR';
    CN_CTLCOLORSTATIC:
      result := 'CN_CTLCOLORSTATIC';
    CN_DELETEITEM:
      result := 'CN_DELETEITEM';
    CN_DRAWITEM:
      result := 'CN_DRAWITEM';
    CN_HSCROLL:
      result := 'CN_HSCROLL';
    CN_MEASUREITEM:
      result := 'CN_MEASUREITEM';
    CN_PARENTNOTIFY:
      result := 'CN_PARENTNOTIFY';
    CN_VKEYTOITEM:
      result := 'CN_VKEYTOITEM';
    CN_VSCROLL:
      result := 'CN_VSCROLL';
    CN_KEYDOWN:
      result := 'CN_KEYDOWN';
    CN_KEYUP:
      result := 'CN_KEYUP';
    CN_CHAR:
      result := 'CN_CHAR';
    CN_SYSKEYDOWN:
      result := 'CN_SYSKEYDOWN';
    CN_SYSCHAR:
      result := 'CN_SYSCHAR';
    CN_NOTIFY:
      result := 'CN_NOTIFY';
  else
    result := 'WM_' + IntToHex(msg, 8);
  end;
end;

procedure SetFocusTo(root: TWinControl; s: string);
var
  sts: TStrings;
  i: integer;
  wcn1, wcn2: TWincontrol;
begin
  sts := tNumStrList.Create;
  sts.Commatext := s;
  wcn1 := root;
  for i := 1 to sts.Count - 1 do begin
    wcn2 := TWinControl(wcn1.FindChildcontrol(sts[i]));
    if wcn2 = nil then
      break
    else
      wcn1 := wcn2;
  end;
  while (wcn1 <> nil) and not wcn1.CanFocus do
    wcn1 := wcn1.Parent;
  if wcn1 <> nil then
    wcn1.SetFocus;
  sts.Free;
end;

function Koren(x: integer): integer;
var
  i: integer;
begin
  result := 0;
  for i := 1 to 9 do begin
    result := result + x mod 10;
    x := x div 10;
  end;
end;

procedure FindFilesFromAll(FileMask: string; sts: TStrings;
  FileFindEvent: TFileFindEvent;
  FileAddEvent: TFileAddEvent;
  subdir: boolean);
var
  DriveNum: Integer;
  DriveBits: set of 0..25;
  s: string;
begin
  Integer(DriveBits) := GetLogicalDrives;
  for DriveNum := 0 to 25 do begin
    if not (DriveNum in DriveBits) then
      Continue;
    s := Char(DriveNum + Ord('a')) + ':\';
    if GetDriveType(PChar(s)) <> DRIVE_FIXED then
      Continue;
    FindFiles(s, FileMask, sts, FileFindEvent, FileAddEvent);
  end;
end;

procedure Exchange(var x1, x2: integer);
var
  p: integer;
begin
  p := x1;
  x1 := x2;
  x2 := p;
end;

procedure Exchange(var p1, p2: pointer);
var
  p: pointer;
begin
  p := p1;
  p1 := p2;
  p2 := p;
end;

{ TNullStrList }

function TNullStrList.GetTextStr: String;
var
  I, L, Size, Count: Integer;
  P: PChar;
  S, LB: string;
begin
  Count := GetCount;
  Size := 0;
  LB := #13#0#10#0;
  for I := 0 to Count - 1 do
    Inc(Size, Length(Get(I)) + Length(LB));
  SetString(Result, nil, Size);
  P := Pointer(Result);
  for I := 0 to Count - 1 do begin
    S := Get(I);
    L := Length(S);
    if L <> 0 then begin
      System.Move(Pointer(S)^, P^, L);
      Inc(P, L);
    end;
    L := Length(LB);
    if L <> 0 then begin
      System.Move(Pointer(LB)^, P^, L);
      Inc(P, L);
    end;
  end;
end;

procedure TNullStrList.SetTextStr(const Value: String);
var
  P, Start: PChar;
  S: string;
  n, l: integer;
begin
  BeginUpdate;
  try
    Clear;
    P := Pointer(Value);
    n := 0;
    l := length(Value);
    if P <> nil then
      while n < l do begin
        Start := P + n;
        while not ((P + n)^ in [#10, #13]) do
          Inc(n);
        SetString(S, Start, P + n - Start);
        Add(S);
        if P^ = #13 then
          Inc(n);
        if P^ = #10 then
          Inc(n);
      end;
  finally
    EndUpdate;
  end;
end;

{ tMyStringList }

function tNumStrList.CompareStrings(const S1, S2: String): Integer;
var
  k: integer;
  l1, l2: integer;
  st1, st2: string;
begin
  if fDirection = drIncrease then
    k := 1
  else
    k := -1;
  st1 := s1;
  st2 := s2;
  l1 := Length(st1);
  l2 := Length(st2);
  if l1 > l2 + 1 then
    SetLength(st1, l2 + 1)
  else
  if l1 + 1 < l2 then
    SetLength(st2, l1 + 1);
  if CaseSensitive then
    if SortType = stAsText then
      Result := k * AnsiCompareStr(st1, st2)
    else
      Result := k * CompNumStr(st1, st2)
  else
  if SortType = stAsText then
    Result := k * AnsiCompareText(st1, st2)
  else
    Result := k * CompNumText(st1, st2);
end;

constructor tNumStrList.Create;
begin
  inherited;
  FDirection := drIncrease;
  FSortType := stAsNumbers;
end;

function tNumStrList.GetIam: TNumStrList;
begin
  result := self;
end;

function tNumStrList.GetValues(x: integer): Integer;
begin
  Result := integer(Objects[x]);
end;

procedure tNumStrList.SetDirection(const Value: TDirection);
begin
  FDirection := Value;
  if Sorted then
    Sort;
end;

procedure tNumStrList.SetValues(x: integer; const Value: Integer);
begin
  Objects[x] := TObject(Value);
end;

procedure MessageBox(Title, Text: String);
begin
  windows.MessageBox(0, PChar(Text), PChar(Title), MB_OK + MB_ICONASTERISK);
end;

procedure ShowMessage(Text: String; Title: String);
begin
  if Title = '' then
    Title := ExtractFileName(ParamStr(0));
  MessageBox(Title, Text);
end;

function ChangeCommaText(S, SubS: string; index: integer): string;
begin
  with TStringList.Create do begin
    CommaText := S;
    if (index >= 0) and (index < Count) then
      strings[index] := SubS;
    result := CommaText;
    Free;
  end;
end;

function ItemOfCommaText(S: string; index: integer): string;
begin
  with TStringList.Create do begin
    CommaText := S;
    if (index >= 0) and (index < Count) then
      result := strings[index];
    ;
    Free;
  end;
end;

function VarToInt(v: Variant; ADefault: integer = 0): integer;
begin
  if v = null then
    result := ADefault
  else
    result := v;
end;

function SolidText(sts: TStrings): string;
begin
  result := AnsiReplaceStr(sts.Text, #13#10, '');
end;

{ TIntegers }

procedure TIntegers.Add(Ints: TIntegers);
var
  i, x: integer;
begin
  for i := 0 to Ints.Count - 1 do begin
    x := Add(Ints[i]);
    Values[x] := Ints.Values[i];
    Objects[x] := Ints.Objects[i];
  end;
end;

function TIntegers.Add(Num: integer): integer;
var
  i, x: integer;
begin
  if Find(Num, result) then
    Exit;
  FindX(Num, x);
  for i := 0 to High(Inds) do
    if Inds[i] >= x then
      Inc(Inds[i]);
  IncCount;
  if MaxInd > x then
    Move(FInts[x], FInts[x + 1], (MaxInd - x) * SizeOf(TPoint));
  FInts[x].X := num;
  FInts[x].Y := MaxInd;
  Inds[MaxInd] := X;
  result := MaxInd;
  Test;
end;

procedure TIntegers.Delete(Num: integer);
var
  x, n: integer;
  i: integer;
begin
  if not FindX(Num, x) then
    Exit;
  n := FInts[x].Y;
  if MaxInd <> x then
    Move(FInts[x + 1], FInts[x], (MaxInd - x) * SizeOf(TPoint));
  if MaxInd <> n then begin
    Move(Inds[n + 1], Inds[n], (MaxInd - n) * SizeOf(Integer));
    Move(FValues[n + 1], FValues[n], (MaxInd - n) * SizeOf(Integer));
    Move(FObjects[n + 1], FObjects[n], (MaxInd - n) * SizeOf(TObject));
  end;
  SetLength(FInts, MaxInd);
  SetLength(Inds, MaxInd);
  SetLength(FObjects, MaxInd);
  SetLength(FValues, MaxInd);
  Dec(MaxInd);
  for i := 0 to MaxInd do begin
    if FInts[i].y > n then
      dec(FInts[i].y);
    if Inds[i] > x then
      dec(Inds[i]);
  end;
  Test;
end;

constructor TIntegers.Create;
begin
  SetLength(FInts, 0);
  SetLength(Inds, 0);
  MaxInd := -1;
end;

procedure TIntegers.Delete(Ints: TIntegers);
var
  i: integer;
begin
  for i := 0 to Ints.Count - 1 do
    Delete(Ints[i]);
end;

function TIntegers.Find(Num: integer; out Ind: integer): boolean;
var
  L: Integer;
begin
  Ind := -1;
  if MaxInd=-1 then Exit;
  Result := FindX(Num, l);
  if (l >= 0) and (l <= MaxInd) then
    Ind := FInts[L].Y;
end;

function TIntegers.GetCount: integer;
begin
  result := MaxInd + 1;
end;

function TIntegers.GetIntegers(ind: integer): integer;
begin
  Result := ImpossibleInt;
  if (ind < 0) or (ind > MaxInd) then
    Exit;
  Result := FInts[Inds[Ind]].X;
end;

procedure TIntegers.IncCount;
begin
  Inc(MaxInd);
  SetLength(FInts, Count);
  SetLength(Inds, Count);
  SetLength(FObjects, Count);
  SetLength(FValues, Count);
end;

function TIntegers.IsIn(Num: integer): boolean;
var
  x: integer;
begin
  result := Find(num, x);
end;

procedure TIntegers.KeepEquals(Ints: TIntegers);
var
  i: integer;
begin
  for i := 0 to MaxInd do
    if not Ints.IsIn(FInts[i].X) then
      Delete(FInts[inds[i]].x);
end;

procedure TIntegers.SetIntegers(ind: integer; const Value: integer);
var
  i, x, x1, x2, d, l, r: integer;
begin
  if (ind < 0) or (ind > MaxInd) then
    Exit;
  if FindX(Value, x1) then
    Exit;
  x2 := Inds[Ind];
  if abs(x1 - x2) < 2 then begin
    if x1 > x2 then
      dec(x1);
    FInts[x1].X := Value;
    Exit;
  end;
  if x1 > x2 then begin
    d := -1;
    x := x2;
    x1 := x1 - 1;
  end
  else begin
    d := 1;
    x := x1 + 1;
  end;
  l := min(x1, x2);
  r := max(x1, x2);
  Move(FInts[x - d], FInts[x], abs(x2 - x1) * SizeOf(TPoint));
  FInts[x1].X := Value;
  FInts[x1].Y := Ind;
  for i := 0 to MaxInd do
    if (Inds[i] >= l) and (Inds[i] <= r) then
      inc(Inds[i], d);
  inds[ind] := x1;
  Test;
end;

function TIntegers.FindX(Num: integer; var Ind: integer): boolean;
var
  L, H, I, C: Integer;
begin
  Result := False;
  L := 0;
  H := MaxInd;
  while L <= H do begin
    I := (L + H) shr 1;
    C := CompareValue(FInts[i].X, Num);
    if C < 0 then
      L := I + 1
    else begin
      H := I - 1;
      if C = 0 then begin
        Result := True;
        L := I;
      end;
    end;
  end;
  Ind := L;
end;

function TIntegers.GetObjects(Ind: integer): TObject;
begin
  result := nil;
  if (Ind < 0) or (Ind > MaxInd) then
    Exit;
  result := FObjects[ind];
end;

function TIntegers.GetValues(Ind: integer): integer;
begin
  result := 0;
  if (Ind < 0) or (Ind > MaxInd) then
    Exit;
  result := FValues[ind];
end;

procedure TIntegers.SetObjects(Ind: integer; const Value: TObject);
begin
  if (Ind < 0) or (Ind > MaxInd) then
    Exit;
  FObjects[ind] := Value;
end;

procedure TIntegers.SetValues(Ind: integer; const Value: integer);
begin
  if (Ind < 0) or (Ind > MaxInd) then
    Exit;
  FValues[ind] := Value;
end;

function TIntegers.IndexOf(Num: integer): integer;
var
  x: integer;
begin
  result := -1;
  if Find(Num, x) then
    Result := x;
end;

procedure TIntegers.Clear;
begin
  MaxInd := -1;
  SetLength(FInts, 0);
  SetLength(FObjects, 0);
  SetLength(FValues, 0);
  SetLength(Inds, 0);
end;

procedure TIntegers.Test;
var
  i, j: integer;
begin
  for i := 0 to High(Inds) - 1 do
    for j := i + 1 to High(Inds) do
      if (Inds[i] = Inds[j]) or (FInts[i].X = FInts[j].X) or (FInts[i].Y = FInts[j].Y) or (i <> Inds[FInts[i].Y]) then begin
        MessageBox('', 'Нарушена целостность массива Integers');
        exit;
      end;
end;

function TIntegers.Swap(Num1, Num2: integer): boolean;
var
  ind1, ind2: Integer;
  x1, x2: integer;
begin
  result := false;
  if Num1 = Num2 then
    Exit;
  if not Find(Num1, ind1) then
    Exit;
  if not Find(Num2, ind2) then
    Exit;
  x1 := inds[ind1];
  x2 := inds[ind2];
  FInts[x1].Y := ind2;
  FInts[x2].Y := ind1;
  inds[ind1] := x2;
  inds[ind2] := x1;
  result := true;
  Exchange(FValues[ind1], FValues[ind2]);
  Exchange(pointer(FObjects[ind1]), pointer(FObjects[ind2]));
  Test;
end;

function TIntegers.Insert(Ind, Num: integer): integer;
 // Ind - индекс числа в массиве Integers
 // n - индекс числа в отсортированом массиве FInts
var
  x, n: integer;
  i: integer;
begin
  if (Ind < 0) or (Ind > Count) then
    Exit;
  if Find(Num, result) then
    Exit;
  if Ind = Count then begin
    result := Add(Num);
    Exit;
  end;
  FindX(Num, x);
  n := ind;
  IncCount;
  if MaxInd <> x then
    Move(FInts[x], FInts[x + 1], (MaxInd - x) * SizeOf(TPoint));
  if MaxInd <> n then begin
    Move(Inds[n], Inds[n + 1], (MaxInd - n) * SizeOf(Integer));
    Move(FValues[n], FValues[n + 1], (MaxInd - n) * SizeOf(Integer));
    Move(FObjects[n], FObjects[n + 1], (MaxInd - n) * SizeOf(TObject));
  end;
  for i := 0 to MaxInd do begin
    if FInts[i].y >= n then
      inc(FInts[i].y);
    if Inds[i] >= x then
      inc(Inds[i]);
  end;
  Inds[n] := x;
  FInts[x] := Point(Num, n);
  Test;
end;

{ TExtClipboard }

procedure TExtClipboard.SetBuffer(Format: Word; var Buffer; Size: Integer);
begin
  inherited;
end;

function Equal(var a; var b; Size: integer): boolean;
type
  bytes = array[1..MaxInt] of byte;
var
  i: integer;
begin
  result := true;
  for i := 1 to Size do begin
    result := bytes(a)[i] = bytes(b)[i];
    if not result then
      Exit;
  end;
end;

function xEntering(var p; var ps; Count, ItemSize: integer): integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to Count - 1 do
    if Equal(p, Pointer(integer(@ps) + i * ItemSize)^, ItemSize) then begin
      result := i;
      break;
    end;
end;

function EnteringP(p: pointer; ps: array of pointer): integer;
begin
  result := xEntering(p, ps, length(ps), SizeOf(p));
end;

function EnteringI(p: integer; ps: array of integer): integer;
begin
  result := xEntering(p, ps, Length(ps), SizeOf(p));
end;

function EnteringS(S: String; ps: array of String): integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to High(ps) do
    if SameText(s, ps[i]) then begin
      result := i;
      break;
    end;
end;
////////////////////// x //////////////////////
function Int2Str(Value: Integer): string;
begin
  if Value = ImpossibleInt then
    result := ''
  else
    Result := IntToStr(Value);
end;

function Date2Str(Value: TDateTime): string;
begin
  if IsNan(Value) then
    result := ''
  else
    Result := DateToStr(Value);
end;

function Time2Str(Value: TDateTime; TimeDats: TTimeDats): string;
var
  s, s2: String;
  p: integer;
begin
  if IsNan(Value) then
    result := ''
  else begin
    s := LongTimeFormat;
    s2 := 'h';
    if tdMinute in TimeDats then
      s2 := ContStr(s2, ':', 'mm');
    if tdSecond in TimeDats then
      s2 := ContStr(s2, ':', 'ss');
    if tdMilliSecond in TimeDats then
      s2 := ContStr(s2, '.', 'zzz');
    LongTimeFormat := s2;
    s2 := TimeToStr(Value);
    LongTimeFormat := s;
    if not (tdHour in TimeDats) then begin
      p := pos(':', s2);
      if p = 0 then
        p := pos('.', s2);
      if p <> 0 then
        Delete(s2, 1, p);
    end;
    Result := s2;
  end;
end;

function DateTime2Str(Value: TDateTime): string;
begin
  if IsNan(Value) then
    result := ''
  else
    Result := DateTimeToStr(Value);
end;

function Float2Str(Value: Extended; Digits: integer): string;
begin
  if IsNan(Value) then
    result := ''
  else begin
    Value := RoundTo(Value, -Digits);
    Result := FloatToStr(Value);
  end;
end;
////////////////////// x //////////////////////
function Str2Int(Value: String): Integer;
begin
  result := StrToIntDef(Value, ImpossibleInt);
end;

function Str2Date(Value: String): TDateTime;
begin
  result := StrToDateDef(Value, ImpossibleDateTime);
end;

function Str2Time(Value: String): TDateTime;
begin
  result := StrToTimeDef(Value, ImpossibleDateTime);
end;

function Str2DateTime(Value: String): TDateTime;
begin
  result := StrToDateTimeDef(Value, ImpossibleDateTime);
end;

function Str2Float(Value: String): Extended;
begin
  result := StrToFloatDef(Value, ImpossibleFloat);
end;

function Round_(Value: Real): Integer;
begin
  if IsNan(Value) then
    result := ImpossibleInt
  else
    result := Round(Value);
end;

procedure GetMethodList(AClass: TClass; List: TStrings; IncludeParents: boolean);
var
  P: pointer;
  N: word;
  i: integer;
  S: ShortString;

  procedure IncAddr(Offset: integer);
  begin
    P := Pointer(Integer(P) + Offset);
  end;

begin
  if AClass <> nil then begin
    P := AClass;
    IncAddr(vmtMethodTable);
    P := Pointer(P^);
    if P <> nil then begin
      N := Word(P^);
      IncAddr(2);
      for i := 0 to N - 1 do begin
        IncAddr(6);
        S := ShortString(P^);
        List.AddObject(S, TObject(AClass.MethodAddress(S)));
        IncAddr(Byte(P^) + 1);
      end;
    end;
    if IncludeParents then
      GetMethodList(AClass.ClassParent, List, True);
  end;
end;

procedure SaveToFileEx(fn: String; sp: TStreamProc);
var
  fs: tFileStream;
  state: LongWord;
  s: string;
begin
  if FileExists(fn) then begin
    s := ChangeFileExt(fn, '.old');
    DeleteFile(s);
    RenameFile(fn, s);
  end;
  fs := TFileStream.Create(fn, fmCreate);
  State := $87654321;
  fs.Write(State, 4);
  sp(fs);
  fs.Position := 0;
  State := $12345678;
  fs.Write(State, 4);
  fs.Free;
  DeleteFile(s);
end;

procedure LoadFromFileEx(fn: String; sp: TStreamProc; ErrStr: string);
var
  fs: tFileStream;
  State: longint;
  s: string;
begin
  if not FileExists(fn) then
    Exit;
  s := ChangeFileExt(fn, '.old');
  fs := TFileStream.Create(fn, fmOpenRead);
  fs.Read(State, 4);
  if State <> $12345678 then begin
    fs.Free;
    if not FileExists(s) then
      raise Exception.Create('Один из файлов повреждён и не может быть открыт.')
    else begin
      if ErrStr <> '' then
        MessageBox('Ошибка', ErrStr);
      fs := TFileStream.Create(s, fmOpenRead);
      fs.Position := 4;
    end;
  end;
  sp(fs);
  fs.Free;
end;

function GetVersion(Name: string): string;
var
  VerSize, Temp: DWORD;
  VerInfo: array of byte;
  Buffer: Pointer;
  pint: ^VS_FIXEDFILEINFO;
begin
  Result := '';
  VerSize := GetFileVersionInfoSize(pchar(Name), Temp);
  if VerSize <> 0 then begin
    SetLength(VerInfo, VerSize);
    GetFileVersionInfo(pchar(Name), 0, VerSize, @VerInfo[0]);
  end;
  if VerQueryValue(@VerInfo[0], '\', Buffer, temp) then begin
    pint := buffer;
    Result := IntToStr(HiWord(pint^.dwFileVersionMS)) + '.' + IntToStr(LoWord(pint^.dwFileVersionMS)) + '.' + IntToStr(HiWord(pint^.dwFileVersionLS)) + '.' + IntToStr(LoWord(pint^.dwFileVersionLS));
  end;
end;

function IsIt(obj: TObject; c: TClass): boolean;
var
  cls: TClass;
begin
  result := false;
  if obj = nil then
    Exit;
  cls := obj.ClassType;
  result := true;
  while cls <> nil do begin
    if cls = c then
      Exit;
    cls := cls.ClassParent;
  end;
  result := false;
end;

function GetTempPath: String;
var
  FTemp: array[0..MAX_PATH] of Char;
begin
  Windows.GetTempPath(MAX_PATH, FTemp);
  result := StrPas(FTemp);
end;

function Find(obj: TObject; Count: Integer; Compare: TCustomCompare; out Index: Integer): Boolean;
var
  L, H, I, C: Integer;
begin
  Result := False;
  Index := 0;
  if not Assigned(Compare) then
    Exit;
  L := 0;
  H := Count - 1;
  while L <= H do begin
    I := (L + H) shr 1;
    C := Compare(I, obj);
    if C < 0 then
      L := I + 1
    else begin
      H := I - 1;
      if C = 0 then begin
        Result := True;
        L := I;
      end;
    end;
  end;
  Index := L;
end;

procedure QuickSort(L, R: Integer; SCompare: TIndCompare; Swap: TSwapProc);
var
  I, J: Integer;
  P: Integer;
begin
  repeat
    I := L;
    J := R;
    P := (L + R) shr 1;
    repeat
      while SCompare(I, P) < 0 do
        Inc(I);
      while SCompare(J, P) > 0 do
        Dec(J);
      if I <= J then begin
        Swap(I, J);
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then
      QuickSort(L, J, SCompare, Swap);
    L := I;
  until I >= R;
end;

procedure SaveStrToFile(s, FileName: String);
var
  sts: TStringList;
begin
  sts := TStringList.Create;
  sts.Text := s;
  Sts.SaveToFile(FileName);
  sts.Free;
end;

procedure AppendStrToFile(s, FileName: String);
var
  TF: TextFile;
begin
  AssignFile(TF, FileName);
  if not FileExists(FileName) then
    Rewrite(TF)
  else
    Append(TF);
  Writeln(TF, s);
  CloseFile(TF);
end;

function LoadStrFromFile(FileName: String): String;
var
  sts: TStringList;
begin
  Result := '';
  if not FileExists(FileName) then
    Exit;
  sts := TStringList.Create;
  sts.LoadFromFile(FileName);
  result := sts.Text;
  sts.Free;
end;

procedure Dummy;
begin
 // Здесь должно быть пусто
end;

function OutSide(Ind, MaxInd: integer): boolean; overload;
begin
  result := (Ind < 0) or (Ind > MaxInd);
end;

function OutSide(Ind, MinInd, MaxInd: integer): boolean; overload;
begin
  result := (Ind < MinInd) or (Ind > MaxInd);
end;

{ TSimpleLink }

function TSimpleLink.DoChange(x: integer): integer;
begin
  if Assigned(FOnChange) then
    FOnChange(Self, x);
  result := x;
end;

function RealRect(Left, Top, Right, Bottom: Real): TRealRect;
begin
  Result.Left := Left;
  Result.Top := Top;
  Result.Right := Right;
  Result.Bottom := Bottom;
end;

function RealPoint(X, Y: Real): TRealPoint;
begin
  Result.X := X;
  Result.Y := Y;
end;

{
begin
end;
}

procedure TSimpleLink.GetValue(ind: integer; out x);
begin
  if Assigned(FOnGetValue) then
    FOnGetValue(self, ind, x);
end;

{ TListener }

procedure TListener.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) and (FComponent = AComponent) then
    FComponent := nil;
end;

procedure TListener.SetComponent(const Value: TComponent);
begin
  if FComponent <> nil then
    FComponent.RemoveFreeNotification(self);
  FComponent := Value;
  if FComponent <> nil then
    FComponent.FreeNotification(self);
end;
/////////////////// x ///////////////////
type
  THookPersistent = class (TPersistent)
  protected
    function GetOwner: TPersistent; override;
  end;
 /////////////////// x ///////////////////
  THookComponent = class (TComponent)
  public
    function QueryInterface(const IID: TGUID; out Obj): HRESULT; override; stdcall;
  end;
/////////////////// x ///////////////////
procedure GetDesigner(Obj: TPersistent; out Result: IDesignerNotify);
var
  Temp: TPersistent;
begin
  Result := nil;
  if Obj = nil then
    Exit;
  Temp := THookPersistent(Obj).GetOwner;
  if Temp = nil then begin
    if (Obj is TComponent) and (csDesigning in TComponent(Obj).ComponentState) then
      THookComponent(Obj).QueryInterface(IDesignerNotify, Result);
  end
  else begin
    if (Obj is TComponent) and not (csDesigning in TComponent(Obj).ComponentState) then
      Exit;
    GetDesigner(Temp, Result);
  end;
end;

function FiltKey(Text: String; SelStart: integer; Key: char): char;
begin
  if Key in ['0'..'9', 'e', 'E', '-', ',', '.', #8, '*'] then begin
    case Key of
      '-':
        if not ((SelStart = 0) or SameText(Text[SelStart], 'e')) then
          Key := #0;
      '.', ',':
      begin
        Key := DecimalSeparator;
        if (pos(Key, Text) > 0) or (SelStart = 0) then
          Key := #0;
      end;
      'e', 'E', '*':
      begin
        Key := 'E';
        if Pos(Key, Text) > 0 then
          Key := #0;
      end;
    end;
  end
  else
    Key := #0;
  result := Key;
end;

function FiltKey(Sender: TObject; Key: char): char;
var
  Text: String;
  SelStart: integer;
begin
  Text := ' ';
  SelStart := 1;
  if Sender is TCustomEdit then begin
    Text := (Sender as TCustomEdit).Text;
    SelStart := (Sender as TCustomEdit).SelStart;
  end;
  Result := FiltKey(Text, SelStart, Key);
end;

procedure Cycle(var x: integer; MaxValue: Integer = MaxInt; MinValue: integer = 0);
begin
  if x < MinValue then
    x := MinValue
  else
  if x > MaxValue then
    x := MaxValue
  else
    x := (x + 1 - MinValue) mod (MaxValue - MinValue + 1) + MinValue;
end;

procedure Cycle(var x: word; MaxValue: word; MinValue: word);
begin
  if x < MinValue then
    x := MinValue
  else
  if x > MaxValue then
    x := MaxValue
  else
    x := (x + 1 - MinValue) mod (MaxValue - MinValue + 1) + MinValue;
end;

{ THookPersistent }

function THookPersistent.GetOwner: TPersistent;
begin
  result := inherited GetOwner;
end;

{ THookComponent }

function THookComponent.QueryInterface(const IID: TGUID; out Obj): HRESULT;
begin
  result := inherited QueryInterface(iid, obj);
end;

procedure Carrying(var Source, Dest: word; Period: word);
begin
  while Source > Period do begin
    inc(Dest);
    dec(Source, Period);
  end;
end;

function AbsoluteDay(Year, Month, Day: Word): Word;
var
  i: integer;
begin
  if Year div 4 = 0 then
    DayCountInMonth[2] := 29
  else
    DayCountInMonth[2] := 28;
  Result := 0;
  for i := 1 to Month - 1 do
    Result := Result + ord(DayCountInMonth[i]);
  Result := Result + Day;
end;

function IncDate(Date1, Date2: TSystemTime): TSystemTime;
var
  x, y, m: integer;
begin
  with Date1 do
    x := AbsoluteDay(wYear, wMonth, wDay);
  with Date2 do
    x := x + AbsoluteDay(wYear, wMonth, wDay);
  with Result do
    for y := 0 to 1 do
      for m := 1 to 12 do
        if ord(DayCountInMonth[m]) > x then begin
          wYear := Date1.wYear + Date2.wYear + y;
          wMonth := m;
          wDay := x;
        end
        else
          x := x - ord(DayCountInMonth[m]);
end;

function IncTime(Time1, Time2: TSystemTime): TSystemTime;
begin
  Result.wYear := Time1.wYear + Time2.wYear;
  Result.wMonth := Time1.wMonth + Time2.wMonth;
  Result.wDay := Time1.wDay + Time2.wDay;
  Result.wHour := Time1.wHour + Time2.wHour;
  Result.wMinute := Time1.wMinute + Time2.wMinute;
  Result.wSecond := Time1.wSecond + Time2.wSecond;
  Result.wMilliseconds := Time1.wMilliseconds + Time2.wMilliseconds;
  with Result do begin
    Carrying(wMilliseconds, wSecond, 1000);
    Carrying(wSecond, wMinute, 60);
    Carrying(wMinute, wHour, 60);
    Carrying(wHour, wDay, 24);
  end;
end;

initialization
  ProgramPath := ExtractFilePath(ParamStr(0));
  Randomize;
end.

