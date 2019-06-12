@create Game Config Storage <GCS>
@set gcs=NO_MODIFY INDESTRUCTIBLE SAFE INHERIT
@parent gcs=BBK
@fo me=&cobj`gcs bbk=[objid(gcs)]


&newconfig [u(cobj,bbk)]=[setq(idb,[u(strfirstof,[u(cobj,%1)],[u(cobj,gcs)])])][set(%q<idb>,SYSTEM`CONFIGS:[setunion([u(%q<idb>/SYSTEM`configs)],[ucstr(%0)])])][set([u(cobj,gcs)],CONFIG`%0`TYPE:[ucstr(%2)],1)][set([u(cobj,gcs)],CONFIG`%0`DEFAULT:%3,1)][set([u(cobj,gcs)],CONFIG`%0`VALID:[ucstr(%4)],1)][set([u(cobj,gcs)],CONFIG`%0:{%5},1)][set([u(Cobj,gcs)],CONFIG`%0`PLAYER:[u(strfirstof,%6,0)])][pemit(%#,Done: %0)]
&newconfcat [u(cobj,bbk)]=[set([u(cobj,gcs)],CONFIG`TYPES:[setunion([u([u(cobj,gcs)]/config`types)],[ucstr(%0)],|)])][pemit(%#,Done: %0)]

&get_config [u(Cobj,core)]=[u(get_config`[if(gtm(LIST|TYPE|TYPES,%0,|),%0,def)],%0,%1,%2,%3,%4,%5,%6,%7,%8,%9)]
&get_config`def [u(cobj,core)]=[u(strfirstof,[get([u(getid,%0)]/config`%1`custom)],[get([u(cobj,gcs)]/config`%1`custom)],[get([u(cobj,gcs)]/config`%1`default)])]
&get_config`list [u(cobj,core)]=[setunion([iter(lattr([u(cobj,bbk)]/install`*,,,,,1),[get([get([u(cobj,bbk)]/##)]/system`configs)])],[get([u(cobj,gcs)]/system`configs)])]
&get_config`type [u(Cobj,core)]=[sort([iter([u(get_config`list)],[if(gtm([get([u(cobj,gcs)]/config`##`type)],%1,|),##)])])]
&get_config`types [u(cobj,core)]=[setq(types,[iter([u(get_config`list)],[get([u(cobj,gcs)]/config`##`type)],%B,|)])][setunion(%q<types>,%q<types>,|)]


@@ COMMANDS



&cmd`+gameconfig [u(cobj,core)]=@attach %!/CMD`+GAMECONFIG`MAIN
@set [u(cobj,core)]/CMD`+GAMECONFIG=regexp
@set [u(Cobj,core)]/CMD`+gameconfig=no_inherit
&CMD`+GAMECONFIG`MAIN [u(cobj,core)]=@check [isadmin(%#)]={@attach %!/msg`error={Permission Denied.}};th [setq(subsys,GAMECONFIG)];@attach %!/run`switches=%1;@attach %!/RUN`CONFIG`[u(strfirstof,%q<switch>,MAIN)]=%2,%3,%4,%5,%6
&switches`gameconfig`admin [u(Cobj,core)]=SET|CLEAR


&run`config`main [u(Cobj,bbk)]=@switch [setq(t1,getid(%#))]strlen(%0)=0,{@attach %!/run`config`display},{@attach %!/run`partial=%0,[sort([u(get_config`list)])],%B,config,Configuration Setting;@attach %!/run`config`view=%q<config>}

&run`config`view [u(cobj,bbk)]=@pemit %#=[line([caps([u(system`name)])] Configuration,%#,header)]%R[align(25 [sub(80,26)],[ansi([u(get_config,%#,line_text)],Config Name)]:,%q<config>)]%R[align(25 [sub(80,26)],[ansi([u(get_config,%#,line_text)],Config Category)]:,[itemize([get([u(cobj,gcs)]/config`%q<config>`type)],&)] %([if([default([u(cobj,gcs)]/config`%q<config>`player,0)],[ansi([u(get_config,%#,line_accent)],Player Settable)],Staff Only)]%))]%R[align(25 [sub(80,26)],[ansi([u(get_config,%#,line_text)],Config Default)]:,[get([u(cobj,gcs)]/config`%q<config>`default)])]%R[align(25 [sub(80,26)],[ansi([u(get_config,%#,line_text)],Config Validator Type)]:,[get([u(cobj,gcs)]/config`%q<config>`valid)])]%R[align(25 [sub(80,26)],[ansi([u(get_config,%#,line_text)],Config Current)]:,[u(display`config`value,%#,%q<config>)])]%R[align(25 [sub(80,26)],[ansi([u(get_config,%#,line_text)],Config Description)]:,[get([u(cobj,gcs)]/config`%q<config>)])]%R[line(,%#)]

&display`config`value [u(Cobj,bbk)]=[setq(lkr,[if([default([u(cobj,gcs)]/config`%1`player,0)],[getid(%0)],[u(cobj,gcs)])])][u(display`config`[get([u(cobj,gcs)]/config`%1`type)],%q<lkr>,[u(%q<lkr>/config`%1`[if(hasattr(%q<lkr>,config`%1`custom),custom,default)])])]



&display`config`color [u(cobj,bbk)]=[ansi(%1,%1)]


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
