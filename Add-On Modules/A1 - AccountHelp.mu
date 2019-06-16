&shlp`account [u(cobj,ams)]=[ansi([u(gconfig,%#,line_accent)],Commands)]:%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],+account <player/account name>)] - Shows the account information for the player or account.)]%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],+account/list %[<page>%])] - Lists all the accounts in the system. If there are multiple pages\, you can supply the page number.)]%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],+account/freeze <player>)] - This freezes all characters associated with the account. This also moves them to the freezer room.)]%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],+account/jail <player>)] - This marks all players on the account as jailed. This moves them to the jail room. This places very restrictive flags on the players.)]%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],+account/release <player>)] - This removes either the freeze or jailed status from all players associated with the account.)]%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],+account/create <player>=<email>)] - This command creates an account\, then links it to the player and sets them as the master character.)]

&hlp`account [u(cobj,ams)]=[ansi([u(gconfig,%#,line_accent)],Commands)]:%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],+account)] - Shows your current account information.)][if([gameconfig(%#,CREATE_ACCOUNT)],%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],+account/new <email>)] - Creates an account for you.)])][if([gameconfig(%#,RENAME_ACCOUNT)],%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],+account/rename <new email>)] - Renames the account. This requires that you be either the Master Character or the account set to allow all to manage.)])]%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],+account/request <player>)] - Requests to be added to the player's account.)]%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],+account/reqlist)] - Shows all requests for your current account.)]%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],+account/approve <request number>)] - Approves someone to join your account. Requires that you either be the Master Character or the account set to allow all to manage.)]%R[align(10 [sub([u(gconfig,%#,width)],11)],,[ansi([u(gconfig,%#,line_text)],+account/deny <request number>)] - Denies someone to join your account. Requires that you either be the Master Character or the account set to allow all to manage.)]

+help/add Out of Character/Account=[u(cobj,ams)]/hlp`account
+help/add Players/Account=[u(cobj,ams)]/shlp`account
+install AMS=1.0