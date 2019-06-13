@create Game Config Storage <GCS>
@set gcs=NO_MODIFY INDESTRUCTIBLE SAFE INHERIT
@parent gcs=BBK
@fo me=&cobj`gcs bbk=[objid(gcs)]

&newconfig [u(cobj,bbk)]=[setq(idb,[u(strfirstof,[u(cobj,%1)],[u(cobj,gcs)])])][set(%q<idb>,SYSTEM`CONFIGS:[setunion([u(%q<idb>/SYSTEM`configs)],[ucstr(%0)])])][set([u(cobj,gcs)],CONFIG`%0`TYPE:[ucstr(%2)],1)][set([u(cobj,gcs)],CONFIG`%0`DEFAULT:%3,1)][set([u(cobj,gcs)],CONFIG`%0`VALID:[ucstr(%4)],1)][set([u(cobj,gcs)],CONFIG`%0:{%5},1)][set([u(Cobj,gcs)],CONFIG`%0`PLAYER:[u(strfirstof,%6,0)])][pemit(%#,Done: %0)]

&newconfcat [u(cobj,bbk)]=[set([u(cobj,gcs)],CONFIG`TYPES:[setunion([u([u(cobj,gcs)]/config`types)],[ucstr(%0)],|)])][pemit(%#,Done: %0)]


@@ [getid(DBREF,CONFIG)]
&get_id [u(cobj,core)]=[if([u(installed,AMS)],[u(get_id`[type(%0)],%0)],[u(playerid,%0)])]
&get_id`thing [u(Cobj,core)]=[objid(%0)]
&get_id`player [u(cobj,core)]=[u(accid,%0)]

@@ [u(get_config,DBREF,CONFIG)]

&get_config [u(Cobj,core)]=[u([u(cobj,core)]/get_config`[if(gtm(LIST|TYPE|TYPES|PLIST|PTYPE|PTYPES,%0,|),%0,def)],%0,%1,%2,%3,%4,%5,%6,%7,%8,%9)]
&get_config`def [u(cobj,core)]=[firstof([get([u(get_id,%0,%1)]/config`%1`custom)],[get([u(cobj,gcs)]/config`%1`custom)],[get([u(cobj,gcs)]/config`%1`default)])]

&get_config`list [u(cobj,core)]=[setunion([iter(lattr([u(cobj,bbk)]/install`*,,,,,1),[get([get([u(cobj,bbk)]/##)]/system`configs)])],[get([u(cobj,gcs)]/system`configs)])]
&get_config`type [u(Cobj,core)]=[sort([iter([u(get_config`list)],[if(gtm([get([u(cobj,gcs)]/config`##`type)],%1,|),##)])])]
&get_config`types [u(cobj,core)]=[setq(types,[iter([u(get_config`list)],[get([u(cobj,gcs)]/config`##`type)],%B,|)])][setunion(%q<types>,%q<types>,|)]

&get_config`plist [u(cobj,core)]=[filter(fil`pconfig,[setunion([iter(lattr([u(cobj,bbk)]/install`*,,,,,1),[get([get([u(cobj,bbk)]/##)]/system`configs)])],[get([u(cobj,gcs)]/system`configs)])])]
&fil`config [u(cobj,core)]=[get([u(cobj,gcs)]/config`%0`player)]
&get_config`ptype [u(Cobj,core)]=[sort([iter([u(get_pconfig`list)],[if(gtm([get([u(cobj,gcs)]/config`##`type)],%1,|),##)])])]
&get_config`ptypes [u(cobj,core)]=[setq(types,[iter([u(get_pconfig`list)],[get([u(cobj,gcs)]/config`##`type)],%B,|)])][setunion(%q<types>,%q<types>,|)]


&cmd`+config [u(cobj,core)]=$^\+config(?\:/(\\S+)?)?(?\: +(.+?))?(?\:=(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?$:@attach %!/CMD`+CONFIG`MAIN
@set [u(cobj,core)]/CMD`+CONFIG=regexp
@set [u(Cobj,core)]/CMD`+config=no_inherit
&CMD`+CONFIG`MAIN [u(cobj,core)]=th [setq(subsys,CONFIG)];@attach %!/run`switches=%1;@attach %!/RUN`PCONFIG`[u(strfirstof,%q<switch>,MAIN)]=%2,%3,%4,%5,%6
&switches`config`player [u(Cobj,core)]=SET|CLEAR


&run`pconfig`main [u(Cobj,bbk)]=@switch [setq(t1,getid(%#))]strlen(%0)=0,{@attach %!/run`pconfig`display},{@attach %!/run`partial=%0,[sort([u(get_config`plist)])],%B,config,Configuration Setting;@attach %!/run`config`view=%q<config>}

&run`pconfig`display [u(cobj,bbk)]=@pemit %#=[line([caps([v(system`name)])] Configuration,%#,Header)];@dolist/delimit | [u(get_config`ptypes)]={@attach %!/run`pconfig`list`fmt=%#,##};@wait 0={@pemit %#=[line(+config <name> for more info,%#)]}

&run`pconfig`list`fmt [u(Cobj,bbk)]=@pemit %#=[line([caps(%1)],%0)][step(run`config`step,sort([u(get_config`ptype,%#,%1)]),3,,)]

&run`pconfig`set [u(cobj,bbk)]=@attach %!/run`partial=%0,sort(u(get_config`plist)),%B,op,Option;@attach %!/validator`[get([u(cobj,gcs)]/config`%q<op>`valid)]=%1;&config`%q<op>`custom [getid(%#)]=%q<value>;@attach %!/msg={You set the config option '%q<op>' to: %q<value>}

&run`pconfig`clear [u(cobj,bbk)]=@check [gte(words(%0),1)]={@attach %!/msg`error={You must provide a value to clear.}};@attach %!/run`partial=%0,sort(u(get_config`plist)),%B,op,Option;&config`%q<op>`custom [getid(%#)];@attach %!/msg={You clear the config option '%q<op>'.}

&cmd`+gameconfig [u(cobj,core)]=$^\+gameconfig(?\:/(\\S+)?)?(?\: +(.+?))?(?\:=(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?$:@attach %!/CMD`+GAMECONFIG`MAIN
@set [u(cobj,core)]/CMD`+GAMECONFIG=regexp
@set [u(Cobj,core)]/CMD`+gameconfig=no_inherit
&CMD`+GAMECONFIG`MAIN [u(cobj,core)]=@check [isadmin(%#)]={@attach %!/msg`error={Permission Denied.}};th [setq(subsys,GAMECONFIG)];@attach %!/run`switches=%1;@attach %!/RUN`CONFIG`[u(strfirstof,%q<switch>,MAIN)]=%2,%3,%4,%5,%6
&switches`gameconfig`admin [u(Cobj,core)]=SET|CLEAR


&run`config`main [u(Cobj,bbk)]=@switch [setq(t1,getid(%#))]strlen(%0)=0,{@attach %!/run`config`display},{@attach %!/run`partial=%0,[sort([u(get_config`list)])],%B,config,Configuration Setting;@attach %!/run`config`view=%q<config>}

&run`config`view [u(cobj,bbk)]=@pemit %#=[line([caps([u(system`name)])] Configuration,%#,header)]%R[align(25 [sub(80,26)],[ansi([u(get_config,%#,line_text)],Config Name)]:,%q<config>)]%R[align(25 [sub(80,26)],[ansi([u(get_config,%#,line_text)],Config Category)]:,[itemize([get([u(cobj,gcs)]/config`%q<config>`type)],&)] %([if([default([u(cobj,gcs)]/config`%q<config>`player,0)],[ansi([u(get_config,%#,line_accent)],Player Settable)],Staff Only)]%))]%R[align(25 [sub(80,26)],[ansi([u(get_config,%#,line_text)],Config Default)]:,[get([u(cobj,gcs)]/config`%q<config>`default)])]%R[align(25 [sub(80,26)],[ansi([u(get_config,%#,line_text)],Config Validator Type)]:,[get([u(cobj,gcs)]/config`%q<config>`valid)])]%R[align(25 [sub(80,26)],[ansi([u(get_config,%#,line_text)],Config Current)]:,[u(display`config`value,%#,%q<config>)])]%R[align(25 [sub(80,26)],[ansi([u(get_config,%#,line_text)],Config Description)]:,[get([u(cobj,gcs)]/config`%q<config>)])]%R[line(,%#)]

&display`config`value [u(Cobj,bbk)]=[u(display`config`[get([u(cobj,gcs)]/config`%1`valid)],[u(get_config,%0,%1)])]

&display`config`email [u(cobj,bbk)]=%0
&display`config`color [u(cobj,bbk)]=[ansi(%0,%0)]
&display`config`int [u(Cobj,bbk)]=%0
&display`config`word [u(Cobj,bbk)]=%0
&display`config`list [u(Cobj,bbk)]=[itemize(%0,|,&)] %(%0%)
&display`config`bool [u(Cobj,bbk)]=[if(%0,True %(1%),False %(0%))]
&display`config`dbref [u(cobj,bbk)]=[cname(%0)] %(%0%)
&display`config`duration [u(cobj,bbk)]=[singletime(%0)]
&display`config`tz [u(cobj,bbk)]=[ucstr(%0)]


&VALIDator`TZ [u(cobj,bbk)]=@check valid(timezone,[setr(value,%0)])=@attach %!/msg`error={That is not a valid timezone. Check help timezone}
&VALIDator`DURATION [u(cobj,bbk)]=@check [setr(value,u(stringsecs,%0))]=@attach %!/msg`error={'%0' did not resolve into a time.}

&STRINGSECS [u(cobj,bbk)]=ladd(iter(secure(regeditall(%0,(h|m|s),$1%b)),switch(%i0,*ML,mul(%i0,31536000000),*y,mul(%i0,31471200),*C,mul(%i0,3153600000),*Mo,mul(%i0,2628000),*w,mul(%i0,604800),*d,mul(%i0,86400),*h,mul(%i0,3600),*m,mul(%i0,60),*s,add(%i0,0))) 0)

&get_tz [u(cobj,bbk)]=[firstof([u(gconfig,%0,TIMEZONE)],[u(gconfig,%0,SYSTEM_TIMEZONE)])]


&validator`TIME [u(cobj,bbk)]=@check strlen(%0)=@attach %!/msg`error={You didn't enter a date!};@check gt([setr(time,convtime(%0,u(get_tz,%#)))],0)=@attach %!/msg`error={The entered date was not recognized. Did you typo? Dates should be in abbreviated 24-hour <month> <day> <hour>:<minute> format using YOUR timezone\, such as Jun 26 7:00 or Oct 31 13:00.}

&validator`email [u(cobj,bbk)]=th [setq(value,trim(%0))];@check strlen(%q<value>)=@attach %!/msg`error={Nothing entered!};@check lte(strlen(%q<value>),255)=@attach %!/msg`error={Emails must be 255 characters or less.};@stop strmatch(%q<value>,* *)=@attach %!/msg`error={Email addresses may not contain spaces.};@check strmatch(%q<value>,*@*.*)=@attach %!/msg`error={An Email must be in the format: *@*.* (example@game.com).}
&validator`color [u(cobj,bbk)]=@stop [strmatch([valid(colorname,[setr(value,%0)])],#-*)]={@attach %!/msg`error={'%q<value>' is not a valid color.}}
&validator`INT [u(cobj,bbk)]=@check isint(%0)=@attach %!/msg`error={'%0' must be a whole number 0 or greater.};th u(setq,value,%0)
&validator`WORD [u(cobj,bbk)]=th u(setq,value,trim(%0))
&validator`LIST [u(cobj,bbk)]=th u(setq,value,trim(%0))
&validator`BOOL [u(cobj,bbk)]=@check match(0 1,u(setr,value,%0))=@attach %!/MSG`error={BOOL options can only be 0 (false) or 1 (true).}
&validator`DBREF [u(cobj,bbk)]=@check isdbref(%0)=@attach %!/MSG`error={DBREF not found.};th u(setq,value,objid(%0))

&run`config`display [u(cobj,bbk)]=@pemit %#=[line([caps([v(system`name)])] Configuration,%#,Header)];@dolist/delimit | [u(get_config`types)]={@attach %!/run`config`list`fmt=%#,##};@wait 0={@pemit %#=[line(,%#)]}

&run`config`list`fmt [u(Cobj,bbk)]=@pemit %#=[line([caps(%1)],%0)][step(run`config`step,sort([u(get_config`type,%#,%1)]),3,,)]

&run`config`step [u(cobj,bbk)]=%R[align(26 26 26,[u(run`config`step`fmt,%0)],[u(run`config`step`fmt,%1)],[u(run`config`step`fmt,%2)])]
&run`config`step`fmt [u(Cobj,bbk)]=[if(gte(words(%0),1),[align(2 23,[if(hasattr([u(Cobj,gcs)],CONFIG`%0`CUSTOM),[ansi([u(gconfig,%#,LINE_ACCENT)],+,%B)])][if(u([u(Cobj,gcs)]/CONFIG`%0`PLAYER),[ansi([u(gconfig,%#,LINE_ACCENT)],P,%B)])],%0)])]

&run`config`set [u(cobj,bbk)]=@attach %!/run`partial=%0,sort(u(get_config`list)),%B,op,Option;@attach %!/validator`[get([u(cobj,gcs)]/config`%q<op>`valid)]=%1;&config`%q<op>`custom [u(cobj,gcs)]=%q<value>;@attach %!/msg={You set the config option '%q<op>' to: %q<value>};@attach %!/msg`chan=Config option '%q<op>' set to %q<value>

&run`config`clear [u(cobj,bbk)]=@attach %!/run`partial=%0,sort(u(get_config`list)),%B,op,Option;&config`%q<op>`custom [u(cobj,gcs)];@attach %!/msg={You clear the config option '%q<op>'.};@attach %!/msg`chan=Config option '%q<op>' cleared.
