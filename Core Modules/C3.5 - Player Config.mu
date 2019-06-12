&cmd`+config [u(cobj,core)]=$^\+config(?\:/(\\S+)?)?(?\: +(.+?))?(?\:=(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:/(.+?))?$:@attach %!/CMD`+CONFIG`MAIN
@set [u(cobj,core)]/CMD`+CONFIG=regexp
@set [u(Cobj,core)]/CMD`+config=no_inherit
&CMD`+CONFIG`MAIN [u(cobj,core)]=th [setq(subsys,CONFIG)];@attach %!/run`switches=%1;@attach %!/RUN`PCONFIG`[u(strfirstof,%q<switch>,MAIN)]=%2,%3,%4,%5,%6
&switches`config`player [u(Cobj,core)]=SET|CLEAR

&get_pconfig [u(Cobj,core)]=[u(get_pconfig`[if(gtm(LIST|TYPE,%0,|),%0,def)],%0,%1,%2,%3,%4,%5,%6,%7,%8,%9)]
&get_pconfig`def [u(cobj,core)]=[u(strfirstof,[get([u(getid,%0)]/config`%1`custom)],[get([u(cobj,gcs)]/config`%1`custom)],[get([u(cobj,gcs)]/config`%1`default)])]
&get_pconfig`list [u(cobj,core)]=[filter(fil`pconfig,[setunion([iter(lattr([u(cobj,bbk)]/install`*,,,,,1),[get([get([u(cobj,bbk)]/##)]/system`configs)])],[get([u(cobj,gcs)]/system`configs)])])]
&fil`pconfig [u(cobj,core)]=[get([u(cobj,gcs)]/config`%0`player)]
&get_pconfig`type [u(Cobj,core)]=[sort([iter([u(get_pconfig`list)],[if(gtm([get([u(cobj,gcs)]/config`##`type)],%1,|),##)])])]
&get_pconfig`types [u(cobj,core)]=[setq(types,[iter([u(get_pconfig`list)],[get([u(cobj,gcs)]/config`##`type)],%B,|)])][setunion(%q<types>,%q<types>,|)]

&run`pconfig`main [u(Cobj,bbk)]=@switch [setq(t1,getid(%#))]strlen(%0)=0,{@attach %!/run`pconfig`display},{@attach %!/run`partial=%0,[sort([u(get_pconfig`list)])],%B,config,Configuration Setting;@attach %!/run`config`view=%q<config>}

&run`pconfig`display [u(cobj,bbk)]=@pemit %#=[line([caps([v(system`name)])] Configuration,%#,Header)];@dolist/delimit | [u(get_pconfig`types)]={@attach %!/run`pconfig`list`fmt=%#,##};@wait 0={@pemit %#=[line(,%#)]}

&run`pconfig`list`fmt [u(Cobj,bbk)]=@pemit %#=[line([caps(%1)],%0)][step(run`config`step,sort([u(get_pconfig`type,%#,%1)]),3,,)]

&run`pconfig`set [u(cobj,bbk)]=@attach %!/run`partial=%0,sort(u(get_pconfig`list)),%B,op,Option;@attach %!/validator`[get([u(cobj,gcs)]/config`%q<op>`valid)]=%1;&config`%q<op>`custom [getid(%#)]=%q<value>;@attach %!/msg={You set the config option '%q<op>' to: %q<value>}

&run`pconfig`clear [u(cobj,bbk)]=@check [gte(words(%0),1)]={@attach %!/msg`error={You must provide a value to clear.}};@attach %!/run`partial=%0,sort(u(get_pconfig`list)),%B,op,Option;&config`%q<op>`custom [getid(%#)];@attach %!/msg={You clear the config option '%q<op>'.}
