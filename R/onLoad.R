#' @importFrom rJava .jpackage
#' @importFrom rJava .jaddLibrary
#' @importFrom rJava .jaddClassPath
#' @importFrom utils download.file
#' 
.onLoad <- function(libname, pkgname) {
    #library(rJava)
    #library(utils)
    .jpackage(pkgname, lib.loc=unique(libname, c(.libPaths())))
    .jaddLibrary('root', 'inst/java/root.jar')
    .jaddClassPath('inst/java/root.jar')
    #Test if the jar is required
    if(file.size(file.path(system.file(package="mssm"), "java/root.jar"))/(1024**2) < 1){
        cat("The JAR file is lighter than expected.\n
    The actual JAR file used by the package will be downloaded and installed in the library `", system.file(package="mssm"),"`.\n
    > If this message appears during installation, ignore it.
    > If it appears during to package loading, you should contact the maintainer of the package.\n")
        download.file("https://github.com/vbranders/mssm/raw/master/inst/java/root.jar", destfile = file.path(system.file(package="mssm"), "java/root.jar"))
    }
    
} #Hook function that R will call when this package is being loaded
#devtools::document() #Uncomment and run for DESCRIPTION file
