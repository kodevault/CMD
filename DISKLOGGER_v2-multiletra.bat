@ECHO OFF

REM #-> Localiza y sustituye las XXXXXXX por las letras de unidad a monitorizar, ejemplo: XXXXXXX: > F:
FOR /F "tokens=* USEBACKQ" %%F IN (`mountvol XXXXXXX: /L`) DO (
SET CURRENT_ID=%%F
)

REM #-> Sustituye los IDs actuales por los IDs de tus discos, respetando el formato.
SET A=\\?\Volume{a20f82bd-d9a0-11ea-a2c4-001a7dda7113}\
SET B=\\?\Volume{53ab3993-4d42-11e7-b836-d8cb8a15dd32}\
setlocal EnableDelayedExpansion
SET DoubleCheck=True

:DriveCheck
IF /I "%CURRENT_ID%"=="%A%" (
	echo !DATE! --^> Disco A >> C:\DISKLOG.txt
) ELSE (
	IF /I "%CURRENT_ID%"=="%B%" (
		echo %DATE% --^> Disco B >> C:\DISKLOG.txt
) ELSE (
	IF /I %DoubleCheck%==True (
	FOR /F "tokens=* USEBACKQ" %%F IN (`mountvol XXXXXXX: /L`) DO (
	SET CURRENT_ID=%%F
	)
	SET DoubleCheck=False
	goto DriveCheck
) ELSE (
	echo %DATE% --^> Disco desconectado o desconocido: %CURRENT_ID% >> C:\DISKLOG.txt
)
)
)

SET Y=%date:~6,4%
SET M=%date:~3,2%

IF /I "%M%"=="01" (
	set M2=12
	set M3=11
	set /a Y=%Y-1	
	findstr "!M3!/!Y!" C:\DISKLOG.txt > %USERPROFILE%\temp.txt 
	findstr "!M2!/!Y!" C:\DISKLOG.txt >> %USERPROFILE%\temp.txt
	set Y=%date:~6,4% 
	findstr "!M!/!Y!" C:\DISKLOG.txt >> %USERPROFILE%\temp.txt
) ELSE (
	IF /I "%M%"=="02" (
		set M2=01
		set M3=12
		set /a Y=%Y-1
		findstr "!M3!/!Y!" C:\DISKLOG.txt > %USERPROFILE%\temp.txt
		set Y=%date:~6,4%
		findstr "!M2!/!Y!" C:\DISKLOG.txt >> %USERPROFILE%\temp.txt
		findstr "!M!/!Y!" C:\DISKLOG.txt >> %USERPROFILE%\temp.txt
) ELSE (
	set /a M2=%M-1
	set /a M3=%M-2
	findstr "!M3!/!Y!" C:\DISKLOG.txt > %USERPROFILE%\temp.txt
	findstr "!M2!/!Y!" C:\DISKLOG.txt >> %USERPROFILE%\temp.txt
	findstr "!M!/!Y!" C:\DISKLOG.txt >> %USERPROFILE%\temp.txt
	)
)

type %USERPROFILE%\temp.txt > C:\DISKLOG.txt 
del %USERPROFILE%\temp.txt 
exit

REM #-> Known Bugs & Future Updates:
REM #-> En algunos PCs, el script no tiene permiso de escritura sobre C:\DISKLOG.txt y todo se va a la puta, crea manualmente el fichero y dale permisos de escritura para todos 
REM #-> OJO! hacer backup del DISKLOG antes de implementar el script por primera vez ya que es incompatible con la version anterior debido al formato del log
REM #-> Code By: Mario Nekko ~ Feel free to edit or distribute



