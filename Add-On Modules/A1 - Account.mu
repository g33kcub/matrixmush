@@ Requires the Core Modules to be Installed.
@@ Interacts with Core Modules.
@@ Interacts with Add-On Modules: Locations, Boards, Channels, Jobs, Alts, Friends, Idle Tracker, Profile, Login Add-Ons, Privacy.
@@ Interacts with System Modules: Scion Second

@create Account Management System <AMS>
@set AMS=NO_MODIFY INDESTRUCTIBLE SAFE SIDEFX COMMANDS INHERIT
@parent AMS=BBK
@fo me=&cobj`AMS bbk=[objid(AMS)]

@create Account Parent Object <APO>
@set apo=NO_MODIFY INDESTRUCTIBLE SAFE SIDEFX INHERIT
@parent apo=BBK
@fo me=&cobj`apo bbk=[objid(APO)]

th [u(newconfcat,ACCOUNT)]
@@ [u(newconfig,CONFIG NAME,SYSTEM MONIKER,CONFIG CATEGORY,DEFAULT,VALIDATOR,DESCRIP,PLAYER)]
th [u(newconfig,CREATE_ACCOUNT,AMS,ACCOUNT,1,BOOL,Players can create accounts using +account/new.)]
th [u(newconfig,RENAME_ACCOUNT,AMS,ACCOUNT,1,BOOL,Players can rename accounts using +account/rename.)]
th [u(newconfig,NOTIFY_MAIL,AMS,ACCOUNT,0,BOOL,Notify if an account member has unread mail.,1)]
th [u(newconfig,PUBLIC_ALTS,AMS,ACCOUNT,0,BOOL,List all of your account characters as part of your alt list.,1)]
th [u(newconfig,MANAGE_PASSWORD,AMS,ACCOUNT,0,BOOL,Allow all members of account to reset or change password to the acocunt?,1)]
th [u(newconfig,MASTER_CHARACTER,AMS,ACCOUNT,,DBREF,The character listed as the account owner. Typically this is the character that uses +account/new.,1)]

&system`name ams=ACCOUNT
&system`desc ams=This system setups and manages player accounts.

&switches`player [u(cobj,ams)]=RENAME|NEW|REQUEST|APPROVE|CHANGEPASSWORD|RESETPASSWORD|MASTER
&switches`admin [u(cobj,ams)]=FREEZE|JAIL


@@ %0 = +account/switch SET1=Set2/Set3/set4/set5/set6/set7/set8
@@ %1 = switch
@@ %2 = SET1
@@ %3 = Set2
@@ %4 = Set3
@@ %5 = set4
@@ %6 = set5
@@ %7 = set6
@@ %8 = set7
@@ %9 = set8

&cmd`account [u(cobj,ams)]=$^\+account(?\:/(\\S+)?)?(?\: +(.+?))?(?\:=(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?$:@attach %!/CMD`ACCOUNT`MAIN
@set [u(cobj,ams)]/cmd`account=regexp
@set [u(cobj,ams)]/cmd`account=no_inherit
&cmd`account`main [u(cobj,ams)]=@attach %!/run`switches=%1;@attach %!/run`[u(strfirstof,%q<switch>,MAIN)]=%2,%3,%4,%5,%6,%7,%8,%9

@@ %0 = SET1
@@ %1 = Set2
@@ %2 = Set3
@@ %3 = set4
@@ %4 = set5
@@ %5 = set6
@@ %6 = set7
@@ %7 =
@@ %8 =
@@ %9 =

&run`new [u(cobj,ams)]=@check [not([hasattr(%#,%VT`account_DB)])]={@attach %!/msg`error={You are already part of a game account.}}

&run`main [u(cobj,ams)]=@check [hasattr(%#,%VT`account_DB)]={@attach %!/msg`error={You are not assigned to an account. Please use [ansi([gameconfig(%#,line_text)],+account/new <account name>)] or [ansi([gameconfig(%#,line_text)],+account/request <player or account name>)] to create or request addition to an existing account.}};@pemit %#=[line([gameconfig(%#,Game_name)] - Account Data,%#,Header)]%R[printf($-20s $-[sub([gameconfig(%#,width)],21)]s,[ansi([gameconfig(%#,line_text)],Account Name)]:,[name([setr(adb,[get(%#/%VT`account_db)])])])]%R[printf($-20s $-[sub([gameconfig(%#,width)],21)]s,[ansi([gameconfig(%#,line_text)],Account Members)]:,[words(lzone(%q<adb>))])][if([and([isinstalled(XP)],[hasmodule(XP,ACCOUNT)])],%R[u(run`main`xp,%q<adb>)])]%R[line(Account Members,%#)]%R[printf($-30:.:s $8:.:s $4:.:s,[ansi(gameconfig(%#,COLUMN_NAMES),Name)],[ansi(gameconfig(%#,COLUMN_NAMES),N,n,/,gameconfig(%#,COLUMN_NAMES),U,n,/,gameconfig(%#,COLUMN_NAMES),T)],[ansi(gameconfig(%#,COLUMN_NAMES),Idle)])]%R[iter(sortname(lzone(%q<adb>)),[u(run`main`fmt,##)],%b,%R)];@pemit %#=[line(,%#)]

&run`main`fmt [u(cobj,ams)]=[printf($-30s $8s $4s,[if(u(isadmin,%0),[ansi([gameconfig(%#,line_accent)],*)])][cname(%0)],[extract([setr(mail,mailquick(%0))],2,1)]/[extract(%q<mail>,3,1)]/[extract(%q<mail>,1,1)],[hideidle(%0)])]


+install AMS=1.0
