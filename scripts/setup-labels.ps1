<#
.SYNOPSIS
  Cria no GitHub as labels definidas em config/parametros.json (idempotente).
.REQUIRES
  GitHub CLI (gh) instalado e autenticado: https://cli.github.com/
#>
$ErrorActionPreference = "Stop"

function Get-RepoFromGit {
  $url = git remote get-url origin 2>$null
  if (-not $url) { throw "Defina o remote 'origin' ou rode dentro do clone do repositório." }
  if ($url -match "github\.com[:/](.+?)/(.+?)(?:\.git)?/?$") {
    return @{ Owner = $Matches[1]; Repo = $Matches[2] }
  }
  throw "Não foi possível interpretar owner/repo a partir de: $url"
}

function Test-Gh {
  if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    throw "Instale o GitHub CLI (gh) e faça login: gh auth login"
  }
}

Test-Gh
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$configPath = Join-Path $repoRoot "config\parametros.json"
if (-not (Test-Path $configPath)) { throw "Falta o ficheiro de configuração: $configPath" }

& (Join-Path $PSScriptRoot "validar-parametros.ps1")

$p = Get-Content $configPath -Raw -Encoding UTF8 | ConvertFrom-Json
$r = Get-RepoFromGit
$repo = "$($r.Owner)/$($r.Repo)"

Write-Host "Repositório: $repo" -ForegroundColor Cyan
Write-Host "Origem das labels: $configPath" -ForegroundColor DarkGray
foreach ($l in $p.labels) {
  $err = gh label create $l.nome --repo $repo --color $l.cor --description $l.descricao 2>&1
  if ($LASTEXITCODE -eq 0) {
    Write-Host "  criada: $($l.nome)" -ForegroundColor Green
  }
  elseif ("$err" -match "already been taken|name has already") {
    Write-Host "  já existe: $($l.nome)" -ForegroundColor DarkGray
  }
  else {
    Write-Warning "  $($l.nome): $err"
  }
}
Write-Host "Concluído." -ForegroundColor Cyan
