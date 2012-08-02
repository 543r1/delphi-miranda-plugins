(*
    History++ plugin for Miranda IM: the free IM client for Microsoft* Windows*

    Copyright (C) 2006-2009 theMIROn, 2003-2006 Art Fedorov.
    History+ parts (C) 2001 Christian Kastner

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*)

{-----------------------------------------------------------------------------
 hpp_global.pas (historypp project)

 Version:   1.5
 Created:   30.01.2006
 Author:    Oxygen

 [ Description ]

 After some refactoring, caused by dp_events, had to bring
 THistoryItem record into independant unit, so we don't have
 silly dependances of HisotoryGrid on dp_events (HistoryGrid
 doesn't depend on Miranda!) or dp_events on HistoryGrid (such
 a hog!)


 [ History ]

 1.5 (30.01.2006)
   First version

 [ Modifications ]
 none

 [ Known Issues ]
 none

 Contributors: theMIROn
-----------------------------------------------------------------------------}

unit hpp_global;

interface

uses
  Windows,Messages,
  kol,m_api;

// KOL unit needs for this type only
type
  TFont = KOL.TGraphicTool;
  PFont = ^TFont;
type

  // note: add new message types to the end, or it will mess users' saved filters
  //       don't worry about customization filters dialog, as mtOther will always
  //       be show as the last entry
  TMessageType = (mtUnknown,
                  mtIncoming, mtOutgoing,
                  mtMessage, mtUrl, mtFile, mtSystem,
                  mtContacts, mtSMS, mtWebPager, mtEmailExpress, mtStatus, mtSMTPSimple,
                  mtOther,
                  mtNickChange,mtAvatarChange,mtWATrack,mtStatusMessage,mtVoiceCall,mtCustom);

  PMessageTypes = ^TMessageTypes;
  TMessageTypes = set of TMessageType;

  TRTLMode = (hppRTLDefault,hppRTLEnable,hppRTLDisable);

  PHistoryItem = ^THistoryItem;
  THistoryItem = record
    Time        : DWord;
    MessageType : TMessageTypes;
    EventType   : Word;
    Height      : Integer;
    Module      : AnsiString;
    Proto       : AnsiString;
    Text        : WideString;
    CodePage    : Cardinal;
    RTLMode     : TRTLMode;
    HasHeader   : Boolean;    // header for sessions
    LinkedToPrev: Boolean;    // for future use to group messages from one contact together
    Bookmarked  : Boolean;
    IsRead      : Boolean;
    Extended    : AnsiString;
  end;

  TCodePage = record
    cp: Cardinal;
    lid: LCID;
    name: WideString;
  end;

  TSaveFormat = (sfAll,sfHTML,sfXML,sfRTF,sfMContacts,sfUnicode,sfText);
  TSaveFormats = set of TSaveFormat;
  TSaveStage = (ssInit,ssDone);

  TWideStrArray = array of WideString;
  TIntArray = array of Integer;

  TSendMethod = (smSend,smPost);

  TUrlProto = record
    Proto: PWideChar;
    Idn  : Boolean;
  end;

const
  HM_BASE = WM_APP + 10214; // (+$27E6) base for all history++ messages
  HM_HIST_BASE = HM_BASE + 100; // base for contact's history specific messages
  HM_SRCH_BASE = HM_BASE + 200; // base for global search specific messages
  HM_SESS_BASE = HM_BASE + 300; // base for session thread specific messages
  HM_STRD_BASE = HM_BASE + 400; // base for search thread specific messages
  HM_NOTF_BASE = HM_BASE + 500; // base for plugin-wide notification messages
  HM_MIEV_BASE = HM_BASE + 600; // base for miranda event messages

  // HistoryGrid messages:
  HM_HG_OPTIONS     = HM_BASE + 1; // HistoryGrid options changed. wParam - HGOPT_* flags
  HM_HG_CACHEUPDATE = HM_BASE + 2; // Need to update RichItem cache element. lParam - RichItem?

  // notification messages:
  HM_NOTF_ICONSCHANGED    = HM_NOTF_BASE + 1; // Skin icons has changed
  HM_NOTF_ICONS2CHANGED   = HM_NOTF_BASE + 2; // IcoLib icons has changed
  HM_NOTF_FILTERSCHANGED  = HM_NOTF_BASE + 3; // Filters has changed
  HM_NOTF_TOOLBARCHANGED  = HM_NOTF_BASE + 4; // Toolbar has changed
  HM_NOTF_BOOKMARKCHANGED = HM_NOTF_BASE + 5; // Bookmarks has changed
  HM_NOTF_ACCCHANGED      = HM_NOTF_BASE + 6; // Accessability prefs changed (menu toggle)
  HM_NOTF_NICKCHANGED     = HM_NOTF_BASE + 7; // Nick changed

  // miranda events
  HM_MIEV_EVENTADDED      = HM_MIEV_BASE + 1; // ME_DB_EVENT_ADDED
  HM_MIEV_EVENTDELETED    = HM_MIEV_BASE + 2; // ME_DB_EVENT_DELETED
  HM_MIEV_PRESHUTDOWN     = HM_MIEV_BASE + 3; // ME_SYSTEM_PRESHUTDOWN
  HM_MIEV_CONTACTDELETED  = HM_MIEV_BASE + 4; // ME_DB_CONTACT_DELETED
  HM_MIEV_METADEFCHANGED  = HM_MIEV_BASE + 5; // ME_MC_DEFAULTTCHANGED

const
  ME_HPP_OPTIONSCHANGED = 'History++/OptionsChanged';
const
  // History Grid options flags
  HGOPT_TEMPLATES   = $0001; // templates, datetime format
  HGOPT_FONTSERVICE = $0002; // fonts, colors
  HGOPT_ITEMS       = $0004; // close to HGOPT_FONTSERVICE
  HGOPT_OPTIONS     = $0008; // inline,RTL, externals,bbcodes
  HGOPT_ALL         = $00FF;

const
  hppName       = 'History++';
  hppShortName  = 'History++ (2in1)';
  hppShortNameV = hppShortName{$IFDEF ALPHA}+' [alpha '+{$I 'alpha.inc'}+']'{$ENDIF};
  hppDBName     = 'HistoryPlusPlus';
  hppVerMajor   = {MAJOR_VER}1{/MAJOR_VER};
  hppVerMinor   = {MINOR_VER}5{/MINOR_VER};
  hppVerRelease = {SUB_VER}1{/SUB_VER};
  hppVerBuild   = {BUILD}5{/BUILD};
  hppVerAlpha   = {$IFDEF ALPHA}True{$ELSE}False{$ENDIF};
  hppVersion    = hppVerMajor shl 24 + hppVerMinor shl 16 + hppVerRelease shl 8 + hppVerBuild;

  MIID_HISTORYPP:TGUID = '{B92282AC-686B-4541-A12D-6E9971A253B7}';

  hppDescription = 'Easy, fast and feature complete history viewer.';
  hppAuthor      = 'theMIROn, Art Fedorov';
  hppAuthorEmail = 'themiron@mail.ru, artemf@mail.ru';
  hppCopyright   = '� 2006-2009 theMIROn, 2003-2006 Art Fedorov. History+ parts � 2001 Christian Kastner';

  hppHomePageURL  = 'http://themiron.miranda.im/';
  hppChangelogURL = 'http://themiron.miranda.im/changelog';

  hppIPName     = 'historypp_icons.dll';

  hppLoadBlock  = 4096;
  hppFirstLoadBlock = 200;

  cpTable: array[0..14] of TCodePage = (
    (cp:  874; lid: $041E; name: 'Thai'),
    (cp:  932; lid: $0411; name: 'Japanese'),
    (cp:  936; lid: $0804; name: 'Simplified Chinese'),
    (cp:  949; lid: $0412; name: 'Korean'),
    (cp:  950; lid: $0404; name: 'Traditional Chinese'),
    (cp: 1250; lid: $0405; name: 'Central European'),
    (cp: 1251; lid: $0419; name: 'Cyrillic'),
    (cp: 1252; lid: $0409; name: 'Latin I'),
    (cp: 1253; lid: $0408; name: 'Greek'),
    (cp: 1254; lid: $041F; name: 'Turkish'),
    (cp: 1255; lid: $040D; name: 'Hebrew'),
    (cp: 1256; lid: $0801; name: 'Arabic'),
    (cp: 1257; lid: $0425; name: 'Baltic'),
    (cp: 1258; lid: $042A; name: 'Vietnamese'),
    (cp: 1361; lid: $0412; name: 'Korean (Johab)'));

const
  HPP_ICON_CONTACTHISTORY    = 0;
  HPP_ICON_GLOBALSEARCH      = 1;
  HPP_ICON_SESS_DIVIDER      = 2;
  HPP_ICON_SESSION           = 3;
  HPP_ICON_SESS_SUMMER       = 4;
  HPP_ICON_SESS_AUTUMN       = 5;
  HPP_ICON_SESS_WINTER       = 6;
  HPP_ICON_SESS_SPRING       = 7;
  HPP_ICON_SESS_YEAR         = 8;
  HPP_ICON_HOTFILTER         = 9;
  HPP_ICON_HOTFILTERWAIT     = 10;
  HPP_ICON_SEARCH_ALLRESULTS = 11;
  HPP_ICON_TOOL_SAVEALL      = 12;
  HPP_ICON_HOTSEARCH         = 13;
  HPP_ICON_SEARCHUP          = 14;
  HPP_ICON_SEARCHDOWN        = 15;
  HPP_ICON_TOOL_DELETEALL    = 16;
  HPP_ICON_TOOL_DELETE       = 17;
  HPP_ICON_TOOL_SESSIONS     = 18;
  HPP_ICON_TOOL_SAVE         = 19;
  HPP_ICON_TOOL_COPY         = 20;
  HPP_ICON_SEARCH_ENDOFPAGE  = 21;
  HPP_ICON_SEARCH_NOTFOUND   = 22;
  HPP_ICON_HOTFILTERCLEAR    = 23;
  HPP_ICON_SESS_HIDE         = 24;
  HPP_ICON_DROPDOWNARROW     = 25;
  HPP_ICON_CONTACDETAILS     = 26;
  HPP_ICON_CONTACTMENU       = 27;
  HPP_ICON_BOOKMARK          = 28;
  HPP_ICON_BOOKMARK_ON       = 29;
  HPP_ICON_BOOKMARK_OFF      = 30;
  HPP_ICON_SEARCHADVANCED    = 31;
  HPP_ICON_SEARCHRANGE       = 32;
  HPP_ICON_SEARCHPROTECTED   = 33;

  HPP_ICON_EVENT_INCOMING    = 34;
  HPP_ICON_EVENT_OUTGOING    = 35;
  HPP_ICON_EVENT_SYSTEM      = 36;
  HPP_ICON_EVENT_CONTACTS    = 37;
  HPP_ICON_EVENT_SMS         = 38;
  HPP_ICON_EVENT_WEBPAGER    = 39;
  HPP_ICON_EVENT_EEXPRESS    = 40;
  HPP_ICON_EVENT_STATUS      = 41;
  HPP_ICON_EVENT_SMTPSIMPLE  = 42;
  HPP_ICON_EVENT_NICK        = 43;
  HPP_ICON_EVENT_AVATAR      = 44;
  HPP_ICON_EVENT_WATRACK     = 45;
  HPP_ICON_EVENT_STATUSMES   = 46;
  HPP_ICON_EVENT_VOICECALL   = 47;

  HppIconsCount              = 48;

  HPP_SKIN_EVENT_MESSAGE     = 0;
  HPP_SKIN_EVENT_URL         = 1;
  HPP_SKIN_EVENT_FILE        = 2;
  HPP_SKIN_OTHER_MIRANDA     = 3;

  SkinIconsCount             = 4;

const
  UrlPrefix: array[0..1] of WideString = (
    'www.',
    'ftp.');
  UrlProto: array[0..12] of TUrlProto = (
    (Proto: 'http:/';     Idn: True;),
    (Proto: 'ftp:/';      Idn: True;),
    (Proto: 'file:/';     Idn: False;),
    (Proto: 'mailto:/';   Idn: False;),
    (Proto: 'https:/';    Idn: True;),
    (Proto: 'gopher:/';   Idn: False;),
    (Proto: 'nntp:/';     Idn: False;),
    (Proto: 'prospero:/'; Idn: False;),
    (Proto: 'telnet:/';   Idn: False;),
    (Proto: 'news:/';     Idn: False;),
    (Proto: 'wais:/';     Idn: False;),
    (Proto: 'outlook:/';  Idn: False;),
    (Proto: 'callto:/';   Idn: False;));

var
  hppCodepage: Cardinal;
  hppRichEditVersion: Integer;

{$I m_historypp.inc}

function MessageTypesToDWord(mt: TMessageTypes): DWord;
function TimestampToDateTime(const Timestamp: DWord): TDateTime;

function AnsiToWideString(const S: AnsiString; CodePage: Cardinal; InLength: Integer = -1): WideString;
function WideToAnsiString(const WS: WideString; CodePage: Cardinal; InLength: Integer = -1): AnsiString;
function TranslateAnsiW(const S: AnsiString{TRANSLATE-IGNORE}): WideString;
procedure CopyToClip(const WideStr: WideString; Handle: Hwnd; CodePage: Cardinal = CP_ACP; Clear: Boolean = True);

procedure OpenUrl(const URLText: WideString; NewWindow: Boolean);

function HppMessageBox(Handle: THandle; const Text: WideString; const Caption: WideString; Flags: Integer): Integer;

function FormatCString(const Text: WideString): WideString;
function PassMessage(Handle: THandle; Message: DWord; wParam: WPARAM; lParam: LPARAM; Method: TSendMethod = smSend): Boolean;

//----- added from TNT ------
function IsRTF(const Value: WideString): Boolean;

function IsWideCharUpper(WC: WideChar): Boolean;
function IsWideCharLower(WC: WideChar): Boolean;
function IsWideCharDigit(WC: WideChar): Boolean;
function IsWideCharSpace(WC: WideChar): Boolean;
function IsWideCharPunct(WC: WideChar): Boolean;
function IsWideCharCntrl(WC: WideChar): Boolean;
function IsWideCharBlank(WC: WideChar): Boolean;
function IsWideCharXDigit(WC: WideChar): Boolean;
function IsWideCharAlpha(WC: WideChar): Boolean;
function IsWideCharAlphaNumeric(WC: WideChar): Boolean;

//----- from SysUtils -----
type
  TReplaceFlags = set of (rfReplaceAll, rfIgnoreCase);

function StringReplace(const S, OldPattern, NewPattern: WideString; Flags: TReplaceFlags): WideString;


type
  THppBuffer = class
  private
    FBuffer: Pointer;
    FSize: Integer;
    FCallCount: Integer;
    FLock: TRTLCriticalSection;
  protected
    procedure Shrink;
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;
    function Reallocate(NewSize: Integer): Integer;
    function Allocate(NewSize: Integer): Integer;
    procedure Lock;
    procedure Unlock;
    property Buffer: Pointer read FBuffer;
    property Size: Integer read FSize;
  end;


implementation

uses common;

function MessageTypesToDWord(mt: TMessageTypes): DWord;
begin
  Result := 0;
  Move(mt,Result,SizeOf(mt));
end;

const
  // 1970-01-01T00:00:00 in TDateTime
  UnixTimeStart = 25569;
  SecondsPerDay = 60*60*24;

function TimestampToDateTime(const Timestamp: DWord): TDateTime;
begin
  Result := UnixTimeStart +
    CallService(MS_DB_TIME_TIMESTAMPTOLOCAL,WPARAM(Timestamp),0) / SecondsPerDay;
end;

procedure OpenUrl(const URLText: WideString; NewWindow: Boolean);
begin
  CallService(MS_UTILS_OPENURL,OUF_UNICODE + WPARAM(NewWindow),LPARAM(@URLText[1]));
end;

function AnsiToWideString(const S: AnsiString; CodePage: Cardinal; InLength: Integer = -1): WideString;
var
  InputLength,
  OutputLength: Integer;
  pcw:pWideChar;
begin
  Result := '';
  if S = '' then
    exit;
  if CodePage = CP_UTF8 then
  begin
    pcw := mir_utf8decodew(PAnsiChar(S));
    Result := Widestring(pcw);
    mir_free(pcw);
//    Result := UTF8ToWideString(S); // CP_UTF8 not supported on Windows 95
  end
  else
  begin
    if InLength < 0 then
      InputLength := Length(S)
    else
      InputLength := InLength;
    OutputLength := MultiByteToWideChar(CodePage, 0, PAnsiChar(S), InputLength, nil, 0);
    SetLength(Result, OutputLength);
    MultiByteToWideChar(CodePage, MB_PRECOMPOSED, PAnsiChar(S), InputLength, PWideChar(Result),
      OutputLength);
  end;
end;

function WideToAnsiString(const WS: WideString; CodePage: Cardinal; InLength: Integer = -1): AnsiString;
var
  InputLength,
  OutputLength: Integer;
  pc:PAnsiChar;
begin
  Result := '';
  if WS = '' then
    exit;
  if CodePage = CP_UTF8 then
  begin
    pc := mir_utf8encodew(PWideChar(WS));
    Result := AnsiString(pc);
    mir_free(pc);
//    Result := UTF8Encode(WS) // CP_UTF8 not supported on Windows 95
  end
  else
  begin
    if InLength < 0 then
      InputLength := Length(WS)
    else
      InputLength := InLength;
    OutputLength := WideCharToMultiByte(CodePage, 0, PWideChar(WS), InputLength, nil, 0,
      nil, nil);
    SetLength(Result, OutputLength);
    WideCharToMultiByte(CodePage, 0, PWideChar(WS), InputLength, PAnsiChar(Result),
      OutputLength, nil, nil);
  end;
end;

function TranslateAnsiW(const S: AnsiString{TRANSLATE-IGNORE}): WideString;
begin
  Result := AnsiToWideString(Translate(PAnsiChar(S)),hppCodepage{TRANSLATE-IGNORE});
end;


function GetLCIDfromCodepage(Codepage: Cardinal): LCID;
var
  i: integer;
begin
  if Codepage = CP_ACP then
    Codepage := GetACP;
  for i := 0 to High(cpTable) do
    if cpTable[i].cp = Codepage then
    begin
      Result := cpTable[i].lid;
      exit;
    end;
{
  for i := 0 to Languages.Count - 1 do
    if Cardinal(LCIDToCodePage(Languages.LocaleID[i])) = Codepage then
    begin
      Result := Languages.LocaleID[i];
      exit;
    end;
}
  Result := $0405;
end;

procedure CopyToClip(const WideStr: WideString; Handle: Hwnd; CodePage: Cardinal = CP_ACP; Clear: Boolean = True);
var
  WData, AData, LData: THandle;
  LDataPtr: ^Cardinal;
  WDataPtr: PWideChar;
  ADataPtr: PAnsiChar;
  ASize,WSize: Integer;
  AnsiStr: AnsiString;
begin
  WSize := (Length(WideStr)+1)*SizeOf(WideChar);
  if WSize = SizeOf(WideChar) then exit;
  AnsiStr := WideToAnsiString(WideStr,CodePage);
  ASize := Length(AnsiStr)+1;
  OpenClipboard(Handle);
  try
    if Clear then EmptyClipboard;
    WData := GlobalAlloc(GMEM_MOVEABLE+GMEM_DDESHARE, WSize);
    AData := GlobalAlloc(GMEM_MOVEABLE+GMEM_DDESHARE, ASize);
    LData := GlobalAlloc(GMEM_MOVEABLE+GMEM_DDESHARE, SizeOf(Cardinal));
    try
      WDataPtr := GlobalLock(WData);
      ADataPtr := GlobalLock(AData);
      LDataPtr := GlobalLock(LData);
      try
        Move(WideStr[1],WDataPtr^,WSize);
        Move(AnsiStr[1],ADataPtr^,ASize);
        LDataPtr^ := GetLCIDfromCodepage(CodePage);
        SetClipboardData(CF_UNICODETEXT, WData);
        SetClipboardData(CF_TEXT, AData);
        SetClipboardData(CF_LOCALE, LData);
      finally
        GlobalUnlock(WData);
        GlobalUnlock(AData);
        GlobalUnlock(LData);
      end;
    except
      GlobalFree(WData);
      GlobalFree(AData);
      GlobalFree(LData);
    raise;
    end;
  finally
    CloseClipBoard;
  end;
end;

function HppMessageBox(Handle: THandle; const Text: WideString; const Caption: WideString; Flags: Integer): Integer;
begin
  Result := MessageBoxW(Handle,PWideChar(Text),PWideChar(Caption),Flags);
end;

function FormatCString(const Text: WideString): WideString;
var
  inlen,inpos,outpos: integer;
begin
  inlen := Length(Text);
  SetLength(Result,inlen);
  if inlen = 0 then exit;
  inpos := 1;
  outpos := 0;
  while inpos <= inlen do begin
    inc(outpos);
    if (Text[inpos] = '\') and (inpos < inlen) then begin
      case Text[inpos+1] of
        'r': begin Result[outpos] := #13; inc(inpos); end;
        'n': begin Result[outpos] := #10; inc(inpos); end;
        't': begin Result[outpos] := #09; inc(inpos); end;
        '\': begin Result[outpos] := '\'; inc(inpos); end;
      else         Result[outpos] := Text[inpos];
      end;
    end else
      Result[outpos] := Text[inpos];
    inc(inpos);
  end;
  SetLength(Result,outpos);
end;

function PassMessage(Handle: THandle; Message: DWord; wParam: WPARAM; lParam: LPARAM; Method: TSendMethod = smSend): Boolean;
var
  Tries: integer;
begin
  Result := True;
  case Method of
    smSend: SendMessage(Handle,Message,wParam,lParam);
    smPost: begin
      Tries := 5;
      while (Tries > 0) and not PostMessage(Handle,Message,wParam,lParam) do
      begin
        Dec(Tries);
        Sleep(5);
      end;
      Result := (Tries > 0);
    end;
  end;
end;

function IsRTF(const Value: WideString): Boolean;
const
  RTF_BEGIN_1  = WideString('{\RTF');
  RTF_BEGIN_2  = WideString('{URTF');
begin
  Result := (Pos(RTF_BEGIN_1, Value) = 1)
         or (Pos(RTF_BEGIN_2, Value) = 1);
end;

function _WideCharType(WC: WideChar; dwInfoType: Cardinal): Word;
begin
  GetStringTypeExW(GetThreadLocale, dwInfoType, PWideChar(@WC), 1, Result)
end;

function IsWideCharUpper(WC: WideChar): Boolean;
begin
  Result := (_WideCharType(WC, CT_CTYPE1) and C1_UPPER) <> 0;
end;

function IsWideCharLower(WC: WideChar): Boolean;
begin
  Result := (_WideCharType(WC, CT_CTYPE1) and C1_LOWER) <> 0;
end;

function IsWideCharDigit(WC: WideChar): Boolean;
begin
  Result := (_WideCharType(WC, CT_CTYPE1) and C1_DIGIT) <> 0;
end;

function IsWideCharSpace(WC: WideChar): Boolean;
begin
  Result := (_WideCharType(WC, CT_CTYPE1) and C1_SPACE) <> 0;
end;

function IsWideCharPunct(WC: WideChar): Boolean;
begin
  Result := (_WideCharType(WC, CT_CTYPE1) and C1_PUNCT) <> 0;
end;

function IsWideCharCntrl(WC: WideChar): Boolean;
begin
  Result := (_WideCharType(WC, CT_CTYPE1) and C1_CNTRL) <> 0;
end;

function IsWideCharBlank(WC: WideChar): Boolean;
begin
  Result := (_WideCharType(WC, CT_CTYPE1) and C1_BLANK) <> 0;
end;

function IsWideCharXDigit(WC: WideChar): Boolean;
begin
  Result := (_WideCharType(WC, CT_CTYPE1) and C1_XDIGIT) <> 0;
end;

function IsWideCharAlpha(WC: WideChar): Boolean;
begin
  Result := (_WideCharType(WC, CT_CTYPE1) and C1_ALPHA) <> 0;
end;

function IsWideCharAlphaNumeric(WC: WideChar): Boolean;
begin
  Result := (_WideCharType(WC, CT_CTYPE1) and (C1_ALPHA + C1_DIGIT)) <> 0;
end;

{ From SysUtils }

function StringReplace(const S, OldPattern, NewPattern: WideString; Flags: TReplaceFlags): WideString;
var
  SearchStr, Patt, NewStr: WideString;
  Offset: Integer;
begin
{
  if rfIgnoreCase in Flags then
  begin
    SearchStr := AnsiUpperCase(S);
    Patt := AnsiUpperCase(OldPattern);
  end else
}
  begin
    SearchStr := S;
    Patt := OldPattern;
  end;
  NewStr := S;
  Result := '';
  while SearchStr <> '' do
  begin
    Offset := Pos(Patt, SearchStr);
    if Offset = 0 then
    begin
      Result := Result + NewStr;
      Break;
    end;
    Result := Result + Copy(NewStr, 1, Offset - 1) + NewPattern;
    NewStr := Copy(NewStr, Offset + Length(OldPattern), MaxInt);
    if not (rfReplaceAll in Flags) then
    begin
      Result := Result + NewStr;
      Break;
    end;
    SearchStr := Copy(SearchStr, Offset + Length(Patt), MaxInt);
  end;
end;

{ THppBuffer }

const
  SHRINK_ON_CALL = 50;
  SHRINK_TO_LEN  = 512;

constructor THppBuffer.Create;
begin
  inherited;
  FBuffer := nil;
  FSize := 0;
  FCallCount := SHRINK_ON_CALL+1;
  InitializeCriticalSection(FLock);
  Shrink;
end;

destructor THppBuffer.Destroy;
begin
  Clear;
  DeleteCriticalSection(FLock);
  inherited;
end;

function THppBuffer.Reallocate(NewSize: Integer): Integer;
begin
  if NewSize > FSize then
  begin
    FSize := ((NewSize shr 4) + 1) shl 4;
    ReallocMem(FBuffer, FSize);
  end;
  Result := FSize;
end;

function THppBuffer.Allocate(NewSize: Integer): Integer;
begin
  Shrink;
  Result := Reallocate(NewSize);
end;

procedure THppBuffer.Shrink;
begin
  // shrink buffer on every SHRINK_ON_CALL event,
  // so it's not growing to infinity
  if (FSize > SHRINK_TO_LEN) and (FCallCount >= SHRINK_ON_CALL) then
  begin
    FSize := SHRINK_TO_LEN;
    ReallocMem(FBuffer, FSize);
    FCallCount := 0;
  end
  else
    Inc(FCallCount);
end;

procedure THppBuffer.Clear;
begin
  FreeMem(FBuffer,FSize);
  FBuffer := nil;
  FSize := 0;
  FCallCount := 0;
end;

procedure THppBuffer.Lock;
begin
  EnterCriticalSection(FLock);
end;

procedure THppBuffer.Unlock;
begin
  LeaveCriticalSection(FLock);
end;

end.
