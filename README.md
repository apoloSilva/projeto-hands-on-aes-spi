# MiniSoC AES — Hands-on


Projeto da trilha de RTL Design para desenvolver um acelerador AES-128 com
interface SPI, memória compartilhada e técnicas de baixo consumo.


## Especificação


A arquitetura, a nomenclatura, as interfaces e o mapa de registradores seguem o
[DV_BlockGuide_MiniSoCAES_v1.0.0](docs/spec/DV_BlockGuide_MiniSoCAES_v1.0.0.pdf).

O planejamento e estado das tarefas está no [backlog](docs/backlog.md).


## Organização (semana 4)


| Pasta | Conteúdo |
| --- | --- |
| `rtl/` | Package, topo `minisoc_top` e módulos SPI/AES. |
| `sim/` |  Testbench.|
| `docs/` | Especificação, backlog e relatórios. |
| `synth/` | Síntese, reservada. |
| `fm/` | Verificação formal, reservada. |
| `upf/` | Intenção de potência, reservada. |
| `libs/` | Bibliotecas, reservada. |
| `build/sim/` | Arquivos gerados pela compilação e pela simulação, incluindo `simv` e `waves.fsdb`. |


## Executar testes das transformações (semana 4)


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
- [Relatório da semana 3](docs/reports/semana_03.md)
- [Relatório da semana 4](docs/reports/semana_04.md)
- [Microarquitetura v1.0](docs/architecture/microarquitetura_v1.0.md)




