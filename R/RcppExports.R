# Generated by using Rcpp::compileAttributes() -> do not edit by hand
# Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#' Function signals to the server through shared memory region to terminate from 
#' its main loop and then deletes the client CSharedMemory object
StopServer <- function() {
    invisible(.Call('MagmaGPU_StopServer', PACKAGE = 'MagmaGPU'))
}

#' Called when the package is unloaded or R terminated - it releases the shared memory objects that are used to communicate with the syevd_server executable
.CleanupSharedMemory <- function() {
    .Call('MagmaGPU_CleanupSharedMemory', PACKAGE = 'MagmaGPU')
}

#' Initialise shared memory on client and obtain server launch string.
#' @description This function will create a CSharedMemory object that initialises the shared memory region and the semaphore used for comms beteween client and server.
#' If the object is already initialised it is removed and reinitialised. 
#' Returns a string of the form "-n 10000 -v 1 -g 3 -m /syevx_<PID_of_client> -s /sem_<PID_of_client> -p" that can be used to launch a nonsyevd_server process
#' that will accept matrix data on which to perform eigenvalue decomposition 
#' @param matrixDimension   - type (integer) - the dimension of the (assumed square) matrix
#' @param numGPUsWanted     - type (string)  - The number of GPUs to use in for the symmetric eigenvalue (syevd) computation
#' @param withVectors       - type (boolean) - true = We want the eigenvectors and eigenvalues calculated ; false = we only want eigenvalues calculated
#' @param memName           - type (string)  - a name to give to the named shared memory region (will be created in /dev/shm/) and defaults to the user name if nothing specified
#' @param semName           - type (string)  - a name to give to the semaphore (will be placed in /dev/shm) and defaults to the user name if nothing specified
#' @param printDetails      - type (integer 0|1|2) - 0 = don't print, 1 = print details of server progress to screen; 2 = print to log (not functional)
#' @return                  - type (string) A string that can be used a command line arguments to run the nonsyevd_server executable
GetServerArgs <- function(matrixDimension, withVectors, numGPUsWanted, memName, semName, printDetails) {
    .Call('MagmaGPU_GetServerArgs', PACKAGE = 'MagmaGPU', matrixDimension, withVectors, numGPUsWanted, memName, semName, printDetails)
}

#' Function used to obtain the eigenvalue decomposition (EVD) of a matrix using a MAGMA 2-stage multi-gpu EVD algorithm
#' @description This function performs the eigenvalue decomposition of the input matrix and returns the eigenvalues and (if requested) the 
#' eigenvectors of the input matrix in the returned list, identical to the base R eigen() function. If overwrite=TRUE then the eigenvectors are copied into the ***input matrix*** and the original matrix 
#' data is overwritten. 
#' The method involves the offload of the matrix data to a seperate nonsyevd_server executable by copying data into a shared memory area and 
#' signalling to the server that the data is availble. This function will block until the server has completed the decomposition. The 
#' function checks that the input is square, however it does not check that the matrix is symmetric.
#' N.B. The maximum size allowed of the input matrix is goverend by what was provided in the MagmaGPU::RunServer() function. The server 
#' will automatically be restarted with a larger shared memory area if user wants to perorm EVD on a larger matrix.
#' @param matrix - the input matrix to be used in eigenvalue decomposition. It is assumed to be square 
#' @param symmetric - the input is assumed to be symmetric and real. Function will fail if symmetric=FALSE.
#' @param only_values - If TRUE: only compute eigenvalues. If FALSE: Compute eigenvectors also. 
#' @param overwrite - If TRUE: The resulting eigenvectors (if requested) will overwrite the input matrix to potentially reduce memory requirements. 
#' @param printInfo - Prints diagnostic information about the client processing
#' @return A list that contains the eigenvalues and if requested the eignenvectors. If overwrite==TRUE then the eignevectors are copied into the ***input matrix***
eigen_nonsym_mgpu <- function(matrix, symmetric = FALSE, only_values = FALSE, overwrite = FALSE, printInfo = FALSE) {
    .Call('MagmaGPU_eigen_nonsym_mgpu', PACKAGE = 'MagmaGPU', matrix, symmetric, only_values, overwrite, printInfo)
}



#' Function used to obtain the eigenvalue decomposition (EVD) of a matrix using a MAGMA 2-stage multi-gpu EVD algorithm
#' @description This function performs the eigenvalue decomposition of the input matrix and returns the eigenvalues and (if requested) the 
#' eigenvectors of the input matrix in the returned list, identical to the base R eigen() function. If overwrite=TRUE then the eigenvectors are copied into the ***input matrix*** and the original matrix 
#' data is overwritten. 
#' The method involves the offload of the matrix data to a seperate syevd_server executable by copying data into a shared memory area and 
#' signalling to the server that the data is availble. This function will block until the server has completed the decomposition. The 
#' function checks that the input is square, however it does not check that the matrix is symmetric.
#' N.B. The maximum size allowed of the input matrix is goverend by what was provided in the MagmaGPU::RunServer() function. The server 
#' will automatically be restarted with a larger shared memory area if user wants to perorm EVD on a larger matrix.
#' @param matrix - the input matrix to be used in eigenvalue decomposition. It is assumed to be square 
#' @param symmetric - the input is assumed to be symmetric and real. Function will fail if symmetric=FALSE.
#' @param only_values - If TRUE: only compute eigenvalues. If FALSE: Compute eigenvectors also. 
#' @param overwrite - If TRUE: The resulting eigenvectors (if requested) will overwrite the input matrix to potentially reduce memory requirements. 
#' @param printInfo - Prints diagnostic information about the client processing
#' @return A list that contains the eigenvalues and if requested the eignenvectors. If overwrite==TRUE then the eignevectors are copied into the ***input matrix***
eigen_mgpu <- function(matrix, symmetric = TRUE, only_values = FALSE, overwrite = FALSE, printInfo = FALSE) {
    .Call('MagmaGPU_eigen_mgpu', PACKAGE = 'MagmaGPU', matrix, symmetric, only_values, overwrite, printInfo)
}


solve_mgpu <- function(matrix){
.Call('MagmaGPU_solve_mgpu', PACKAGE = 'MagmaGPU', matrix )
}



