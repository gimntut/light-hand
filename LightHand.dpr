program LightHand;

{%File 'History.txt'}
{%ToDo 'LightHand.todo'}

uses
  Forms,
  TableUnit in 'TableUnit.pas' {TableForm},
  SbjKernel in 'SbjKernel.pas',
  SbjColl in 'SbjColl.pas',
  SbjResource in 'SbjResource.pas',
  Servis in 'Servis.pas' {ServisDlg},
  publ in 'MyLib\publ.pas',
  MyDialog in 'MyDialog.pas' {Dialog},
  MyLists in 'MyLib\MyLists.pas',
  PublGraph in 'MyLib\PublGraph.pas',
  PublMath in 'MyLib\PublMath.pas',
  UQPixels in 'MyLib\UQPixels.pas',
  uPagePanel in 'MyLib\uPagePanel.pas';

{$R *.res}

begin
  //Protect;
  Application.Initialize;
  Application.Title := 'Расписание';
  Application.CreateForm(TTableForm, TableForm);
  Application.CreateForm(TServisDlg, ServisDlg);
  Application.CreateForm(TDialog, Dialog);
  Application.Run;
end.
