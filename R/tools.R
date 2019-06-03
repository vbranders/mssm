#' Lists Java classes of the [mssm] package
#'
#' Lists all Java classes and their associated location.
#'
#' @return It returns a named vactor of the class locations.
#' @section Maintainer: Vincent Branders <vincent.branders\@uclouvain.be>.
#' @seealso [mssm.jInst()] for the instanciation of java Objects.
#' See also package [mssm].
mssm.listClasses<-function(){
    classes = c("uclouvain/mssm/utils/Helper", "uclouvain/mssm/utils/SubMatrix", "uclouvain/mssm/cp/CPGC")
    names(classes) = c("Helper", "SubMatrix", "CPGC")
    return(classes)
}

#' Instanciation of Java objects
#'
#' This function retrieves a Java instance of a named class.
#' The class names and locations are listed by [mssm.listClasses()].
#'
#' @param name a string corresponding to the name of the class as
#' indicated by [mssm.listClasses()].
#' @return A Java instance of the named class.
#' @section Maintainer: Vincent Branders <vincent.branders\@uclouvain.be>.
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
#' @section Maintainer: Vincent Branders <vincent.branders\@uclouvain.be>.
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
#' @section Maintainer: Vincent Branders <vincent.branders\@uclouvain.be>.
#' @seealso [mssm.fromJavaMatrix()] to transform a Java Matrix into a
#' matrix and [mssm.loadMatrix()] to load a Java Matrix from a file.
#' See also package [mssm].
#' @export
mssm.asJavaMatrix<-function(matrix){
    #Tests if it is a Java matrix
    if(mssm.isJavaRectArray(matrix)){
        return(matrix)
    # } else if(mssm.isJava(matrix)){
    #     warning("Argument `matrix` must be a R matrix, not a (non matrix) Java object.")
    }
    # } else {
        #Tests that matrix is a matrix
        if(!is.matrix(matrix)){
            #Test if can coerce to matrix
            matrix = mssm.testWarning(as.matrix(matrix), 'Argument `matrix` cannot be coerced to matrix. Warning while doing as.matrix(matrix).', stop=1)
            #Test if can coerce to numeric
            matrix = mssm.testWarning(as.numeric(matrix), 'Argument `matrix` cannot be coerced to numeric Warning while doing as.numeric(matrix).', stop=1)
            return(mssm.internal.asJavaMatrix(matrix))
        }
    # }
}

mssm.internal.asJavaMatrix<-function(matrix){
    #Assumes that matrix is a R matrix
    JHelper = mssm.jInst("Helper")
    return(JHelper$vectorToMatrix(as.vector(matrix), as.integer(dim(matrix)[1]), as.integer(dim(matrix)[2])))
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
#' @section Maintainer: Vincent Branders <vincent.branders\@uclouvain.be>.
#' @seealso [mssm.asJavaMatrix()] to transform a matrix into a Java
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


mssm.isJava<-function(o){
    return(mssm.isJavaObject(o) || mssm.isJavaClassName(o))
}
mssm.isJavaObject<-function(o){
    return(is(o, 'jobjRef'))
}
mssm.isJavaArray<-function(o){
    return(is(o, 'jarrayRef')) #subclass of jobjRef
}
mssm.isJavaRectArray<-function(o){
    return(is(o, 'jrectRef')) #subclass of jobjRef
}
mssm.isJavaClassName<-function(o){
    return(is(o, 'jclassName'))
}

mssm.testWarning<-function(call, msg, stop=0){
    resCall = tryCatch(call,error=function(e) e, warning=function(w) w)
    if(is(resCall,"warning")){
        if(stop == 1){
            stop(msg)
        } else {
            warning(msg)
            return(resCall)
        }
    } else {
        return(resCall)
    }
}


###----------------------------------------


#' Ensures type of objects
#'
#' Ensures that object `object` is of type `class` and return a boolean. If type is not valid, it generates a warning.
#'
#' @param object a Java object to be validated.
#' @param class the type that should be matched by `object`.
#' @return A boolean indicating if the object is of expected type.
#' @section Maintainer: Vincent Branders <vincent.branders\@uclouvain.be>.
#' @seealso \code{\link{.jinstanceof}}.
mssm.isValid<-function(object, class, silent=F){
    if(.jinstanceof(object, class)){
        return(TRUE)
    } else {
        if(!silent){
            warning("Wrong parameter type !")
        }
        return(FALSE)
    }
}


######
###### Internal function to check type of arguments
######
######
######
mssm.tools.as<-function(x, type){
    if(type == 'javaMatrix'){
        #Test if it is a rectangular java array
        if(mssm.isJavaRectArray(x)){
            #Test if it consist of a Java two-dimensionnal array of double
            if(mssm.isValid(javaMatrix, '[[D')){
                #Then returns it
                return(x)
            } else {
                #Matrix is not of double
                stop("Argument `x` should be a Java two-dimensionnal array of double.")
            }
        }
        #Try to coerce to matrix if not
        if(!is.matrix(x)){
            x = mssm.testWarning(as.matrix(x), 'Argument `x` cannot be coerced to matrix. Warning while doing as.matrix(x).', stop=1) #Interrupt of cannot coerce to matrix
        }
        #Try to coerce to numeric if not
        if(!is.numeric(x)){
            x = mssm.testWarning(apply(x, c(1,2), as.numeric), 'Argument `x` cannot be coerced to numeric. Warning while doing apply(x, c(1,2), as.numeric).', stop=1)
        }
        #x is a numeric matrix
        return(mssm.tools.as(mssm.internal.asJavaMatrix(x), type))
    }
}

test.separability = function(x){
    r = dim(x)[1]
    c = dim(x)[2]
    rowsP = rep(0, dim(x)[1]);rowsM = rep(0, dim(x)[1])
    colsP = rep(0, dim(x)[2]);colsM = rep(0, dim(x)[2])
    p = 0
    m = 0
    for(i in 1:dim(x)[1]){
        for(j in 1:dim(x)[2]){
            square = (x[i,j])
            if(x[i, j] > 0){
                p = p + square
                rowsP[i] = rowsP[i] + square
                colsP[j] = colsP[j] + square
            } else {
                m = m + square
                rowsM[i] = rowsM[i] + square
                colsM[j] = colsM[j] + square
            }
        }
    }
    if(p == 0 || m == 0){
        return (0)
    }
    matP = (rowsP %*% t(colsP))
    matM = (rowsM %*% t(colsM))
    dif = matP - matM
    return (((sum(abs(dif))))/((p^2+m^2)))
}
