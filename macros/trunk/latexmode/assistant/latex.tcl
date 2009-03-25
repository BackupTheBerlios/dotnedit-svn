# gets the topic to display from the command line
set dir [lindex $argv 0]
set topic [lindex $argv 1]
wm withdraw .
wm overrideredirect . 1
source [file join [file dirname $argv0] "help.tcl"]
help::init $dir/index.help $topic

# tkwait window .tophelpwindow
# exit

# after 1000 exit_on_destroy
# 
# proc exit_on_destroy {} {
#  if {[winfo exists .tophelpwindow]} {
#    after 1000 exit_on_destroy
#  } else {
#    exit
#  }
# }



# This is the subroutine that pipes data to NEdit.
# NEdit is invoked via ``nc -do``, where ``tcl_insert()`` is a subroutine in
# ``tcl_hook.nm`` that
# reads the file ``.outtcl`` and inserts the contents in the current NEdit window.
# Notice, that NEdit writes its current editing window in the file ``.intcl`` from
# which Tcl/Tk reads it, so that it knows on what file to invoke ``nc -do``, namely
# on the file ``$current``.
# btw, the small macros that write the current window name to intcl are located
# at the smart-indent hook of NEdit, i.e., the Newline and Type-in Macro.
# The directory ``$dir`` is given by NEdit when it invokes the assistant Tcl program.
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

# Some text variables
set intfdx "\\int_a^b f(x)\\,dx"
set matrix "A= \\begin{pmatrix}
1 & 2\\\\
3 & 4
\\end{pmatrix}"
set fgleichsum "f(z) =\\sum_{n=0}^\\infty a_nz^n"
set equation "\\begin{equation*}
\\begin{split}
a&=b+c-d\\\\
&\\quad +e-f\\\\
&=g+h\\\\
&=i
\\end{split}
\\end{equation*}"
set intsum "\\int_C \\bigl (\\sum_{n=0}^\\infty a_nz^n\\bigr)\\,dz"
