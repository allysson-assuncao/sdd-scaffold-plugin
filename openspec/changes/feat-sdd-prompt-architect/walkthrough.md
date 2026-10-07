# Walkthrough: `feat-sdd-prompt-architect`

Registro cumulativo da execução do plano de implementação da feature `feat-sdd-prompt-architect`.

---

## Fase 0 — Proposta SDD (Spec Only)

### Arquivos Criados / Modificados
- `openspec/changes/feat-sdd-prompt-architect/proposal.md` — Proposta formal completa com motivação, escopo, segurança defensiva, estratégia de testes e critérios Given-When-Then.
- `openspec/changes/feat-sdd-prompt-architect/tasks.md` — Checklist de tarefas atômicas espelhando as Fases 1 a 4.
- `openspec/changes/feat-sdd-prompt-architect/specs/agent-sdd-prompt-architect.md` — Delta spec detalhando a especificação do subagente `sdd-prompt-architect`.
- `openspec/changes/feat-sdd-prompt-architect/specs/prompt-engineering-workflow.md` — Delta spec do workflow de engenharia de prompt e taxonomia de templates.
- `openspec/changes/feat-sdd-prompt-architect/walkthrough.md` — Este artefato de rastreamento de progresso.

### Resultados de Verificação e Auditoria
- **Skill `sdd-spec-validate` executada:** Subagente `sdd-spec-auditor` invocado para auditar `proposal.md` e `tasks.md`.
- **Veredicto da Auditoria:** **Approved** (Aprovado sem ressalvas).
  - Todas as seções obrigatórias preenchidas.
  - 6 critérios Given-When-Then validados.
  - Seções de segurança defensiva e testes validadas.
  - Nenhuma ação corretiva pendente.

### Handoff para a Fase 1
- Aprovada a Fase 0, a Fase 1 criará a skill `sdd-prompt-craft` e a cópia do guia em `skills/sdd-prompt-craft/resources/prompt-guide.md` com a Seção 4.

---

## Fase 1 — Skill `sdd-prompt-craft`

### Arquivos Criados / Modificados
- `skills/sdd-prompt-craft/resources/prompt-guide.md` — Guia de prompts copiado de `Universal Prompt Guide & Templates.md`, caminho do artefato do Template 3 atualizado para `openspec/changes/<change-id>/walkthrough.md`, e Seção 4 (Template Selection & File Naming) adicionada ao final.
- `skills/sdd-prompt-craft/SKILL.md` — Nova skill com frontmatter válido (`name`, `description`), contendo propósito, passos de coleta de intenção, delegação ao subagente `sdd-prompt-architect`, relato de link clicável e regras.
- `openspec/changes/feat-sdd-prompt-architect/tasks.md` — Atualizado com as tarefas da Fase 1 marcadas como completas.

### Resultados de Verificação
- `skills/sdd-prompt-craft/SKILL.md`: 28 linhas (< 500 linhas de limite).
- Frontmatter verificado com `name: sdd-prompt-craft` e `description`.
- `prompt-guide.md`: contém os 4 templates originais e a Seção 4 adicionada.

### Handoff para a Fase 2
- A Fase 2 criará a definição do subagente `agents/sdd-prompt-architect.md` com modelo `flash`, sandbox policy e sem `run_command`.

---

## Fase 2 — Subagente `sdd-prompt-architect`

### Arquivos Criados / Modificados
- `agents/sdd-prompt-architect.md` — Definição do subagente leve com modelo `flash`, sandbox policy, ferramentas de leitura + escrita scoped (`write_to_file`) + delegação (`invoke_subagent`), sem `run_command`. Instruções completas para inspeção de repositório, seleção de template da Seção 4, preenchimento declarativo, acúmulo de walkthrough e resposta com link clicável.
- `openspec/changes/feat-sdd-prompt-architect/tasks.md` — Atualizado com as tarefas da Fase 2 marcadas como completas.

### Resultados de Verificação
- Chaves do frontmatter comparadas e validadas contra `agents/sdd-code-explorer.md`.
- `run_command` estritamente ausente da lista de ferramentas.
- `subagent: true`, `mainAgent: false`, `model: flash`, `commandExecutionPolicy: sandbox`.

### Handoff para a Fase 3
- A Fase 3 abordará o endurecimento do escopo de escrita (`write-scope hardening`) avaliando `hooks.json`.

---

## Fase 3 — Endurecimento do Escopo de Escrita (Hooks)

### Arquivos Criados / Modificados
- `hooks.json` — Adicionado recipe stub desabilitado em `PreToolUse` documentando o hook de restrição de escrita de prompt (`scope-prompt-writes.sh`).
- `openspec/changes/feat-sdd-prompt-architect/tasks.md` — Atualizado com as tarefas da Fase 3 marcadas como completas.

### Análise de Limitações e Decisão de Design
- A arquitetura de hooks do Antigravity executa comandos externos via matcher de ferramentas. Como o contexto do agente chamador (`caller subagent`) não é isolado de forma padronizada em variáveis de ambiente nativas globais sem sidecar, a ativação de um bloqueio incondicional de escrita quebraria operações legítimas de outros agentes e skills.
- Conforme instruído no plano e na decisão de design, evitou-se a ativação de um bloqueio global indiscriminado; em vez disso, adicionou-se a receita documentada no `hooks.json` e a restrição de escopo de escrita é garantida de forma rígida através das instruções de sistema (`Hard limits`) no arquivo do agente `sdd-prompt-architect.md` e na ausência da ferramenta `run_command`.

### Resultados de Verificação
- `hooks.json` validado via `ConvertFrom-Json` com sintaxe JSON 100% íntegra.
- Hooks pré-existentes preservados intactos.

### Handoff para a Fase 4
- A Fase 4 atualizará `validate-v3.sh` e `plugin.json` para registro e execução da suíte completa de validação.

---

## Fase 4 — Registro e Validação

### Arquivos Criados / Modificados
- `validate-v3.sh` — Atualizados loops de frontmatter YAML, contagem de linhas de skills (< 500), inspeção de subagentes (adicionando `sdd-prompt-architect`), checagem de existência de recursos (incluindo `skills/sdd-prompt-craft/resources/prompt-guide.md`) e normalizado o caminho relativo de checagem JSON para compatibilidade POSIX/Windows.
- `plugin.json` — Estendida a descrição para incluir `sdd-prompt-craft` e o subagente `sdd-prompt-architect`.
- `openspec/changes/feat-sdd-prompt-architect/tasks.md` — Todas as tarefas das Fases 1 a 4 e Review Gate marcadas como concluídas (`[x]`).

### Resultados de Verificação
- Suíte `bash validate-v3.sh` executada com sucesso total:
  ```
  ========================================
   Results: 68/68 checks passed
   🎉 ALL CHECKS PASSED — v3 is valid.
  ========================================
  ```
- 100% de taxa de aprovação em:
  1. Frontmatter YAML de todas as skills.
  2. Contagem de linhas (< 500 por skill, <= 55 em AGENTS.md).
  3. Configurações de subagentes (flash, sandbox, mainAgent false, subagent true).
  4. Validade de JSON (`plugin.json` e `hooks.json`).
  5. Regras Hard Stop e Progressive Disclosure.
  6. Seções de segurança defensiva e testes no template.
  7. Existência de todos os recursos.

---

## Resumo Consolidado da Execução

| Fase | Componente | Ações Principais | Status |
|------|------------|------------------|--------|
| **Fase 0** | SDD Spec | Proposta formal em `openspec/changes/feat-sdd-prompt-architect/`, 2 delta specs, checklist em `tasks.md`, auditoria `sdd-spec-auditor` (Approved). | Concluída |
| **Fase 1** | Skill `sdd-prompt-craft` | Guia copiado em `resources/prompt-guide.md` com Seção 4 adicionada; `SKILL.md` criado com delegação e regras. | Concluída |
| **Fase 2** | Subagente `sdd-prompt-architect` | Definido em `agents/sdd-prompt-architect.md` com modelo `flash`, sandbox, ferramentas mínimas sem `run_command`. | Concluída |
| **Fase 3** | Write-scope Hardening | Recipe stub adicionado em `hooks.json`, limites documentados e garantidos no prompt do agente. | Concluída |
| **Fase 4** | Registro & Validação | `validate-v3.sh` e `plugin.json` atualizados; 68/68 testes aprovados. | Concluída |

---

## Procedimentos de Validação Manual Recomendados

1. **Cenário 1 — Ideia Ambígua / Descoberta:**
   - Ativar a skill `sdd-prompt-craft` solicitando uma demanda vaga (ex: *"quero explorar uma ideia de refatoração no módulo de autenticação"*).
   - O subagente deve selecionar o **Template 1** e gerar o arquivo `prompt-discovery.md` na raiz do projeto com modo `/grill-me`.
   - Nenhum agente executor deve ser iniciado automaticamente.

2. **Cenário 2 — Execução de Fase em Mudança Aprovada:**
   - Solicitar a criação do prompt para a próxima fase de uma mudança ativa com `tasks.md`.
   - O subagente deve selecionar o **Template 3** e gerar `prompt-<change-id>-phase-<N>.md` referenciando explicitamente `openspec/changes/<change-id>/walkthrough.md`.

3. **Cenário 3 — Garantia de Não-Disparo:**
   - Confirmar que o subagente apenas grava o arquivo na raiz do repositório, exibe o link clicável em pt-BR e encerra sem disparar agentes pesados de execução.




