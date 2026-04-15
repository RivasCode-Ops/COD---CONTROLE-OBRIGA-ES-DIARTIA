# Roteiro do projeto COD

Use esta lista para **continuar** a implementação do sistema (Rivaldo Organização) sem saltar passos.

## Fase 1 — Código e remoto

- [ ] Clone atualizado: `git pull` na pasta do repositório.
- [ ] `config/parametros.json` revisto (labels, prefixos, colunas sugeridas).

## Fase 2 — Validação local

Na raiz do clone (PowerShell):

```powershell
.\scripts\validar-parametros.ps1
.\scripts\verificar-formularios-issues.ps1
```

- [ ] Ambos terminam sem erro.

## Fase 3 — Labels no GitHub

**Opção A (PC):** [GitHub CLI](https://cli.github.com/) com `gh auth login` e `.\scripts\setup-labels.ps1`.

**Opção B (sem gh):** no GitHub, **Actions → Sincronizar labels (parametros.json) → Run workflow** — cria as labels a partir de `config/parametros.json`.

- [ ] Labels criadas (script local **ou** workflow acima).

## Fase 4 — GitHub Project (manual no site)

- [ ] **Projects → New project** (board) ligado a este repositório.
- [ ] Colunas criadas alinhadas a `colunasQuadroSugeridas` em `parametros.json` (ex.: Inbox, Planejado, Em andamento, Aguardando, Concluído).
- [ ] Fluxo de trabalho: novas issues entram no projeto (por automação ou arrastar o cartão).

## Fase 5 — Automação no GitHub

- [ ] **Actions** ativas no repositório.
- [ ] Workflows **Validar parametros**, **Labels a partir do título** e **Publicar GitHub Pages** com últimos runs verdes (quando aplicável).

## Fase 6 — Site público (opcional)

- [ ] **Settings → Pages:** branch **`gh-pages`**, pasta **`/(root)`** (após o workflow **Publicar GitHub Pages** criar a branch).
- [ ] URL de `Settings → Pages` abre o site (não 404).

## Fase 7 — Uso no dia a dia

- [ ] Nova demanda → **Issues → New issue** → escolher formulário.
- [ ] Cartão no **Project**; regra: tudo começa em **Inbox**; até 3 prioridades principais por dia.
- [ ] Ao concluir → fechar Issue e mover coluna para **Concluído**.

## Atalhos úteis

| Objetivo | Comando / ação |
| --- | --- |
| Tudo de validação + labels (se tiver `gh`) | `.\scripts\inicio-rapido.ps1` |
| Só abrir formulários no browser | `.\scripts\abrir-formularios-issues.ps1` |
| Pré-visualizar o site local | `.\scripts\abrir-docs-local.ps1` |
| Documentação visual no repo | [`README.md`](README.md), pasta [`docs/`](docs/) |

---

Quando alterar **apenas** `parametros.json`: validar → (opcional `setup-labels`) → **commit e push** para o workflow de labels no título usar a nova configuração.
