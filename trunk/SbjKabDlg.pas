unit SbjKabDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MyDialog, StdCtrls, ExtCtrls, SbjKernel, Menus, SbjResource;

type
  TKabinetDlg = class(TDialog)
    Panel3: TPanel;
    KabName: TLabeledEdit;
    KabNum: TLabeledEdit;
    chkView: TCheckBox;
    Panel5: TPanel;
    Panel6: TPanel;
    lbHelp: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure KabNumChange(Sender: TObject);
    procedure KabNumKeyPress(Sender: TObject; var Key: Char);
    procedure KabNumKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
   sts:TStringList;
   FKabinet: TKabinet;
   FOnGetList: TGetListEvent;
   IsOldText:boolean;
   function GetKabinet: TKabinet;
  public
   constructor Create(AOwner: TComponent); override;
   Destructor Destroy; override;
   Function Execute(Kab:TKabinet):boolean;
   property Kabinet:TKabinet read GetKabinet;
   property OnGetList:TGetListEvent read FOnGetList write FOnGetList;
  end;

var
  KabinetDlg: TKabinetDlg;
resourcestring
 HelpKabinetDlg='”кажите название кабинета, которое написано над дверью, и его '
 +'номер. ≈сли у кабинета нет номера, то придумайте его сами. Ќомер об€зателен.'
 +' ѕомните, в школе не может быть двух кабинетов с одинаковыми номерами. '
 +'”берите галочку дл€ мастерской и спортзала (если хотите).';
 HelpDuplicateNum='Ётот номер уже принадлежит кабинету "%s". ¬ам придЄтс€ '
 +'воспользоватьс€ другим номером.';
implementation

{$R *.dfm}

{ TKabinetDlg }

function TKabinetDlg.Execute(Kab:TKabinet):boolean;
Var
 i:integer;
begin
 if Assigned(FOnGetList) then begin
   FOnGetList(self,todKabinet,false,sts);
   sts.Sort;
 end;
 if Kab=nil then Begin
  Caption:='—оздание нового кабинета';
  KabName.Text:='';
  KabNum.text:='0';
  chkView.Checked:=true;
 End else Begin
  For i:=0 to sts.Count-1 do
   if sts.Objects[i]=Kab then Begin
    sts.Delete(i);
    break;
   End;
  Caption:='»зменение данных кабинета';
  KabName.Text:=Kab.Name;
  KabNum.text:=IntToStr(Kab.Num);
  chkView.Checked:=Kab.ShowNum;
 End;
 lbHelp.Caption:=HelpKabinetDlg;
 IsOldText:=false;
 result:=inherited Execute;
 if not Result then Exit;
 FKabinet.Name:=KabName.text;
 FKabinet.Num:=StrToInt(KabNum.text);
 FKabinet.ShowNum:=chkView.checked;
end;

constructor TKabinetDlg.Create;
begin
 inherited Create(AOwner);
 FKabinet:=TKabinet.Create;
 sts:=TStringList.Create;
end;

destructor TKabinetDlg.Destroy;
begin
 FKabinet.Free;
 sts.Free;
 inherited;
end;

procedure TKabinetDlg.FormActivate(Sender: TObject);
begin
 inherited;
 KabName.SetFocus;
end;

function TKabinetDlg.GetKabinet: TKabinet;
begin
 result:=nil;
 if ModalResult<>mrOk then Exit;
 result:=FKabinet;
end;

procedure TKabinetDlg.KabNumChange(Sender: TObject);
Var
 i,num,x:integer;
begin
 inherited;
 if IsOldText then Exit;
 IsOldText:=true;
 With KabNum do Begin
  if Text='' then Begin
   Text:='0';
   SelStart:=1;
  End;
  Num:=StrToInt(Text);
  if Text<>IntToStr(Num) then Begin
   x:=SelStart;
   Text:=IntToStr(Num);
   SelStart:=x;
  End;
  IsOldText:=false;
  For i:=0 to sts.Count-1 do
   if TKabinet(sts.Objects[i]).Num=Num then Begin
    Font.Color:=clRed;
    lbHelp.Caption:=format(HelpDuplicateNum,[sts[i]]);
    exit;
   End;
  Font.Color:=clBlack;
  lbHelp.Caption:=HelpKabinetDlg;
 End;
end;

procedure TKabinetDlg.KabNumKeyPress(Sender: TObject; var Key: Char);
begin
 inherited;
 if key in ['0'..'9',#8] then Exit;
 Key:=#0;
end;

procedure TKabinetDlg.KabNumKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
Var
 sc:Word;
 num:integer;
begin
 inherited;
 sc:=ShortCut(Key,Shift);
 num:=0;
 if sc in [vk_up,vk_down] then num:=StrToInt(KabNum.Text);
 Case sc of
  vk_Up: KabNum.Text:=IntToStr(Num+1);
  vk_Down: if Num>0 then KabNum.Text:=IntToStr(Num-1);
 End;
 if sc in [vk_up,vk_down] then KabNum.SelStart:=Length(KabNum.Text);
end;

procedure TKabinetDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 inherited;
 if ModalResult=mrCancel then Exit;
 if KabNum.Font.Color<>clRed then Exit;
 Action:=caNone;
 KabNum.SetFocus;
end;

end.
