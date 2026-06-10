# Gerador de Usuários, Grupos e Conectores TSplus

## Descrição

O **Gerador de Usuários, Grupos e Conectores TSplus** é uma ferramenta Batch para automação de tarefas administrativas em ambientes Windows com TSplus.

O script permite criar usuários locais, associá-los a grupos, configurar permissões em pastas e gerar automaticamente arquivos de conexão (.connect) para acesso remoto via TSplus.

Seu objetivo é reduzir o tempo de provisionamento de novos usuários e padronizar o processo de criação de acessos.

---

## Principais Funcionalidades

### Criação de Usuário Individual

Permite:

- Criar usuário local do Windows
- Definir senha
- Configurar senha para nunca expirar
- Associar usuário a grupo
- Vincular grupo a pasta
- Gerar conectores TSplus automaticamente

---

### Criação de Múltiplos Usuários

Criação em lote utilizando sequência numérica.

Exemplo:

```text
Base usuário: cliente
Quantidade: 5

Resultado:

cliente01
cliente02
cliente03
cliente04
cliente05
