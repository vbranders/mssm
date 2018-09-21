.onLoad <- function(libname, pkgname) {
    .jpackage(pkgname, lib.loc=libname)
    .jaddLibrary('root', 'inst/java/root.jar')
    .jaddClassPath('inst/java/root.jar')

} #Hook function that R will call when this package is being loaded
