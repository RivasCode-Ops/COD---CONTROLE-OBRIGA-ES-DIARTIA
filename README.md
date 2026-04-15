# Rivaldo Organização

[![Validar parametros](https://github.com/RivasCode-Ops/COD---CONTROLE-OBRIGA-ES-DIARTIA/actions/workflows/validar-parametros.yml/badge.svg)](https://github.com/RivasCode-Ops/COD---CONTROLE-OBRIGA-ES-DIARTIA/actions/workflows/validar-parametros.yml)
[![Issues](https://img.shields.io/github/issues/RivasCode-Ops/COD---CONTROLE-OBRIGA-ES-DIARTIA?color=0d9488)](https://github.com/RivasCode-Ops/COD---CONTROLE-OBRIGA-ES-DIARTIA/issues)

Sistema simples de gestão de tarefas pessoais e da empresa usando [GitHub Issues](https://github.com/RivasCode-Ops/COD---CONTROLE-OBRIGA-ES-DIARTIA/issues) + GitHub Projects.

## Site (aparência)

A pasta [`docs/`](docs/) é uma **página estática** com visão geral, cartões por tipo de tarefa e atalhos. Para ver no PC, após clonar:

```powershell
.\scripts\abrir-docs-local.ps1
```

Para publicar na web, no repositório: **Settings → Pages → Build and deployment**.

**Opção A — GitHub Actions (recomendado com Actions já autorizadas):** em **Source**, escolha **GitHub Actions**. O workflow [`.github/workflows/deploy-pages.yml`](.github/workflows/deploy-pages.yml) publica a pasta `docs/` a cada push em `main` que altere `docs/` (ou manualmente em **Actions → Publicar GitHub Pages → Run workflow**). O URL aparece no resumo do job e costuma ser `https://rivascode-ops.github.io/COD---CONTROLE-OBRIGA-ES-DIARTIA/`.

**Opção B — Branch:** Source **Deploy from a branch**, branch **main**, pasta **`/docs`**. A primeira publicação pode levar alguns minutos.

[![Pages](https://github.com/RivasCode-Ops/COD---CONTROLE-OBRIGA-ES-DIARTIA/actions/workflows/deploy-pages.yml/badge.svg)](https://github.com/RivasCode-Ops/COD---CONTROLE-OBRIGA-ES-DIARTIA/actions/workflows/deploy-pages.yml)

### Se o site der **404**

1. **Copie o URL que o próprio GitHub mostra** em **Settings → Pages** (área *Your site is live at* / *Visit site*). Não adivinhe o endereço; org/repo com maiúsculas/minúsculas usam sempre `https://<org em minúsculas>.github.io/<nome-do-repo>/`.
2. **Opção A (Actions):** em Pages, **Source** tem de ser **GitHub Actions** (não “Deploy from a branch”). Só depois disso o job **Publicar GitHub Pages** consegue publicar. Em **Actions**, abra o último run: se estiver vermelho, leia o erro (muito comum: fonte ainda em *branch*).
3. **Opção B (branch):** Source **Deploy from a branch** → branch **main** → pasta **`/docs`** (não use `/(root)` se o `index.html` estiver dentro de `docs/`).
4. **Repositório privado:** em contas/planos gratuitos o Pages **público** a partir de repo privado pode estar indisponível ou exigir plano pago; nesse caso o browser mostra **404** para quem não tem acesso. Torne o repositório **público** ou confirme na documentação atual da GitHub o que o teu plano permite.
5. **Primeiro deploy com Actions:** em **Settings → Environments → `github-pages`**, veja se há **Deployment protection** a pedir aprovação manual no primeiro run.
6. Foi adicionado `docs/.nojekyll` para o GitHub **não tratar o site como Jekyll** (evita 404 por ficheiros ignorados).

## Estrutura

As tarefas são abertas como Issues usando formulários prontos:

- Tarefa pessoal
- Tarefa da empresa
- Atendimento ao cliente
- Ideia ou melhoria

## Parametrização (fonte única)

Tudo o que era “sugestão fixa” de **labels**, **prefixos de título** (ligação ao workflow) e **nomes de colunas** do quadro está em [`config/parametros.json`](config/parametros.json):

| Chave | Função |
| --- | --- |
| `labels` | Lista de labels (`nome`, `cor` em hex **sem** `#`, `descricao`) — usada por `setup-labels.ps1`. |
| `mapeamentoTituloLabel` | Para cada `prefixo` (ex. `[PESSOAL]`) e `label` correspondente — usada pelo workflow **Labels a partir do título**. |
| `colunasQuadroSugeridas` | Referência para montar o GitHub Project (só documentação; o GitHub não lê este JSON automaticamente). |

1. Edite `config/parametros.json` como quiser.
2. Rode `.\scripts\validar-parametros.ps1` (opcional mas recomendado) e `.\scripts\verificar-formularios-issues.ps1` para cruzar com os YAML dos formulários.
3. Rode `.\scripts\setup-labels.ps1` para criar/atualizar labels no remoto (labels já existentes são ignoradas na criação; para **mudar cor/descrição** use a UI do GitHub ou `gh label edit`).
4. Faça **commit e push** do JSON para o Actions aplicar o novo mapeamento de títulos.

**Formulários de Issue** (`.github/ISSUE_TEMPLATE/*.yml`): continuam em YAML — se mudar `prefixo` ou o nome da label principal de um tipo de tarefa, ajuste manualmente o `title:` e `labels:` nesses ficheiros para bater com `parametros.json`.

Os formulários aplicam a label principal; prioridade e área costumam ser ajustadas na Issue após abrir (veja a dica no final de cada formulário).

## Utilidades e automação

### Workflow no GitHub (sem configurar segredo)

O arquivo [`.github/workflows/issue-label-from-title.yml`](.github/workflows/issue-label-from-title.yml) roda quando uma Issue é **aberta ou editada**: lê `config/parametros.json` e, se o título começar com um dos `prefixo` definidos em `mapeamentoTituloLabel`, aplica a `label` correspondente **se ainda não estiver** na Issue. Útil para Issues criadas fora do formulário ou se faltar label. As labels precisam existir no repositório (use o script abaixo).

**Atenção:** Actions precisam estar permitidas no repositório (**Settings → Actions → General**).

O workflow [`.github/workflows/validar-parametros.yml`](.github/workflows/validar-parametros.yml) corre em **push/PR** quando mudam `parametros.json`, formulários, estes workflows ou os scripts de validação, e falha o CI se o JSON estiver inconsistente.

### Scripts no seu computador (PowerShell)

Requisito: [GitHub CLI](https://cli.github.com/) (`gh`) instalado e `gh auth login`.

| Script | Função |
| --- | --- |
| [`scripts/validar-parametros.ps1`](scripts/validar-parametros.ps1) | Valida o JSON e se cada `label` do mapeamento existe em `labels`. |
| [`scripts/verificar-formularios-issues.ps1`](scripts/verificar-formularios-issues.ps1) | Garante que cada formulário em `ISSUE_TEMPLATE` tem `title`/`labels` alinhados ao mapeamento (e que não há prefixo órfão). |
| [`scripts/setup-labels.ps1`](scripts/setup-labels.ps1) | Cria no remoto `origin` todas as entradas de `labels` em `parametros.json` (ignora as que já existem). |
| [`scripts/abrir-formularios-issues.ps1`](scripts/abrir-formularios-issues.ps1) | Abre o navegador em **Nova issue → escolher formulário**. |
| [`scripts/abrir-docs-local.ps1`](scripts/abrir-docs-local.ps1) | Abre `docs/index.html` no navegador (pré-visualização do site). |

Exemplo (na pasta do clone):

```powershell
cd caminho\do\seu\clone\COD---CONTROLE-OBRIGA-ES-DIARTIA
.\scripts\validar-parametros.ps1
.\scripts\verificar-formularios-issues.ps1
.\scripts\setup-labels.ps1
.\scripts\abrir-formularios-issues.ps1
.\scripts\abrir-docs-local.ps1
```

### O que ainda é manual (no GitHub)

- Criar o **Project** e as colunas (use como guia a lista `colunasQuadroSugeridas` em `parametros.json`).
- Opcional: regras de automação do Project (mover cartão ao fechar Issue, etc.), conforme a versão do Projects que você usar.

## Fluxo de uso

1. Toda nova demanda vira uma Issue.
2. A Issue recebe label e prioridade.
3. A tarefa entra no GitHub Project.
4. O quadro deve ter colunas alinhadas a `colunasQuadroSugeridas` em [`config/parametros.json`](config/parametros.json) (editável).
5. Ao finalizar, fechar a Issue.

## Regra prática

- Tudo que surgir vai para Inbox.
- No começo do dia, escolher até 3 prioridades principais.
- No fim da semana, revisar e limpar o quadro.

## Discussões (opcional)

O controle de tarefas deste sistema é **Issues + Projects**. O caminho `/discussions` no GitHub **só existe** depois que **Discussions** é ativado; antes disso, esse URL retorna *Page not found*.

**Para habilitar Discussions** (quem tem permissão de administrador no repositório): abra [Settings → General](https://github.com/RivasCode-Ops/COD---CONTROLE-OBRIGA-ES-DIARTIA/settings), role até **Features**, marque **Discussions** e salve. Aí a aba **Discussions** aparece no topo do repositório.

Enquanto não ativar, use **Issues** (incluindo o formulário *Ideia ou melhoria* para sugestões de processo) e o **Project Board**.

## Objetivo

Centralizar vida pessoal e empresa em um sistema simples, visual e fácil de manter.
