@create Location Commands <LOCATIONS>
@set LOCATIONS=NO_MODIFY INDESTRUCTIBLE SAFE SIDEFX COMMANDS INHERIT
@parent LOCATIONS=[u(cobj,BBK)]
@fo me=&cobj`LOCATIONS [u(cobj,BBK)]=[objid(LOCATIONS)]
@tel [u(cobj,locations)]=#[config(master_room)]
&system`name [u(cobj,locations)]=LOCATION

@create Area Management System <AREA>
@set AREA=NO_MODIFY INDESTRUCTIBLE SAFE SIDEFX COMMANDS INHERIT
@parent AREA=[u(cobj,BBK)]
@fo me=&cobj`area [u(cobj,BBK)]=[objid(AREA Management)]
@tel [u(cobj,area)]=#[config(master_room)]
&system`name [u(cobj,area)]=AREA

@create Area Parent Object <APar>
@set Apar=NO_MODIFY INDESTRUCTIBLE SAFE SIDEFX INHERIT
@parent Apar=[u(cobj,BBK)]
@fo me=&cobj`apar [u(cobj,BBK)]=[objid(apar)]
@tel [u(cobj,apar)]=[u(cobj,area)]

@create Map Parent Object <MPO>
@set mpo=NO_MODIFY INDESTRUCTIBLE SAFE SIDEFX INHERIT
@parent mpo=bbk
@fo me=&cobj`mpo bbk=[objid(MPO)]
@tel [u(cobj,mpo)]=[u(cobj,locations)]


&system`desc [u(cobj,locations)]=This is the basic system for Maps, +who, +where and Areas.
th [u(newconfcat,Locations)]
@@ [u(newconfig,CONFIG NAME,SYSTEM MONIKER,CONFIG CATEGORY,DEFAULT,VALIDATOR,DESCRIP,PLAYER)]
th [u(newconfig,STATUS_COLOR_SCLOAK,LOCATIONS,Locations,+firebrick2,COLOR,The color for a member of staff that is using Super Cloak.)]
th [u(newconfig,STATUS_COLOR_CLOAK,LOCATIONS,Locations,+debianred,COLOR,The color for a member of staff that is using Cloak.)]
th [u(newconfig,STATUS_COLOR_DARK,LOCATIONS,Locations,+darkslategrey,COLOR,The color for a member of staff that is using Dark.)]
th [u(newconfig,STATUS_COLOR_HIDE,LOCATIONS,Locations,+darkorchid,COLOR,The color for a member of staff that is using @hide.)]
th [u(newconfig,STATUS_COLOR_UNFINDABLE,LOCATIONS,Locations,+darkseagreen,COLOR,The color for an unfindable player.)]

&cmd`who [u(cobj,locations)]=$^(?s)(?\:\+)?(who)$:@attach %!/run`get_player_list=%#;th [setq(clr,[u(gconfig,%#,COLUMN_NAMES)])];@pemit %#=[line([u(gconfig,%#,Game_name)] -- +who,%#,header)]%R[printf($-3:.:s $-28:.:s $-5:.:s $1s $-23:.:s $-7:.:s $-7:.:s,[ansi(%q<clr>,Sts)],[ansi(%q<clr>,Name)],[ansi(%q<clr>,Alias)],[ansi(%q<clr>,S)],[ansi(%q<clr>,Area)],[ansi(%q<clr>,Idle)],[ansi(%q<clr>,Conn)])];@dolist %q<who>={@pemit %#=[printf($-3s $-28s $-5s $1s $-23s $-7s $-7s,[u(get_status,##)],[cname(##)],[default(##/alias,--)],[firstof([mid([get(##/sex)],0,1)],N)],[u(get_area,##)],hideidle(##),singletime(conn(##)))]};@wait 0={@pemit %#=[line([u(get_footer,%q<who>)],%#)]}



&get_FOOTER [u(cobj,locations)]=[setq(lact,[iter(%0,u(accid,##))])][setq(acts,[setunion(%q<lact>,%q<lact>)])][words(%q<acts>)] Account[u(pl,words(%q<acts>))] - [words(%q<who>)] Character[u(pl,[words(%q<who>)])] Connected

&pl [u(cobj,bbk)]=[switch(%0,1,,s)]

&run`get_player_list [u(cobj,locations)]=th [setq(raw,[lwho()])][setq(bit,[bittype(%0)])][setq(fil,[filter(filter`who`%q<bit>,%q<raw>)])][setq(who,[sortname(%q<fil>)])]
&filter`who`6 [u(cobj,locations)]=1
&filter`who`5 [u(cobj,locations)]=[not([hasflag(%0,SCLOAK)])]
&filter`who`4 [u(cobj,locations)]=[and([u(filter`who`5,%0)],[not([hasflag(%0,cloak)])])]
&filter`who`3 [U(cobj,locations)]=[u(filter`who`4,%0)]
&filter`who`2 [u(cobj,locations)]=[u(filter`who`3,%0)]
&filter`who`1 [u(cobj,locations)]=[and([u(filter`who`2,%0)],[not([hasflag(%0,NO_WHO)])],[not([hasflag(%0,DARK)])])]
&filter`who`0 [u(cobj,locations)]=[u(filter`who`1,%0)]



&get_status [u(cobj,locations)]=[switch(1,[hasflag(%0,SCLOAK)],[ansi([u(gconfig,%#,STATUS_COLOR_SCLOAK)],SCK)],[hasflag(%0,CLOAK)],[ansi([u(gconfig,%#,STATUS_COLOR_CLOAK)],CLK)],[hasflag(%0,Dark)],[ansi([u(gconfig,%#,STATUS_COLOR_DARK)],DRK)],[hasflag(%0,NO_WHO)],[ansi([u(gconfig,%#,STATUS_COLOR_HIDE)],HID)],[isops(%0)],[ansi([u(gconfig,%#,Rank_color_ops)],OPS)],[iswiz(%0)],[ansi([u(gconfig,%#,Rank_color_wiz)],WIZ)],[gtm(3 4,bittype(%0))],[ansi([u(gconfig,%#,Rank_color_adm)],ADM)],[isadmin(%0)],[ansi([u(gconfig,%#,Rank_color_stf)],STF)],[isbldr(%0)],[ansi([u(gconfig,%#,Rank_color_bld)],BLD)],[isguest(%0)],[ansi([u(gconfig,%#,Rank_color_GST)],GST)],[isnew(%0)],[ansi([u(gconfig,%#,Rank_color_New)],NEW)],[u(isic,%0)],[ansi([u(gconfig,%#,IC_TAG)],IC)],[ansi([u(gconfig,%#,OOC_TAG)],OOC)])]



@set [u(Cobj,locations)]/cmd`who=regexp

&get_area [u(cobj,locations)]=[strfirstof([cname([area(loc(%0))])],Unknown)]

&start`function`area [u(cobj,start)]=@function/privileged/preserve area=[u(cobj,locations)]/area
&area [u(cobj,locations)]=[u(area`[strfirstof(%1,def)],%0)]

&area`def [u(cobj,locations)]=[setq(zones,[lzone(%0)])][setq(areas,[filter(filter`is_area,%q<zones>)])][setq(area,first(%q<areas>))]%q<area>

&area`list [u(cobj,locations[setq(zones,[lzone(%0)])][setq(areas,[filter(filter`is_area,%q<zones>)])]%q<areas>

&area`type [u(cobj,locations)]=[setq(r1,[children([u(cobj,apar)])])][setq(r2,[iter(%q<r1>,children(##))])][setq(r3,[iter(%q<r2>,children(##))])][setq(r4,[iter(%q<r3>,children(##))])][setq(raw,[setdiff(%q<r1> %q<r2> %q<r3> %q<r4>,#-1)])][setq(list,[iter(%q<raw>,name(##),%B,|)])][setq(db,[extract(%q<raw>,[match(%q<list>,%0,|)],1)])][setq(a1,[if(isdbref(%q<db>),[objid(%q<db>)])])][match(parents(%q<a1>),[before([u(cobj,apar)],:)])]

&filter`is_area [u(cobj,locations)]=[gtm([parents(%0)],[before([u(cobj,apar)],:)])]

&cmd`area [u(cobj,area)]=$^(?s)(?\:\+)?(area|areas)(?\:/(\\S+)?)?(?\: +(.+?))?(?\:=(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?$:@attach %!/CMD`Area`MAIN
@set [u(cobj,area)]/cmd`area=regexp
@set [u(cobj,area)]/cmd`area=no_inherit
&cmd`area`main [u(cobj,area)]=@attach %!/run`switches=%2;@attach %!/run`[u(strfirstof,%q<switch>,MAIN)]=%3,%4,%5,%6,%7,%8,%9

&switches`player [u(cobj,area)]=
&switches`builder [u(cobj,area)]=ADD|REMOVE
&switches`admin [u(cobj,area)]=CREATE|DESTROY|IC|CREATESUB|COLOR

&run`remove [u(cobj,area)]=@attach %!/run`checkarea=[name([area(%L)])],1;@attach %!/run`partial=[area(%L)],%q<objid>,%B,a1,Area DBREF;@check [isdbref(area(%L))]={@attach %!/msg`error={Your current location is not part of an area. You must use [ansi([u(gconfig,%#,line_text)],+area/add)] before you can remove it from an area.}};@zone/del %L=%q<a1>;@attach %!/msg={You remove '[name(%l)]' from the '[cname(%q<a1>)]' area.}

&run`add [u(cobj,area)]=@attach %!/run`checkarea=name(%0),1;@attach %!/run`partial=%0,%q<objid>,%B,a1,Area DBREF;@check [not([isdbref(area(%l))])]={@attach %!/msg`error={Your current location is already part of an area. You must use [ansi([u(gconfig,%#,line_text)],+area/remove)] before you can add it to area '[cname(%q<a1>)]'}};@zone/add %L=%q<a1>;@attach %!/msg={You add '[name(%l)]' to the '[cname(%q<a1>)]' area.}

&run`color [u(cobj,area)]=@attach %!/run`checkarea=%0,1;@attach %!/run`partial=%0,%q<objid>,%B,a1,Area DBREF;@attach %!/VALIDATOR`color=%1;@ansiname %q<a1>=[ansi(%1,[name(%q<a1>)])];@attach %!/msg={[setr(msg,'[cname(%q<a1>)]' has been updated with the color [ansi(%1,%1)].)]};@attach %!/msg`chan={%q<msg>}

&run`ic [u(cobj,area)]=@attach %!/run`checkarea=%0,1;@switch [hasflag(%q<a1>,IC)]=0,{@set %q<a1>=IC;@attach %!/msg={[setr(msg,'[cname(%q<a1>)]' has been set to be IC.)]};@attach %!/msg`chan={%q<msg>}},1,{@set %q<a1>=!IC;@attach %!/msg={[setr(msg,'[cname(%q<a1>)]' has been set to be OOC.)]};@attach %!/msg`chan={%q<msg>}}

&run`destroy [u(Cobj,area)]=@attach %!/run`checkarea=%0,1;@attach %!/run`partial=%0,%q<objid>,%B,a1,Area DBREF;@check [not([gte(words([u(clean_child,%q<a1>)]),1)])]={@attach %!/msg`error={'[cname(%q<a1>)]' has child areas. You must remove those first.}};@attach %!/msg={[setr(msg,'[name(%q<a1>)]' has been destroyed.)]};@destroy %q<a1>;@attach %!/msg`chan={%q<msg>}

&run`checkarea [u(cobj,area)]=th [setq(r1,[children([u(cobj,apar)])])][setq(r2,[iter(%q<r1>,children(##))])][setq(r3,[iter(%q<r2>,children(##))])][setq(r4,[iter(%q<r3>,children(##))])][setq(raw,[setdiff(%q<r1> %q<r2> %q<r3> [if(strfirstof(%1,1),%q<r4>)],#-1)])][setq(objid,[iter(%q<raw>,[objid(##)])])][setq(list,[iter(%q<raw>,name(##),%B,|)])][setq(db,[extract(%q<raw>,[match(%q<list>,%0,|)],1)])][setr(a1,[if(isdbref(%q<db>),[objid(%q<db>)])])]

&run`createsub [u(cobj,area)]=@attach %!/run`checkarea=%0,0;@check [isdbref(%q<a1>)]={@attach %!/msg`error={'%0' is not a valid area for this command.}};@check [not([gtm([iter(children(setr(par,%q<a1>)),name(##),%B,|)],%1,|)])]={@attach %!/msg`error={'%1' is already an area under '[name(%q<par>)]'.}};th [setq(area,[create(%1)])];@parent %q<area>=%q<par>;@set %q<area>=zonemaster;@tel %q<area>=%q<par>;@toggle %q<area>=extansi;@attach %!/msg={[setr(msg,'[name(%q<area>)]' has been added under '[name(%q<par>)]'.)]};@attach %!/msg`chan={%q<msg>}

&run`create [u(cobj,area)]=@check [not([gtm([iter(children([setr(par,[u(cobj,apar)])]),name(##),%B,|)],%0,|)])]={@attach %!/msg`error={'%0' is already an area.}};th [setq(area,[create(%0)])];@parent %q<area>=%q<par>;@set %q<area>=zonemaster;@tel %q<area>=%q<par>;@toggle %q<area>=extansi;@attach %!/msg={[setr(msg,'[name(%q<area>)]' has been added.)]};@attach %!/msg`chan={%q<msg>}

&run`main [u(cobj,area)]=@pemit %#=[line(Master Area List,%#,header)]%R[printf($3:.:s $-40:.:s $-5:.:s $-20:.:s,[ansi([setr(c,[u(gconfig,%#,COLUMN_NAMES)])],IC?)],[ansi(%q<c>,Area Name)],[ansi(%q<c>,# Rms)],[ansi(%q<c>,Area DBREF)])];@dolist [sortname([children([u(cobj,apar)])])]={@attach %!/get_area_groups=##;@attach %!/display`over=##};@wait 0.2={@pemit %#=[line(,%#)]}

&get_area_groups [u(Cobj,area)]=th [setq(o1,%0)][setq(r1,[iter(%q<o1>,[children(##)])])][setq(l1,[iter(%q<r1>,children(##))])][setq(s1,[iter(%q<l1>,children(##))])][setq(overworld,%0)][setq(region,[setdiff(%q<r1>,#-1)])][setq(local,[setdiff(%q<l1>,#-1)])][setq(subdivision,[setdiff(%q<s1>,#-1)])]

&display`over [u(Cobj,area)]=@pemit %#=[printf($3s $-40s $-5s $-20s,%[[if([hasflag(%0,IC)],[ansi(u(gconfig,%#,line_accent),*)],%B)]%],[cname(%0)],[words(lzone(%0))],[objid(%0)])][if([gte(words([setr(reg,[u(clean_child,%0)])]),1)],%R[iter(%q<reg>,[u(display`region,##)],%B,%R)])]

&display`region [u(Cobj,area)]=[printf($3s $1s $-38s $-5s $-20s,%[[if([u(parent_ic,%0)],[ansi(u(gconfig,%#,line_accent),*)],%B)]%],[ansi(u(gconfig,%#,line_accent),[chr(187)])],[cname(%0)],[words(lzone(%0))],[objid(%0)])][if([gte(words([setr(reg,[u(clean_child,%0)])]),1)],%R[iter(%q<reg>,[u(display`local,##)],%B,%R)])]

&display`local [u(Cobj,area)]=[printf($3s $2s $-37s $-5s $-20s,%[[if([u(parent_ic,%0)],[ansi(u(gconfig,%#,line_accent),*)],%B)]%],[ansi(u(gconfig,%#,line_accent),[chr(187)])],[cname(%0)],[words(lzone(%0))],[objid(%0)])][if([gte(words([setr(reg,[u(clean_child,%0)])]),1)],%R[iter(%q<reg>,[u(display`subdivision,##)],%B,%R)])]

&display`subdivision [u(Cobj,area)]=[printf($3s $3s $-36s $-5s $-20s,%[[if([u(parent_ic,%0)],[ansi(u(gconfig,%#,line_accent),*)],%B)]%],[ansi(u(gconfig,%#,line_accent),[chr(187)])],[cname(%0)],[words(lzone(%0))],[objid(%0)])]

&clean_child [u(cobj,area)]=[setdiff(children(%0),#-1)]

&parent_ic [u(cobj,area)]=[or([gte([words([filter(Filter`ic,[parents(%0)])])],1)],[hasflag(%0,IC)])]
&filter`ic [u(cobj,bbk)]=[hasflag(%0,IC)]
&isic [u(cobj,bbk)]=[u([u(cobj,area)]/parent_ic,area(loc(%0)))]

&cmd`where2 [u(cobj,locations)]=$^(?s)(?\:\+)?(showme)$:@attach %!/run`get_player_list=%#;@attach %!/run`get_rooms=%q<who>;th [setq(clr,[u(gconfig,%#,COLUMN_NAMES)])];@pemit %#=[line([u(gconfig,%#,Game_name)] -- +where,%#,header)]%R;@dolist ho [lnum(0,20)]={@pemit %#=## - %q<w##>};@wait 0={@pemit %#=[line([u(get_footer,%q<who>)],%#)]}

@set [u(cobj,locations)]/cmd`where2=regexp

&cmd`where [u(cobj,locations)]=$^(?s)(?\:\+)?(where)$:@attach %!/run`get_player_list=%#;@attach %!/run`get_rooms=%q<who>;th [setq(clr,[u(gconfig,%#,COLUMN_NAMES)])];@pemit %#=[line([u(gconfig,%#,Game_name)] -- +where,%#,header)]%R[printf($-39:.:s %B$-39:.:s,[ansi(u(gconfig,%#,column_names),Location Name)],[ansi(u(gconfig,%#,column_names),Players At Location)])];@dolist [sortname(%q<w8>)]={@pemit %#=[u(display`where,##,0)]};@wait 0={@pemit %#=[if(isadmin(%#),,[printf($-39s %B$-39s,[ansi(u(gconfig,%#,STATUS_COLOR_UNFINDABLE),Unfindable)]:,[u(display`players`unfind,%q<w1>)])]%R)][line([u(get_footer,%q<who>)],%#)]}

&run`make_players [u(cobj,locations)]=[setq(occ,[iter(graball(%1,%0~*,|),[after(##,~)],|,%B)])][itemize([iter(%q<occ>,[cname(##)]%B%([hideidle(##)]%),%B,|)],&,|)]
@set [u(Cobj,locations)]/cmd`where=regexp
&fil`where`6 [u(Cobj,locations)]=1
&fil`where`5 [u(Cobj,locations)]=1
&fil`where`4 [u(Cobj,locations)]=1
&fil`where`3 [u(Cobj,locations)]=1
&fil`where`2 [u(Cobj,locations)]=1
&fil`where`1 [u(cobj,locations)]=[or([gtm(loc(%#),loc(%0))],[findable(%#,%0)])]
&fil`where`0 [U(cobj,locations)]=[or([gtm(loc(%#),loc(%0))],[findable(%#,%0)])]

&run`makelist [U(cobj,locations)]=[setq(grabs,[graball(%1,%0~*)])][iter(%q<grabs>,[after(##,~)])]
&run`get_rooms [u(cobj,locations)]=th [setq(w0,[setq(lkr,%#)][filter(fil`where`[bittype(%#)],%0)])][setq(w1,[setdiff(%0,%q<w0>)])][setq(w2,children([u(cobj,apar)]))][setq(w3,iter(%q<w0>,room(##)))][setq(w4,iter(%q<w3>,area(##)))][setq(w5,setunion(%q<w4>,%q<w4>))][setq(w6,[iter(%q<w5>,parents(##))])][setq(w7,[setunion(%q<w4>,%q<w6>)])][setq(w8,setinter(%q<w2>,%q<w7>))][setq(w9,iter(%q<w0>,[room(##)]~##))]


&display`where [u(cobj,locations)]=[setq(rooms,sortname([setinter([lzone(%0)],%q<w3>)]))][setq(subs,sortname([setinter([children(%0)],%q<w4>)]))][printf($-39s %B$-39s,[if(%1,[space(mul(%1,2))][ansi(u(gconfig,%#,line_accent),[chr(187)])]%B)][cname(%0)],)][if(gte(words(%q<rooms>),1),%R[iter(%q<rooms>,[u(display`where`room,##,add(%1,1),%q<w9>)],%B,%R)])][if(gte(words(%q<subs>),1),%R[iter(%q<subs>,[u(display`where,##,add(%1,1),%q<w9>)],%B,%R)])]

&display`where`room [u(cobj,locations)]=[printf($-39s %B$-39s,[if(%1,space(mul(%1,2))%B)][cname(%0)],[u(display`players,%0,%2)])]

&display`players [u(cobj,locations)]=[setq(n1,[graball(%1,%0~*)])][setq(n2,iter(%q<n1>,after(##,~)))][setq(n3,[iter(sortname(%q<n2>),[u(display`players`name,##)],%B,|)])][itemize(%q<n3>,|,&)]

&display`players`name [u(cobj,locations)]=[if(isadmin(%0),ansi(u(gconfig,%#,line_accent),*))][cname(%0)][if(or(hasflag(%0,Scloak),hasflag(%0,cloak),hasflag(%0,dark),hasflag(%0,no_who),hasflag(%0,Unfindable)),%[[switch(1,[hasflag(%0,SCLOAK)],[ansi(u(gconfig,%#,STATUS_COLOR_SCLOAK),S)],[hasflag(%0,CLOAK)],[ansi(u(gconfig,%#,STATUS_COLOR_CLOAK),C)],[hasflag(%0,dark)],[ansi(u(gconfig,%#,STATUS_COLOR_DARK),D)],[hasflag(%0,NO_WHO)],[ansi(u(gconfig,%#,STATUS_COLOR_HIDE),H)],[hasflag(%0,Unfindable)],[ansi(u(gconfig,%#,STATUS_COLOR_UNFINDABLE),U)])]%])]%([hideidle(%0)]%)

&display`players`unfind [u(cobj,locations)]=[setq(u1,[iter(sortname(%0),[u(display`players`unfind`names,##)],%B,|)])][itemize(%q<u1>,|,&)]
&display`players`unfind`names [u(cobj,locations)]=[if(isadmin(%0),ansi(u(gconfig,%#,line_accent),*))][cname(%0)]%([hideidle(%0)]%)

@@ [u(newconfig,CONFIG NAME,SYSTEM MONIKER,CONFIG CATEGORY,DEFAULT,VALIDATOR,DESCRIP,PLAYER)]
th [u(newconfig,MASTER_MAP,LOCATIONS,Locations,,DBREF,The object dbref that will be used for the default master map.)]
th [u(newconfig,USE_AREA_MAPS,LOCATIONS,Locations,0,BOOL,Does your game support maps for each +area or do you just use the master map?)]



&cmd`map [u(cobj,locations)]=$^\+map(?\:/(\\S+)?)?(?\: +(.+?))?(?\:=(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?$:@attach %!/CMD`map`MAIN
@set [u(cobj,locations)]/cmd`map=regexp
&cmd`map`main [u(cobj,locations)]=th [setq(subsys,MAP)];@attach %!/run`switches=%1;@attach %!/run`map`[u(strfirstof,%q<switch>,MAIN)]=%2,%3,%4,%5,%6,%7,%8,%9

&switches`map`player [u(cobj,locations)]=
&switches`map`admin [u(cobj,locations)]=ADD|REMOVE|INIT

&run`map`init [u(cobj,locations)]=@check [isdbref(%0)]={@attach %!/msg`error={You must use the DBREF of the object you want to setup as a map.}};@check [not([gtm([parent(%0)],[u(Cobjdb,mpo)])])]={@attach %!/msg`error={'[cname(%0)]' is already setup as a map object.}};@parent %0=[u(cobj,mpo)];@attach %!/msg={You have added the '[cname(%0)]' as a map object.}


&run`map`main [u(cobj,locations)]=@check [gte(strlen(%0),1)]={@check [u(gconfig,%#,USE_AREA_MAPS)]={@attach %!/display`map=MASTER};@attach %!/display`map=[area(%L)]};@attach %!/run`get_mapdb=%0;@attach %!/draw`map=%q<mdb>

&display`map [u(cobj,locations)]=@attach %!/display`map`[firstof(%0,DEFAULT)]
&display`map`master [u(Cobj,locations)]=@check [isdbref([setr(mm,[u(gconfig,%#,MASTER_MAP)])])]={@attach %!/msg`error={There is no master map object assigned to the system.}};@attach %!/draw`map=%q<mm>,%#
&display`map`default [u(Cobj,locations)]=@check [hasattrp(%0,%VT`MAPDB)]={@attach %!/msg`error={The '[cname(%0)]' area does not have a map specific to it.}};th [setq(mdb,[u(%0/%VT`MAPDB)])];@attach %!/draw`map=%q<mdb>,[loc(%#)]

&draw`map [u(cobj,locations)]=@pemit %#=[line([name(%0)] Map,%#,header)];@dolist [sort([lattrp(%0/line-*)])]={@pemit %#=[u(%0/##,%1)]};@wait 0={@pemit %#=[line(,%#)]}


@@ Mapfn(PLAYER,X,Y,CHAR)
&mapfn [u(cobj,locations)]=[setq(loc,room(%0))][setq(cx,[get(%q<loc>/%VT`MAP`X)])][setq(cy,[get(%q<loc>/%VT`MAP`Y)])][switch([gtm(%q<cx>,%1)]:[gtm(%q<cy>,%2)],1:1,[ansi([u(gconfig,%0,LINE_ACCENT)],%3)],%3)]

&start`function`mapfn [U(cobj,start)]=@function/privileged/preserve mapfn=[u(cobj,locations)]/mapfn
