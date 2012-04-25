unit WinRar;

interface
type
 TWinRar=Class
  private
    FExists: boolean;
 public
  property Exists:boolean read FExists;
  procedure EMail(Path,Address:string);
 End;
implementation

{ TWinRar }

procedure TWinRar.EMail(Path, Address: string);
begin

end;

end.
