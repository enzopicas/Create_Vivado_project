# Create Vivado project from .TCL script
This script is used by Vivado to create project with a block design.  
By setting parameters and complete the script, you can re-create from scratch a project, from sources to bitstream and .xsa file.

## Licence
This script is provided under MIT licence

## Custom parameters
|Parameter|Info|
|:--|:--:|
|target_name|Target name of the project *(start your project name with `proj_` to be ignored by git, following the .gitignore file)*|
|bd_name|Target name of the block design|
|GENERATE_BIT|0: Bitstream will not be generate at the end of the script, other, set to 1|
|PART_ID|Reference number of the FPGA part used|
|BOARD_ID|Reference number of the board, used to apply board preset|
|local_dir|This is used to get the actual path of the script, **don't change this parameter**|
|DIR_VIVAVO_PROJ|Final directory of the generated project|
|DIR_VIVADO_SRC|Directory where are located sources, constraint, and simulation files|
|DIR_IP_REPO|Directory where are located custom packaged IPs|

## Update the script
* Add all your sources in the *Add sources* section, following the example
* Add all IPs you want, and configure them in the *Add IPs* section

In case of other update, be sure that you're not writing absolute path in the script, use variable instead.
