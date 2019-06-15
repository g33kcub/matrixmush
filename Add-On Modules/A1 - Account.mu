@@ Requires the Core Modules to be Installed.
@@ Interacts with Core Modules.
@@ Interacts with Add-On Modules: Locations, Boards, Channels, Jobs, Alts, Friends, Idle Tracker, Profile, Login Add-Ons, Privacy, Mail Wrappers.
@@ Interacts with System Modules: Scion Second, PokeWorld

@create Account Management System <AMS>
@set AMS=NO_MODIFY INDESTRUCTIBLE SAFE SIDEFX COMMANDS INHERIT
@parent AMS=BBK
@fo me=&cobj`AMS bbk=[objid(AMS)]
@tel [u(cobj,ams)]=#[config(master_room)]

@create Account Parent Object <APO>
@set apo=NO_MODIFY INDESTRUCTIBLE SAFE SIDEFX INHERIT
@parent apo=BBK
@fo me=&cobj`apo bbk=[objid(APO)]
@tel [u(cobj,apo)]=[u(cobj,ams)]

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
th [u(newconfig,MAX_PER_PAGE,AMS,ACCOUNT,20,INT,The maximum amount of accounts to show on the list for the +account/list command. %(Staff Only%),1)]

&system`name ams=ACCOUNT
&system`desc ams=This system setups and manages player accounts.

&switches`player [u(cobj,ams)]=RENAME|NEW|REQUEST|REQLIST|APPROVE|DENY
&switches`admin [u(cobj,ams)]=FREEZE|JAIL|LIST|RELEASE|CREATE

&cmd`account [u(cobj,ams)]=$^\+account(?\:/(\\S+)?)?(?\: +(.+?))?(?\:=(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?$:@attach %!/CMD`ACCOUNT`MAIN
@set [u(cobj,ams)]/cmd`account=regexp
@set [u(cobj,ams)]/cmd`account=no_inherit
&cmd`account`main [u(cobj,ams)]=@attach %!/run`switches=%1;@attach %!/run`[u(strfirstof,%q<switch>,MAIN)]=%2,%3,%4,%5,%6,%7,%8,%9

&run`create [u(cobj,ams)]=@attach %!/run`getpc=%0,1;@check [not([hasaccount(%#)])]={@attach %!/msg`error={[name(%q<t1>)] is already part of a game account.}};@check [not([gtm([U(get`account_list)],%1,|)])]={@attach %!/msg`error={'%1' is already an account.}};@attach %!/validator`email=%1;th [setq(act,[create(%1)])];@parent %q<act>=[u(cobj,apo)];@tel %q<act>=[u(cobj,apo)];&config`master_character`custom %q<act>=[objid(%q<t1>)];@set %q<act>=zonemaster;@zone/add %q<t1>=%q<act>;&%vt`account_db %q<t1>=[objid(%q<act>)];@dolist [lattr(%q<t1>/CONFIG`**,,,,,1)]={&## %q<act>=[get(%q<t1>/##)];&## %q<t1>};@dolist [lattr(%q<t1>/%VT`READ`**,,,,,1)]={&## %q<act>=[get(%q<t1>/##)];&## %q<t1>};@attach %!/msg={[name(%#)] has created the account '%1'. All of your configuration items have been copied to the account, as well as any readable and trackable items, such as news and help. You have been set as the master character and this can be changed by viewing [ansi([u(gconfig,%#,line_text)],+config)]. Welcome.},{[lzone(%q<act>)]};@attach %!/msg={You create the account '%1' and add '[name(%q<t1>)]' as the master character.}

&run`release [u(cobj,ams)]=@attach %!/run`getpc=%0,1;th [setq(pid,[u(getid,%q<t1>)])];@check [hasaccount(%#)]={@attach %!/msg`error={'[name(%q<t1>)]' is not part of an account. Please use the standard release command.}};@check [cor([hasflag(%q<pid>,FROZEN)],[hasflag(%q<pid>,PRISONER)])]={@attach %!/msg`error={The '[name(%q<pid>)]' is not either Frozen or Jailed. There is nothing to do.}};@dolist [lzone(%q<pid>)]={@set ##=!PRISONER !FROZEN !NO_MOVE !NO_TEL !SLAVE;@link ##=[u(gconfig,##,OOC_NEXUS)];@tel ##=[u(gconfig,##,OOC_NEXUS)]};@set %q<pid>=!FROZEN !PRISONER;@attach %!/msg`chan={[name(%#)] has released the account '[name(%q<Pid>)]' and all of the members.};@attach %!/msg={[name(%#)] has released the account '[name(%q<Pid>)]' and all of the members.},{[lzone(%q<pid>)]}

&get_pages [u(cobj,bbk)]=[u(get_pages`%0,%1,%2,%3)]
&get_pages`num [u(Cobj,bbk)]=[setq(cnt,words(%0,u(firstof,%1,%B)))][setq(div,[fdiv(%q<cnt>,%2)])][if(gte([after(%q<div>,.)],1),inc(before(%q<div>,.)),%q<div>)]
&get_pages`list [u(cobj,bbk)]=[extract(%0,[u(get_pages`step,%2)],%2,u(firstof,%1,%b))]
&get_pages`step [u(cobj,bbk)]=[iter([lnum(0,80)],[inc(mul(##,%0))])]

@@ This will be edited eventually to add page support.
&run`list [u(cobj,ams)]=th [setq(raw,[sortby(sort`dbname,[children([u(cobj,apo)])])])] [setq(list,[pages(list,%q<raw>,,[u(gconfig,%#,MAX_PER_PAGE)])])][setq(pg,[pages(num,%q<raw>,,[u(gconfig,%#,MAX_PER_PAGE)])])];@attach %!/run`partial=firstof(%0,1),[lnum(1,%q<pg>)],%B,page,Pages;@pemit %#=[line(Master Account List,%#,Header)]%R[printf($-3:.:s $-45:.:s $-5:.:s $-24:.:s,[ansi([setr(c,[u(gconfig,%#,COLUMN_NAMES)])],Sts)],[ansi(%q<c>,Account Name)],[ansi(%q<c>,Chars)],[ansi(%q<c>,Master Character)])];@dolist %q<list>={@pemit %#=[printf($-3s $-45s $^5s $-24s,%[[switch(1,[hasflag(##,PRISONER)],[ansi(%q<c>,J)],[hasflag(##,FROZEN)],[ansi(%q<c>,F)],%B)]%],[name(##)],[words([lzone(##)])],[if([hasattr(##,CONFIG`master_character`custom)],[name([get(##/CONFIG`MASTER_CHARACTER`custom)])],none)])]};@wait 0={@pemit %#=[line(Page [firstof(%0,1)] of %q<pg> -- +account/list <page num>,%#)]}

&sort`dbname [u(cobj,bbk)]=[comp(name(%0),name(%1))]

&run`jail [u(cobj,ams)]=@attach %!/run`getpc=%0,1;th [setq(pid,[u(getid,%q<t1>)])];@check [hasaccount(%#)]={@attach %!/msg`error={'[name(%q<t1>)]' is not part of an account. Please use the standard jail command.}};@dolist [lzone(%q<pid>)]={@set ##=PRISONER SLAVE NO_MOVE NO_TEL;@link ##=[u(gconfig,%#,JAIL_ROOM)];@tel ##=[u(gconfig,%#,JAIL_ROOM)]};@attach %!/msg`chan={[setr(m1,[name(%#)] has jailed all players attached to account '[name(%q<pid>)]'.)]};@attach %!/msg={%q<msg>},{[lzone(%q<pid>)]};@set %q<pid>=PRISONER

&run`freeze [u(cobj,ams)]=@attach %!/run`getpc=%0,1;th [setq(pid,[u(getid,%q<t1>)])];@check [hasaccount(%#)]={@attach %!/msg`error={'[name(%q<t1>)]' is not part of an account. Please use the standard freeze command.}};@dolist [lzone(%q<pid>)]={@set ##=FROZEN NO_TEL;@link ##=[u(gconfig,%#,FREEZER_ROOM)];@tel ##=[u(gconfig,%#,FREEZER_ROOM)]};@attach %!/msg`chan={[setr(m1,[name(%#)] has frozen all players attached to account '[name(%q<pid>)]'.)]};@attach %!/msg={%q<msg>},{[lzone(%q<pid>)]};@set %q<pid>=FROZEN


&run`deny [u(Cobj,ams)]=@check [hasaccount(%#)]={@attach %!/msg`error={You are not part of a game account.}};@check [u(can_manage,%#)]={@attach %!/msg`error={You are not permitted to deny join requests.}};th [setq(a1,[u(accid,%#)])][setq(list,[lattr(%q<a1>/%VT`REQUEST`*)])][setq(req,[extract(%q<list>,%0,1)])][setq(new,[get(%q<a1>/%q<req>)])];@check [not([hasattr(%q<new>,%VT`account_db)])]={@attach %!/msg`error={[name(%q<new>)] is already a member of an account.}};@check [gte(words(%q<req>),1)]={@attach %!/msg`error={Invalid Request number '%0'.}};&%q<req> %q<al>;@attach %!/msg={[name(%#)] denies [name(%q<new>)] to join the account.},{[lzone(%q<a1>)]};mail %q<new>=Account Denial//Your request to join the [name(%q<a1>)] account has been denied by [name(%#)].

&run`approve [u(Cobj,ams)]=@check [hasaccount(%#)]={@attach %!/msg`error={You are not part of a game account.}};@check [u(can_manage,%#)]={@attach %!/msg`error={You are not permitted to approve join requests.}};th [setq(a1,[u(accid,%#)])][setq(list,[lattr(%q<a1>/%VT`REQUEST`*)])][setq(req,[extract(%q<list>,%0,1)])][setq(new,[get(%q<a1>/%q<req>)])];@check [not([hasattr(%q<new>,%VT`account_db)])]={@attach %!/msg`error={[name(%q<new>)] is already a member of an account.}};@check [gte(words(%q<req>),1)]={@attach %!/msg`error={Invalid Request number '%0'.}};@zone %q<new>=%q<a1>;&%q<req> %q<al>;@attach %!/msg={[name(%#)] approves [name(%q<new>)] to join the account.},{[lzone(%q<a1>)]};mail %q<new>=Account Approval//You have been added to the [name(%q<a1>)] account by [name(%#)].

&run`reqlist [u(cobj,ams)]=@check [hasaccount(%#)]={@attach %!/msg`error={You are not part of a game account.}};@pemit %#=[line([name([u(accid,%#)])] - Account Request List,%#,Header)]%R[printf($-2:.:s $-30:.:s $-20:.:s,[ansi(gameconfig(%#,COLUMN_NAMES),#)],[ansi(gameconfig(%#,COLUMN_NAMES),Name)],[ansi(gameconfig(%#,COLUMN_NAMES),Request Date)])]%R[iter([lattr([setr(adb,[u(accid,%#)])]/%vt`request`*)],[printf($-2s $-30s $-20s,#@,[name([get(%q<adb>/##)])],[u(prettytime,[last(##,`)])],)],%B,%R)];@pemit %#=[line(,%#)]

&prettytime [u(cobj,bbk)]=[timefmt($M/$D/$y $H:$T $p,%0)]

&run`request [u(cobj,ams)]=@check [not([hasaccount(%#)])]={@attach %!/msg`error={You are already part of a game account.}};@attach %!/run`getpc=%0,1;th [setq(adb,[u(accid,%q<t1>)])];&%VT`Request`[secs()] %q<adb>=%:;@attach %!/msg={[name(%#)] has requested to join your account. Please see [ansi(u(gconfig,%#,line_text),+account/reqlist)] to approve or deny.},{[lzone(%q<adb>)]};@attach %!/msg={You have requested to join [name(%q<t1>)]'s account.}

&run`rename [u(Cobj,ams)]=@check [gameconfig(%#,RENAME_ACCOUNT)]={@attach %!/msg`error={This game does not allow players to rename their own accounts. Please contact staff.}};@check [u(can_manage,%#)]={@attach %!/msg`error={Only the Master Character can make this change.}};@attach %!/validator`email=%0;@check [not([gtm([U(get`account_list)],%0,|)])]={@attach %!/msg`error={'%0' is already an account.}};&%vt`previous`[words(lattr([u(accid,%#)]/%VT`Previous`*))] [u(accid,%#)]=[name([u(accid,%#)])];@name [u(accid,%#)]=%0;@attach %!/msg={[cname(%#)] has updated the account name to '%0'.},{[lzone([u(accid,%#)])]}

&can_manage [u(cobj,ams)]=[if([u(gconfig,%0,MANAGE_ACCOUNT)],1,[gtm([u(gconfig,%0,MASTER_CHARACTER)],[objid(%0)],|)])]

&get`account_list [u(cobj,ams)]=[iter([children([cobj(apo)])],[name(##)],%B,|)]
&run`new [u(cobj,ams)]=@check [gameconfig(%#,CREATE_ACCOUNT)]={@attach %!/msg`error={This game does not allow players to create their own accounts. Please contact staff.}};@check [not([hasaccount(%#)])]={@attach %!/msg`error={You are already part of a game account.}};@check [not([gtm([U(get`account_list)],%0,|)])]={@attach %!/msg`error={'%0' is already an account. If you are supposed to be part of it use: [ansi(u(gconfig,%#,line_text),+account/request %0)]}};@attach %!/validator`email=%0;th [setq(act,[create(%0)])];&config`master_character`custom %q<act>=%:;@parent %q<act>=[u(cobj,apo)];@tel %q<act>=[u(cobj,apo)];@set %q<act>=zonemaster;@zone/add %#=%q<act>;&%vt`account_db %#=[objid(%q<act>)];@dolist [lattr(%#/CONFIG`**,,,,,1)]={&## %q<act>=[get(%#/##)];&## %#};@dolist [lattr(%#/%VT`READ`**,,,,,1)]={&## %q<act>=[get(%#/##)];&## %#};@attach %!/msg={You have created the account '%0'. All of your configuration items have been copied to the account, as well as any readable and trackable items, such as news and help. You have been set as the master character and this can be changed by viewing [ansi([u(gconfig,%#,line_text)],+config)]. Welcome.}

&get_account [u(cobj,ams)]=[u(get_account`[strmatch(%1,*@*.*)],%0,%1)]
&get_account`0 [u(cobj,ams)]=[pmatch([firstof(%1,%0)])]
&get_account`1 [u(cobj,ams)]=[setq(acts,[children([u(cobj,apo)])])][setq(anm,[iter(%q<acts>,[name(##)],%B,|)])][setq(bingo,[if(gtm(%q<anm>,%1,|),[extract(%q<acts>,[match(%q<anm>,%1,|)],1)])])][objid(%q<bingo>)]

&run`main [u(cobj,ams)]=th [setq(pid,[if(isadmin(%#),u(get_account,%#,%0),%#)])];@check isdbref(%q<pid>)={@attach %!/msg`error={'%0' cannot be found as either a player or an account.}};@attach %!/run`main`[type(%q<pid>)]=%q<pid>

&run`main`thing [u(cobj,ams)]=@pemit %#=[line([gameconfig(%#,Game_name)] - Account Data,%#,Header)]%R[printf($-20s $-[sub([gameconfig(%#,width)],21)]s,[ansi([gameconfig(%#,line_text)],Account Name)]:,[name([setr(adb,%q<pid>)])])]%R[printf($-20s $-[sub([gameconfig(%#,width)],21)]s,[ansi([gameconfig(%#,line_text)],Account Members)]:,[words(lzone(%q<adb>))])][if([and([isinstalled(XP)],[hasmodule(XP,ACCOUNT)])],%R[u(run`main`xp,%q<adb>)])]%R[line(Account Members,%#)]%R[printf($-30:.:s $8:.:s $4:.:s,[ansi(gameconfig(%#,COLUMN_NAMES),Name)],[ansi(gameconfig(%#,COLUMN_NAMES),N,n,/,gameconfig(%#,COLUMN_NAMES),U,n,/,gameconfig(%#,COLUMN_NAMES),T)],[ansi(gameconfig(%#,COLUMN_NAMES),Idle)])]%R[iter(sortname(lzone(%q<adb>)),[u(run`main`fmt,##)],%b,%R)];@pemit %#=[line(,%#)]


&run`main`player [u(cobj,ams)]=@check [hasattr(%q<pid>,%VT`account_DB)]={@attach %!/msg`error={[if(gte(words(%0),1),[name(%q<pid>)] is,You are)] not assigned to an account.[if(gte(words(%0),1),,%BPlease use [ansi([gameconfig(%#,line_text)],+account/new <account name>)] or [ansi([gameconfig(%#,line_text)],+account/request <player name>)] to create or request addition to an existing account.)]}};@pemit %#=[line([gameconfig(%#,Game_name)] - Account Data,%#,Header)]%R[printf($-20s $-[sub([gameconfig(%#,width)],21)]s,[ansi([gameconfig(%#,line_text)],Account Name)]:,[name([setr(adb,[get(%q<pid>/%VT`account_db)])])])]%R[printf($-20s $-[sub([gameconfig(%#,width)],21)]s,[ansi([gameconfig(%#,line_text)],Account Members)]:,[words(lzone(%q<adb>))])][if([and([isinstalled(XP)],[hasmodule(XP,ACCOUNT)])],%R[u(run`main`xp,%q<adb>)])]%R[line(Account Members,%#)]%R[printf($-30:.:s $8:.:s $4:.:s,[ansi(gameconfig(%#,COLUMN_NAMES),Name)],[ansi(gameconfig(%#,COLUMN_NAMES),N,n,/,gameconfig(%#,COLUMN_NAMES),U,n,/,gameconfig(%#,COLUMN_NAMES),T)],[ansi(gameconfig(%#,COLUMN_NAMES),Idle)])]%R[iter(sortname(lzone(%q<adb>)),[u(run`main`fmt,##)],%b,%R)];@pemit %#=[line(,%#)]

&run`main`fmt [u(cobj,ams)]=[printf($-30s $8s $4s,[if(u(isadmin,%0),[ansi([gameconfig(%#,line_accent)],*)])][cname(%0)],[extract([setr(mail,mailquick(%0))],2,1)]/[extract(%q<mail>,3,1)]/[extract(%q<mail>,1,1)],[hideidle(%0)])]
