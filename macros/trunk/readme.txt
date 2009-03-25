.. Document Type: reStructured Text
.. Encoding: ISO-8859-1

===================
 NEdit Macro Setup
===================


:Author: Dr Jörg Fischer 
:Contact: nedit@public-files.de
:Date: 2007-12-20
:Abstract:

    Description of a very simple on-demand loading of NEdit macros.
    
------------------------------
 Simplistic On-Demand Loading
------------------------------


The Situation
=============

NEdit has grown into a powerful editing framework.  Unfortunately, it
has neither a special preferences setting system nor a plug-in system
for macros.  For its preferences, NEdit simply uses the X resources
mechanism.  On the other hand, while NEdit is fully macro programmable,
there are a few restrictions stemming from the history of the macro
language.

Before NEdit was programmable, it only had a macro recorder.  This also
explains the name 'macro', meaning to record a sequence of editor
actions to replay them.  Later on, a full programming language was built
around the macro recorder.  A remaining restriction is that macros must
be located on the Macro menu [#]_.  But these menu entries must not
contain definitions of macro subroutines.  Macro subroutines must be
loaded from a file, so that the macros located at the menus can call
them.

At start-up time, NEdit automatically reads the preferences file
``nedit.rc``, and the autoload macro file ``autoload.nm`` [#]_.  The
preferences file contains saved preferences [#]_ in the format of an X
resource file.  The autoload macro file is a macro file containing macro
commands and definitions that NEdit will execute at start-up.

By default the location of these files is ``$HOME/.nedit/``.  A
different directory can be given by letting the environment variable
``NEDIT_HOME`` point to it.

This is already all the support NEdit offers for macro packages, that
is, you have to care for it mainly yourself.  Luckily, all of the menu
actions are available in macros, too.  This means to load a macro file,
you needn't go to the File menu and click on ``Load Macro File``.  The
action behind this menu entry is called ``load_macro_file()``. 
Moreover, if a macro is loaded, it isn't only compiled, but also
executed.  So, to automatically load a macro file on start-up,  you
needn't rename it to, or include it into, ``autoload.nm``.  It is enough
to add a statement like ::

    load_macro_file("/path/name-of-file")

to your ``autoload.nm`` file.  This is fine, if you have just a few
macro files to load.  On the long run, it doesn't make sense to
automatically load all macros you have.  If you going to write an
e-mail, you don't need your LaTeX macros for instance.  Moreover, the
idea to have subroutines means to re-use these also for other macros. 
So, you create macro routines that depend on another, but it will soon
be unclear, whether or not you loaded the required routines, unless you
load them all right from the start.

The Solution
============

There is a macro set available on Niki_ that offers an on-demand loading
of macros to address these problems.  This macro set was written many
years ago [#]_, and is still very usable.

I don't use it, because it offers much more than I need, and it also
depends on using the ``shell_command()`` to search for the actual
location of the macro files.

Now, if one doesn't need the extra comfort to put the macro files
somewhere and let the on-demand loading macro search for them, but only
wants to have the on-demand loading part of it, this is much simpler and
shorter to achieve, and it needs no shell commands, which aren't
available everywhere, where NEdit can run.

I also benefit from the environment variable ``NEDIT_HOME``, which gives
me all the flexibility I need.  The idea is to let ``NEDIT_HOME`` be the
base path and to put all macros below it.  This isn't strictly required,
though.  Required is, that all macro files are declared in the
``autoload.nm`` file.  That is, you must give the full path leading to
the file.

This is also required to have these paths as base paths for the specific
macro packages readily available.  Either you go to the trouble to
specify these paths once in ``autoload.nm``, or you go to the trouble of
letting all the files that macros may need in addition be found
automagically.

We require the file names without path to be unique and put them as keys
into a global array called ``$jf_loaded_nmfiles``.

There are only to further small macro subroutines defined in
``autoload.nm``, namely ``jf_require()`` and ``jf_displayLoaded()``. 


TODO
====

We could also try to search for files.  The idea is that we shouldn't
create dependencies on external tools too much.  Currently, we need no
shell commands whatsoever.  If we allow to use a shell, we need a shell.
On cygwin we can impose ``tcsh``.  This shell has the built-in command
``ls -F``, which works like the ``-F`` option of the external command 
``ls``.  So, under minimal assumptions, we could try to use shell
commands, namely ::

    list = shell_command("cd "$jf_path_to["/nedit_home/"]";ls -F *", "")

This will work with both ``bash`` and ``tcsh``.  The output coincides.

So, if a file name is not contained in ``$jf_path_to``, we try to find
it with the preceding shell command.  If we find it, we add the file
name to ``$jf_path_to``.

------------------------

Footnotes

.. [#] NEdit doesn't create this file automatically.  So, create it
   yourself, if it shouldn't exist.

.. [#] Long before things like associative arrays for the macro
   language, or the variable ``NEDIT_HOME`` existed. 
   
.. _Niki : http://nedit.hackvalue.net/niki/
