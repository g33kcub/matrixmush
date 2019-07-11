@create Guest Commands <GUESTS>
@set GUESTS=NO_MODIFY INDESTRUCTIBLE SAFE SIDEFX COMMANDS INHERIT
@parent Guests=[u(cobj,BBK)]
@fo me=&cobj`GUESTS [u(cobj,BBK)]=[objid(GUESTS)]
@tel [u(cobj,GUESTS)]=#[config(master_room)]
&system`name [u(cobj,GUESTS)]=GUEST

&system`desc [u(cobj,Guests)]=This is the system for managing Guest Characters.
th [u(newconfcat,Guests)]
@@ [u(newconfig,CONFIG NAME,SYSTEM MONIKER,CONFIG CATEGORY,DEFAULT,VALIDATOR,DESCRIP,PLAYER)]
th [u(newconfig,GUEST_HOME,GUESTS,GUESTS,,DBREF,This is the default location that all guest characters are linked to as home.)]
th [u(newconfig,GUEST_CHANNEL,GUESTS,GUESTS,,LIST,This is the list of channels that a guest will be added to when connected.)]
th [u(newconfig,MYNAME,GUESTS,GUESTS,1,BOOL,Can the guest use the +myname command to set their name.)]

&switches`player [u(Cobj,guests)]=BOOT
&switches`admin [u(cobj,guests)]=INIT

&CMD`+GUESTS [u(cobj,guests)]=$^(?s)\+(guests)(?\:/(\\S+)?)?(?\: +(.+?))?(?\:=(.*))?$:@attach %!/CMD`+GUESTS`MAIN
@set [u(cobj,guests)]/CMD`+GUESTS=regexp
&CMD`+GUESTS`MAIN [u(cobj,guests)]=@attach %!/run`SWITCHes=%2;@attach %!/GUEST`[u(strfirstof,%q<switch>,MAIN)]=%3,%4
