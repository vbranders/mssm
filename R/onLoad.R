.onLoad <- function(libname, pkgname) {
    .jpackage(pkgname, lib.loc=libname)
    .jaddLibrary('root', 'inst/java/root.jar')
    .jaddClassPath('inst/java/root.jar')
    #Test if the jar is required
    if(file.size(file.path(system.file(package="mssm"), "java/root.jar"))/(1024**2) < 1){
        warning("The JAR file is lighter than expected.\n
                The actual JAR file used by the package will be downloaded and installed in the library `", system.file(package="mssm"),"`.\n
                > If this is the time you load the package since a first or new install, you should ignore this warning.
                > Otherwise, you should contact the maintainer specifying your error.")
        download.file("https://github.com/vbranders/mssm/raw/master/inst/java/root.jar", destfile = file.path(system.file(package="mssm"), "java/root.jar"))
    }
    
} #Hook function that R will call when this package is being loaded
