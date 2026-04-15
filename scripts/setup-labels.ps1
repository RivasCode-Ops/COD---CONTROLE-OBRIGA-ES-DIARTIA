<#
.SYNOPSIS
  Cria no GitHub as labels usadas pelo COD (idempotente: ignora se já existir).
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
$r = Get-RepoFromGit
$repo = "$($r.Owner)/$($r.Repo)"

$labels = @(
  @{ Name = "pessoal"; Color = "0E8A16"; Desc = "Tarefa pessoal" },
  @{ Name = "empresa"; Color = "1D76DB"; Desc = "Tarefa da empresa" },
  @{ Name = "cliente"; Color = "B60205"; Desc = "Atendimento / cliente" },
  @{ Name = "melhoria"; Color = "5319E7"; Desc = "Ideia ou melhoria" },
  @{ Name = "financeiro"; Color = "FBCA04"; Desc = "Área financeira" },
  @{ Name = "marketing"; Color = "D93F0B"; Desc = "Marketing" },
  @{ Name = "automacao"; Color = "006B75"; Desc = "Automação / ferramentas" },
  @{ Name = "urgente"; Color = "B60205"; Desc = "Prioridade máxima" },
  @{ Name = "alta-prioridade"; Color = "F9D0C4"; Desc = "Alta prioridade" },
  @{ Name = "aguardando"; Color = "FEF2C0"; Desc = "Bloqueado / esperando" },
  @{ Name = "rotina"; Color = "C2E0C6"; Desc = "Recorrente / manutenção" }
)

Write-Host "Repositório: $repo" -ForegroundColor Cyan
foreach ($l in $labels) {
  $err = gh label create $l.Name --repo $repo --color $l.Color --description $l.Desc 2>&1
  if ($LASTEXITCODE -eq 0) {
    Write-Host "  criada: $($l.Name)" -ForegroundColor Green
  }
  elseif ("$err" -match "already been taken|name has already") {
    Write-Host "  já existe: $($l.Name)" -ForegroundColor DarkGray
  }
  else {
    Write-Warning "  $($l.Name): $err"
  }
}
Write-Host "Concluído." -ForegroundColor Cyan
