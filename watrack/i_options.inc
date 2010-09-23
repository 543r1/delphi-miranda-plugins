{Database options}
const
  DefaultXStatus = $080B; // TV + Music
const
  defhotkey    = (HOTKEYF_CONTROL+HOTKEYF_ALT  )*256+VK_F5;
  definshotkey = (HOTKEYF_CONTROL+HOTKEYF_SHIFT)*256+VK_F7;

const
  defcoverpaths = 'cover.jpg'#13#10'..\cover.jpg'#13#10'*.jpg'#13#10'..\*.jpg';

const
  WATFormats:PAnsiChar = 'formats/';
const
  WATPlayers   :PAnsiChar = 'players/';
const
  opt_DefPlayer:PAnsiChar = 'defplayer';

const
  opt_version  :PAnsiChar = 'version';
  opt_disable  :PAnsiChar = 'disableplugin';

  opt_InsHotKey :PAnsiChar = 'inshotkey';
  opt_HotKey    :PAnsiChar = 'hotkey';
  opt_Timer     :PAnsiChar = 'timer';
  opt_UserCP    :PAnsiChar = 'usercp';
  opt_CheckTime :PAnsiChar = 'checktime';
  opt_coverpaths:PAnsiChar = 'coverpaths';
  opt_implantant:PAnsiChar = 'useimplantant';
  opt_MTHCheck  :PAnsiChar = 'mthcheck';
  opt_KeepOld   :PAnsiChar = 'keepold';
  opt_mmkeyemu  :PAnsiChar = 'mmkeyemu';
  opt_CheckAll  :PAnsiChar = 'checkall';
const
  opt_HiddenOption:PAnsiChar = 'hiddenoption';

procedure _loadopt;
begin
//  PlgVersion:=DBReadDWord(0,PluginShort,opt_version,0);
  HiddenOption:=DBReadDWord(0,PluginShort,opt_HiddenOption,0);

  DisablePlugin:=DBReadByte(0,PluginShort,opt_disable,0);
  if DisablePlugin<>dsPermanent then
    DisablePlugin:=dsEnabled;

  inshotkey    :=DBReadWord(0,PluginShort,opt_InsHotKey ,definshotkey);
  globhotkey   :=DBReadWord(0,PluginShort,opt_HotKey    ,defhotkey);
  CheckTime    :=DBReadByte(0,PluginShort,opt_CheckTime ,BST_CHECKED);
  UseImplant   :=DBReadByte(0,PluginShort,opt_Implantant,BST_UNCHECKED);
  MTHCheck     :=DBReadByte(0,PluginShort,opt_MTHCheck  ,BST_CHECKED);
  KeepOld      :=DBReadByte(0,PluginShort,opt_KeepOld   ,BST_UNCHECKED);
  CheckAll     :=DBReadByte(0,PluginShort,opt_CheckAll  ,BST_UNCHECKED);
  mTimer       :=DBReadWord(0,PluginShort,opt_timer     ,3000);
  if mTimer<500 then
    mTimer:=mTimer*1000;
  UserCP       :=DBReadWord(0,PluginShort,opt_UserCP    ,CP_ACP);
  CoverPaths   :=DBReadUnicode(0,PluginShort,opt_coverpaths,defcoverpaths);

  mmkeyemu     :=DBReadByte (0,PluginShort,opt_mmkeyemu  ,BST_UNCHECKED);
end;

procedure _saveopt;
begin
//  DBWriteDWord(0,PluginShort,opt_version,PluginInfo.version);

  DBWriteWord(0,PluginShort,opt_InsHotKey ,inshotkey);
  DBWriteWord(0,PluginShort,opt_HotKey    ,globhotkey);
  DBWriteByte(0,PluginShort,opt_CheckTime ,CheckTime);
  DBWriteByte(0,PluginShort,opt_Implantant,UseImplant);
  DBWriteByte(0,PluginShort,opt_MTHCheck  ,MTHCheck);
  DBWriteByte(0,PluginShort,opt_KeepOld   ,KeepOld);
  DBWriteByte(0,PluginShort,opt_CheckAll  ,CheckAll);
  DBWriteWord(0,PluginShort,opt_timer     ,mTimer);
  DBWriteWord(0,PluginShort,opt_UserCP    ,UserCP);

  DBWriteUnicode(0,PluginShort,opt_CoverPaths,CoverPaths);

  DBWriteByte (0,PluginShort,opt_mmkeyemu  ,mmkeyemu);
end;

function enumwp(desc:PAnsiChar;lParam:integer):bool; stdcall;
var
  i:integer;
  buf:array [0..63] of AnsiChar;
begin
  i:=CallService(MS_WAT_PLAYER,WAT_ACT_GETSTATUS,dword(desc));
  if i=WAT_RES_ENABLED then
    i:=1
  else
    i:=0;
  StrCopy(buf,WATPlayers);
  StrCat (buf,desc);
  DBWriteByte(0,PluginShort,buf,i);
  result:=true;
end;

procedure WritePlayers;
begin
  EnumPlayers(@enumwp,0);
end;

function enumrp(desc:PAnsiChar;lParam:integer):bool; stdcall;
var
  i:integer;
  buf:array [0..63] of AnsiChar;
begin
  StrCopy(buf,WATPlayers);
  StrCat (buf,desc);
  i:=DBReadByte(0,PluginShort,buf,1);
  if i=1 then
    i:=WAT_ACT_ENABLE
  else
    i:=WAT_ACT_DISABLE;
  CallService(MS_WAT_PLAYER,i,dword(desc));
  result:=true;
end;

procedure ReadPlayers;
begin
  EnumPlayers(@enumrp,0);
{!!  p:=DBReadString(0,PluginShort,opt_DefPlayer,nil);
  CallService(MS_WAT_PLAYER,WAT_ACT_SETACTIVE,dword(p));
  mFreeMem(p);
}
end;

function enumwf(ext:PAnsiChar;lParam:integer):bool; stdcall;
var
  i:integer;
  buf:array [0..63] of AnsiChar;
begin
  i:=CallService(MS_WAT_FORMAT,WAT_ACT_GETSTATUS,dword(ext));
  if i=WAT_RES_ENABLED then
    i:=1
  else
    i:=0;
  StrCopy(buf,WATFormats);
  StrCat (buf,ext);
  DBWriteByte(0,PluginShort,buf,i);
  result:=true;
end;

procedure WriteFormats;
begin
  EnumFormats(@enumwf,0);
end;

function enumrf(ext:PAnsiChar;lParam:integer):bool; stdcall;
var
  i:integer;
  buf:array [0..63] of AnsiChar;
begin
  StrCopy(buf,WATFormats);
  StrCat (buf,ext);
  i:=DBReadByte(0,PluginShort,buf,1);
  if i=1 then
    i:=WAT_ACT_ENABLE
  else
    i:=WAT_ACT_DISABLE;
  CallService(MS_WAT_FORMAT,i,dword(ext));
  result:=true;
end;

procedure ReadFormats;
begin
  EnumFormats(@enumrf,0);
end;

procedure saveopt;
begin
  _saveopt;
  WriteFormats;
  WritePlayers;
end;

procedure loadopt;
begin
  _loadopt;
  ReadPlayers;
  ReadFormats;
end;