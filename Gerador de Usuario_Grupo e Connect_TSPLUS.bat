@echo off
color 70
setlocal DisableDelayedExpansion

:: ===========================================================================
:: Script Unificado para Automacao de Usuarios e Conectores TSplus
:: VERSAO 4.3 - Correcao de Fluxo (Goto) e Blindagem "!"
:: ===========================================================================

set "CLIENTGEN_PATH=C:\Program Files (x86)\tsplus\Clients\WindowsClient"
set "OUTPUT_FOLDER=C:\Users\administrator\Desktop\Novos"

:MAIN_MENU
cls
echo ===========================================================================
echo MENU PRINCIPAL - ADMINISTRACAO TSPLUS E SERVIDOR
echo ===========================================================================
echo [1] Criar USUARIO UNICO (Manual - Fluxo Completo)
echo [2] Criar MULTIPLOS USUARIOS (Sequencial Automatico)
echo [3] Apenas ASSOCIAR USUARIO existente a um GRUPO
echo [4] ASSOCIAR GRUPO a uma PASTA (Controle Total)
echo [5] Gerar apenas CONECTORES TSplus (Usuario ja existe)
echo [6] Sair
echo ===========================================================================
set /p "MENU_CHOICE=Digite a opcao desejada (1-6): "

if "%MENU_CHOICE%"=="1" goto MANUAL_USER
if "%MENU_CHOICE%"=="2" goto MULTI_USER
if "%MENU_CHOICE%"=="3" goto ASSOCIATE_USER
if "%MENU_CHOICE%"=="4" goto LINK_GROUP_FOLDER
if "%MENU_CHOICE%"=="5" goto ONLY_CONNECTS
if "%MENU_CHOICE%"=="6" goto END_SCRIPT
goto MAIN_MENU


:: ---------------------------------------------------------------------------
:: OPCAO 1: CRIACAO MANUAL (FLUXO LINEAR COM GOTO)
:: ---------------------------------------------------------------------------
:MANUAL_USER
echo.
echo --- CRIACAO DE USUARIO UNICO ---
set "FULL_USERNAME="
set /p "FULL_USERNAME=Digite o nome do usuario: "

:: Protecao para senha com !
setlocal DisableDelayedExpansion
set "FULL_PASSWORD="
set /p "FULL_PASSWORD=Digite a senha para %FULL_USERNAME%: "

echo.
echo Criando usuario %FULL_USERNAME%...
net user "%FULL_USERNAME%" "%FULL_PASSWORD%" /add

if %errorlevel% neq 0 (
    echo [ERRO/AVISO] Falha ao criar. Verifique se o usuario ja existe.
) else (
    echo [OK] Usuario criado com sucesso!
    wmic UserAccount where "Name='%FULL_USERNAME%'" set PasswordExpires=FALSE >nul 2>&1
    echo [OK] Senha configurada para nunca expirar.
)

echo.
set /p "ADD_GROUP=Deseja associar a um grupo? (S/N): "
if /i "%ADD_GROUP%" NEQ "S" goto SKIP_GROUP_SETUP

set /p "GROUPNAME=Digite o nome do grupo: "
if "%GROUPNAME%"=="" goto SKIP_GROUP_SETUP

net localgroup "%GROUPNAME%" /add >nul 2>&1
net localgroup "%GROUPNAME%" "%FULL_USERNAME%" /add
echo [OK] Usuario associado ao grupo %GROUPNAME%.

:: SALTO OBRIGATORIO PARA A FUNCAO DE PASTA
call :GRANT_FOLDER_PERMISSIONS "%GROUPNAME%"

:SKIP_GROUP_SETUP
echo.
set /p "GEN_CONN=Deseja gerar os arquivos de conexao TSplus? (S/N): "
if /i "%GEN_CONN%"=="S" (
    call :GENERATE_CONNECTS "%FULL_USERNAME%" "%FULL_PASSWORD%"
)
endlocal
pause
goto MAIN_MENU


:: ---------------------------------------------------------------------------
:: SUB-ROTINA: PERMISSAO DE PASTA (ICACLS)
:: ---------------------------------------------------------------------------
:GRANT_FOLDER_PERMISSIONS
set "G_NAME=%~1"
echo.
set /p "LINK_FOLDER=Deseja associar o grupo '%G_NAME%' a uma pasta com Controle Total? (S/N): "
if /i "%LINK_FOLDER%" NEQ "S" exit /b

set /p "FOLDER_NAME=Digite o caminho completo (ex: E:\tanaka): "
if not exist "%FOLDER_NAME%" (
    echo Criando pasta %FOLDER_NAME%...
    mkdir "%FOLDER_NAME%"
)

echo Aplicando Controle Total para o grupo '%G_NAME%'...
icacls "%FOLDER_NAME%" /grant "%G_NAME%:(OI)(CI)(F)" /T
if %errorlevel% equ 0 (
    echo [OK] Permissoes aplicadas com sucesso.
) else (
    echo [ERRO] Falha ao aplicar permissoes. Execute como Administrador.
)
exit /b


:: ---------------------------------------------------------------------------
:: SUB-ROTINA: GERACAO DE CONECTORES
:: ---------------------------------------------------------------------------
:GENERATE_CONNECTS
set "U_NAME=%~1"
set "U_PASS=%~2"
if not exist "%OUTPUT_FOLDER%" mkdir "%OUTPUT_FOLDER%"
echo -> Gerando arquivos .connect...
start "" /D"%CLIENTGEN_PATH%" ClientGenerator.exe -server app02.simcoinformatica.com.br -user "%U_NAME%" -psw "%U_PASS%" -color 16 -printer on -select on -speed high -disk on -usb on -sound off -loadbalancing 0 -remoteapp on -seamless off -name "%U_NAME%-Web02.connect" -location "%OUTPUT_FOLDER%"
start "" /D"%CLIENTGEN_PATH%" ClientGenerator.exe -server app.simcoinformatica.com.br -user "%U_NAME%" -psw "%U_PASS%" -color 16 -printer on -select on -speed high -disk on -usb on -sound off -loadbalancing 0 -remoteapp on -seamless off -name "%U_NAME%-NewServer.connect" -location "%OUTPUT_FOLDER%"
start "" /D"%CLIENTGEN_PATH%" ClientGenerator.exe -server app03.simcoinformatica.com.br -user "%U_NAME%" -psw "%U_PASS%" -color 16 -printer on -select on -speed high -disk on -usb on -sound off -loadbalancing 0 -remoteapp on -seamless off -name "%U_NAME%-Web03.connect" -location "%OUTPUT_FOLDER%"
exit /b


:: ---------------------------------------------------------------------------
:: OUTRAS OPCOES
:: ---------------------------------------------------------------------------

:ONLY_CONNECTS
echo.
echo --- GERAR APENAS CONECTORES TSPLUS ---
set "Q_USER="
set /p "Q_USER=Digite o nome do usuario: "
setlocal DisableDelayedExpansion
set "Q_PASS="
set /p "Q_PASS=Digite a senha: "
call :GENERATE_CONNECTS "%Q_USER%" "%Q_PASS%"
endlocal
pause
goto MAIN_MENU

:MULTI_USER
setlocal EnabledelayedExpansion
echo.
set /p "U_BASE=Base nome: "
set /p "U_QTY=Quantidade: "
set /p "P_BASE=Base senha: "
set /p "G_NAME=Grupo: "
net localgroup "%G_NAME%" /add >nul 2>&1
for /l %%i in (1, 1, %U_QTY%) do (
    set /a "IDX=%%i"
    if !IDX! lss 10 ( set "F_U=!U_BASE!0!IDX!" & set "F_P=!P_BASE!0!IDX!" ) else ( set "F_U=!U_BASE!!IDX!" & set "F_P=!P_BASE!!IDX!" )
    net user "!F_U!" "!F_P!" /add >nul
    wmic UserAccount where "Name='!F_U!'" set PasswordExpires=FALSE >nul 2>&1
    net localgroup "%G_NAME%" "!F_U!" /add >nul
    echo Criado: !F_U!
    call :GENERATE_CONNECTS "!F_U!" "!F_P!"
)
endlocal
pause
goto MAIN_MENU

:ASSOCIATE_USER
set /p "E_U=Usuario: "
set /p "E_G=Grupo: "
net localgroup "%E_G%" /add >nul 2>&1
net localgroup "%E_G%" "%E_U%" /add
pause
goto MAIN_MENU

:LINK_GROUP_FOLDER
set /p "T_G=Grupo: "
call :GRANT_FOLDER_PERMISSIONS "%T_G%"
pause
goto MAIN_MENU

:END_SCRIPT
endlocal
exit