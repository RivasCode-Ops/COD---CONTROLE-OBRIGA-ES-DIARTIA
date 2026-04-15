<#
.SYNOPSIS
  Abre docs/index.html no navegador (pré-visualização local do site).
#>
$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$html = Join-Path $repoRoot "docs\index.html"
if (-not (Test-Path $html)) { throw "Falta: $html" }
Start-Process $html
