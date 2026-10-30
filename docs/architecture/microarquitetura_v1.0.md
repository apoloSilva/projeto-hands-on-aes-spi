# Microarquitetura v1.0 — MiniSoC AES


## Diagrama geral


![Esboço da arquitetura geral do MiniSoC AES](arquitetura_geral.png)


*Figura 1 — Esboço da arquitetura geral e das ligações entre os blocos. Fonte: elaboração própria.*


A arquitetura é composta pelos módulos [`minisoc_spi.sv`](../../rtl/minisoc_spi/minisoc_spi.sv), [`minisoc_pll_mock.sv`](../../rtl/minisoc_pll/minisoc_pll_mock.sv), [`minisoc_aes_top.sv`](../../rtl/minisoc_aes/minisoc_aes_top.sv) e [`minisoc_memory.sv`](../../rtl/minisoc_mem/minisoc_memory.sv), integrados em [`minisoc_top.sv`](../../rtl/minisoc_top.sv). O SPI recebe comandos e disponibiliza configurações ao AES e à PLL; o núcleo AES acessa a memória de dados. O sequenciamento do reset é realizado diretamente no topo, enquanto a PLL fornece o clock do sistema.


As interfaces externas compreendem `RESET`, `CLK`, `SPI IF` e `MEMORY DATA IF`. O diagrama representa a arquitetura proposta, ainda pendente de validação. O detalhamento das interfaces e das decisões em aberto está no [relatório da Semana 02](../reports/semana_02.md).




