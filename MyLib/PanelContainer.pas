unit PanelContainer;

interface

uses
 SysUtils, Classes, Controls, ExtCtrls, ComCtrls, Forms, Types,
 Graphics, Messages;

type
  TPanelContainer = class(TPanel)
  private
   Do_Rebuild:boolean;
   FSubHeight: integer;
   F_OneSize: boolean;
   procedure Rebuild;
   procedure SetSubHeight(const Value: integer);
   procedure CMControlChange(var Message: TCMControlListChange); message CM_CONTROLCHANGE;
   procedure Set_OneSize(const Value: boolean);
    procedure SetCaption(const Value: String);
    function GetIam: TPanelContainer;
  protected
   procedure Resize; override;
   procedure AlignControls(AControl: TControl; var Rect: TRect); override;
  public
   constructor Create(AOwner: TComponent); override;
   destructor Destroy; override;
   property Iam:TPanelContainer read GetIam;
  published
   property A0_SubPanelHeight:integer read FSubHeight
    write SetSubHeight default 50;
   property A0_OneSize:boolean read F_OneSize write Set_OneSize default true;
   property Caption:String Write SetCaption;
  end;

implementation

{ TPanelContainer }

procedure TPanelContainer.AlignControls(AControl: TControl;
  var Rect: TRect);
begin
 Rebuild;
end;

procedure TPanelContainer.CMControlChange(var Message: TCMControlListChange);
begin
 inherited;
 if Message.Inserting
  then if not (Message.Control is TPanel)
   then With Message.Control do Begin
    Do_Rebuild:=false;
    Visible:=false;
    With ClientToParent(Point(0,0)) do Begin
     Left:=x;
     Top:=y;
    End;
    Parent:=self.parent;
    Visible:=true;
    Do_Rebuild:=true;
   End else ReBuild
  else Rebuild;
end;

constructor TPanelContainer.Create(AOwner: TComponent);
begin
 inherited;
 Do_Rebuild:=true;
 FSubHeight:=50;
 Caption:=' ';
end;

destructor TPanelContainer.Destroy;
begin
  {events.txt}
  inherited;
end;

function TPanelContainer.GetIam: TPanelContainer;
begin
 result:=self;
end;

procedure TPanelContainer.Rebuild;
Var
 i,j,n,w,h,t:integer;
 rs:array of TPoint;
 x:TPoint;
 panel:TPanel;
 asz:boolean;
begin
 if not Do_Rebuild then Exit;
 n:=ControlCount;
 if n=0 then Exit;
 Do_Rebuild:=false;
 SetLength(rs,n);
 For i:=0 to n-1 do Begin
  rs[i].x:=0;
  rs[i].y:=i;
  if not (Controls[i] is tPanel) then Continue;
  panel:=TPanel(Controls[i]);
  if F_OneSize then Panel.Height:=FSubHeight;
  rs[i].x:=panel.TabOrder;
  rs[i].y:=i;
 End;
 For i:=0 to n-2 do
  For j:=0 to n-2-i do
   if rs[j].x>rs[j+1].x then Begin
    x:=rs[j];
    rs[j]:=rs[j+1];
    rs[j+1]:=x;
   End;
 w:=0;
 h:=0;
 t:=0;
 asz:=AutoSize;
 AutoSize:=false;
 For i:=0 to n-1 do Begin
  j:=rs[i].y;
  if not (Controls[j] is tPanel) then Continue;
  panel:=TPanel(Controls[j]);
  if (w>0) and (w+panel.Width>Width) then Begin
   w:=0;
   t:=t+h;
   h:=0;
  End;
  Panel.Top:=t;
  Panel.Left:=w;
  w:=w+panel.Width;
  if h<Panel.Height then h:=panel.Height;
 End;
 AutoSize:=asz;
 Do_Rebuild:=true;
 SetLength(rs,0);
end;

procedure TPanelContainer.Resize;
begin
 inherited;
 Rebuild;
end;

procedure TPanelContainer.SetCaption(const Value: String);
begin
 inherited Caption:=Value;
end;

procedure TPanelContainer.SetSubHeight(const Value: integer);
begin
 FSubHeight := Value;
 if F_OneSize then Rebuild;
end;

procedure TPanelContainer.Set_OneSize(const Value: boolean);
begin
 F_OneSize := Value;
 if Value then Rebuild;
end;

end.
