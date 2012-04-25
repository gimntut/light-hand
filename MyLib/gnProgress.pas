unit gnProgress;

interface
uses Messages, PublGraph, Classes, Controls, Graphics, SysUtils, Dialogs;
type
 TgnProgressBar=Class(TCustomControl)
 private
  GammaBM:TBitmap;
  FPosition: Integer;
  FMin: Integer;
  FMax: Integer;
  FOnChange: TNotifyEvent;
  procedure DoChange;
  procedure SetMax(const Value: Integer);
  procedure SetMin(const Value: Integer);
  procedure SetPosition(const Value: Integer);
 protected
  procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
  procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
 public
  constructor Create(AOwner: TComponent); override;
  destructor Destroy; override;
  procedure SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer;
            AHeight: Integer); override;
 published
  property Min:Integer read FMin write SetMin;
  property Max:Integer read FMax write SetMax;
  property Position:Integer read FPosition write SetPosition;
  property OnChange:TNotifyEvent read FOnChange write FOnChange;
  property Align;
 End;
implementation
Uses Math;
{ TgnProgressBar }

constructor TgnProgressBar.Create(AOwner: TComponent);
begin
 inherited;
 GammaBM:=TBitmap.Create;
 SetBounds(0,0,150,17);
 FMax:=100;
end;

destructor TgnProgressBar.Destroy;
begin
 GammaBM.Free;
 inherited;
end;

procedure TgnProgressBar.DoChange;
begin
 if Assigned(FOnChange) then FOnChange(self);
end;

procedure TgnProgressBar.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
Var
 w,h:Integer;
begin
 if Width<>AWidth then Begin
  GammaBM.Width:=AWidth*3;
  if GammaBM.Height=0 then GammaBM.Height:=1;
  w:=AWidth;
  h:=GammaBM.Height;
  With GammaBM.Canvas do Begin
   Pen.Color:=clMaroon;
   MoveTo(0,0);
   LineTo(0,h);
   Pen.Color:=$80ff;
   MoveTo(w-1,0);
   LineTo(w-1,h);
   Pen.Color:=clLime;
   MoveTo(w*2-1,0);
   LineTo(w*2-1,h);
   Pen.Color:=clLime;
   MoveTo(w*3-1,0);
   LineTo(w*3-1,h);
  End;
  DrawG(GammaBM,0.5,Rect(0,0,w,h));
  DrawG(GammaBM,0.5,Rect(w-1,0,w*2,h));
  DrawG(GammaBM,0.5,Rect(w*2-1,0,w*3,h));
  //DrawG(GammaBM,0.5,Rect(0,0,w,h));
 End;
 if Height<>AHeight then Begin
  GammaBM.Height:=Math.Max(1,AHeight);
  w:=GammaBM.Width;
  h:=GammaBM.Height;
  GammaBM.Canvas.CopyRect(Rect(0,1,w,h),GammaBM.Canvas,Rect(0,0,w,1));
 End;
 inherited;
end;

procedure TgnProgressBar.SetMax(const Value: Integer);
begin
 FMax := Value;
 if csLoading in ComponentState then Exit;
 if FMax<FMin then Begin
  FMax:=FMin;
  FPosition:=FMin;
 End;
 if FMax<FPosition then FPosition:=FMax;
 DoChange;
 Perform(WM_PAINT,0,0);
end;

procedure TgnProgressBar.SetMin(const Value: Integer);
begin
 FMin := Value;
 if csLoading in ComponentState then Exit;
 if FMin>FMax then Begin
  FMin:=FMax;
  FPosition:=FMax;
 End;
 if FMin>FPosition then FPosition:=FMin;
 DoChange;
 Perform(WM_PAINT,0,0);
end;

procedure TgnProgressBar.SetPosition(const Value: Integer);
begin
 FPosition := Value;
 if csLoading in ComponentState then Exit;
 if FPosition<FMin then FPosition:=FMin;
 if FPosition>FMax then FPosition:=FMax;
 DoChange;
 Perform(WM_PAINT,0,0);
end;

procedure TgnProgressBar.WMNCHitTest(var Message: TWMNCHitTest);
begin
 inherited;
 Exit;
 Message.Result:=2;
end;

procedure TgnProgressBar.WMPaint(var Message: TWMPaint);
Var
 perc:Integer;
 w,h:Integer;
begin
 Inherited;
 try
  Perform(WM_ERASEBKGND,Integer(Canvas.Handle),0);
 except
  on ERangeError do ShowMessage('Ok');
 End;
 if Position=Min
 then perc:=0
 else if Max=Min then perc:=100
 else perc:=100*(Position-Min) div (Max-Min);
 w:=Width*perc div 100;
 h:=Height;
 Canvas.CopyRect(Rect(0,0,w,h),GammaBM.Canvas,Rect(w*2,0,w*3,h));
 //Canvas.Draw(-20,0,GammaBM);
end;

end.
