add wave -position insertpoint  \
sim:/RV32i_tb/RV32i_soc_inst/RV32i_core/dp/alu_do_w \
sim:/RV32i_tb/RV32i_soc_inst/RV32i_core/dp/alu_op1_data_r \
sim:/RV32i_tb/RV32i_soc_inst/RV32i_core/dp/alu_op2_data_r \
sim:/RV32i_tb/RV32i_soc_inst/RV32i_core/dp/pc_counter_r \
sim:/RV32i_tb/RV32i_soc_inst/RV32i_core/dp/pc_next_w \
sim:/RV32i_tb/RV32i_soc_inst/RV32i_core/dp/reg_we_i
add wave -position insertpoint  \
{sim:/RV32i_tb/RV32i_soc_inst/RV32i_core/dp/regfile_inst/register_r[5]} \
{sim:/RV32i_tb/RV32i_soc_inst/RV32i_core/dp/regfile_inst/register_r[6]} \
{sim:/RV32i_tb/RV32i_soc_inst/RV32i_core/dp/regfile_inst/register_r[7]} \
{sim:/RV32i_tb/RV32i_soc_inst/RV32i_core/dp/regfile_inst/register_r[28]}
add wave -position insertpoint  \
sim:/RV32i_tb/RV32i_soc_inst/RV32i_core/cp/inst_dec_r \
sim:/RV32i_tb/RV32i_soc_inst/RV32i_core/cp/inst_exec_r \
sim:/RV32i_tb/RV32i_soc_inst/RV32i_core/cp/inst_mem_r \
sim:/RV32i_tb/RV32i_soc_inst/RV32i_core/cp/inst_wb_r \
sim:/RV32i_tb/RV32i_soc_inst/RV32i_core/cp/instruction_i \
sim:/RV32i_tb/RV32i_soc_inst/RV32i_core/cp/rd_add_exec_w \
sim:/RV32i_tb/RV32i_soc_inst/RV32i_core/cp/rd_add_mem_w \
sim:/RV32i_tb/RV32i_soc_inst/RV32i_core/cp/rd_add_wb_w \
sim:/RV32i_tb/RV32i_soc_inst/RV32i_core/cp/rs1_dec_w \
sim:/RV32i_tb/RV32i_soc_inst/RV32i_core/cp/rs2_dec_w \
sim:/RV32i_tb/RV32i_soc_inst/RV32i_core/cp/stall_w \
sim:/RV32i_tb/RV32i_soc_inst/RV32i_core/cp/branch_taken_w
run 2800 ns






