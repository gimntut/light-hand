unit MyDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TDialog = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnCancel: TButton;
    btnOK: TButton;
  private
  protected
    procedure DoBeforeExecute; virtual;
    procedure DoAfterExecute; virtual;
  public
    function Execute:Boolean;
  end;

var
  Dialog: TDialog;

implementation

{$R *.dfm}

{ TDialog }

function TDialog.Execute: Boolean;
begin
  DoBeforeExecute;
  Result := ShowModal = mrOk;
  DoAfterExecute;
end;

procedure TDialog.DoAfterExecute;
begin
  Caption := '';
end;

procedure TDialog.DoBeforeExecute;
begin
end;

end.
