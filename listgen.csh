#!/bin/csh

# 23 mar 17: digest a POSCAR file from VASP into the format
#            that the julia script understands

if (null$1 == null) then
 echo ''
 echo '$ a-listgen file Atom_1_Name Atom_2_Name Atom_3_Name Atom_4_Name' 
 echo '...where file is a POSCAR formatted file from VASP'
 echo '...Two atom names are required. The 3rd and 4th are optional.'
 echo '...this script chops up a POSCAR file into a format'
 echo '...that is convenient for DirectToXYZ.jl.'
 echo '...DirectToXYZ.jl will convert the fractional or direct coordinates'
 echo '...into standard cartesian format and save them to an .xyz file.'
 echo '...the usual workflow is to run this script followed by DirectToXYZ.jl'
 echo ''
 exit
endif

set file=$1
set Name1=$2 
set Name2=$3

if (null$4 != null) then 
 set Name3=$4
endif

if (null$5 != null) then
 set Name4=$5
endif

#-----Structure of a POSCAR file---------#
#line 1: comment line
# line 2: lattice scaling factor
# line 3,4,5: lattice vectors
# line 6: number of atoms per atomic species
# line 7: specifies type of coordinates being  used
# line 9 to end: coordinates
#---------------------------------------#

# get the list of atom types and how many of each
set howmany=`awk 'NR==6' $file`
#foo=$(echo ${'ARRAY[*]}'
echo ${howmany[*]}
set number_of_atom_types=`$(echo ${howmany[*]})`
echo $number_of_atom_types '=number of atom types'
echo $howmany[1] 

# print the atom names for 1st and 2nd atom types to temp file
set n=1
while ( $n <= $howmany[1])
 echo $Name1 >> temp
 @ n++
end 

set m=1
while ($m <= $howmany[2])
 echo $Name2 >> temp
 @ m++
end 

# if present, print atom names for 3rd and 4th atom types to temp file
if (null$4 != null) then
 set s=1
 while ($s <= $howmany[3])
  echo $Name3 >> temp
  @ s++
 end 
endif 

if (null$5 != null) then
 set y=1
 while ($y <= $howmany[4])
  echo $Name4 >> temp
  @ y++
 end 
endif 

# cat line for debug; check that temp was generated correctly
cat temp
# rename temp so that it has the name DirectToXYZ.jl expects it to have
mv temp atomlist

# collect lattice vectors: they are the 3rd, 4th, and 5th lines of POSCAR file.
awk 'NR==3' $file >> lattice-vectors
awk 'NR==4' $file >> lattice-vectors
awk 'NR==5' $file >> lattice-vectors

# get the fractional, direct coordinates. 
# Print from the 8th line to the end of POSCAR to $file
awk 'NR > 7' $file >> direct-list

# This script does not clean up its temp files b/c DirectToXYZ.jl needs them.
# DirectToXYZ.jl will clean up all the temp files @ the end of its execution.
