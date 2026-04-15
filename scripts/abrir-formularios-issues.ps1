<#
.SYNOPSIS
  Abre no navegador a página para criar Issue (escolha de formulários).
#>
$ErrorActionPreference = "Stop"
$url = git remote get-url origin 2>$null
if (-not $url) { throw "Sem remote origin." }
if ($url -match "github\.com[:/](.+?)/(.+?)(?:\.git)?/?$") {
  $issues = "https://github.com/$($Matches[1])/$($Matches[2])/issues/new/choose"
  Start-Process $issues
  return
}
throw "Remote não é GitHub: $url"
