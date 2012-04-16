unit SbjManager;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uPagePanel, StdCtrls, ExtCtrls, Grids, MyLists, SbjKernel, SbjSrc, SbjResource;

type
 TManageDlg = class(TForm)
  ppAll: TPagePanel;
  spTime: TSheetPanel;
  Panel1: TPanel;
  Label1: TLabel;
  Panel2: TPanel;
  Panel3: TPanel;
  Button1: TButton;
  Button2: TButton;
  ListBox1: TListBox;
  Label2: TLabel;
  Label3: TLabel;
  spTeacher: TSheetPanel;
  Panel4: TPanel;
  Panel5: TPanel;
  Label4: TLabel;
  ComboBox1: TComboBox;
  Panel6: TPanel;
  Panel7: TPanel;
  Panel8: TPanel;
  Label5: TLabel;
  PagePanel3: TPagePanel;
  spEmpty: TSheetPanel;
  spChangeTeacher: TSheetPanel;
  Panel9: TPanel;
  SuperGrid1: TSuperGrid;
  Panel11: TPanel;
  Panel12: TPanel;
  spKabinet: TSheetPanel;
  Panel10: TPanel;
  Panel13: TPanel;
  Panel14: TPanel;
  Label6: TLabel;
  PagePanel2: TPagePanel;
  SheetPanel4: TSheetPanel;
  Panel15: TPanel;
  SheetPanel5: TSheetPanel;
  Panel16: TPanel;
  SuperGrid2: TSuperGrid;
  Panel17: TPanel;
  Panel18: TPanel;
  Label7: TLabel;
  ComboBox2: TComboBox;
 private
  FState: TSubjState;
  FSubject: TSubject;
  FSource: TSubjSource;
  procedure SetSource(const Value: TSubjSource);
  procedure SetState(const Value: TSubjState);
  procedure SetSubject(const Value: TSubject);
 protected
  property Subject:TSubject read FSubject write SetSubject;
  property Source:TSubjSource read FSource write SetSource;
  property State:TSubjState read FState write SetState;
 public

 end;
 ////////////////////// x //////////////////////
 TSubjManager=Class(TSubjCustomManager)
 public
  function Run: Boolean; override;
 End;
 ////////////////////// x //////////////////////
resourcestring
 stTimeOut='Для того, чтобы не было превышения отведёного предмету времени, необходимо удалить один из уже поставленных предметов';
 stKabinets='Вы хотите поставить предмет %s. Но кабинет(ы) этого предмета уже занят(ы) предметом %s. Выберите один из вариантов действий.';
 stTeachers='Вы хотите поставить предмет %s. Но преподаватель(и) этого предмета уже занят(ы) предметом %s. Выберите один из вариантов действий.';
 stKlass='Вы хотите поставить предмет %s. Но в классе для этого предмета уже занимаются.';
implementation

{$R *.dfm}

{ TSubjManager }

function TSubjManager.Run: Boolean;
Var
 ManDlg:TManageDlg;
begin
 result:=true;
 ManDlg:=TManageDlg.Create(nil);
 
 ManDlg.ShowModal;
 ManDlg.Free;
end;

{ TManageDlg }

procedure TManageDlg.SetSource(const Value: TSubjSource);
begin
  FSource := Value;
end;

procedure TManageDlg.SetState(const Value: TSubjState);
begin
  FState := Value;
end;

procedure TManageDlg.SetSubject(const Value: TSubject);
begin
  FSubject := Value;
end;

end.

