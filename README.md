# MiniSoC AES — Hands-on


Projeto da trilha de RTL Design para desenvolver um acelerador AES-128 com
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

## Semana 3

Esta etapa define a microarquitetura e as interfaces entre os módulos do AES,
incluindo a FSM, o datapath e a sequência de reset. As transformações de rodada
incluem MixColumns, InvMixColumns e AddRoundKey, além das transformações diretas
e inversas da Semana 2. O testbench compara os resultados com os
estados intermediários da FIPS 197.

`minisoc_aes_key_exp` e `minisoc_aes_dp` ainda são rascunhos; sua implementação
está prevista para a Semana 4. A integração da memória, do SPI e do topo geral
ocorre nas semanas seguintes.



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


## Executar testes das transformações


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
- [Microarquitetura v1.0](docs/architecture/microarquitetura_v1.0.md)
- [Relatório da semana 3](docs/reports/semana_03.md)




