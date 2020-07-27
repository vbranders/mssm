#' @details
#' You are most likely to use [mssm.search.cpgc()] for the seach.
#' You might require [mssm.loadMatrix()] to load matrices into a Java
#' two-dimensionnal array of Double.
#' Alternatively, functons [mssm.asJavaMatrix()] and [mssm.fromJavaMatrix()]
#' allows conversion fom R to Java and vice versa.
#' @keywords internal
"_PACKAGE"
#> [1] "_PACKAGE"


#' Computes the upper bound of a matrix
#'
#' Computes the upper bound of a matrix. The upper bound is computed here
#' as the sum of all positive values.
#' This can be usefull to determines if the found solution match the upper
#' bound computed here as this means that the solution is an optimal solution.
#'
#' @param x a matrix or a Java two-dimensionnal array of double ([mssm.asJavaMatrix()]).
#' @return A numeric value corresponding to the sum of all positive values in
#' the matrix.
#' @section Maintainer: Vincent Branders <vincent.branders\@uclouvain.be>.
#' @seealso [mssm.asJavaMatrix()] and [mssm.search.cpgc()] for the
#' transformation of a matrix to a Java Matrix and the search of a submatrix
#' of maximal sum. See also package [mssm].
#' @export
mssm.getUpperBound<-function(x){
    javaMatrix = mssm.tools.as(x, 'javaMatrix')
    JHelper = mssm.jInst("Helper")
    return(JHelper$getUpperBound(javaMatrix))
}

#' Heuristic ordering of the columns
#'
#' Returns an ordering of the column indices to improve the search of
#' [mssm.search.cpgc()].
#' Columns are sorted on the descending sum of their positive entries.
#' This sum is computed as the sum of the entries (in the column) that
#' are positive.
#' The purpose of this function is to provide one (among many possible)
#' heuristic ordering of the columns to be used in the subsequent search.
#'
#' @param x a matrix or a Java two-dimensionnal array of double ([mssm.asJavaMatrix()]).
#' @return A vector of the columns indices to be investigated first (starting from zero).
#' @section Maintainer: Vincent Branders <vincent.branders\@uclouvain.be>.
#' @seealso [mssm.asJavaMatrix()] and [mssm.search.cpgc()] for the
#' transformation of a matrix to a Java Matrix and the search of a submatrix
#' of maximal sum. See also package [mssm].
#' @export
mssm.getHeuristicReordering<-function(x){
    javaMatrix = mssm.tools.as(x, 'javaMatrix')
    JHelper = mssm.jInst("Helper")
    return(JHelper$heuristicReordering(javaMatrix)+1)
}


###----------------------------------------

#' Searches for a Max-Sum Submatrix using CPGC
#'
#' Searches for a submatrix of maximal sum using a Constraint
#' Programming with Global Constraint approach.
#' See \strong{`Details`} section for informations on the search
#' performed and the criterion required to complete it.
#'
#' This function performs the search of a \emph{submatrix of maximal sum}
#' accordingly to its arguments.
#' A submatrix is a rectangular, non-necessarily contiguous, subset of rows
#' and of columns of a (larger) matrix.
#' A submatrix is of maximal sum if the sum of its entires (selected from
#' the original matrix) is of maximal sum.
#' The search is completed whenever it finds a provably optimal solution.
#' If parameter `lns` is \code{TRUE}, the search is completed whenever the
#' `lns.nRestarts` restarts have been done.
#' For some scenarios, one might wants to abort the search before completion.
#' This is doable through the combination of parameters `budget` and `convergence`.
#'
#' @param x a matrix or a Java two-dimensionnal array of double ([mssm.asJavaMatrix()]).
#' @param budget a limit to prevent long searches.
#' Its value is used in combination with parameter `convergence`.
#' It corresponds either to the maximum number of solutions without
#' improvement of the sum (if `convergence == "solution"`) or the
#' maximum number of seconds without improvements of the sum (if
#' `convergence == "time"`). See details of `convergence`.
#' @param convergence indicates criterions to abort the search. It can
#' be any of the following:
#' \describe{
#'    \item{`"none"` or `-1`}{The search is not aborted. It will stop
#'    only when completed, which means that the solution is optimal
#'    (if `lns == FALSE`) or all lns restarts are done.}
#'    \item{`"solution"` or `0`}{If the last `budget` solutions
#'    identified did not improve the sum, the search is aborted.}
#'    \item{`"time"` or `1`}{Abort the search if `budget` seconds have
#'    elapsed since the last improving solution was found. This is the
#'    default value.}
#' }
#' @param verbose indicates whether improving solutions should be
#' printed or not.
#' @param lowerBound is the expected minimum sum ot the submatrix to
#' find. No submatrix with sum below `lowerBound` will be considered
#' as a solution to store. Raising its value might improve the filtering
#' of non-optimal solution. This however can be diffucult to estimate
#' and a value above the optimal sum will prevent the identification of
#' any solution.
#' @param lightFilter reduces the computational cost of pruning the
#' search tree at the expense of a reduced filtering (if `lightFilter
#' == TRUE`). It is preferable to set it to \code{FALSE} for very
#' large matrices as one prefer a stronger filtering of sub-optimal
#' solutions, even at the expense of some additional computations.
#' @param variableOrdering is an ordering of the columns indices. It
#' indicates which columns should be considered first for the branching.
#' A \code{NULL} value is associated to the natural ordering (`1:j` if
#' `javaMatrix` has `j` columns). It appears that columns with many
#' positive entries should be considered first in the search. See
#' [mssm.getHeuristicReordering()] as an example of column ordering.
#' @param lns allows the use of a large neighborhood search: after a
#' given number `lns.failureLimit` of backtracking (non improving
#' solutions), the search is restarted while fixing `lns.restartFilter`
#' percent of the columns of the best solution found so far.
#' @param lns.nRestarts is the number of restarts to perform if `lns`
#' is \code{TRUE}.
#' @param lns.failureLimit is the number of backtracks allowed for each
#' large neighborhood search.
#' @param lns.maxDiscrepancy is a limite on the number of discrepancies.
#' In the search tree, a discrepancy is counted whenever one explores the
#' right child of a node. Small values prevent the search of the full
#' tree but visit only the left-most branches. This should be considered
#' when you are confident with the variable ordering (see parameter
#' `variableOrdering`).
#' @param lns.restartFilter is the percentage of the columns of the best
#' solution found so far to keep in subsequent search. More precisely, at
#' each lns restart, `lns.restartFilter/100` of the columns of the best
#' solution are fixed and the search is performed on the non-fixed columns.
#' @return A submatrix of maximal sum, represented as a list, with the
#' associated sum, columns and rows.
#' @section Maintainer: Vincent Branders <vincent.branders\@uclouvain.be>.
#' @seealso [mssm.asJavaMatrix()] and [mssm.loadMatrix()] to transform
#' a matrix to a Java matrix and to load a Java matrix from a file. See
#' also [mssm.getHeuristicReordering()] for an heuristic ordering of the
#' columns. See also package [mssm].
#' @export
#' @importFrom methods new
mssm.search.cpgc<-function(x, budget = 10, convergence = 'time', verbose = FALSE, lowerBound = 0, lightFilter = FALSE, variableOrdering = NULL, lns = FALSE, lns.nRestarts = 100, lns.failureLimit = 500, lns.maxDiscrepancy = 2, lns.restartFilter = 70){
    #Validate the matrix as a JavaMatrix
    javaMatrix = mssm.asJavaMatrix(x)#mssm.tools.as(x, 'javaMatrix')
    #Validate the budget as an integer
    if(as.integer(budget) != budget){
        budget = as.integer(budget)
        warning("Argument `budget` should be an integer. Continuing with value budget = ", budget)
    }
    #Validate the budget as an integer or length 1 string
    if(length(convergence) != 1 || !((is.character(convergence) && convergence%in%c('none', 'solution', 'time')) || ((is.numeric(convergence) ||is.integer(convergence)) && (convergence >= -1 && convergence <= 1)))){
        stop("Argument `convergence` should be one of 'none', 'solution' or 'time' or an integer (respectively -1, 0 and 1), not ", convergence, '\nSee ?mssm.search.cpgc')
    } else if(is.character(convergence)){
        convergence = switch(convergence, 'none' = -1, 'solution' = 0, 'time' = 1)
    }
    if(!is.null(variableOrdering) && !(is.vector(variableOrdering) && length(variableOrdering) == dim(mssm.fromJavaMatrix(javaMatrix))[2])){
        stop("Argument `variableOrdering` should be NA or a vector of size equal to the number of columns of `x`.")
    }
    # method = new(J("uclouvain.mssm.cp.CPGC"), javaMatrix)
    # print("----")
    # print(str(javaMatrix))
    # print("---")
    # print(str(x))
    # print("--")
    # a = mssm.jInst("CPGC")
    method = .jnew("uclouvain/mssm/cp/CPGC", javaMatrix, as.integer(budget), as.integer(convergence), verbose, as.numeric(lowerBound), lightFilter)
    # method$setMatrix()
    # method$setBudget(as.integer(budget))
    # method$setConvergence(as.integer(convergence))
    # method$setVerbose(verbose)
    # method$setLowerBound(as.numeric(lowerBound))
    # method$setLightFilter(lightFilter)
    # method = new(mssm.jInst("CPGC"), javaMatrix, as.integer(budget), as.integer(convergence), verbose, as.numeric(lowerBound), lightFilter)
    if(!is.null(variableOrdering)){
        if(min(variableOrdering) > 0 && max(variableOrdering) == length(variableOrdering)){
            variableOrdering = variableOrdering - 1
        }
        method$heuristicOnCols(as.integer(variableOrdering))
    }
    solution = method$search(lns, as.integer(lns.nRestarts), as.integer(lns.failureLimit), as.integer(lns.maxDiscrepancy), as.integer(lns.restartFilter))
    res = list()
    res$sum = solution$getObjective()
    res$rows = solution$getRowIndices()+1
    res$cols = solution$getColIndices()+1
    res$boolean.cols = solution$getColBooleanVector()
    res$boolean.rows = solution$getRowBooleanVector()
    return(res)
}



