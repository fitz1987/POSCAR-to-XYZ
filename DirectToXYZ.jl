# DirectToXYZ.jl
# this script converts a matrix of direct, fractional coordinates
# such as you might find in a POSCAR (VASP) file
# into standard cartesian coordinates


# INPUT: files: lattice-vectors and direct-list & it will ask you for the value of Factor
# Files: lattice-vectors contains lattice vectors, a 3x3 list of their xyz components
#        direct-list is a nx3 list of direct coordinates
# Factor = the scaling factor for the fractional coordinates
# OUTPUT: file coords.txt containing standard cartesian coordinates

# type info: All numbers in this script are Float64. 

# get the scaling factor for the fractional/direct coordinates. 
println("What is the scaling factor? Enter a Float64")
Factor=parse(Float64, readline())
println("Factor=", Factor)

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
XList=DirectList[1:54,1]
YList=DirectList[1:54,2]
ZList=DirectList[1:54, 3]


function UnscaleX(Factor::Float64, XList::Array{Float64}, a::Array{Float64})
 CarteX=zeros(XList)
 n=size(XList,1)
 for i in 1:n
  CarteX[i]= Factor*(XList[i]*a[1] + XList[i]*a[2] + XList[i]*a[3])
 end
 CarteX
end

function UnscaleY(Factor::Float64, YList::Array{Float64}, b::Array{Float64})
 CarteY=zeros(YList)
 n=size(YList,1)
 for i in 1:n 
  CarteY[i]=Factor*(YList[i]*b[1] + YList[i]*b[2] + YList[i]*b[3])
 end
 return CarteY
end 

function UnscaleZ(Factor::Float64, ZList::Array{Float64}, c::Array{Float64})
 CarteZ=zeros(ZList)
 n=size(ZList,1)
 for i in 1:n
  CarteZ[i]=CartesianZList=Factor*(ZList[i]*c[1] + ZList[i]*c[2] + ZList[i]*c[3])
 end
 return CarteZ
end 

FinalX=zeros(XList)
FinalY=zeros(YList)
FinalZ=zeros(ZList)

FinalX=UnscaleX(Factor, XList, a)
FinalY=UnscaleY(Factor, YList, b)
FinalY=UnscaleZ(Factor, ZList, c)

println("FinalX:", FinalX)
println("FinalY:", FinalY)
println("FinalZ", FinalZ)
writedlm("coords.txt", [FinalX FinalY FinalZ], '\t')
#
