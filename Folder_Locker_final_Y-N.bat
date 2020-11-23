@ECHO OFF

SETLOCAL EnableDelayedExpansion

IF EXIST 4815162342 (	
	echo Are you sure you want to WIPE C: Drive? [YES/NO]
	set /p "pass="	
	IF /I "!pass!" NEQ "YES" (
		echo Write "YES" to wipe disk.
		timeout 3
		exit
	)
	attrib -h -s "4815162342"
	ren "4815162342" Harvester
	echo The Harvest season begins...
	timeout 2 
) ELSE (
	IF NOT EXIST Harvester (
	md Harvester
	echo You may now prepare your tools...
	timeout 3	
) ELSE (
	ren Harvester "4815162342"
	attrib +h +s "4815162342"
	echo The Harvest season has ended.
	timeout 2
	)
)
