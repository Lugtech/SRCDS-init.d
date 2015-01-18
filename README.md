# SRCDS-init.d
A basic init.d script for Source Dedicated Servers (SRCDS)

## About
These scripts provide init.d functionality for `srcds` servers.
There are two files, `srcds.bash` and `tf2`.

 - `tf2` is the configuration file, and should be renamed and configured for the desired server type. This will go in the `/etc/init.d` folder
 - `srcds.bash` is the script. There only needs to be one copy of this even if there are multiple configurations (TF2, CS:GO, Insurgency, etc.). This should be placed in a convienient location, or `/etc/init.d/` if required.

### Usage

This assumes you have the `service` program. If you do not, run the script directly (ie `/etc/init.d/tf2`).

There are 5 different commands:
 - `start` (`# service tf2 start`) - starts the server if it is not running
 - `stop` (`# service tf2 stop`) - stops the server if it is running
 - `restart` (`# service tf2 restart`) - stops the server if it is running and restarts the server
 - `status` (`# service tf2 status`) - prints whether the server is running
 - `rcon` (`# service tf2 rcon <command>`) - sends `<command>` to the server and prints the reply. If the server is slow to respond the reply may not show up properly.

## Installation
1. Clone this repository to a temporary directory. Example:  
`$ mkdir /tmp/srcds`  
`$ cd /tmp/srcds`  
`$ git clone https://github.com/Lugtech/SRCDS-init.d.git`
1. Copy the files to their desired locations. Example:  
`# cp tf2 /etc/init.d/`  
`# cp srcds.bash /etc/init.d`
1. Edit/rename the configuration file (`tf2`). There are comments describing each setting.
1. Register the init.d script. Example (Debian/Ubuntu):  
`update-rc.d tf2 defaults`
The server should now start on boot.
