# 👥 Gerador de Usuários, Grupos e Conectores TSplus

![Windows](https://img.shields.io/badge/Windows-10%20%7C%2011%20%7C%20Server-blue)
![Batch](https://img.shields.io/badge/Linguagem-Batch-green)
![TSplus](https://img.shields.io/badge/TSplus-Automação-orange)
![Status](https://img.shields.io/badge/Status-Em%20Uso-success)

## 📋 Sobre o Projeto

O **Gerador de Usuários, Grupos e Conectores TSplus** foi desenvolvido para automatizar o processo de provisionamento de usuários em ambientes Windows com TSplus.

A ferramenta permite criar usuários individuais ou em lote, associar grupos de segurança, configurar permissões em pastas e gerar automaticamente arquivos de conexão (.connect) para acesso remoto.

O objetivo é reduzir atividades manuais, padronizar procedimentos e aumentar a produtividade da equipe de suporte e infraestrutura.

---

# 🚀 Funcionalidades

## 👤 Criação de Usuário Individual

Permite:

- Criar usuário local do Windows
- Definir senha personalizada
- Configurar senha para nunca expirar
- Associar usuário a um grupo
- Aplicar permissões em diretórios
- Gerar conectores TSplus automaticamente

---

## 👥 Criação de Usuários em Lote

Criação automática de múltiplos usuários utilizando sequência numérica.

### Exemplo

Entrada:

```text
Usuário Base: cliente
Quantidade: 5
```

Resultado:

```text
cliente01
cliente02
cliente03
cliente04
cliente05
```

O mesmo padrão é aplicado às senhas.

---

## 🔐 Associação de Usuários a Grupos

Permite:

- Associar usuários existentes
- Criar grupos automaticamente quando necessário
- Adicionar usuários aos grupos de forma automatizada

---

## 📁 Associação de Grupo a Pasta

Permite:

- Criar diretórios automaticamente
- Aplicar permissões NTFS
- Conceder acesso ao grupo informado

Utilizando:

```cmd
icacls
```

---

## 🌐 Geração de Conectores TSplus

Geração automática de arquivos:

```text
.connect
```

Compatíveis com o ambiente TSplus.

Os conectores são configurados automaticamente para os servidores definidos no script.

---

# 🖥️ Estrutura do Menu

```text
=========================================
 GERADOR DE USUÁRIOS E TSPLUS
=========================================

1 - Criar Usuário Único
2 - Criar Múltiplos Usuários
3 - Associar Usuário a Grupo
4 - Associar Grupo a Pasta
5 - Gerar Conectores TSplus
6 - Sair

=========================================
```

---

# 🔄 Fluxo de Provisionamento

```text
Criar Usuário
      ↓
Definir Senha
      ↓
Senha Nunca Expira
      ↓
Associar Grupo
      ↓
Criar Permissões
      ↓
Gerar Conectores TSplus
      ↓
Finalizado
```

---

# ⚙️ Requisitos

## Sistema Operacional

- Windows 10
- Windows 11
- Windows Server 2016
- Windows Server 2019
- Windows Server 2022

---

## Permissões

O script deve ser executado como:

```text
Administrador
```

Necessário para:

- Criação de usuários
- Criação de grupos
- Configuração de permissões
- Geração de conectores

---

## TSplus

Necessário possuir o TSplus instalado.

Local padrão utilizado pelo script:

```text
C:\Program Files (x86)\tsplus\Clients\WindowsClient
```

Arquivo necessário:

```text
ClientGenerator.exe
```

---

# 🛠️ Tecnologias Utilizadas

- Windows Batch (.BAT)
- Net User
- Net Localgroup
- WMIC
- ICACLS
- TSplus Client Generator

---

# 📂 Estrutura de Saída

Os arquivos de conexão são gerados em:

```text
C:\Users\administrator\Desktop\Novos
```

Exemplo:

```text
usuario-Web02.connect
usuario-Web03.connect
usuario-NewServer.connect
```

---

# 🌐 Servidores Configurados

Atualmente o script gera conectores para:

```text
app02.simcoinformatica.com.br
app.simcoinformatica.com.br
app03.simcoinformatica.com.br
```

---

# 🔧 Comandos Utilizados

| Função | Comando |
|----------|----------|
| Criar Usuário | net user |
| Criar Grupo | net localgroup |
| Associar Grupo | net localgroup grupo usuario /add |
| Senha Nunca Expira | wmic UserAccount |
| Criar Diretório | mkdir |
| Permissões NTFS | icacls |
| Gerar Conectores | ClientGenerator.exe |

---

# 🔒 Segurança

O script possui tratamento para caracteres especiais em senhas, reduzindo falhas comuns durante a criação de usuários.

Também automatiza a aplicação de permissões utilizando grupos, seguindo boas práticas de segurança.

---

# 📖 Exemplo de Utilização

### Criar usuário único

```text
Nome: cliente01
Senha: Cliente@123
Grupo: CLIENTES
```

Resultado:

✅ Usuário criado

✅ Grupo associado

✅ Permissões configuradas

✅ Conectores TSplus gerados

---

# ✅ Benefícios

- Redução do tempo de provisionamento
- Padronização dos acessos
- Menos erros operacionais
- Automação do ambiente TSplus
- Facilidade para equipes de suporte

---

# 🔮 Melhorias Futuras

- Exportação para Excel
- Relatórios PDF
- Logs automáticos
- Interface PowerShell
- Interface gráfica
- Integração com Active Directory
- Integração com banco de dados
- Dashboard de provisionamento

---

# 📸 Capturas de Tela

Adicione aqui imagens do menu em execução.

Exemplo:

```markdown
![Menu Principal](images/menu-principal.png)
```

---

# 🤝 Contribuições

Sugestões e melhorias são bem-vindas.

Caso encontre algum problema, abra uma Issue ou envie uma Pull Request.

---

# 📄 Licença

Este projeto é distribuído para fins de automação e administração de ambientes Windows.

---

# 👨‍💻 Autor

## Richard Tech

Automação de Processos • Infraestrutura • TSplus • Suporte Corporativo

GitHub:
https://github.com/SEU-USUARIO

LinkedIn:
https://linkedin.com/in/SEU-PERFIL

---

⭐ Se este projeto foi útil para você, considere dar uma estrela no repositório.
