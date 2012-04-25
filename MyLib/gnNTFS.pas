unit gnNTFS;

interface

implementation
(*
const
  SE_BACKUP_NAME = 'SeBackupPrivilege';

function NTSetPrivilege(sPrivilege:string;fEnabled:LongBool):boolean;
var hToken:THandle;
    TokenPriv,PrevTokenPriv:TOKEN_PRIVILEGES;
    PrivSet:PRIVILEGE_SET;
    f:LongBool;
    i:Cardinal;
begin
 Result:=false;
 if Win32Platform<>VER_PLATFORM_WIN32_NT then exit;
 PrivSet.PrivilegeCount:=1;
 PrivSet.Control:=0;
 PrivSet.Privilege[0].Attributes:=0;
 if LookupPrivilegeValue(nil,PChar(sPrivilege),PrivSet.Privilege[0].Luid) then
  if OpenProcessToken(GetCurrentProcess(),TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,hToken) then
   begin
    try
     if PrivilegeCheck(hToken,PrivSet,f)and(f<>fEnabled) then
      if LookupPrivilegeValue(nil,PChar(sPrivilege),TokenPriv.Privileges[0].Luid) then
       begin
        TokenPriv.PrivilegeCount:=1;
        if fEnabled then TokenPriv.Privileges[0].Attributes:=SE_PRIVILEGE_ENABLED else
         TokenPriv.Privileges[0].Attributes:=0;
        i:=0;
        PrevTokenPriv:=TokenPriv;
        AdjustTokenPrivileges(hToken,false,TokenPriv,SizeOf(PrevTokenPriv),PrevTokenPriv,i);
        Result:=GetLastError=ERROR_SUCCESS;
       end;
    except
    end;
    CloseHandle(hToken);
   end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var s:string;
begin
 NTSetPrivilege(SE_BACKUP_NAME,true);
 if InfoFileStreams('k:\memo.txt',false,s) then Memo1.Lines.Text:=s;
 //������� ������������ ������
 //if InfoFileStreams('k:\memo.txt',true,s) then Memo1.Lines.Text:=s;
end;

function InfoFileStreams(const FileName:String; Delete:Boolean; out RStreams:String):Boolean;
{������� ������:
- FileName: ��� �����/�����������.
- Delete: ���� Tru� ��... �� ���� ���� ��� � ������� "������������ ������" �����.
�������� ������:
- True: ���-�� ������ ���������� :)
- RStreams - ������������ ����}
const Error_Buffer_Overflow=$80000005;
type
 _IO_STATUS_BLOCK=packed record
   Status:DWord;
   Information:DWord;
 end;
 FILE_STREAM_INFORMATION=packed record 
   NextEntry:DWord;
   NameLength:DWord;
   Size:Int64;
   AllocationSize:Int64;
   Name:WideChar;
 end;
 _FILE_INFORMATION_CLASS=(FileDirectoryInformation=1,FileFullDirectoryInformation,
                          FileBothDirectoryInformation,FileBasicInformation,
                          FileStandardInformation,FileInternalInformation,
                          FileEaInformation,FileAccessInformation,FileNameInformation,
                          FileRenameInformation,FileLinkInformation,FileNamesInformation,
                          FileDispositionInformation,FilePositionInformation,FileFullEaInformation,
                          FileModeInformation,FileAlignmentInformation,FileAllInformation,
                          FileAllocationInformation,FileEndOfFileInformation,FileAlternateNameInformation,
                          FileStreamInformation,FilePipeInformation,FilePipeLocalInformation,
                          FilePipeRemoteInformation,FileMailslotQueryInformation,FileMailslotSetInformation,
                          FileCompressionInformation,FileObjectIdInformation,FileCompletionInformation,
                          FileMoveClusterInformation,FileQuotaInformation,FileReparsePointInformation,
                          FileNetworkOpenInformation,FileAttributeTagInformation,FileTrackingInformation,
                          FileMaximumInformation);
var NtQueryInformationFile: function (FileHandle:DWord; out IoStatusBlock: _IO_STATUS_BLOCK; FileInformation:Pointer; Length:DWord; FileInformationClass:_FILE_INFORMATION_CLASS):DWord; stdcall;
    fHandle:DWord;
    StreamIS:DWord;
    StreamInfo,tSI:^FILE_STREAM_INFORMATION;
    IoSB:_IO_STATUS_BLOCK;
    t:DWord;
    sN,sT:String;
    NextEntry,sM:Boolean;
begin
 Result:=false;
 NtQueryInformationFile:=GetProcAddress(GetModuleHandle('ntdll.dll'),'NtQueryInformationFile');
 if Assigned(NtQueryInformationFile)=false then exit;
 fHandle:=CreateFile(PChar(FileName),GENERIC_READ,FILE_SHARE_READ or FILE_SHARE_WRITE,nil,
                     OPEN_EXISTING,FILE_FLAG_BACKUP_SEMANTICS,0);
 if fHandle<>INVALID_HANDLE_VALUE then
  begin
   StreamIS:=0;
   GetMem(StreamInfo,StreamIS);
   repeat
    FreeMem(StreamInfo,StreamIS);
    StreamIS:=StreamIS+16384;
    GetMem(StreamInfo,StreamIS);
    t:=NtQueryInformationFile(fHandle,IoSB,StreamInfo,StreamIS,FileStreamInformation);
   until (t<>Error_Buffer_Overflow);
   if (t=0)and(IoSB.Information<>0) then
    begin
     tSI:=StreamInfo;
     sN:='';
     NextEntry:=True;
     Result:=true;
     sM:=false;
     while NextEntry do
      begin
       if tSI^.NextEntry=0 then NextEntry:=false;
       sT:=Copy(PWideChar(@tSI^.Name),0,tSI^.NameLength div SizeOf(WideChar));
       if (sM=false)and(AnsiCompareText(sT,'::$DATA')=0) then
        begin
         sM:=true;
         sN:=sN+'�������� �����: '+sT+'; ������: '+IntToStr(tSI^.Size)+' ����'+CRLF;
        end else
        begin
         sN:=sN+'������������ �����: '+sT+'; ������: '+IntToStr(tSI^.Size)+' ����'+CRLF;
         if Delete then
          if DeleteFile(FileName+sT) then sN:=sN+'������!'+CRLF;
        end;
       tSI:=Pointer(DWord(tSI)+tSI^.NextEntry);
      end;
     RStreams:=sN;
    end;
   FreeMem(StreamInfo,StreamIS);
   CloseHandle(fHandle);
  end;
end; *)
end.
