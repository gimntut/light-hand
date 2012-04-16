unit Servis;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TServisDlg = class (TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ServisDlg: TServisDlg;

implementation

{$R *.dfm}

procedure TServisDlg.Button1Click(Sender: TObject);
Var
  op: TOpenDialog;
  bm1, bm2: TBitmap;
  s: string;
  i, j, n, m: integer;
  rs, rd: TRect;
begin
  op := TOpenDialog.Create(nil);
  With Op do Begin
    if Execute then Begin
      bm1 := TBitmap.Create;
      bm2 := TBitmap.Create;
      s := FileName;
      bm1.LoadFromFile(s);
      n := bm1.Width div 16;
      m := bm1.Height div 16;
      bm2.Width := n * m * 16;
      bm2.Height := 16;
      For i := 0 to n - 1 do
        For j := 0 to m - 1 do Begin
          rs := Rect(i * 16, j * 16, i * 16 + 16, j * 16 + 16);
          rd := Rect((j * n + i) * 16, 0, (j * n + i + 1) * 16, 16);
          bm2.Canvas.CopyRect(rd, bm1.Canvas, rs);
        End;
      s := ChangeFileExt(s, 'Old.bmp');
      bm1.SaveToFile(s);
      bm2.SaveToFile(FileName);
      bm1.Free;
      bm2.Free;
    End;
    op.Free;
  End;
end;

procedure TServisDlg.Button2Click(Sender: TObject);
begin
  Close;
end;

end.
