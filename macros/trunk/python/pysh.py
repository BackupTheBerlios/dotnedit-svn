#!/usr/bin/python
import os
import sys
# for exists
import os.path
from code import InteractiveInterpreter
import stat

# to get environment variables

dotnedit = os.getenv("NEDIT_HOME")
if dotnedit == "" :
    dotnedit = os.getenv("HOME") + "/.nedit"
dotnedit = dotnedit + "/"    
PyCmds = dotnedit + ".py_cmds"
PyAnswers = dotnedit + ".py_answers"

if not os.path.exists(PyAnswers):
    os.mkfifo(PyAnswers)
statinfo = os.stat(PyAnswers)
if not stat.S_ISFIFO(statinfo.st_mode):
    os.unlink(PyAnswers)
    os.mkfifo(PyAnswers)
    
# PyCmds is file (fifo) written by nedit containing commands for the interpreter
# PyAnswers is fifo read by nedit for the output these commands
# therefore, this script reads from PyCmds, tries to interpret them
# and writes the output to PyAnswers


PyShell = InteractiveInterpreter()
commandLine = ''
while True :
    # Getting the command line from the pipe
    
    # check if pipe
    if not os.path.exists(PyCmds):
        os.mkfifo(PyCmds)
    statinfo = os.stat(PyCmds)
    if not stat.S_ISFIFO(statinfo.st_mode):
        os.unlink(PyCmds)
        os.mkfifo(PyCmds)
    
    try:
        INPUT = open(PyCmds, 'r')
    except IOError:
        print "Can't open " + PyCmds
    else:
        commandLine += INPUT.read()
        INPUT.close()
    
    if commandLine == '' :
        continue

    # we have a command line
    # open output pipe
    if not os.path.exists(PyAnswers):
        os.mkfifo(PyAnswers)
    statinfo = os.stat(PyAnswers)
    if not stat.S_ISFIFO(statinfo.st_mode):
        os.unlink(PyAnswers)
        os.mkfifo(PyAnswers)
    
    try:
        OUTPUT = open(PyAnswers, 'w')
    except IOError:
        print "Can't open " + PyAnswers
    else:
        # for simplicity, we redirect 
        # anything the script outputs
        sError = sys.stderr
        sOutput = sys.stdout
        sys.stderr = OUTPUT
        sys.stdout = OUTPUT
    
    # execute command line(s)
    if PyShell.runsource(str(commandLine)) :
        # the command is not complete
        print "... "
        commandLine += "\n"
    else:
        # the command was complete
        print ">>> "
        commandLine = ''

    OUTPUT.close()
    # restore the streams
    sys.stdout, sys.stderr = sOutput, sError
