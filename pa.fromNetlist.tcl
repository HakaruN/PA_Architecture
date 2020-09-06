
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name PA_Architecture -dir "/home/hakaru/Projects/Verilog/PA_Architecture/PA_Architecture/planAhead_run_5" -part xc3s500evq100-5
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "/home/hakaru/Projects/Verilog/PA_Architecture/PA_Architecture/PA_Core.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/home/hakaru/Projects/Verilog/PA_Architecture/PA_Architecture} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "PA_Core.ucf" [current_fileset -constrset]
add_files [list {PA_Core.ucf}] -fileset [get_property constrset [current_run]]
link_design
