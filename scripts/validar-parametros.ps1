<#
.SYNOPSIS
  Valida config/parametros.json (JSON + labels referenciadas no mapeamento).
#>
$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$configPath = Join-Path $repoRoot "config\parametros.json"
if (-not (Test-Path $configPath)) { throw "Falta: $configPath" }

$p = Get-Content $configPath -Raw -Encoding UTF8 | ConvertFrom-Json
$nomes = @{}
foreach ($l in $p.labels) {
  if ($nomes.ContainsKey($l.nome)) { throw "Label duplicada: $($l.nome)" }
  $nomes[$l.nome] = $true
}
foreach ($m in $p.mapeamentoTituloLabel) {
  if (-not $nomes.ContainsKey($m.label)) {
    throw "mapeamentoTituloLabel aponta para label inexistente: $($m.label) (prefixo $($m.prefixo))"
  }
}
Write-Host "OK: parametros.json válido." -ForegroundColor Green
