&hlp`system [u(Cobj,core)]=[ansi([u(gconfig,%#,line_accent)],Commands)]:%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],+system)] - Shows all modules installed for the Matrix MUSH Code Suite.)]

&hlp`charset [u(cobj,core)]=[ansi([u(gconfig,%#,line_accent)],Commands)]: %R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],+charset)] - Shows all the available characters that can be generated on the game server. These are used in conjunction with the \[chr\(\)\] function.)]

&shlp`cobj [u(Cobj,core)]=[ansi([u(gconfig,%#,line_accent)],Commands)]:%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],+coreobjects)] - Shows all core code objects Matrix MUSH Code Suite.)]

&hlp`credits [u(cobj,core)]=%TThe Matrix Code Suite was heavily influenced by Volund's Code Suite in both appearance and functionality. While some of the backbone code is directly copied from Volund, the majority of the code is original to this suite. The Suite is coded exclusively for RhostMUSH and will not be supported on any other platform.%R%R%TI consider this the spiritual successor to Volund's Code Suite. All credit goes to Volund for the parts of the code that he wrote. The code that was inspired by his code suite is mostly inspired for the look and functionality, not the actual code. %R%R%TIn addition to Volund's Code Suite there are several other systems that are highly modified to fit the system, but were not entirely coded by Matrix for the code suite. These include, but are not limited to, AshComm, the mailwrappers and a few other systems. Matrix will fully disclose which systems, if desired.%R%R%TThis code suite is not intended to challenge anyone's creative effort or to take credit. The suite has modified these code systems to work with its systems to allow for ease of install and integration. The goal was to simply create a code snapshot that would make it easy to get a RhostMUSH up and running from the code system with minimal effort.%R%R%R%TThanks,%R%T%TMatrix.


&shlp`install [u(cobj,core)]=[ansi([u(gconfig,%#,line_accent)],Commands)]:%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],+install <system>=<version>)] - Installs the code object into the system.)]%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],+install/update <system>=<version>)] - Updates the system version for the system.)]%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],+install/remove <system>)] - Uninstalls the code from the system.)]%R%R%TThis code is strictly for the Operations staff members. This is needed to allow some commands to be triggered.

&shlp`gameconfig [u(cobj,core)]=[ansi([u(gconfig,%#,line_accent)],Commands)]:%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],+gameconfig)] - Lists all the various game configuration files.)]%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],+gameconfig <config>)] - Views the information for the configuration.)]%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],+gameconfig/set <config>=<value>)] - Sets the config to what value you supply.)]%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],+gameconfig/clear <config>)] - Returns the config to the default values.)]


&hlp`config [u(cobj,core)]=[ansi([u(gconfig,%#,line_accent)],Commands)]:%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],+config)] - Lists all the various game configuration files.)]%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],+config <config>)] - Views the information for the configuration.)]%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],+config/set <config>=<value>)] - Sets the config to what value you supply.)]%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],+config/clear <config>)] - Returns the config to the default values.)]


&shlp`validators [u(Cobj,core)]=%TThis is a list of the validators used by the system to check to make sure a configuration is value is actually acceptable.%r%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],COLOR)] - It looks for ansi names such as +red\, to set.)]%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],INT)] - It looks for a number that is 0 or greater. Such as 1.)]%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],WORD)] - It looks for any word\, character\, number or anything similar.)]%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],LIST)] - It looks for a list of items separated by | only.)]%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],BOOL)] - It looks for either a 1 %(For True%) or 0 %(For False%).)]%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],DBREF)] - It looks for only a DBREF from the MUSH. Such as #2.)]%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],EMAIL)] - Checks to see if the email is in the valid format.)]%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],TZ)] - Checks to see if that is a valid Timezone.)]%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],TIME)] - Checks to make sure that it is a valid time.)]%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],DURATION)] - Checks to see if it is a valid duration.)]


+shelp/add Technical/+gameconfig=[u(cobj,core)]/shlp`gameconfig
+shelp/addsub +gameconfig/Validators=[u(cobj,core)]/shlp`validators
+shelp/add Technical/+install=[u(cobj,core)]/shlp`install
+help/add Technical/+charset=[u(cobj,core)]/hlp`charset
+help/add Technical/+system=[u(cobj,core)]/hlp`SYSTEM
+help/add Technical/Credits=[u(cobj,core)]/hlp`credits
+help/add Technical/+config=[u(cobj,core)]/hlp`config
+help/addsub +config/Validators=[u(cobj,core)]/shlp`validators
+shelp/add Technical/+coreobjects=[u(cobj,core)]/shlp`cobj
