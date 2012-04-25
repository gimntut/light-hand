///////////////////////////////////////////////////////////////////////
//           Набор компонент заменяющий ToolBar и SpeedBtn           //
//                                                                   //
//                                                                   //
//                  Copyright Гимаев Наиль 2005г.                    //
//                                                                   //
///////////////////////////////////////////////////////////////////////

unit CoolBtn;

interface

uses
  Windows, SysUtils, Classes, Controls, ExtCtrls, Graphics, publ, Messages, Types,
  ActnList, Forms, Dialogs, PublGraph, Menus;

type
  TXColor=( xxGREEN,xxPINK,xxRED,xxBrightBlue,xxBrightCyan,xxBrightLime,
   xxBrightOrange,xxBrightPurple,xxBrightRed,xxBrightYellow,
   xxDarkBlack,xxDarkBlue,xxDarkBrown,xxDarkGreen,xxDarkRed,xxDarkSkin,
   xxLightGreen,xxLightPink,xxLightPurple,xxLightYellow,xxMediumGray,
   xxMediumGreen,xxMediumSkin,xxBrightPink);

  TCoolPanel=class;
  TCoolBtn=class;

  TCoolStyle=class(TComponent)
  private
   FHard:Boolean;
   FTextColOff:TColor;
   FTextColOn:TColor;
   FFontOn:TFont;
   FFontOff:TFont;
   FColorOn:TXColor;
   FColorOff:TXColor;
   CoolBtns:array of TCoolBtn;
   procedure SetColorOff(const Value:TXColor);
   procedure SetColorOn(const Value:TXColor);
   procedure SetHard(const Value:Boolean);
   procedure SetTextColOff(const Value:TColor);
   procedure SetTextColOn(const Value:TColor);
   procedure DoChange;
   function  Find(CoolBtn:TCoolBtn):integer;
   procedure FntChange(Sender:TObject);
   procedure SetFontOff(const Value:TFont);
   procedure SetFontOn(const Value:TFont);
   function GetIam:TCoolStyle;
  protected
  public
   constructor Create(AOwner:TComponent); override;
   destructor Destroy; override;
   procedure Add(CoolBtn:TCoolBtn);
   procedure Delete(CoolBtn:TCoolBtn);
   property Iam:TCoolStyle read GetIam;
  published
   property TextColOn:TColor read FTextColOn write SetTextColOn;
   property FontOn:TFont read FFontOn write SetFontOn;
   property ColorOn:TXColor read FColorOn write SetColorOn;
   property Hard:Boolean read FHard write SetHard;
   property TextColOff:TColor read FTextColOff write SetTextColOff;
   property FontOff:TFont read FFontOff write SetFontOff;
   property ColorOff:TXColor read FColorOff write SetColorOff;
  End;

  TIndexEvent = procedure(Sender:TObject;Var Index:Integer) of object;

  TCoolBtn = class(TGraphicControl)
  private
   bm:TBitMap;
   bmAll:TBitMap;
   bmOff:TBitMap;
   bmOn:TBitMap;
   dwn:boolean;
   FaClick:boolean;
   FActIn:TAction;
   FActive:boolean;
   FAllowCheck:boolean;
   FColorOff:TXColor;
   FColorOn:TXColor;
   FCoolStyle:TCoolStyle;
   FDown:boolean;
   FFont:TFont;
   FGroupIndex:Integer;
   FHard:boolean;
   FOnBeforeChangeActive:TBoolEvent;
   FOnChangeActive:TBoolEvent;
   FOnChangeDown:TBoolEvent;
   FOnIndex:TIndexEvent;
   FOrder:integer;
   FTextBoth:String;
   FTextColOff:TColor;
   FTextColOn:TColor;
   FTextOff:String;
   FTextOn:String;
   IsRealign:boolean;
   Modified:boolean;
   function _ColOff:boolean;
   function _ColOn:boolean;
   function _Hard:boolean;
   function _TextColOff:boolean;
   function _TextColOn:boolean;
   function GetColorOff:TXColor;
   function GetColorOn:TXColor;
   function GetFont:TFont;
   function GetHard:boolean;
   function GetIndex:integer;
   function GetTextColOff:TColor;
   function GetTextColOn:TColor;
   function WithoutStyle:boolean;
   function xx(col:TXColor):string;
   procedure AcClick(Sender:TObject);
   procedure Draw;
   procedure DrawDown;
   procedure DrwBtn;
   procedure LoadBM(bm:TBitMap;Color:TXColor);
   procedure OutText_(bmv:TBitMap);
   procedure SetActive(const Value:boolean);
   procedure SetColorOff(const Value:TXColor);
   procedure SetColorOn(const Value:TXColor);
   procedure SetCoolStyle(const Value:TCoolStyle);
   procedure SetDown(const Value:boolean);
   procedure SetFont(const Value:TFont);
   procedure SetGroupIndex(const Value:Integer);
   procedure SetTextBoth(const Value:String);
   procedure SetTextColOff(const Value:TColor);
   procedure SetTextColOn(const Value:TColor);
   procedure SetTextOff(const Value:String);
   procedure SetTextOn(const Value:String);
   procedure WMLButtonDown(var Message:TWMLButtonDown); message WM_LBUTTONDOWN;
   procedure WMLButtonUp(var Message:TWMLButtonUp); message WM_LBUTTONUP;
  protected
   procedure Paint; override;
   procedure CMFontChanged(var Message:TMessage); message CM_FONTCHANGED;
   procedure Notification(AComponent:TComponent; Operation:TOperation); override;
   procedure SetParent(AParent:TWinControl); override;
   procedure RequestAlign; override;
  public
   constructor Create(AOwner:TComponent); override;
   destructor Destroy; override;
   function GetIam:TCoolBtn;
   procedure AllUp;
   procedure Click; override;
   procedure Repaint; override;
   property ActIn:TAction read FActIn;
   property Canvas;
   property Iam:TCoolBtn read GetIam;
   property Index:integer read GetIndex;
  published
   property aClick:boolean read FaClick write FaClick;
   property Active:boolean read FActive write SetActive default true;
   property Align;
   property AllowCheck:boolean read FAllowCheck write FAllowCheck default false;
   property Anchors;
   property ColorOff:TXColor read GetColorOff write SetColorOff stored _ColOff;
   property ColorOn:TXColor read GetColorOn write SetColorOn stored _ColOn;
   property Constraints;
   property CoolStyle:TCoolStyle read FCoolStyle write SetCoolStyle;
   property Down:boolean read FDown write SetDown default false;
   property Enabled;
   property Font:TFont read GetFont write SetFont stored WithoutStyle;
   property GroupIndex:Integer read FGroupIndex write SetGroupIndex;
   property Hard:boolean read GetHard write FHard stored _Hard;
   property Hint;
   property OnBeforeChangeActive:TBoolEvent read FOnBeforeChangeActive write FOnBeforeChangeActive;
   property OnChangeActive:TBoolEvent read FOnChangeActive write FOnChangeActive;
   property OnChangeDown:TBoolEvent read FOnChangeDown write FOnChangeDown;
   property OnClick;
   property OnDblClick;
   property OnMouseDown;
   property OnMouseMove;
   property OnMouseUp;
   property ParentShowHint;
   property ShowHint;
   property TextBoth:String read FTextBoth write SetTextBoth;
   property TextColOff:TColor read GetTextColOff write SetTextColOff stored _TextColOff;
   property TextColOn:TColor read GetTextColOn write SetTextColOn stored _TextColOn;
   property TextOff:String read FTextOff write SetTextOff stored false;
   property TextOn:String read FTextOn write SetTextOn stored false;
   property Visible;
  end;

  TCoolItem = class(TCollectionItem)
  private
   FButton:TCoolBtn;
   FDestroing:boolean;
   function GetActIn:TAction;
   function GetAlign:TAlign;
   function GetAnchors:TAnchors;
   function GetColorOff:TXColor;
   function GetColorOn:TXColor;
   function GetConstraints:TSizeConstraints;
   function GetCoolStyle:TCoolStyle;
   function GetFont:TFont;
   function GetGroupIndex:Integer;
   function GetOnBeforeChangeActive:TBoolEvent;
   function GetOnChangeActive:TBoolEvent;
   function GetOnChangeDown:TBoolEvent;
   function GetOnClick:TNotifyEvent;
   function GetOnDblClick:TNotifyEvent;
   function GetOnMouseDown:TMouseEvent;
   function GetOnMouseMove:TMouseMoveEvent;
   function GetOnMouseUp:TMouseEvent;
   function GetOptions(x:integer):boolean;
   function GetStrings(x:integer):string;
   function GetTextColOff:TColor;
   function GetTextColOn:TColor;
   function GetWidth:Integer;
   procedure SetAlign(const Value:TAlign);
   procedure SetAnchors(const Value:TAnchors);
   procedure SetButton(const Value:TCoolBtn);
   procedure SetColorOff(const Value:TXColor);
   procedure SetColorOn(const Value:TXColor);
   procedure SetConstraints(const Value:TSizeConstraints);
   procedure SetCoolStyle(const Value:TCoolStyle);
   procedure SetFont(const Value:TFont);
   procedure SetGroupIndex(const Value:Integer);
   procedure SetOnBeforeChangeActive(const Value:TBoolEvent);
   procedure SetOnChangeActive(const Value:TBoolEvent);
   procedure SetOnChangeDown(const Value:TBoolEvent);
   procedure SetOnClick(const Value:TNotifyEvent);
   procedure SetOnDblClick(const Value:TNotifyEvent);
   procedure SetOnMouseDown(const Value:TMouseEvent);
   procedure SetOnMouseMove(const Value:TMouseMoveEvent);
   procedure SetOnMouseUp(const Value:TMouseEvent);
   procedure SetOptions(x:integer; const Value:boolean);
   procedure SetStrings(x:integer; const Value:string);
   procedure SetTextColOff(const Value:TColor);
   procedure SetTextColOn(const Value:TColor);
   procedure SetWidth(const Value:Integer);
  protected
   function GetDisplayName:String; override;
  Public
   constructor Create(Collection:TCollection); override;
   destructor Destroy; override;
   property ActIn:TAction read GetActIn;
   property Destroing:boolean read FDestroing;
   property Options[Index:integer]:boolean read GetOptions write SetOptions;
   property Strings[Index:integer]:string read GetStrings write SetStrings;
   property Width:Integer read GetWidth write SetWidth;
  published
   property aClick:boolean index 1 read GetOptions write SetOptions stored false;
   property Active:boolean index 2 read GetOptions write SetOptions stored false;
   property Align:TAlign read GetAlign write SetAlign stored false;
   property AllowCheck:boolean index 3 read GetOptions write SetOptions stored false;
   property Anchors:TAnchors read GetAnchors write SetAnchors stored false;
   property Button:TCoolBtn read FButton write SetButton;
   property ColorOff:TXColor read GetColorOff write SetColorOff stored false;
   property ColorOn:TXColor read GetColorOn write SetColorOn stored false;
   property Constraints:TSizeConstraints read GetConstraints write SetConstraints stored false;
   property CoolStyle:TCoolStyle read GetCoolStyle write SetCoolStyle stored false;
   property Down:boolean index 4 read GetOptions write SetOptions stored false;
   property Enabled:Boolean index 6 read GetOptions write SetOptions stored false;
   property Font:TFont read GetFont write SetFont stored false;
   property GroupIndex:Integer read GetGroupIndex write SetGroupIndex stored false;
   property Hard:boolean index 5 read GetOptions write SetOptions stored false;
   property Hint:string index 1 read GetStrings write SetStrings;
   property Name:string index 5 read GetStrings write SetStrings;
   property OnBeforeChangeActive:TBoolEvent read GetOnBeforeChangeActive write SetOnBeforeChangeActive stored false;
   property OnChangeActive:TBoolEvent read GetOnChangeActive write SetOnChangeActive stored false;
   property OnChangeDown:TBoolEvent read GetOnChangeDown write SetOnChangeDown stored false;
   property OnClick:TNotifyEvent read GetOnClick write SetOnClick stored false;
   property OnDblClick:TNotifyEvent read GetOnDblClick write SetOnDblClick stored false;
   property OnMouseDown:TMouseEvent read GetOnMouseDown write SetOnMouseDown stored false;
   property OnMouseMove:TMouseMoveEvent read GetOnMouseMove write SetOnMouseMove stored false;
   property OnMouseUp:TMouseEvent read GetOnMouseUp write SetOnMouseUp stored false;
   property ParentShowHint:Boolean index 7 read GetOptions write SetOptions stored false;
   property ShowHint:Boolean index 8 read GetOptions write SetOptions stored false;
   property TextBoth:String index 4 read GetStrings write SetStrings;
   property TextColOff:TColor read GetTextColOff write SetTextColOff stored false;
   property TextColOn:TColor read GetTextColOn write SetTextColOn stored false;
   property TextOff:String index 3 read GetStrings write SetStrings;
   property TextOn:String index 2 read GetStrings write SetStrings;
   property Visible:Boolean index 9 read GetOptions write SetOptions stored false;
  End;
  // todo -cClass:TCoolCoolection
  TCoolCollection = class(TCollection)
  private
   AddFromCollection:boolean;
   AddFromPanel:boolean;
   DeleteFromCollection:boolean;
   FRestore:boolean;
   Owner:TCoolPanel;
   function GetIam:TCoolCollection;
   function GetItems(x:integer):TCoolItem;
   function IsReading:boolean;
   procedure ItemIndex(Sender:Tobject; Var Index:integer);
   procedure SetItems(x:integer; const Value:TCoolItem);
  protected
   function  GetOwner:TPersistent; override;
   procedure Notify(Item:TCollectionItem; Action:TCollectionNotification); override;
   procedure Update(Item:TCollectionItem); override;
  public
   constructor Create(AOwner:TCoolPanel);
   destructor Destroy; override;
   function Add(Btn:TCoolBtn):TCoolItem; overload;
   function IndexOf(Btn:TCoolBtn):integer;
   procedure Delete(btn:TCoolBtn); overload;
   property Iam:TCoolCollection read GetIam;
   property Items[x:integer]:TCoolItem read GetItems write SetItems; default;
  end;

  TCoolPanel=class(TPanel)
  private
   OldWidth:integer;
   FButtons:TCoolCollection;
   Temp:TWinControl;
   function  GetIam:TCoolPanel;
   function  GetIsDesign:boolean;
   procedure SetButtons(const Value:TCoolCollection);
  protected
   procedure CMControlChange(var Message:TCMControlChange); message CM_CONTROLCHANGE;
   procedure CMControlListChange(var Message:TCMControlListChange); message CM_CONTROLLISTCHANGE;
   procedure Resize; override;
   procedure SetParent(AParent:TWinControl); override;
   procedure UpdateX(x:integer);
   procedure VisibleChanging; override;
   property IsDesign:boolean read GetIsDesign;
  public
   constructor Create(AOwner:TComponent); override;
   destructor Destroy; override;
   procedure AllUp;
   procedure Repaint; override;
   procedure Restruct;
   procedure View;
   property  Iam:TCoolPanel read GetIam;
  published
   property Buttons:TCoolCollection read FButtons write SetButtons;
   property Caption stored false;
  end;
  ////////////////////// x //////////////////////
  TChangeIndexEvent=procedure(Sender:TObject; OldIndex,NewIndex:Integer) of object;
implementation
{$R buttons_.res}
uses Math, DateUtils
//},ViewLog
;
Var
 IsRepaint:Boolean=false;
{ TCoolBtn }

procedure TCoolBtn.DrwBtn;
begin
 if Parent=nil then Exit;
 if not Parent.HandleAllocated then Exit;
 if Modified or (bmAll.Width<>Width) or (bmAll.Height<>Height) then
  if fDown then DrawDown else Draw;
 Canvas.Draw(0,0,bmAll);
 Modified:=false;
end;

procedure TCoolBtn.SetColorOff(const Value:TXColor);
begin
 Modified:=(FColorOff<>Value) and (CoolStyle=nil);
 FColorOff:=Value;
 LoadBM(bmOff,Value);
 if not fActive then Paint;
end;

procedure TCoolBtn.SetColorOn(const Value:TXColor);
begin
 Modified:=(FColorOn<>Value) and (CoolStyle=nil);;
 FColorOn:=Value;
 LoadBM(bmOn,Value);
 if fActive then Paint;
end;

procedure TCoolBtn.SetFont(const Value:TFont);
begin
 inherited Font:=Value;
 Canvas.Font:=Value;
 Repaint;
end;

procedure TCoolBtn.SetActive(const Value:boolean);
Var
 us:boolean;
begin

 us:=FActive<>Value;
 if Assigned(fOnBeforeChangeActive)
  then FOnBeforeChangeActive(self,Value);
 if Value and us then Begin
  FActive:=Value;
  AllUp;
 End;
 if Value then bm:=bmOn else bm:=bmOff;
 FActive:=Value;
 Modified:=us;
 if Assigned(fOnChangeActive) then FOnChangeActive(self,Value);
 Paint;
end;

procedure TCoolBtn.SetTextOn(const Value:String);
begin

 Modified:=(FTextOn<>Value) and (CoolStyle=nil);
 FTextOn:=Value;
 if Active then ActIn.Caption:=Value;
 FTextBoth:=FTextOff+'|'+FTextOn;
 Paint;
end;

procedure TCoolBtn.SetTextColOff(const Value:TColor);
begin
 Modified:=(FTextColOff<>Value) and (CoolStyle=nil);
 FTextColOff:=Value;
 Font.Color:=Value;
 Paint;
end;

procedure TCoolBtn.SetTextColOn(const Value:TColor);
begin
 Modified:=(FTextColOn<>Value) and (CoolStyle=nil);
 FTextColOn:=Value;
 Font.Color:=Value;
 Paint;
end;

function TCoolBtn.xx(col:TXColor):string;
begin
 case col of
  xxGREEN:result:='GREEN';
  xxPINK:result:='PINK';
  xxRED:result:='RED';
  xxBrightBlue:result:='BrightBlue';
  xxBrightCyan:result:='BrightCyan';
  xxBrightLime:result:='BrightLime';
  xxBrightOrange:result:='BrightOrange';
  xxBrightPurple:result:='BrightPurple';
  xxBrightRed:result:='BrightRed';
  xxBrightYellow:result:='BrightYellow';
  xxDarkBlack:result:='DarkBlack';
  xxDarkBlue:result:='DarkBlue';
  xxDarkBrown:result:='DarkBrown';
  xxDarkGreen:result:='DarkGreen';
  xxDarkRed:result:='DarkRed';
  xxDarkSkin:result:='DarkSkin';
  xxLightGreen:result:='LightGreen';
  xxLightPink:result:='LightPink';
  xxLightPurple:result:='LightPurple';
  xxLightYellow:result:='LightYellow';
  xxMediumGray:result:='MediumGray';
  xxMediumGreen:result:='MediumGreen';
  xxMediumSkin:result:='MediumSkin';
  xxBrightPink:Result:='BRIGHTPINK';
  else result:='';
 end;
end;

Procedure TCoolBtn.Draw;
Var
 w,h,i:integer;
Begin
 w:=Width;
 h:=Height;
 With bmAll, Canvas do Begin
  Width:=w;
  Height:=h;
  Brush.Color:=bm.Canvas.Pixels[5,5];
  Brush.Style:=bsSolid;
  Rectangle(0,0,w,h);
  CopyRect(Rect(0,0,5,5),bm.Canvas,Rect(0,0,5,5));
  CopyRect(Rect(w-5,0,w,5),bm.Canvas,Rect(6,0,11,5));
  CopyRect(Rect(0,h-5,5,h),bm.Canvas,Rect(0,6,5,11));
  CopyRect(Rect(w-5,h-5,w,h),bm.Canvas,Rect(6,6,11,11));
  For i:=5 to w-6 do Begin
   CopyRect(Rect(i,0,i+1,5),bm.Canvas,Rect(5,0,6,5));
   CopyRect(Rect(i,h-5,i+1,h),bm.Canvas,Rect(5,6,6,11));
  End;
  For i:=5 to h-6 do Begin
   CopyRect(Rect(0,i,5,i+1),bm.Canvas,Rect(0,5,5,6));
   CopyRect(Rect(w-5,i,w,i+1),bm.Canvas,Rect(6,5,11,6));
  End;
 End;
 OutText_(bmAll);
End;

Procedure TCoolBtn.DrawDown;
Var
 w,h:integer;
Begin
 w:=Width;
 h:=Height;
 With bmAll, Canvas do Begin
  Width:=w;
  Height:=h;
  Pen.Color:=clBlack;
  Brush.Color:=bm.Canvas.Pixels[5,5];
  Brush.Style:=bsSolid;
  Rectangle(0,0,w,h);
  MoveTo(1,h-1); LineTo(1,1); LineTo(w-1,1);
  Pen.Color:=clWhite;
  LineTo(w-1,h-1); LineTo(1,h-1);
 End;
 OutText_(bmAll);
End;

function TCoolBtn.GetFont:TFont;
begin
 if CoolStyle=nil
  then result:=inherited Font
  else if Active
    then result:=FCoolStyle.FontOn
    else result:=FCoolStyle.FontOff;
end;

constructor TCoolBtn.Create(AOwner:TComponent);
begin
 inherited;
 IsRealign:=false;
 FOrder:=-1;
 FActin:=TAction.Create(self);
 bmAll:=TBitMap.Create;
 bmOn:=TBitMap.Create;
 bmOff:=TBitMap.Create;
 FActin.OnExecute:=AcClick;
 FColorOn:=xxPink;
 FColorOff:=xxRed;
 TextBoth:='Кнопка';
 FTextColOn:=clWhite;
 FTextColOff:=clBlack;
 Font.Name:='Tahoma';
 FFont:=Font;
 FDown:=false;
 FHard:=false;
 Dwn:=false;
 FGroupIndex:=0;
 FAllowCheck:=false;
 bmOn.LoadFromResourceName(HInstance,xx(FColorOn));
 bmOff.LoadFromResourceName(HInstance,xx(FColorOff));
 bm:=bmOff;
 Modified:=true;
 Active:=true;
end;

procedure TCoolBtn.Paint;
begin
 inherited;
 if (Parent<>nil) and ((csDesigning in ComponentState) or Visible) then Begin
  DrwBtn;
  //if Parent is TCoolPanel then TCoolPanel(Parent).Repaint;
 End;
end;

procedure TCoolBtn.SetDown(const Value:boolean);
begin
 Modified:=FDown<>Value;
 FDown:=Value;
 if Assigned(FOnChangeDown) then FOnChangeDown(self,Value);
 Paint;
end;

procedure TCoolBtn.SetGroupIndex(const Value:Integer);
begin
 FGroupIndex:=Value;
end;

procedure TCoolBtn.WMLButtonDown(var Message:TWMLButtonDown);
begin
 if not Enabled then Exit;
 if not Hard then Down:=true;
 //Dwn:=true;
 inherited;
end;

procedure TCoolBtn.WMLButtonUp(var Message:TWMLButtonUp);
begin
 if not Enabled then Exit;
 if not Hard then Down:=false;
 {if Dwn then
  if AllowCheck
   then Active:=not FActive
   else Active:=true;}
 inherited;
end;

destructor TCoolBtn.Destroy;
begin
 if CoolStyle<>nil then CoolStyle.Delete(self);
 bmOn.Free;
 bmOff.Free;
 bmAll.Free;
 FActIn.Free;
 inherited;
end;

procedure TCoolBtn.OutText_(bmv:TBitMap);
Var
 w,h:integer;
 x:integer;
 r:TRect;
 s:String;
begin
 if Down then x:=0 else x:=1;
 if Active then s:=TextOn else s:=TextOff;
 With bmv, Canvas do Begin
  Brush.Style:=bsClear;
  Font:=self.Font;
  if FActive then Font.Color:=TextColOn else Font.Color:=TextColOff;
  With TextExtent(s) do Begin
   w:=Width;
   h:=Height;
   r:=Rect(4,4,w-4,h-4);
   if w>=h
    then TextRect(r,(w-cx) div 2-x,(h-cy) div 2-x,s)
    else Begin
     Font.Handle:=CreateRotatedFont(Font,90);
     x:=1-x;
     TextRect(r,(w-cy) div 2+1,(h+cx) div 2+2+x,s);
    End;
   End;
 End;
end;

procedure TCoolBtn.AllUp;
Var
 i,n:integer;
 btn:TCoolBtn;
begin
 if (FGroupIndex<>0) and (Parent<>nil) then Begin
  n:=Parent.ControlCount;
  For i:=0 to n-1 do Begin
   if not (Parent.Controls[i] is TCoolBtn) then Continue;
   btn:=TCoolBtn(Parent.Controls[i]);
   if (btn.GroupIndex<>FGroupIndex) or not btn.Visible or not btn.Active
    then Continue;
   btn.Active:=false;
  End;
 end;
end;

procedure TCoolBtn.CMFontChanged(var Message:TMessage);
begin
 inherited;
 Repaint;
end;

procedure TCoolBtn.SetCoolStyle(const Value:TCoolStyle);
begin
 if FCoolStyle<>nil then Begin
  FCoolStyle.Delete(self);
  FCoolStyle.RemoveFreeNotification(self);
 End;
 FCoolStyle:=Value;
 if FCoolStyle<>nil then Begin
  FCoolStyle.FreeNotification(self);
  FCoolStyle.Add(self);
 End;
 Repaint;
end;

procedure TCoolBtn.Repaint;
begin
 Modified:=true;
 LoadBM(bmOn,ColorOn);
 LoadBM(bmOff,ColorOff);
 inherited;
end;

function TCoolBtn.GetColorOff:TXColor;
begin
 if CoolStyle=nil
  then result:=FColorOff
  else result:=CoolStyle.ColorOff;
end;

function TCoolBtn.GetColorOn:TXColor;
begin
 if CoolStyle=nil
  then result:=FColorOn
  else result:=CoolStyle.ColorOn;
end;

function TCoolBtn.GetHard:boolean;
begin
 if CoolStyle=nil
  then result:=FHard
  else result:=CoolStyle.Hard;
end;

function TCoolBtn.GetTextColOff:TColor;
begin
 if CoolStyle=nil
  then result:=FTextColOff
  else result:=CoolStyle.TextColOff;
end;

function TCoolBtn.GetTextColOn:TColor;
begin
 if CoolStyle=nil
  then result:=FTextColOn
  else result:=CoolStyle.TextColOn;
end;

procedure TCoolBtn.LoadBM(bm:TBitMap; Color:TXColor);
begin
 if bm<>nil then
  bm.LoadFromResourceName(HInstance,xx(Color));
end;

procedure TCoolBtn.SetTextBoth(const Value:String);
begin
 Modified:=FTextBoth<>Value;
 FTextBoth:=Value;
 FTextOff:=GetShortHint(Value);
 FTextOn:=GetLongHint(Value);
 if Active
  then ActIn.Caption:=FTextOn
  else ActIn.Caption:=FTextOff;
 Paint;
end;

procedure TCoolBtn.SetTextOff(const Value:String);
begin
 Modified:=(FTextOn<>Value) and (CoolStyle=nil);
 FTextOff:=Value;
 if not Active then ActIn.Caption:=Value;
 FTextBoth:=FTextOff+'|'+FTextOn;
 Paint;
end;


procedure TCoolBtn.Notification(AComponent:TComponent;
  Operation:TOperation);
begin
 inherited;
 if (Operation=opRemove) and (AComponent=FCoolStyle) then CoolStyle:=nil;
end;

function TCoolBtn.WithoutStyle:boolean;
begin
 result:=CoolStyle=nil;
end;

function TCoolBtn._ColOff:boolean;
begin
 result:=(CoolStyle=nil) and (FColorOff<>xxRED);
end;

function TCoolBtn._ColOn:boolean;
begin
 result:=(CoolStyle=nil) and (FColorOn<>xxPINK);
end;

function TCoolBtn._Hard:boolean;
begin
 result:=(CoolStyle=nil) and FHard;
end;

function TCoolBtn._TextColOff:boolean;
begin
 result:=(CoolStyle=nil) and (FTextColOff<>clBlack);
end;

function TCoolBtn._TextColOn:boolean;
begin
 result:=(CoolStyle=nil) and (FTextColOn<>clWhite);
end;

function TCoolBtn.GetIam:TCoolBtn;
begin
 result:=self;
end;

procedure TCoolBtn.SetParent(AParent:TWinControl);
begin
 if AParent is TCoolPanel then Align:=alLeft;
 inherited;
end;

procedure TCoolBtn.AcClick(Sender:TObject);
begin
 Click;
end;

procedure TCoolBtn.Click;
begin
 Active:=(AllowCheck  or not FActive) xor FActive;
 inherited;
end;

procedure TCoolBtn.RequestAlign;
begin
 if IsRealign then Exit;
 IsRealign:=true;
 inherited;
 if Parent is TCoolPanel then TCoolPanel(Parent).Restruct;
 IsRealign:=false;
end;

{ TCoolStyle }

procedure TCoolStyle.Add(CoolBtn:TCoolBtn);
begin
 if Find(CoolBtn)<>-1 then Exit;
 SetLength(CoolBtns,Length(CoolBtns)+1);
 CoolBtns[High(CoolBtns)]:=CoolBtn;
end;

constructor TCoolStyle.Create(AOwner:TComponent);
begin
 inherited;
 FFontOn:=TFont.Create;
 FFontOff:=TFont.Create;
 With FFontOn do Begin
  Name:='Tahoma';
  Size:=10;
  OnChange:=FntChange;
 End;
 With FFontOff do Begin
  Name:='Tahoma';
  Size:=10;
  OnChange:=FntChange;
 End;
end;

procedure TCoolStyle.Delete(CoolBtn:TCoolBtn);
Var
 x:integer;
begin
 x:=Find(CoolBtn);
 if x=-1 then Exit;
 CoolBtns[x]:=CoolBtns[High(CoolBtns)];
 SetLength(CoolBtns,High(CoolBtns));
end;

destructor TCoolStyle.Destroy;
begin
 FFontOn.Free;
 FFontOff.Free;
 CoolBtns:=nil;
 inherited;
end;

procedure TCoolStyle.DoChange;
Var
 i:integer;
begin
 For i:=0 to High(CoolBtns) do CoolBtns[i].Repaint;
end;

function TCoolStyle.Find(CoolBtn:TCoolBtn):integer;
Var
 i,l:integer;
begin
 result:=-1;
 l:=Length(CoolBtns)-1;
 For i:=0 to l do
  if CoolBtn=CoolBtns[i] then Begin
   result:=i;
   Exit;
  End;
end;

procedure TCoolStyle.FntChange(Sender:TObject);
begin
 DoChange;
end;

function TCoolStyle.GetIam:TCoolStyle;
begin
 result:=self;
end;

procedure TCoolStyle.SetColorOff(const Value:TXColor);
begin
 FColorOff:=Value;
 DoChange;
end;

procedure TCoolStyle.SetColorOn(const Value:TXColor);
begin
 FColorOn:=Value;
 DoChange;
end;

procedure TCoolStyle.SetFontOff(const Value:TFont);
begin
 FFontOff.Assign(Value);
end;

procedure TCoolStyle.SetFontOn(const Value:TFont);
begin
 FFontOn.Assign(Value);
end;

procedure TCoolStyle.SetHard(const Value:Boolean);
begin
 FHard:=Value;
 DoChange;
end;

procedure TCoolStyle.SetTextColOff(const Value:TColor);
begin
 FTextColOff:=Value;
 DoChange;
end;

procedure TCoolStyle.SetTextColOn(const Value:TColor);
begin
 FTextColOn:=Value;
 DoChange;
end;

{ TCoolPanel }

procedure TCoolPanel.AllUp;
Var
 i:integer;
begin
 For i:=0 to Buttons.Count-1 do Buttons[i].Active:=false;
 Repaint;
end;

procedure TCoolPanel.CMControlChange(var Message:TCMControlChange);
begin
 inherited;
 With Message do Begin
  if Inserting then
   if Control is TCoolBtn
    then Begin
     if [csReading]*ComponentState=[] then Buttons.Add(TCoolBtn(Control));
    End else Control.Parent:=Temp;
 End;
 View;
end;

procedure TCoolPanel.CMControlListChange(
  var Message:TCMControlListChange);
begin
 inherited;
 With Message do Begin
  if Inserting then Begin
   if not (Control is TCoolBtn) then Temp:=Control.Parent;
   if Temp=nil then Temp:=Parent;
   Exit;
  End;
  //LogBeg('CMControlListChange');
  Buttons.Delete(TCoolBtn(Control));
  //LogEnd;
  View;
 End;
end;

constructor TCoolPanel.Create(AOwner:TComponent);
begin
 inherited;
 FButtons:=TCoolCollection.Create(self);
 OldWidth:=-1;
 DoubleBuffered:=true;
 Align:=alTop;
 Caption:='';
 ControlStyle:=ControlStyle-[csSetCaption];
 BevelOuter:=bvNone;
 Height:=20;
end;

destructor TCoolPanel.Destroy;
begin
 FButtons.Free;
 inherited;
end;

function TCoolPanel.GetIam:TCoolPanel;
begin
 result:=self;
end;

function TCoolPanel.GetIsDesign:boolean;
begin
 result:=csDesigning in ComponentState;
end;

procedure TCoolPanel.Repaint;
Var
 i:integer;
begin
 inherited;
 if not (csReading in ComponentState) then
  For i:=0 to Buttons.Count-1 do Buttons[i].Button.Repaint;
end;

procedure TCoolPanel.Resize;
begin
 inherited;
 if Width=OldWidth then Exit;
 Restruct;
 OldWidth:=Width;
end;

procedure TCoolPanel.Restruct;
Var
 i,w,n:integer;
 bt:TCoolBtn;
 b:array of TCoolBtn;
begin
 n:=FButtons.Count;
 if n=0 then Exit;
 SetLength(b,n);
 n:=0;
 For i:=0 to FButtons.Count-1 do Begin
  bt:=FButtons.Items[i].FButton;
  if (bt<>nil) and (bt.Visible or (csDesigning in ComponentState)) then Begin
   b[n]:=bt;
   inc(n);
  End;
 End;
 SetLength(b,n);
 if n=0 then Exit;
 w:=Width div n;
 For i:=0 to high(b) do With b[i] do Begin
  Left:=i*w;
  if i=n-1
   then Width:=self.Width-Left
   else Width:=w;
 End;
 SetLength(b,0);
end;

procedure TCoolPanel.SetButtons(const Value:TCoolCollection);
begin
 FButtons.Assign(Value);
end;

procedure TCoolPanel.SetParent(AParent:TWinControl);
begin
 inherited;
 if AParent<>nil then Repaint;
end;

procedure TCoolPanel.UpdateX;
begin
 if x=-1 then Begin
 End else Begin
 End;
 View;
end;

procedure TCoolPanel.View;
begin
 OldWidth:=-1;
 Resize;
end;

procedure TCoolPanel.VisibleChanging;
begin
   if not Visible then Repaint;
end;

{ TCoolItem }

function TCoolItem.GetColorOff:TXColor;
begin
 result:=xxDarkRed;
 if FButton<>nil then result:=FButton.ColorOff;
end;

function TCoolItem.GetColorOn:TXColor;
begin
 result:=xxBrightRed;
 if FButton<>nil then result:=FButton.ColorOn;
end;

function TCoolItem.GetCoolStyle:TCoolStyle;
begin
 result:=nil;
 if FButton<>nil then result:=FButton.CoolStyle;
end;

function TCoolItem.GetFont:TFont;
begin
 result:=nil;
 if FButton<>nil then result:=FButton.Font;
end;

function TCoolItem.GetGroupIndex:Integer;
begin
 result:=0;
 if FButton<>nil then result:=FButton.GroupIndex;
end;

function TCoolItem.GetOnBeforeChangeActive:TBoolEvent;
begin
 result:=nil;
 if FButton<>nil then result:=FButton.OnBeforeChangeActive;
end;

function TCoolItem.GetOnChangeActive:TBoolEvent;
begin
 result:=nil;
 if FButton<>nil then result:=FButton.OnChangeActive;
end;

function TCoolItem.GetOnChangeDown:TBoolEvent;
begin
 result:=nil;
 if FButton<>nil then result:=FButton.OnChangeDown;
end;

function TCoolItem.GetTextColOff:TColor;
begin
 result:=0;
 if FButton<>nil then result:=FButton.TextColOff;
end;

function TCoolItem.GetTextColOn:TColor;
begin
 result:=0;
 if FButton<>nil then result:=FButton.TextColOn;
end;

procedure TCoolItem.SetAlign(const Value:TAlign);
begin
 if FButton<>nil then FButton.Align:=value;
end;

procedure TCoolItem.SetAnchors(const Value:TAnchors);
begin
 if FButton<>nil then FButton.Anchors:=value;
end;

procedure TCoolItem.SetButton(const Value:TCoolBtn);
begin
 With TCoolCollection(Collection) do Begin
  if not IsReading then
   if FButton<>nil then Begin
    if Value<>nil then Value.Parent:=FButton.Parent;
    FreeAndNil(FButton);
   End;
  FButton:=Value;
  if FButton<>nil then FButton.FOnIndex:=ItemIndex;
 End;
end;

procedure TCoolItem.SetColorOff(const Value:TXColor);
begin
 if FButton<>nil then FButton.ColorOff:=value;
end;

procedure TCoolItem.SetColorOn(const Value:TXColor);
begin
 if FButton<>nil then FButton.ColorOn:=value;
end;

procedure TCoolItem.SetConstraints(const Value:TSizeConstraints);
begin
 if FButton<>nil then FButton.Constraints:=value;
end;

procedure TCoolItem.SetCoolStyle(const Value:TCoolStyle);
begin
 if FButton<>nil then FButton.CoolStyle:=value;
end;

procedure TCoolItem.SetFont(const Value:TFont);
begin
 if FButton<>nil then FButton.Font:=value;
end;

procedure TCoolItem.SetGroupIndex(const Value:Integer);
begin
 if FButton<>nil then FButton.GroupIndex:=value;
end;

procedure TCoolItem.SetOnClick(const Value:TNotifyEvent);
begin
 if FButton<>nil then FButton.OnClick:=value;
end;

procedure TCoolItem.SetOnDblClick(const Value:TNotifyEvent);
begin
 if FButton<>nil then FButton.OnDblClick:=value;
end;

procedure TCoolItem.SetOnMouseDown(const Value:TMouseEvent);
begin
 if FButton<>nil then FButton.OnMouseDown:=value;
end;

procedure TCoolItem.SetOnMouseMove(const Value:TMouseMoveEvent);
begin
 if FButton<>nil then FButton.OnMouseMove:=value;
end;

procedure TCoolItem.SetOnMouseUp(const Value:TMouseEvent);
begin
 if FButton<>nil then FButton.OnMouseUp:=value;
end;

procedure TCoolItem.SetTextColOff(const Value:TColor);
begin
 if FButton<>nil then FButton.TextColOff:=value;
end;

procedure TCoolItem.SetTextColOn(const Value:TColor);
begin
 if FButton<>nil then FButton.TextColOn:=value;
end;

function TCoolItem.GetAlign:TAlign;
begin
 result:=alNone;
 if FButton<>nil then result:=FButton.Align;
end;

function TCoolItem.GetAnchors:TAnchors;
begin
 result:=[];
 if FButton<>nil then result:=FButton.Anchors;
end;

function TCoolItem.GetConstraints:TSizeConstraints;
begin
 result:=nil;
 if FButton<>nil then result:=FButton.Constraints;
end;

function TCoolItem.GetOnClick:TNotifyEvent;
begin
 result:=nil;
 if FButton<>nil then result:=FButton.OnClick;
end;

function TCoolItem.GetOnDblClick:TNotifyEvent;
begin
 result:=nil;
 if FButton<>nil then result:=FButton.OnDblClick;
end;

function TCoolItem.GetOnMouseDown:TMouseEvent;
begin
 result:=nil;
 if FButton<>nil then result:=FButton.OnMouseDown;
end;

function TCoolItem.GetOnMouseMove:TMouseMoveEvent;
begin
 result:=nil;
 if FButton<>nil then result:=FButton.OnMouseMove;
end;

function TCoolItem.GetOnMouseUp:TMouseEvent;
begin
 result:=nil;
 if FButton<>nil then result:=FButton.OnMouseUp;
end;

procedure TCoolItem.SetOnChangeActive(const Value:TBoolEvent);
begin
 if FButton<>nil then FButton.OnChangeActive:=Value;
end;

procedure TCoolItem.SetOnBeforeChangeActive(const Value:TBoolEvent);
begin
 if FButton<>nil then FButton.OnBeforeChangeActive:=Value;
end;

procedure TCoolItem.SetOnChangeDown(const Value:TBoolEvent);
begin
 if FButton<>nil then FButton.OnChangeDown:=Value;
end;

procedure TCoolItem.SetWidth(const Value:Integer);
begin
 if FButton<>nil then FButton.Width:=Value;
end;

function TCoolItem.GetWidth:Integer;
begin
 result:=0;
 if FButton<>nil then result:=FButton.Width;
end;

function TCoolItem.GetOptions(x:integer):boolean;
begin
 result:=false;
 if FButton=nil then Exit;
 With FButton do
 Case x of
  1:result:=aClick;
  2:result:=Active;
  3:result:=AllowCheck;
  4:result:=Down;
  5:result:=Hard;
  6:result:=Enabled;
  7:result:=ParentShowHint;
  8:result:=ShowHint;
  9:result:=Visible;
 End;
end;

procedure TCoolItem.SetOptions(x:integer; const Value:boolean);
begin
 if FButton=nil then Exit;
 With FButton do
 Case x of
  1:aClick:=Value;
  2:Active:=Value;
  3:AllowCheck:=Value;
  4:Down:=Value;
  5:Hard:=Value;
  6:Enabled:=Value;
  7:ParentShowHint:=Value;
  8:ShowHint:=Value;
  9:Visible:=Value;
 End;
end;

function TCoolItem.GetStrings(x:integer):string;
begin
 result:='';
 if FButton=nil then Exit;
 With FButton do
 Case x of
  1:Result:=Hint;
  2:Result:=TextOn;
  3:Result:=TextOff;
  4:Result:=TextBoth;
  5:if TCoolCollection(Collection).IsReading then Result:='' else Result:=Name;
 End;
end;

procedure TCoolItem.SetStrings(x:integer; const Value:string);
begin
 if FButton=nil then Exit;
 With FButton do
 Case x of
  1:Hint:=Value;
  2:TextOn:=Value;
  3:TextOff:=Value;
  4:TextBoth:=Value;
  5:if not TCoolCollection(Collection).IsReading then Name:=Value;
 End;
end;

destructor TCoolItem.Destroy;
begin
 FDestroing:=true;
 inherited;
end;

constructor TCoolItem.Create(Collection:TCollection);
begin
 inherited;

end;

function TCoolItem.GetDisplayName:String;
begin
 Result:=Name+' ('+TextBoth+')';
end;

function TCoolItem.GetActIn:TAction;
begin
 result:=FButton.ActIn;
end;

function TCoolBtn.GetIndex:integer;
begin
 result:=-1;
 if Assigned(FOnIndex) then FOnIndex(self, Result);
end;

{ TCoolCollection }

function TCoolCollection.Add(Btn:TCoolBtn):TCoolItem;
begin
 AddFromPanel:=false;
 if AddFromCollection
  then result:=TCoolItem(inherited Add)
  else result:=Items[Count-1];
 AddFromPanel:=true;
 Result.FButton:=Btn;
 Btn.FOnIndex:=ItemIndex;
end;

constructor TCoolCollection.Create(AOwner:TCoolPanel);
begin
 FRestore:=true;
 Owner:=AOwner;
 AddFromPanel:=true;
 AddFromCollection:=true;
 DeleteFromCollection:=true;
 inherited Create(TCoolItem);
end;

procedure TCoolCollection.Delete(btn:TCoolBtn);
Var
 i:integer;
begin
 For i:=0 to Count-1 do
  if Items[i].Button=btn then Begin
   if not Items[i].Destroing then Delete(i);
   break;
  End;
end;

destructor TCoolCollection.Destroy;
begin
 DeleteFromCollection:=false;
 FRestore:=false;
 inherited;
end;

function TCoolCollection.GetIam:TCoolCollection;
begin
 Result:=self;
end;

function TCoolCollection.GetItems(x:integer):TCoolItem;
begin
 result:=TCoolItem(inherited Items[x]);
end;

function TCoolCollection.GetOwner:TPersistent;
begin
 result:=Owner;
end;

function TCoolCollection.IndexOf(Btn:TCoolBtn):integer;
Var
 i:integer;
begin
 result:=-1;
 For i:=0 to Count-1 do
  if Items[i].Button=Btn then Begin
   result:=i;
   break;
  End;
end;

function TCoolCollection.IsReading:boolean;
begin
 result:=[csReading,csLoading]*Owner.ComponentState<>[];
end;

procedure TCoolCollection.ItemIndex(Sender:Tobject; var Index:integer);
begin
 if not (Sender is TCoolBtn) then Exit;
 Index:=IndexOf(TCoolBtn(Sender));
end;

procedure TCoolCollection.Notify(Item:TCollectionItem;
  Action:TCollectionNotification);
Var
 i:integer;
 s:string;
 frm:TCustomForm;
begin
 inherited;
  Case Action of
  cnAdded:if AddFromPanel and not IsReading then Begin
   With TCoolBtn.Create(GetParentForm(Owner)) do Begin
    i:=1;
    s:=copy(Iam.ClassName,2,MaxInt);
    frm:=GetParentForm(self.Owner);
    if frm<>nil then Begin
     While frm.FindComponent(format('%s%d',[s,i]))<>nil do inc(i);
     Iam.Name:=format('%s%d',[s,i]);
    End;
    AddFromCollection:=false;
    Parent:=self.Owner;
    AddFromCollection:=true;
    TCoolItem(Item).FButton:=Iam;
    FOnIndex:=ItemIndex;
   End;
  End;
  cnDeleting:Begin
   //ShowMessage('Удаление');
   DeleteFromCollection:=false;
   TCoolItem(Item).Button.FOnIndex:=nil;
  End;
  cnExtracting:Begin
   //ShowMessage('Отделение 1');
   if DeleteFromCollection then Begin
    //ShowMessage('Отделение 2');
    TCoolItem(Item).Button.Free;
   End;
   DeleteFromCollection:=FRestore;
  End;
 End;
end;

procedure TCoolCollection.SetItems(x:integer; const Value:TCoolItem);
begin
 inherited Items[x]:=Value;
end;

procedure TCoolCollection.Update(Item:TCollectionItem);
begin
 inherited;
 if Item=nil then Owner.UpdateX(-1) else Owner.UpdateX(Item.Index);
end;

end.






