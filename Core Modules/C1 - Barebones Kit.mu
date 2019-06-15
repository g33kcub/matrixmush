@create Barebones Kit <BBK>
@create Startup Master <START>
@create Core Control Object <CORE>

@set BBK=NO_MODIFY INDESTRUCTIBLE SAFE SIDEFX INHERIT
@set START=NO_MODIFY INDESTRUCTIBLE SAFE SIDEFX INHERIT
&SYSTEM`NAME BBK=SYSTEM
@parent start=bbk

@set core=NO_MODIFY INDESTRUCTIBLE SAFE SIDEFX COMMANDS INHERIT
@parent core=BBK
@fo me=&cobj`core bbk=[objid(core)]

&cobj BBK=[default(%!/cobj`%0,#-1)]
@fo me=&cobj`start bbk=[objid(START)]
@fo me=&cobj`bbk bbk=[objid(BBK)]

&msg [u(cobj,bbk)]=@pemit/list u(strfirstof,%1,%#)=udefault(%!/MSG`fmt,%0,##,%0,%1,u(SYSTEM`NAME))
&msg`error [u(cobj,bbk)]=@pemit/list u(strfirstof,%1,%#)=udefault(%!/MSG`fmt`error,%0,##,%0,%1,u(SYSTEM`NAME))
&msg`fmt [u(cobj,bbk)]=u(msg`header,%3,%0) %1
&msg`fmt`error [u(cobj,bbk)]=u(msg`header,%3,%0) [ansi(+red,ERROR)]: %1
&msg`header [u(Cobj,bbk)]=localize(ansi(u(setr,msgcolor,u(gconfig,u(firstof,%1,%#),ALERT_FRAME)),[chr(91)])[ansi(u(gconfig,u(firstof,%1,%#),ALERT_TEXT),ucstr(%0))][ansi(%q<msgcolor>,[chr(93)])])
&msg`chan [u(cobj,bbk)]=@check [gtm([u(gconfig,%#,SYSTEMS)],COMSYS,|)];



@@ Startup System (START)
@startup start=@dolist [lattr(%!/start`**)]=@attach [u(cobj,start)]/##

&start`flag`build [u(cobj,start)]=@flag Marker0=BUILD;@flagdef/set BUILD=Architect;@flagdef/unset build=Architect;@flagdef/see build=mortal
&start`flag`frozen [u(cobj,start)]=@flag Marker1=FROZEN;@flagdef/set FROZEN=Royalty;@flagdef/unset FROZEN=Royalty;@flagdef/see FROZEN=architect
&start`flag`prisoner [u(cobj,start)]=@flag Marker2=PRISONER;@flagdef/set PRISONER=IMMORTAL;@flagdef/unset PRISONER=IMMORTAL;@flagdef/see PRISONER=architect
&start`function`isinstalled [u(cobj,start)]=@function/privileged isinstalled=[u(cobj,bbk)]/isinstalled
&start`function`hasmodule [u(cobj,start)]=@function/privileged hasmodule=[u(cobj,bbk)]/hasmodule
&start`config`07 [u(cobj,start)]=@admin global_parent_room=[after([u(gconfig,%!,GP_room)],#)]
&start`config`06 [u(cobj,start)]=@admin global_parent_exit=[after([u(gconfig,%!,GP_exit)],#)]
&start`config`05 [u(cobj,start)]=@admin global_parent_player=[after([u(gconfig,%!,GP_player)],#)]
&start`function`cobj [u(cobj,start)]=@function/privileged cobj=[u(cobj,bbk)]/cobj
&start`function`strfirstof [u(cobj,start)]=@function/privileged strfirstof=[u(cobj,bbk)]/strfirstof
&start`function`line [u(cobj,start)]=@function/privileged line=[u(cobj,bbk)]/line
&start`function`firstof [u(cobj,start)]=@function/privileged firstof=[u(cobj,bbk)]/firstof
&start`function`align [u(cobj,start)]=@function/privileged align=[u(cobj,bbk)]/align
&start`function`caps [u(cobj,start)]=@function/privileged caps=[u(cobj,bbk)]/caps
&start`function`su [u(cobj,start)]=@function/privileged su=[u(cobj,bbk)]/su
&start`function`gtm [u(cobj,start)]=@function/privileged gtm=[u(cobj,bbk)]/gtm
&start`function`cnum [u(cobj,start)]=@function/privileged cnum=[u(cobj,bbk)]/cnum
&start`function`isadmin [u(cobj,start)]=@function/privileged isadmin=[u(cobj,bbk)]/isadmin
&start`function`isops [u(cobj,start)]=@function/privileged isops=[u(cobj,bbk)]/isops
&start`function`iswiz [u(cobj,start)]=@function/privileged iswiz=[u(cobj,bbk)]/iswiz
&start`function`isguest [u(cobj,start)]=@function/privileged isguest=[u(cobj,bbk)]/isguest
&start`function`isapproved [u(cobj,start)]=@function/privileged isapproved=[u(cobj,bbk)]/isapproved
&start`function`isnew [u(cobj,start)]=@function/privileged isnew=[u(cobj,bbk)]/isnew
&start`function`isbldr [u(cobj,start)]=@function/privileged isbldr=[u(cobj,bbk)]/isbldr
&start`function`hastag [u(cobj,start)]=@function/privileged hastag=[u(cobj,bbk)]/hastag
&start`function`gameconfig [u(cobj,start)]=@function/privileged gameconfig=[u(cobj,bbk)]/gameconfig
&start`function`alignfilter [u(cobj,start)]=@function/privileged alignfilter=[u(cobj,bbk)]/alignfilter
&start`function`itemize [u(cobj,start)]=@function/privileged/preserve itemize=[u(cobj,bbk)]/itemize
&start`function`getid [u(cobj,start)]=@function/privileged getid=[u(cobj,bbk)]/getid
&start`function`pages [u(Cobj,start)]=@function/privileged pages=[u(cobj,bbk)]/get_pages
&start`run`vt [u(Cobj,start)]=@VT [u(Cobj,bbk)]=[u(firstof,[u([u(cobj,gcs)]/config`system_attribute`custom)],[u([u(cobj,gcs)]/config`system_attribute`default)])]
&start`config`04 [u(Cobj,start)]=@admin function_recursion_limit=100
&start`config`03 [u(Cobj,start)]=@admin penn_setq=yes
&start`alias`select [u(Cobj,start)]=@admin alias=@select @switch/first
&start`alias`check [u(Cobj,start)]=@admin alias=@check @assert/inline
&start`alias`stop [u(cobj,start)]=@admin alias=@stop @break/inline
&start`alias`attach [u(Cobj,start)]=@admin alias=@attach @include/override
&start`object`master_room [u(Cobj,start)]=@admin master_room=[after([u(cobj,master_room)],#)]
&start`config`02 [u(Cobj,start)]=@dolist/inline name contents exits={@admin format_##=1}
&start`config`01 [u(Cobj,start)]=@admin parentable_control_lock=1
&start`object`hook [u(cobj,start)]=@admin hook_obj=[after([u(cobj,bbk)],#)]
&start`object`admin [u(cobj,start)]=@admin admin_object=[after([u(cobj,bbk)],#)]
&start`access`help [u(cobj,start)]=@admin access=+help ignore
&start`access`shelp [u(cobj,start)]=@admin access=+shelp ignore
&start`access`news [u(cobj,start)]=@admin access=news ignore
&start`attributes`config [u(Cobj,start)]=@admin atrperms=CONFIG`:6:6
&start`attributes`vt [u(cobj,start)]=@admin atrperms=%VT`:6:6

@@ Functions
&strfirstof bbk=[ofparse(5,,%0,%1,%2,%3,%4,%5,%6,%7,%8,%9)]

&firstof bbk=[ofparse(1,%0,%1,%2,%3,%4,%5,%6,%7,%8,%9)]

&CAPs bbk=regeditalli(lcstr(%0),v(REG`CAPNAMES),capstr($1),v(REG`CAPNAMES3),lcstr($0),v(REG`CAPNAMES2),$1[capstr($2)])
&REG`CAPNAMES bbk=(?:^|(?<=[_\/\-\|\s()\+]))([a-z]+)
&REG`CAPNAMES2 bbk=(^|(?<=[(\|\/]))(of|the|a|and|in)
&REG`CAPNAMES3 bbk=\b(of|the|a|and|in)\b

&SU bbk=[u(su`[strmatch(%0,*_*)],%0)]
&SU`0 bbk=[edit([edit(%0,%B,_)],:,")]
&SU`1 bbk=[edit([edit(%0,_,%B)],",:)]

&gtm bbk=[gte([match(%0,%1,%2)],1)]

&CNUM bbk=[u(cnum`[strlen(before(%0,.))],%0)]
&cnum`0 bbk=%0
&cnum`1 bbk=%0
&cnum`10 bbk=[mid(%0,0,1)]\,[mid(%0,3,3)]\,[mid(%0,6,3)]\,[mid(%0,9,99)]
&cnum`2 bbk=%0
&cnum`3 bbk=%0
&cnum`4 bbk=[mid(%0,0,1)]\,[mid(%0,1,99)]
&cnum`5 bbk=[mid(%0,0,2)]\,[mid(%0,2,99)]
&cnum`6 bbk=[mid(%0,0,3)]\,[mid(%0,3,99)]
&cnum`7 bbk=[mid(%0,0,1)]\,[mid(%0,1,3)]\,[mid(%0,4,99)]
&cnum`8 bbk=[mid(%0,0,2)]\,[mid(%0,2,3)]\,[mid(%0,5,99)]
&cnum`9 bbk=[mid(%0,0,3)]\,[mid(%0,3,3)]\,[mid(%0,6,99)]

&isadmin bbk=[gte(bittype(%0),2)]
&isops bbk=[gte(bittype(%0),6)]
&iswiz bbk=[gte(bittype(%0),5)]
&isguest bbk=[hasflag(%0,GUEST)]
&isapproved bbk=[or([not([hasflag(%0,wanderer)])],[u(isadmin,%0)])]
&isnew bbk=[hasflag(%0,Wanderer)]
&isbldr bbk=[u(hastag,%0,BUILDER)]

&hastag bbk=[u(gtm,[get(%0/%vt`tags)],[ucstr(%1)])]

&playerid bbk=[setr(p1,[objid(u(strfirstof,%0,%#))])]
&accid bbk=[setr(a1,[get(%0/%vt`account_db)])]
&getid bbk=[setr(id,[u([u(cobj,core)]/get_id,%0,%1)])]



&installed bbk=[gtm([gameconfig(#1,SYSTEMS)],%0,|)]


&gameconfig bbk=[u([cobj(core)]/get_config,%0,%1,%2,%3,%4,%5,%6,%7,%8,%9)]
&gconfig bbk=[u(gameconfig,%0,%1,%2,%3,%4,%5,%6,%7,%8,%9)]

&staffrank bbk=[switch([bittype(%0)],6,[ansi([u(gconfig,%:,RANK_COLOR_OPS)],Ops)],5,[ansi([u(gconfig,%:,RANK_COLOR_WIZ)],Wiz)],4,[ansi([u(gconfig,%:,RANK_COLOR_ADM)],Adm)],3,[ansi([u(gconfig,%:,RANK_COLOR_BLD)],Bld)],2,[ansi([u(gconfig,%:,RANK_COLOR_STF)],STF)])]

&line`prep [u(Cobj,bbk)]=[setq(t1,firstof(%1,%!))][setq(fill,[u(gameconfig,%0,LINE_FILL)])][setq(fillcolor,[u(gameconfig,%0,LINE_COLOR)])][setq(filltext,[u(gameconfig,%0,LINE_TEXT)])][setq(fillstar,[u(gameconfig,%0,LINE_ACCENT)])][setq(fillwidth,[u(firstof,%1,[u(gameconfig,%0,WIDTH)])])]

&line [u(cobj,bbk)]=[u(line`prep,%1,%3)][u(line`[u(strfirstof,%2,center)],%0)]
&line`header [u(cobj,bbk)]=[printf($&^%q<fillwidth>:[ansi(%q<fillcolor>,%q<fill>)]:s,[if(gte(words(%0),1),[ansi(%q<fillcolor>,[chr(91)])][ansi(%q<fillstar>,:)]%B[ansi(%q<filltext>,%0)]%B[ansi(%q<fillstar>,:)][ansi(%q<fillcolor>,[chr(93)])],)])]
&line`center [u(cobj,bbk)]=[printf($&^%q<fillwidth>:[ansi(%q<fillcolor>,%q<fill>)]:s,[if(gte(words(%0),1),[ansi(%q<fillcolor>,[chr(91)])]%B[ansi(%q<filltext>,%0)]%B[ansi(%q<fillcolor>,[chr(93)])],)])]
&line`left [u(cobj,bbk)]=[printf($5:[ansi(%q<fillcolor>,%q<fill>)]:s$&-[sub(%q<fillwidth>,5)]:[ansi(%q<fillcolor>,%q<fill>)]:s,,[if(gte(words(%0),1),[ansi(%q<fillcolor>,[chr(91)])]%B[ansi(%q<filltext>,%0)]%B[ansi(%q<fillcolor>,[chr(93)])],)])]
&line`right [u(cobj,bbk)]=[printf($&[sub(%q<fillwidth>,5)]:[ansi(%q<fillcolor>,%q<fill>)]:s$5:[ansi(%q<fillcolor>,%q<fill>)]:s,[if(gte(words(%0),1),[ansi(%q<fillcolor>,[chr(91)])]%B[ansi(%q<filltext>,%0)]%B[ansi(%q<fillcolor>,[chr(93)])],)],)]
&line`cathead [u(Cobj,bbk)]=[printf($&^%q<fillwidth>s,[if(gte(words(%0),1),[ansi(%q<fillcolor>,[chr(91)])]%B[ansi(%q<filltext>,%0)]%B[ansi(%q<fillcolor>,[chr(93)])],)])]


&setr [u(cobj,bbk)]=[setr(%0,%1)]
&setq [u(cobj,bbk)]=[setq(%0,%1)]
&itemize [u(Cobj,bbk)]=[setq(ansi,%5)][elist(%0,%2,%1,%4,%3,[ansi(%q<ansi>,%0)])]


&run`switches [u(cobj,bbk)]=@attach %!/run`partial=%0,[u(get_switches,%#,%q<subsys>)],|,switch,Switches
&get_switches [u(cobj,bbk)]=[setunion([setr(lswitch,[iter(PLAYER [if(u(isadmin,%#),ADMIN)] [if(u(iswiz,%#),WIZARD)] [if(u(isops,%#),OPERATIONS)],[u(SWITCHES[if(gte(words(%1),1),`%1)]`##)],%B,|)])],%q<lswitch>,|)]

&run`partial [u(cobj,bbk)]=@select/inline or(not(strlen(%0)),[u(setq,color,[gameconfig(getid(%#),LINE_TEXT)])]u(setr,matched,match(%1,u(setr,u(strfirstof,%3,choice),%0),u(strfirstof,%2,%b))))=0,{@check words(u(setr,u(strfirstof,%3,choice),graball(%1,%0*,u(strfirstof,%2,%b),u(strfirstof,%2,%b))))=@attach %!/msg`error={Invalid [ansi(%q<Color>,%4)]! Valid choices are: [elist(%1,and,u(strfirstof,%2,%B),,,[ansi(%q<color>,%0)])]};@stop gt(words(r(u(strfirstof,%3,choice)),u(strfirstof,%2,%b)),1)=@attach %!/MSG`error={[ansi(%q<color>,%0)] matched [elist(r(u(strfirstof,%3,choice)),and,u(strfirstof,%2,%b),,,[ansi(%q<color>,%0)])]. Please be more specific.}},1,{@select/inline cand(t(strlen(%0)),t(%q<matched>))=1,{th u(setq,u(strfirstof,%3,choice),elements(%1,%q<matched>,u(strfirstof,%2,%b)))}}

&run`install [u(cobj,bbk)]=th [setq(slist,[u(get_config,%#,SYSTEMS)])];&config`SYSTEMS`custom [u(Cobj,gcs)]=[setunion(%q<slist>,[ucstr(%0)],|)]

&isinstalled [u(cobj,bbk)]=[gtm([u(gconfig,%!,systems)],[ucstr(%0)],|)]
&hasmodule [u(cobj,bbk)]=[setq(sys,[u(cobj,%0)])][gtm([u(%q<sys>/modules)],[ucstr(%1)],|)]

&SYSTEM`DESC BBK=The basic core systems for the game. This includes basic functions, help & info systems, game configuration options and core permission adjustments.
@fo me=&install`core [u(cobj,bbk)]=[objid(BBK)]
&install`core`date [u(cobj,bbk)]=[secs()]
&install`core`ver [u(cobj,bbk)]=1.0

&fold`addem [u(cobj,bbk)]=[add(%0,%1)]
&data`b36_digits [u(cobj,bbk)]=0 1 2 3 4 5 6 7 8 9 A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
&data`b36_powers [u(cobj,bbk)]=1 36 1296 46656 1679616 60466176
&data`b36_mags [u(Cobj,bbk)]=revwords(iter(v(data`b36_powers),switch([div(##,%0)]:[eq(##,%0)],0:*,##,*:1,##)))
&data`b36_B10 [u(cobj,bbk)]=[setq(0,ucstr(%0))][setq(1,strlen(%q0))][fold(me/fold`addem,[iter(lnum(%q1),mul(sub(member(v(data`b36_digits),mid(%q0,##,1)),1),power(36,sub(sub(%q1,##),1))))],0)]
&data`b10_b36 [u(cobj,bbk)]=[setq(0,%0)][edit(iter(u(data`b36_mags,%q0),[extract(v(data`b36_digits),add(div(%q0,##),1),1)][setq(0,sub(%q0,mul(##,div(%q0,##))))]),%b,)]
&get_next_num [u(cobj,bbk)]=[u(data`b10_b36,[add([u(data`b36_b10,%0)],1)])]


&run`getpc [u(cobj,bbk)]=@check [strlen(%0)]={@attach %!/msg`error=You must enter a player name.};@check strlen(%1);@check isdbref(setr(t%1,pmatch(%0)))={@attach %!/msg`error={%0 [if(strmatch(%q<t%1>,#-2*),matches multiple players.,does not match a player.)]}};th [setq(t%1objid,objid(%q<t%1>))];th [setq(t%1name,name(%q<t1>))];th [setq(t%1acc,u(accid,%q<t%1>))]
