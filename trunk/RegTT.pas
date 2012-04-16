unit RegTT;

interface
procedure Register;
implementation
uses Classes, SbjGrd, SbjCmd, SbjSrc, SbjLst, SbjPlug, SbjManager;
{$R Icons.res}
procedure Register;
begin
 RegisterNoIcon([TSubjImageList]);
 RegisterComponents('TimeTable', [TSubjSource, TSubjList, TSubjGrid,
                                 TSubjCmds, TSubjPluginSupport, TSubjManager
]);
end;

end.

