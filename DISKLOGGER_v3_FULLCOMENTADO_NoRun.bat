@ECHO OFF	

REM #-> VERSION 3, PARA COMENTARIOS ADICIONALES VER LA VERSION2 FULLCOMENTADA

REM #-> Cambia la X por la letra de unidad que deseas monitorizar:
FOR /F "tokens=* USEBACKQ" %%F IN (`mountvol X: /L`) DO (
SET CURRENT_ID=%%F
)

REM #-> Sustituye los IDs actuales por los IDs de tus discos, respetando el formato.
SET A=\\?\Volume{a20f82bd-d9a0-11ea-a2c4-001a7dda7113}\
SET B=\\?\Volume{b101b563-bda7-11e6-80e2-ecb1d7f4bdcd}\
setlocal EnableDelayedExpansion

IF /I "%CURRENT_ID%"=="%A%" echo %DATE% --^> Disco A >> C:\DISKLOG.txt
IF /I "%CURRENT_ID%"=="%B%" echo %DATE% --^> Disco  B >> C:\DISKLOG.txt
IF /I "%CURRENT_ID%" NEQ "%A%" IF /I "%CURRENT_ID%" NEQ "%B%" echo %DATE% --^> Disco desconectado o desconocido: %CURRENT_ID% >> C:\DISKLOG.txt

REM #-> La variable Z la vamos a usar para quitarle el 0 de delante a los meses del 1 al 9 pq a la hora de hacer operaciones matematicas piensa que es octal y se china
SET Z=%date:~3,1%
SET Y=%date:~6,4%
SET M=%date:~3,2%

REM #-> En este if averiguamos si el primer digito del mes es un 0 y en ese caso, lo omitimos y cogemos solo el segundo
IF /I "%Z%"=="0" SET M=%date:~4,1% 

IF /I "%M%"=="1" (
	set M2=12
	set M3=11
	set /a Y=%Y-1	
	findstr "!M3!/!Y!" C:\DISKLOG.txt > %USERPROFILE%\temp.txt 
	findstr "!M2!/!Y!" C:\DISKLOG.txt >> %USERPROFILE%\temp.txt
	set Y=%date:~6,4% 
	findstr "!M!/!Y!" C:\DISKLOG.txt >> %USERPROFILE%\temp.txt
) ELSE (
	IF /I "%M%"=="2" (
		set M2=01
		set M3=12
		set /a Y=%Y-1
		findstr "!M3!/!Y!" C:\DISKLOG.txt > %USERPROFILE%\temp.txt
		set Y=%date:~6,4%
		findstr "!M2!/!Y!" C:\DISKLOG.txt >> %USERPROFILE%\temp.txt
		findstr "!M!/!Y!" C:\DISKLOG.txt >> %USERPROFILE%\temp.txt
) ELSE (
	set /A M2=%M-1
	set /A M3=%M-2
	findstr "!M3!/!Y!" C:\DISKLOG.txt > %USERPROFILE%\temp.txt
	findstr "!M2!/!Y!" C:\DISKLOG.txt >> %USERPROFILE%\temp.txt
	findstr "!M!/!Y!" C:\DISKLOG.txt >> %USERPROFILE%\temp.txt
	)
)
type %USERPROFILE%\temp.txt > C:\DISKLOG.txt 
del %USERPROFILE%\temp.txt 
exit

REM #-> Known Bugs & Future Updates:
REM #-> En algum momento cambiare los hardcoded path a variables
REM #-> En algunos PCs, el script no tiene permiso de escritura sobre C:\DISKLOG.txt y todo se va a la puta, crea manualmente el fichero y dale permisos de escritura para todos 
REM #-> Esta version solo soporta monitoreo a una unica letra de unidad, para Multi-Unidad usar DISKLOGGER_v2-multiletra
REM #-> Code By: Mario Nekko ~ Feel free to edit or distribute



