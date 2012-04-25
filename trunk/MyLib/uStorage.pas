unit uStorage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, publ;

type
  TEditMode=(emDisabled,emEnabled,emSave,emCancel);
  TTabEvent=procedure(OldControl,NewControl:TWinControl) of Object;
  TPanelEvent=procedure(Sender:TObject; APanel:TPanel) of Object;
  TChangeEMEvent=procedure(Sender:TObject; Old:TEditMode; var New:TEditMode) of Object;
  TStorageForm=class;
  //TLinkUpEVent=procedure(Sender:TObject; var ALinkUp:TStorageForm) of object;
  TLinkUpEVent=procedure(Sender:TObject; var ALinkUp:TForm) of object;
  TStorageForm = class(TForm)
  private
   FAtNewFocus: TNotifyEvent;
   FAtTabKey: TTabEvent;
   //FIsEditMode: boolean;
   FOfficier: Word;
   FAtEditMode: TBoolVarEvent;
   FAtCancelSave: TNotifyEvent;
   FAtOpenPanel: TNotifyEvent;
   FAtClosePanel: TNotifyEvent;
   FAtGetMenu: TIntEvent;
   FAtCloseMenu: TPanelEvent;
   FAtOpenMenu: TPanelEvent;
   FAtGetPanel: TIntEvent;
   FAtOfficier: TIntEvent;
   FAtChangeEditMode: TChangeEMEvent;
   FSaveMode: boolean;
   FOnChangeEditMode: TNotifyEvent;
   FAtSave: TBoolVarEvent;
   FAtReturn: TNotifyEvent;
   FOnReturn: TNotifyEvent;
   FEditMode: TEditMode;
   FAtGetLinkUp: TLinkUpEvent;
   FOnGod: TNotifyEvent;
   FAtDisableEdit: TNotifyEvent;
   FAtEnableEdit: TNotifyEvent;
   //procedure SetIsEditMode(const Now:boolean; const Value: boolean=false);
   function GetIam: TStorageForm;
   procedure SetEditMode(const Value: TEditMode);
   procedure SetOfficier(const Value: Word);
   function GetIsEditMode: boolean;
   function GetLinkUp: TStorageForm;
  public
   function EnableEditMode:Boolean;
   function Save:boolean;
   procedure CancelSave;
   procedure CloseMenu(Panel:TPanel);
   procedure ClosePanel;
   procedure DoChanging(var EdMd:TEditMode);
   procedure DoDisabled;
   procedure DoEnabled;
   procedure GetMenu(ind:integer=0);
   procedure GetPanel(ind:integer=0);
   procedure OpenMenu(Panel:TPanel);
   procedure OpenPanel;
   procedure Return(s:string);
   ////
   property EditMode:TEditMode read FEditMode write SetEditMode;
   property IsEditMode:boolean read GetIsEditMode;
   {property IsEditMode[Now:boolean]:boolean read GetIsEditMode write SetIsEditMode;{}
   property LinkUp:TStorageForm read GetLinkUp;
   property Officier:Word read FOfficier write SetOfficier;
   property OnChangeEditMode:TNotifyEvent read FOnChangeEditMode write FOnChangeEditMode;
   property OnReturn:TNotifyEvent read FOnReturn write FOnReturn;
   property SaveMode:boolean read FSaveMode write FSaveMode;
   ////
   property Iam:TStorageForm read GetIam;
  published
   property AtNewFocus:TNotifyEvent read FAtNewFocus write FAtNewFocus;
   property AtTabKey:TTabEvent read FAtTabKey write FAtTabKey;
   property AtEditMode:TBoolVarEvent read FAtEditMode write FAtEditMode;
   property AtSave:TBoolVarEvent read FAtSave write FAtSave;
   property AtCancelSave:TNotifyEvent read FAtCancelSave write FAtCancelSave;
   property AtOpenPanel:TNotifyEvent read FAtOpenPanel write FAtOpenPanel;
   property AtClosePanel:TNotifyEvent read FAtClosePanel write FAtClosePanel;
   property AtGetPanel:TIntEvent read FAtGetPanel write FAtGetPanel;
   property AtOpenMenu:TPanelEvent read FAtOpenMenu write FAtOpenMenu;
   property AtCloseMenu:TPanelEvent read FAtCloseMenu write FAtCloseMenu;
   property AtGetMenu:TIntEvent read FAtGetMenu write FAtGetMenu;
   property AtOfficier:TIntEvent read FAtOfficier write FAtOfficier;
   property AtChangeEditMode:TChangeEMEvent read FAtChangeEditMode write FAtChangeEditMode;
   property AtReturn:TNotifyEvent read FAtReturn write FAtReturn;
   property AtGetLinkUp:TLinkUpEvent read FAtGetLinkUp write FAtGetLinkUp;
   property AtDisableEdit:TNotifyEvent read FAtDisableEdit write FAtDisableEdit;
   property AtEnableEdit:TNotifyEvent read FAtEnableEdit write FAtEnableEdit;
   property OnGod:TNotifyEvent read FOnGod write FOnGod;
  end;

  TStFormClass=Class of TStorageForm;

implementation

{$R *.dfm}                                       

{ TForm7 }

procedure TStorageForm.OpenPanel;
begin
 if Assigned(FAtOpenPanel) then FAtOpenPanel(Self);
end;

procedure TStorageForm.ClosePanel;
begin
 if Assigned(FAtClosePanel) then FAtClosePanel(Self);
end;

procedure TStorageForm.SetOfficier(const Value: Word);
begin
 if Assigned(FAtOfficier) then FAtOfficier(Self,Value);
end;

procedure TStorageForm.CloseMenu;
begin
 if Assigned(FAtCloseMenu) then FAtCloseMenu(Self,Panel);
end;

procedure TStorageForm.OpenMenu;
begin
 if Assigned(FAtOpenMenu) then FAtOpenMenu(Self,Panel);
end;

function TStorageForm.GetIam: TStorageForm;
begin
 result:=self;
end;

procedure TStorageForm.GetMenu(ind: integer);
begin
 if Assigned(FAtGetMenu) then FAtGetMenu(Self,ind);
end;

procedure TStorageForm.GetPanel(ind: integer);
begin
 if Assigned(FAtGetPanel) then FAtGetPanel(Self,ind);
end;

procedure TStorageForm.CancelSave;
begin
 if Assigned(FAtCancelSave) then FAtCancelSave(Self);
end;

function TStorageForm.EnableEditMode:Boolean;
begin
 result:=Assigned(FAtEditMode);
 if Result then FAtEditMode(Self,result);
end;

function TStorageForm.Save:boolean;
begin
 result:=true;
 if Assigned(FAtSave) then FAtSave(Self,result);
end;

procedure TStorageForm.DoChanging(var EdMd:TEditMode);
begin
 Case EdMd of
  emEnabled: if not EnableEditMode then begin
   EdMd:=emDisabled;
   Exit;
  end else DoEnabled;
  emSave: if Save then EdMd:=emDisabled else EdMd:=emEnabled;
  emCancel: begin
   CancelSave;
   EdMd:=emDisabled;
  end;
  else begin
   DoDisabled;
   Exit;
  end;
 end;
 if EdMd=emDisabled then Return('');
end;

{function TStorageForm.GetIsEditMode(Now: boolean): boolean;
begin
 Result:=FIsEditMode;
end;}

{procedure TStorageForm.SetIsEditMode(Now: boolean; const Value: boolean);
var
 us:boolean;
 em:TEditMode;
begin
 us:=Value;
 if Assigned(FAtChangeEditMode) then FAtChangeEditMode(Self,FIsEditMode,us,Now);
 if Now then DoChanging(us);
 FIsEditMode := us;
 if Assigned(FOnChangeEditMode) then FOnChangeEditMode(Self);
 if not us then Return;
end;}

procedure TStorageForm.Return;
begin
 DoDisabled;
 if Assigned(FAtReturn) then FAtReturn(self);
 if Assigned(FOnReturn) then FOnReturn(self);
end;

procedure TStorageForm.SetEditMode(const Value: TEditMode);
var
 em1,em2:TEditMode;
begin
 em1:=Value;
 em2:=em1;
 if Value in [emSave,emCancel] then em2:=emDisabled;
 if Assigned(FAtChangeEditMode) then FAtChangeEditMode(Self,FEditMode,em2);
 if em2=emEnabled then em1:=em2;
 DoChanging(em1);
 FEditMode := em1;
 if Assigned(FOnChangeEditMode) then FOnChangeEditMode(Self);
end;


function TStorageForm.GetIsEditMode: boolean;
begin
 if (LinkUp=nil) or (LinkUp=self)
  then Result:=FEditMode=emEnabled
  else Result:=LinkUp.IsEditMode;
end;

function TStorageForm.GetLinkUp: TStorageForm;
begin
 result:=self;
 if Assigned(FAtGetLinkUp) then FAtGetLinkUp(self,TForm(result));
end;

procedure TStorageForm.DoDisabled;
begin
 if Assigned(FAtDisableEdit) then FAtDisableEdit(self);
end;

procedure TStorageForm.DoEnabled;
begin
 if Assigned(FAtEnableEdit) then FAtEnableEdit(self);
end;

end.
