#! /usr/bin/env bash
files_list=(../hdl_src/RV32i_pkg.sv \
    ../hdl_src/regfile.sv \
    ../hdl_src/RV32i_alu.sv \
    ../hdl_src/RV32i_pipeline_controlpath.sv \
    ../hdl_src/RV32i_pipeline_datapath.sv \
    ../hdl_src/RV32i_pipeline_top.sv \
    ../hdl_src/RV32i_soc.sv \
    ../hdl_src/wsync_mem.sv \
    ../tb/RV32i_tb.sv)


if [ ! -d ./libs ]; then
  mkdir libs
fi

if [-d ./libs/work ]
then
    vdel -lib ./libs/work/ -all
    vlib ./libs/work
else
    vlib ./libs/work
fi
vmap work ./libs/work

for file in ${files_list[*]} ;do
    echo "compiling : " $file
    vlog -work work "+acc" -sv $file
done

vsim RV32i_tb
