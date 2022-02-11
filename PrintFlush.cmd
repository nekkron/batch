@ECHO OFF
echo ----------------------------------
echo Print Flush - 1.3 - By Brad Kovach
echo ----------------------------------
echo.

echo Step 1: Stop the Print Spooler
echo ------------------------------
net stop spooler
echo.

echo Step 1.5: Reassigning Print Spooler Dependencies
echo ------------------------------------------------
echo this step is important if you have a Lexmark printer which screws up the services and may make it impossible to start the print spooler
echo.
sc config spooler depend= RPCSS
echo.
echo Done!
echo.

echo Step 2: Erasing old chaf (junk printer documents)
echo -------------------------------------------------
del /Q /F /S "%systemroot%\System32\Spool\Printers\*.*"
echo Done!
echo.

echo Step 3: Problems eliminated! Restarting printer services
echo --------------------------------------------------------
net start spooler
echo Spooler has been restarted!
echo.

echo Step 4: Try printing again.
pause>nul