unit TableUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ActnList, ToolWin, ComCtrls, ImgList,
  Menus, Grids, ExtCtrls, SbjCmd, SbjSrc, SbjLst, SbjManager,
  SbjGrd, XPMan;

type
  TTableForm = class (TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    C1: TMenuItem;
    C2: TMenuItem;
    N5: TMenuItem;
    N14: TMenuItem;
    Panel1: TPanel;
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    ToolBar3: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolBar4: TToolBar;
    ToolButton19: TToolButton;
    ToolButton20: TToolButton;
    ToolButton21: TToolButton;
    Label4: TLabel;
    ToolButton22: TToolButton;
    N15: TMenuItem;
    SubjCmds1: TSubjCmds;
    SubjCmds1ImLst: TSubjImageList;
    SubjCmds1_CM_Klass: TAction;
    SubjCmds1_CM_Teacher: TAction;
    SubjCmds1_CM_Kabinet: TAction;
    SubjCmds1_TC_Subject: TAction;
    SubjCmds1_TC_Teacher: TAction;
    SubjCmds1_TC_Kabinet: TAction;
    SubjCmds1_VM_Subjects: TAction;
    SubjCmds1_VM_Columns: TAction;
    SubjCmds1_VM_WeekDays: TAction;
    SubjCmds1_VM_Lessons: TAction;
    SubjCmds1_VW_FullView: TAction;
    SubjCmds1_VW_TextAct: TAction;
    SubjCmds1_VW_SanPIN: TAction;
    SubjCmds1_LockLess: TAction;
    SubjCmds1_LockDay: TAction;
    SS1: TSubjSource;
    SubjList1: TSubjList;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    SubjManager1: TSubjManager;
    SubjGrid1: TSubjGrid;
    XPManifest1: TXPManifest;
    procedure C1Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
  public
  end;

var
  TableForm: TTableForm;

implementation

uses SbjColl, publ, Servis;

{$R *.dfm}

procedure TTableForm.C1Click(Sender: TObject);
begin
  SS1.Save;
end;

procedure TTableForm.N14Click(Sender: TObject);
Var
  op: TOpenDialog;
begin
  op := TOpenDialog.Create(nil);
  op.InitialDir := ProgramPath;
  With op do Begin
    op.Filter := 'Расписания|*.rsp';
    if Execute then
      SS1.Load(FileName);
    Free;
  End;
end;

procedure TTableForm.N5Click(Sender: TObject);
begin
  ServisDlg.ShowModal;
end;

procedure TTableForm.FormCreate(Sender: TObject);
begin
  ss1.FileName := ProgramPath + 'default.rsp';
  ss1.LoadTxt;
end;

procedure TTableForm.FormDestroy(Sender: TObject);
begin
//  ss1.Save;
  ss1.SaveTxt;
end;

end.

