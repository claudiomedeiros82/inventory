# /commit — Commit semântico em lote com release opcional

## Etapa 1 — Levantamento das alterações

Execute `git status --short` e `git diff HEAD` para ver todas as mudanças pendentes (incluindo untracked).

Analise cada arquivo modificado/criado/deletado e classifique pelo tipo semântico:

| Tipo | Quando usar |
|------|-------------|
| `feat` | Nova funcionalidade visível ao usuário |
| `fix` | Correção de bug |
| `refactor` | Reestruturação sem mudança de comportamento |
| `perf` | Melhoria de performance |
| `test` | Adição ou ajuste de testes |
| `docs` | Documentação |
| `style` | Formatação, espaços, ponto-e-vírgula |
| `chore` | Build, dependências, configuração, CI |
| `revert` | Reversão de commit anterior |

Um arquivo pode pertencer a mais de um commit se as mudanças forem de natureza diferente.
Prefira granularidade: separe `feat` de `fix` mesmo que estejam no mesmo arquivo.

## Etapa 2 — Montar o plano de commits

Monte uma lista numerada com TODOS os commits planejados, no formato:

```
[1] feat: descrição curta e objetiva
    Arquivos: lib/features/x/screen.dart, lib/core/router.dart

[2] fix: descrição curta e objetiva
    Arquivos: lib/main.dart

[3] chore: atualiza dependências
    Arquivos: pubspec.yaml, pubspec.lock
```

Exiba a lista completa antes de fazer qualquer commit.
Não inclua neste plano o commit de versão (release) — ele vem depois, separado.

## Etapa 3 — Confirmação e execução

Após exibir o plano, pergunte UMA ÚNICA VEZ:
> "Confirma o plano acima? Vou executar todos os commits em sequência sem pedir confirmação individual."

Após a confirmação, execute cada commit da lista em sequência: `git add` nos arquivos listados e `git commit -m "..."`. Exiba o resultado de cada commit conforme avança.

Se um commit falhar, pare e informe o erro antes de continuar.

## Etapa 4 — Release (versão)

Após todos os commits serem feitos, pergunte:
> "Deseja criar um commit de release (bump de versão)?"

### Se sim — calcular a nova versão

1. Execute `git log --oneline` e identifique o último commit com prefixo `release:` para determinar o ponto de partida.
   - Se não existir nenhum release anterior, use a versão atual do `pubspec.yaml` como ponto de partida.

2. Liste todos os commits desde o último release (inclusive os que acabaram de ser feitos).

3. Processe cada commit **um a um, na ordem cronológica**, atualizando a versão corrente a cada passo:
   - `fix:` → patch++
   - `feat:` → minor++, patch=0  ← **reseta o patch para 0; fixes posteriores voltam a incrementar patch do novo minor**
   - qualquer tipo com `!` (ex: `feat!:`) ou com `BREAKING CHANGE` no corpo → major++, minor=0, patch=0
   - outros tipos (`docs`, `chore`, `style`, `refactor`, `test`, `perf`, `revert`) → sem alteração

   **IMPORTANTE:** não agrupe nem some os tipos. Cada commit é processado individualmente sobre o resultado do anterior.
   Exemplo correto partindo de `1.0.0`:
   - fix → `1.0.1`
   - feat → `1.1.0`  (patch zerou!)
   - feat → `1.2.0`  (patch zerou de novo!)
   - fix → `1.2.1`  (patch do novo minor)
   Resultado final: `1.2.1` — NÃO `1.2.2` nem `1.1.2`.

4. Exiba o cálculo passo a passo (uma linha por commit relevante) para o usuário ver a progressão e anuncie a versão final.

### Gerar o commit de versão

Edite **apenas** as duas linhas de versão em `pubspec.yaml`:
- `version: X.Y.Z`
- `msix_version: X.Y.Z.0`

Monte uma mensagem de release resumindo todas as alterações desde o último release em linguagem natural e concisa. Exemplo:
> `release: 1.2.3 - adiciona busca por CNPJ, corrige filtro de datas, atualiza dependências`

Mostre o diff exato (apenas essas duas linhas) e a mensagem de commit, depois pergunte:
> "Confirma o bump de versão de X.Y.Z-atual para X.Y.Z-novo?"

Após confirmação, aplique as edições e execute:
```bash
git add pubspec.yaml
git commit -m "release: X.Y.Z - resumo das alterações"
```

Não altere nenhuma outra linha do `pubspec.yaml`.
