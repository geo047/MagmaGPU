\name{rcppMagmaSYEVD}
\alias{rcppMagmaSYEVD}
\docType{package}
\title{
 rcppMagmaSYEVD - provides a fast replacement for the eigen() function, using a 2 stage GPU based MAGMA library routine. Also provides a function that returns the sqrt and inverse sqrt of an input matrix.
}
\description{
Implements the symmetric eigenvalue decomposition using the MAGMA library (http://icl.cs.utk.edu/magma/index.html) 2-stage multi-GPU implementation with 64 bit integer interface. Currently only for real symmetric matricies. In this case it provides a direct replacement for R function eigen(symmetric=T) and also provides an efficient function for producing the square root and inverse square root of the input matrix. The package uses the 64 bit integer MAGMA library by a client-server shared memory architecture. This removes the problem that can arrise with larger datasets where R only provides the 32 bit BLAS/LAPACK interface.  The server side code checks how many GPUs are present so the client side R package code does not require CUDA/other interface to be present. The server side code requires the MAGMA library to be available (http://icl.cs.utk.edu/magma/) compiled as position independent code (shared library) with a multi-threaded high performance LAPACK and -DMAGMA_ILP64 defined (an example make.inc file should be available in MAGMA download package). The server code also requires an OpenCL library to be installed which is used to get the number of GPUs present on a system. This package can be used in conjunction with HiPLARb and HiPLARM that require high performance, but single-threaded BLAS routines, which will then degrade the performance of some routines (such as eigen() and possibly svd()) which require a multi threaded BLAS to operate effectively.

Compilation of the R package the 'client side' code:
Optionally set MAGMA_HOME and CUDA_ROOT as per the server side instructions. This will alow the client to compile the server code during package install.
Setting the OpenCL platform string and device type:


Compilation of the 'server side' code:
Requires environment variables MAGMA_HOME to be set to where the MAGMA install is present. MAGMA_HOME=/usr/local/magma is the default.
The CUDA version of MAGMA requires CUDA_ROOT to be set CUDA_ROOT=/usr/local/cuda is the default.
The server code uses OpenCL to determine how many GPUs are present on the system it is being run on.
The default platform string is stored in a file in <R library path>/rcppMagamSYEVD/extdata/platformstring.txt and contains the default platform string "NVidia", and the default device is set to "GPU". See the platformstring.txt file for other options.
If these libraries and variables are set correctly then the server side code will be compiled automatically when the package is installed. If failing installation on install then whenerver the package is loaded into the R environment using library(rcppMagmaSYEVD) the system will attempt to compile the server code.


N.B. Calling the eigen_mgpu() function with argument overwrite=TRUE will cause an *overwrite of the input matrix data* with the eigenvectors of the original matrix data (if they are requested). This is done to potentialy reduce the memory footprint of the function. If overwrite=TRUE then please ensure the original matrix is copied if the data needs to be used after the function is called. Using overwrite=FALSE will return the usual list of results in $vectors and $values list items of the result object.

}
\details{
\tabular{ll}{
Package: \tab rcppMagmaSYEVD\cr
Type: \tab Package\cr
Version: \tab 1.0.0\cr
Date: \tab 2016-02-01\cr
License: \tab GPL-3 + file LICENCE \cr
LazyLoad: \tab yes\cr
}

}
\author{
Josh Bowden, CSIRO

Maintainer: Josh Bowden <josh.bowden@csiro.au>
}
\references{
Stanimire Tomov, Jack Dongarra, Marc Baboulin, Towards dense linear algebra for hybrid GPU accelerated manycore systems, Parallel Computing, Volume 36, Issues 5-6, June 2010, Pages 232-240, ISSN 0167-8191, http://dx.doi.org/10.1016/j.parco.2009.12.005.

@article{
    title     = {{Towards dense linear algebra for hybrid GPU accelerated manycore systems}},
    author    = {Stanimire Tomov and Jack Dongarra and Marc Baboulin},
    booktitle = {Parallel Matrix Algorithms and Applications},
    doi       = {10.1016/j.parco.2009.12.005},
    issn      = {0167-8191},
    journal   = {Parallel Computing},
    month     = jun,
    number    = {5-6},
    pages     = {232--240},
    posted-at = {2010-12-17 09:48:58},
    priority  = {2},
    volume    = {36},
    year      = {2010}
}

Solca, Raffaele; Haidar, Azzam; Tomov, Stanimire; Schulthess, Thomas C.; Dongarra, Jack, "Abstract: A Novel Hybrid CPU-GPU Generalized Eigensolver for Electronic Structure Calculations Based on Fine Grained Memory Aware Tasks," in High Performance Computing, Networking, Storage and Analysis (SCC), 2012 SC Companion: , vol., no., pp.1338-1339, 10-16 Nov. 2012
doi: 10.1109/SC.Companion.2012.173

@article{Haidar:2014:NHC:2747699.2747703,
 author = {Haidar, Azzam and Tomov, Stanimire and Dongarra, Jack and Solc\`{a}, Raffaele and Schulthess, Thomas},
 title = {A Novel Hybrid CPU-GPU Generalized Eigensolver for Electronic Structure Calculations Based on Fine-grained Memory Aware Tasks},
 journal = {Int. J. High Perform. Comput. Appl.},
 issue_date = {May       2014},
 volume = {28},
 number = {2},
 month = may,
 year = {2014},
 issn = {1094-3420},
 pages = {196--209},
 numpages = {14},
 url = {http://dx.doi.org/10.1177/1094342013502097},
 doi = {10.1177/1094342013502097},
 acmid = {2747703},
 publisher = {Sage Publications, Inc.},
 address = {Thousand Oaks, CA, USA},
 keywords = {Eigensolver, GPU, electronic structure calculations, generalized eigensolver, high performance, hybrid, multicore, two-stage},
} 

}

\keyword{ rcppMagmaSYEVD, magma, MAGMA, eigen, GPU, EVD  }
\seealso{
eigen
}
\examples{
\dontrun{
# Initialisation:

  numgpus <- 1 
  maxMatrixSize <- 5000  # the server will fail if the matrix sized passed to it is greater than this value
  if (numgpus > 0) # use MAGMA GPU eigen_mgpu() 
	{
		if (require(rcppMagmaSYEVD))
		{
			RunServer(  numGPUsWanted=numgpus, matrixMaxDimension=maxMatrixSize,  memName="/syevd_mem", semName="/syevd_sem", print=1)			
		}	else {
		  numgpus <- 0  # Package is not available so set numgpus to zero and use original eigen() using LAPACK 
    }
	}
  
# Usage:
  size <- 2000
  
  // Do not use GPU version if matrix size is small - 
  if (size < 1000){ 
    numgpus <- 0
  }
  
  set.seed(42)
  elems <- size * size
  V <- matrix(runif(elems),size)
  V <- crossprod(V)
	if (numgpus == 0) { 
    # CPU version 
		evdresult <- eigen( V, symmetric=T, only.values=F )
	} else if (numgpus > 0) {
    # GPU version
		evdresult <- eigen_mgpu( V, symmetric=T, only_values=F, overwrite=T) # from the rcppMagmaSYEVD package
  }
  # N.B. If overwrite=T, the V matrix will now contain the eignevalues of the original V data matrix
  # Use overwrite=F to obtain an identical data structure as the original R eigen() function, 
  # without overwriting the input matrix.
	

# Close:
	# The server program will be terminated when the R session exits or the package is unloaded.
	# To terminate manually, run the following which gets the R (client) to signal to the server to exit.
	StopServer() 
} # end of dontrun

# Basic tests for correctness:

  size <- 1000
	library(rcppMagmaSYEVD)
	RunServer(numGPUsWanted=1, matrixMaxDimension=size, memName="/syevd_mem", semName="/syevd_sem", print=0)
	set.seed(42)
	elems <- size * size
	system.time(r1 <- matrix(runif(elems),size))
	system.time(r1 <- crossprod(r1))
	set.seed(42)
	elems <- size * size
	system.time(r2 <- matrix(runif(elems),size))
	system.time(r2 <- crossprod(r2))  # make input symmetric

	system.time(r2_gpus <- eigen_mgpu(r2, symmetric=TRUE, only_values=FALSE, overwrite=FALSE) )
	r2_gpus$vectors[1:5,1:5]
	r2_gpus$values[1:5]
	inv_evals_r2 <- diag(1.0/r2_gpus$values)
	system.time(r2_inv <- (r2_gpus$vectors) \%*\% inv_evals_r2 \%*\% t(r2_gpus$vectors)) 
	ident_r2 <- r2_inv \%*\% r2
	if ((sum(diag(ident_r2)) - size) < 0.0001) {
    message("PASSED")
  } else {
    message("FAILED")
  }

	# Compare with eigen()
	system.time(r1_eig <- eigen(r1,symmetric=TRUE))
	r1_eig$vectors[1:5,1:5]
	r1_eig$values[1:5]
	inv_evals_r1 <- diag(1.0/r1_eig$values)
	system.time(r1_inv <- r1_eig$vectors \%*\% inv_evals_r1 \%*\% t(r1_eig$vectors))  
	ident_r1 <- r1_inv \%*\% r1
  if ((sum(diag(ident_r1)) - size) < 0.0001) {
    message("PASSED")
  } else {
    message("FAILED")
  }

	# the server program will be terminated when the R session exits or the package is unloaded
	# to terminate manually:
	StopServer()  # Client signals to server to terminate
  

}