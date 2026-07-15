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
```text
+---------------------------------------------------------------------------+
|         DACE RESUMIDA - DECLARAÇÃO AUXILIAR DE CONTEÚDO ELETRÔNICA        |
+---------------------------------------------------------------------------+
|  Nº 007.222.294   SÉRIE: 025                                              |
|  DATA DE EMISSÃO: 2026-07-13T12:47:35-03:00                               |
|  PROTOCOLO DE AUTORIZAÇÃO: 3352600058738349                               |
|  MODALIDADE DO TRANSPORTE: 0-CORREIOS                                     |
+---------------------------------------------------------------------------+
|  CNPJ/CPF REMETENTE: 054.******-79                                        |
|  NOME REMETENTE: marcelo antonio lazzaro carli                            |
|  CIDADE-UF: Marília-SP                                                    |
|  ENDEREÇO: Rua Andre Martins Parra, 250 - Jardim Colibri - CEP: 17514-260  |
+---------------------------------------------------------------------------+
|  CNPJ/CPF DESTINATÁRIO: 137.******-88                                     |
|  NOME DESTINATÁRIO: flavia evencio                                        |
|  CIDADE-UF: Morello - ES                                                  |
|  ENDEREÇO: Morello, 0 sn - zona rural - CEP: 29723-000                    |
+---------------------------------------------------------------------------+
|  CNPJ FISCO/MARKETPLACE: 16.922.038/0001-51                               |
|  NOME: Enjoei S.A.                                                        |
+-----------------+---------------------------------------------------------+
|                 | É contribuinte de ICMS qualquer pessoa física...        |
|   [ QR CODE ]   |                                                         |
|                 | Constitui crime contra a ordem tributária...            |
+-----------------+---------------------------------------------------------+
|                          Chave de Acesso DC-e                             |
|         3526 0716 9220 3800 0151 9902 5007 2222 9411 0632 7420            |
+---------------------------------------------------------------------------+
---

## 🛠️ Pré-requisitos e Dependências

Para compilar e executar este gerador de PDF, certifique-se de ter instalado e configurado em seu ambiente Harbour:

1. **Compilador Harbour** (3.2.0 ou superior)
2. **Biblioteca LibHaru (hpdf)** (Geração de PDFs nativos)
3. **Biblioteca hb_zebra** (Para renderização de códigos de barras e QR Codes)


