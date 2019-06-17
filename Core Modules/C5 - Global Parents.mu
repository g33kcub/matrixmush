th [u(newconfig,GP_ROOM,CORE,SYSTEM,,DBREF,The Global Parent for Rooms.)]
th [u(newconfig,GP_EXIT,CORE,SYSTEM,,DBREF,The Global Parent for Exits.)]
th [u(newconfig,GP_PLAYER,CORE,SYSTEM,,DBREF,The Global Parent for Players.)]
th [u(newconfig,CONFORMAT,CORE,COSMETIC,DEFAULT,WORD,Which formatting to use for Global Rooms.,1)]
th [u(newconfig,EXITFORMAT,CORE,COSMETIC,DEFAULT,WORD,Which formatting to use for Global Rooms.,1)]
th [u(newconfig,DARK_EXITS,CORE,COSMETIC,+darkolivegreen4,COLOR,This is the color used for the default dark exits within the game.,1)]

@dolist ROOM EXIT PLAYER={@create Global Parent ## <##>;@set Global Parent ## <##>=NO_MODIFY INDESTRUCTIBLE SAFE INHERIT;+gameconfig/set GP_##=[objid(##)];&cobj`## [u(cobj,bbk)]=[objid(##)];@parent ##=bbk}

&start`function`hideidle [u(cobj,start)]=@function/privileged hideidle=[u(cobj,bbk)]/hideidle
&HIDEIDLE [u(cobj,bbk)]=switch(objeval(%#,idle(%0)),-1,ansi(hx,Off),ansi(if(ishidden(%0),hx,u(ryg,round(mul(fdiv(bound(idle(%0),0,3600),3600),100),0))),singletime(idle(%0))))
&ryg [u(cobj,bbk)]=<[if(gt(%0,50),255,round(mul(255,fdiv(mul(%0,2),100)),0))] [if(gte(%0,50),sub(mul(255,2),round(mul(255,fdiv(mul(%0,2),100)),0)),255)] 0>



@nameformat [u(cobj,room)]=[center([ansi([gameconfig(%#,line_text)],[name(me)])][if(controls(%#,[num(me)]),%[[num(me)][flags([num(me)])]%])],[gameconfig(%#,width)])]%R[if(and([isinstalled(LOCATIONS)],isdbref(area(num(me)))),[u(get_zones,[num(me)],%#)])][line(,%#)]

&get_zones [u(cobj,room)]=[printf($^80s,[iter([area(%0,list)],%[[mname(##)]%],%B,%B[ansi([u(gconfig,%1,line_text)],+)]%B)])]%R

&fil`cansee [u(cobj,room)]=[cansee(%q<lkr>,%0)]

&get_bitname [u(cobj,bbk)]=[switch(bittype(%0),7,god,6,immortal,5,royalty,4,councilor,3,architect,2,guildmaster,citizen)]

&lvthings [u(cobj,bbk)]=[setq(perm,[u(get_bitname,%1)])][setq(item,[keeptype(lcon(%0,vis),thing)])][streval(%q<item>,%q<perm>)]
&start`function`lvthings [u(cobj,start)]=@function/privileged lvthings=[u(cobj,bbk)]/lvthings
&lvexits [u(cobj,bbk)]=[setq(perm,[u(get_bitname,%1)])][setq(item,[objeval(%#,lexits(%0))])][streval(%q<item>,%q<perm>)]
&start`function`lvexits [u(cobj,start)]=@function/privileged lvexits=[u(cobj,bbk)]/lvexits
&lvplayers [u(cobj,bbk)]=[setq(perm,[u(get_bitname,%1)])][setq(item,[keeptype(setinter(lcon(%0,vis),lcon(%0,connect)),player)])][streval(%q<item>,%q<perm>)]
&start`function`lvplayers [u(cobj,start)]=@function/privileged lvplayers=[u(cobj,bbk)]/lvplayers

@conformat [u(cobj,room)]=[setq(lkr,%#)][setq(players,[lvplayers(%L,%#)])][setq(things,[lvthings(%l,%#)])][u(conformat`[gameconfig(%#,CONFORMAT)],%q<players>,%q<things>)]


&sortname [u(cobj,bbk)]=[sortby(sortname`sort,%0,[u(strfirstof,%B,%1)])]
&sortname`sort [u(cobj,bbk)]=[comp([name(%0)],[name(%1)])]
&start`function`sortname [u(cobj,start)]=@function/privileged sortname=[u(cobj,bbk)]/sortname

&exitformat`lines [u(cobj,room)]=[if(gte(words(%q<paths>),1),[printf($-10s $-[sub([gameconfig(%#,width)],11)]s,[ansi([gameconfig(%#,column_names)],Paths)]:,[u(exitformat`lines`fmt,[sortname(%q<paths>)])])])][if(gte(words(%q<build>),1),[if(gte(words(%q<paths>),1),%R)][printf($-10s $-[sub([gameconfig(%#,width)],11)]s,[ansi([gameconfig(%#,column_names)],Buildings)]:,[u(exitformat`lines`fmt,[sortname(%q<build>)])])])][if(gte(words(%q<paths> %q<build>),1),%R)][line(,%#)]

&exitformat`lines`fmt [u(cobj,room)]=[itemize(iter(%0,[u(get_exit`name,##,%q<lkr>)]%B[ansi([gameconfig(%#,line_color)],[chr(91)])][u(get_exit`alias,##,%q<lkr>)][ansi([gameconfig(%#,line_color)],[chr(93)])],%B,|),|,and)]

&conformat`lines [u(cobj,room)]=[line(,%#)][if(gte(words(%q<players>),1),%R[printf($-10s $-[sub([gameconfig(%#,width)],11)]s,[ansi([gameconfig(%#,column_names)],Players)]:,[u(conformat`lines`players,[sortname(%q<players>)])])])][if(gte(words(%q<things>),1),%R[printf($-10s $-[sub([gameconfig(%#,width)],11)]s,[ansi([gameconfig(%#,column_names)],Objects)]:,[u(conformat`lines`objects,[sortname(%q<things>)])])])]
&conformat`lines`players [u(cobj,room)]=[itemize([iter(%0,[switch(1,[isadmin(##)],[ansi([gameconfig(%#,line_accent)],*)],[isguest(##)],[ansi(+green,+)])][mname(##)][chr(40)][hideidle(##)][chr(41)],%B,|)],|,and)]

&conformat`lines`objects [u(cobj,room)]=[itemize([iter(%0,[if(hasflag(##,PUPPET),[ansi([gameconfig(%#,line_accent)],!)])][mname(##)][if(or(controls(%#,##),isadmin(%#)),[chr(91)]##[chr(93)])],%B,|)],|,and)]

&conformat`default [u(cobj,room)]=[line(,%#)][ifelse(gte(words(%q<players>),1),%R[ansi([gameconfig(%#,line_color)],[chr(91)])][ansi([gameconfig(%#,column_names)],Players)][ansi([gameconfig(%#,line_color)],[chr(93)])]%R[iter([sortname(%q<players>)],[u(conformat`player,##,%#)],%B,%R)])][ifelse(gte(words(%q<things>),1),%R[ansi([gameconfig(%#,line_color)],[chr(91)])][ansi([gameconfig(%#,column_names)],Objects)][ansi([gameconfig(%#,line_color)],[chr(93)])][step(conformat`default`step,[sortname(%q<things>)],2,,)])]

&conformat`default`step [u(cobj,room)]=%R[printf($-39s,[u(conformat`default`thing,%0,%q<lkr>)])]%B%B[printf($-39s,[u(conformat`default`thing,%1,%q<lkr>)])]
&conformat`default`thing [u(cobj,room)]=[if(gte(words(%0),1),[printf($1s $-30s $6s,[if(hasflag(%0,Puppet),[ansi([gameconfig(%#,LINE_ACCENT)],P)])],[mname(%0)],[if(or(controls(%#,%0),isadmin(%#)),%0)])])]

&conformat`player [u(cobj,room)]=[printf($1s $-30s $-[sub([gameconfig(%#,width)],30,1,1,1,1,5)]s $5s,[switch(1,[isadmin(%0)],[ansi([gameconfig(%#,line_accent)],*)],[isguest(%0)],[ansi(+green,G)])],[mname(%0)],%B,[hideidle(%0)])]

@exitformat [u(cobj,room)]=[setq(lkr,%#)][setq(exits,[lvexits(%L,%#)])][setq(paths,[iter(%q<exits>,if(hasflag(##,build),,##))])][setq(build,[iter(%q<exits>,if(hasflag(##,build),##))])][u(exitformat`[gameconfig(%#,ExitFORMAT)],%q<paths>,%q<build>)]

&exitformat`default [u(cobj,room)]=[if(gte(words(%q<exits>),1),[printf($-40s$-40s,[ansi([gameconfig(%#,line_color)],[chr(91)])][ansi([gameconfig(%#,column_names)],Paths)][ansi([gameconfig(%#,line_color)],[chr(93)])],[ansi([gameconfig(%#,line_color)],[chr(91)])][ansi([gameconfig(%#,column_names)],Buildings)][ansi([gameconfig(%#,line_color)],[chr(93)])])][setq(row,[max(words(%q<paths>),words(%q<build>))])][if(gte(%q<row>,1),%R[iter([lnum(1,%q<row>)],[printf($-40s$-40s,[u(exitformat`default`fmt,%q<lkr>,##,%q<paths>)],[u(exitformat`default`fmt,%q<lkr>,##,%q<build>)])],%B,%R)])]%R)][line(,%#)]

&exitformat`default`fmt [u(cobj,room)]=[setq(ex,extract(%2,%1,1))][if(gte(words(%q<ex>),1),[printf($1s $-5s $-32s,,[ansi([gameconfig(%#,line_color)],[chr(91)])][u(get_exit`alias,%q<ex>,%q<lkr>)][ansi([gameconfig(%#,line_color)],[chr(93)])],[u(get_exit`name,%q<ex>,%q<lkr>)])])]

&get_exit`alias [u(cobj,room)]=[setq(alias,[ucstr([extract(fullname(%0),2,1,;)])])][if(hasflag(%0,dark),[ansi([gameconfig(%#,DARK_EXITS)],%q<alias>)],[ansi([gameconfig(%#,line_text)],%q<alias>)])]
&get_exit`name [u(cobj,room)]=[if(hasflag(%0,dark),[ansi([gameconfig(%#,DARK_EXITS)],name(%0))],name(%0))]

&ODROP [u(cobj,exit)]=heads over from [fullname(home(me))].
&OSUCCESS [u(cobj,exit)]=heads over to [fullname(loc(me))].
&SUCCESS [u(cobj,exit)]=You head over to [fullname(loc(me))].
