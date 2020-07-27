
# library(devtools)
# install_github("vbranders/mssm")
library("mssm")

# -----------------
# Example with importing data from file and executing a search

#Open a matrix
mat = as.matrix(read.csv("data.tsv", sep="\t", dec=".", header=FALSE, stringsAsFactors=FALSE))

#Print it
print(mat)

#Find a solution
solution = mssm.search.cpgc(x = mat, budget = 10, convergence = -1, verbose = T, lowerBound = 0, lightFilter = F, variableOrdering = mssm.getHeuristicReordering(mssm.asJavaMatrix(mat)), lns = F)

print(solution)



# -----------------
# Example with making a matrix with uniform background and inserting solution

build.matrix<-function(nr=500, nc=200, FUN = rnorm, ...){
    return(matrix(FUN(...), nrow = nr, ncol = nc, byrow = TRUE))
}
add.simple.cluster<-function(matrix, nr=50, nc=50, ir, ic, FUN, ...){
    matrix[(1:nr+ir), (1:nc+ic)] = FUN(...)
    return(matrix)
}

# Builds the background
matrix = build.matrix(500, 200, rnorm, 500*200, 0, 1)

# Adds three submatrices to find (they slightly overlap)
matrix = add.simple.cluster(matrix, 50, 50, 1, 1, rnorm, 50*50, 1, 1)
matrix = add.simple.cluster(matrix, 50, 50, 45, 45, rnorm, 50*50, 3, 1)
matrix = add.simple.cluster(matrix, 50, 50, 90, 90, rnorm, 50*50, 2, 1)

# Plots the matrix obtained
heatmap(matrix, Rowv = NA, Colv = NA, labRow = F, labCol = F)

#Heuristic ordering
colOrder = mssm.getHeuristicReordering(matrix)
#Print with ordering
heatmap(matrix[1:dim(matrix)[1], colOrder], Rowv = NA, Colv = NA, labRow = F, labCol = F)
# Plot hist od data values in the matrix
plot(hist(matrix, 100000))
#Search a first submatrix
solution = mssm.search.cpgc(matrix-2.5, budget = 120, convergence = "time", verbose = T, lightFilter = F, variableOrdering = colOrder, lns = F, lowerBound = 0, lns.nRestarts = 100, lns.failureLimit = 500, lns.maxDiscrepancy = 2, lns.restartFilter = 70)

