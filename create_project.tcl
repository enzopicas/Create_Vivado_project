##################################################################
# USER PARAMETERS
##################################################################

#Project name
set target_name proj_project_name
set bd_name design_name

#Generate bitstream
set GENERATE_BIT 0

#part ID
set PART_ID xc7z010clg400-1
set BOARD_ID digilentinc.com:zybo-z7-10:part0:1.0

#TCL actual path
set local_dir [ file dirname [ file normalize [ info script ] ] ]

#localization of vivado project directory from root package
set DIR_VIVAVO_PROJ $local_dir/

#localization of Vivado sources
set DIR_VIVADO_SRC $DIR_VIVAVO_PROJ/SRC_VHDL_XDC

#localization of ip repository directory from root package
set DIR_IP_REPO $DIR_VIVADO_SRC/IP_REPO

##################################################################
# end USER PARAMETERS
##################################################################

if {[file exists $DIR_VIVAVO_PROJ/$target_name]} {
puts "#########################################################################################
####    ERROR :
####           Project \"$target_name\" already exist.
####           Please delete
####                         /$target_name
#### 	       Before Launching this script
#########################################################################################"
} else {

    ### INITIALIZATION ###
    create_project $target_name $DIR_VIVAVO_PROJ/$target_name -part $PART_ID
    set_property board_part $BOARD_ID [current_project]
    set_property target_language VHDL [current_project]

    create_bd_design "$bd_name"
    update_compile_order -fileset sources_1
    set_property  ip_repo_paths  $DIR_IP_REPO [current_project]
    update_ip_catalog

    save_bd_design

    ###############
    # Add sources #
    ###############
    add_files -fileset constrs_1 -norecurse $DIR_VIVADO_SRC/ctr.xdc
    add_files -norecurse $DIR_VIVADO_SRC/src.vhd
    add_files -fileset sim_1 -norecurse $DIR_VIVADO_SRC/sim.vhd

    ###########
    # Add IPs #
    ###########
    # Add and configure here all IPs you need

    #################
    # Set Addresses #
    #################
    assign_bd_address

    ################
    # Clean visual #
    ################
    regenerate_bd_layout
    validate_bd_design
    save_bd_design

    ######################
    # GENERATE BITSTREAM #
    ######################
    if {$GENERATE_BIT} {
        ###########################
        # Generate output product #
        ###########################
        generate_target all [get_files  $DIR_VIVAVO_PROJ/$target_name/$target_name.srcs/sources_1/bd/$bd_name/$bd_name.bd]
        
        ##################
        # Create wrapper #
        ##################
        make_wrapper -files [get_files $DIR_VIVAVO_PROJ/$target_name/$target_name.srcs/sources_1/bd/$bd_name/$bd_name.bd] -top
        add_files -norecurse $DIR_VIVAVO_PROJ/$target_name/$target_name.gen/sources_1/bd/$bd_name/hdl/${bd_name}_wrapper.vhd

        ######################
        # Generate bitstream #
        ######################
        launch_runs impl_1 -to_step write_bitstream -jobs 6
        wait_on_run impl_1

        ##############
        # Export xsa #
        ##############
        write_hw_platform -fixed -include_bit -force -file $DIR_VIVAVO_PROJ/${bd_name}_wrapper.xsa
    }
}