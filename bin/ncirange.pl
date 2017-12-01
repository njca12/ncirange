#!/usr/bin/perl
use strict;
#########################################################################
#
#
#     ##   ##  #####  ##  ####   ######  ##   ##  ######  ######
#     ###  ##  ##     ##  ##  #  ##  ##  ###  ##  ##      ##
#     ## # ##  ##     ##  ####   ######  ## # ##  ######  ####
#     ##  ###  ##     ##  ## #   ##  ##  ##  ###  ##  ##  ##
#     ##   ##  #####  ##  ##  #  ##  ##  ##   ##  ######  ######
#  
#                 NCI-RANGE Script. Version 1.0.
#  This script takes the cube files produced by NCIPlot Software (http://
#  www.lct.jussieu.fr/pagesperso/contrera/nciplot.html) and extracts dens-
#  ity and reduced density gradients in the requested range. The Software 
#  gives a new reduced density gradients cube files. 
# 
#  Author: Nestor Cubillan, nestorcubillan@mail.uniatlantico.edu.co
#  Universidad del Atlantico, Barranquilla, Colombia.
#  2017
# 
#########################################################################
#    Copyright (C) 2017  Nestor Cubillan
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#     any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
###########################################################################
# Declaring variables
my $sign;
my @rngtxt;
my $prefix;
my $vmd = 0;

# Evaluating Arguments Array
if(!@ARGV){dieProcess()};
for (my $i=0; $i < scalar(@ARGV); $i++){
   if($ARGV[$i] eq '-help'    or $ARGV[$i] eq '-h'){helpPopUp()};
   if($ARGV[$i] eq '-version' or $ARGV[$i] eq '-V'){versPopUp()};
   if($ARGV[$i] eq '-prefix'  or $ARGV[$i] eq '-p'){$prefix = $ARGV[$i+1]};
   if($ARGV[$i] eq '-range'   or $ARGV[$i] eq '-r'){@rngtxt = split(":",$ARGV[$i+1]) };
   if($ARGV[$i] eq '-sign'    or $ARGV[$i] eq '-s'){$sign = 0};
   if($ARGV[$i] eq '-vmd'     or $ARGV[$i] eq '-v'){$vmd = 1};
}
if(!$prefix){dieProcess()};
if(!@rngtxt){dieProcess()};

# Open RDG and RHO cube files
open RDG, "<$prefix-grad.cube" or die "Cannot open $prefix-grad.cube";
my @rdglines = <RDG>;
close(RDG);
open RHO, "<$prefix-dens.cube" or die "Cannot open $prefix-dens.cube";
my @rholines = <RHO>;
close(RHO);

# Obtaining number of atoms (nat)
my $nat = substr($rdglines[2],0,5);


open RNG, ">$prefix-rang.cube" or die "Cannot open $prefix-rang.cube";
print RNG @rdglines[0..$nat+5];
# Looping in voxel data; the header text and coordinates are avoided
for (my $i = $nat+6; $i < scalar(@rdglines); $i++){
   my @tmp1 = split(/\s+/,$rholines[$i]);
   shift @tmp1;
   my @tmp2 = split(/\s+/,$rdglines[$i]);
   shift @tmp2;
   my @tmp3 = (100) x scalar(@tmp2);
   my $line;
   for (my $j=0; $j < scalar(@tmp2); $j++){
      my $value = $tmp1[$j]/100.0;
      if($sign){$value = abs($value)};
      for (my $k = 0; $k < scalar(@rngtxt); $k++){
         my ($inirho, $endrho) = sort { $a <=> $b } split(",",$rngtxt[$k]);
         if(($value > $inirho) && ($value < $endrho)){$tmp3[$j] = $tmp2[$j]};
      }
      $line = $line.(sprintf "%13.5E", $tmp3[$j]);
   }
   print RNG $line,"\n";
}
close(RNG);

if($vmd == 1){
my $vmdtxt = "#!/usr/local/bin/vmd
set viewplist
set fixedlist
# Display settings            
display projection   Orthographic
display nearclip set 0.000000
# load new molecule         
mol new $prefix-dens.cube type cube first 0 last -1 step 1 filebonds 1 autobonds 1 waitfor all
mol addfile $prefix-rang.cube type cube first 0 last -1 step 1 filebonds 1 autobonds 1 waitfor all
#
# representation of the atoms
mol delrep 0 top
mol representation Lines 1.00000
mol color Element
mol selection {all}
mol material Opaque
mol addrep top
mol representation CPK 1.000000 0.300000 118.000000 131.000000
mol color Element
mol selection {all}
mol material Opaque
mol addrep top
#
# add representation of the surface
mol representation Isosurface 0.50000 1 0 0 1 1
mol color Volume 0
mol selection {all}
mol material Opaque
mol addrep top
mol selupdate 2 top 0
mol colupdate 2 top 0
mol scaleminmax top 2 -4.0000 4.0000
mol smoothrep top 2 0
mol drawframes top 2 {now}
color scale method BGR
set colorcmds {{color Name {C} gray}}
#some more";

open VMD, ">$prefix-rang.vmd" or die "Cannot open $prefix-rang.vmd";
print VMD $vmdtxt;
close(VMD);

}

sub dieProcess{ die "Basic usage: ncirange -prefix XXX -range AAA,BBB:CCC,DDD -sign\n" };

sub helpPopUp{
   print "ncirange - NCI range extractor 0.1 (2017 Jun 09)

usage: ncirange -prefix XXX -range AA,BB:CC,DD -sign    Basic usage, read arguments to

Arguments:
   -prefix XXX		Prefix to cube files. E.g. XXX-grad.cube and XXX-dens.cube
   -p XXX	        
   -range AA,BB:CC,DD   Range in ascendent order (AA<BB) separated by comma, several
   -r AA,BB:CC,DD       ranges must be separated by colon (:)
   -sign or -s		(OPTIONAL) Signed density is considered to extract RDG 
   -vmd or -v           (OPTIONAL) If required a VMD file is generated
   -help  or  -h	Print Help (this message) and exit
   -version or -V	Print version information and exit\n";
    exit
};

sub versPopUp{
   print "ncirange - NCI range extractor
Version 1.0 (2017 Jun 09)
Universidad del Atlántico - Barranquilla, Colombia
Programa de Química, Facultad de Ciencias Básicas
Dr. Néstor Cubillán (nestorcubillan\@mail.uniatlantico.edu.co)\n";
   exit
};
