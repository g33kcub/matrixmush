@create Information Systems <HELP>
@set [u(cobj,help)]=NO_MODIFY INDESTRUCTIBLE SAFE SIDEFX COMMANDS INHERIT
@parent [u(cobj,help)]=BBK
@fo me=&cobj`help bbk=[objid(help)]
@create Help Database <HDB>
@create News Database <NDB>
@create Staff Help Database <SDB>
@create Book Database <BDB>
@create Rules Database <RDB>
@dolist hdb ndb sdb bdb rdb={@set ##=NO_MODIFY INDESTRUCTIBLE SAFE SIDEFX INHERIT}
@dolist hdb ndb sdb bdb rdb={&cobj`## [u(cobj,bbk)]=[objid(##)]}
@dolist hdb ndb sdb bdb rdb={@parent ##=[u(cobj,help)]}
@dolist hdb ndb sdb bdb rdb={@tel ##=[u(cobj,help)]}
&system`name [u(cobj,hdb)]=+help
&system`name [u(Cobj,ndb)]=+news
&system`name [u(cobj,sdb)]=+shelp
&system`name [u(cobj,bdb)]=+book
&system`name [u(cobj,rdb)]=+rules

&system`next [u(cobj,hdb)]=0
&system`next [u(Cobj,ndb)]=0
&system`next [u(cobj,sdb)]=0
&system`next [u(cobj,bdb)]=0
&system`next [u(cobj,rdb)]=0

th [u(newconfig,BACKUP_STORAGE,CORE,SYSTEM,,DBREF,The location where Information System Backups are stored when created.)]
th [u(newconfig,USE_HELP,CORE,SYSTEM,1,BOOL,Enable the Use of the +help system.)]
th [u(newconfig,USE_NEWS,CORE,SYSTEM,1,BOOL,Enable the Use of the news system.)]
th [u(newconfig,USE_SHELP,CORE,SYSTEM,1,BOOL,Enable the Use of the +shelp system.)]
th [u(newconfig,USE_BOOK,CORE,SYSTEM,1,BOOL,Enable the Use of the +book system.)]
th [u(newconfig,USE_RULES,CORE,SYSTEM,1,BOOL,Enable the Use of the +rules system.)]



@@ %0 = +help/blah1 blah2=blah3/blah4/blah5/blah6
@@ %1 = help
@@ %2 = blah1
@@ %3 = blah2
@@ %4 =
@@ %5 =
@@ %6 = blah3
@@ %7 = blah4
@@ %8 = blah5
@@ %9 = blah6

&CMD`+HELP [u(cobj,help)]=$^(?s)(?\:\+)?(book|rules|help|shelp|news)(?\:/(\\S+)?)?(?\: +(.+?))?(?\:/(.+?))?(?\:/(.+?))?(?\:=(.+?))?$:@attach %!/CMD`+HELP`MAIN
@set [u(cobj,help)]/CMD`+HELP=regexp
&system`name [u(Cobj,help)]=u(strfirstof,[mid([get(%q<db>/system`name)],1,99)],HELP)

&run`isactive [u(cobj,help)]=@check [setq(sys,[ucstr(%0)])][u(gconfig,%#,USE_%0)]={@attach %!/msg`error={'+%0' is not active on this game.}}

&init`help [u(Cobj,help)]=th [setq(sys,HELP)][setq(db,[u(Cobj,HDB)])]
&init`shelp [u(Cobj,help)]=th [setq(sys,SHELP)][setq(db,[u(Cobj,SDB)])];@check [isadmin(%#)]={@attach %!/msg`error={Permission Denied.}}
&init`news [u(Cobj,help)]=th [setq(sys,NEWS)][setq(db,[u(Cobj,NDB)])]
&init`book [u(Cobj,help)]=th [setq(sys,BOOK)][setq(db,[u(Cobj,BDB)])];@check [isadmin(%#)]={@attach %!/msg`error={Permission Denied.}}
&init`rules [u(Cobj,help)]=th [setq(sys,RULES)][setq(db,[u(Cobj,RDB)])]


&SWITCHES`PLAYER [u(cobj,help)]=
&SWITCHES`ADMIN [u(cobj,help)]=HELP|ADD|ADDSUB|STATS|CATEGORY|RENAMECATEGORY|DELETECATEGORY|RENAME|RENAMESUB|DELETE|DELETESUB
&switches`OPERATIONS [u(Cobj,help)]=BACKUP|PURGE



&run`switch`delete [u(Cobj,help)]=@attach %!/init`%4;@attach %!/run`partial=%0,[sort([u(get_topics`main,%q<db>)],a,|)],|,topic,[u(%q<db>/system`name)] File;@attach %!/run`get_topic`main=%q<topic>;@attach %!/run`remove_file=%q<tid>;@attach %!/msg={File "[ansi([u(gconfig,%#,line_text)],%0)]" and all subfiles deleted.};@attach %!/msg`chan={File "[ansi([u(gconfig,%#,line_text)],%0)]" and all subfiles deleted.}

&run`switch`deletesub [u(Cobj,help)]=@attach %!/init`%4;@attach %!/run`partial=%0,[sort([u(get_topics`main,%q<db>)],a,|)],|,topic,[u(%q<db>/system`name)] File;@attach %!/run`get_topic`main=%q<topic>;@attach %!/run`partial=%1,[sort([u(get_topics`sub,%q<db>,%q<tid>)],a,|)],|,subtopic,[u(%q<db>/system`name)] %q<topic> File;@attach %!/run`get_topic`sub=%q<topic>,%q<subtopic>;@attach %!/run`remove_file=%q<sid>;@attach %!/msg={File "[ansi([u(gconfig,%#,line_text)],%0)]/[ansi([u(gconfig,%#,line_text)],%1)]" deleted.};@attach %!/msg`chan={File "[ansi([u(gconfig,%#,line_text)],%0)]/[ansi([u(gconfig,%#,line_text)],%1)]" deleted.}

&run`switch`renamesub [u(Cobj,help)]=@attach %!/init`%4;@attach %!/run`partial=%0,[sort([u(get_topics`main,%q<db>)],a,|)],|,topic,[u(%q<db>/system`name)] File;@attach %!/run`get_topic`main=%q<topic>;@attach %!/run`partial=%1,[sort([u(get_topics`sub,%q<db>,%q<tid>)],a,|)],|,subtopic,[u(%q<db>/system`name)] %q<topic> File;@attach %!/run`get_topic`sub=%q<topic>,%q<subtopic>;@check [not([gtm([u(get_topics`sub,%q<db>,%q<tid>)],%3,|)])]={@attach %!/msg`error={Sub-File named "[ansi([u(gconfig,%#,line_text)],%0)]/[ansi([u(gconfig,%#,line_text)],%3)]" already exists.}};&file`%q<sid> %q<db>=[caps(%3)];&file`%q<sid>`update %q<db>=[secs()];&file`%q<sid>`updated_by %q<db>=%:;@attach %!/msg={Sub-File "[ansi([u(gconfig,%#,line_text)],%0)]/[ansi([u(gconfig,%#,line_text)],%1)]" renamed to "[ansi([u(gconfig,%#,line_text)],%3)]".};@attach %!/msg`chan={File "[ansi([u(gconfig,%#,line_text)],%0)]/[ansi([u(gconfig,%#,line_text)],%1)]" renamed to "[ansi([u(gconfig,%#,line_text)],%3)]".}

&run`switch`rename [u(Cobj,help)]=@attach %!/init`%4;@attach %!/run`partial=%0,[sort([u(get_topics`main,%q<db>)],a,|)],|,topic,[u(%q<db>/system`name)] File;@attach %!/run`get_topic`main=%q<topic>;@check [not([gtm([u(get_topics`main,%q<db>)],%3,|)])]={@attach %!/msg`error={File named "[ansi([u(gconfig,%#,line_text)],%3)]" already exists.}};&file`%q<tid> %q<db>=[caps(%3)];&file`%q<tid>`update %q<db>=[secs()];&file`%q<tid>`updated_by %q<db>=%:;@attach %!/msg={File "[ansi([u(gconfig,%#,line_text)],%0)]" renamed to "[ansi([u(gconfig,%#,line_text)],%3)]".};@attach %!/msg`chan={File "[ansi([u(gconfig,%#,line_text)],%0)]" renamed to "[ansi([u(gconfig,%#,line_text)],%3)]".}

&run`switch`deletecategory [u(cobj,help)]=@attach %!/init`%4;@attach %!/run`partial=%0,[u(get_categories,%q<db>)],|,cat,Category;@dolist/delimit | {[filter(fil`in_category,[get(%q<db>/files)],|)]}={@attach %!/run`remove_file=##};@attach %!/msg={Category "[ansi([u(gconfig,%#,line_text)],%0)]" deleted. All associated files removed too.};@attach %!/msg`chan={Category "[ansi([u(gconfig,%#,line_text)],%0)]" deleted. All associated files removed too.}

&run`remove_file [u(cobj,help)]=@switch [hasattr(%q<db>,ROOT`%0)][hasattr(%q<db>,[setr(FID,FILE`%0)]`root)][gtm([get(%q<db>/main)],%0,|)]=001,{@dolist UPDATE CATEGORY UPDATED_BY BODY={&%q<fid>`## %q<db>};&%q<fid> %q<db>;&Files %q<db>=[setdiff([get(%q<db>/files)],%0,|)];&main %q<db>=[setdiff([get(%q<db>/main)],%0,|)]},101,{@dolist UPDATE CATEGORY UPDATED_BY BODY={&%q<fid>`## %q<db>};&%q<fid> %q<db>;&Files %q<db>=[setdiff([get(%q<db>/files)],%0,|)];&main %q<db>=[setdiff([get(%q<db>/main)],%0,|)];@dolist/delimit | {[get(%q<db>/root`%0)]}={@attach %!/run`remove_file=##};&root`%0 %q<db>},010,{@dolist UPDATE CATEGORY UPDATED_BY BODY={&%q<fid>`## %q<db>};&%q<fid> %q<db>;&Files %q<db>=[setdiff([get(%q<db>/files)],%0,|)];&root`[get(%q<db>/%q<fid>`root)] %q<db>=[setdiff([get(%q<db>/root`[get(%q<db>/%q<fid>`root)])],%0,|)];&%q<fid>`root %q<db>}


&[setr(fid,FILE`%0)] %q<db>;&%q<fid>`category %q<DB>;&%q<fid>`update %q<DB>;&%q<fid>`updated_by %q<DB>;&root`[get(%q<db>/%q<fid>`root)] %q<db>=[setdiff([get(%q<db>/root`[get(%q<db>/%q<fid>`root)])],%0,|)])];&%q<fid>`root %q<DB>;&%q<fid>`body %q<db>;&files %q<db>=[setdiff([get(%q<db>/files)],%0,|)];&main %q<db>=[setdiff([get(%q<db>/main)],%0,|)];@dolist [get(%q<db>/root`%0)]={@attach %!/run`remove_file=##};@check [hasattr(%q<db>,%q<FID>`root)];&root`[get(%q<db>/%q<fid>`root)] %q<db>=[setdiff([get(%q<db>/root`[get(%q<db>/%q<fid>`root)])],%0,|)])];&root`%0 %q<db>

&run`switch`renamecategory [u(cobj,help)]=@attach %!/init`%4;@attach %!/run`partial=%0,[u(get_categories,%q<db>)],|,cat,Category;@switch [t(strlen(%3))][gtm(%q<cats>,%3,|)]=0?,{@attach %!/msg`error={You must supply a category name to set.}},11,{@attach %!/msg`error={'%3' already exists, please use [ansi([U(gconfig,%#,line_text)],+help/category <file>=%3)] to set it.}},10,{@dolist/delimit | {[filter(fil`in_category,[get(%q<db>/files)],|)]}={&file`##`category %q<db>=[ucstr(%3)];&file`##`update %q<db>=[secs()];&file`##`updated_by %q<db>=%:};@attach %!/msg={Category "[ansi([u(gconfig,%#,line_text)],%0)]" renamed to "[ansi([u(gconfig,%#,line_text)],%3)]".};@attach %!/msg`chan={Category "[ansi([u(gconfig,%#,line_text)],%0)]" renamed to "[ansi([u(gconfig,%#,line_text)],%3)]".}}

&fil`in_category [u(cobj,help)]=[gtm([get(%q<db>/file`%0`category)],%q<cat>,|)]

&run`switch`category [u(Cobj,help)]=@attach %!/init`%4;@attach %!/run`partial=%0,[sort([u(get_topics`main,%q<db>)],a,|)],|,topic,[u(%q<db>/system`name)] File;@attach %!/run`get_topic`main=%q<topic>;@check [t(strlen(%3))]={@attach %!/msg`error={You can't change a category without providing one.}};@dolist %q<tid> [get(%q<db>/root`%q<tid>)]={&file`##`category %q<db>=[ucstr(%3)];&file`##`update %q<db>=[secs()];&file`##`updated_by %q<db>=%:};@attach %!/msg={File "[ansi([u(gconfig,%#,line_text)],%0)]" category updated to "[ansi([u(gconfig,%#,line_text)],%3)]".};@attach %!/msg`chan={File "[ansi([u(gconfig,%#,line_text)],%0)]" category updated to "[ansi([u(gconfig,%#,line_text)],%3)]".}

@@ %0 = File
@@ %1 = Subfile
@@ %2 =
@@ %3 = Body
@@ %4 = help

&run`switch`addsub [u(Cobj,help)]=@attach %!/init`%4;@attach %!/run`get_topic`main=%0;@switch [t(strlen(%0))][t(strlen(%1))][t(strlen(%3))]=0??,{@attach %!/msg`error={You must supply a parent file for your file.}},10?,{@attach %!/msg`error={You must name your file.}},110,{@attach %!/msg`error={You can't set a file with no information.}},111,{@attach %!/run`switch`addsub`[gtm([u(get_topics`sub,%q<db>,%q<tid>)],%1,|)]=trim(%0),trim(%1),trim(%3),trim(%4),%q<sys>,%q<tid>}

&run`switch`addsub`0 [u(cobj,help)]=@attach %!/run`partial=%0,[u(get_topics`main,%q<db>)],|,file,Root File;@attach %!/run`get_next_num=%q<db>;&[setr(fa,file`%q<new>)] %q<db>=[caps(%1)];&%q<fa>`category %q<db>=[get(%q<db>/file`%5`category)];&%q<fa>`update %q<db>=[secs()];&%q<fa>`updated_by %q<db>=%:;&%Q<fa>`root %q<db>=%5;&root`%q<tid> %q<db>=[setunion([get(%q<db>/root`%5)],%q<new>,|)];&files %q<db>=[setunion([get(%q<db>/files)],%q<new>,|)];@switch [strmatch(%2,#*/*)]=0,{&file`%q<new>`body %q<db>=%2;@attach %!/msg={Sub-File "[ansi([u(gconfig,%#,line_text)],%1)]" added to root file "[ansi([u(gconfig,%#,line_text)],%0)]".};@attach %!/msg`chan={Sub-File "[ansi([u(gconfig,%#,line_text)],%1)]" added to root file "[ansi([u(gconfig,%#,line_text)],%0)]".}},1,{@switch [cand([t(strlen([u(%2)]))],[hasattr(%2)])]=0,{@attach %!/msg`error={The system process that DBREF/ATTRIBUTE combination.}},1,{&file`%q<new>`body %q<db>=%2;@attach %!/msg={Sub-File "[ansi([u(gconfig,%#,line_text)],%1)]" added to root file "[ansi([u(gconfig,%#,line_text)],%0)]".};@attach %!/msg`chan={Sub-File "[ansi([u(gconfig,%#,line_text)],%1)]" added to root file "[ansi([u(gconfig,%#,line_text)],%0)]".}}

&run`switch`addsub`1 [u(cobj,help)]=@attach %!/init`%4;@attach %!/run`get_topic`main=%0;@attach %!/run`get_topic`sub=%q<tid>,%1;@switch [strmatch(%2,#*/*)]=0,{&file`%q<sid>`update %q<db>=[secs()];&file`%q<sid>`updated_by %q<db>=%:;&file`%q<sid>`body %q<db>=%2;@attach %!/msg={Sub-File "[ansi([u(gconfig,%#,line_text)],%1)]" updated.};@attach %!/msg`chan={Sub-File "[ansi([u(gconfig,%#,line_text)],%1)]" updated.}},1,{@switch [cand([t(strlen([u(%2)]))],[hasattr(%2)])]=0,{@attach %!/msg`error={The system process that DBREF/ATTRIBUTE combination.}},1,{&file`%q<sid>`update %q<db>=[secs()];&file`%q<sid>`updated_by %q<db>=%:;&file`%q<sid>`body %q<db>=%2;@attach %!/msg={Sub-File "[ansi([u(gconfig,%#,line_text)],%1)]" updated.};@attach %!/msg`chan={Sub-File "[ansi([u(gconfig,%#,line_text)],%1)]" updated.}}

&run`switch`help [u(cobj,help)]=@attach %!/init`%3;th [setq(comm,[get(%q<db>/system`name)])];@pemit %#=[line([u(gconfig,%#,Game_Name)] - [u(%q<db>/system`name)] System Help,%#,Header)]%R[align(5 [sub(u(gconfig,%#,width),6)],,[ansi([u(gconfig,%#,line_text)],%q<comm>/add <category>/<filename>=<text>)] - Creates or update a helpfile AND the respective category if it does not exist. If <text> is #DBREF/ATTRIBUTE format\, the given attribute will be u%(%)'d for retrieval.%R[ansi([u(gconfig,%#,line_text)],%q<comm>/addsub <filename>/<subfilename>=<text>)] - Create or update a sub-helpfile. Works like /add.%R[ansi([u(gconfig,%#,line_text)],%q<comm>/category <filename>=<category>)] - Re-Assign a helpfile to a different category.%R[ansi([u(gconfig,%#,line_text)],%q<comm>/rename <filename>=<newname>)] - Rename a file.%R[ansi([u(gconfig,%#,line_text)],%q<comm>/renamesub <filename>/<subfilename>=<newname>)] - Rename a subfile.%R[ansi([u(gconfig,%#,line_text)],%q<comm>/renamecategory <category>=<new name>)] - Re-assign all helpfiles of a given category to a new or existing one.%R[ansi([u(gconfig,%#,line_text)],%q<comm>/deletecategory <category>)] - Delete a category and all associated files.%R[ansi([u(gconfig,%#,line_text)],%q<comm>/delete <filename>)] - Delete a helpfile and all subfiles.%R[ansi([u(gconfig,%#,line_text)],%q<comm>/deletesub <filename>/<subfilename>)] - Delete a sub-helpfile.)]%R%R[ansi(u(gconfig,%#,line_accent),Operations Staff Only)]%R[align(5 [sub(u(gconfig,%#,width),6)],,[ansi([u(gconfig,%#,line_text)],%q<comm>/backup)] - Backs up all %q<comm> files.)]%R[align(5 [sub(u(gconfig,%#,width),6)],,[ansi([u(gconfig,%#,line_text)],%q<comm>/purge)] - Deletes all the backups stored for the %q<comm> system.)]%R[line(,%#)]

&run`switch`backup [u(Cobj,help)]=@attach %!/init`%4;th [setq(bkp,[clone(%q<db>,BACKUP : [get(%q<db>/system`name)] : [secs()])])];&%vt`backups`%4 [u(Cobj,help)]=[setunion([get([u(cobj,help)]/%vt`backups`%4)],[objid(%q<bkp>)])];@tel %q<bkp>=[u(gconfig,%#,BACKUP_STORAGE)];@attach %!/msg={Backup for "[ansi(u(gconfig,%#,line_text),[get(%q<db>/system`name)])]" created.};@attach %!/msg`chan={Backup for "[ansi(u(gconfig,%#,line_text),[get(%q<db>/system`name)])]" created.}

&run`switch`purge [u(Cobj,help)]=@check [hasattr([u(cobj,help)],%VT`backups`%4)]={@attach %!/msg`error={There are no "[ansi([u(gconfig,%#,line_text)],%4)]" backups.}};@dolist [get([u(Cobj,help)]/%vt`backups`%4)]={@destroy ##};&%vt`backups`%4 [u(cobj,help)];@attach %!/msg={You have purged all the "[ansi([u(gconfig,%#,line_text)],%4)]" backups.};@attach %!/msg`chan={You have purged all the "[ansi([u(gconfig,%#,line_text)],%4)]" backups.}

&cmd`+help`main [u(cobj,help)]=@attach %!/run`isactive=%1;@attach %!/init`%1;@attach %!/run`switches=%2;@attach %!/run`switch`[u(strfirstof,%q<switch>,MAIN)]=trim(%3),trim(%4),trim(%5),trim(%6),%1

&run`switch`stats [u(Cobj,help)]=@attach %!/init`%4;@pemit %#=[line([u(gconfig,%#,Game_Name)] - [u(%q<db>/system`name)] System Stats,%#,Header)]%R[align(25 [sub([u(gconfig,%#,width)],26)],[ansi([u(gconfig,%#,line_text)],Database Object)]:,[name(%q<db>)] %(%q<db>%))]%R[align(25 [sub([u(gconfig,%#,width)],26)],[ansi([u(gconfig,%#,line_text)],Database Size)]:,[u(get_dbsize,[objeval(%!,[size(%q<db>,3)])])])]%R[align(25 [sub([u(gconfig,%#,width)],26)],[ansi([u(gconfig,%#,line_text)],Database Backups)]:,[words([get([u(cobj,help)]/%vt`backups`%4)])])]%R[align(25 [sub([u(gconfig,%#,width)],26)],[ansi([u(gconfig,%#,line_text)],Number of Files)]:,[cnum([words([get(%q<db>/files)],|)])])]%R[align(25 [sub([u(gconfig,%#,width)],26)],[ansi([u(gconfig,%#,line_text)],Category List)]:,[u(itemize,[u(get_categories,%q<db>)],|,&)])]%R[align(25 [sub([u(gconfig,%#,width)],26)],[ansi([u(gconfig,%#,line_text)],Next File ID)]:,[u(get_next_num,[get(%q<db>/system`next)])])]%R[line(,%#)]

&get_dbsize [u(cobj,bbk)]=[switch(1,[between(1,999,%0,1)],%0 bytes,[between(1000,999999,%0)],[fdiv(%0,1000)] kb,[gte(%0,1000000)],[fdiv(%0,1000000)] mb)]

&run`switch`add [u(cobj,help)]=@attach %!/init`%4;@switch [t(strlen(%0))][t(strlen(%1))][t(strlen(%3))]=0??,{@attach %!/msg`error={You must supply a category for your file.}},10?,{@attach %!/msg`error={You must name your file.}},110,{@attach %!/msg`error={You can't set a file with no information.}},111,{@attach %!/run`switch`add`[gtm([u(get_topics`main,%q<db>)],%1,|)]=trim(%0),trim(%1),trim(%3),trim(%4),%q<sys>}

&run`switch`add`0 [u(cobj,help)]=@attach %!/init`%3;@attach %!/run`get_next_num=%q<db>;&[setr(fa,file`%q<new>)] %q<db>=[caps(%1)];&%q<fa>`category %q<db>=[ucstr(%0)];&%q<fa>`update %q<db>=[secs()];&%q<fa>`updated_by %q<db>=%:;&main %q<db>=[setunion([get(%q<db>/main)],%q<new>,|)];&files %q<db>=[setunion([get(%q<db>/files)],%q<new>,|)];@switch [strmatch(%2,#*/*)]=0,{&file`%q<new>`body %q<db>=%2;@attach %!/msg={File "[ansi([u(gconfig,%#,line_text)],%1)]" added to category "[ansi([u(gconfig,%#,line_text)],%0)]".};@attach %!/msg`chan={File "[ansi([u(gconfig,%#,line_text)],%1)]" added to category "[ansi([u(gconfig,%#,line_text)],%0)]".}},1,{@switch [cand([t(strlen([u(%2)]))],[hasattr(%2)])]=0,{@attach %!/msg`error={The system process that DBREF/ATTRIBUTE combination.}},1,{&file`%q<new>`body %q<db>=%2;@attach %!/msg={File "[ansi([u(gconfig,%#,line_text)],%1)]" added to category "[ansi([u(gconfig,%#,line_text)],%0)]".};@attach %!/msg`chan={File "[ansi([u(gconfig,%#,line_text)],%1)]" added to category "[ansi([u(gconfig,%#,line_text)],%0)]".}}

&run`switch`add`1 [u(cobj,help)]=@attach %!/init`%3;@attach %!/run`get_topic`main=%1;@switch [strmatch(%2,#*/*)]=0,{&file`%q<tid>`update %q<db>=[secs()];&file`%q<tid>`updated_by %q<db>=%:;&file`%q<tid>`body %q<db>=%2;@attach %!/msg={File "[ansi([u(gconfig,%#,line_text)],%1)]" updated.};@attach %!/msg`chan={File "[ansi([u(gconfig,%#,line_text)],%1)]" updated.}},1,{@switch [cand([t(strlen([u(%2)]))],[hasattr(%2)])]=0,{@attach %!/msg`error={The system process that DBREF/ATTRIBUTE combination.}},1,{&file`%q<tid>`update %q<db>=[secs()];&file`%q<tid>`updated_by %q<db>=%:;&file`%q<tid>`body %q<db>=%2;@attach %!/msg={File "[ansi([u(gconfig,%#,line_text)],%1)]" updated.};@attach %!/msg`chan={File "[ansi([u(gconfig,%#,line_text)],%1)]" updated.}}

&run`get_next_num [u(cobj,help)]=&system`next %q<db>=[setr(new,[u(get_next_num,[get(%q<db>/system`next)])])]

&run`switch`main [u(cobj,help)]=@select/inline t(strlen(%0))[t(strlen(%1))]=00,{@attach %!/run`index},10,{@attach %!/run`topic},11,{@attach %!/run`subtopic}

&get_categories [u(cobj,help)]=[setunion([setr(cats,[iter([lattr(%0/file`*`category)],[get(%0/##)],%B,|)])],%q<cats>,|)]
&get_files [u(cobj,help)]=[setq(f1,[get(%q<db>/main)])][setq(f2,[iter(%q<f1>,[ifelse([gtm([get(%q<db>/file`##`category)],%1,|)],##)],|,|)])][sortby(sort`filename,[setunion(%q<f2>,%q<f2>,|)])]

&sort`filename [u(cobj,help)]=[comp([u(sort`filename`clean,[get(%q<db>/file`%0)])],[u(sort`filename`clean,[get(%q<db>/file`%1)])])]

&sort`filename`clean [u(Cobj,help)]=[if(strmatch(%0,+*),ZZZZZZZ%0,%0)]

&run`index [u(Cobj,help)]=@attach %!/init`%q<sys>;@pemit %#=[line([u(gconfig,%#,Game_Name)] - [u(%q<db>/system`name)] Files,%#,Header)];@dolist/delimit/inline | {[u(get_categories,%q<db>)]}={@pemit %#=[line([caps(##)],%#,cathead)][step(run`index`step,[u(get_files,[setr(t1,%#)],##,%q<sys>)],2,|,)]};@pemit %#=[line(,%#)]%R[align(5 [sub([u(gconfig,%#,Width)],6)],,For more information on the listed topics\, please use '[ansi([u(gconfig,%#,line_text)],[u(%q<db>/system`name)] <topic>)]')][if([u(isadmin,%#)],%R[align(5 [sub([u(gconfig,%#,Width)],6)],,Admin[chr(44)] please see [ansi([u(gconfig,%#,line_text)],[u(%q<db>/system`name)]/help)] for config information.)])]%R[line(,%#)]
&run`index`step [u(cobj,help)]=%R[u(run`index`fmt,%q<t1>,%q<db>,%0)]%B%B[u(run`index`fmt,%q<t1>,%q<db>,%1)]
&run`index`fmt [u(cobj,help)]=[if([gte([words(%2)],1)],[align(26 >[sub([div([sub([u(gconfig,%#,width)],2)],2)],27)],[ansi([u(gconfig,%q<t1>,LINE_TEXT)],[get(%1/file`%2)])],[u(get_unread,%q<t1>,%2,[get(%q<db>/root`%2)])][timefmt($M/$D/$Y,[get(%q<db>/file`%2`update)])])])]

&run`get_topic`main [u(cobj,help)]=[setq(tlist,[u(get_topics`main,%q<db>)])][setq(tnlist,[get(%q<db>/main)])][setq(tnum,[match(%q<tlist>,%0,|)])][setq(tid,[extract(%q<tnlist>,%q<tnum>,1,|)])]
&run`get_topic`sub [u(cobj,help)]=[setq(slist,[u(get_topics`sub,%q<db>,%q<tid>)])][setq(snlist,[get(%q<db>/root`%q<tid>)])][setq(snum,[match(%q<slist>,%1,|)])][setq(sid,[extract(%q<snlist>,%q<snum>,1,|)])]

&get_topics`main [u(Cobj,help)]=[iter([get(%0/main)],[get(%0/file`##)],|,|)]
&get_topics`sub [u(Cobj,help)]=[iter([get(%0/root`%1)],[get(%0/file`##)],|,|)]

&run`subtopic [u(cobj,help)]=@attach %!/init`%q<sys>;@attach %!/run`partial=%0,[sort([u(get_topics`main,%q<db>)],a,|)],|,topic,[u(%q<db>/system`name)] File;@attach %!/run`get_topic`main=%q<topic>;@attach %!/run`partial=%1,[sort([u(get_topics`sub,%q<db>,%q<tid>)],a,|)],|,subtopic,[u(%q<db>/system`name)] %q<topic> File;@attach %!/run`get_topic`sub=%q<topic>,%q<subtopic>;@pemit %#=[line([u(%q<db>/system`name)] Files - %q<subtopic>,%#,Header)];@attach %!/template`subfile;@pemit %#=%R%R[ansi([u(gconfig,%#,LIne_Text)],Last Updated on)] [u(get_update`time,%q<db>,%q<sid>)] [ansi([u(gconfig,%#,LIne_Text)],by)] [cname([get(%q<db>/file`%q<sid>`updated_by)])]%R[line(%q<topic> -- [caps([get(%q<db>/file`%q<sid>`category)])],%#,right)];@attach %!/run`has_read=[getid(%#)],%q<sid>

&run`topic [u(cobj,help)]=@attach %!/run`partial=%0,[sort([u(get_topics`main,%q<db>)],a,|)],|,topic,[u(%q<db>/system`name)] File;@attach %!/run`get_topic`main=%q<topic>;@pemit %#=[line([u(%q<db>/system`name)] Files - %q<topic>,%#,Header)];@attach %!/template`file;@pemit %#=%R%R[ansi([u(gconfig,%#,LIne_Text)],Last Updated on)] [u(get_update`time,%q<db>,%q<tid>)] [ansi([u(gconfig,%#,LIne_Text)],by)] [cname([get(%q<db>/file`%q<tid>`updated_by)])]%R[line([caps([get(%q<db>/file`%q<tid>`category)])],%#,right)];@attach %!/run`has_read=[getid(%#)],%q<tid>

&run`has_read [u(cobj,help)]=[setq(rlist,[get(%0/%VT`read`%q<sys>)])][setq(entry,[grab(%q<rlist>,%1~*,|)])][setq(eid,[match(%q<rlist>,%q<entry>,|)])];@switch [gtm(%q<rlist>,%1~*,|)]=0,{&%VT`READ`%q<sys> %0=[setunion(%q<rlist>,%1~[secs()],|)]},1,{&%VT`READ`%q<sys> %0=[replace(%q<rlist>,%q<eid>,%1~[secs()],|)]}


&get_update`time [u(cobj,help)]=[timefmt($M/$D/$Y $H:$02F$p,[get(%0/file`%1`update)])]


&template`subfile [u(cobj,help)]=@pemit %#=[if([strmatch([setr(dbref,[get(%q<db>/file`%q<sid>`body)])],#*/*)],[u(%q<dbref>)],[get(%q<db>/file`%q<sid>`body)])]
&template`file [u(cobj,help)]=@pemit %#=[if([strmatch([setr(dbref,[get(%q<db>/file`%q<tid>`body)])],#*/*)],[u(%q<dbref>)],[get(%q<db>/file`%q<tid>`body)])][if([hasattr(%q<db>,ROOT`%q<tid>)],[u(template`file`sub,%q<db>,%q<tid>)])]
&template`file`sub [u(Cobj,help)]=%R[line(Sub-Topics,%#)]%R[align(5 [sub([u(gconfig,%#,Width)],6)],,To read subfiles[chr(44)] use '[ansi([u(gconfig,%#,line_text)],[u(%q<db>/system`name)] %q<topic>/<topic>)]')][step(run`index`step`sub,[setq(t1,%#)][u(get_files`sub,%q<db>,%q<tid>)],2,|,)]
&run`index`step`sub [u(cobj,help)]=%R[u(run`index`fmt`sub,%q<t1>,%q<db>,%0)]%B%B[u(run`index`fmt`sub,%q<t1>,%q<db>,%1)]
&run`index`fmt`sub [u(cobj,help)]=[if([gte([words(%2)],1)],[align(26 >[sub([div([sub([u(gconfig,%#,width)],2)],2)],27)],[ansi([u(gconfig,%q<t1>,LINE_TEXT)],[get(%1/file`%2)])],[u(get_unread,%q<t1>,%2)][timefmt($M/$D/$Y,[get(%q<db>/file`%2`update)])])])]

&get_unread [u(cobj,help)]=[if([gtm([u(get_unread`nums,[filter(fil`is_unread,%1,|)])],%1)],[ansi([u(gconfig,%q<t1>,line_accent)],*)],[if([gte([words([iter(%2,[filter(fil`is_unread,##,|)],|,|)],|)],1)],[ansi([u(gconfig,%q<t1>,line_accent)],+)],)])]

&get_unread`nums [u(cobj,help)]=[iter(%0,[first(##,~)],|,|)]

&fil`is_unread [u(Cobj,help)]=[if([gtm([setr(read,[get([getid(%q<t1>)]/[u(VT)]`read`%q<sys>)])],%0~*,|)],[gt([get(%q<db>/file`%0`update)],[last([grab(%q<read>,%0~*,|)],~)])],1)]


&get_unread`sub [u(Cobj,help)]=[if([gtm([words([iter(%0,[filter(fil`is_unread,##,|)],|,|)],|)],1)],[ansi([u(gconfig,%q<t1>,line_accent)],*)])]

&get_files`sub [u(cobj,help)]=[setq(s1,[get(%q<db>/root`%1)])][sortby(sort`filename,[setq(db,%q<db>)][setunion(%q<s1>,%q<s1>,|)],|)]
