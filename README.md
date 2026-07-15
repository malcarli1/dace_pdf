# Gerador de DACE Resumida em PDF com Harbour e LibHaru 📄🚀

Este projeto é uma ferramenta de alto desempenho desenvolvida em **Harbour** para a geração automática e homologada do documento **DACE Resumida** (Declaração Auxiliar de Conteúdo Eletrônica) em formato PDF. 

O sistema realiza o parsing direto do arquivo XML de distribuição da DACE, formata e mascara os dados de forma inteligente (respeitando as regras de privacidade e a LGPD) e renderiza dinamicamente o documento em milímetros (conversão direta para pontos PDF).

---

## 🌟 Principais Recursos

* **Renderização Vetorial:** Desenho preciso de tabelas, contornos e blocos cinzas de destaque usando a biblioteca nativa **LibHaru**.
* **Integração com HB_ZEBRA:** Geração e posicionamento dinâmico de **QR Code** de homologação em tempo real no PDF.
* **Sistema de Coordenadas em Milímetros:** Conversão matemática transparente de milímetros para pontos PDF, facilitando o design do layout.
* **Mascaramento Dinâmico Inteligente:** * Aplicação de máscaras dinâmicas diferenciadas para CPF/CNPJ de Remetente (`CPF: 123.******-89` e `CNPJ: 99.999.999/9999-99`).
  * Máscara específica homologada de privacidade para CPF de Destinatário (`CPF: 123.***.***-89`).
* **Tratamento de Strings Avançado:** Conversão de strings UTF-8 para PTISO (ANSI) garantindo a integridade dos caracteres acentuados nas observações do DACE.

---

## 📊 Estrutura Visual da DACE Resumida (Demo do Layout)

Abaixo, uma representação lógica de como o layout do PDF é estruturado pelo código:
´´´
+-----------------------------------------------------------------------------------------+
|                  DACE RESUMIDA - DECLARAÇÃO AUXILIAR DE CONTEÚDO ELETRÔNICA             |
+-----------------------------------------------------------------------------------------+
| Nº 000.123.456   SÉRIE 001                                                              |
| DATA DE EMISSÃO: 15-07-2026 10:00:00                                                    |
| PROTOCOLO DE AUTORIZAÇÃO: 135260001234567                                               |
| MODALIDADE DO TRANSPORTE: 0-CORREIOS                                                    |
+-----------------------------------------------------------------------------------------+
| CNPJ/CPF REMETENTE: 123.******-01                                                       |
| NOME REMETENTE: REMETENTE DEMO DA SILVA                                                 |
| ENDEREÇO: Avenida Paulista, 1000 - Bela Vista - CEP: 01310100                           |
+-----------------------------------------------------------------------------------------+
| CNPJ/CPF DESTINATÁRIO: 98.765.432/0001-99                                               |
| NOME DESTINATÁRIO: DESTINATÁRIO EXEMPLO LTDA                                            |
| ENDEREÇO: Rua Copacabana, 500 Bloco B - Copacabana - CEP: 22020002                      |
+-----------------------------------------------------------------------------------------+
| [ QR CODE ]   | Obs 1: Declaramos que este pacote contem apenas itens de uso pessoal...  |
|               | Obs 2: Mercadoria enviada sob termos de servico padrão...                |
+-----------------------------------------------------------------------------------------+
| CHAVE DE ACESSO DC-e                                                                    |
| 3526 0712 3456 7890 1234 5678 9012 3456 7890 1234 5678                                  |
+-----------------------------------------------------------------------------------------+
´´´´
---

## 🛠️ Pré-requisitos e Dependências

Para compilar e executar este gerador de PDF, certifique-se de ter instalado e configurado em seu ambiente Harbour:

1. **Compilador Harbour** (3.2.0 ou superior)
2. **Biblioteca LibHaru (hpdf)** (Geração de PDFs nativos)
3. **Biblioteca hb_zebra** (Para renderização de códigos de barras e QR Codes)


