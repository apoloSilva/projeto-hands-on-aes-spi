# Backlog - AES Hands-on

Lista inicial de tarefas baseada no planejamento de 15 semanas do projeto.
As tarefas serão atualizadas a cada semana.

## Semana 1 - Kick-off, estudo e ambiente

| Tarefa | Critério de conclusão | Estado |
| --- | --- | --- |
| Estudar AES e SPI. | Estudo do AES com base na FIPS-197 e do SPI, incluindo modos de operação, polaridade e fase de clock, registrado no relatório. | Concluída. |
| Estudar a arquitetura-base do sistema de topo. | Blocos, interfaces de topo e fluxo de configuração e dados resumidos no relatório. | Resumo registrado. |
| Preparar o repositório, os scripts e as ferramentas. | Repositório estruturado, scripts definidos e simulador e lint configurados. | Concluída. |
| Validar o exemplo mínimo. | Repositório clonável em ambiente limpo e compilação, lint e simulação executáveis com um único comando. | Simulação  concluída. |
| Preparar o backlog inicial e o relatório da semana. | Planejamento das 15 semanas e relatório de estudo, atividades, resultados, problemas e próximos passos disponíveis no repositório. | Concluída. |

## Planejamento das 15 semanas

| Semana | Tarefas e entregável | Critério de conclusão | Estado |
| --- | --- | --- | --- |
| 1 | Kick-off, estudo e ambiente: estudar AES/SPI e a arquitetura-base; preparar o ambiente; entregar repositório estruturado, backlog inicial, exemplo mínimo e relatório de estudo. | Repositório clonável em ambiente limpo e fluxo mínimo executável com um único comando. | Aguardando avaliação. |
| 2 | Arquitetura e microarquitetura: definir blocos, interfaces, modelos do PLL e da memória, registradores, clocks, resets, CDC e microarquitetura do AES; entregar documento de arquitetura v1.0 e apresentar ao verificador parceiro. | Arquitetura aprovada pelo instrutor na defesa. | Pendente. |
| 3 | RTL do núcleo AES I — datapath das rodadas: implementar SubBytes, ShiftRows, MixColumns e AddRoundKey; entregar RTL e testes unitários. | Transformações conferem com os valores intermediários da FIPS-197; lint sem erros. | Pendente. |
| 4 | RTL do núcleo AES II — expansão de chave e controle: implementar expansão de chave e sequenciamento das rodadas; entregar núcleo completo e testbench dirigido. | Todos os vetores de referência passam em simulação; lint sem erros. | Pendente. |
| 5 | RTL do SPI e do RESET e modelo do PLL: implementar SPI, sincronização, registradores, RESET e modelo comportamental do PLL; entregar RTL, modelo, testbench e relatório de lint. | Leitura e escrita dos registradores funcionando; reset e locked conforme a especificação; lint sem erros e avisos justificados. | Pendente. |
| 6 | Subsistema de dados, integração e congelamento do RTL v1.0: implementar MEMORY / DATA System e modelo de memória; integrar o top-level, testar o fluxo completo e verificar CDC; entregar RTL v1.0 ao verificador parceiro. | Configuração via SPI → entrada pela MEMORY DATA IF → AES → saída pela MEMORY DATA IF funcionando; interfaces conforme a especificação; nenhuma violação de CDC sem justificativa. | Pendente. |
| 7 | Rodada inicial de síntese: preparar SDC e scripts, sintetizar RTL v1.0 e analisar área, timing e potência; entregar netlist e relatório de baseline. | Síntese sem erros e sem latches não intencionais; timing atendido ou plano de correção documentado. | Pendente. |
| 8 | Verificação de equivalência I — RTL × netlist: preparar o fluxo no Formality, executar match e verify e analisar os resultados; entregar scripts e relatório de equivalência do baseline. | Fluxo executável por script; pontos de comparação casados ou com justificativa; resultado registrado. | Pendente. |
| 9 | Verificação de equivalência II — depuração e fechamento: depurar não equivalências, realizar exercício de alteração intencional e corrigir defeitos com nova síntese e equivalência; entregar relatório consolidado e tag RTL v1.1. | Equivalência entre RTL v1.1 e sua netlist confirmada pelo Formality, sem pontos não verificados sem justificativa. | Pendente. |
| 10 | Arquitetura de energia: definir modos, domínios, tabela de estados de potência, isolamento, retenção e sequências de desligamento e religamento; entregar documento de arquitetura de energia. | Arquitetura de energia aprovada pelo instrutor na defesa. | Pendente. |
| 11 | Intenção de potência com UPF: escrever UPF, verificar sua consistência com o RTL e executar simulação power-aware; entregar UPF e relatórios de verificação estática e simulação. | Verificação estática sem erros; corrupção nos domínios desligados e comportamento correto do isolamento e da retenção demonstrados. | Pendente. |
| 12 | Técnicas de baixo consumo I — power gating: implementar controlador e sequência de energia, integrar comandos e status aos registradores e testar transições; entregar RTL, testes e relatório power-aware. | Desligamento e religamento funcionando em simulação power-aware, com isolamento e retenção corretos. | Pendente. |
| 13 | Técnicas de baixo consumo II — clock gating e outras técnicas: aplicar clock gating e técnicas previstas na arquitetura; entregar tag RTL v2.0 ao verificador parceiro, testes atualizados e relatório das técnicas aplicadas. | Funcionalidade da v1.0 preservada; transições entre modos funcionando em simulação power-aware. | Pendente. |
| 14 | Síntese low power e comparação com o baseline: sintetizar RTL v2.0 com UPF e clock gating, comparar área, timing e potência e repetir a equivalência no Formality; entregar relatórios comparativo e de equivalência. | Síntese com UPF sem erros; ganhos e custos quantificados e justificados; equivalência entre RTL v2.0 e netlist low power confirmada. | Pendente. |
| 15 | Encerramento: consolidar documentação e defeitos, organizar o repositório e realizar a apresentação; entregar release final, documentação completa, apresentação e versão preliminar do artigo. | Simulação, síntese, formal e UPF reproduzíveis pelos scripts; apresentação realizada. | Pendente. |
