# AES Hands-on

Projeto da trilha de RTL Synthesis para desenvolver um acelerador AES com
interface SPI, interface de memória e técnicas de baixo consumo.

## Semana 1

O planejamento das tarefas está no [backlog inicial](docs/backlog.md).
As atividades realizadas e os resultados obtidos estão registrados no
[relatório da semana 1](docs/reports/semana_01.md).

## Organização

| Pasta | Conteúdo |
| --- | --- |
| `rtl/` | Package, topo, reset e módulos SPI/AES. |
| `models/` | Modelos temporários da PLL e da memória. |
| `sim/` | Stimulus, testbench e response_checker. |
| `docs/` | Especificação, backlog e relatórios. |
| `synth/` | Síntese, reservada. |
| `fm/` | Verificação formal, reservada. |
| `upf/` | Intenção de potência, reservada. |
| `libs/` | Bibliotecas, reservada. |

## Executar (teste mínimo da semana 1)

```bash
make syntax   # Análise dos arquivos SystemVerilog
make compile  # Compilação e elaboração
make run      # Execução da simulação
make wave     # Visualização no Verdi
make clean    # Limpeza dos arquivos gerados
```

## Documentação

- [Backlog inicial](docs/backlog.md)
- [Relatório da semana 1](docs/reports/semana_01.md)
