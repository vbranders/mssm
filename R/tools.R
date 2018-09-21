#' Get the required JAR for the [mssm] package
#'
#' Lists Java classes of the [mssm] package
#'
#' Lists all Java classes and their associated location.
#'
#' @return It returns a named vactor of the class locations.
#' @seealso [mssm.jInst()] for the instanciation of java Objects.
#' See also package [mssm].
mssm.listClasses<-function(){
    classes = c("uclouvain/mssm/utils/Helper", "uclouvain/mssm/utils/SubMatrix", "uclouvain/mssm/cp/CPGC")
    names(classes) = c("Helper", "SubMatrix", "CPGC")
    return(classes)
    # a = as.matrix(read.table('inst/names.txt', header = F, sep = "\t", row.names = 1, colClasses = "character"))
    # classes = as.vector(a[,1])
    # names(classes) = rownames(a)
    # return(classes)
}

#' Instanciation of Java objects
#'
#' This function retrieves a Java instance of a named class.
#' The class names and locations are listed by [mssm.listClasses()].
#'
#' @param name a string corresponding to the name of the class as
#' indicated by [mssm.listClasses()].
#' @return A Java instance of the named class.
#' @seealso \code{\link{mssm.listClasses}} for a list of possible class
#' names. See also package [mssm].
mssm.jInst<-function(name){
    if(name %in% names(mssm.listClasses())){
        return(J(mssm.listClasses()[name]))
    } else {
        stop(paste0("Argument `name`(=", name, ") is not valid. Uses `mssm.listClasses()` to determines the possible values for `name`."))
    }
}


#' Load a Java Matrix from file
#'
#' Produces a Java two-dimensionnal array of double (a Java Matrix) from
#' a file.
#' Java Matrices are the standard type used for subsequent analysis with
#' the [mssm] package.
#'
#' @param filePath the name of the file which the data are to be read from.
#' @param sep the field separator character.
#' @return A Java two-dimensionnal array of double (called Java Matrix).
#' @seealso [mssm.asJavaMatrix()] and [mssm.fromJavaMatrix()] to transform
#' a matrix into a Java Matrix and conversely. See also package [mssm].
#' @export
mssm.loadMatrix<-function(filePath='data.tsv', sep='\t'){
    JHelper = mssm.jInst("Helper")
    return(JHelper$loadMatrix(filePath, sep))
}


#' Transform a matrix into a Java Matrix
#'
#' Produces a Java two-dimensionnal array of double (a Java Matrix) from
#' a R matrix.
#' Java Matrices are the standard type used for subsequent analysis with
#' the [mssm] package.
#'
#' @param matrix a matrix to be transformed into a Java Matrix.
#' @return A Java two-dimensionnal array of double (called Java Matrix).
#' @seealso [mssm.fromJavaMatrix()] to transform a Java Matrix into a
#' matrix and [mssm.loadMatrix()] to load a Java Matrix from a file.
#' See also package [mssm].
#' @export
mssm.asJavaMatrix<-function(matrix){
    if(!is.matrix(matrix)){
        stop("Argument `matrix` should be a matrix.")
    } else {
        JHelper = mssm.jInst("Helper")
        return(JHelper$vectorToMatrix(as.vector(matrix), as.integer(dim(matrix)[1]), as.integer(dim(matrix)[2])))
    }
}



#' Transform a Java Matrix into a matrix
#'
#' Produces a R matrix from a Java two-dimensionnal array of double
#' (a Java Matrix).
#' Java Matrices are the standard type used for subsequent analysis
#' with the [mssm] package.
#'
#' @param javaMatrix a Java two-dimensionnal array of double (called
#' Java Matrix).
#' @return A standard R matrix.
#' @seealso [mssm.toJavaMatrix()] to transform a matrix into a Java
#' Matrix and [mssm.loadMatrix()] to load a Java matrix from a file.
#' See also package [mssm].
#' @export
mssm.fromJavaMatrix<-function(javaMatrix){
    if(!mssm.isValid(javaMatrix, '[[D')){
        stop("Argument `javaMatrix` should be a Java two-dimensionnal array of double.")
    } else {
        JHelper = mssm.jInst("Helper")
        vector = JHelper$matrixToVectorR(javaMatrix)
        return(matrix(vector[1:(length(vector)-2)], nrow = vector[length(vector)-1], ncol = vector[length(vector)]))
    }
}

