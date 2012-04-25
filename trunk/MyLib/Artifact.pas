////////////////////////////////////////////////////////////////////////////////
//   Компонента имитирующая работу искуственного интелекта
//
//
//                  Copyright Гимаев Наиль 2005г.
//
////////////////////////////////////////////////////////////////////////////////
unit Artifact;
{см. Логика.txt}          
interface
Uses Classes, Publ;
Type
 TAIEnd=(enNone,enDraw,enWin,enLost);
 TAIInitEvent=procedure(Sender:TObject;NewState:TStream) of object;
 TAIChangeEvent=procedure(Sender:TObject;OldState,NewState:TStream) of object;
 TAIEndEvent=procedure(Sender:TObject;Var AIEnd:tAIEnd) of object;

 TArtifact=Class(TComponent)
 private
  State:TMemoryStream;
  FS:TFileStream;
  FMaxOfStep: integer;
  FFileName: String;
  FonCPUStep: TAIChangeEvent;
  FonManStep: TAIChangeEvent;
  FonInit: TAIInitEvent;
  FonEndGame: TAIEndEvent;
  procedure SetFileName(const Value: String);
  procedure SetMaxOfStep(const Value: integer);
  procedure SetonCPUStep(const Value: TAIChangeEvent);
  procedure SetonInit(const Value: TAIInitEvent);
  procedure SetonManStep(const Value: TAIChangeEvent);
  procedure SetonEndGame(const Value: TAIEndEvent);
  function GetIam: TArtifact;
 public
  Function GetStep(Balls:ai):integer;
  constructor Create(AOwner: TComponent); override;
  destructor Destroy; override;
  procedure DoStep;
 published
  property onInit:TAIInitEvent read FonInit write SetonInit;
  property onManStep:TAIChangeEvent read FonManStep write SetonManStep;
  property onCPUStep:TAIChangeEvent read FonCPUStep write SetonCPUStep;
  property onEndGame:TAIEndEvent read FonEndGame write SetonEndGame;
  property FileName:String read FFileName write SetFileName;
  property MaxOfStep:integer read FMaxOfStep write SetMaxOfStep;
  property Iam:TArtifact read GetIam;
 End;

implementation

uses SysUtils, Dialogs;
{ TArtifact }

constructor TArtifact.Create(AOwner: TComponent);
begin
 inherited;
 State:=TMemoryStream.Create;
 FS:=nil;
end;

destructor TArtifact.Destroy;
begin
 FS.Free;
 State.Free;
 inherited;
end;

procedure TArtifact.DoStep;
begin
 
end;

function TArtifact.GetIam: TArtifact;
begin
 result:=self;
end;

function TArtifact.GetStep(Balls: ai): integer;
Var
 i,x,sum:integer;
begin
 result:=-1;
 Sum:=0;
 For i:=0 to High(Balls) do sum:=sum+Balls[i];
 x:=Random(Sum);
 Sum:=0;
 For i:=0 to High(Balls) do Begin
  sum:=sum+Balls[i];
  result:=i;
  if sum>x then break;
 End;
end;

procedure TArtifact.SetFileName(const Value: String);
Var
 fm:Word;
begin
 FFileName := Value;
 if FileExists(Value) then fm:=fmOpenReadWrite else fm:=fmCreate;
 if fs<>nil then FreeAndNil(fs);
 FS:=TFileStream.Create(Value,fm);
end;

procedure TArtifact.SetMaxOfStep(const Value: integer);
begin
  FMaxOfStep := Value;
end;

procedure TArtifact.SetonCPUStep(const Value: TAIChangeEvent);
begin
  FonCPUStep := Value;
end;

procedure TArtifact.SetonEndGame(const Value: TAIEndEvent);
begin
  FonEndGame := Value;
end;

procedure TArtifact.SetonInit(const Value: TAIInitEvent);
begin
  FonInit := Value;
end;

procedure TArtifact.SetonManStep(const Value: TAIChangeEvent);
begin
 FonManStep := Value;
end;

end.

