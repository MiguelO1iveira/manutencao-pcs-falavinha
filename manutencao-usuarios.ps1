New-Alias -Name "wh" -Value "Write-Host"
New-Alias -Name "rh" -Value "Read-Host"


# ============================================================
#              SCRIPT DE MANUTENCAO DE USUARIOS
# ============================================================


function Limpar-ArquivosTemporarios {

    wh ""
    wh "+----------------------------------------------------------+" 
    wh "| [1/10] LIMPEZA DE ARQUIVOS TEMPORARIOS                    |" 
    wh "+----------------------------------------------------------+" 

    Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$env:SystemRoot\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

    wh "  [OK] Arquivos temporarios limpos." -ForegroundColor Green
}


function Limpar-Lixeira {

    wh ""
    wh "+----------------------------------------------------------+" 
    wh "| [2/10] LIMPEZA DA LIXEIRA                                 |" 
    wh "+----------------------------------------------------------+" 

    Clear-RecycleBin -Force -ErrorAction SilentlyContinue

    wh "  [OK] Lixeira limpa." -ForegroundColor Green
}


function Limpar-CacheNavegadores {

    wh ""
    wh "+----------------------------------------------------------+" 
    wh "| [3/10] LIMPEZA DE CACHE DOS NAVEGADORES                   |" 
    wh "+----------------------------------------------------------+" 

    $browsers = @("chrome", "firefox", "edge")

    foreach ($browser in $browsers) {

        switch ($browser) {

            "chrome" {

                $chromePath = "$env:LOCALAPPDATA\Google\Chrome\User Data\Default"

                if (Test-Path $chromePath) {
                    Remove-Item -Path "$chromePath\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
                    wh "  [OK] Cache do Google Chrome limpo." -ForegroundColor Green
                }
            }

            "firefox" {

                $firefoxPath = "$env:APPDATA\Mozilla\Firefox\Profiles"

                if (Test-Path $firefoxPath) {

                    Get-ChildItem -Path $firefoxPath | ForEach-Object {
                        Remove-Item -Path "$($_.FullName)\cache2\*" -Recurse -Force -ErrorAction SilentlyContinue
                    }

                    wh "  [OK] Cache do Mozilla Firefox limpo." -ForegroundColor Green
                }
            }

            "edge" {

                $edgePath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default"

                if (Test-Path $edgePath) {
                    Remove-Item -Path "$edgePath\Cache\*" -Recurse -Force -ErrorAction SilentlyContinue
                    wh "  [OK] Cache do Microsoft Edge limpo." -ForegroundColor Green
                }
            }
        }
    }

    wh "  [OK] Limpeza de cache concluida." -ForegroundColor Green
}


function Limpar-Windows {

    wh ""
    wh "+----------------------------------------------------------+" 
    wh "| [4/10] REPARANDO COMPONENTES DO WINDOWS                   |" 
    wh "+----------------------------------------------------------+" 

    Dism /Online /Cleanup-Image /StartComponentCleanup

    wh "  [OK] Etapa concluida." -ForegroundColor Green
}


function Reparar-Windows {

    wh ""
    wh "+----------------------------------------------------------+" 
    wh "| [5/10] REPARANDO ARQUIVOS DO SISTEMA                      |" 
    wh "+----------------------------------------------------------+" 

    Dism /Online /Cleanup-Image /RestoreHealth

    sfc /scannow

    wh "  [OK] Verificacao do sistema concluida." -ForegroundColor Green
}


function Manutencao-Rede {

    wh ""
    wh "+----------------------------------------------------------+" 
    wh "| [6/10] VERIFICANDO E REPARANDO A REDE                     |" 
    wh "+----------------------------------------------------------+" 

    ipconfig /flushdns

    wh "  [OK] Cache DNS limpo." -ForegroundColor Green
}


function Reiniciar-Spooler {

    wh ""
    wh "+----------------------------------------------------------+" 
    wh "| [7/10] REINICIANDO SERVICO DE IMPRESSAO                   |" 
    wh "+----------------------------------------------------------+" 

    Restart-Service -Name "Spooler" -Force

    wh "  [OK] Spooler reiniciado." -ForegroundColor Green
}


function Otimizar-Disco {

    wh ""
    wh "+----------------------------------------------------------+" 
    wh "| [8/10] OTIMIZANDO O DISCO                                 |" 
    wh "+----------------------------------------------------------+" 

    Optimize-Volume -DriveLetter C

    wh "  [OK] Otimizacao do disco concluida." -ForegroundColor Green
}


function Limpar-ArquivosLogs {

    wh ""
    wh "+----------------------------------------------------------+" 
    wh "| [9/10] LIMPEZA DE ARQUIVOS DE LOG                         |" 
    wh "+----------------------------------------------------------+" 

    Remove-Item -Path "$env:SystemRoot\Logs\*" -Recurse -Force -ErrorAction SilentlyContinue

    wh "  [OK] Arquivos de log limpos." -ForegroundColor Green
}

function Desativar_Servicos {
    wh ""
    wh "+----------------------------------------------------------+"
    wh "| [10/10] DESATIVANDO SERVICOS DESNECESSARIOS               |"
    wh "+----------------------------------------------------------+"

        $servicos = @(
            "XboxGipSvc",
            "XblAuthManager",
            "XblGameSave",
            "XboxNetApiSvc",
            "Fax",
            "RetailDemo",
            "MapsBroker",
            "WMPNetworkSvc",
            "wisvc"

        )

    foreach ($servico in $servicos) {
        Stop-Service -Name $servico -Force
        Set-Service -Name $servico -StartupType Disabled
    }

    wh "  [OK] Arquivos de log limpos." -ForegroundColor Green
}


function Manutencao-Completa {

    Limpar-ArquivosTemporarios
    Limpar-Lixeira
    Limpar-CacheNavegadores
    Limpar-Windows
    Reparar-Windows
    Manutencao-Rede
    Reiniciar-Spooler
    Otimizar-Disco
    Limpar-ArquivosLogs
    Desativar_Servicos
}



# Função principal do script

function Main {

    wh ""
    wh "============================================================" -BackgroundColor DarkCyan
    wh "                  MANUTENCAO DO COMPUTADOR                  " -BackgroundColor DarkCyan
    wh "============================================================" -BackgroundColor DarkCyan
    wh ""
    wh "  Projeto desenvolvido por: Miguel Oliveira"
    wh ""
    wh "Feche todos os programas antes de iniciar a manutencao." -ForegroundColor Red
    wh ""
    pause
    wh ""
    wh "  Iniciando processo de manutencao..."
    wh ""

    Manutencao-Completa

    wh ""
    wh "  MANUTENCAO CONCLUIDA!! " -ForegroundColor Green

    wh ""
    wh "  Necessario desligar o computador e ligar novamente"
    wh "  para aplicar todas as alteracoes."
    wh ""

    $resp = Read-Host "  Deseja desligar o computador agora? (S/N)"

    if ($resp -eq "S" -or $resp -eq "s") {

        wh ""
        wh "  O computador sera desligado em 10 segundos..." -ForegroundColor Yellow
        wh "  Salve seus arquivos antes do desligamento." -ForegroundColor Yellow
        wh ""

        Start-Sleep -Seconds 10
        shutdown.exe /s /f /t 0

    } else {

        wh ""
        wh "  O computador pode ser desligado manualmente mais tarde." -ForegroundColor Yellow
        wh ""

        pause
    }
}


# Verifica se o PowerShell esta sendo executado como Administrador

$principal = New-Object Security.Principal.WindowsPrincipal(
    [Security.Principal.WindowsIdentity]::GetCurrent()
)

if (-not $principal.IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)) {

    # Reabre o proprio script como Administrador

    Start-Process powershell.exe `
        -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" `
        -Verb RunAs

    # Encerra a execucao atual

    exit
}



# Executando o script
Main