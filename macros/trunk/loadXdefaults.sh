
# 
export NEDIT_HOME=~/dotnedit
xrdb -m $NEDIT_HOME/.Xdefaults

# This doesn't work, the nedit*text.Translations is *one* string.
# therefore, this woul override the previous Translations!
# xrdb -m $NEDIT_HOME/rst/keybindings.xrc

if test $OSTYPE = "linux";
then xrdb -m $NEDIT_HOME/special.xrc
fi 
