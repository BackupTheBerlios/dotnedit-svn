# gets the topic to display from the command line
set dir [lindex $argv 0]
set topic [lindex $argv 1]
wm withdraw .
wm overrideredirect . 1
source [file join [file dirname $argv0] "help.tcl"]
help::init $dir/help/help.help $topic

tkwait window .tophelpwindow
exit
