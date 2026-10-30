# MiniSoC AES — Hands-on


Projeto da trilha de RTL Synthesis para desenvolver um acelerador AES-128 com
interface SPI, memória compartilhada e técnicas de baixo consumo.


## Especificação


A arquitetura, a nomenclatura, as interfaces e o mapa de registradores seguem o
[DV_BlockGuide_MiniSoCAES_v1.0.0](docs/spec/DV_BlockGuide_MiniSoCAES_v1.0.0.pdf).

## Semana 2


Esta etapa contempla a organização do topo e das interfaces do MiniSoC conforme
a especificação, além da implementação e dos testes de SubBytes, ShiftRows,
InvSubBytes e InvShiftRows do AES.


O planejamento das tarefas está no [backlog](docs/backlog.md), e as atividades
da etapa estão descritas no [relatório da semana 2](docs/reports/semana_02.md).


## Organização


| Pasta | Conteúdo |
| --- | --- |
| `rtl/` | Package, topo `minisoc_top` e módulos SPI/AES. |
| `sim/` |  Testbench.|
| `docs/` | Especificação, backlog e relatórios. |
| `synth/` | Síntese, reservada. |
| `fm/` | Verificação formal, reservada. |
| `upf/` | Intenção de potência, reservada. |
| `libs/` | Bibliotecas, reservada. |


## Executar teste da semana 02


```bash
make syntax   # Análise dos arquivos SystemVerilog
make compile  # Compilação e elaboração
make run      # Execução da simulação
make clean    # Limpeza dos arquivos gerados
```


## Documentação


- [Especificação DV_BlockGuide_MiniSoCAES_v1.0.0](docs/spec/DV_BlockGuide_MiniSoCAES_v1.0.0.pdf)
- [Backlog](docs/backlog.md)
- [Relatório da semana 1](docs/reports/semana_01.md)
- [Relatório da semana 2](docs/reports/semana_02.md)




