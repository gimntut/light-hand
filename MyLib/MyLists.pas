unit MyLists;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, StdCtrls, Menus, publ,
  Grids, ExtCtrls, Graphics, Forms, DateUtils;
type
  tChangeIndexEvent=Procedure(Sender:TObject; Index:integer; Data:TObject) of Object;
  tDeleteEvent=Procedure(Sender: TObject; Index: integer) of Object;
  tListEdit = class(TEdit)
  private
   Design:boolean;
   EditDown:TEdit;
   EditUp:TEdit;
   FChoiceColor: TColor;
   FChoiceTextColor: TColor;
   FData: TObject;
   FiltredList:TStringList;
   FItemIndex: integer;
   FItems: TStringList;
   FItems2: TStringList;
   FonChangeIndex: tChangeIndexEvent;
   IAmWorking:boolean;
   Num:integer;
   Text2:String;
   ViewEnd:boolean;
   function GetIam: TListEdit;
   function GetItems: TStrings;
   procedure _Enter(Sender:TObject);
   procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
   procedure SetChoiceColor(const Value: TColor);
   procedure SetChoiceTextColor(const Value: TColor);
   procedure SetItems(const Value: TStrings);
   procedure ShowString(Num:integer);
  protected
   procedure Change; override;
   procedure DoEnter; override;
   procedure DoExit; override;
   procedure DoIt;
   procedure KeyDown(var Key: Word; Shift: TShiftState); override;
   procedure KeyUp(var Key: Word; Shift: TShiftState); override;
   procedure SetData(index:integer; AData:TObject);
   procedure SetParent(AParent: TWinControl); override;
  public
   Constructor Create(AOwner:TComponent); override;
   Destructor Destroy; override;
   procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
   property Data:TObject read FData;
   property Iam:TListEdit read GetIam;
  published
   property ChoiceColor:TColor read FChoiceColor write SetChoiceColor;
   property ChoiceTextColor:TColor read FChoiceTextColor write SetChoiceTextColor;
   property ItemIndex:integer read FItemIndex;
   property Items:TStrings read GetItems write SetItems;
   property OnChangeIndex:tChangeIndexEvent read FOnChangeIndex write FOnChangeIndex;
  end;
  //////////////////////////////////////////////////
  TNewGrid=Class;
  TChangeCellEvent=procedure (Sender:TObject;ACol,ARow:integer) of object;
  TEditEvent=procedure(Sender:TNewGrid; ARow:integer;Var CanEdit:boolean) of object;

  TSubStringList=Class(TStrings)
  private
   Control: TControl;
   Link: TStrings;
   function GetIam: TSubStringList;
  protected
   function Get(Index: Integer): String; override;
   function GetCount: Integer; override;
   function GetObject(Index: Integer): TObject; override;
   function IsGood:boolean;
   procedure Put(Index: Integer; const S: String); override;
  public
   Constructor Create(AControl:TControl; ALink:TStrings);
   function AddObject(const S: String; AObject: TObject): Integer; override;
   procedure Assign(Source: TPersistent); override;
   procedure Clear; override;
   procedure Delete(Index: Integer); override;
   procedure Insert(Index: Integer; const S: string); override;
   property Iam:TSubStringList read GetIam;
  End;

  TSubListBox=Class(TListBox)
  private
   IsClick:boolean;
   IsSend:boolean;
   function GetIam: TSubListBox;
  protected
   function GetItemIndex: integer; override;
   procedure Click; override;
   procedure CMCancelMode(var Message: TCMCancelMode); message CM_CANCELMODE;
   procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
   procedure CNKeydown(var Message: TWMKeyDown); message CN_KEYDOWN;
   procedure SetItemIndex(const Value: Integer); override;
  public
   constructor Create(AOwner: TComponent); override;
   property Iam:TSubListBox read GetIam;
  published
   property ItemIndex:integer read GetItemIndex write SetItemIndex;
  End;

  TDataTyp=(ctString,ctInteger,ctFloat,ctDate,ctTime,ctSmallInt); // ct - Cell's Type

  TNGColumn=Class(TCollectionItem)
  private
   FCaption: String;
   FHint: String;
   FInfo: String;
   FOnValidResult: TBoolEvent;
   function GetGrid: TNewGrid;
   function GetIam: TNGColumn;
   function GetStrings: TStrings;
   procedure SetHint(const Value: String);
  private
   FDataType: TDataTyp;
   FOnChangeWidth: TNotifyEvent;
   FOnEdit: TEditEvent;
   FReadOnly: boolean;
   FRelativeWidth: integer;
   FStrings: TNumStrList;
   function DoEdit(ARow:integer):boolean;
   function GetReadOnly: boolean;
   procedure SetCaption(const Value: String);
   procedure SetDataType(const Value: TDataTyp);
   procedure SetReadOnly(const Value: boolean);
   procedure SetRelativeWidth(const Value: integer);
   procedure SetStrings(const Value: TStrings);
   procedure StringChange(Sender:TObject);
   property Grid:TNewGrid read GetGrid;
  protected
   function GetDisplayName: String; override;
   procedure ChangeWidth;
  public
   Constructor Create(Collection: TCollection); override;
   Destructor Destroy; override;
   property OnChangeWidth:TNotifyEvent read FOnChangeWidth write FOnChangeWidth;
   property Iam:TNGColumn read GetIam;
  published
   property Caption:String read FCaption write SetCaption stored true;
   property DataType:TDataTyp read FDataType write SetDataType;
   property Hint:String read FHint write SetHint;
   property Info:String read FInfo write fInfo;
   property OnEdit:TEditEvent read FOnEdit write FOnEdit;
   property OnValidResult:TBoolEvent read FOnValidResult write FOnValidResult;
   property ReadOnly:boolean read GetReadOnly write SetReadOnly;
   property RelativeWidth:integer read FRelativeWidth write SetRelativeWidth;
   property Strings:TStrings read GetStrings write SetStrings;
  End;

  TNGCollection=Class(TCollection)
  private
   Grid:TNewGrid;
   function GetIam: TNGCollection;
   function GetItems(x: integer): TNGColumn;
   procedure SetItems(x: integer; const Value: TNGColumn);
  protected
   function GetOwner: TPersistent; override;
   procedure Update(Item: TCollectionItem); override;
  public
   Constructor Create(AGrid:TNewGrid);
   function Add:TNGColumn;
   property Iam:TNGCollection read GetIam;
   property Items[x:integer]:TNGColumn read GetItems write SetItems; default;
  End;

  TNGEditor=Class(TInplaceEdit)
  private
   FTextColor:TColor;
   function GetIam: TNGEditor;
  protected
   procedure Change; override;
   procedure CNKeydown(var Message: TWMKey); message CN_KEYDOWN;
   procedure KeyDown(var Key: Word; Shift: TShiftState); override;
   procedure KeyPress(var Key: Char); override;
   procedure KeyUp(var Key: Word; Shift: TShiftState); override;
  public
   property Iam:TNGEditor read GetIam;
   constructor Create(AOwner: TComponent); override;
  End;

  TValidateEvent=procedure(Sender:TObject; ACol,ARow:integer;
   S:string; Var Value:boolean) of object;

  TNewColumnEvent=procedure(Sender:TObject; Column:TNGColumn;
   index:integer) of object;

  TNewGrid=Class(TStringGrid)
  private
   btCol,btRow:integer;
   DownBtn:tPanel;
   FBeMark: boolean;
   //FColumns:array of TNGColumn;
   FColumns:TNGCollection;
   FHideSelection: boolean;
   FHint: String;
   FItemIndex:array of array of integer;
   FListColor: TColor;
   FListLinesCount: Integer;
   FOldText:String;
   FOnBeforeChangeCell: TChangeCellEvent;
   FOnChangeCell: TChangeCellEvent;
   FOnlyView: boolean;
   FOnValidate: TValidateEvent;
   FormPreview:boolean;
   IsNew:boolean;
   List:TListBox;
   OldCell:String;
   OldData:TObject;
   function GetCellState(ACol, ARow: Integer): TGridDrawState;
   function GetColCount: Integer;
   function GetComboCol(x: integer): TStrings;
   function GetDefaultRowHeight: integer;
   function GetDroppedDown: boolean;
   function GetHint: String;
   function GetHnt: String;
   function GetIam: TNewGrid;
   function GetItemIndex(ACol, ARow: integer): integer;
   function GetRowHeights(x: integer): integer;
   function GetValues(ACol, ARow: integer): integer;
   function Valid:boolean;
   procedure BtnClick(Sender: TObject);
   procedure BtnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
   procedure BtnMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
   procedure ListClick(Sender: TObject);
   procedure ListDBlClick(Sender: TObject);
   procedure ListKeyUp(Sender:TObject; var Key: Word; Shift: TShiftState);
   procedure PrepareItInd(ACol,ARow:integer);
   procedure SetBeMark(const Value: boolean);
   procedure SetColCount(const Value: Integer);
   procedure SetColumns(const Value: TNGCollection);
   procedure SetComboCol(x: integer; const Value: TStrings);
   procedure SetDefaultRowHeight(const Value: integer);
   procedure SetDroppedDown(const Value: boolean);
   procedure SetFixedCols(const Value: integer);
   procedure SetHideSelection(const Value: boolean);
   procedure SetHint(const Value: String);
   procedure SetHnt(const Value: String);
   procedure SetItemIndex(ACol, ARow: integer; const Value: integer);
   procedure SetListColor(const Value: TColor);
   procedure SetListLinesCount(const Value: Integer);
   procedure SetOnlyView(const Value: boolean);
   procedure SetRowHeights(x: integer; const Value: integer);
   procedure SetValues(ACol, ARow: integer; const Value: integer);
  protected
   function CanEditShow: Boolean; override;
   function CreateEditor: TInplaceEdit; override;
   function GetEditLimit: Integer; override;
   function GetEditMask(ACol: Integer; ARow: Integer): String; override;
   function GetEditText(ACol: Integer; ARow: Integer): String; override;
   function SelectCell(ACol: Integer; ARow: Integer): Boolean; override;
   procedure Click; override;
   procedure CMChildKey(var Message: TCMChildKey); message CM_CHILDKEY;
   procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
   procedure DoExit; override;
   procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); overload; override;
   procedure DrawCell(ACol,ARow:integer); reintroduce; overload;
   procedure KeyDown(var Key: Word; Shift: TShiftState); override;
   procedure KeyPress(var Key: Char); override;
   procedure KeyUp(var Key: Word; Shift: TShiftState); override;
   procedure ListExit(Sender: TObject); virtual;
   procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X: Integer; Y: Integer); override;
   procedure MouseMove(Shift: TShiftState; X: Integer; Y: Integer); override;
   procedure SetEditText(ACol: Integer; ARow: Integer; const Value: String); override;
   procedure SetName(const NewName: TComponentName); override;
   procedure WMCommand(var Message: TWMCommand); message WM_COMMAND;
   procedure WMGetDlgCode(var Msg: TWMGetDlgCode); message WM_GETDLGCODE;
   procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
   property BeMark:boolean read FBeMark write SetBeMark;
   property CellState[ACol,ARow:Integer]:TGridDrawState read GetCellState;
   property Hnt:String read GetHnt write SetHnt;
  public
   Exiting:boolean;
   Constructor Create(AOwner:TComponent); override;
   Destructor Destroy; override;
   function Focused: Boolean; override;
   function SwitchValueTo(ACol,ARow,Value:integer):Boolean;
   procedure Clear;
   procedure GoToNextCell;
   procedure GoToPrevCell;
   procedure ToCell(x,y,ItInd:integer); overload;
   procedure ToCell(x,y:integer; s:String; Data:TObject); overload; virtual;
   procedure UpdateColumn(x:integer); virtual;
   procedure UpdateColumns; virtual;
   property ColCount:Integer read GetColCount write SetColCount;
   property ComboCol[x:integer]:TStrings read GetComboCol write SetComboCol;
   property DroppedDown:boolean read GetDroppedDown write SetDroppedDown;
   property Iam:TNewGrid read GetIam;
   property InplaceEditor;
   property ItemIndex[ACol,ARow:integer]:integer read GetItemIndex write SetItemIndex;
   property RowHeights[x:integer]:integer read GetRowHeights write SetRowHeights;
   property Values[ACol,ARow:integer]:integer read GetValues write SetValues;
  published
   property Columns:TNGCollection read FColumns write SetColumns;
   property DefaultRowHeight:integer read GetDefaultRowHeight write SetDefaultRowHeight;
   property FixedCols:integer write SetFixedCols;
   property HideSelection:boolean read FHideSelection write SetHideSelection default false;
   property Hint:String read GetHint write SetHint;
   property ListColor:TColor read FListColor write SetListColor default clWindow;
   property ListLinesCount:Integer read FListLinesCount write SetListLinesCount default 5;
   property OnBeforeChangeCell:TChangeCellEvent read FOnBeforeChangeCell write FOnBeforeChangeCell;
   property OnChangeCell:TChangeCellEvent read FOnChangeCell write FOnChangeCell;
   property OnlyView:boolean read FOnlyView write SetOnlyView default false;
   property OnResize;
   property OnValidate:TValidateEvent read FOnValidate write FOnValidate;
  End;

  TSuperGrid=Class(TNewGrid)
  private
   FDeleteRowKey: TShortCut;
   FInsertRowKey: TShortCut;
   FOnDeletingRow: TIntEvent;
   FOneMore: byte;
   FOnInsertedRow: TIntEvent;
   function  GetOneMore: boolean;
   function  RowText(ARow:integer):string;
   function GetIam: TSuperGrid;
   procedure AutoAdjust;
   procedure ColResize(Sender:TObject);
   procedure Compact;
   procedure SetOneMore(const Value: boolean);
  protected
   function SelectCell(ACol: Integer; ARow: Integer): Boolean; override;
   procedure KeyDown(var Key: Word; Shift: TShiftState); override;
   procedure ListExit(Sender: TObject); override;
   procedure Resize; override;
   procedure WMChar(var Message: TWMChar); message WM_CHAR;
  public
   constructor Create(AOwner: TComponent); override;
   procedure Clear;
   procedure DelRow(x:integer);
   procedure InsertRow(x:integer);
   procedure Reset;
   procedure ToCell(x,y:integer; s:String; Data:TObject); override;
   procedure UpdateColumn(x: Integer); override;
   property Iam:TSuperGrid read GetIam;
  published
   property DeleteRowKey:TShortCut read FDeleteRowKey write FDeleteRowKey default scCtrl+vk_Delete;
   property InsertRowKey:TShortCut read FInsertRowKey write FInsertRowKey default vk_Insert;
   property OnDeletingRow:TIntEvent read FOnDeletingRow write FOnDeletingRow;
   property OneMore:boolean read GetOneMore write SetOneMore default true;
   property OnInsertedRow:TIntEvent read FOnInsertedRow write FOnInsertedRow;
  End;

implementation

uses StrUtils, Mask, Math;

{ tListEdit }

procedure tListEdit.Change;
begin
 inherited;
 if IAmWorking then Exit;
 DoIt;
end;

procedure tListEdit.CMFontChanged(var Message: TMessage);
begin
 inherited;
 if Design then Exit;
 EditUp.Font:=font;
 EditUp.Font.Size:=Font.Size-1;
 EDitDown.Font:=Font;
 EditDown.Font.Size:=Font.Size-1;
end;

constructor tListEdit.Create(AOwner: TComponent);
begin
 inherited;
 Design:=csDesigning in ComponentState;
 if not Design then Begin
  EditUp:=tEdit.Create(AOwner);
  FreeNotification(EditUp);
  With EditUp do Begin
   Font.Size:=self.Font.Size-1;
   Name:='EditUp';
   ReadOnly:=true;
   AutoSelect:=false;
   OnEnter:=_Enter;
   TabStop:=false;
   TabOrder:=-1;
   Visible:=false;
   ParentCtl3D:=false;
   Ctl3D:=false;
  End;
  EditDown:=tEdit.Create(AOwner);
  FreeNotification(EditDown);
  With EditDown do Begin
   Font.Size:=self.Font.Size-1;
   Name:='EditDown';
   ReadOnly:=true;
   AutoSelect:=false;
   OnEnter:=_Enter;
   TabStop:=false;
   TabOrder:=-1;
   Visible:=false;
   ParentCtl3D:=false;
   Ctl3D:=false;
  End;
 End;
 FData:=nil;
 FItemIndex:=-1;
 FiltredList:=TStringList.Create;
 FItems:=TStringList.Create;
 FItems2:=TStringList.Create;
 ViewEnd:=true;
 FiltredList.Sorted:=true;
 FItems.Sorted:=true;
 FItems.CaseSensitive:=false;
 IAmWorking:=false;
 AutoSelect:=false;
end; 

destructor tListEdit.Destroy;
begin
 FiltredList.Free;
 FItems.Free;
 FItems2.Free;
 inherited;
end;

procedure tListEdit.DoEnter;
begin
 DoIt;
 inherited;
end;

procedure tListEdit.DoExit;
begin
 inherited;
 EditUp.visible:=false;
 EditDown.visible:=false;
end;

procedure tListEdit.DoIt;
Var
 x:integer;
begin
 Text2:=AnsiLowerCase(text);
 FiltredList.Clear;
 FItems.Find(Text2,x);
 if (x<0) or (x>FItems.Count-1) then Exit;
 While pos(Text2,AnsiLowerCase(FItems[x]))=1 do Begin
  FiltredList.Add(FItems[x]);
  inc(x);
  if x=FItems.Count then break;
 End;
 Num:=0;
 ShowString(0);
end;

function tListEdit.GetIam: TListEdit;
begin
 result:=self;
end;

function tListEdit.GetItems: TStrings;
begin
 result:=FItems;
end;

procedure tListEdit.KeyDown(var Key: Word; Shift: TShiftState);
Var
 sc:Word;
begin
 inherited;
 sc:=ShortCut(Key,Shift);
 ViewEnd:=not(sc in [vk_Delete,VK_BACK]);
end;

procedure tListEdit.KeyUp(var Key: Word; Shift: TShiftState);
Var
 sc:Word;
begin
 ViewEnd:=true;
 inherited;
 sc:=ShortCut(Key,Shift);
 Case sc of
  vk_Down: if Num<FiltredList.Count-1 then inc(Num);
  vk_Up: if Num>0 then dec(Num);
 End;
 if sc in [vk_Down,vk_Up] then ShowString(Num);
end;

procedure tListEdit.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
Var
 a,b:TPoint;
 dx,dy:integer;
 i:integer;
 Edit:TEdit;
begin
 inherited;
 if Design then Exit;
 if Parent=nil then Exit;
 a:=Parent.ClientToScreen(Point(0,0));
 For i:=1 to 2 do Begin
  Case i of
   1: Edit:=EditDown;
   2: Edit:=EditUp;
   else Edit:=nil;
  End;
  if Edit=nil then Continue;
  With Edit do Begin
   Visible:=false;
   b:=Parent.ClientToScreen(Point(0,0));
   dx:=a.x-b.x;
   dy:=a.y-b.y;
   Left:=self.Left+2+dx;
   Width:=self.Width-4;
   if i=2
    then Top:=Self.Top-Height+dy
    else Top:=Self.Top+Self.Height+dy;
  End;
 End;
end;

procedure tListEdit.SetChoiceColor(const Value: TColor);
begin
 FChoiceColor := Value;
 if (EditUp=nil) or (EditDown=nil) then Exit;
 EditUp.Color:=Value;
 EditDown.Color:=Value;
end;

procedure tListEdit.SetChoiceTextColor(const Value: TColor);
begin
 FChoiceTextColor := Value;
 if (EditUp=nil) or (EditDown=nil) then Exit;
 EditUp.Font.Color:=Value;
 EditDown.Font.Color:=Value;
end;

procedure tListEdit.SetData(index:integer; AData:TObject);
begin
 fItemIndex:=index;
 if Assigned(FonChangeIndex) then FonChangeIndex(self,index,AData);
 FData:=AData;
end;

procedure tListEdit.SetItems(const Value: TStrings);
begin
 FItems2.Assign(Value);
 FItems.Assign(Value);
end;

procedure tListEdit.SetParent(AParent: TWinControl);
begin
 if not Design and (AParent<>nil) then Begin
  With EditUp do Begin
   Parent:=AParent;
   While Parent.Parent<>nil do Parent:=Parent.Parent;
   BringToFront;
  End;
  With EditDown do Begin
   Parent:=AParent;
   While Parent.Parent<>nil do Parent:=Parent.Parent;
   BringToFront;
  End;
 End;
 inherited;
end;

procedure tListEdit.ShowString(Num: integer);
begin
 if Design or (Num<0) or (Num>FiltredList.Count-1) then Begin
  SetData(-1,nil);
  EditUp.Visible:=false;
  EditDown.Visible:=false;
  Exit;
 End;
 if ViewEnd then Begin
  IAmWorking:=true;
  text:=FiltredList[Num];
  SetData(FItems2.IndexOf(text),FiltredList.Objects[Num]);
  IAmWorking:=false;
  SelStart:=Length(text2);
  SelLength:=Length(Text)-SelStart;
 End;
 EditUp.Visible:=Num>0;
 if Num>0 then EditUp.Text:=FiltredList[Num-1];
 EditDown.Visible:=Num<FiltredList.Count-1;
 if Num<FiltredList.Count-1 then EditDown.Text:=FiltredList[Num+1];
end;

procedure tListEdit._Enter(Sender: TObject);
begin
 self.SetFocus;
end;

{ TNewGrid }

procedure TNewGrid.BtnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 DownBtn.BevelInner:=bvRaised;
end;

procedure TNewGrid.BtnMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 DownBtn.BevelInner:=bvNone;
end;

constructor TNewGrid.Create(AOwner: TComponent);
begin
 inherited;
 Exiting:=false;
 SetLength(FItemIndex,0);
 FHideSelection:=false;
 FOnlyView:=false;
 FixedCols:=0;
 FColumns:=TNGCollection.Create(self);
 ColCount:=1;
 Options:=Options+[goDrawFocusSelected,goTabs]-[goRangeSelect];
 FListLinesCount:=5;
 FListColor:=clWindow;
 List:=tSubListBox.Create(self);
 With List do Begin
  Parent:=self;
  Visible:=false;
  BoundsRect:=Rect(0,0,0,0);
  Ctl3D:=false;
  ParentCtl3D:=false;
  ListColor:=clWindow;
  onKeyUp:=ListKeyUp;
  onExit:=ListExit;
  onClick:=ListClick;
  onDblClick:=ListDblClick;
 End;
 DownBtn:=tPanel.Create(self);
 With DownBtn do Begin
  Width:=0;
  Height:=0;
  Visible:=false;
  Parent:=self;
  BevelInner:=bvRaised;
  BevelOuter:=bvLowered;
  Caption:='6';
  Font.Name:='Webdings';
  TabStop:=false;
  onMouseDown:=BtnMouseDown;
  onMouseUp:=BtnMouseUp;
  onClick:=BtnClick;
 End;
end;

destructor TNewGrid.Destroy;
Var
 i:integer;
begin
 For i:=0 to High(FItemIndex) do SetLength(FItemIndex[i],0);
 SetLength(FItemIndex,0);
 FColumns.Free;
 inherited;
end;

procedure TNewGrid.DrawCell(ACol, ARow: Longint; ARect: TRect;
             AState: TGridDrawState);
Var
 rct:tRect;
 l,t,w,ww:integer;
 S:string;
begin
 inherited;
 l:=ARect.Left;
 t:=ARect.Top;
 s:=Cells[ACol,ARow];
 ww:=ARect.Right-l;
 if gdSelected in AState then With Canvas do Begin
  Brush.Style:=bsSolid;
  Brush.Color:=Color;
  Font.Color:=clBlack;
  TextRect(ARect,l+2,t+2,s);
  if HideSelection then Pen.Color:=Color else Pen.Color:=clBlack;
  Brush.Style:=bsClear;
  Rectangle(ARect);
  if not (gdFocused in AState) then BeMark:=false;
 End;
 if gdFocused in AState then Repeat
  Rct:=ARect;
  With Rct do Begin
   Top:=Top+1;
   Bottom:=Bottom-1;
   Right:=Right-1;
   Left:=Right-(Bottom-Top);
  End;
  With DownBtn do
   if not(CompareRect(BoundsRect,Rct) and BeMark) then Begin
    Visible:=false;
    BoundsRect:=Rct;
    BeMark:=true;
   End;
  btCol:=ACol;
  btRow:=ARow;
  With Canvas, ARect do Begin
   Brush.Style:=bsSolid;
   Brush.Color:=clWhite;
   Pen.Color:=clRed;
   Rectangle(Left,Top,Right,Bottom);
   Font.Color:=clBlue;
   Brush.Style:=bsClear;
   TextRect(ARect,l+2,t+2,s);
  End;
 Until true;
 if gdFixed in AState then With Canvas do Begin
  Brush.Color:=FixedColor;
  Pen.Color:=clBlack;
  Rectangle(ARect);
  Font.Color:=clBlack;
  Font.Style:=[fsBold];
  w:=TextWidth(Cells[ACol,ARow]);
  TextRect(ARect,l+(ww-w) div 2,t+2,s);
 End;
end;

function TNewGrid.GetComboCol(x: integer): TStrings;
begin
 result:=FColumns[x].Strings;
end;

procedure TNewGrid.SetComboCol(x: integer; const Value: TStrings);
begin
 if (x<0) or (x>=FColumns.Count) then Exit;
 FColumns[x].Strings:=Value;
end;

procedure TNewGrid.BtnClick(Sender: TObject);
Var
 a,b:TPoint;
 dx,dy:integer;
 Form:tCustomForm;
begin
 Form:=GetParentForm(self);
 if Form<>nil then Begin
  FormPreview:=Form.KeyPreview;
  Form.KeyPreview:=false;
 End;
 a:=ClientToScreen(Point(0,0));
 OldCell:=Cells[btCol,btRow];
 OldData:=Objects[btCol,btRow];
 IsNew:=false;
 With List do Begin
  Visible:=false;
  Parent:=GetParentForm(self);
  b:=Parent.ClientToScreen(Point(0,0));
  dx:=a.x-b.x;
  dy:=a.y-b.y;
  BoundsRect:=CellRect(btCol,btRow);
  BringToFront;
  Top:=Top+height+dy;
  Left:=Left+dx;
  if ComboCol[btCol]=nil
   then Items.Clear
   else Items.Assign(ComboCol[btCol]);
  Height:=2+ItemHeight*min(FListLinesCount,max(Items.Count,1));
  Visible:=true;
  SetFocus;
  BeMark:=true;
 End;
end;

procedure TNewGrid.ListExit(Sender: TObject);
Var
 Form:tCustomForm;
begin
 List.Visible:=false;
 if not IsNew then ToCell(btCol,btRow,OldCell,OldData);
 Form:=GetParentForm(self);
 if Form<>nil then Form.KeyPreView:=FormPreView;
end;

procedure TNewGrid.SetListColor(const Value: TColor);
begin
 FListColor := Value;
 List.Color:=Value;
end;

procedure TNewGrid.KeyUp(var Key: Word; Shift: TShiftState);
begin
 Case ShortCut(Key,Shift) of
  scAlt+vk_Down: Begin
   if BeMark and (ComboCol[Col].Count>0) then BtnClick(DownBtn);
   Exit;
  End;
  else inherited;
 End;
end;

procedure TNewGrid.KeyDown(var Key: Word; Shift: TShiftState);
begin
 Case ShortCut(Key,Shift) of
  VK_RIGHT: GoToNextCell;
  VK_LEFT: GoToPrevCell;
  VK_ESCAPE: if EditorMode then Begin
   EditorMode:=false;
   Cells[Col,Row]:=FOldText;
   FocusCell(Col,Row,true);
  End;
  scAlt+vk_Down: Exit;
  VK_DELETE: Begin
   if not EditorMode and not OnlyView
   and not (Columns[col].ReadOnly and (Columns[col].Strings.Count=0)) 
   then ToCell(Col,Row,'',nil);
  End;
  else if Valid then inherited;
 End;
end;

procedure TNewGrid.ListClick(Sender: TObject);
begin
 if List.ItemIndex=-1 then Exit;
 With List, Items do
  ToCell(btCol,btRow,ItemIndex)
end;

procedure TNewGrid.ListDBlClick(Sender: TObject);
begin
 isNew:=true;
 self.SetFocus;
end;

procedure TNewGrid.ListKeyUp(Sender:TObject; var Key: Word; Shift: TShiftState);
Var
 sc:Word;
begin
 sc:=ShortCut(Key,Shift);
 inherited;
 IsNew:=sc=vk_Return;
 if sc in [vk_Return,vk_Escape] then Self.SetFocus;
end;

procedure TNewGrid.ToCell(x, y: integer; s: String; Data: TObject);
Var
 ii:integer;
begin
 if Assigned(FOnBeforeChangeCell) then FOnBeforeChangeCell(self,x,y);
 Cells[x,y]:=s;
 Objects[x,y]:=Data;
 ii:=ComboCol[x].IndexOf(s);
 if ii=-1 then ii:=ComboCol[x].IndexOfObject(Data);
 PrepareItInd(x,y);
 FItemIndex[x,y]:=ii;
 if Assigned(FOnChangeCell) then FOnChangeCell(self,x,y);
end;

procedure TNewGrid.SetName(const NewName: TComponentName);
begin
 inherited;
 if List<>nil then List.Name:=NewName;
end;

procedure TNewGrid.SetListLinesCount(const Value: Integer);
begin
 FListLinesCount := Value;
end;

function TNewGrid.GetItemIndex(ACol, ARow: integer): integer;
begin
 result:=-1;
 if (ACol<0) or (ACol>ColCount-1) then Exit;
 if (ARow<0) or (ARow>RowCount-1) then Exit;
 PrepareItInd(ACol,ARow);
 result:=FItemIndex[ACol,ARow];
end;

procedure TNewGrid.SetItemIndex(ACol, ARow: integer; const Value: integer);
begin
 if (ACol<0) or (ACol>ColCount-1) then Exit;
 if (ARow<0) or (ARow>RowCount-1) then Exit;
 PrepareItInd(ACol,ARow);
 ToCell(ACol,ARow,Value)
end;

procedure TNewGrid.PrepareItInd(ACol, ARow: integer);
Var
 i,l1,l2:integer;
begin
 l1:=Length(FItemIndex);
 if l1-1<ACol then SetLength(fItemIndex,ACol+1);
 l2:=Length(FItemIndex[ACol]);
 if l2-1<ARow then Begin
  SetLength(fItemIndex[ACol],ARow+1);
  For i:=l2 to ARow do FItemIndex[ACol,i]:=-1;
 End;
end;

procedure TNewGrid.ToCell(x, y, ItInd: integer);
Var
 s:string;
begin
 PrepareItInd(x,y);
 if (ItInd<0) or (ItInd>ComboCol[x].Count-1) then Begin
  s:='';
  FItemIndex[x,y]:=-1;
 End else Begin
  s:=ComboCol[x][ItInd];
  FItemIndex[x,y]:=ItInd;
  Objects[x,y]:=ComboCol[x].Objects[ItInd];
 End;
 if Assigned(FOnBeforeChangeCell) then FOnBeforeChangeCell(self,x,y);
 Cells[x,y]:=s;
 if Assigned(FOnChangeCell) then FOnChangeCell(self,x,y);
end;

function TNewGrid.CanEditShow: Boolean;
begin
 result:=true;
 if Columns[Col]<>nil then result:=Columns[Col].DoEdit(Row);
 result:=result and inherited CanEditShow;
end;

function TNewGrid.CreateEditor: TInplaceEdit;
begin
 result:=TNGEditor.Create(self);
end;

procedure TNewGrid.SetBeMark(const Value: boolean);
begin
 FBeMark := false;
 if FOnlyView then Exit;
 FBeMark := Value;
 DownBtn.Visible:=(ComboCol[Col].Count>0) and Value;
end;

function TNewGrid.SelectCell(ACol, ARow: Integer): Boolean;
begin
 result:=inherited SelectCell(ACol,ARow);
 Cells[ACol,ARow]:=Cells[ACol,ARow];
end;

procedure TNewGrid.GoToNextCell;
Var
 x:integer;
 us:boolean;
begin
 us:=true;
 if EditorMode and (InplaceEditor<>nil) then Begin
  if not Valid then Exit;
  us:=InplaceEditor.SelStart=Length(InplaceEditor.Text);
 End;
 x:=Row*ColCount+Col;
 us:=us and (x<ColCount*RowCount-1);
 if us then inc(x);
 Col:=x mod ColCount;
 Row:=x div ColCount;
end;

procedure TNewGrid.GoToPrevCell;
Var
 x:integer;
 us:boolean;
begin
 us:=true;
 if EditorMode and (InplaceEditor<>nil) then Begin
  if not Valid then Exit;
  us:=InplaceEditor.SelStart=0;
 End;
 x:=Row*ColCount+Col;
 us:=us and (x>ColCount);
 if us then dec(x);
 Col:=x mod ColCount;
 Row:=x div ColCount;
end;

procedure TNewGrid.SetColumns(const Value: TNGCollection);
begin
 FColumns.assign(Value);
end;

procedure TNewGrid.SetFixedCols(const Value: integer);
begin
 inherited FixedCols:=Value;
end;

procedure TNewGrid.UpdateColumn(x: integer);
begin
 Inherited ColCount:=FColumns.Count;
 Cells[x,0]:=FColumns[x].Caption;
end;

procedure TNewGrid.UpdateColumns;
Var
 i:integer;
begin
 Inherited ColCount:=FColumns.Count;
 For i:=0 to ColCount-1 do UpdateColumn(i);
end;

procedure TNewGrid.CMEnter(var Message: TCMEnter);
begin
 inherited;
 DrawCell(Col,Row);
 FocusCell(Col,Row,true);
end;

function TNewGrid.GetIam: TNewGrid;
begin
 result:=self;
end;

procedure TNewGrid.Clear;
Var
 i:integer;
begin
 For i:=1 to RowCount-1 do Rows[i].Clear;
end;

procedure TNewGrid.SetHideSelection(const Value: boolean);
begin
  FHideSelection := Value;
end;

procedure TNewGrid.CMChildKey(var Message: TCMChildKey);
begin
end;

procedure TNewGrid.WMGetDlgCode(var Msg: TWMGetDlgCode);
Var
 op:TGridOptions;
 sh:Boolean;
begin
 inherited;
 sh:=GetKeyState(VK_SHIFT) >= 0;
 op:=Options;
 sh:=(not sh and (Col=0) and (Row=1))
  or ((Col=Columns.Count-1) and (Row=RowCount-1) and sh);
 if sh then Options:=Options-[goTabs];
 inherited;
 Options:=op;
end;

function TNewGrid.Valid: boolean;
Var
 a:Integer;
 b:Extended;
 d,t:TDateTime;
 h,m,s,ms:Word;
 Text:String;
begin
 result:=true;
 if InplaceEditor=nil then Exit;
 if not EditorMode then Exit;
 Text:=InplaceEditor.EditText;
 if Text<>'' then
 Case Columns[Col].DataType of
  ctInteger: result:=TryStrToInt(Text,a);
  ctSmallInt: Begin
   result:=TryStrToInt(Text,a) and (a>Low(SmallInt))
                               and (a<High(SmallInt));
  End;
  ctFloat: result:=TryStrToFloat(Text,b);
  ctDate: Begin
   result:=TryStrToDate(Text,d);
   if result then Begin
    DecodeDate(d,h,m,s);
    result:=(YearOf(d)>=1950) and (m<13) and (s<31);
   End;
  End;
  ctTime: Begin
   result:=TryStrToTime(Text,t);
   if result then Begin
    DecodeTime(t,h,m,s,ms);
    result:=(h<24) and (m<60) and (s<60);
   End;
  End;
 End;
 if result then
  if Assigned(FOnValidate) then FOnValidate(self,Col,Row,Text,Result);
 if Assigned(Columns[Col].OnValidResult)
  then Columns[Col].FOnValidResult(self,result);
end;

function TNewGrid.GetEditMask(ACol, ARow: Integer): String;
begin
 FOldText:=Cells[ACol,ARow];
 result:='';
end;

procedure TNewGrid.DoExit;
begin
 if Valid then inherited Doexit else Begin
  Exiting:=true;
  InplaceEditor.SetFocus;
  EditorMode:=true;
  Valid;
  Exiting:=false;
 End;
end;

procedure TNewGrid.MouseDown(Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
 if Valid then inherited;
end;

procedure TNewGrid.WMCommand(var Message: TWMCommand);
begin
 if not (Message.NotifyCode=EN_CHANGE)
  then inherited
  else TNGEditor(InplaceEditor).Change;
  Message.Result:=1;
end;

function TNewGrid.GetEditLimit: Integer;
begin
 With Columns[Col] do Case DataType of
  ctInteger: result:=11;
  ctSmallInt: result:=6;
  else result:=0;
 End;
end;

function TNewGrid.GetEditText(ACol, ARow: Integer): String;
begin
 result:=inherited GetEditText(ACol,ARow);
 if result='' then
  Case Columns[ACol].DataType of
   ctSmallInt,ctInteger: result:='0';
   ctFloat: result:='0,0';
   ctDate: result:='00.00.2000';
   ctTime: result:='00:00';
  End;
end;

procedure TNewGrid.SetHint(const Value: String);
begin
 FHint:=Value;
 Hnt:=Value;
end;

procedure TNewGrid.SetHnt(const Value: String);
begin
 inherited Hint := Value;
end;

function TNewGrid.GetHnt: String;
begin
 result:=Inherited Hint;
end;

function TNewGrid.GetHint: String;
begin
 result:=Hnt;
end;

procedure TNewGrid.MouseMove(Shift: TShiftState; X, Y: Integer);
Var
 a,b:integer;
 s:string;
begin
 inherited;
 if csDesigning in ComponentState then Exit;
 MouseToCell(x,y,a,b);
 s:='';
 if a>-1 then s:=Columns[a].Hint;
 if s='' then s:=FHint;
 Hnt:=s;
end;

procedure TNewGrid.KeyPress(var Key: Char);
begin
 if (Key=#13) and EditorMode and not Valid then Exit;
 inherited;
end;

procedure TNewGrid.SetEditText(ACol, ARow: Integer; const Value: String);
Var
 x:TDateTime;
begin
 if Exiting then Exit;
 inherited;
 Case Columns[ACol].DataType of
  ctFloat: if TryStrToFloat(Value,Double(x)) then Cells[ACol,ARow]:=FloatToStr(x);
  ctDate: if TryStrToDate(Value,x) then Cells[ACol,ARow]:=Date2Str(x);
  ctTime: if TryStrToTime(Value,x) then Cells[ACol,ARow]:=Time2Str(x);
 End;
end;

function TNewGrid.GetValues(ACol, ARow: integer): integer;
begin
 result:=Integer(Objects[ACol,ARow]);
end;

procedure TNewGrid.SetValues(ACol, ARow: integer; const Value: integer);
begin
 Objects[ACol,ARow]:=TObject(Value);
end;

function TNewGrid.SwitchValueTo(ACol,ARow,Value: integer):boolean;
Var
 n:integer;
begin
 result:=false;
 if (ACol<0) or (ACol>ColCount-1) then EXit;
 n:=ComboCol[ACol].IndexOfObject(TObject(Value));
 if n=-1 then Exit;
 ItemIndex[ACol,ARow]:=n;
 result:=true;
end;

function TNewGrid.Focused: Boolean;
begin
 result:=inherited Focused;
 if List<>nil then result:=result or List.Focused;
 if InplaceEditor<>nil
  then result:=result or InplaceEditor.Focused;
end;

procedure TNewGrid.SetDroppedDown(const Value: boolean);
begin
 if not Value
 then List.Visible:=false
 else if (ComboCol[Col].Count>0) and Focused then BtnClick(DownBtn);
end;

function TNewGrid.GetDroppedDown: boolean;
begin
 result:=List.Visible;
end;

function TNewGrid.GetRowHeights(x: integer): integer;
begin
 result:=MulDiv(inherited RowHeights[x],96,Screen.PixelsPerInch);
end;

procedure TNewGrid.SetRowHeights(x: integer; const Value: integer);
begin
 inherited RowHeights[x]:=MulDiv(Value,Screen.PixelsPerInch,96);
end;

procedure TNewGrid.SetDefaultRowHeight(const Value: integer);
begin
 inherited DefaultRowHeight:=MulDiv(Value,Screen.PixelsPerInch,96);
end;

function TNewGrid.GetDefaultRowHeight: integer;
begin
 result:=MulDiv(inherited DefaultRowHeight,96,Screen.PixelsPerInch);
end;

procedure TNewGrid.Click;
Var
 x:TWinControl;
begin
 inherited;
 x:=GetParentForm(self);
 if x=nil then Exit;
 x.Perform(27777,Integer(self),0);
end;

procedure TNewGrid.WMLButtonDblClk(var Message: TWMLButtonDblClk);
Var
 cr:TGridCoord;
begin
 inherited;
 if OnlyView then Exit;
 With ScreenToClient(Mouse.CursorPos)
  do cr:=MouseCoord(x,y);
 if cr.x<inherited FixedCols then Exit;
 if cr.y<FixedRows then Exit;
 DroppedDown:=not DroppedDown;
end;

procedure TNewGrid.SetOnlyView(const Value: boolean);
begin
 FOnlyView := Value;
 if Value then BeMark:=false;
end;

function TNewGrid.GetColCount: Integer;
begin
 result:=Inherited ColCount;
end;

procedure TNewGrid.SetColCount(const Value: Integer);
Var
 i,m:integer;
begin
 m:=100;
 For i:=0 to Columns.Count-1 do
  if (i=0) or (Columns[i].RelativeWidth<m) then m:=Columns[i].RelativeWidth;
 For i:=Columns.Count+1 to Value do Columns.Add.RelativeWidth:=m;
 inherited ColCount:=Value;
end;

function TNewGrid.GetCellState(ACol, ARow: Integer): TGridDrawState;
begin
 Result:=[];
 if (ACol<inherited FixedCols) or (ARow<FixedRows) then Result:=[gdFixed];
 if (ACol=Col) and (ARow=Row) then Result:=Result+[gdFocused];
 With Selection do
  if (Left<=ACol) and (Right-1>=ACol) and (Top<=ARow) and (Bottom-1>=ARow)
  then Result:=Result+[gdSelected];
end;

procedure TNewGrid.DrawCell(ACol, ARow: integer);
begin
 DrawCell(Acol,ARow,CellRect(ACol,ARow),CellState[ACol,ARow]);
end;

{ TSubListBox }

procedure TSubListBox.Click;
begin
 IsClick:=true;
 inherited;
 IsClick:=false;
end;

procedure TSubListBox.CMCancelMode(var Message: TCMCancelMode);
begin
 inherited;
 if Message.Sender<>self then Hide;
end;

procedure TSubListBox.CNCommand(var Message: TWMCommand);
begin
 if (Message.NotifyCode=LBN_SELCHANGE) and IsClick then Exit;
 inherited;
end;

procedure TSubListBox.CNKeydown(var Message: TWMKeyDown);
begin
 if Message.CharCode=vk_Tab then Begin
  Hide;
  TWinControl(Owner).SetFocus;
  With TMessage(Message)  do
   Result:=TControl(Owner).Perform(msg,WParam,LParam);
 End else inherited;
end;

constructor TSubListBox.Create(AOwner: TComponent);
begin
 inherited;
 IsClick:=false;
 IsSend:=false;
 FComponentStyle:=FComponentStyle+[csSubComponent];
 ControlStyle:=ControlStyle+[csNoDesignVisible];
 Hide;
end;


{ TNGColumn }

procedure TNGColumn.ChangeWidth;
begin
 if Assigned(FOnChangeWidth) then FOnChangeWidth(self);
end;

constructor TNGColumn.Create(Collection: TCollection);
begin
 Inherited;
 FStrings:=tNumStrList.Create;
 FStrings.OnChange:=StringChange;
 FDataType:=ctString;
 FRelativeWidth:=100;
 Caption:='';
 ReadOnly:=true;
end;

destructor TNGColumn.Destroy;
begin
 FStrings.Free;
 inherited;
end;

function TNGColumn.DoEdit(ARow:integer):boolean;
begin
 Result:=not FReadOnly and not Grid.OnlyView;
 if Assigned(FOnEdit) then FOnEdit(Grid,ARow,Result);
end;

function TNGColumn.GetDisplayName: String;
begin
 Result:=Caption;
end;

function TNGColumn.GetGrid: TNewGrid;
begin
 result:=TNewGrid(Collection.Owner);
end;

function TNGColumn.GetIam: TNGColumn;
begin
 result:=self;
end;

function TNGColumn.GetReadOnly: boolean;
begin
 result:=FReadOnly or (Strings.Count<>0);
end;

function TNGColumn.GetStrings: TStrings;
begin
 result:=FStrings;
end;

procedure TNGColumn.SetCaption(const Value: String);
Var
 Grid:TNewGrid;
begin
 FCaption:=Value;
 Grid:=TNewGrid(Collection.Owner);
 if Grid<>nil then
  Grid.Cells[index,0]:=Value;
end;

procedure TNGColumn.SetDataType(const Value: TDataTyp);
begin
 FDataType := Value;
end;

procedure TNGColumn.SetHint(const Value: String);
begin
 FHint := Value;
end;

procedure TNGColumn.SetReadOnly(const Value: boolean);
begin
 FReadOnly:=Value;
end;

procedure TNGColumn.SetRelativeWidth(const Value: integer);
begin
 FRelativeWidth := Value;
 ChangeWidth;
end;

procedure TNGColumn.SetStrings(const Value: TStrings);
begin
 if Value=nil
  then FStrings.Clear
  else FStrings.Assign(Value);
end;

procedure TNGColumn.StringChange(Sender: TObject);
begin
 if FStrings.Count=0
  then Grid.BeMark:=false
  else With Grid do if Columns[Col]=self then DrawCell(Col,Row);
end;

{ TNGEditor }

procedure TNGEditor.Change;
begin
 inherited;
 if Grid=nil then Exit;
 if not TNewGrid(Grid).Valid then Begin
  if FTextColor=-1 then FTextColor:=Font.Color;
  Font.Color:=clRed;
 End else
  if FTextColor<>-1 then Begin
   Font.Color:=FTextColor;
   FTextColor:=-1;
  End;
end;

procedure TNGEditor.CNKeydown(var Message: TWMKey);
begin
 With Message do
 if CharCode=VK_TAB
  then With TMessage(Message) do result:=Grid.Perform(msg,WParam,LParam)
  else inherited;
end;

constructor TNGEditor.Create(AOwner: TComponent);
begin
 inherited;
 FTextColor:=-1;
 AutoSelect:=false;
end;

function TNGEditor.GetIam: TNGEditor;
begin
 result:=self;
end;

procedure TNGEditor.KeyDown(var Key: Word; Shift: TShiftState);
begin
 Case ShortCut(Key,Shift) of
  VK_LEFT,VK_RIGHT: Grid.Perform(WM_KEYDOWN,Integer(Key),0);
  else inherited;
 End;
end;

procedure TNGEditor.KeyPress(var Key: Char);
begin
 inherited;
 With TNewGrid(Grid), Columns[Col] do Begin
  if DataType=ctString then Exit;
  if not (Key in ['-','0'..'9',#8,'.',',',':']) then begin
   key:=#0;
   Exit;
  end;
  Case DataType of
   ctFloat: Begin
    if Key in [':'] then Key:=#0;
    if Key in [',','.'] then Begin
     Key:=DecimalSeparator;
     if pos(Key,self.Text)>0 then Key:=#0;
    End;
    if (Key='-') and ((SelStart>0) or (Text[1]='-')) then key:=#0;
   End;
   ctInteger:Begin
    if Key in [',','.',':'] then Key:=#0;
    if (Key='-') and ((SelStart>0) or (Text[1]='-')) then key:=#0;
   End;
   ctTime: if Key in [',','.','-'] then Key:=':';
   ctDate: if Key in [',','-',':'] then Key:='.';
  End;
 End;
end;

procedure TNGEditor.KeyUp(var Key: Word; Shift: TShiftState);
begin
 inherited;
end;

{ TSuperGrid }

procedure TSuperGrid.AutoAdjust;
Var
 i,s,ww:integer;
 cw:ai;
begin
 if not HandleAllocated then Exit;
 ww:=0;
 SetLength(cw,ColCount);
 For i:=0 to ColCount-1 do cw[i]:=Columns[i].RelativeWidth;
 For i:=0 to ColCount-1 do ww:=ww+cw[i];
 s:=0;
 For i:=0 to ColCount-2 do Begin
  ColWidths[i]:=cw[i]*ClientWidth div ww;
  s:=s+ColWidths[i];
 End;
 ColWidths[ColCount-1]:=ClientWidth-ColCount-s-1;
end;

procedure TSuperGrid.Clear;
begin
 inherited;
 Compact;
end;

procedure TSuperGrid.ColResize(Sender: TObject);
begin
 AutoAdjust;
end;

procedure TSuperGrid.Compact;
Var
 i,x:integer;
begin
 if OneMore then
  if RowText(RowCount-1)<>'' then begin
   RowCount:=RowCount+1;
   Rows[RowCount-1].Text:='';
   Exit;
  end;
 x:=RowCount-1;
 For i:=x downto 2-FOneMore do
  if RowText(i)='' then RowCount:=i+FOneMore else break;
end;

constructor TSuperGrid.Create(AOwner: TComponent);
begin
 inherited;
 FOneMore:=1;
 FDeleteRowKey:=scCtrl+vk_Delete;
 FInsertRowKey:=vk_Insert;
end;

procedure TSuperGrid.DelRow(x: integer);
Var
 i:integer;
begin
 if Assigned(FOnDeletingRow) then FOnDeletingRow(self,x);
 For i:=x to RowCount-2 do Rows[i]:=Rows[i+1];
 if x<RowCount-1
 then RowCount:=RowCount-1
 else Rows[RowCount-1].Text:='';
end;

function TSuperGrid.GetIam: TSuperGrid;
begin
 result:=self;
end;

function TSuperGrid.GetOneMore: boolean;
begin
 result:=FOneMore=1;
end;

procedure TSuperGrid.InsertRow(x: integer);
Var
 i:integer;
begin
 if (x<RowCount-1) or (RowText(RowCount-1)<>'') then RowCount:=RowCount+1;
 For i:=RowCount-1 downto x+1 do Rows[i]:=Rows[i-1];
 Rows[x].Text:='';
 if Assigned(FOnInsertedRow) then FOnInsertedRow(self,x);
end;

procedure TSuperGrid.KeyDown(var Key: Word; Shift: TShiftState);
Var
 sc:TShortCut;
begin
 sc:=ShortCut(Key,Shift);
 if not((sc=FInsertRowKey) or (sc=FDeleteRowKey)) then inherited;
 if OnlyView then Exit;
 if not EditorMode then Begin
  if sc=FInsertRowKey then InsertRow(Row);
  if sc=FDeleteRowKey then DelRow(Row);
 End;
end;

procedure TSuperGrid.ListExit(Sender: TObject);
begin
 inherited;
 Compact;
end;

procedure TSuperGrid.Reset;
begin
 RowCount:=2;
 Rows[1].Text:='';
end;

procedure TSuperGrid.Resize;
begin
 inherited;
 AutoAdjust;
end;

function TSuperGrid.RowText(ARow: integer): string;
begin
 result:=SolidText(Rows[ARow]);
end;

function TSuperGrid.SelectCell(ACol, ARow: Integer): Boolean;
begin
 result:=inherited SelectCell(ACol,ARow);
 if OneMore and (ARow=RowCount-1) and (Cells[0,ARow]<>'') then Compact;
end;

procedure TSuperGrid.SetOneMore(const Value: boolean);
begin
 if Value then FOneMore := 1 else FOneMore:=0;
 Compact;
end;

procedure TSuperGrid.ToCell(x, y: integer; s: String; Data: TObject);
begin
 IsNew:=true;
 inherited;
 if (y=RowCount-1) and (Cells[x,y]<>'') then Begin
  RowCount:=RowCount+1;
  Rows[RowCount-1].Text:='';
 End;
 Compact;
end;

procedure TSuperGrid.UpdateColumn(x: Integer);
begin
 Columns[x].onChangeWidth:=ColResize;
 inherited;
end;

procedure TSuperGrid.WMChar(var Message: TWMChar);
begin
 if (ComboCol[Col].Count>0) and not OnlyView and (Message.CharCode>27) then Begin
  BtnClick(DownBtn);
  With Message do List.Perform(WM_CHAR,CharCode,0);
 End;
 inherited;
end;

function TSubListBox.GetIam: TSubListBox;
begin
 result:=self;
end;

function TSubListBox.GetItemIndex: integer;
begin
 if HandleAllocated then result:=inherited GetItemIndex else result:=-1;
end;

procedure TSubListBox.SetItemIndex(const Value: Integer);
begin
 if HandleAllocated then inherited;
 Click;
end;

{ TSubStringList }

function TSubStringList.AddObject(const S: String;
  AObject: TObject): Integer;
begin
 result:=-1;
 if IsGood then result:=Link.AddObject(S,AObject);
end;

procedure TSubStringList.Assign(Source: TPersistent);
begin
 if IsGood then Link.Assign(Source);
end;

procedure TSubStringList.Clear;
begin
 if IsGood then Link.Clear;
end;

constructor TSubStringList.Create(AControl:TControl; ALink:TStrings);
begin
 Link:=ALink;
 Control:=AControl;
end;

procedure TSubStringList.Delete(Index: Integer);
begin
 if (Index<0) or (Index>=Link.Count) then Exit;
 Link.Delete(Index);
end;

function TSubStringList.Get(Index: Integer): String;
begin
 result:='';
 if (Index<0) or (Index>=Link.Count) then Exit;
 result:=Link[Index];
end;

function TSubStringList.GetCount: Integer;
begin
 if IsGood then result:=Link.Count else result:=0;
end;

function TSubStringList.GetIam: TSubStringList;
begin
 result:=self;
end;

function TSubStringList.GetObject(Index: Integer): TObject;
begin
 result:=nil;
 if (Index<0) or (Index>=Link.Count) then Exit;
 result:=Link.Objects[Index];
end;

procedure TSubStringList.Insert(Index: Integer; const S: string);
begin
 if (Index<0) or (Index>=Link.Count) then Exit;
 Link.Insert(Index,s);
end;

function TSubStringList.IsGood: boolean;
begin
 result:=false;
 if Control=nil then Exit;
 if Control.Parent=nil then Exit;
 if not Control.Parent.HandleAllocated then Exit;
 result:=true;
end;

procedure TSubStringList.Put(Index: Integer; const S: String);
begin
 if (Index<0) or (Index>=Link.Count) then Exit;
 Link[Index]:=s;
end;

{ TNGCollection }

function TNGCollection.Add: TNGColumn;
Var
 x:integer;
begin
 result:=TNGColumn(inherited Add);
 x:=Result.Index;
 if x>0 then Result.RelativeWidth:=Items[x-1].RelativeWidth;
end;

constructor TNGCollection.Create(AGrid: TNewGrid);
begin
 Grid:=AGrid;
 inherited Create(TNGColumn);
end;

function TNGCollection.GetIam: TNGCollection;
begin
 result:=self;
end;

function TNGCollection.GetItems(x: integer): TNGColumn;
begin
 result:=nil;
 if (x<0) or (x>=Count) then Exit;
 result:=TNGColumn(inherited Items[x]);
end;

function TNGCollection.GetOwner: TPersistent;
begin
 result:=Grid;
end;

procedure TNGCollection.SetItems(x: integer; const Value: TNGColumn);
begin
 inherited Items[x]:=Value;
end;

procedure TNGCollection.Update(Item: TCollectionItem);
begin
 inherited;
 if Item=nil
  then Grid.UpdateColumns
  else Grid.UpdateColumn(Item.Index);
end;

initialization
 //LogFileName:='c:\III.xxx';
 //LogAutoSave:=true;
end.
