unit PublGraph;
interface
Uses Windows, publ, Graphics, Types, Classes, SysUtils, Printers, ExtCtrls, PublMath;
     //ViewLog;
Type
 TPublGraph=class(TComponent)
 end;
 TColorRec=packed record
 case byte of
  0: (Color:Integer);
  1: (Red,Green,Blue,Alpha:byte);
  2: (Bytes:array[0..3] of byte);
 end;
 TCorner=(crLeftTop,crRightTop,crLeftBottom,crRightBottom);
 /////////////////// x ///////////////////
 TMixMetod=(mmNormal,mmMultiply);
 /////////////////// x ///////////////////
 TPipeEnd=packed record
  x,y:integer;
  Direction:TDirection;
 end;
 /////////////////// x ///////////////////
 TPipe=class
 private
  FGrad:ai;
  FBrightness:Integer;
  FWidth:Integer;
  FRadius:Integer;
  FColor:TColor;
  FStart:TPipeEnd;
  FFinish:TPipeEnd;
  FMinLength: integer;
  FCanvas:TCanvas;
  procedure NewGrad;
  procedure SetWidth(const Value: Integer);
  procedure SetBrightness(const Value: Integer);
  procedure SetColor(const Value: TColor);
 protected
  procedure DrawBend1(Canvas:TCanvas);
  procedure DrawBend2(Canvas:TCanvas);
  procedure LeftLeft(AStart,AFinish:TPipeEnd);
  procedure LeftRight(AStart,AFinish:TPipeEnd);
  procedure LeftTop(AStart,AFinish:TPipeEnd);
  procedure LeftBottom(AStart,AFinish:TPipeEnd);
  procedure RightLeft(AStart,AFinish:TPipeEnd);
  procedure RightRight(AStart,AFinish:TPipeEnd);
  procedure RightTop(AStart,AFinish:TPipeEnd);
  procedure RightBottom(AStart,AFinish:TPipeEnd);
  procedure TopLeft(AStart,AFinish:TPipeEnd);
  procedure TopRight(AStart,AFinish:TPipeEnd);
  procedure TopTop(AStart,AFinish:TPipeEnd);
  procedure TopBottom(AStart,AFinish:TPipeEnd);
  procedure BottomLeft(AStart,AFinish:TPipeEnd);
  procedure BottomRight(AStart,AFinish:TPipeEnd);
  procedure BottomTop(AStart,AFinish:TPipeEnd);
  procedure BottomBottom(AStart,AFinish:TPipeEnd);
  procedure Draw(AStart,AFinish:TPipeEnd); overload;
 public
  constructor Create;
  property Color:TColor read FColor write SetColor;
  property Brightness:Integer read FBrightness write SetBrightness;
  property Width:Integer read FWidth write SetWidth;
  property Radius:Integer read FRadius write FRadius;
  property Start:TPipeEnd read FStart write FStart;
  property Finish:TPipeEnd read FFinish write FFinish;
  property MinLength:integer read FMinLength write FMinLength;
  property Canvas:TCanvas read FCanvas write FCanvas;
  procedure Draw; overload;
  function DrawPiece(APipeEnd:TPipeEnd;ALength:integer):TPipeEnd; overload;
  function DrawPiece(x,y,ALength:integer; ADirection:TDirection):TPipeEnd; overload;
  procedure DrawSector(x0,y0,x1,y1,x2,y2: integer); overload;
  // AStart - Начало сектора;
  // ADirection - drRight, drLeft поворот направо и налево от начального направления
  function DrawSector(AStart:TPipeEnd; ADirection:TDirection):TPipeEnd; overload;
 end;
 function PipeEnd(AX,AY:integer; ADirection:TDirection):TPipeEnd;
 // Закраска прямоугольника по четырём сторонам
 procedure Fill(Bm:TBitMap;G,V:Extended);
 // Закраска прямоугольника по двум сторонам верх-низ
 procedure FillV(Bm:TBitMap;K:Extended);
 // Закраска прямоугольника по двум сторонам лево-право
 procedure FillG(Bm:TBitMap;K:Extended);
 // Смешивание двух цветов
 function Mix(c1,c2:TColor):TColor; overload;
 // Смешивание двух цветов
 // k=0 - result=c1; k=1 - result=c2; k=0.5 - result=(c1+c2)/2
 function Mix(c1,c2:TColor; k:Extended):TColor; overload;
 // Смешивание двух рисунков
 procedure Mix(Bm1,Bm2:TBitMap;Out Bm3:TBitMap; k:Extended=0.5; MixMetod:TMixMetod=mmNormal); overload;
 // Умножение двух цветов
 // k=0 - result=c1; k=1 - result=c2; k=0.5 - result=(c1+c2)/2
 function MixMultiply(c1,c2:TColor; k:Extended):TColor; overload;
 // Закрашивание прямоугольной области по 4 сторонам
 procedure Draw(Bm:TBitMap;G,V:Extended;ARect:TRect);
 // Закрашивание прямоугольной области по 2 сторонам <->
 procedure DrawG(Bm:TBitMap;K:Extended;ARect:TRect);
 // Закрашивание прямоугольной области по 2 сторонам ^-v
 procedure DrawV(Bm:TBitMap;K:Extended;ARect:TRect);
 // Заполнение массива цветами плавного перехода от одного цвета к другому
 procedure Grad(Col1, Col2: TColor; Count: integer; var Grd: ai; K:Extended); overload;
 // Заполнение массива перехода от одного цвета к другому на основе массива
 procedure Grad(Col1, Col2: TColor; Ks:ar; var Grd: ai); overload;
 // Рисование одного рисунка на порхности другого
 procedure CopyBm(bmSource, bmDest: TBitMap; ARect: TRect);
 // Рисование углов
 procedure DrawCorners(BM,bm1,bm2,bm3,bm4:TBitMap);
 // Рисования всего рисунка кнопки
 procedure OutBtn(BM,LT,RT,LB,RB:TBitMap; GK,VK:Extended); overload;
 procedure OutBtn(ms:TStream; BM:TBitMap); overload;
 // Максимальная зона заливки
 function GetBig(BM, bm1, bm2, bm3, bm4: TBitMap): TRect;
 // Минимальная зона заливки
 function GetSmall(BM, bm1, bm2, bm3, bm4: TBitMap): TRect;
 procedure ReadBMP(ms:TStream; bmp:TBitMap);
 procedure WriteBMP(ms:TStream; bmp:TBitMap);
 procedure LoadBtnFromStream(ms:TStream; LT,RT,LB,RB:TBitMap; out GK,VK:Extended;
 out TC:TColor);
 procedure SaveBtnToStream(ms:TStream; LT,RT,LB,RB:TBitMap; GK,VK:Extended; TC:TColor);
 procedure OutCenterText(bmv: TBitMap; Text:String; AFont:TFont;
           Down:boolean=false);
 procedure Turn90(bmp:TBitMap);
 procedure Turn270(bmp:TBitMap);
 procedure Turn180(bmp:TBitMap);
 // Рисование BitMap'a на принтере
 procedure CopyToPrinter(BitMap:TBitMap;x,y:Integer);
 // ClearImage
 procedure ClearImage(Image:TImage);
 // Заливка всего битмапа одним цветом
 procedure ClearBitMap(BitMap:TBitMap;Color:TColor);
 // Определение координат BitMap'a соответствующие координате Imag'a
 function RealCoord(Image:TImage; p:TPoint):TPoint; overload;
 function RealCoord(Image:TImage; x,y:Integer):TPoint; overload;
 // Преобразование одного массива в массив другой длины с сохранением длины
 procedure Stretch(a:ai;out b:ai);
 // Преобразование цвета в серый оттенок
 function RGBToGray(Color:TColor):TColor;
 // Создание нового объекта TBitmap, с задаными размерами и цветом
 function NewBitMap(AWidth,AHeight:integer;AColor:TColor):TBitMap;
 // Создание перехода от основного рисунка к одному цвету
 procedure Tramplin(Canvas:TCanvas; ARect:TRect; Color:TColor; Direct:TDirection);
 // Вывод кнопки на полотно по указанным координатам с задаными цветами углов
 procedure OutSimpleBtn(Canvas:TCanvas; ARect:TRect; Colors:array of TColor; GK,VK:Extended);
 // Является ли цвет тёмным
 function IsDark(Color:TColor):boolean;
 // Задать цвет кисти и пера для Canvas
 procedure SetBrushPen(Canvas:TCanvas;BrushColor,PenColor:TColor; PenWidth:Integer=1);
 /////////////////// x ///////////////////
implementation
Uses Math, UQPixels, Controls;
Var
 FSector:TBitmap=nil;
procedure SideToSide(bm:TBitMap;LR,TB:Boolean);
Var
 RectL,RectR,RectT,RectB:TRect;
begin
 RectL:=Rect(0,0,1,bm.Height);
 RectR:=Rect(bm.Width-1,0,bm.Width,bm.Height);
 RectT:=Rect(0,0,bm.Width,1);
 RectB:=Rect(0,bm.Height-1,bm.Width,bm.Height);
 With bm.Canvas do begin
  if LR
   then CopyRect(RectR,bm.Canvas,RectL)
   else CopyRect(RectL,bm.Canvas,RectR);
  if TB
   then CopyRect(RectB,bm.Canvas,RectT)
   else CopyRect(RectT,bm.Canvas,RectB);
 end;
end;


procedure Fill(Bm: TBitMap;G,V:Extended);
Var
 us1,us2:Boolean;
 bm1:TBitmap;
begin
 us1:=bm.Width>2;
 us2:=bm.Height>2;
 bm1:=TBitmap.Create;
 bm1.PixelFormat:=pf24bit;
 bm1.Assign(bm);
 if us1 then FillV(bm1,V);
 if us2 then FillG(bm,G);
 if us1 and us2 then Mix(bm,bm1,bm) else
  if us1 then bm.Assign(bm1);
 bm1.Free;
end;

procedure FillG(Bm: TBitMap;K:Extended);
Var
 i,j,n:integer;
 c1,c2:TColor;
 ks:ar;
 cls:ai;
 qp:TQuickPixels;
begin
 SetLength(cls,0);
 if bm.Width<3 then Exit;
 if bm.Empty then Exit;
 qp:=TQuickPixels.Create;
 qp.Attach(bm);
 n:=bm.Width-2;
 SetLength(ks,n);
 For i:=0 to n-1 do ks[i]:=Gamma(k,i/n);
 For i:=0 to bm.Height-1 do begin
  c1:=qp.Pixels[0,i];
  c2:=qp.Pixels[n+1,i];
  Grad(c1,c2,ks,cls);
  For j:=0 to n-1 do qp.Pixels[j+1,i]:=cls[j];
 end;
 qp.Free;
end;

procedure FillV(Bm: TBitMap;K:Extended);
Var
 i,j,n:integer;
 c1,c2:TColor;
 cls:ai;
 ks:ar;
 qp:TQuickPixels;
begin
 SetLength(cls,0);
 if bm.Height<3 then Exit;
 if bm.Empty then Exit;
 qp:=TQuickPixels.Create;
 qp.Attach(bm);
 n:=bm.Height-2;
 SetLength(ks,n);
 For i:=0 to n-1 do ks[i]:=Gamma(k,i/n);
 For i:=0 to bm.Width-1 do begin
  c1:=qp.Pixels[i,0];
  c2:=qp.Pixels[i,n+1];
  Grad(c1,c2,ks,cls);
  For j:=0 to High(cls) do qp.Pixels[i,j+1]:=cls[j];
 end;
 qp.Free;
end;

type
 TMixProc=function (c1,c2:TColor; k:Extended):TColor; 
procedure Mix(Bm1,Bm2:TBitMap; Out Bm3:TBitMap; k:Extended; MixMetod:TMixMetod);
Var
 i,j:integer;
 qt1,qt2,qt3:TQuickPixels;
 mp:TMixProc;
begin
 qt1:=TQuickPixels.Create;
 qt2:=TQuickPixels.Create;
 qt3:=TQuickPixels.Create;
 qt1.Attach(bm1);
 qt2.Attach(bm2);
 qt3.Attach(bm3);
 Case MixMetod of
  mmNormal: mp:=Mix;
  mmMultiply: mp:=MixMultiply;
  else mp:=Mix;
 End;
 For i:=0 to bm1.Width-1 do
  For j:=0 to bm1.Height-1 do
   qt3.Pixels[i,j]:=mp(qt1.Pixels[i,j],qt2.Pixels[i,j],k);
 qt1.Free;
 qt2.Free;
 qt3.Free;
end;

function MixMultiply(c1,c2:TColor; k:Extended):TColor; overload;
Var
 xc,xc1,xc2:TColorRec;
begin
 xc.Color:=0;
 xc1.Color:=c1;
 xc2.Color:=c2;
 xc.Red:=Round(xc1.Red*xc2.Red/255);
 xc.Green:=Round(xc1.Green*xc2.Green/255);
 xc.Blue:=Round(xc1.Blue*xc2.Blue/255);
 Result:=xc.Color;
end;

procedure FillCorn(Bm: TBitMap; Corner: TCorner; G,V:Extended);
begin
 case Corner of
  crLeftTop:     SideToSide(bm,true ,true);
  crRightTop:    SideToSide(bm,false,true);
  crLeftBottom:  SideToSide(bm,true ,false);
  crRightBottom: SideToSide(bm,false,false);
 end;
 Fill(bm,G,V);
end;

function Mix(c1, c2: TColor): TColor;
Var
 xc,xc1,xc2:TColorRec;
begin
 xc1.Color:=c1;
 xc2.Color:=c2;
 //--//
 xc.Red:=(xc1.Red     +xc2.Red) div 2;
 xc.Green:=(xc1.Green +xc2.Green) div 2;
 xc.Blue:=(xc1.Blue   +xc2.Blue) div 2;
 xc.Alpha:=0;
 result:=xc.Color;
end;

function Mix(c1,c2:TColor; k:Extended):TColor; overload;
Var
 xc,xc1,xc2:TColorRec;
begin
 if SameValue(k,0.5) or (k<0) or (k>1) then begin
  result:=Mix(c1,c2);
  Exit;
 end;
 //--//
 xc1.Color:=c2;
 xc2.Color:=c1;
 xc.Red:=Round(xc1.Red*k+xc2.Red*(1-k));
 xc.Green:=Round(xc1.Green*k+xc2.Green*(1-k));
 xc.Blue:=Round(xc1.Blue*k+xc2.Blue*(1-k));
 xc.Alpha:=0;
 result:=xc.Color;
end;

procedure Draw(Bm: TBitMap; G, V: Extended; ARect: TRect);
Var
 bmTmp:TBitMap;
begin
 bmTmp:=TBitMap.Create;
 CopyBm(bm,bmTmp,ARect);
 bmTmp.PixelFormat:=pf24bit;
 FillG(bmTmp,G);
 With ARect do
  bm.Canvas.Draw(Left,Top,bmTmp);
 bmTmp.Free;
end;

procedure DrawG(Bm: TBitMap; K: Extended; ARect: TRect);
Var
 bmTmp:TBitMap;
begin
 bmTmp:=TBitMap.Create;
 CopyBm(bm,bmTmp,ARect);
 bmTmp.PixelFormat:=pf24bit;
 FillG(bmTmp,K);
 With ARect do
  bm.Canvas.Draw(Left,Top,bmTmp);
 bmTmp.Free;
end;

procedure DrawV(Bm: TBitMap; K: Extended; ARect: TRect);
Var
 bmTmp:TBitMap;
begin
 bmTmp:=TBitMap.Create;
 CopyBm(bm,bmTmp,ARect);
 bmTmp.PixelFormat:=pf24bit;
 FillV(bmTmp,K);
 With ARect do
  bm.Canvas.Draw(Left,Top,bmTmp);
 bmTmp.Free;
end;

procedure DrawCorners(BM, bm1, bm2, bm3, bm4: TBitMap);
begin
 With BM, Canvas do begin
  Draw(0,0,bm1);
  Draw(Width-bm2.Width,0,bm2);
  Draw(0,Height-bm3.Height,bm3);
  Draw(Width-bm4.Width,Height-bm4.Height,bm4);
 end;
end;

procedure Grad(Col1, Col2: TColor; Count: integer; var Grd: ai; K:Extended);
Var
 i,dr,dg,db:integer;
 kg:Extended;
 xc,xc1,xc2:TColorRec;
begin
 xc1.Color:=Col1;
 xc2.Color:=Col2;
 SetLength(Grd,Count);
 dr:=xc2.Red-xc1.Red;
 dg:=xc2.Green-xc1.Green;
 db:=xc2.Blue-xc1.Blue;
 For i:=0 to Count-1 do begin
  { TODO 1 -oOwner -cCategory : Перевести к целочисленому виду}
  kg:=Gamma(k,i/Count);
  xc.Red:=Round(dr*kg+xc1.Red);
  xc.Green:=Round(dg*kg+xc1.Green);
  xc.Blue:=Round(db*kg+xc1.Blue);
  Grd[i]:=xc.Color;
 end;
end;

procedure Grad(Col1, Col2: TColor; Ks:ar; var Grd: ai); overload;
Var
 i,dr,dg,db:integer;
 Count:integer;
 kg:Extended;
 xc,xc1,xc2:TColorRec;
begin
 xc1.Color:=Col1;
 xc2.Color:=Col2;
 Count:=Length(ks);
 SetLength(Grd,Count);
 dr:=xc2.Red-xc1.Red;
 dg:=xc2.Green-xc1.Green;
 db:=xc2.Blue-xc1.Blue;
 For i:=0 to Count-1 do begin
  { TODO 1 -oOwner -cCategory : Перевести к целочисленому виду}
  kg:=ks[i];
  xc.Red:=Round(dr*kg+xc1.Red);
  xc.Green:=Round(dg*kg+xc1.Green);
  xc.Blue:=Round(db*kg+xc1.Blue);
  Grd[i]:=xc.Color;
 end;
end;

procedure CopyBm(bmSource, bmDest: TBitMap; ARect: TRect);
Var
 w,h:Integer;
begin
 With ARect do begin
  w:=max(0,Right-Left);
  h:=max(0,Bottom-Top);
 end;
 bmDest.Width:=w;
 bmDest.Height:=h;
 bmDest.Canvas.CopyRect(Rect(0,0,w,h),bmSource.Canvas,ARect);
end;

procedure OutBtn(BM,LT,RT,LB,RB:TBitMap; GK,VK:Extended);
Var
 BigRect,SmallRect:TRect;
begin
 BigRect:=GetBig(BM,LT,RT,LB,RB);
 SmallRect:=GetSmall(BM,LT,RT,LB,RB);
 DrawCorners(BM,LT,RT,LB,RB);
 ////////////////////// x //////////////////////
 With BigRect do begin
  DrawG(bm,GK,Rect(left-1,0,right+1,top));
  DrawG(bm,GK,Rect(left-1,bottom,right+1,bm.Height));
  DrawV(bm,VK,Rect(0,top-1,left,bottom+1));
  DrawV(bm,VK,Rect(right,top-1,bm.Width,bottom+1));
  Draw(bm,GK,VK,Rect(left-1,top-1,right+1,bottom+1));
 end;
end;

procedure OutBtn(ms:TStream; BM:TBitMap); overload;
Var
 b1,b2,b3,b4:TBitmap;
 tc:TColor;
 g,v:Extended;
begin
 b1:=TBitmap.Create;
 b2:=TBitmap.Create;
 b3:=TBitmap.Create;
 b4:=TBitmap.Create;
 LoadBtnFromStream(ms,b1,b2,b3,b4,g,v,tc);
 OutBtn(BM,b1,b2,b3,b4,g,v);
 b1.Free;
 b2.Free;
 b3.Free;
 b4.Free;
end;

function GetBig(BM, bm1, bm2, bm3, bm4: TBitMap): TRect;
begin
 With Result do begin
  Left:=Min(bm1.Width,bm3.Width);
  Right:=bm.Width-Min(bm2.Width,bm4.Width);
  Top:=Min(bm1.Height,bm2.Height);
  Bottom:=bm.Height-Min(bm3.Height,bm4.Height);
 end;
end;

function GetSmall(BM, bm1, bm2, bm3, bm4: TBitMap): TRect;
begin
 With Result do begin
  Left:=Max(bm1.Width,bm3.Width);
  Right:=bm.Width-Max(bm2.Width,bm4.Width);
  Top:=Max(bm1.Height,bm2.Height);
  Bottom:=bm.Height-Max(bm3.Height,bm4.Height);
 end;
end;

procedure ReadBMP(ms:TStream; bmp:TBitMap);
Var
 m:TMemoryStream;
 sz:integer;
begin
 m:=TMemoryStream.Create;
 ms.Read(sz,4);
 m.CopyFrom(ms,sz);
 m.Position:=0;
 if bmp<>nil then begin
  bmp.Width:=0;
  bmp.Height:=0;
  bmp.LoadFromStream(m);
 end;
 m.Free;
end;

procedure WriteBMP(ms:TStream; bmp:TBitMap);
Var
 m:TMemoryStream;
 sz:integer;
begin
 m:=TMemoryStream.Create;
 if bmp<>nil then bmp.SaveToStream(m);
 m.Position:=0;
 sz:=m.Size;
 ms.Write(sz,4);
 ms.CopyFrom(m,sz);
 m.Free;
end;

procedure LoadBtnFromStream( ms:TStream; LT,RT,LB,RB:TBitMap; out GK,VK:Extended;
                             out TC:TColor);
Var
 Gx,Vx:Real;
begin
 ms.Read(Gx,8);
 GK:=Gx;
 ms.Read(Vx,8);
 VK:=Vx;
 ReadBMP(ms,LT);
 ReadBMP(ms,RT);
 ReadBMP(ms,LB);
 ReadBMP(ms,RB);
 if ms.Position<ms.Size then ms.Read(TC,4) else tc:=clNone;
end;

procedure SaveBtnToStream(ms:TStream; LT,RT,LB,RB:TBitMap; GK,VK:Extended; TC:TColor);
Var
 Gx,Vx:Real;
begin
 Gx:=GK;
 Vx:=VK;
 ms.Write(Gx,8);
 ms.Write(Vx,8);
 WriteBMP(ms,LT);
 WriteBMP(ms,RT);
 WriteBMP(ms,LB);
 WriteBMP(ms,RB);
 ms.Write(TC,4);
end;

procedure OutCenterText(bmv: TBitMap; Text:String; AFont:TFont; Down:boolean=false);
Var
 w,h:integer;
 x:integer;
 r:TRect;
 s:String;
begin
 if Down then x:=0 else x:=1;
 s:=Text;
 With bmv, Canvas do begin
  Brush.Style:=bsClear;
  Font:=AFont;
  With TextExtent(s) do begin
   w:=Width;
   h:=Height;
   r:=Rect(4,4,w-4,h-4);
   if w>=h
    then TextRect(r,(w-cx) div 2-x,(h-cy) div 2-x,s)
    else begin
     Font.Handle:=CreateRotatedFont(Font,90);
     x:=1-x;
     TextRect(r,(w-cy) div 2+1,(h+cx) div 2+2+x,s);
    end;
   end;
 end;
end;

procedure Turn90(bmp:TBitMap);
Var
 bm:TBitMap;
 i,j:integer;
 w,h:integer;
 qt,qt1:TQuickPixels;
begin
 if bmp=nil then Exit;
 if bmp.PixelFormat=pfDevice then bmp.PixelFormat:=pf24bit;
 bm:=TBitmap.Create;
 w:=bmp.Width;
 h:=bmp.Height;
 bm.Width:=h;
 bm.Height:=w;
 bm.PixelFormat:=pf24bit;
 qt:=TQuickPixels.Create;
 qt1:=TQuickPixels.Create;
 qt.Attach(bm);
 qt1.Attach(bmp);
 For i:=0 to w-1 do
  For j:=0 to h-1 do qt.Pixels[j,i]:=qt1.Pixels[i,h-j-1];
 bmp.Width:=w;
 bmp.Height:=h;
 bmp.Canvas.Draw(0,0,bm);
 bm.Free;
 qt.Free;
 qt1.Free;
end;

procedure Turn270(bmp:TBitMap);
Var
 bm:TBitMap;
 i,j:integer;
 w,h:integer;
 qt,qt1:TQuickPixels;
begin
 if bmp=nil then Exit;
 if bmp.PixelFormat=pfDevice then bmp.PixelFormat:=pf24bit;
 bm:=TBitmap.Create;
 bm.PixelFormat:=pf24bit;
 w:=bmp.Width;
 h:=bmp.Height;
 bm.Width:=h;
 bm.Height:=w;
 qt:=TQuickPixels.Create;
 qt1:=TQuickPixels.Create;
 qt.Attach(bm);
 qt1.Attach(bmp);
 For i:=0 to w-1 do
  For j:=0 to h-1 do qt.Pixels[j,i]:=qt1.Pixels[w-i-1,j];
 bmp.Assign(bm);
 bm.Free;
 qt.Free;
 qt1.Free;
end;

procedure Turn180(bmp:TBitMap);
Var
 bm:TBitMap;
 i,j:integer;
 w,h:integer;
 qt,qt1:TQuickPixels;
begin
 if bmp=nil then Exit;
 if bmp.PixelFormat=pfDevice then bmp.PixelFormat:=pf24bit;
 bm:=TBitmap.Create;
 bm.PixelFormat:=pf24bit;
 w:=bmp.Width;
 h:=bmp.Height;
 bm.Width:=h;
 bm.Height:=w;
 qt:=TQuickPixels.Create;
 qt1:=TQuickPixels.Create;
 qt.Attach(bm);
 qt1.Attach(bmp);
 For i:=0 to w-1 do
  For j:=0 to h-1 do qt.Pixels[i,j]:=qt1.Pixels[w-i-1,h-j-1];
 bmp.Assign(bm);
 bm.Free;
 qt.Free;
 qt1.Free;
end;

procedure CopyToPrinter;
var
 Info: PBitmapInfo;
 InfoSize, ImageSize: DWord;
 Image: Pointer;
 w,h:Integer;
begin
 GetDIBSizes(Bitmap.Handle, InfoSize, ImageSize);
 Info:=AllocMem(InfoSize);
 w:=BitMap.Width;
 h:=BitMap.Height;
 try
  Image:=AllocMem(ImageSize);
  try
   GetDIB(Bitmap.Handle,0,Info^,Image^);
   StretchDIBits( Printer.Canvas.Handle,x,y,x+w,y+h,0,0,w,h,Image,Info^,
                  DIB_RGB_COLORS,SRCCOPY);
  finally
   FreeMem(Image, ImageSize);
  end;
 finally
   FreeMem(Info, InfoSize);
 end;
end;

procedure ClearImage(Image:TImage);
Var
 bm:TBitmap;
begin
 bm:=TBitmap.Create;
 bm.Width:=Image.Width;
 bm.Height:=Image.Height;
 Image.Picture.Bitmap.Assign(bm);
 bm.Free;
end;

procedure ClearBitMap(BitMap:TBitMap;Color:TColor);
//Var
 //bc:TColor;
Begin
 if BitMap.Empty then Exit;
 //bc:=BitMap.Canvas.Brush.Color;
 BitMap.Canvas.Brush.Style:=bsSolid;
 BitMap.Canvas.Brush.Color:=Color;
 BitMap.Canvas.FillRect(Rect(0,0,BitMap.Width,BitMap.Height));
 //BitMap.Canvas.Brush.Color:=bc;
End;

function RealCoord(Image:TImage; x,y:Integer):TPoint; overload;
Var
 kx,ky:Extended;
 cx,cy,iw,ih,pw,ph:Integer;
begin
 Result.x:=0;
 Result.y:=0;
 pw:=Image.Picture.Width;
 ph:=Image.Picture.Height;
 iw:=Image.Width;
 ih:=Image.Height;
 if (pw=0) or (ph=0) or (iw=0) or (ih=0) then Exit;
 kx:=1;
 ky:=1;
 cx:=0;
 cy:=0;
 if Image.Stretch then begin
  kx:=pw/iw;
  ky:=ph/ih;
  if Image.Proportional then begin
   if kx<ky then begin
    kx:=ky;
    pw:=Round(pw/kx);
    ph:=ih;
   end else begin
    ky:=kx;
    pw:=iw;
    ph:=Round(ph/ky);
   end;
  end;
 end;
 if Image.Center then begin
  cx:=(iw-pw) div 2;
  cy:=(ih-ph) div 2;
 end;
 Result.x:=Round((x-cx)*kx);
 Result.y:=Round((y-cy)*ky);
end;

function RealCoord(Image:TImage; p:TPoint):TPoint; overload;
begin
 With p do RealCoord(Image,x,y);
end;

procedure Stretch(a:ai;out b:ai);
Var
 i:integer;
begin
 For i:=0 to High(b) do begin
 end;
end;

function RGBToGray(Color:TColor):TColor;
begin
 With TColorRec(Color) do
  Result:=(59*Green+30*Red+11*Blue) div 100 * $10101;
end;

function NewBitMap(AWidth,AHeight:integer;AColor:TColor):TBitMap;
begin
 result:=TBitmap.Create;
 Result.Width:=AWidth;
 Result.Height:=AHeight;
 Result.Canvas.Brush.Color:=AColor;
 Result.Canvas.FillRect(Rect(0,0,AWidth,AHeight));
end;

procedure Tramplin(Canvas:TCanvas; ARect:TRect; Color:TColor; Direct:TDirection);
Var
 XLT,XRT,XLB,XRB:TBitMap;
{} procedure Order(blt,brt,blb,brb:TBitMap);
{} begin
{}  XLT:=blt;
{}  XRT:=brt;
{}  XLB:=blb;
{}  XRB:=brb;
{} end;
{} /////////////////// x ///////////////////
{} procedure Scatter(w:integer;Var a,b,c,d:integer);
{} begin
{}  a:=w div 2;
{}  b:=w-a;
{}  c:=1;
{}  d:=1;
{} end;
Var
 Xtmp,b1,b2,b3,b4:TBitMap;
 dx1,dx2,dy1,dy2:integer;
 w,h:Integer;
 r1,r2:TRect;
 gk,vk:Extended;
begin
 With ARect do Begin
  w:=Right-Left;
  h:=Bottom-Top;
  Case Direct of
   drUp,drTop: Begin
    Scatter(w,dx1,dx2,dy1,dy2);
    r1:=Rect(Left,Bottom-dy1,Left+dx1,Bottom);
    r2:=Rect(Right-dx2,Bottom-dy2,Right,Bottom);
    //gk:=0.5;
    //vk:=0.7;
   End;
   drDown,drBottom: Begin
    Scatter(w,dx1,dx2,dy1,dy2);
    r1:=Rect(Left,Top,Left+dx1,Top+dy1);
    r2:=Rect(Right-dx2,Top,Right,Top+dy2);
    //gk:=0.5;
    //vk:=0.3;
   End;
   drLeft: Begin
    Scatter(h,dy1,dy2,dx1,dx2);
    r1:=Rect(Right-dx1,Top,Right,Top+dy1);
    r2:=Rect(Right-dx2,Bottom-dy2,Right,Bottom);
    //gk:=0.7;
    //vk:=0.5;
   End;
   drRight: Begin
    Scatter(h,dy1,dy2,dx1,dx2);
    r1:=Rect(Left,Top,Left+dx1,Top+dy1);
    r2:=Rect(Left,Bottom-dy2,Left+dx2,Bottom);
    //gk:=0.3;
    //vk:=0.5;
   End;
   else Exit;
  End;
  gk:=0.5;
  vk:=0.5;
  Xtmp:=NewBitMap(Right-Left,Bottom-Top,0);
  b1:=NewBitMap(dx1,dy1,Color);
  b2:=NewBitMap(dx2,dy2,Color);
  b3:=NewBitMap(dx1,dy1,Color);
  b4:=NewBitMap(dx2,dy2,Color);
  b3.Canvas.CopyRect(Rect(0,0,dx1,dy1),Canvas,r1);
  b4.Canvas.CopyRect(Rect(0,0,dx2,dy2),Canvas,r2);
  Case Direct of
   drUp,drTop: Order(b1,b2,b3,b4);
   drDown,drBottom: Order(b3,b4,b1,b2);
   drRight: Order(b3,b1,b4,b2);
   drLeft: Order(b1,b3,b2,b4);
  End;
  OutBtn(Xtmp,XLT,XRT,XLB,XRB,1-gk,1-vk);
  Canvas.Draw(Left,Top,Xtmp);
 End;
 b1.Free;
 b2.Free;
 b3.Free;
 b4.Free;
 Xtmp.Free;
end;

procedure OutSimpleBtn(Canvas:TCanvas; ARect:TRect; Colors:array of TColor; GK,VK:Extended);
Var
 c:array[1..4] of TColor;
 i,n:integer;
 b,blt,brt,blb,brb:TBitmap;
begin
 n:=High(Colors);
 if n=-1 then Exit;
 For i:=1 to 4 do
  if i>n+1
  then c[i]:=Colors[0]
  else c[i]:=Colors[i-1];
 blt:=NewBitMap(1,1,c[1]);
 brt:=NewBitMap(1,1,c[2]);
 blb:=NewBitMap(1,1,c[3]);
 brb:=NewBitMap(1,1,c[4]);
 With ARect do Begin
  b:=NewBitMap(abs(Right-Left),abs(Bottom-Top),0);
  OutBtn(b,blt,brt,blb,brb,GK,VK);
  Canvas.Draw(Left,Top,b);
 End;
 blt.Free;
 brt.Free;
 blb.Free;
 brb.Free;
 b.Free;
end;

function IsDark(Color:TColor):boolean;
begin
 result:=RGBToGray(Color)<=clGray;
end;

procedure SetBrushPen(Canvas:TCanvas;BrushColor,PenColor:TColor; PenWidth:Integer=1);
begin
 if BrushColor=clNone
 then Canvas.Brush.Style:=bsClear
 else Canvas.Brush.Style:=bsSolid;
 Canvas.Brush.Color:=BrushColor;
 if PenColor=clNone
 then Canvas.Pen.Style:=psClear
 else Canvas.Pen.Style:=psSolid;
 Canvas.Pen.Color:=PenColor;
 Canvas.Pen.Width:=PenWidth;
end;

{
begin
end;

}
{ TPipe }

procedure TPipe.BottomBottom(AStart, AFinish: TPipeEnd);
Var
 strt,fnsh:TPipeEnd;
 dy,l1,l2:integer;
begin
 dy:=AFinish.y-AStart.y;
 l1:=max(MinLength,MinLength-dy);
 l2:=max(MinLength,MinLength+dy);
 strt:=DrawPiece(AStart,l1);
 fnsh:=DrawPiece(AFinish,l2);
 strt:=DrawSector(strt,drRight);
 fnsh:=DrawSector(fnsh,drLeft);
 LeftRight(strt,fnsh);
end;

procedure TPipe.BottomLeft(AStart, AFinish: TPipeEnd);
Var
 fnsh:TPipeEnd;
 dy:integer;
begin
 fnsh:=DrawPiece(AFinish,MinLength);
 dy:=AStart.y-AFinish.y;
 if dy>MinLength+2*FRadius+FWidth
  then fnsh:=DrawSector(fnsh,drRight)
  else fnsh:=DrawSector(fnsh,drLeft);
 Draw(AStart,fnsh);
end;

procedure TPipe.BottomRight(AStart, AFinish: TPipeEnd);
Var
 strt:TPipeEnd;
 dy:integer;
 rw:integer;
begin
 strt:=AStart;
 rw:=FRadius+FWidth;
 dy:=AStart.y-AFinish.y;
 if dy>rw then Begin
  strt:=DrawPiece(strt,dy-rw);
 End;
 strt:=DrawPiece(strt,MinLength);
 strt:=DrawSector(strt,drRight);
 LeftRight(strt,AFinish);
end;

procedure TPipe.BottomTop(AStart, AFinish: TPipeEnd);
Var
 dy,dx,rw,rw2:integer;
 strt,fnsh:TPipeEnd;
 drx,dry:integer;
 x1,x2,y1,y2:integer;
 l:integer;
begin
 rw:=2*FRadius+FWidth;
 rw2:=rw div 2;
 dy:=AStart.y-AFinish.y;
 dx:=AFinish.x-AStart.x;
 if dy>0 then begin
  if dx=0 then begin
   DrawPiece(AStart,dy);
  end else
  if dx<rw then begin
   drx:=rw-dx;
   dry:=Round_(sqrt(rw*rw-drx*drx));
   l:=(dy-dry) div 2;
   DrawPiece(AStart,l);
   DrawPiece(AFinish,l);
   y1:=AStart.y-l;
   y2:=AFinish.y+l;
   x1:=AStart.x+rw2;
   x2:=AFinish.x-rw2;
   DrawSector(x1,y1,x2,y2,x1-1,y1);
   DrawSector(x2,y2,x1,y1,x2+1,y2);
  end else begin
   l:=(abs(dy)-rw) div 2;
   strt:=DrawPiece(AStart,l);
   fnsh:=DrawPiece(AFinish,l);
   DrawSector(strt,drRight);
   DrawSector(fnsh,drRight);
   y1:=(AStart.y+AFinish.y) div 2;
   x1:=min(AStart.x,AFinish.x)+rw2;
   l:=max(AStart.x,AFinish.x)-rw2-x1;
   DrawPiece(x1,y1,l,drLeft);
  end;
 end else begin
  strt:=DrawPiece(AStart,MinLength);
  strt:=DrawSector(strt,drRight);
  fnsh:=DrawPiece(AFinish,MinLength);
  fnsh:=DrawSector(fnsh,drRight);
  LeftRight(strt,fnsh);
 end;
end;

constructor TPipe.Create;
begin
 FMinLength:=1;
 FColor:=clNavy;
 FBrightness:=100;
 FRadius:=10;
 Width:=10;
 FStart:=PipeEnd(0,0,drLeft);
 FFinish:=FStart;
 FFinish.Direction:=drRight;
 FCanvas:=nil;
end;

procedure TPipe.DrawBend1(Canvas:TCanvas);
begin

end;

procedure TPipe.DrawBend2(Canvas:TCanvas);
begin

end;

function TPipe.DrawPiece(x,y,ALength: integer;
  ADirection: TDirection):TPipeEnd;
Var
 bm:TBitmap;
 QP:TQuickPixels;
 i,cx,cy,ex,ey:integer;
begin
 Result:=PipeEnd(x,y,ADirection);
 if FCanvas=nil then Exit;
 if ALength<=0 then Exit;
 bm:=TBitmap.Create;
 QP:=TQuickPixels.Create;
 Case ADirection of
  drBottom,drTop: begin
   bm.Width:=FWidth;
   bm.Height:=ALength;
   QP.Attach(bm);
   For i:=0 to FWidth-1 do begin
    QP[i,0]:=FGrad[i];
    QP[i,bm.Height-1]:=FGrad[i];
   end;
   DrawV(bm,0.5,Rect(0,0,bm.Width,bm.Height));
   cx:=x-FWidth div 2;
   ex:=x;
   if ADirection=drTop
   then begin
    cy:=y;
    ey:=y+ALength;
   end else begin
    cy:=y-ALength;
    ey:=cy;
   end;
  end;
  drLeft,drRight: begin
   bm.Width:=ALength;
   bm.Height:=FWidth;
   QP.Attach(bm);
   For i:=0 to FWidth-1 do begin
    QP[0,i]:=FGrad[i];
    QP[bm.Width-1,i]:=FGrad[i];
   end;
   DrawG(bm,0.5,Rect(0,0,bm.Width,bm.Height));
   cy:=y-FWidth div 2;
   ey:=y;
   if ADirection=drLeft
   then begin
    cx:=x;
    ex:=x+ALength;
   end else begin
    cx:=x-ALength;
    ex:=cx;
   end;
  end;
  else Exit;
 end;
 FCanvas.Draw(cx,cy,bm);
 bm.Free;
 QP.Free;
 Result:=PipeEnd(ex,ey,ADirection);
end;

function TPipe.DrawPiece(APipeEnd: TPipeEnd;
  ALength: integer):TPipeEnd;
begin
 result:=DrawPiece(APipeEnd.x,APipeEnd.y,ALength,APipeEnd.Direction);
end;

procedure TPipe.Draw;
begin
 Draw(Start,Finish);
end;

type
 TDrawProc=procedure (AStart, AFinish: TPipeEnd) of object;

procedure TPipe.Draw(AStart, AFinish: TPipeEnd);
Var
 x:integer;
 p:TPipeEnd;
 dp:TDrawProc;
begin
 if FCanvas=nil then Exit;
 if AStart.x>AFinish.x then begin
  p:=AStart;
  AStart:=AFinish;
  AFinish:=p;
 end;
 x:=ord(AStart.Direction)*4+ord(AFinish.Direction);
 Case x of
  0: dp:=LeftLeft;
  1: dp:=LeftTop;
  2: dp:=LeftRight;
  3: dp:=LeftBottom;
  4: dp:=TopLeft;
  5: dp:=TopTop;
  6: dp:=TopRight;
  7: dp:=TopBottom;
  8: dp:=RightLeft;
  9: dp:=RightTop;
  10: dp:=RightRight;
  11: dp:=RightBottom;
  12: dp:=BottomLeft;
  13: dp:=BottomTop;
  14: dp:=BottomRight;
  15: dp:=BottomBottom;
  else Exit;
 end;
 dp(AStart,AFinish);
end;

procedure TPipe.DrawSector(x0,y0,x1,y1,x2,y2: integer);
Var
 FSector:TBitMap;
 a,a1,a2,l:Extended;
 i,j,ln,c:integer;
 wr,cl:Integer;
 qt:TQuickPixels;
begin
 if FCanvas=nil then Exit;
 qt:=TQuickPixels.Create;
 FSector:=TBitmap.Create;
 FSector.Transparent:=true;
 FSector.TransparentColor:=clWhite;
 FSector.Canvas.Pen.Style:=psClear;
 wr:=FWidth+FRadius;
 FSector.Width:=wr*2;
 FSector.Height:=FSector.Width;
 FSector.Canvas.Rectangle(0,0,FSector.Width,FSector.Height);
 qt.Attach(FSector);
 a1:=-ArcTan2(y1-y0,x1-x0);
 a2:=-ArcTan2(y2-y0,x2-x0);
 if a1>a2 then a2:=a2+2*pi;
 ln:=High(FGrad);
 For i:=-wr to wr do
  For j:=-wr to wr do begin
   l:=Hypot(i,j);
   if (l<FRadius) or (l>=wr) then Continue;
   a:=-ArcTan2(j,i);
   if (a<a1) or (a>a2) then Continue;
   c:=Round(l-FRadius);
   c:=Morph(c,FWidth,ln-1);
   if (a>0) and (a<pi/2) then begin
    cl:=Mix(FGrad[c],FGrad[FWidth-c-1],Morph(a,0,pi/2,0,1));
   end else
   if (a>-pi) and (a<-pi/2) then begin
    cl:=Mix(FGrad[c],FGrad[FWidth-c-1],Morph(a,-pi,-pi/2,1,0));
   end else
   if (a>pi/2) and (a<pi)
    then cl:=FGrad[FWidth-c-1]
    else cl:=FGrad[c];
   qt.Pixels[i+wr,j+wr]:=cl;
  end;
 qt.Free;
 FCanvas.Draw(x0-wr,y0-wr,FSector);
 FSector.Free;
end;

function TPipe.DrawSector(AStart: TPipeEnd;
  ADirection: TDirection): TPipeEnd;
Var
 x,y,ex,ey:integer;
 dx1,dy1,dx2,dy2:integer;
 n1,n2:Shortint;
 wr:integer;
Const
 dx:array[0..3] of Shortint=(1,0,-1,0);
 dy:array[0..3] of Shortint=(0,-1,0,1);
 dn:array[drLeft..drRight] of Shortint=(0,0,1);
 n:array[0..1,drLeft..drBottom] of Shortint=((3,2,1,0),(2,1,0,3));
 dr:array[0..1,drLeft..drBottom] of TDirection=(
 (drBottom,drLeft,drTop,drRight),
 (drTop,drRight,drBottom,drLeft));
begin
 if [ADirection]*[drLeft,drRight]=[] then Exit;
 wr:=FRadius+FWidth div 2;
 n1:=n[dn[ADirection],AStart.Direction];
 if ADirection=drRight then n1:=(n1+2) mod 4;
 dx1:=dx[n1];
 dy1:=dy[n1];
 n2:=(n1+1) mod 4;
 dx2:=dx[n2];
 dy2:=dy[n2];
 if ADirection=drLeft then begin
  x:=AStart.x-wr*dx1;
  y:=AStart.y-wr*dy1;
  ex:=x+wr*dx2;
  ey:=y+wr*dy2;
 end else begin
  x:=AStart.x-wr*dx2;
  y:=AStart.y-wr*dy2;
  ex:=x+wr*dx1;
  ey:=y+wr*dy1;
 end;
 DrawSector(x,y,x+dx1,y+dy1,x+dx2,y+dy2);
 Result:=PipeEnd(ex,ey,dr[dn[ADirection],AStart.Direction]);
end;

procedure TPipe.LeftBottom(AStart, AFinish: TPipeEnd);
Var
 fnsh:TPipeEnd;
 dy:integer;
 rw:integer;
begin
 fnsh:=AFinish;
 rw:=FRadius+FWidth;
 dy:=AFinish.y-AStart.y;
 if dy>rw then Begin
  fnsh:=DrawPiece(fnsh,dy-rw);
 End;
 fnsh:=DrawPiece(fnsh,MinLength);
 fnsh:=DrawSector(fnsh,drLeft);
 LeftRight(AStart,fnsh);
end;

procedure TPipe.LeftLeft(AStart, AFinish: TPipeEnd);
Var
 dy:integer;
 fnsh:TPipeEnd;
begin
 fnsh:=DrawPiece(AFinish,MinLength);
 dy:=AStart.y-AFinish.y;
 if dy<0
  then fnsh:=DrawSector(fnsh,drLeft)
  else fnsh:=DrawSector(fnsh,drRight);
 Draw(AStart,fnsh);
end;

procedure TPipe.LeftRight(AStart, AFinish: TPipeEnd);
Var
 dx,dy,dry,drx,rw,rw2:Integer;
 x0,y0,x1,x2,y1,y2,l,d:integer;
begin
 dx:=AFinish.x-AStart.x;
 dy:=AStart.y-AFinish.y;
 rw:=2*FRadius+FWidth;
 rw2:=rw div 2;
 if dy=0 then begin
  DrawPiece(AStart.x,AStart.y,dx,drLeft);
 end else
 if abs(dy)<rw then begin
  dry:=rw-abs(dy);
  drx:=Round_(sqrt(rw*rw-dry*dry));
  l:=(dx-drx) div 2;
  DrawPiece(AStart,l);
  DrawPiece(AFinish,l);
  x1:=AStart.x+l;
  x2:=AFinish.x-l-1;
  if dy>0 then begin
   y1:=AStart.y-rw2;
   y2:=AFinish.y+rw2;
   DrawSector(x1,y1,x1,y1+1,x2,y2);
   DrawSector(x2,y2,x2,y2-1,x1,y1);
  end else begin
   y1:=AStart.y+rw2;
   y2:=AFinish.y-rw2;
   DrawSector(x1,y1,x2,y2,x1,y1-1);
   DrawSector(x2,y2,x1,y1,x2,y2+1);
  end;
 end
 else begin
  l:=(dx-rw) div 2;
  DrawPiece(AStart,l);
  DrawPiece(AFinish,l);
  if dy>0 then d:=-1 else d:=1;
  x0:=AStart.x+l;
  y0:=AStart.y+rw2*d;
  DrawSector(x0,y0,x0+d+1,y0-d+1,x0-d+1,y0-d-1);
  x0:=AFinish.x-l-1;
  y0:=AFinish.y-rw2*d;
  DrawSector(x0,y0,x0-d-1,y0+d-1,x0+d-1,y0+d+1);
  x0:=(AStart.x+AFinish.x) div 2;
  y0:=min(AStart.y,AFinish.y)+rw2;
  l:=max(AStart.y,AFinish.y)-rw2-y0;
  DrawPiece(x0,y0,l,drTop);
 end;
end;

procedure TPipe.LeftTop(AStart, AFinish: TPipeEnd);
Var
 fnsh:TPipeEnd;
 dy:integer;
 rw:integer;
begin
 fnsh:=AFinish;
 rw:=FRadius+FWidth;
 dy:=AStart.y-AFinish.y;
 if dy>rw then Begin
  fnsh:=DrawPiece(fnsh,dy-rw);
 End;
 fnsh:=DrawPiece(fnsh,MinLength);
 fnsh:=DrawSector(fnsh,drRight);
 LeftRight(AStart,fnsh);
end;

procedure TPipe.NewGrad;
Var
 w4:integer;
 m1,m2,m3:ai;
 lcl:TColor;
begin
 lcl:=Mix(clWhite,FColor,1-FBrightness/100);
 w4:=FWidth div 4;
 Grad(FColor,lcl,w4+1,m1,0.5);
 Grad(lcl,FColor,FWidth-2*w4,m2,0.5);
 Grad(FColor,clBlack,w4,m3,0.5);
 MergeAI(FGrad,[m1,m2,m3]);
end;

procedure TPipe.RightBottom(AStart, AFinish: TPipeEnd);
Var
 strt,fnsh:TPipeEnd;
 dy,rw:integer;
begin
 rw:=2*FRadius+FWidth;
 dy:=AFinish.y-AStart.y;
 strt:=DrawPiece(AStart,MinLength);
 if dy<=rw+MinLength
 then strt:=DrawSector(strt,drRight)
 else strt:=DrawSector(strt,drLeft);
 fnsh:=DrawPiece(AFinish,MinLength);
 fnsh:=DrawSector(fnsh,drLeft);
 Draw(strt,fnsh);
end;

procedure TPipe.RightLeft(AStart, AFinish: TPipeEnd);
Var
 dy:integer;
 strt,fnsh:TPipeEnd;
begin
 dy:=AStart.Y-AFinish.Y;
 strt:=DrawPiece(AStart,MinLength);
 fnsh:=DrawPiece(AFinish,MinLength);
 if dy>0  then begin
  strt:=DrawSector(strt,drRight);
  fnsh:=DrawSector(fnsh,drRight);
 end else begin
  strt:=DrawSector(strt,drLeft);
  fnsh:=DrawSector(fnsh,drLeft);
 end;
 Draw(strt,fnsh);
end;

procedure TPipe.RightRight(AStart, AFinish: TPipeEnd);
Var
 dy:integer;
 strt:TPipeEnd;
begin
 dy:=AStart.Y-AFinish.Y;
 strt:=DrawPiece(AStart,MinLength);
 if dy>0
 then strt:=DrawSector(strt,drRight)
 else strt:=DrawSector(strt,drLeft);
 Draw(strt,AFinish);
end;

procedure TPipe.RightTop(AStart, AFinish: TPipeEnd);
Var
 strt:TPipeEnd;
 dy:integer;
begin
 strt:=DrawPiece(AStart,MinLength);
 dy:=AStart.y-AFinish.y;
 if dy>MinLength+2*FRadius+FWidth
  then strt:=DrawSector(strt,drRight)
  else strt:=DrawSector(strt,drLeft);
 Draw(strt,AFinish);
end;

procedure TPipe.SetBrightness(const Value: Integer);
begin
 if OutSide(Value,100) then Exit;
 FBrightness := Value;
 NewGrad;
end;

procedure TPipe.SetColor(const Value: TColor);
begin
 FColor := Value;
 NewGrad;
end;

procedure TPipe.SetWidth(const Value: Integer);
begin
 FWidth := Value;
 NewGrad;
end;

function PipeEnd(AX,AY:integer; ADirection:TDirection):TPipeEnd;
begin
 With Result do begin
  x:=ax;
  y:=ay;
  Direction:=ADirection;
 end;
end;

procedure TPipe.TopBottom(AStart, AFinish: TPipeEnd);
Var
 dy,dx,rw,rw2:integer;
 strt,fnsh:TPipeEnd;
 drx,dry:integer;
 x1,x2,y1,y2:integer;
 l:integer;
begin
 rw:=2*FRadius+FWidth;
 rw2:=rw div 2;
 dy:=AStart.y-AFinish.y;
 dx:=AFinish.x-AStart.x;
 if dy<0 then begin
  if dx=0 then begin
   DrawPiece(AStart,-dy);
  end else
  if dx<rw then begin
   drx:=rw-dx;
   dry:=Round_(sqrt(rw*rw-drx*drx));
   l:=(abs(dy)-dry) div 2;
   strt:=DrawPiece(AStart,l);
   fnsh:=DrawPiece(AFinish,l);
   y1:=strt.y;
   y2:=fnsh.y;
   x1:=strt.x+rw2;
   x2:=fnsh.x-rw2;
   DrawSector(x1,y1,x1-1,y1,x2,y2);
   DrawSector(x2,y2,x2+1,y2,x1,y1);
  end else begin
   l:=(abs(dy)-rw) div 2;
   strt:=DrawPiece(AStart,l);
   fnsh:=DrawPiece(AFinish,l);
   DrawSector(strt,drLeft);
   DrawSector(fnsh,drLeft);
   y1:=(AStart.y+AFinish.y) div 2;
   x1:=min(AStart.x,AFinish.x)+rw2;
   l:=max(AStart.x,AFinish.x)-rw2-x1;
   DrawPiece(x1,y1,l,drLeft);
  end;
 end else begin
  strt:=DrawPiece(AStart,MinLength);
  strt:=DrawSector(strt,drLeft);
  fnsh:=DrawPiece(AFinish,MinLength);
  fnsh:=DrawSector(fnsh,drLeft);
  LeftRight(strt,fnsh);
 end;
end;

procedure TPipe.TopLeft(AStart, AFinish: TPipeEnd);
Var
 fnsh:TPipeEnd;
 dy:integer;
begin
 fnsh:=DrawPiece(AFinish,MinLength);
 dy:=AFinish.y-AStart.y;
 if dy>MinLength+2*FRadius+FWidth
  then fnsh:=DrawSector(fnsh,drLeft)
  else fnsh:=DrawSector(fnsh,drRight);
 Draw(AStart,fnsh);
end;

procedure TPipe.TopRight(AStart, AFinish: TPipeEnd);
Var
 strt:TPipeEnd;
 dy,rw:integer;
begin
 dy:=AFinish.y-AStart.y;
 rw:=FRadius+FWidth div 2;
 if dy>MinLength+rw
  then strt:=DrawPiece(AStart,dy-rw)
  else strt:=DrawPiece(AStart,MinLength);
 strt:=DrawSector(strt,drLeft);
 Draw(strt,AFinish);
end;

procedure TPipe.TopTop(AStart, AFinish: TPipeEnd);
Var
 strt,fnsh:TPipeEnd;
 dy,l1,l2:integer;
begin
 dy:=AFinish.y-AStart.y;
 l1:=max(MinLength,MinLength+dy);
 l2:=max(MinLength,MinLength-dy);
 strt:=DrawPiece(AStart,l1);
 fnsh:=DrawPiece(AFinish,l2);
 strt:=DrawSector(strt,drLeft);
 fnsh:=DrawSector(fnsh,drRight);
 LeftRight(strt,fnsh);
end;

initialization
finalization
 FSector.Free;
end.

