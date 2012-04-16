unit uPagePanel;

interface
uses Classes, Controls, Dialogs, Forms;
type
 TPagePanel=Class;
 ////////////////////// x //////////////////////
 TSheetPanel=Class(TWinControl)
 private
  FPagePanel:TPagePanel;
  FPageIndex: Integer;
  function GetIam: TSheetPanel;
  procedure SetPagePanel(const APagePanel: TPagePanel);
 protected
  property PageIndex:Integer read FPageIndex;
  procedure ReadState(Reader: TReader); override;
 public
  constructor Create(AOwner: TComponent); override;
  destructor Destroy; override;
  property Iam:TSheetPanel read GetIam;
  property PagePanel:TPagePanel read FPagePanel write SetPagePanel;
 End;
 ////////////////////// x //////////////////////
 TPagePanel=Class(TWinControl)
 private
  FActivePage: TSheetPanel;
  FPages: TList;
  FActivePageIndex: Integer;
  procedure SetActivePage(const Value: TSheetPanel);
  function GetIam: TPagePanel;
  function GetPages(index: Integer): TSheetPanel;
  function FindNextPage(CurPage: TSheetPanel; GoForward: Boolean): TSheetPanel;
  function GetPageCount: Integer;
  procedure SetActivePageIndex(const Value: Integer);
 protected
  procedure ShowControl(AControl: TControl); override;
 public
  constructor Create(AOwner: TComponent); override;
  destructor Destroy; override;
  procedure RemovePage(ASheet:TSheetPanel);
  procedure InsertPage(ASheet:TSheetPanel);
  property Iam:TPagePanel read GetIam;
  property PageCount:Integer read GetPageCount;
  property Pages[index:Integer]:TSheetPanel read GetPages;
  property ActivePageIndex:Integer read FActivePageIndex write SetActivePageIndex;
 published
  property ActivePage:TSheetPanel read FActivePage write SetActivePage;
  property Align;
 End;
implementation

uses SysUtils;

{ TPagePanel }

constructor TPagePanel.Create(AOwner: TComponent);
begin
 inherited;
 Width := 289;
 Height := 193;
 ControlStyle := [csDoubleClicks, csOpaque];
 FPages := TList.Create;
end;

destructor TPagePanel.Destroy;
var
  I: Integer;
begin
 for I := 0 to FPages.Count - 1 do TSheetPanel(FPages[I]).FPagePanel := nil;
 FPages.Free;
 inherited Destroy;
end;

function TPagePanel.FindNextPage(CurPage: TSheetPanel; GoForward: Boolean): TSheetPanel;
var
 I, StartIndex: Integer;
begin
 Result:=nil;
 if FPages.Count<>0 then begin
  StartIndex:=FPages.IndexOf(CurPage);
  if StartIndex=-1 then
   if GoForward then StartIndex:=FPages.Count - 1 else StartIndex:=0;
  I:=StartIndex;
  if GoForward then begin
   Inc(I);
   if I=FPages.Count then I:=0;
  end else begin
   if I=0 then I:=FPages.Count;
   Dec(I);
  end;
  Result:=FPages[I];
 end;
end;

function TPagePanel.GetIam: TPagePanel;
begin
 result:=self;
end;

function TPagePanel.GetPageCount: Integer;
begin
 Result:=FPages.Count;
end;

function TPagePanel.GetPages(index: Integer): TSheetPanel;
begin
 result:=nil;
 if (index<0) or (index>=PageCount) then Exit;
 result:=FPages[Index];
end;

procedure TPagePanel.InsertPage(ASheet: TSheetPanel);
begin
 ASheet.FPageIndex:=FPages.Add(ASheet);
 ASheet.FPagePanel:=Self;
end;

procedure TPagePanel.RemovePage(ASheet: TSheetPanel);
var
 NextSheet: TSheetPanel;
 i:Integer;
begin
 NextSheet:=FindNextPage(ASheet, True);
 if NextSheet=ASheet then NextSheet:=nil;
 ASheet.FPagePanel:=nil;
 FPages.Remove(ASheet);
 For i:=0 to FPages.Count-1 do TSheetPanel(FPages[i]).FPageIndex:=i;
 SetActivePage(NextSheet);
end;

procedure TPagePanel.SetActivePage(const Value: TSheetPanel);
begin
 if (Value<>nil) and (Value.PagePanel<>self) then Exit;
 if ActivePage=Value then Exit;
 if FActivePage<>nil then FActivePage.Visible:=false;
 FActivePage:=Value;
 if Value=nil
 then FActivePageIndex:=-1
 else FActivePageIndex:=Value.PageIndex;
 if FActivePage<>nil then FActivePage.Visible:=true;
end;

procedure TPagePanel.SetActivePageIndex(const Value: Integer);
begin
 if (Value<0) or (Value>=FPages.Count) then Exit;
 ActivePage:=TSheetPanel(FPages[Value]);
end;

procedure TPagePanel.ShowControl(AControl: TControl);
begin
 if AControl is TSheetPanel then SetActivePage(TSheetPanel(AControl));
 inherited ShowControl(AControl);
end;

{ TSheetPanel }

constructor TSheetPanel.Create(AOwner: TComponent);
begin
 inherited;
 Align:=alClient;
 ControlStyle:=ControlStyle+[csAcceptsControls,csNoDesignVisible,csParentBackground];
 Visible:=False;
end;

destructor TSheetPanel.Destroy;
begin
 if FPagePanel <> nil then FPagePanel.RemovePage(Self);
 inherited Destroy;
end;

function TSheetPanel.GetIam: TSheetPanel;
begin
 result:=self;
end;

procedure TSheetPanel.ReadState(Reader: TReader);
begin
  inherited ReadState(Reader);
  if Reader.Parent is TPagePanel then
   PagePanel:=TPagePanel(Reader.Parent);
end;

procedure TSheetPanel.SetPagePanel(const APagePanel: TPagePanel);
begin
 if FPagePanel<>APagePanel then
 begin
  if FPagePanel<>nil then FPagePanel.RemovePage(Self);
  Parent:=APagePanel;
  if APagePanel<>nil then APagePanel.InsertPage(Self);
 end;
end;

end.
