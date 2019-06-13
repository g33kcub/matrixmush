@@ Requires the Core Modules to be Installed.
@@ Interacts with Core Modules.
@@ Interacts with Add-On Modules: Locations, Boards, Channels, Jobs, Alts, Friends, Idle Tracker, Profile, Login Add-Ons, Privacy, Mail Wrappers.
@@ Interacts with System Modules: Scion Second, PokeWorld

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
th [u(newconfig,REQUIRE_ACCOUNT,AMS,ACCOUNT,1,BOOL,Does the game require +accounts for players?)]
th [u(newconfig,RENAME_ACCOUNT,AMS,ACCOUNT,1,BOOL,Players can rename accounts using +account/rename.)]
th [u(newconfig,PUBLIC_ALTS,AMS,ACCOUNT,0,BOOL,List all of your account characters as part of your alt list.,1)]
th [u(newconfig,MANAGE_ACCOUNT,AMS,ACCOUNT,0,BOOL,Allow all members of account to reset or change password to the account?,1)]
th [u(newconfig,MASTER_CHARACTER,AMS,ACCOUNT,,DBREF,The character listed as the account owner. Typically this is the character that uses +account/new.,1)]
th [u(newconfig,TIMEZONE,AMS,ACCOUNT,,TZ,This is the timezone the account belongs to.,1)]
th [u(newconfig,ACCOUNT_ONLY,AMS,ACCOUNT,MANAGE_ACCOUNT|ACCOUNT_PREFS|MASTER_CHARACTER,List,A list of settings that MUST be set on the account object only.)]

&system`name ams=ACCOUNT
&system`desc ams=This system setups and manages player accounts.

&switches`player [u(cobj,ams)]=RENAME|NEW|REQUEST|REQLIST|APPROVE|CHANGEPASSWORD|RESETPASSWORD|DENY
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

&run`reqlist [u(cobj,ams)]=@check [hasattr(%#,%VT`account_DB)]={@attach %!/msg`error={You are not part of a game account.}};@pemit %#=[line([gameconfig(%#,Game_name)] - Account Request List,%#,Header)]%R[printf($-30:.:s $-20:.:s,[ansi(gameconfig(%#,COLUMN_NAMES),Name)],[ansi(gameconfig(%#,COLUMN_NAMES),Request Date)])]%R[iter([lattr([setr(adb,[u(accid,%#)])]/%vt`request`*)],[printf($-30:.:s $-20:.:s,[name([get(%q<adb>/##)])],,)],%B,%R)]

&run`request [u(cobj,ams)]=@check [not([hasattr(%#,%VT`account_DB)])]={@attach %!/msg`error={You are already part of a game account.}};@attach %!/run`getpc=%0,1;th [setq(adb,[u(accid,%q<t1>)])];&%VT`Request`[secs()] %q<adb>=%:;@attach %!/msg={[name(%#)] has requested to join your account. Please see [ansi(u(gconfig,%#,line_text),+account/reqlist)] to approve or deny.},{[lzone(%q<adb>)]};@attach %!/msg={You have requested to join [name(%q<t1>)]'s account.}

&run`rename [u(Cobj,ams)]=@check [gameconfig(%#,RENAME_ACCOUNT)]={@attach %!/msg`error={This game does not allow players to rename their own accounts. Please contact staff.}};@check [u(can_manage,%#)]={@attach %!/msg`error={Only the Master Character can make this change.}};@attach %!/validator`email=%0;@check [not([gtm([U(get`account_list)],%0,|)])]={@attach %!/msg`error={'%0' is already an account.}};&%vt`previous`[words(lattr([u(accid,%#)]/%VT`Previous`*))] [u(accid,%#)]=[name([u(accid,%#)])];@name [u(accid,%#)]=%0;@attach %!/msg={[cname(%#)] has updated the account name to '%0'.},{[lzone([u(accid,%#)])]}

&can_manage [u(cobj,ams)]=[if([u(gconfig,%0,MANAGE_ACCOUNT)],1,[gtm([u(gconfig,%0,MASTER_CHARACTER)],[objid(%0)],|)])]

&get`account_list [u(cobj,ams)]=[iter([children([cobj(apo)])],[name(##)],%B,|)]
&run`new [u(cobj,ams)]=@check [gameconfig(%#,CREATE_ACCOUNT)]={@attach %!/msg`error={This game does not allow players to create their own accounts. Please contact staff.}};@check [not([hasattr(%#,%VT`account_DB)])]={@attach %!/msg`error={You are already part of a game account.}};@check [not([gtm([U(get`account_list)],%0,|)])]={@attach %!/msg`error={'%0' is already an account. If you are supposed to be part of it use: [ansi(u(gconfig,%#,line_text),+account/request %0)]}};@attach %!/validator`email=%0;th [setq(act,[create(%0)])];&config`master_character`custom %q<act>=%:;@set %q<act>=zonemaster;@zone/add %#=%q<act>;&%vt`account_db %#=[objid(%q<act>)];@dolist [lattr(%#/CONFIG`**,,,,,1)]={&## %q<act>=[get(%#/##)];&## %#};@dolist [lattr(%#/%VT`READ`**,,,,,1)]={&## %q<act>=[get(%#/##)];&## %#};@attach %!/msg={You have created the account '%0'. All of your configuration items have been copied to the account, as well as any readable and trackable items, such as news and help. You have been set as the master character and this can be changed by viewing [ansi([u(gconfig,%#,line_text)],+config)]. Welcome.}

&run`main [u(cobj,ams)]=@check [hasattr(%#,%VT`account_DB)]={@attach %!/msg`error={You are not assigned to an account. Please use [ansi([gameconfig(%#,line_text)],+account/new <account name>)] or [ansi([gameconfig(%#,line_text)],+account/request <player name>)] to create or request addition to an existing account.}};@pemit %#=[line([gameconfig(%#,Game_name)] - Account Data,%#,Header)]%R[printf($-20s $-[sub([gameconfig(%#,width)],21)]s,[ansi([gameconfig(%#,line_text)],Account Name)]:,[name([setr(adb,[get(%#/%VT`account_db)])])])]%R[printf($-20s $-[sub([gameconfig(%#,width)],21)]s,[ansi([gameconfig(%#,line_text)],Account Members)]:,[words(lzone(%q<adb>))])][if([and([isinstalled(XP)],[hasmodule(XP,ACCOUNT)])],%R[u(run`main`xp,%q<adb>)])]%R[line(Account Members,%#)]%R[printf($-30:.:s $8:.:s $4:.:s,[ansi(gameconfig(%#,COLUMN_NAMES),Name)],[ansi(gameconfig(%#,COLUMN_NAMES),N,n,/,gameconfig(%#,COLUMN_NAMES),U,n,/,gameconfig(%#,COLUMN_NAMES),T)],[ansi(gameconfig(%#,COLUMN_NAMES),Idle)])]%R[iter(sortname(lzone(%q<adb>)),[u(run`main`fmt,##)],%b,%R)];@pemit %#=[line(,%#)]

&run`main`fmt [u(cobj,ams)]=[printf($-30s $8s $4s,[if(u(isadmin,%0),[ansi([gameconfig(%#,line_accent)],*)])][cname(%0)],[extract([setr(mail,mailquick(%0))],2,1)]/[extract(%q<mail>,3,1)]/[extract(%q<mail>,1,1)],[hideidle(%0)])]

&help`install`main [u(cobj,ams)]=Character/Account=[u(cobj,ams)]/HLP`ACCOUNT
&shelp`install`main [u(Cobj,ams)]=Players/Account=[u(cobj,ams)]/shlp`ACCOUNT
&shelp`uninstall [u(cobj,ams)]=Account
&help`uninstall [u(cobj,ams)]=Account

+install AMS=1.0
