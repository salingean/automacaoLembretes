# Automação de Lembretes do Contas a Pagar (TOTVS Protheus)

Sistema desenvolvido em **AdvPL / TLPP** para TOTVS Protheus para monitoramento, auditoria e notificação automatizada de despesas e vencimentos no módulo Financeiro (SIGAFIN - SE2).

---

## 🚀 Componentes do Projeto

| Arquivo | Linguagem | Função / Descrição |
| :--- | :--- | :--- |
| `src/updlemb.prw` | AdvPL | **Compatibilizador / Dicionário de Dados**: Criação e atualização da tabela customizada `ZZL` (Regras de Lembretes Financeiros) via SX3/SIX/SX2. |
| `src/U_FinCfgLemb.prw` | AdvPL | **Interface / CRUD (AxCadastro)**: Rotina visual de cadastro para inclusão, alteração e exclusão de regras de lembretes na tabela `ZZL`. |
| `src/U_FinLembPagar.tlpp` | TLPP | **Job de Processamento & Notificação**: Varredura das regras ativas, cruzamento com pendências no Contas a Pagar (`SE2`) e envio de e-mail consolidado em HTML responsivo. |

---

## 🛠️ Requisitos e Configurações

### Parâmetros Protheus (SX6)
Para o envio de e-mails via classe nativa `TMailManager`, utilize os parâmetros padrão de e-mail do Protheus:
* `MV_RELSERV`: Servidor SMTP e porta (ex: `smtp.office365.com:587`).
* `MV_RELACNT`: Conta de e-mail remetente.
* `MV_RELPSW`: Senha ou Token de aplicativo da conta remetente.
* `MV_RELPORT`: Porta SMTP.

---

## 📋 Como Utilizar

1. **Compilação**:
   * Compile os arquivos da pasta `src/` no ambiente do seu Protheus (RPO).

2. **Criação da Tabela `ZZL`**:
   * Execute a função `U_UPDZZL()` para criar a tabela e seus índices no dicionário de dados.

3. **Cadastro de Regras**:
   * Adicione a rotina `U_FinCfgLemb()` no menu do módulo Financeiro para gerenciar os lembretes por filial, fornecedor, vencimento e e-mail.

4. **Agendamento (Schedule)**:
   * Configure no Protheus Schedule a rotina `U_FinLembPagar()` para execução periódica.
