#= DirectToXYZ.jl
this script converts a matrix of direct, fractional coordinates
such as you might find in a POSCAR (VASP) file
 into standard cartesian coordinates


 INPUT: files: lattice-vectors, direct-list, atomlist
               & it will ask you for the value of Factor
 Files: lattice-vectors contains lattice vectors, a 3x3 list of their xyz components
        direct-list is a nx3 list of direct coordinates
 Factor = the scaling factor for the fractional coordinates
 OUTPUT: file coords.txt containing standard cartesian coordinates

 type info: All numbers are Float64.
=#
# get the scaling factor for the fractional/direct coordinates.
println("What is the scaling factor? Enter a Float64")
Factor=parse(Float64, readline())
println("Factor=", Factor)

# get the atomlist file into an array
AtomList=readdlm("atomlist")

# set the Lattice Vectors a, b, and c. Each is a 1x3 vector.
# having components e.g. ax, ay, az.

LatticeVectors=readdlm("lattice-vectors")
a=LatticeVectors[1:1,:]
b=LatticeVectors[2:2,:]
c=LatticeVectors[3:3,:]
println("...the lattice vectors are:")
println("a=", a)
println("b=", b)
println("c=", c)

DirectList=readdlm("direct-list")

n=size(DirectList,1)
XList=DirectList[1:n,1]
YList=DirectList[1:n,2]
ZList=DirectList[1:n,3]

# this is the old version of the functions. they were all identical except 
# for interchanging the name of the coordinate.
#function UnscaleX(Factor::Float64, XList::Array{Float64}, a::Array{Float64})
# CarteX=zeros(XList)
# n=size(XList,1)
# for i in 1:n
#  CarteX[i]= Factor*(XList[i]*a[1] + XList[i]*a[2] + XList[i]*a[3])
# end
# CarteX
#end

function UnscaleX(Factor::Float64, XList::Array{Float64}, YList::Array{Float64}, ZList::Array{Float64}, a::Array{Float64}, b::Array{Float64}, c::Array{Float64})
 CarteX=zeros(XList)
 n=size(XList, 1)
 for i in 1:n
   CarteX[i]=Factor*(XList[i]*a[1] + YList[i]*b[1] + ZList[i]*c[1])
 end
 CarteX
end


function UnscaleY(Factor::Float64, XList::Array{Float64}, YList::Array{Float64}, ZList::Array{Float64}, a::Array{Float64}, b::Array{Float64}, c::Array{Float64})
 CarteY=zeros(YList)
 n=size(YList, 1)
 for i in 1:n
  CarteY[i]=Factor*(XList[i]*a[2] + YList[i]*b[2] + ZList[i]*c[2])
 end
 CarteY
end 

function UnscaleZ(Factor::Float64, XList::Array{Float64}, YList::Array{Float64}, ZList::Array{Float64}, a::Array{Float64}, b::Array{Float64}, c::Array{Float64})
 CarteZ=zeros(ZList)
 n=size(ZList,1)
 for i in 1:n
  CarteZ[i]=Factor*(XList[i]*a[3] + YList[i]*b[3] + ZList[i]*c[3])
 end
 CarteZ
end

FinalX=zeros(XList)
FinalY=zeros(YList)
FinalZ=zeros(ZList)

FinalX=UnscaleX(Factor, XList, YList, ZList, a, b, c)
FinalY=UnscaleY(Factor, XList, YList, ZList, a, b, c)
FinalZ=UnscaleZ(Factor, XList, YList, ZList, a, b, c)

# Format results and save to an XYZ file
n=size(YList, 1)
println("Enter the text (< 80 chars) for the comment line of the xyz file:")
println("This is commonly the empirical formula of the system, or something descriptive")
CommentLine=readline()
write("commentline.txt", "$CommentLine")
writedlm("natom.txt", n)
writedlm("coords.txt", [AtomList FinalX FinalY FinalZ], '\t')
println("coordinates have been converted to XYZ format and saved in coords2.xyz.")
run(pipeline(`cat natom.txt commentline.txt coords.txt`, stdout="coords2.xyz"))

# clean up temp and .txt files before exiting
  run(`\rm natom.txt commentline.txt coords.txt`)
# run(`\rm lattice-vectors direct-list atomlist`)
#
