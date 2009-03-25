wm withdraw .
wm overrideredirect . 1
source [file join [file dirname $argv0] "help.tcl"]
help::init ~/nedata/assistant/demo.help

after 1000 exit_on_destroy

proc exit_on_destroy {} {
 if {[winfo exists .tophelpwindow]} {
   after 1000 exit_on_destroy
 } else {
   exit
 }
}

#Routine of moving help window. Invokes from help
proc move_w {dx dy} {
 foreach {w h x y} [split [wm geom .tophelpwindow] "+x"] {
  wm geom .tophelpwindow "${w}x${h}+[expr {$x + $dx}]+[expr {$y + $dy}]"
 }
}

proc pipe {a} {
set f [open ~/nedata/outtcl w]
puts -nonewline $f $a
close $f
set f [open ~/nedata/intcl r]
set current [read -nonewline $f]
close $f
exec nc -do tcl() $current &
}
