# Garante que gh esta no PATH nesta sessao (VS Code/Cursor nem sempre herda o PATH do utilizador).
if (Get-Command gh -ErrorAction SilentlyContinue) { return }
$dirs = @(
  "$env:LOCALAPPDATA\Programs\gh",
  "$env:ProgramFiles\GitHub CLI",
  "${env:ProgramFiles(x86)}\GitHub CLI"
)
foreach ($dir in $dirs) {
  $exe = Join-Path $dir "gh.exe"
  if (Test-Path -LiteralPath $exe) {
    $env:Path = "$dir;$env:Path"
    return
  }
}
