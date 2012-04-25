unit PublDB;

interface
Uses DB, Classes;
Type
 TPublDB=Class(TComponent)
 End;
// Преобразование типа поля таблицы в строку
Function FieldTypeToStr(FT:TFieldType):String;
// Преобразование типа поля таблицы в тип SQL
Function FtToSQL(FT: TFieldType; Size:integer): String;
// Копирование таблицы базы данных в другую Paradox-таблицу
procedure CopyDBFile(Source,Dest:string; PKeys:array of string);
// Добавление нового поля
procedure CreateEmptyTable(TableName:String);
// Добавление нового поля
procedure AddField(TableName,FieldName:String; FT:TFieldType; Size:integer);
// Создание индекса
procedure AddIndex(FN, ind, FieldNames: string);
// Изменение кодировки таблицы
procedure TableToAnsi(TableName: string);
procedure TableToOEM(TableName:String);

implementation

Uses SysUtils, DBTables, ViewLog, publ, StrUtils;

Function FtToSQL(FT: TFieldType; Size:integer): String;
begin
 Case ft of
  ftDate: result:='DATE';
  ftTime: result:='TIME';
  ftFloat: result:='FLOAT';
  ftMemo: result:=format('BLOB(%d,1)',[Size]);
  ftBlob: result:=format('BLOB(%d,2)',[Size]);
  ftSmallint: result:='SMALLINT';
  ftInteger: result:='INTEGER';
  ftString: result:=format('CHAR(%d)',[Size]);
 else result:='';
 End;
end;

Function FieldTypeToStr(FT:TFieldType):String;
begin
 Case ft of
  ftUnknown: Result:='ftUnknown';
  ftString: Result:='ftString';
  ftSmallint: Result:='ftSmallint';
  ftInteger: Result:='ftInteger';
  ftWord: Result:='ftWord';
  ftBoolean: Result:='ftBoolean';
  ftFloat: Result:='ftFloat';
  ftCurrency: Result:='ftCurrency';
  ftBCD: Result:='ftBCD';
  ftDate: Result:='ftDate';
  ftTime: Result:='ftTime';
  ftDateTime: Result:='ftDateTime';
  ftBytes: Result:='ftBytes';
  ftVarBytes: Result:='ftVarBytes';
  ftAutoInc: Result:='ftAutoInc';
  ftBlob: Result:='ftBlob';
  ftMemo: Result:='ftMemo';
  ftGraphic: Result:='ftGraphic';
  ftFmtMemo: Result:='ftFmtMemo';
  ftParadoxOle: Result:='ftParadoxOle';
  ftDBaseOle: Result:='ftDBaseOle';
  ftTypedBinary: Result:='ftTypedBinary';
  ftCursor: Result:='ftCursor';
  ftFixedChar: Result:='ftFixedChar';
  ftWideString: Result:='ftWideString';
  ftLargeint: Result:='ftLargeint';
  ftADT: Result:='ftADT';
  ftArray: Result:='ftArray';
  ftReference: Result:='ftReference';
  ftDataSet: Result:='ftDataSet';
  ftOraBlob: Result:='ftOraBlob';
  ftOraClob: Result:='ftOraClob';
  ftVariant: Result:='ftVariant';
  ftInterface: Result:='ftInterface';
  ftIDispatch: Result:='ftIDispatch';
  ftGuid: Result:='ftGuid';
  ftTimeStamp: Result:='ftTimeStamp';
  ftFMTBcd: Result:='ftFMTBcd';
  else Result:='';
 End;
End;


procedure CopyDBFile(Source, Dest: string; PKeys:array of string);
Var
 st1,st2:TStringList;
 sf,sf2,str,fn:String;
 i:integer;
 quConvert:TQuery;
 tabConv:TTable;
 s1,s2:string;
begin
 LogBeg('CopyDBFile');
 quConvert:=TQuery.Create(nil);
 tabConv:=TTable.Create(nil);
 st1:=TStringList.Create;
 st2:=TStringList.Create;
 sf:='(';
 sf2:='';
 quConvert.DataBaseName:=ExtractFilePath(dest);
 With quConvert, tabConv do Begin
  st1.Text:=Format('Create table "%s" (',[Dest]);
  TableName:=Source;
  tabConv.Open;
  st2.clear;
  fn:=ExtractFileName(Dest);
  s1:='';
  s2:='';
  For i:=0 to FieldCount-1 do
   With Fields[i] do Begin
    if s2<>'' then s2:=s2+',';
    s2:=s2+'"'+Dest+'"."'+FieldName+'"';
    if AnsiMatchText(FieldName,PKeys) and (i<7)
    and (DataType in [ftString, ftSmallint, ftInteger,
    ftBoolean, ftFloat, ftCurrency, ftDate, ftDateTime, ftBytes]) then Begin
     if s1<>'' then s1:=s1+',';
     s1:=s1+s2;
     s2:='';
    End;
    str:='"'+Dest+'"."'+FieldName+'" '+FtToSQL(DataType,Size);
    sf:=sf+'"'+fn+'"."'+FieldName+'"';
    sf2:=sf2+'XXX."'+FieldName+'"';
    if i<FieldCount-1 then str:=str+',' else Begin
     str:=str+','#13#10'Primary key ('+s1+'));';
    End;
    if i<FieldCount-1 then sf:=sf+', ' else sf:=sf+')';
    if i<FieldCount-1 then sf2:=sf2+', ' else sf2:=sf2;
    St1.add(str);
   End;
  tabConv.Close;
  St2.Add(format('Insert into "%s" ',[fn]));
  St2.Add(sf);
  St2.Add(format('select %s from "%s" as XXX',[sf2,Source]));
  //ShowMessage(SQL.Text);
  sql.Assign(st1);
  Log(sql.Text);
  ExecSQL;
  sql.Assign(st2);
  Log(sql.Text);
  ExecSQL;
 End;
 st1.Free;
 st2.Free;
 quConvert.Free;
 tabConv.Free;
 LogEnd;
end;

procedure CreateEmptyTable(TableName:String);
Var
 qwt:TQuery;
 s1:string;
begin
 qwt:=TQuery.Create(nil);
 qwt.DataBaseName:=ExtractFilePath(TableName);
 TableName:=ExtractFileName(TableName);
 With qwt do Begin
  s1:=Format('Create table "%s" ()',[TableName]);
  sql.text:=s1;
  ExecSQL;
 End;
 qwt.Free;
end;

procedure AddField(TableName,FieldName:String; FT:TFieldType; Size:integer);
begin
 With TQuery.Create(nil) do Begin
  sql.Text:=Format('Alter table "%s"'#13#10
  +'add "%s"."%s" %s;',[TableName,TableName,FieldName,FtToSQL(ft,size)]);
  Log(sql.Text);
  ExecSQL;
  Free;
 End;
end;

procedure AddIndex(FN, ind, FieldNames: string);
begin
 With TQuery.Create(nil) do Begin
  SQL.Text:=format('Create Index %s on "%s" (%s)',[ind,FN,FieldNames]);
  Log(sql.Text);
  ExecSQL;
  Free;
 End;
end;

procedure TableToAnsi(TableName: string);
Var
 table:TTable;
 i:integer;
 ist:Set of byte;
begin
 table:=TTable.Create(nil);
 table.TableName:=TableName;
 Table.Open;
 Table.Last;
 ist:=[];
 For i:=0 to table.FieldCount-1 do
  if table.Fields[i].DataType in [ftString,ftMemo] then ist:=ist+[i];
 While not table.Bof do Begin
  table.Edit;
  For i:=0 to table.FieldCount-1 do Begin
   if not(i in ist) then Continue;
   table.Fields[i].AsString:=ToAnsi(table.Fields[i].AsString);
  End;
  table.Post;
  table.Prior;
 End;
 table.Close;
 table.Free;
end;

procedure TableToOEM(TableName:String);
Var
 table:TTable;
 i:integer;
 ist:Set of byte;
begin
 table:=TTable.Create(nil);
 table.TableName:=TableName;
 Table.Open;
 For i:=0 to table.FieldCount-1 do
  if table.Fields[i].DataType in [ftString,ftMemo] then ist:=ist+[i];
 While not table.Eof do Begin
  table.Edit;
  For i:=0 to table.FieldCount-1 do Begin
   if not(i in ist) then Continue;
   table.Fields[i].AsString:=ToOEM(table.Fields[i].AsString);
  End;
  table.Post;
  table.Next;
 End;
 table.Close;
 table.Free;
end;

initialization
 //LogFileName:='c:\zzz.zzz';
 LogAutoSave:=true;
end.
