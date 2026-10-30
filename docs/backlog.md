# Backlog - MiniSoC AES (RTL Design Track)

Planejamento atualizado conforme o cronograma revisado em 27/10/2026 e o *Block Guide - MiniSoC AES*, v1.0.0. O projeto tem 13 semanas de entrega, com encerramento em 29/01/2027 e recesso de 21/12/2026 a 03/01/2027.

## Regras de acompanhamento

- Atualizar o estado das tarefas no início de cada semana e registrar bloqueios e dúvidas para o acompanhamento com o instrutor.
- Versionar cada entrega no repositório Git em branch ou tag identificada pela semana, acompanhada de `docs/reports/semana_XX.md` com atividades, resultados, problemas e próximos passos.
- Versionar scripts e relatórios de lint, síntese, equivalência e UPF. Marcar uma entrega como concluída somente após atender ao critério de aceite correspondente.
- Seguir o *Block Guide* para as interfaces de topo, nomes de módulos e sinais, SPI, mapa de registradores e modelo de programação. Registrar divergências ou ambiguidades como issues e encaminhá-las ao instrutor.
- Registrar defeitos do verificador parceiro como issues com cenário e evidência; classificá-los e acompanhar as correções no backlog. Compartilhar as tags `rtl-v1.0`, `rtl-v1.1` e `rtl-v2.0` nas semanas previstas.

## Semana 1 - Kick-off, estudo e ambiente

| Tarefa | Critério de conclusão | Estado |
| --- | --- | --- |
| Estudar AES e SPI. | Estudo do AES com base na FIPS-197 e do SPI, incluindo modos de operação, polaridade e fase de clock, registrado no relatório. | Concluída. |
| Estudar a arquitetura-base do sistema de topo. | Blocos, interfaces de topo e fluxo de configuração e dados resumidos no relatório. | Resumo registrado. |
| Preparar o repositório, os scripts e as ferramentas. | Repositório estruturado, scripts definidos e simulador e lint configurados. | Concluída. |
| Validar o exemplo mínimo. | Repositório clonável em ambiente limpo e compilação, lint e simulação executáveis com um único comando. | Simulação  concluída. |
| Preparar o backlog inicial e o relatório da semana. | Planejamento das 15 semanas e relatório de estudo, atividades, resultados, problemas e próximos passos disponíveis no repositório. | Concluída. |

## Semana 2 - Desafio: SubBytes e ShiftRows (entrega 30/10/2026)

| Tarefa | Critério de conclusão | Estado |
| --- | --- | --- |
| Implementar `minisoc_aes_sbox`. | Entrada e saída de 8 bits, lógica combinacional correspondente às 256 entradas da S-box da FIPS 197. | Aguardando aprovação. |
| Implementar `minisoc_aes_sub_bytes`. | Estado de 128 bits transformado por 16 instâncias da S-box, respeitando a ordem dos bytes do *Block Guide*. | Aguardando aprovação. |
| Implementar `minisoc_aes_shift_rows`. | Reordenação combinacional dos 16 bytes conforme a representação de estado da FIPS 197: byte 0 em `[127:120]`, byte 15 em `[7:0]`, `r = n mod 4` e `c = n div 4`. | Aguardando aprovação. |
| Criar testbench autoverificável. | Comparar as 256 entradas da S-box com tabela independente e conferir SubBytes e ShiftRows com os estados intermediários do Apêndice B da FIPS 197, pelo menos nas rodadas 1 e 10. Um único comando executa os testes com PASS. | Aguardando aprovação. |
| Ler as seções 1 a 3 e 8 do *Block Guide* e registrar dúvidas. | Lista de dúvidas e ambiguidades incluída no relatório `docs/reports/semana_02.md`. | Aguardando aprovação. |
| Entregar RTL, testes e relatório da semana. | RTL dos três módulos, testbench e relatório versionados; lint sem erros. | Aguardando aprovação. |

**Opcional:** implementar e testar InvSubBytes e InvShiftRows como transformações inversas. Isso não substitui os critérios obrigatórios acima.

## Cronograma e entregas - Semanas 2 a 13

| Semana / entrega | Atividades e entregável | Critério de conclusão | Estado |
| --- | --- | --- | --- |
| **3 - 06/11/2026** | **Microarquitetura e transformações de rodada.** Documentar diagrama interno, opção de datapath, FSM de `minisoc_aes_top`, CDC por toggle entre `spi_sclk` e `clk` e sequência de reset de `sys_clk`. Implementar MixColumns, AddRoundKey e as transformações inversas InvSubBytes, InvShiftRows e InvMixColumns; criar testes unitários e apresentar a microarquitetura ao verificador parceiro. | Documento v1.0 em `docs/architecture/` aprovado pelo instrutor na defesa curta; transformações diretas e inversas conferem com os valores intermediários dos Apêndices B e C.1 da FIPS 197; lint sem erros. | Pendente. |
| **4 - 13/11/2026** | **Expansão de chave e datapath AES-128.** Implementar `minisoc_aes_key_exp` com 11 round keys e `minisoc_aes_dp` para cifra e cifra inversa de um bloco. Justificar expansão pré-computada ou sob demanda e testar com vetores da FIPS 197. | Cifragem e decriptação conferem com os vetores de referência; RTL e testbench entregues; lint sem erros. | Pendente. |
| **5 - 20/11/2026** | **SPI front-end e PLL mock.** Implementar `minisoc_spi`, banco de registradores e `minisoc_pll_mock`. SPI Mode 0, MSB-first, frame de 40 bits, escrita em uma transação e leitura em duas; transferir frame por toggle entre `spi_sclk` e `clk`. Testar os registradores e o lock nos quatro divisores do PLL. | Registradores R/W escritos e lidos por SPI; registradores de leitura protegidos contra escrita; PLL libera `sys_clk` após lock em /1, /2, /4 e /8; testbench e relatório de lint entregues, sem erros e com avisos justificados. | Pendente. |
| **6 - 27/11/2026** | **AES engine e memória compartilhada.** Implementar `minisoc_memory` (1024 x 32 bits, porta única síncrona, sem reset funcional e posse exclusiva por `MEM_SEL_AES`) e `minisoc_aes_top` (captura da configuração, leitura e escrita *in-place*, status). Implementar inicialmente ECB, CBC e CTR nos dois sentidos; testar 1, 2 e 256 blocos, além de configurações inválidas. Registrar PCBC, CFB e OFB como limitações conhecidas da v1.0 e comunicá-las ao verificador parceiro. | Modos implementados conferem com modelo de referência; `ERROR` para `NUM_BLOCKS` fora de 1..256 ou `MODE` reservado; RTL, vetores e testbench entregues; lint sem erros. | Pendente. |
| **7 - 04/12/2026** | **Integração e RTL v1.0.** Implementar `minisoc_top` com as interfaces CLK, RESET, SPI e MEMORY DATA exatamente como especificadas. Integrar reset do domínio AES após lock, testar o fluxo completo dos 14 passos do modelo de programação e analisar CDC entre os domínios. Entregar `rtl-v1.0` ao verificador parceiro. | Fluxo memória → configuração SPI → lock → START → DONE → leitura do resultado funciona; interfaces compatíveis com o *Block Guide*; lint e CDC documentados, sem violação de CDC sem justificativa; tag `rtl-v1.0` criada. | Pendente. |
| **8 - 11/12/2026** | **Síntese inicial.** Preparar SDC para `clk`, `sys_clk`, `spi_sclk` e `mem_clk`, incluindo grupos assíncronos; tratar PLL mock e memória como caixas-pretas ou macros conforme orientação do instrutor. Sintetizar a v1.0 e produzir netlist e baseline de área, timing e potência estimada. | Síntese sem erros e sem latches não intencionais; timing atendido nas frequências definidas pelo instrutor ou plano de correção documentado; scripts, SDC, netlist e relatório versionados. | Pendente. |
| **9 - 18/12/2026** | **Equivalência formal.** Preparar Formality com RTL v1.0, netlist, bibliotecas, SVF e tratamento coerente de PLL e memória. Executar match/verify, investigar divergências e registrar exercício de alteração intencional. | Fluxo executável por script; equivalência confirmada; pontos sem correspondência ou sem verificação justificados; relatório de causas e resultados entregue. | Pendente. |
| **Recesso - 21/12/2026 a 03/01/2027** | Sem entregas. Issues eventualmente abertas pelo verificador parceiro entram na triagem da Semana 10. | Não se aplica. | Planejado. |
| **10 - 08/01/2027** | **Fechamento funcional e RTL v1.1.** Implementar PCBC, CFB e OFB; corrigir e classificar issues do verificador parceiro; testar os seis modos; repetir síntese e equivalência formal. Entregar `rtl-v1.1` ao verificador. | Seis modos conferem com modelo de referência; issues tratadas; equivalência entre RTL v1.1 e sua netlist confirmada; tag, testes e relatórios entregues. | Pendente. |
| **11 - 15/01/2027** | **Arquitetura de energia e UPF.** Definir atividade, modos e domínios de potência, blocos always-on, tabela de estados, isolamento, retenção e sequência de desligamento/religamento. Escrever UPF, verificar estaticamente e simular transição power-aware; apresentar defesa curta. | Arquitetura aprovada pelo instrutor; UPF sem erros na verificação estática; simulação mostra corrupção no domínio desligado e isolamento correto; documento, UPF e relatórios entregues. | Pendente. |
| **12 - 22/01/2027** | **Baixo consumo e RTL v2.0.** Implementar controlador e sequência de power gating, integrar comandos/status; aplicar clock gating com células ICG e outras técnicas aprovadas. Testar transições de energia e entregar `rtl-v2.0` ao verificador parceiro para regressão funcional. | Funcionalidade v1.1 preservada; transições corretas em simulação power-aware, com isolamento e retenção; tag, testes e relatório das técnicas entregues. | Pendente. |
| **13 - 29/01/2027** | **Síntese low power e encerramento.** Sintetizar v2.0 com UPF e clock gating, comparar área, timing e potência por modo com a Semana 8, verificar equivalência RTL × netlist low power, consolidar documentação/issues e apresentar o projeto. | Síntese com UPF sem erros; ganhos e custos quantificados e justificados; simulação, síntese, formal e UPF reproduzíveis por scripts; relatório comparativo, relatório de equivalência, release final e apresentação entregues. | Pendente. |

O artigo técnico é uma entrega condicionada à viabilidade e pode ser concluído após o encerramento; não é critério de aceite da Semana 13.
