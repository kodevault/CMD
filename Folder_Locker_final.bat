@ECHO OFF

SETLOCAL EnableDelayedExpansion

IF EXIST 4815162342 (	
	echo Intentos restantes: 1
	set /p "pass="	
	IF /I "!pass!" NEQ "23fcarlos" (
		echo Error 403.
		timeout 3
		exit
	)
	attrib -h -s "4815162342"
	ren "4815162342" Zulo24
	echo Recuerda volver a cerrar el Zulo...
	timeout 3 
) ELSE (
	IF NOT EXIST Zulo24 (
	md Zulo24
	echo Zulo24 excavado con exito!
	timeout 3	
) ELSE (
	ren Zulo24 "4815162342"
	attrib +h +s "4815162342"
	echo El zulo ha sido ocultado.
	timeout 3
	)
)
