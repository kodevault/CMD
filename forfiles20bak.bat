rem Borrado de ficheros com mas de 20 dias de antiguedad
forfiles /s /p C:\nieves\bk /m *.bak /d -20 /c "cmd /c del @file"