{variables}
var
  SongInfoA:tSongInfoA;
  SongInfo :tSongInfo;
  WorkSI   :tSongInfo;
const
  LastStatus:integer = WAT_PLS_NOTFOUND;
var
  hEvent:THANDLE;
  hINS,
  hGFI,
  hWI,
  hGMI,
  hPS,
  hPB,
  hWATI,
  hWC,
  hFMT,
  hPLR,
  hRGS,
  wsic,
  hHookWATLoaded:THANDLE;
  opthook:cardinal;
  onloadhook:cardinal;
  hHookShutdown:cardinal;
  inshotkey:cardinal;
  globhotkey:cardinal;
  hTimer:cardinal;
  ttbState,
  hMenuDisable:THANDLE;
var
  CoverPaths:PWideChar;
  MTHCheck,
  KeepOld,
  UseImplant,
  CheckAll,
  CheckTime:dword;
  mmkeyemu: dword;
  mTimer:dword;
  TimeoutForThread:cardinal;
var
  HiddenOption:dword;