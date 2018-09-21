.onLoad <- function(libname, pkgname) {
    .jpackage(pkgname, lib.loc=libname)
    # .jaddLibrary('root', 'inst/java/root.jar')
    # .jaddClassPath('inst/java/root.jar')

    #Pourquoi peut pas en faire une methode accessible partout alors que tel quel c'est accessible partout ?
    # a = as.matrix(read.table('inst/names.txt', header = F, sep = "\t", row.names = 1, colClasses = "character"))
    # classes = as.vector(a[,1])
    # names(classes) = rownames(a)

} #Hook function that R will call when this package is being loaded
