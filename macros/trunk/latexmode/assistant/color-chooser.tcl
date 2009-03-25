set dir [lindex $argv 0]
set topic [lindex $argv 1]
wm withdraw .
wm overrideredirect . 1
source [file join [file dirname $argv0] "help.tcl"]
help::init $dir/color-chooser.help $topic


proc pipe {a} {
global dir
set f [open $dir/.outtcl w]
puts -nonewline $f $a
close $f
set f [open $dir/.intcl r]
set current [read -nonewline $f]
close $f
exec nc -do tcl_insert() $current &
}
