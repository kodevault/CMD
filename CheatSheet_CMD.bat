REM Windows Command Line Scripting
REM Guia basica de Batch

!!!! un simple espacio puede hacer que todo el codigo pete !!!!
-------------------------------------------------------------

@ECHO OFF	rem oculta gran parte del promt y las rutas de ejecucion, mostrando solo lo que quieres mostrar
title Este es el nombre de la ventana.


rem captura el resultado del mountvol y lo guarda en la variable current_ID
FOR /F "tokens=* USEBACKQ" %%F IN (`mountvol E: /L`) DO (
SET CURRENT_ID=%%F
)

rem IMPRESCINDIBLE para asignar variables dentro de un IF
SETLOCAL EnableDelayedExpansion

