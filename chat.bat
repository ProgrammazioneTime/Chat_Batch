@echo off
title ChatBox
::CREAZIONE DELLA CARTELLA SU DESKTOP CON TUTTI I SOTTOFILE DI LAVORO
cd %userprofile%\desktop
if not exist storage (
    mkdir storage
) else (
    cd storage
    goto main
)
cd storage
for %%a IN (crea_chat live invia) DO (
if not exist %%a.bat call :%%a %%a
)
goto main

::  CREAZIONE CREA_CHAT.BAT
:crea_chat
cls
(echo @echo off)>%1.bat
(echo set chiave=%%1)>>%1.bat
(echo ::CREA CHAT)>>%1.bat
(echo if not exist crea_chat.txt goto creazione)>>%1.bat
(echo.)>>%1.bat
(echo :invia)>>%1.bat
(echo ftp -s:crea_chat.txt)>>%1.bat
(echo exit)>>%1.bat
(echo.)>>%1.bat
(echo :creazione)>>%1.bat
(echo echo open FTP.NOMEHOST^>crea_chat.txt)>>%1.bat
(echo echo USERNAME^>^>crea_chat.txt)>>%1.bat
(echo echo PASSWORD^>^>crea_chat.txt)>>%1.bat
(echo echo lcd %userprofile%\desktop\storage^>^>crea_chat.txt)>>%1.bat
(echo echo put chat_%%chiave%%.txt^>^>crea_chat.txt)>>%1.bat
(echo echo quit^>^>crea_chat.txt)>>%1.bat
(echo timeout /T 1 ^> nul)>>%1.bat
(echo goto invia)>>%1.bat
goto :EOF

::  CREAZIONE LIVE.BAT
:live
cls
(echo @echo off)>%1.bat
(echo title LiveChat)>>%1.bat
(echo set chiave=%%1)>>%1.bat
(echo if not exist confronta.bat goto crea)>>%1.bat
(echo.)>>%1.bat
(echo :ripeti)>>%1.bat
(echo if exist esci.txt exit)>>%1.bat
(echo start /MIN scarica.bat)>>%1.bat
(echo start /MIN confronta.bat)>>%1.bat
(echo cls)>>%1.bat
(echo type chat_%%chiave%%.txt)>>%1.bat
(echo echo.)>>%1.bat
(echo timeout /t 1 ^> nul)>>%1.bat
(echo goto ripeti)>>%1.bat
(echo.)>>%1.bat
(echo :crea)>>%1.bat
(echo (echo @echo off^)^>confronta.bat)>>%1.bat
(echo (echo comp /M chat1.txt chat2.txt^)^>^>confronta.bat)>>%1.bat
(echo (echo if %%%%errorlevel%%%% equ 1 (^)^>^>confronta.bat)>>%1.bat
(echo (echo copy /b chat2.txt chat1.txt^)^>^>confronta.bat)>>%1.bat
(echo (echo copy /b chat1.txt chat_%%chiave%%.txt^)^>^>confronta.bat)>>%1.bat
(echo (echo ^^^)^)^>^>confronta.bat)>>%1.bat
(echo (echo exit^)^>^>confronta.bat)>>%1.bat
(echo goto ripeti)>>%1.bat
goto :EOF

::  CREAZIONE INVIA.BAT
:invia
cls
(echo @echo off)>%1.bat
(echo ftp -s:avvia.txt)>>%1.bat
(echo exit)>>%1.bat
goto :EOF

::CREAZIONE O ACCESSO A CHAT SPECIFICA
:main
cls
echo 1. Crea una chat
echo 2. Accedi a una chat
echo 3. Informazioni
echo 4. Esci
choice /c 1234 /n
if %errorlevel% == 1 goto crea
if %errorlevel% == 2 goto accedi 
if %errorlevel% == 3 goto info
if %errorlevel% == 4 exit
:crea
cls
set chiave=%random%
echo Chat numero %chiave% creata, condividi la chiave numerica per far accedere gli amici.
echo Creazione chat in corso...
echo.
echo.
fsutil file createNew chat_%chiave%.txt 0
timeout /T 1 > nul
start /MIN crea_chat.bat %chiave%
pause
goto reg


::ACCESSO A CHAT ESISTENTE
:accedi
cls
set/p "chiave=Inserisci la chiave numerica per accedere alla chat: "
if '%chiave%' == '' echo Chiave non valida, riprova. && pause && goto accedi
curl http://mercatinopovero.altervista.org/chat_%chiave%.txt --output chat_%chiave%.txt
goto reg

::CREAZIONE DEL FILE AVVIA.TXT E SCARICA.BAT
:reg
cls
echo open FTP.NOMEHOST>avvia.txt
echo USERNAME>>avvia.txt
echo PASSWORD>>avvia.txt
echo lcd %userprofile%\desktop\storage>>avvia.txt
echo put chat_%chiave%.txt>>avvia.txt
echo quit>>avvia.txt
echo @echo off>scarica.bat
echo curl http://mercatinopovero.altervista.org/chat_%chiave%.txt --output chat2.txt>>scarica.bat
echo exit>>scarica.bat
:user
cls
echo inserisci il tuo nome:
set/p str=
if '%str%' == '' echo Username non valido, riprova. && pause && goto user
set nome=%str%
call :unisciti
:mex
cls
echo Per prima cosa saluta in chat
set/p "str=-> "
if "%str%" == "bye" goto esci
echo %nome%: %str%>>chat_%chiave%.txt
timeout /t 1 > nul
start /MIN invia.bat
copy /b chat_%chiave%.txt chat1.txt
cls
timeout /t 1 > nul
start live.bat %chiave%

:chat
cls
echo -Per uscire dalla chat scrivi "bye"-
set/p "str=-> "
if "%str%" == "bye" goto esci
echo %nome%: %str%>>chat_%chiave%.txt
timeout /t 1 > nul
start /MIN invia.bat
goto chat

::ELIMINAZIONE DEI FILE INUTILI E USCITA
:esci
echo "%nome%" ha appena lasciato la chat>>chat_%chiave%.txt
timeout /t 1 > nul
start /MIN invia.bat
echo Eliminazione file temporanei della chat in corso...
fsutil file createNew esci.txt 0
cd..
timeout /t 3 > nul
rd /q /s storage
exit

::AVVISO D'UNIONE ALLA CHAT
:unisciti
cls
echo "%nome%" si e' appena unito alla chat>>chat_%chiave%.txt
timeout /T 1 > nul
start /MIN invia.bat
goto :EOF

:info
mode con: cols=84 lines=18
cls
echo.
echo                INFORMAZIONI ~ ChatBox ©
echo.
echo [ Chat creata da Programmazione Time. ]
echo [ Supporto per test e collaborazione con Sparpvp. ]
echo [ Versione ChatBox: 1.0.0 ]
echo.
echo ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
echo º                                                       º
echo º  [1] Vai al mio canale YouTube                        º
echo º  [2] Vai al mio canale Telegram                       º
echo º  [3] Vai al mio profilo Instagram                     º
echo º                                                       º
echo ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
echo.
choice /c 01234 /n /m "Scegli una delle opzioni (per tornare indietro premi 0):"
if %errorlevel% == 1 goto main
if %errorlevel% == 2 start https://www.youtube.com/channel/UCDq9FlqxaAZmgoLBgf5KtYA && goto main
if %errorlevel% == 3 start https://t.me/programmazionetime && goto main
if %errorlevel% == 4 start https://www.instagram.com/programmazionetime_official && goto main