REM #-> Este script permite llevar un registro de los discos de copias que se han conectado a una letra de unidad y asignarles un alias para identificarlos facilmente al revisar el log, tambien detecta si no se habia conectado el disco o si se ha conectado uno diferente a los habituales. El log se purga automaticamente, conservando solo los 3 ultimos meses de informacion
REM #-> Solo hay que configurar la letra de unidad que se desea monitorizar y asignar los ID de los discos duros de copias a las variables A y B 

@ECHO OFF
REM #-> !!!!!!!!!!!!!! AVISO!!!!!!!!!!!!!!! Esta version del script es unicamente para comprender su funcionamiento (ya que los comentarios hacen que pete) "DISKLOGGER_v2.bat" es la version funcional sin comentarios 
REM #-> Asigna el output que devuelve el mountvol a la variable "CURRENT_ID" | Lo unico que hay que cambiar es la letra de unidad del disco, en este caso era la E:
FOR /F "tokens=* USEBACKQ" %%F IN (`mountvol E: /L`) DO (
SET CURRENT_ID=%%F
)

REM #-> Asignamos un identificador a cada disco segun su ID, para mas adelante poder distinguirlos facilmente
SET A=\\?\Volume{a20f82bd-d9a0-11ea-a2c4-001a7dda7113}\
SET B=\\?\Volume{b101b563-bda7-11e6-80e2-ecb1d7f4bdcd}\

REM #-> Aqui comprueba el disco que hay conectado, en caso de no reconocerlo, devuelve su ID. | las comillas hacen falta porque si el disco no estaba conectado, la variable contiene %CURRENT_ID% una cadena de texto con espacios y petan los "IF" 
IF /I "%CURRENT_ID%"=="%A%" echo %DATE% --^> Disco A >> C:\DISKLOG.txt
IF /I "%CURRENT_ID%"=="%B%" echo %DATE% --^> Disco B >> C:\DISKLOG.txt
REM #-> NEQ es el != de windows
IF /I "%CURRENT_ID%" NEQ "%A%" IF /I "%CURRENT_ID%" NEQ "%B%" echo %DATE% --^> Disco desconectado o desconocido: %CURRENT_ID% >> C:\DISKLOG.txt

REM #-> Metemos mes y año en una variable para trimear posteriormente el fichero y quedarnos solo con los ultimos 3 meses de logging
SET Y=%date:~6,4%
SET M=%date:~3,2%

REM #-> Si estamos en enero...
IF /I "%M%"=="01" (
	setlocal EnableDelayedExpansion REM #-> Esto hace falta para poder asignar variables desde dentro de un IF, ademas, las variables pasan a invocarse con !variable!
	set M2=12	REM #-> establecemos manualmente los 2 meses previos a enero y restamos uno al año al actual
	set M3=11	 
	set /a Y=%Y-1 
	findstr "!M3!/!Y!" C:\DISKLOG.txt > %USERPROFILE%\temp.txt REM #-> findstr busca una cadena dentro de un fichero de texto y devuelve solo las lineas que contengan dicha cadena, para no machacar nuestro disklog, redirigimos el resultado a temp.txt dentro del perfil del usuario, para evitar problemas de permisos
	findstr "!M2!/!Y!" C:\DISKLOG.txt >> %USERPROFILE%\temp.txt
	set Y=%date:~6,4% REM #-> restablecemos el año actual
	findstr "!M!/!Y!" C:\DISKLOG.txt >> %USERPROFILE%\temp.txt
) ELSE (
	IF /I "%M%"=="02" (
		setlocal EnableDelayedExpansion
		set M2=01
		set M3=12
		set /a Y=%Y-1
		findstr "!M3!/!Y!" C:\DISKLOG.txt > %USERPROFILE%\temp.txt
		set Y=%date:~6,4%
		findstr "!M2!/!Y!" C:\DISKLOG.txt >> %USERPROFILE%\temp.txt
		findstr "!M!/!Y!" C:\DISKLOG.txt >> %USERPROFILE%\temp.txt
) ELSE (
	setlocal EnableDelayedExpansion
	set /a M2=%M-1
	set /a M3=%M-2
	findstr "!M3!/!Y!" C:\DISKLOG.txt > %USERPROFILE%\temp.txt
	findstr "!M2!/!Y!" C:\DISKLOG.txt >> %USERPROFILE%\temp.txt
	findstr "!M!/!Y!" C:\DISKLOG.txt >> %USERPROFILE%\temp.txt
	)
)

type %USERPROFILE%\temp.txt > C:\Users\NEKKO\Desktop\script\DISKLOG.txt REM #-> Ahora que ya tenemos nuestros 3 meses de informacion en un mismo fichero, machacamos el disklog original
del %USERPROFILE%\temp.txt REM #-> y borramos el fichero temporal, no hay que ir dejando basura por ahi...

REM #-> Known Bugs & Future Updates:
REM #-> En algunos PCs, el script no tiene permiso de escritura sobre C:\DISKLOG.txt y todo se va a la puta, crea manualmente el fichero y dale permisos de escritura para todos 
REM #-> Esta version solo soporta monitoreo a una unica letra de unidad, puede que mas adelante lo mejore
REM #-> OJO! hacer backup del DISKLOG antes de implementar el script por primera vez ya que es incompatible con la version anterior debido al formato del log, puede que saque un conversor mas adelante
REM #-> Code By: Mario Nekko ~ Feel free to edit or distribute


