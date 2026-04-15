<#
.SYNOPSIS
  Valida parametros e formularios; opcionalmente cria labels com gh e abre os formularios de issues.
.PARAMETER SemLabels
  Nao executa setup-labels.ps1 (mesmo com gh instalado).
.PARAMETER AbrirFormularios
  Abre o browser em Nova issue -> escolher formulario.
#>
param(
  [switch]$SemLabels,
  [switch]$AbrirFormularios
)

$ErrorActionPreference = "Stop"
$here = $PSScriptRoot

Write-Host "=== COD - inicio rapido ===" -ForegroundColor Cyan
& (Join-Path $here "validar-parametros.ps1")
& (Join-Path $here "verificar-formularios-issues.ps1")

if (-not $SemLabels) {
  if (Get-Command gh -ErrorAction SilentlyContinue) {
    & (Join-Path $here "setup-labels.ps1")
  }
  else {
    Write-Host "GitHub CLI (gh) nao encontrado - a saltar setup-labels. https://cli.github.com/" -ForegroundColor Yellow
  }
}

if ($AbrirFormularios) {
  & (Join-Path $here "abrir-formularios-issues.ps1")
}

Write-Host "Concluido." -ForegroundColor Green
