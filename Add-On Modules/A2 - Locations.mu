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


th [u(newconfcat,Locations)]
@@ [u(newconfig,CONFIG NAME,SYSTEM MONIKER,CONFIG CATEGORY,DEFAULT,VALIDATOR,DESCRIP,PLAYER)]
th [u(newconfig,STATUS_COLOR_SCLOAK,LOCATIONS,Locations,+firebrick2,COLOR,The color for a member of staff that is using Super Cloak.)]
th [u(newconfig,STATUS_COLOR_CLOAK,LOCATIONS,Locations,+debianred,COLOR,The color for a member of staff that is using Cloak.)]
th [u(newconfig,STATUS_COLOR_DARK,LOCATIONS,Locations,+darkslategrey,COLOR,The color for a member of staff that is using Dark.)]
th [u(newconfig,STATUS_COLOR_HIDE,LOCATIONS,Locations,+darkorchid,COLOR,The color for a member of staff that is using @hide.)]

&cmd`who [u(cobj,locations)]=$^(?s)(?\:\+)?(who)$:@attach %!/run`get_player_list=%#;th [setq(clr,[u(gconfig,%#,COLUMN_NAMES)])];@pemit %#=[line([u(gconfig,%#,Game_name)] -- +who,%#,header)]%R[printf($-3:.:s $-28:.:s $-5:.:s $1s $-23:.:s $-7:.:s $-7:.:s,[ansi(%q<clr>,Sts)],[ansi(%q<clr>,Name)],[ansi(%q<clr>,Alias)],[ansi(%q<clr>,S)],[ansi(%q<clr>,Area)],[ansi(%q<clr>,Idle)],[ansi(%q<clr>,Conn)])];@dolist %q<who>={@pemit %#=[printf($-3s $-28s $-5s $1s $-23s $-7s $-7s,[u(get_status,##)],[cname(##)],[default(##/alias,--)],[firstof([mid([get(##/sex)],0,1)],N)],[u(get_area,##)],hideidle(##),singletime(conn(##)))]};@wait 0={@pemit %#=[line(,%#)]}

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

&start`function`area [u(cobj,start)]=@function/privileged area=[u(cobj,locations)]/area
&area [u(cobj,locations)]=[setq(zones,[lzone(%0)])][setq(areas,[filter(filter`is_area,%q<zones>)])][setq(area,first(%q<areas>))]%q<area>

&filter`is_area [u(cobj,locations)]=[gtm([parents(%0)],[before([u(cobj,apar)],:)])]
