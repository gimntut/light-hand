unit sbjTeachDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, MyDialog, StdCtrls, ExtCtrls, SbjKernel, SbjResource, Menus;

type
  TTeacherDlg = class (TDialog)
    le1: TLabeledEdit;
    le2: TLabeledEdit;
    le3: TLabeledEdit;
    Panel3: TPanel;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Panel5: TPanel;
    Panel6: TPanel;
    Label2: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure ComboBox1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure le1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure le1KeyPress(Sender: TObject; var Key: Char);
    procedure le1Change(Sender: TObject);
  private
    FTeacher: TTeacher;
    FOnChange: TChangeEvent;
    FOnDelete: TChangeEvent;
    FOnGetList: TGetListEvent;
    FOnInsert: TInsertEvent;
    IsEdit: boolean;
    function GetTeacher: TTeacher;
    procedure TodGetList(TypeOfData: TTypeOfData; short: boolean; Strings: TStrings);
    procedure TodChange(TypeOfData: TTypeOfData; Index: Integer);
    procedure TodInsert(TypeOfData: TTypeOfData);
    procedure TodDelete(TypeOfData: TTypeOfData; Index: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute(Teach: TTeacher): boolean;
    property Teacher: TTeacher read GetTeacher;
    property OnInsert: TInsertEvent read FOnInsert write FOnInsert;
    property OnChange: TChangeEvent read FOnChange write FOnChange;
    property OnDelete: TChangeEvent read FOnDelete write FOnDelete;
    property OnGetList: TGetListEvent read FOnGetList write FOnGetList;
  end;

var
  TeacherDlg: TTeacherDlg;

implementation

{$R *.dfm}

{ TTeacherDlg }

function TTeacherDlg.Execute(Teach: TTeacher): boolean;
var
  sts: TStringList;
  i, x: integer;
begin
  todGetList(todKabinet, false, ComboBox1.Items);
  if Teach = nil then begin
    Caption := 'Создание нового преподавателя';
    le1.Text := '';
    le2.Text := '';
    le3.Text := '';
    if ComboBox1.Items.Count > 0 then
      ComboBox1.ItemIndex := 0;
  end
  else begin
    Caption := 'Изменение данных преподавателя';
    sts := TStringList.Create;
    sts.CommaText := Teach.Name;
    x := sts.Count;
    if x > 0 then
      le1.Text := sts[0]
    else
      le1.Text := '';
    if x > 1 then
      le2.Text := sts[1]
    else
      le2.Text := '';
    if x > 2 then
      le3.Text := sts[2]
    else
      le3.Text := '';
    sts.Free;
    x := Teach.KabNum;
    with ComboBox1 do
      for i := 0 to Items.Count - 1 do
        if items.objects[i] <> nil then
          if tKabinet(items.objects[i]).Num = x then begin
            ItemIndex := i;
            break;
          end;
  end;
  ActiveControl := le1;
  result := inherited Execute;
  if not result then
    Exit;
  Teacher.Name := Format('%s %s %s', [le1.Text, le2.Text, le3.Text]);
  with ComboBox1 do
    if ItemIndex = -1 then
      Teacher.KabNum := -1
    else
      Teacher.KabNum := TKabinet(Items.Objects[ItemIndex]).Num;
end;

constructor TTeacherDlg.Create(AOwner: TComponent);
begin
  inherited;
  FTeacher := TTeacher.Create;
  IsEdit := false;
end;

destructor TTeacherDlg.Destroy;
begin
  FTeacher.Free;
  inherited;
end;

procedure TTeacherDlg.FormActivate(Sender: TObject);
begin
  inherited;
  le1.SetFocus;
end;

procedure TTeacherDlg.ComboBox1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  sc: word;
  n, x: integer;
  sts: TStringList;
  I: Integer;
begin
  inherited;
  x := -1;
  with ComboBox1 do
    if itemindex <> -1 then
      if items.objects[itemindex] <> nil then
        x := TKabinet(items.objects[itemindex]).ItemIndex;
  sc := ShortCut(Key, Shift);
  case sc of
    VK_DELETE:
    begin
      todDelete(todKabinet, x);
      todGetList(todKabinet, false, ComboBox1.Items);
      x := 0;
    end;
    VK_INSERT:
    begin
      todInsert(todKabinet);
      n := ComboBox1.Items.Count;
      x := ComboBox1.ItemIndex;
      sts := TStringList.Create;
      todGetList(todKabinet, false, ComboBox1.Items);
      if n <> ComboBox1.Items.Count then
        for I := 0 to sts.Count - 1 do begin
          x := I;
          if sts[I]<>ComboBox1.Items[I] then break;
        end;
    end;
    VK_F2:
    begin
      todChange(todKabinet, x);
      todGetList(todKabinet, false, ComboBox1.Items);
    end;
  end;
  if sc in [vk_Delete, vk_Insert, vk_f2] then
    ComboBox1.ItemIndex := x;
end;

function TTeacherDlg.GetTeacher: TTeacher;
begin
  result := nil;
  if ModalResult <> mrOk then
    Exit;
  result := FTeacher;
end;

procedure TTeacherDlg.TodChange(TypeOfData: TTypeOfData; Index: Integer);
begin
  if Assigned(FOnChange) then
    FOnChange(self, TypeOfData, Index);
end;

procedure TTeacherDlg.TodDelete(TypeOfData: TTypeOfData; Index: Integer);
begin
  if Assigned(FOnDelete) then
    FOnDelete(self, TypeOfData, Index);
end;

procedure TTeacherDlg.TodGetList(TypeOfData: TTypeOfData; short: boolean; Strings: TStrings);
var
  sts: TStringList;
begin
  if Assigned(FOnGetList) then begin
    sts := TStringList.Create;
    FOnGetList(self, TypeOfData, short, sts);
    sts.Sort;
    Strings.Assign(sts);
    sts.Free;
  end;
end;

procedure TTeacherDlg.TodInsert(TypeOfData: TTypeOfData);
begin
  if Assigned(FOnInsert) then
    FOnInsert(self, TypeOfData);
end;

procedure TTeacherDlg.le1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if ShortCut(Key, Shift) = vk_Space then
    ActiveControl := FindNextControl(ActiveControl, true, true, false);
end;

procedure TTeacherDlg.le1KeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if Key = ' ' then
    Key := #0;
  if Key = '.' then
    ActiveControl := FindNextControl(ActiveControl, true, true, false);
end;

procedure TTeacherDlg.le1Change(Sender: TObject);
var
  s1, s2: string;
  x: integer;
  Edit: TEdit;
begin
  inherited;
  if IsEdit then
    Exit;
  IsEdit := true;
  Edit := TEdit(Sender);
  s1 := Edit.Text;
  if s1 = '' then
    s2 := ''
  else
    s2 := AnsiUpperCase(s1[1]) + AnsiLowerCase(Copy(s1, 2, Length(s1) - 1));
  x := Edit.SelStart;
  if s1 <> s2 then
    Edit.Text := s2;
  Edit.SelStart := x;
  IsEdit := false;
end;

end.
