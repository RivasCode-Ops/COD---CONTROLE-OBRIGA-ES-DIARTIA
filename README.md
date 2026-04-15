# Rivaldo Organização

Sistema simples de gestão de tarefas pessoais e da empresa usando [GitHub Issues](https://github.com/RivasCode-Ops/COD---CONTROLE-OBRIGA-ES-DIARTIA/issues) + GitHub Projects.

## Estrutura

As tarefas são abertas como Issues usando formulários prontos:

- Tarefa pessoal
- Tarefa da empresa
- Atendimento ao cliente
- Ideia ou melhoria

## Labels (criar no repositório)

Crie estas labels para bater com os formulários e o fluxo:

| Label | Uso |
| --- | --- |
| `pessoal` | Tarefas pessoais (formulário aplica automaticamente) |
| `empresa` | Tarefas da empresa |
| `cliente` | Atendimento / cliente |
| `melhoria` | Ideias e melhorias |
| `financeiro` | Demandas da área financeira |
| `marketing` | Demandas de marketing |
| `automacao` | Automação ou ideias técnicas de fluxo |
| `urgente` | Prioridade máxima |
| `alta-prioridade` | Alta prioridade |
| `aguardando` | Bloqueado ou esperando retorno |
| `rotina` | Tarefas recorrentes / manutenção |

Os formulários aplicam a label principal; prioridade e área costumam ser ajustadas na Issue após abrir (veja a dica no final de cada formulário).

## Utilidades e automação

### Workflow no GitHub (sem configurar segredo)

O arquivo [`.github/workflows/issue-label-from-title.yml`](.github/workflows/issue-label-from-title.yml) roda quando uma Issue é **aberta ou editada**: se o título começar com `[PESSOAL]`, `[EMPRESA]`, `[CLIENTE]` ou `[MELHORIA]` (como nos formulários), a label correspondente é aplicada **se ainda não estiver** na Issue. Útil para Issues criadas fora do formulário ou se faltar label. As labels precisam existir no repositório (use o script abaixo).

**Atenção:** Actions precisam estar permitidas no repositório (**Settings → Actions → General**).

### Scripts no seu computador (PowerShell)

Requisito: [GitHub CLI](https://cli.github.com/) (`gh`) instalado e `gh auth login`.

| Script | Função |
| --- | --- |
| [`scripts/setup-labels.ps1`](scripts/setup-labels.ps1) | Cria todas as labels da tabela no remoto de `origin` (ignora as que já existem). |
| [`scripts/abrir-formularios-issues.ps1`](scripts/abrir-formularios-issues.ps1) | Abre o navegador em **Nova issue → escolher formulário**. |

Exemplo (na pasta do clone):

```powershell
cd caminho\do\seu\clone\COD---CONTROLE-OBRIGA-ES-DIARTIA
.\scripts\setup-labels.ps1
.\scripts\abrir-formularios-issues.ps1
```

### O que ainda é manual (no GitHub)

- Criar o **Project** e as colunas (Inbox, Planejado, …).
- Opcional: regras de automação do Project (mover cartão ao fechar Issue, etc.), conforme a versão do Projects que você usar.

## Fluxo de uso

1. Toda nova demanda vira uma Issue.
2. A Issue recebe label e prioridade.
3. A tarefa entra no GitHub Project.
4. O quadro deve ter estas colunas:
   - Inbox
   - Planejado
   - Em andamento
   - Aguardando
   - Concluído
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
