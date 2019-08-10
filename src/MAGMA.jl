module MAGMA
using CUDAdrv, CUDAapi, CUDAnative, CuArrays

export magma_gels!, gesvd!, gesdd!, magmaInit, magmaFinalize, magma_gebrd!

# MAGMA enum constants
# the whole file will be stored as enums.jl
#just like in JuliaGPU/MAGMA.jl

# MAGMA constants indicating the vectors status
# as input/output for some functions
# For example, the gesvd functions will use
# MagmaNoVec, MagmaSomeVec, MagmaAllVec and
# MagmaOverwriteVec to indicate the
# strategies that will be applied to the SVD
# U matrix and VT matrix in A = U Σ V**T
# (for MagmaOverwriteVec it is going to overwrite A)
include("enums.jl")


"""
the path to magma binary
"""
const libmagma = "/usr/local/magma/lib/libmagma.so"

macro magmafunc(function_name)
    return Expr(:quote, Symbol("magma_", function_name))
end

# >>> The following are some Utility functions' wrappers >>>
# magma_init
function magmaInit()
	success = ccall((:magma_init, libmagma),Cint,())
	if success != 0
		println("MAGMA initiation error with success = ", success)
	end
end

# magma_finalize
function magmaFinalize()
	ccall((:magma_finalize, libmagma),Cint,())
end

# <<< End of wrappers for Utility

# include the files of subroutines
include("dense/dense.jl")

end  # modul MAGMA
