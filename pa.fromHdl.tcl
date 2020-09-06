
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name PA_Architecture -dir "/home/hakaru/Projects/Verilog/PA_Architecture/PA_Architecture/planAhead_run_2" -part xc3s500evq100-5
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "PA_Core.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {RegisterFile.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {RegController.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {Parser.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {Fetch.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {ExecUnit.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {Decode.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {PA_Core.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set_property top PA_Core $srcset
add_files [list {PA_Core.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc3s500evq100-5
