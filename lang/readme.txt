; ������ �������� ��������
; ������ ����� - ��� GUID - �����

;{9584DA04-FB4F-40c1-9325-E4F9CAAFCB5D}
[Contact window]
���� ��������
[Text insert]
������� ������
==============
�� �����������:
1)��������� ���������� ��� (���� ����) +����������
2)��������� ������ �������� � �� ������ - 
��� ����������������� �������� � ���� ������ ������ ������
------------------------
��� ��������� ����� ������������ (�� �����������)
1 - 2 comments 1 by 1
;{}
;{}

2 - several in one line
;{}{}
------------------------
������� ���������-��������:

function TranslateW(sz: PWideChar): PWideChar;
begin
  Result := PWideChar(PluginLink^.CallService(MS_LANGPACK_TRANSLATESTRING,
    LPHandle shl 16 + LANG_UNICODE, lParam(sz)));
end;

function TranslateDialogDefault(hwndDlg: THandle): int;
var
  lptd: TLANGPACKTRANSLATEDIALOG;
begin
  lptd.cbSize         := sizeof(lptd);
  lptd.flags          := 0;
  lptd.hwndDlg        := hwndDlg;
  lptd.ignoreControls := nil;
  Result := PluginLink^.CallService(MS_LANGPACK_TRANSLATEDIALOG, LPHandle shl 16, lParam(@lptd));
end;

�����������, ���� ����� � ������ �������� ���������� (LPHandle � ������),
���������������� ���������� ����� (������� - ������ ������������ �� ��������������� �,
� UUID, ������������ � PluginInfo

