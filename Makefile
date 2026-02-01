# ==========================================
# GitHub Codespaces Verilog Design Flow
# ==========================================

# 1. 基礎路徑設定
RTL_DIR = rtl
TB_DIR  = tb
SIM_DIR = sim
OUT_FILE = $(SIM_DIR)/sim.vvp
VCD_FILE = $(SIM_DIR)/waveform.vcd

# 2. 自動搜尋原始碼 (Recursive Search)
# 找出 rtl/ 和 tb/ 下面所有層級資料夾內的 .v 檔
RTL_SRCS = $(shell find $(RTL_DIR) -name "*.v")
TB_SRCS  = $(shell find $(TB_DIR) -name "*.v")

# 3. 智能 Include 路徑處理 (關鍵修改) 🌟
# find $(RTL_DIR) -type d : 找出 rtl 下所有的子資料夾 (e.g., rtl/01_basic)
# addprefix -I, ...       : 在每個路徑前加上 -I (e.g., -Irtl/01_basic)
# 這樣 Verilog 的 `include "file.vh"` 才能在任何層級找到檔案
INCLUDE_DIRS = $(addprefix -I, $(shell find $(RTL_DIR) -type d))

# 預設目標
all: lint compile run

# ==========================================
# Tasks
# ==========================================

# 1. Linting (語法檢查 - 使用 Verilator)
# 加入 $(INCLUDE_DIRS) 讓 Verilator 也能找到標頭檔
lint:
	@echo ">>> [Verilator] Checking syntax..."
	verilator --lint-only -Wall --timing $(INCLUDE_DIRS) $(RTL_SRCS)

# 2. Compile (編譯 - 使用 Icarus Verilog)
compile:
	@echo ">>> [Icarus] Compiling..."
	# 確保輸出目錄存在
	@mkdir -p $(SIM_DIR)
	# 編譯指令解析：
	# -o: 輸出檔名
	# -y: Library 搜尋路徑 (基本設為根目錄即可)
	# $(INCLUDE_DIRS): 展開後包含所有子資料夾的 -I 路徑
	iverilog -o $(OUT_FILE) -y $(RTL_DIR) $(INCLUDE_DIRS) $(RTL_SRCS) $(TB_SRCS)

# 3. Simulate (仿真 - 使用 vvp)
run:
	@echo ">>> [Simulation] Running..."
	vvp $(OUT_FILE)
	@echo ">>> Done. Waveform generated at $(VCD_FILE)"

# 4. Clean (清理)
clean:
	rm -rf $(SIM_DIR) obj_dir
	@echo ">>> Cleaned build files."

.PHONY: all lint compile run clean
