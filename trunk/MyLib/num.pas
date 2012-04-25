unit num;

interface
Uses Forms, Classes, ExtCtrls, Windows, Messages, Dialogs, Graphics, Controls,
     Math, StdCtrls, Mask;
Type
 {TNumLabEdit=Class(TLabeledEdit)
 End;}
 ///
 TNumEdit=Class(TEdit)
 private
  FDigits: byte;
  FCurrName: string;
  FValue: Real;
  FDigitLimit: boolean;
  FInfo: String;
  FAsEdit: Boolean;
  function GetCurrName: string;
  function GetIam: TNumEdit;
  procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
  procedure SetCurrName(const Value: string);
  procedure SetDigits(const AValue: byte);
  procedure SetValue(const AValue: Real);
  procedure SetDigitLimit(const AValue: boolean);
  procedure ReadCurr(Reader: TReader);
  procedure WriteCurr(Writer: TWriter);
  procedure Changii;
  procedure TextWrite;
  procedure BuhText(ch:Char);
  procedure KeyText(Var ch:Char);
 protected
  procedure WMChar(Var Message:TWMKey); message WM_Char;
  procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
  procedure CMExit(var Message: TCMExit); message CM_EXIT;
  procedure DefineProperties(Filer: TFiler); override;
 public
  property Iam:TNumEdit read GetIam;
 published
  Constructor Create(AOwner:TComponent); override;
  property Value:Real read FValue write SetValue;
  property DigitLimit:boolean read FDigitLimit write SetDigitLimit default true;
  property Digits:byte read FDigits write SetDigits default 2;
  property CurrName:String read GetCurrName write SetCurrName stored false;
  property Text stored false;
  property Info:String read FInfo write FInfo;
  property AsEdit:Boolean read FAsEdit write FAsEdit default true;
 End;

 TRusMask=Class(TMaskEdit)
  protected
    procedure ValidateError; override;

 End;

implementation

uses SysUtils, publ;

{ NumEdit }
procedure TNumEdit.Changii;
Var
 Result:Real;
 us:Boolean;
 x:Real;
begin
 Font.Color:=clBlack;
 if not Focused then Exit;
 Result:=Str2Float(Text);
 us:=not IsNan(Result);
 x:=0;
 if us and FDigitLimit then Begin
  x:=Result*Power(10,Digits);
  x:=x-int(x);
 End;
 if not IsZero(x)
  then Font.Color:=clRed
  else Begin
   Font.Color:=clBlue;
   FValue:=Result;
  End;
 if Assigned(OnChange) then OnChange(Self);
end;

procedure TNumEdit.CMEnter(var Message: TCMEnter);
Var
 p:integer;
begin
 inherited;
 p:=SelStart;
 TextWrite;
 if AsEdit then SelectAll else SelStart:=p;
end;

procedure TNumEdit.CMExit(var Message: TCMExit);
Var
 p:integer;
begin
 inherited;
 p:=SelStart;
 TextWrite;
 SelStart:=p;
end;

procedure TNumEdit.CNCommand(var Message: TWMCommand);
begin
 if Message.NotifyCode = EN_CHANGE then Changii;
end;

constructor TNumEdit.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
 fCurrName:='руб';
 fDigits:=2;
 fDigitLimit:=true;
 FAsEdit:=true;
 TextWrite;
end;

procedure TNumEdit.SetCurrName(const Value: string);
begin
 FCurrName := Value;
 TextWrite;
end;

procedure TNumEdit.SetDigits(const AValue: byte);
begin
 FDigits := AValue;
 TextWrite;
end;

procedure TNumEdit.SetDigitLimit(const AValue: boolean);
begin
 FDigitLimit := AValue;
 TextWrite;
end;

procedure TNumEdit.SetValue(const AValue: Real);
begin
 FValue := AValue;
 TextWrite;
end;

procedure TNumEdit.TextWrite;
Var
 s:string;
begin
 if IsNan(FValue) or SameValue(FValue,ImpossibleInt)
 then s:=''
 else if FDigitLimit
  then s:=Format('%.*f',[FDigits,FValue])
  else s:=Format('%g',[FValue]);
 if not Focused and (s<>'')
 then Text:=ContStr(s,' ',fCurrName)
 else Text:=s;
end;

procedure TNumEdit.WMChar(var Message: TWMKey);
Var
 ch:Char;
begin
 ch:=chr(Message.CharCode);
 KeyPress(ch);
 if ReadOnly then Exit;
 if AsEdit then Begin
  KeyText(ch);
  Message.CharCode:=byte(ch);
  inherited;
 End else BuhText(ch);
end;

function TNumEdit.GetCurrName: string;
begin
 result:=FCurrName;
end;

procedure TNumEdit.ReadCurr(Reader:TReader);
begin
 Reader.ReadListBegin;
 CurrName:=Reader.ReadString;
 Reader.ReadListEnd;
end;

procedure TNumEdit.WriteCurr(Writer:TWriter);

begin
 Writer.WriteListBegin;
 Writer.WriteString(FCurrName);
 Writer.WriteListEnd;
end;

procedure TNumEdit.DefineProperties(Filer: TFiler);

 Function DoCurr:boolean;
 Begin
  Result:=true;
  if Filer.Ancestor <> nil then
   Result := TNumEdit(Filer.Ancestor).fCurrName<>fCurrName;
 End;

begin
 inherited;
 Filer.DefineProperty('Curr_Name',ReadCurr,WriteCurr,DoCurr);
end;

{ TRusMask }

procedure TRusMask.ValidateError;
begin
 MessageBeep(0);
 raise EDBEditError.Create('Неверные данные. Нажмите ESC для отмены ввода');
end;

function TNumEdit.GetIam: TNumEdit;
begin
 result:=self;
end;

procedure TNumEdit.BuhText(ch: Char);
Var
 ds:Char;
 p,ss:integer;
 s:string;
 us:boolean;
begin
 ds:=DecimalSeparator;
 s:=text;
 if not (ch in ['-','0'..'9',#8,'.',',']) then Exit;
 ss:=SelStart+1;
 us:=(s>'') and (ss<=Length(text)) and (s[ss]=Ds);
 Case ch of
  '.',',': Begin
   if fDigits=0 then Exit;
   p:=pos(ds,s);
   if (p>0) and (ss>p) then Exit;
   if not us then s:=Copy(s,1,ss)+ds;
  End;
  '-': Begin
   p:=pos(ds,s);
   if (p>0) or (ss>1) then Exit;
   s:='-'+s;
  End;
  '0'..'9': if us then Insert(ch,s,ss) else begin
   delete(s,ss,1);
   insert(ch,s,ss);
  end;
  #8: if ss>1 then Begin
   ss:=ss-2;
   delete(s,ss+1,1);
  End;
 End;
 Text:=s;
 SelStart:=ss;
end;

procedure TNumEdit.KeyText(Var ch: Char);
Var
 ch2,ds:Char;
 p,ss:integer;
 s:string;
begin
 ch2:=ch;
 ch:=#0;
 ds:=DecimalSeparator;
 s:=text;
 if not (ch2 in ['-','0'..'9',#8,'.',',']) then Exit;
 ss:=SelStart+1;
 Case ch2 of
  '.',',': Begin
   if (fDigits=0) and DigitLimit then Exit;
   ch2:=ds;
   p:=pos(ds,s);
   if (p>0) and (ss>p) then Exit;
  End;
  '-': Begin
   p:=pos(ds,s);
   if (p>0) or (ss>1) then Exit;
  End;
 End;
 ch:=ch2;
end;

end.

