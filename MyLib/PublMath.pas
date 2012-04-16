unit PublMath;

interface
uses Math, publ, StdConvs{ ,ViewLog{};
type
 TCustomMatrix=Class
 private
  FColCount:Integer;
  FRowCount:Integer;
  NeedDim:boolean;
  FDim:Extended;
  procedure SetItems_(IndX, IndY: integer; const Value: Extended);
  function GetSub_(IndX, IndY: integer): TCustomMatrix;
 protected
  function GetItems(IndX, IndY: integer): Extended; virtual;
  function GetSub(IndX, IndY: integer): TCustomMatrix; virtual;
  function GetVector(Ind: Integer): Extended; virtual;
  procedure SetItems(IndX, IndY: integer; const Value: Extended); virtual;
  procedure SetVector(Ind: Integer; const Value: Extended); virtual; 
 public
  constructor Create(AColCount,ARowCount:integer);
  function Determinant:Extended;
  function Minor(IndX,IndY:integer):Extended;
  property ColCount:Integer read FColCount;
  property RowCount:Integer read FRowCount;
  property Items[IndX,IndY:integer]:Extended read GetItems write SetItems_;
  property SubMatrix[IndX,IndY:integer]:TCustomMatrix read GetSub_;
  property Vector[Ind:Integer]:Extended read GetVector write SetVector;
 End;
 /////////////////// x ///////////////////
 TSubMatrix=class(TCustomMatrix)
 private
  FSubMatrix:TSubMatrix;
  FParent:TCustomMatrix;
  FYInd: integer;
  FXInd: integer;
 protected
  function GetItems(IndX: Integer; IndY: Integer): Extended; override;
  function GetSub(IndX: Integer; IndY: Integer): TCustomMatrix; override;
  function GetVector(Ind: Integer): Extended; override;
  procedure SetItems(IndX: Integer; IndY: Integer; const Value: Extended); override;
  procedure SetVector(Ind: Integer; const Value: Extended); override;
 public
  constructor Create(AParent:TCustomMatrix; AColCount,ARowCount:integer);
  property XInd:integer read FXInd write FXInd;
  property YInd:integer read FYInd write FYInd;
 end;
 /////////////////// x ///////////////////
 TUMatrix=class(TCustomMatrix)
 private
  FVector:ar;
  FSubMatrix:TSubMatrix;
  FItems:aar;
  FOutcome:ar;
  NeedSolve:boolean;
  function GetOutcome(ind: integer): Extended;
  procedure Resolve;
 protected
  function GetItems(IndX: Integer; IndY: Integer): Extended; override;
  procedure SetItems(IndX: Integer; IndY: Integer; const Value: Extended); override;
  function GetSub(IndX: Integer; IndY: Integer): TCustomMatrix; override;
  function GetVector(Ind: Integer): Extended; override;
  procedure SetVector(Ind: Integer; const Value: Extended); override;
 public
  constructor Create(AColCount,ARowCount:integer);
  property Outcome[ind:integer]:Extended read GetOutcome;
 end;

 TPolinom=Class
 private
  FCount: Integer;
  UM:TUMatrix;
  FItems:array of TRealPoint;
  function GetCoefficient(ind: Integer): Extended;
  function GetPoints(Ind: Integer): TRealPoint;
  procedure SetCount(const Value: Integer);
  procedure SetPoints(Ind: Integer; const Value: TRealPoint);
 public
  Constructor Create(ACount:integer);
  property Count:Integer read FCount write SetCount;
  property Points[Ind:Integer]:TRealPoint read GetPoints write SetPoints;
  function ValueFor(x:Extended):Extended;
  property Coefficient[ind:Integer]:Extended read GetCoefficient;
  destructor Destroy; override;
 End;
 /////////////////// x ///////////////////
 TPol3=Class
 private
  x,m,m2,y,v:array[0..2] of Extended;
  FFlat: Extended;
  function GetCoefficient(ind: Integer): Extended;
  function GetPoints(Ind: Integer): TRealPoint;
  procedure SetPoints(Ind: Integer; const Value: TRealPoint);
  procedure SetFlat(const Value: Extended);
 public
  constructor Create(AFlat:Extended);
  function ValueFor(x:Extended):Extended;
  property Coefficient[ind:Integer]:Extended read GetCoefficient;
  property Points[Ind:Integer]:TRealPoint read GetPoints write SetPoints;
  property Flat:Extended read FFlat write SetFlat;
  procedure Add(x,y:Extended); overload;
  procedure Add(APoint:TRealPoint); overload;
  function ReM:TRealPoint;
 End;
// Преобразование величин из одних координат в другие
function Morph(xo, xo1, xo2, xn1, xn2: Extended): Extended; overload;
function Morph(xo, xo1, xo2, xn1, xn2: Integer): Integer; overload;
function Morph(xo, Width1, Width2: Extended): Extended; overload;
function Morph(xo, Width1, Width2: Integer): Integer; overload;
// Нахождение среднего
function GetAverage(Matrix:aar):Extended; overload;
function GetAverage(Matrix:ar):Extended; overload;
// Функции проходящие через точку (1,1)
// Функция   _
// вида    _/
function Sigma(k,x:Extended):Extended;
// Функция   _         /
// вида    /    или   /   или  |
//         |         /        _/
function Gamma(K, X: Extended): Extended;
function Basis(K: Extended): Extended;

implementation

uses VarUtils;
/////////////////// Procedures and Functions ///////////////////
function Morph(xo, xo1, xo2, xn1, xn2: Extended): Extended;
var
 k,dxn,dxo:Extended;
begin
 dxn:=(xn2-xn1);
 dxo:=(xo2-xo1);
 if dxo<1e-10 then begin
  result:=(xn2+xn1)/2;
  Exit;
 end;
 k:=dxn/dxo;
 result:=xn1+k*(xo-xo1);
end;

function Morph(xo, xo1, xo2, xn1, xn2: Integer): Integer; overload;
begin
 result:=Round(Morph(xo,xo1,xo2,xn1,xn2));
end;

function Morph(xo, Width1, Width2: Extended): Extended; overload;
begin
 result:=Morph(xo,0,Width1,0,Width2);
end;

function Morph(xo, Width1, Width2: Integer): Integer; overload;
begin
 result:=Round(Morph(xo,Width1*1.0,Width2));
end;

function Sigma(k,x:Extended):Extended;
begin
 result:=ArcTan(x*k)/Arctan(k);
end;

function Bound(X: Extended): Extended;
begin
 if x<1e-6 then x:=1e-6 else
  if x>1-1e-6 then x:=1-1e-6;
 result:=x;
end;

function Basis(K: Extended): Extended;
begin
 if K<1e-6 then result:=0 else
  if K>1-1e-6 then result:=1e+30 else
   result:=LogN(K,1-K);
end;

function Gamma(K, X: Extended): Extended;
Var
 a,b:Extended;
begin
 result:=x;
 if SameValue(k,0.5) then Exit;
 x:=Bound(x);
 a:=1-Power(X,Basis(K));
 b:=Power(1-X,Basis(1-K));
 result:=1-(a+b)/2;
end;

{ TUMatrix }

function TCustomMatrix.Determinant: Extended;
Var
 i,j:integer;
 s:string;
begin
 Repeat
   if not NeedDim then break;
   if FColCount=3 then Begin
    For i:=0 to 2 do Begin
     s:='';
     For j:=0 to 2 do s:=s+^I+Float2Str(Items[i,j]);
    End;
   End;
   FDim:=ImpossibleFloat;
   if FRowCount<>FColCount then break;
   FDim:=Items[0,0];
   if FColCount=1 then break;
   FDim:=0;
   For i:=0 to RowCount-1 do Begin
    if odd(i)
    then FDim:=FDim-Items[i,0]*Minor(i,0)
    else FDim:=FDim+Items[i,0]*Minor(i,0);
   End;
 Until true;
 Result:=FDim;
 NeedDim:=false;
end;

function TCustomMatrix.Minor(IndX, IndY:integer): Extended;
begin
 result:=ImpossibleFloat;
 if FRowCount<>FColCount
 then Begin
  Exit;
 end;
 result:=SubMatrix[IndX,IndY].Determinant;
end;

{ TUMatrix }

constructor TUMatrix.Create(AColCount, ARowCount: integer);
begin
 inherited Create(AColCount,ARowCount);
 SetLength(FItems,FColCount,FRowCount);
 SetLength(FVector,FRowCount);
 SetLength(FOutcome,FColCount);
 NeedSolve:=true;
end;

function TUMatrix.GetItems(IndX, IndY: Integer): Extended;
begin
 Result:=ImpossibleFloat;
 if OutSide(IndX,FColCount-1) or OutSide(IndY,FColCount-1)
 then Begin
  Exit;
 end;
 Result:=FItems[IndX,IndY];
end;

function TUMatrix.GetOutcome(ind: integer): Extended;
begin
 Result:=ImpossibleFloat;
 if Outside(ind,FRowCount)
 then Begin
  Exit;
 end;
 Resolve;
 Result:=FOutcome[ind];
end;

function TUMatrix.GetSub(IndX, IndY: Integer): TCustomMatrix;
begin
 if FSubMatrix=nil
 then FSubMatrix:=TSubMatrix.Create(self,FColCount-1,FRowCount-1);
 FSubMatrix.XInd:=IndX;
 FSubMatrix.YInd:=IndY;
 Result:=FSubMatrix;
end;

function TUMatrix.GetVector(Ind: Integer): Extended;
begin
 Result:=ImpossibleFloat;
 if OutSide(Ind,FColCount-1)
 then Begin
  Exit;
 end;
 result:=FVector[ind];
end;

procedure TUMatrix.Resolve;
Var
 i:integer;
 x:ar;
 d:Extended;
begin
 if not NeedSolve then Begin
  Exit;
 end;
 d:=Determinant;
 if IsNan(d) or IsZero(d) then Begin
  For i:=0 to RowCount-1 do FOutcome[i]:=ImpossibleFloat;
  NeedSolve:=false;
  exit;
 End;
 SetLength(x,RowCount);
 For i:=0 to ColCount-1 do Begin
  x:=FItems[i];
  NeedDim:=true;
  FItems[i]:=FVector;
  FOutcome[i]:=Determinant/d;
  FItems[i]:=x;
 End;
 NeedDim:=true;
 NeedSolve:=false;
end;

procedure TUMatrix.SetItems(IndX, IndY: Integer; const Value: Extended);
begin
 if OutSide(IndX,FColCount-1) or OutSide(IndY,FColCount-1)  then Begin
  Exit;
 end;
 inherited;
 FItems[IndX,IndY]:=Value;
 NeedSolve:=true;
end;

procedure TUMatrix.SetVector(Ind: Integer; const Value: Extended);
begin
 if OutSide(Ind,FColCount-1) then Begin
  Exit;
 end;
 FVector[ind]:=Value;
end;

{ TCustomMatrix }

constructor TCustomMatrix.Create(AColCount, ARowCount: integer);
begin
 FColCount:=AColCount;
 FRowCount:=ARowCount;
 NeedDim:=true;
end;

procedure TCustomMatrix.SetItems_(IndX, IndY: integer; const Value: Extended);
begin
 NeedDim:=true;
 SetItems(IndX,IndY,Value);
end;

function TCustomMatrix.GetSub_(IndX, IndY: integer): TCustomMatrix;
begin
 result:=GetSub(IndX,IndY);
 if Result<>nil then result.NeedDim:=true;
end;

function TCustomMatrix.GetItems(IndX, IndY: integer): Extended;
begin
 result:=0;
end;

function TCustomMatrix.GetSub(IndX, IndY: integer): TCustomMatrix;
begin
 result:=nil;
end;

function TCustomMatrix.GetVector(Ind: Integer): Extended;
begin
 result:=0;
end;

procedure TCustomMatrix.SetItems(IndX, IndY: integer; const Value: Extended);
begin

end;

procedure TCustomMatrix.SetVector(Ind: Integer; const Value: Extended);
begin

end;

{ TSubMatrix }

constructor TSubMatrix.Create(AParent: TCustomMatrix; AColCount,
  ARowCount: integer);
begin
 inherited Create(AColCount,ARowCount);
 FParent:=AParent;
 FSubMatrix:=nil;
end;

function TSubMatrix.GetItems(IndX, IndY: Integer): Extended;
begin
 if IndX>=FXInd then IndX:=IndX+1;
 if IndY>=FYInd then IndY:=IndY+1;
 result:=FParent.Items[IndX,IndY];
end;

function TSubMatrix.GetSub(IndX, IndY: Integer): TCustomMatrix;
begin
 if FSubMatrix=nil
 then FSubMatrix:=TSubMatrix.Create(self,FColCount-1,FRowCount-1);
 FSubMatrix.XInd:=IndX;
 FSubMatrix.YInd:=IndY;
 Result:=FSubMatrix;
end;

function TSubMatrix.GetVector(Ind: Integer): Extended;
begin
 if ind>=FYInd then inc(ind);
 result:=FParent.Vector[ind];
end;

procedure TSubMatrix.SetItems(IndX, IndY: Integer; const Value: Extended);
begin
 inherited;
 if IndX>=FXInd then IndX:=IndX+1;
 if IndY>=FYInd then IndY:=IndY+1;
 FParent.Items[IndX,IndY]:=Value;
end;

procedure TSubMatrix.SetVector(Ind: Integer; const Value: Extended);
begin
 if ind>=FYInd then inc(ind);
 FParent.Vector[ind]:=Value;
end;

{ TPolinom }

constructor TPolinom.Create(ACount: integer);
begin
 Um:=nil;
 Count:=ACount;
end;

destructor TPolinom.Destroy;
begin
 Um.Free;
 inherited;
end;

function TPolinom.GetCoefficient(ind: Integer): Extended;
begin
 Result:=Um.Outcome[ind];
end;

function TPolinom.GetPoints(Ind: Integer): TRealPoint;
begin
 Result:=RealPoint(UM.Items[Count-2,Ind],UM.Vector[ind]);
end;

procedure TPolinom.SetCount(const Value: Integer);
Var
 i,j,mi:integer;
 x:Extended;
begin
 UM.Free;
 UM:=TUMatrix.Create(Value,Value);
 mi:=Min(Value,FCount)-1;
 For j:=0 to mi do Begin
  x:=1;
  For i:=mi downto 0 do Begin
   if i<mi then x:=x*FItems[j].X;
   UM.Items[i,j]:=x;
  End;
 End;
 FCount := Value;
end;

procedure TPolinom.SetPoints(Ind: Integer; const Value: TRealPoint);
Var
 i:integer;
 v,x:Extended;
begin
 v:=Value.x;
 x:=1;
 For i:=Count-1 downto 0 do Begin
  if i<Count-1 then x:=x*v;
  Um.Items[i,ind]:=x;
  Um.Vector[ind]:=Value.Y;
 End;
end;

function TPolinom.ValueFor(x: Extended): Extended;
Var
 i:integer;
 k:array of Double;
begin
 SetLength(k,FCount);
 For i:=0 to FCount-1 do k[i]:=Coefficient[FCount-1-i];
 result:=Poly(x,k);
end;

{ TPol3 }

procedure TPol3.Add(x, y: Extended);
begin
 Add(RealPoint(x,y));
end;

procedure TPol3.Add(APoint: TRealPoint);
begin
 Move(x[1],x[0],2*SizeOf(Extended));
 Move(y[1],y[0],2*SizeOf(Extended));
 Points[2]:=APoint;
end;

constructor TPol3.Create(AFlat: Extended);
begin
 FFlat:=AFlat;
end;

function TPol3.GetCoefficient(ind: Integer): Extended;
Var
 D,Dx:Extended;
begin
 Result:=ImpossibleFloat;
 D:=m2[0]*(m[1]-m[2])-m2[1]*(m[0]-m[2])+m2[2]*(m[0]-m[1]);
 if IsZero(D)
 then Exit;
 Case ind of
  0: Dx:= v[0]*(m[1]-m[2])-v[1]*(m[0]-m[2])+v[2]*(m[0]-m[1]);
  1: Dx:= m2[0]*(v[1]-v[2])-m2[1]*(v[0]-v[2])+m2[2]*(v[0]-v[1]);
  2: Dx:= m2[0]*(v[2]*m[1]-v[1]*m[2])-
          m2[1]*(v[2]*m[0]-v[0]*m[2])+
          m2[2]*(v[1]*m[0]-v[0]*m[1]);
  else Dx:=0;
 End;
 Result:=Dx/D;
end;

function TPol3.GetPoints(Ind: Integer): TRealPoint;
begin
 Result:=RealPoint(ImpossibleFloat,ImpossibleFloat);
 if OutSide(ind,2) then Exit;
 Result:=RealPoint(x[ind],y[ind]);
end;

function TPol3.ReM:TRealPoint;
Var
 k,b,k2:Extended;
 rx,ry:Extended;
begin
 k:=x[0]-x[2];
 if IsZero(k) then Begin
  rx:=x[1];
  ry:=y[1];
 End else Begin
  k:=(y[0]-y[2])/k;
  k2:=k*k+1;
  b:=y[2]-k*x[2];
  rx:=(x[1]-k*(y[1]-b))/k2;
  ry:=k*rx+b;
 End;
 /////////////////// x ///////////////////
 m[0]:=x[0];
 m2[0]:=sqr(m[0]);
 v[0]:=y[0];
 m[1]:=(1-FFlat)*rx+FFlat*x[1];
 m2[1]:=sqr(m[1]);
 v[1]:=(1-FFlat)*ry+FFlat*y[1];
 m[2]:=x[2];
 m2[2]:=sqr(m[2]);
 v[2]:=y[2];
 result.x:=m[0];
 result.y:=v[0];
end;

procedure TPol3.SetFlat(const Value: Extended);
begin
 FFlat := Value;
 ReM;
end;

procedure TPol3.SetPoints(Ind: Integer; const Value: TRealPoint);
begin
 if OutSide(ind,2) then Exit;
 x[ind]:=Value.X;
 y[ind]:=Value.Y;
 Rem;
end;

function TPol3.ValueFor(x: Extended): Extended;
Var
 i:integer;
 k:array[0..2] of Double;
begin
 For i:=0 to 2 do k[i]:=Coefficient[2-i];
 result:=Poly(x,k);
end;

function GetAverage(Matrix:aar):Extended;
Var
 N:integer;
 i,j:integer;
begin
 Result := 0;
 N := 0;
 for i := 0 to High(Matrix) do
  for j := 0 to High(Matrix[i]) do
   if not IsNan(Matrix[i, j]) then begin
    Result := Result+Matrix[i, j];
    inc(N);
   end;
 if N=0
 then Result := ImpossibleFloat
 else Result := Result/N;
end;

function GetAverage(Matrix:ar):Extended;
Var
 N:integer;
 i:integer;
begin
 Result := 0;
 N := 0;
 for i := 0 to High(Matrix) do
   if not IsNan(Matrix[i]) then begin
    Result := Result+Matrix[i];
    inc(N);
   end;
 if N=0
 then Result := ImpossibleFloat
 else Result := Result/N;
end;

Initialization
 //LogWindowActivate;
end.

