unit RegMyLib;

interface

Uses Classes, DesignIntf, DesignEditors, Graphics, Forms, CoolBtn,
  uStorage, ViewLog;

procedure Register;

Type
 ////////////////////// x //////////////////////
  TPagePanelEdit = class (TDefaultEditor)
  private
  public
    function GetVerb(Index: Integer): String; override;
    function GetVerbCount: Integer; override;
    procedure ExecuteVerb(Index: Integer); override;
  End;
 ////////////////////// x //////////////////////
  TCoolBtnEdit = class (TDefaultEditor)
  protected
    procedure EditProperty(const Prop: IProperty; var Continue: Boolean); override;
  public
  End;
 ////////////////////// x //////////////////////
  TLinkerFormEditor = class (TComponentProperty)
  private
    function CompName(Comp: TComponent): string;
  //procedure AddToList(Const s:string);
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: String; override;
    function FormName(Form: TForm): string;
    procedure GetSubComp(Comp: TComponent; proc: TGetStrProc);
    procedure GetUpComp(Comp: TComponent; proc: TGetStrProc);
    procedure GetValues(Proc: TGetStrProc); override;
    procedure SetValue(const Value: String); override;
    constructor Create(const ADesigner: IDesigner; APropCount: Integer); override;
  End;

implementation

{$R publ.res}
{$R Artifact.res}
{$R ComboEditX.res}
{$R CoolBtn.res}
{$R Messager.res}
Uses Artifact, {ComboEditX,} MyLists, num, PanelContainer, publ,
  TypInfo, SysUtils, Dialogs, PublDB, PublGraph,
  Contnrs, Controls, uPagePanel, gnProgress;

procedure Register;
begin
 { Components }
  RegisterComponents('Nail', [TPanelContainer, TNumEdit, TRusMask,
    tListEdit, TNewGrid, TSuperGrid,{TComboEditX,}TCoolBtn, TCoolStyle,
    TCoolPanel, TgnProgressBar{,TEmbeddedWB}]);
  RegisterComponents('Nail', [TArtifact]);
 //RegisterComponents('Nail', [TMessager,TStorage]);
  RegisterComponents('Nail', [TPubl, TPublDB, TPublGraph, TViewLog]);
  RegisterComponentEditor(TCoolBtn, TCoolBtnEdit);
  RegisterCustomModule(TStorageForm, TCustomModule);
 //RegisterPropertyEditor(TypeInfo(TComponent),TLinker,'Form',TLinkerFormEditor);
 //RegisterPropertyEditor(TypeInfo(String),TActiveTreeView,'Caption',nil);
  RegisterComponents('Nail', [TPagePanel]);
  RegisterNoIcon([TSheetPanel]);
  RegisterClass(TSheetPanel);
  RegisterComponentEditor(TPagePanel, TPagePanelEdit);
  RegisterComponentEditor(TSheetPanel, TPagePanelEdit);
end;

{ TCoolBtnEdit }

procedure TCoolBtnEdit.EditProperty(const Prop: IProperty;
  var Continue: Boolean);
Var
  s: string;
begin
  if Component is TCoolBtn then
    if TCoolBtn(Component).aClick then
      s := 'OnClick'
    else
      s := 'OnChangeActive';
  if SameText(Prop.GetName, s) then begin
    Prop.Edit;
    Continue := False;
  end;
end;

{ TLinkerPropertyEditor }

function TLinkerFormEditor.CompName(Comp: TComponent): string;
begin
  With Comp do
    result := Name + ':' + ClassParent.ClassName;
end;

constructor TLinkerFormEditor.Create(const ADesigner: IDesigner;
  APropCount: Integer);
begin
  inherited;
end;

function TLinkerFormEditor.FormName(Form: TForm): string;
begin
  With Form do
    result := Name + '(' + Caption + ',' + ClassParent.ClassName + ')';
end;

function TLinkerFormEditor.GetAttributes: TPropertyAttributes;
begin
  Result := inherited GetAttributes + [paValueList, paReadOnly];
end;

procedure TLinkerFormEditor.GetSubComp(Comp: TComponent; proc: TGetStrProc);
Var
  i, c: integer;
begin
  if comp = nil then
    Exit;
  ShowMessage(Comp.Name);
  c := Comp.ComponentCount;
  proc(CompName(Comp));
  For i := 0 to c - 1 do
    GetSubComp(Comp.Components[i], proc);
end;

procedure TLinkerFormEditor.GetUpComp(Comp: TComponent; proc: TGetStrProc);
begin
  While Comp <> nil do Begin
    Proc(CompName(Comp));
    ShowMessage(CompName(Comp));
    Comp := Comp.Owner;
  End;
end;

function TLinkerFormEditor.GetValue: String;
begin
  result := '';
 //result:=inherited GetValue;
end;

procedure TLinkerFormEditor.GetValues(Proc: TGetStrProc);
begin
  inherited;
 //GetSubComp(Designer,proc);
end;

procedure TLinkerFormEditor.SetValue(const Value: String);
begin
  inherited;
end;

{ TPagePanelEdit }
procedure TPagePanelEdit.ExecuteVerb(Index: Integer);
Var
  SheetPanel: TSheetPanel;
  pp: TPagePanel;
begin
  Case Index of
    0:
    Begin
      if Component is TPagePanel then
        pp := TPagePanel(Component)
      else
      if Component is TSheetPanel then
        pp := TSheetPanel(Component).PagePanel
      else
        Exit;
      SheetPanel := TSheetPanel.Create(GetParentForm(pp));
      SheetPanel.Name := Designer.UniqueName('SheetPanel');
      SheetPanel.PagePanel := pp;
      pp.ActivePage := SheetPanel;
      Designer.Modified;
    End;
  End;
end;

function TPagePanelEdit.GetVerb(Index: Integer): String;
begin
  Case Index of
    0:
      result := 'Добавить лист';
  End;
end;

function TPagePanelEdit.GetVerbCount: Integer;
begin
  result := 1;
end;

initialization
 //LogFileSet('c:\Reg.txt');
end.

