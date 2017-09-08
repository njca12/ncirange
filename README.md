     ##   ##  #####  ##  ####   ######  ##   ##  ######  ######
     ###  ##  ##     ##  ##  #  ##  ##  ###  ##  ##      ##
     ## # ##  ##     ##  ####   ######  ## # ##  ######  ####
     ##  ###  ##     ##  ## #   ##  ##  ##  ###  ##  ##  ##
     ##   ##  #####  ##  ##  #  ##  ##  ##   ##  ######  ######
  
                 NCI-RANGE Script. Version 1.0.

This script takes the cube files produced by NCIPlot Software (http://www.lct.jussieu.fr/pagesperso/contrera/nciplot.html) and extracts density and reduced density gradients in the requested range. The Software gives a new reduced density gradients cube files. 
 
  Nestor Cubillan, nestorcubillan@mail.uniatlantico.edu.co, Universidad del Atlantico, Barranquilla, Colombia.

*********************
Contents
*********************
1. System Requirement
2. Obtaining NCIRange
3. Installation
4. Usage

*********************
1. System Requirement 
*********************
NCIRange is a Perl script, the main requirement in the computer is a Perl interpreter. This is already installed by default in all of Unix-type operating systems. In Windows operating system there is two popular distributions: Active State (https://www.activestate.com/activeperl) and \Strawberry Perl (http://strawberryperl.com).

*********************
2. Obtaining NCIRange
********************* 
The NCIRange script and additional files can be requested to the author by writing an email to nestorcubillan@mail.uniatlantico.edu.co.

*********************
3. Installation
*********************
The installation in Unix-type operating systems is straightforward. For an all-users installation type the following commands as root:

mypc@root:~$ chmod ugo+x ncirange.pl
mypc@root:~$ cp ncirange.pl /usr/local/bin

In the case of a single-user installation in the HOME user types:

mypc@myuser:~$ mkdir bin
mypc@myuser:~$ chmod u+x ncirange.pl
mypc@myuser:~$ cp ncirange bin/
mypc@myuser:~$ vi .bashrc

Add the line

export PATH = $PATH:/home/myuser/bin

Save and run the command:

mypc@myuser:~$ source .bashrc

In Windows Operating System:

C:\Users\myuser> perl -le "print $^X"

Copy the output (e.g. C:\perl\bin\perl.exe), run the following commands:

C:\Users\myuser> assoc .pl=PerlScript
C:\Users\myuser> ftype PerlScript=C:\perl\bin\perl.exe "%1" %*

Here, the folder containing the script can be moved to "C:\Program files" or another location and added to the PATH.

******************
4. Usage
******************
NCIRange is a command-line driven script. Its generic format is:

ncirange.pl -prefix XXX -range AA,BB:CC,DD -sign -vmd

The arguments:
 -prefix or -p    Prefix to cube files. eg. XXX-grad.cube and XXX-dens.cube
  -range or -r    Range in ascendant order (AA$<$BB and CC$<$DD). Several ranges should be separated by colon (:)
   -sign or -s    (OPTIONAL) The RDG values are extracted with the sign and value of the density. 
    -vmd or -v    (OPTIONAL) Generate VMD file to plot RDG range
   -help or -h    Print Help and exit
-version or -V    Print version information and exit

The script generates a new file with RDG values in the given range. The name of the output file is XXX-rang.cube. If -vmd option is typed a file XXX-rang.vmd is created.
