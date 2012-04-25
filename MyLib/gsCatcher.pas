unit gsCatcher;

//**! ----------------------------------------------------------
//**! This unit is a part of GSPackage project (Gregory Sitnin's
//**! Delphi Components Package).
//**! ----------------------------------------------------------
//**! You may use or redistribute this unit for your purposes
//**! while unit's code and this copyright notice is unchanged
//**! and exists.
//**! ----------------------------------------------------------
//**! (c) Gregory Sitnin, 2001-2002. All rights reserved.
//**! ----------------------------------------------------------

{***} interface {***}

uses Classes, SysUtils, JPEG;

type
  TgsCatcher = class(TComponent)
  private
    FEnabled: boolean;
    FGenerateScreenshot: boolean;
    FJpegQuality: TJPEGQualityRange;
    FCollectInfo: boolean;
    Fn: TFilename;
    procedure SetEnabled(const Value: boolean);
    procedure DoGenerateScreenshot;
    procedure DoCollectInfo(E: Exception);
    function ComputerName: string;
    function UserName: string;
    procedure SetGenerateScreenshot(const Value: boolean);
    procedure SetJpegQuality(const Value: TJPEGQualityRange);
    procedure SetCollectInfo(const Value: boolean);
    { Private declarations }
  protected
    { Protected declarations }
    procedure EnableCatcher;
    procedure DisableCatcher;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Catcher(Sender: TObject; E: Exception);
  published
    { Published declarations }
    property Enabled: boolean read FEnabled write SetEnabled
                      default False;
    property GenerateScreenshot: boolean read FGenerateScreenshot write SetGenerateScreenshot;
    property JpegQuality: TJPEGQualityRange read FJpegQuality write SetJpegQuality;
    property CollectInfo: boolean read FCollectInfo write SetCollectInfo;
  end;

procedure Register;

{***} implementation {***}

uses Windows, Forms, Dialogs, Graphics;

procedure Register;
begin
  RegisterComponents('Nail', [TgsCatcher]);
end;

{ TgsCatcher }
constructor TgsCatcher.Create(AOwner: TComponent);
begin
  inherited;
end;

destructor TgsCatcher.Destroy;
begin
  DisableCatcher;
  inherited;
end;

procedure TgsCatcher.SetEnabled(const Value: boolean);
begin
  FEnabled := Value;
  if Enabled then EnableCatcher else DisableCatcher;
end;

procedure TgsCatcher.DisableCatcher;
begin
  Application.OnException := nil;
end;

procedure TgsCatcher.EnableCatcher;
begin
  Application.OnException := Catcher;
end;

procedure TgsCatcher.Catcher(Sender: TObject; E: Exception);
Var
 FTemp: array[0..MAX_PATH] of Char;
 s:string;
begin
 GetTempPath(MAX_PATH,FTemp);
 s:=StrPas(FTemp)+'A';
 Fn := ExtractFilename(Application.ExeName)+'_'+
       Screen.ActiveForm.Name+
       FormatDateTime('_ddmmyyyy_hhnnss',now);
 if GenerateScreenshot then  DoGenerateScreenshot;
 if CollectInfo then DoCollectInfo(E);
end;

procedure TgsCatcher.DoGenerateScreenshot;
var bmp: TBitmap;
    jpg: TJPEGImage;
begin
  bmp := Screen.ActiveForm.GetFormImage;
  begin
    jpg := TJPEGImage.Create;
    jpg.CompressionQuality := JpegQuality;
    jpg.Assign(bmp);
    jpg.SaveToFile(fn+'.jpg');
    FreeAndNil(jpg);
  end;
  FreeAndNil(bmp);
end;

function TgsCatcher.ComputerName: string;
var
  cname: pchar;
  cnsiz: cardinal;
begin
  cname := StrAlloc(MAX_COMPUTERNAME_LENGTH + 1);
  cnsiz := MAX_COMPUTERNAME_LENGTH + 1;
  GetComputerName(cname,cnsiz);
  if (cnsiz > 0) then
    Result := string(cname) else
    Result := 'n/a';
  StrDispose(cname);
end;

procedure TgsCatcher.DoCollectInfo(E: Exception);
var sl: TStringList;
begin
  sl := tstringlist.Create;
  sl.add('--- This report is created by automated '+
         'reporting system.');
  sl.add('Computer name is: ['+ComputerName+']');
  sl.add('User name is: ['+UserName+']');
  sl.add('Exception text is: ['+E.Message+']');
  sl.add('--- End of report ----------------------'+
         '-----------------');
  sl.SaveToFile(Fn+'.txt');
end;

function TgsCatcher.UserName: string;
var
  uname: pchar;
  unsiz: cardinal;
begin
  uname := StrAlloc(255);
  unsiz := 254;
  GetUserName(uname,unsiz);
  if (unsiz > 0) then
    Result := string(uname) else
    Result := 'n/a';
  StrDispose(uname);
end;

procedure TgsCatcher.SetGenerateScreenshot(const Value: boolean);
begin
 FGenerateScreenshot := Value;
end;

procedure TgsCatcher.SetJpegQuality(const Value: TJPEGQualityRange);
begin
  FJpegQuality := Value;
end;

procedure TgsCatcher.SetCollectInfo(const Value: boolean);
begin
  FCollectInfo := Value;
end;

end.


