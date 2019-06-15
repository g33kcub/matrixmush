@@ +system Command
&cmd`system [u(cobj,core)]=$+system:@pemit %#=[line(System Information,%#,header)]%R[align(<15 5 20 [strfunc(sub,80 16 6 21)],[ansi([setr(cn,[u(get_config,%#,column_names)])],System)],[ansi(%q<cn>,Vers)],[ansi(%q<cn>,Install Date)],[ansi(%q<cn>,System Description)],.)];@dolist/inline/delimit | {[u(get_config,%#,SYSTEMS)]}={@Pemit %#=[u(cmd`system`fmt,##)]};@pemit %#=[line(,%#)]

&cmd`system`fmt [u(cobj,core)]=[align(<15 5 20 [strfunc(sub,80 16 6 21)],%0,[u(install`%0`ver)],[timefmt($M/$D/$Y $H:$02F$p,[u(install`%0`date)])],[get([u(install`%0)]/system`desc)])]

&CMD`install [u(cobj,core)]=$^\+install(?\:/(\\S+)?)?(?\: +(.+?))?(?\:=(.*?))?$:@attach %!/CMD`install`MAIN
@set [u(cobj,core)]/CMD`install=regexp
@set [u(Cobj,core)]/cmd`install=no_inherit
&cmd`install`main [u(cobj,core)]=@check [isops(%#)];th [setq(subsys,INSTALL)];@attach %!/run`switches=%1;@attach %!/run`install`[u(strfirstof,%q<switch>,main)]=%2,%3

&switches`install`operations [u(Cobj,core)]=UPDATE|REMOVE

&run`install`main [u(Cobj,core)]=@check [gte(words(%0),1)]={@attach %!/msg`error={You must supply something to install.}};@check [not([gtm([setr(ins,[u(gconfig,%#,SYSTEMS)])],[ucstr(%0)],|)])]={@attach %!/msg`error={The "[ansi([u(gconfig,%#,Line_text)],[ucstr(%0)])]" module is already installed.}};@check [isdbref([u(cobj,%0)])]={@attach %!/msg`error={The code object for the module "[ansi([u(gconfig,%#,Line_text)],[ucstr(%0)])]" is not found.}};&config`systems`custom [u(cobj,Gcs)]=[insert(%q<ins>,[inc(words(%q<ins>,|))],[ucstr(%0)],|,|)];&install`%0 [u(cobj,bbk)]=[u(cobj,%0)];&install`%0`date [u(cobj,bbk)]=[secs()];@attach [u(Cobj,%0)]/script`install;&install`%0`ver [u(cobj,bbk)]=%1;@attach %!/msg={You have installed the "[ansi([u(gconfig,%#,Line_text)],[ucstr(%0)])]" version "[ansi([u(gconfig,%#,Line_text)],%1)]" module.};@attach %!/msg`chan={Module "[ansi([u(gconfig,%#,Line_text)],[ucstr(%0)])]" version "[ansi([u(gconfig,%#,Line_text)],%1)]" has been installed.}

&run`install`update [u(cobj,core)]=@check [gte(words(%0),1)]={@attach %!/msg`error={You must supply something to update.}};@check [gtm([setr(ins,[u(gconfig,%#,SYSTEMS)])],[ucstr(%0)],|)]={@attach %!/msg`error={Module "[ansi([u(gconfig,%#,Line_text)],[ucstr(%0)])]" is not installed.}};&install`%0`date [u(cobj,bbk)]=[secs()];&install`%0`ver [u(cobj,bbk)]=%1;@attach %!/msg={You have updated the module "[ansi([u(gconfig,%#,Line_text)],[ucstr(%0)])]" to version "[ansi([u(gconfig,%#,Line_text)],%1)]" module.};@attach %!/msg`chan={Module "[ansi([u(gconfig,%#,Line_text)],[ucstr(%0)])]" to version "[ansi([u(gconfig,%#,Line_text)],%1)]" module has been updated.}

&run`install`remove [u(cobj,core)]=@check [gte(words(%0),1)]={@attach %!/msg`error={You must supply something to remove.}};@check [gtm([setr(ins,[u(gconfig,%#,SYSTEMS)])],[ucstr(%0)],|)]={@attach %!/msg`error={Module "[ansi([u(gconfig,%#,Line_text)],[ucstr(%0)])]" is not installed.}};&config`systems`current [u(cobj,gcs)]=[remove(%q<ins>,[ucstr(%0)],|)];&install`%0 [u(cobj,bbk)];&install`%0`ver [u(cobj,bbk)];&install`%0`date [u(cobj,bbk)];@attach %!/msg={You have uninstalled the "[ansi([u(gconfig,%#,Line_text)],[ucstr(%0)])]" module.};@attach %!/msg`chan={Module "[ansi([u(gconfig,%#,Line_text)],[ucstr(%0)])]" has been uninstalled.};@attach [u(cobj,%q<ins>)]/script`uninstall

&CMD`CHARSET [u(cobj,core)]=$+charset:@pemit %#=wrap(iter(lnum(32,256),if(comp(first(chr(%i0)),#-1),ljust([ljust(%i0:,4)] [ansi(hy,chr(%i0))],7)),%B,),78)
