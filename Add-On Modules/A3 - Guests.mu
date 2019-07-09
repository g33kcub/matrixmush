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
