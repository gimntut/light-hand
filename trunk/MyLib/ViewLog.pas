{$WARN UNSAFE_TYPE Off}
{$WARN UNSAFE_CODE Off}
{$WARN UNSAFE_CAST Off}
unit ViewLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ImgList, ComCtrls, ToolWin, publ, DB, Menus;
type
  TViewLog=Class(TComponent)
  End;
  TLogWindow = class(TForm)
   Memo1: TMemo;
   ToolBar1: TToolBar;
   ToolButton1: TToolButton;
   Label1: TLabel;
   ToolButton2: TToolButton;
   ImageList1: TImageList;
   SaveDialog1: TSaveDialog;
   ToolButton3: TToolButton;
   ToolButton4: TToolButton;
   ToolButton5: TToolButton;
   ToolButton6: TToolButton;
   ToolButton7: TToolButton;
   procedure ToolButton1Click(Sender: TObject);
   procedure DoAlign(Sender: TObject);
   procedure FormCreate(Sender: TObject);
  private
   function Hook(var Message: TMessage): Boolean;
   procedure ShowLogWindow(Sender: TObject);
  protected
   procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;
  public
  end;

procedure Log(s:string);
procedure LogFmt(s:string;const x:Array of const);
procedure LogTime;
procedure LogInt(x:integer);
procedure LogInc(s:string);
procedure LogDec(s:string);
procedure LogIncIndt;
procedure LogDecIndt;
procedure LogComponentState(AComp:TComponent);
procedure LogClassName(AObj:TObject);
procedure LogCompName(AComp:TComponent);
procedure LogContStyle(Cont:TControl);
procedure LogControlState(ACont:TControl);
procedure LogWindowActivate;
procedure LogMemCount;
procedure LogMemSize;
procedure LogBeg(s:string);
procedure LogEnd;
procedure LogFieldType(Field:TField);
procedure LogMsg(Msg:Cardinal);
procedure LogFileSet(FN:String);
procedure LogLock;
procedure LogUnLock;
Var
 LogAutoSave:boolean=false;
 LogMark:array[0..10] of integer;
implementation
{$R *.dfm}
var
 LogWindow: TLogWindow=nil;
 TimeOfStart:TDateTime;
 sts:TStringList;
 LogSts:TStringList;
 Indent:String;
 LogFileName:String;
 FLock:boolean=false;
Const
 ID_ShowLogWindow=Wm_user+1;
procedure VerifyFN;
Var
 ProgramPath:string;
begin
 ProgramPath:=ExtractFilePath(ParamStr(0));
 if (Application<>nil) and (Application.MainForm<>nil) then ;
 if LogFileName='' then LogFileName:=ProgramPath+'Log.txt';
end;

procedure Log(s:string);
begin
 if FLock then Exit;
 s:=Indent+s;
 LogSts.Add(s);
 if LogAutoSave then Begin
  VerifyFN;
  LogSts.SaveToFile(LogFileName);
 End;
 if LogWindow=nil then Exit;
 With LogWindow do Begin
  if not Visible then show;
  Memo1.lines.Add(s);
  Label1.Caption:=format('%d строк(и)',[Memo1.Lines.Count]);
 End;
end;

procedure LogFmt(s:string;const x:Array of const);
begin
 Log(format(s,x));
end;

procedure LogInt(x:integer);
begin
 LogFmt('%d',[x]);
end;

procedure LogTime;
Var
 h,m,s,ms:Word;
 x:TDateTime;
 st:string;
begin
 st:='';
 x:=TimeOfStart;
 TimeOfStart:=Time;
 DecodeTime(TimeOfStart-x,h,m,s,ms);
 if h>0 then st:=Format('%dч:%dм',[h,m])
 else if m>0 then st:=Format('%dм:%dс',[m,s])
 else if s>0 then st:=Format('%dc:%dмс',[s,ms])
 else st:=Format('%dмс',[ms]);
 LogFmt('Время=%s. Прошло %s',[TimeToStr(TimeOfStart),st]);
end;

procedure LogInc(s:string);
Var
 x,n:integer;
begin
 x:=sts.Add(s);
 n:=Integer(sts.Objects[x]);
 Inc(n);
 sts.Objects[x]:=TObject(n);
 LogFmt('%s=%d',[sts[x],n]);
end;

procedure LogDec(s:string);
Var
 x,n:integer;
begin
 x:=sts.Add(s);
 n:=Integer(sts.Objects[x]);
 dec(n);
 sts.Objects[x]:=TObject(n);
 LogFmt('%s=%d',[sts[x],n]);
end;

//////////////////////////////////////////////////
procedure TLogWindow.ToolButton1Click(Sender: TObject);
begin
 if SaveDialog1.Execute then Begin
  Memo1.Lines.SaveToFile(SaveDialog1.FileName);
 End;
end;

procedure TLogWindow.DoAlign(Sender: TObject);
begin
 Case TControl(Sender).tag of
  1: Align:=alLeft;
  2: Align:=alTop;
  3: Align:=alNone;
  4: Align:=alBottom;
  5: Align:=alRight;
 End;
 if Align=alNone
 then FormStyle:=fsNormal
 else FormStyle:=fsStayOnTop;
end;

procedure LogComponentState(AComp:TComponent);
Var
 s,st:string;
begin
 if AComp=nil then Begin
  Log('Component = nil; ComponentState=???');
  Exit;
 End;
 st:='';
 With AComp do Begin
  s:=Name;
  if s='' then s:='Объект класса '+ClassName;
  s:=s+'.ComponentState=[';
  if csLoading in ComponentState then st:=st+'csLoading, ';
  if csReading in ComponentState then st:=st+'csReading, ';
  if csWriting in ComponentState then st:=st+'csWriting, ';
  if csDestroying in ComponentState then st:=st+'csDestroying, ';
  if csDesigning in ComponentState then st:=st+'csDesigning, ';
  if csAncestor in ComponentState then st:=st+'csAncestor, ';
  if csUpdating in ComponentState then st:=st+'csUpdating, ';
  if csFixups in ComponentState then st:=st+'csFixups, ';
  if csFreeNotification in ComponentState then st:=st+'csFreeNotification, ';
  if csInline in ComponentState then st:=st+'csInline, ';
  if csDesignInstance in ComponentState then st:=st+'csDesignInstance, ';
 End;
 if st<>'' then st:=Copy(st,1,Length(st)-2);
 Log(s+st+']');
end;

procedure LogControlState(ACont:TControl);
Var
 s,st:string;
begin
 if ACont=nil then Begin
  Log('Control = nil; ControlState=???');
  Exit;
 End;
 st:='';
 With ACont do Begin
  s:=Name;
  if s='' then s:='Объект класса '+ClassName;
  s:=s+'.ControlState=[';
  if csLButtonDown in ControlState then st:=st+'csLButtonDown, ';
  if csClicked in ControlState then st:=st+'csClicked, ';
  if csPalette in ControlState then st:=st+'csPalette, ';
  if csReadingState in ControlState then st:=st+'csReadingState, ';
  if csAlignmentNeeded in ControlState then st:=st+'csAlignmentNeeded, ';
  if csFocusing in ControlState then st:=st+'csFocusing, ';
  if csCreating in ControlState then st:=st+'csCreating, ';
  if csPaintCopy in ControlState then st:=st+'csPaintCopy, ';
  if csCustomPaint in ControlState then st:=st+'csCustomPaint, ';
  if csDestroyingHandle in ControlState then st:=st+'csDestroyingHandle, ';
  if csDocking in ControlState then st:=st+'csDocking, ';
 End;
 if st<>'' then st:=Copy(st,1,Length(st)-2);
 Log(s+st+']');
end;

procedure LogWindowActivate;
begin
 if LogWindow=nil then LogWindow:=tLogWindow.Create(nil);
 LogWindow.Show;
end;

procedure LogMemCount;
Var
 x:integer;
begin
 x:=LogSts.Count;;
 //if LogWindow<>nil then x:=x*2;
 LogFmt('Кол-во блоков памяти = %d',[AllocMemCount-x]);
end;

procedure LogMemSize;
//Var
// x:integer;
begin
 //x:=Length(LogSts.Text);
 //if LogWindow<>nil then x:=x*2;
 LogFmt('Размер занятой памяти = %d',[AllocMemSize]);
end;

procedure LogIncIndt;
begin
 Indent:=Indent+'  ';
end;

procedure LogDecIndt;
begin
 if Indent<>'' then Delete(Indent,1,2);
end;

procedure LogBeg(s:string);
begin
 Log('* '+s);
 LogIncIndt;
end;

procedure LogEnd;
begin
 LogDecIndt;
end;

procedure LogFieldType(Field:TField);
begin
end;

procedure LogClassName(AObj:TObject);
begin
 if AObj=nil
 then Log('Object = nil')
 else With AObj do
  LogFmt('%s',[ClassName]);
end;

procedure LogCompName(AComp:TComponent);
begin
 if AComp=nil
 then Log('Control = nil')
 else With AComp do
  LogFmt('%s:%s',[Name,ClassName]);
end;

procedure LogMsg(Msg:Cardinal);
begin
 Log(MsgToStr(Msg));
end;

procedure LogContStyle(Cont:TControl);
Var
 s:String;
 i:integer;
Const
 cs:array[0..18] of String=('csAcceptsControls', 'csCaptureMouse', 'csDesignInteractive',
  'csClickEvents', 'csFramed', 'csSetCaption', 'csOpaque', 'csDoubleClicks',
  'csFixedWidth', 'csFixedHeight', 'csNoDesignVisible', 'csReplicatable',
  'csNoStdEvents', 'csDisplayDragImage', 'csReflector', 'csActionClient',
  'csMenuEvents', 'csNeedsBorderPaint', 'csParentBackground');
Begin
 if Cont=nil then Begin
  Log('Control = nil; ControlStyle=???');
  Exit;
 End;
 s:='';
 For i:=0 to 18 do Begin
  if odd(Integer(Pointer(@Cont.ControlStyle)^) shr i) then s:=ContStr(s,', ',cs[i]);
 End;
 if Cont.Name=''
  then s:='Объект класса '+Cont.ClassName+'.ControlStyle=['+s+']'
  else s:=Cont.Name+'.ControlStyle=['+s+']';
 Log(s);
End;

procedure LogFileSet(FN:String);
begin
 if (LogFileName='') then Begin
  if DirectoryExists(ExtractFileDir(FN)) then LogFileName:=FN;
 End else ShowMessageFmt('Файл лога уже задан:'#13#10'%s',[LogFileName]);
end;

procedure LogLock;
begin
 FLock:=true;
end;

procedure LogUnLock;
begin
 FLock:=false;
end;

procedure TLogWindow.WMSysCommand(var Message: TWMSysCommand);
begin
 case Message.CmdType of
  ID_ShowLogWindow: ShowLogWindow(Self);
  else inherited;
 end;
end;

procedure TLogWindow.ShowLogWindow(Sender: TObject);
begin
 show;
end;

Var
 i:integer;
function TLogWindow.Hook(var Message: TMessage): Boolean;
begin
 Result:=false;
 With Message do Begin
  if Msg<>WM_SYSCOMMAND then Exit;
  if WParam<>ID_ShowLogWindow then Exit;
  ShowLogWindow(self);
 End;
 Result:=true;
end;

procedure TLogWindow.FormCreate(Sender: TObject);
Var
 FMenu:HMENU;
begin
 FMenu:=GetSystemMenu(Application.Handle, False);
 InsertMenu(FMenu, 0, MF_STRING or MF_BYPOSITION, ID_ShowLogWindow, PChar('Показать лог'));
 Application.HookMainWindow(Hook);
end;

initialization
 For i:=0 to 10 do LogMark[i]:=0;
 LogWindow:=nil;
 //LogWindowActivate;
 //FreeAndNil(LogWindow);
 TimeOfStart:=Time;
 LogSts:=TStringList.Create;
 sts:=TStringList.Create;
 sts.Sorted:=true;
 sts.CaseSensitive:=false;
 sts.Duplicates:=dupIgnore;
 LogFileName:='';
 Indent:='';
finalization
 sts.Free;
 if LogSts.Count>0 then Begin
  VerifyFN;
  LogSts.SaveToFile(LogFileName);
 End;
 LogSts.Free;
 if LogWindow<>nil then LogWindow.Free;
end.

