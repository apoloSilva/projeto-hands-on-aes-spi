# ==========================================
# Diretórios
# ==========================================
RTL_DIR   := rtl
TB_DIR    := tb
SYNTH_DIR := synth

# ==========================================
# Arquivos
# ==========================================
RTL_FILES := \
    $(RTL_DIR)/round_fsm.sv \
    $(RTL_DIR)/spi_main.sv \
    $(RTL_DIR)/aes_main.sv \
    $(RTL_DIR)/aes_spi_top.sv

TB_FILES := $(TB_DIR)/tb_aes_spi.sv

# ==========================================
# Módulos de topo
# ==========================================
RTL_TOP := aes_spi_top
TB_TOP  := tb_aes_spi

# Arquivo de formas de onda gerado pelo testbench
WAVE_FILE := waves.fsdb

# ==========================================
# Flags das ferramentas comerciais
# ==========================================
TIMESCALE = 1ns/1ps

VLOGAN_FLAGS = -full64 \
               -sverilog \
               -kdb \
               +lint=all

VCS_FLAGS = -full64 \
            -timescale=$(TIMESCALE) \
            -debug_access+all \
            -kdb

# ==========================================
# Verificação de sintaxe
# ==========================================
syntax:
	vlogan $(VLOGAN_FLAGS) $(RTL_FILES) $(TB_FILES)

# ==========================================
# Compilação / Elaboração
# ==========================================
compile: syntax
	vcs $(VCS_FLAGS) -top $(TOP)

# ==========================================
# Simulação
# ==========================================
run: compile
	./simv

# ==========================================
# Abrir waveform
# ==========================================
wave:
	verdi -ssf $(WAVE_FILE) &

# ==========================================
# Síntese
# ==========================================
synth: clean
	CLK_PERIOD=6 dc_shell -f $(SYNTH_DIR)/synth.tcl

# ==========================================
# Limpeza da síntese
# ==========================================
clean_synth:
	rm -rf \
	    ./alib-52 \
	    ./default.svf \
	    ./work*

	# Remove arquivos antigos de síntese.
	find $(SYNTH_DIR) -type f \( \
	    -name "*.ddc" -o \
	    -name "*.db" -o \
	    -name "*.rpt" \
	\) -delete

# ==========================================
# Limpeza da simulação
# ==========================================
clean_sim:
	rm -rf \
	    csrc \
	    simv* \
	    obj_dir \
	    *.daidir \
	    novas* \
	    AN.DB \
	    ucli.key \
	    verdi* \
	    DVEfiles \
	    .vlogan* \
	    *.fsdb \
	    *.fst \
	    *.vcd \
	    *.log \
	    *.out \
	    *.fls \
	    *.gz \
	    *.fdb_latexmk \
	    *.aux

# ==========================================
# Limpeza total
# ==========================================
clean: clean_sim clean_synth

.PHONY: syntax compile run wave synth clean clean_sim clean_synth


