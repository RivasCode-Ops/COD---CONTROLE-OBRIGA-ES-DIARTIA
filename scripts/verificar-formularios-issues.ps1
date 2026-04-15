<#
.SYNOPSIS
  Confere se .github/ISSUE_TEMPLATE/*.yml (exceto config) batem com mapeamentoTituloLabel e labels em config/parametros.json.
#>
$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
& (Join-Path $PSScriptRoot "validar-parametros.ps1")

$p = Get-Content (Join-Path $repoRoot "config\parametros.json") -Raw -Encoding UTF8 | ConvertFrom-Json
$tplDir = Join-Path $repoRoot ".github\ISSUE_TEMPLATE"
$usedPrefixes = @{}

Get-ChildItem $tplDir -Filter "*.yml" | Where-Object { $_.Name -ne "config.yml" } | ForEach-Object {
  $raw = Get-Content $_.FullName -Raw -Encoding UTF8
  if ($raw -notmatch '(?m)^title:\s*["''](.+)["'']') {
    throw "Ficheiro $($_.Name): em falta uma linha title: com valor entre aspas."
  }
  $tplTitle = $Matches[1].Trim()
  if ($raw -notmatch '(?m)^labels:\s*\[\s*["'']([^"'']+)["'']') {
    throw "Ficheiro $($_.Name): em falta labels: com pelo menos uma label entre aspas."
  }
  $tplLabel = $Matches[1]

  $matchM = $null
  foreach ($m in $p.mapeamentoTituloLabel) {
    if ($tplTitle.StartsWith($m.prefixo)) {
      $matchM = $m
      break
    }
  }
  if (-not $matchM) {
    throw "Ficheiro $($_.Name): título padrão '$tplTitle' não começa com nenhum prefixo de mapeamentoTituloLabel."
  }
  if ($tplLabel -ne $matchM.label) {
    throw "Ficheiro $($_.Name): labels[0] é '$tplLabel' mas o mapeamento para '$($matchM.prefixo)' exige '$($matchM.label)'."
  }
  $usedPrefixes[$matchM.prefixo] = $true
  Write-Host "  OK $($_.Name) -> $($matchM.prefixo) / $($matchM.label)" -ForegroundColor DarkGray
}

foreach ($m in $p.mapeamentoTituloLabel) {
  if (-not $usedPrefixes.ContainsKey($m.prefixo)) {
    throw "Nenhum formulário em ISSUE_TEMPLATE usa o prefixo $($m.prefixo) (mapeamento órfão)."
  }
}
Write-Host "OK: formulários alinhados com parametros.json." -ForegroundColor Green
