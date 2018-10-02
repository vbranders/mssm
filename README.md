# mssm
This package provides tools for the identification of ***submatrix of maximal sum***.
A submatrix is a rectangular, non-necessarily contiguous, subset of rows and of columns of a (larger) matrix.
The submatrices that are searched for are of maximal sum.
A submatrix is of maximal sum if the sum of its entries (selected from the original matrix) is of maximal sum.
This package is a R wrapper for the Scala implementation originally provided.

## Installation
Recommended installation of the latest development version is done via

	> library(devtools)
	> install_github("vbranders/mssm")

in R.
If everything went fine, you can now load the package without any error:

    > library(mssm)

If errors are raised, keep reading.

### Issues with `rJava`
The `mssm` package has the dependency `rJava`.
Although the installation should be fine in most cases, there are many posts dedicated
to fixing `rJava` installation.
We have three suggestions regarding possible issues while installing `rJava`:
1. As first step, consider the next sections that propose a generic solution to most common issues.
2. Read the [rJava github](https://github.com/s-u/rJava) for installation instructions and documentation.
3. Search for solutions to your (possibly already solved) specific error.

#### Common issue
As the package interfaces R and Java, a JDK (or Java Development Kit) should be available to R.
This means that you should have a JDK installed and the environment variable `JAVA_HOME` should point to the JDK location.
In most cases, this requirement is not met, which leeds to an error during the installation.

If you hadn't installed a JDK yet, you should download and install the latest version (we consider here the JDK version 1.8.0_181).
If you have a JDK installed but you don't know the version, or you don't know if you have a JDK, just type in your favorite command line interface:

    $ java -version

To detect the current Java setup and update the corresponding configuration in R, type:

    $ R CMD javareconf -e

This might have fixed the `rJava` installation issue, but you most probably should continue before re-trying to install `mssm`.
***Note:*** if you are using RStudio, consider restarting R session before any re-installation of `mssm` or `rJava`.

##### Fixing on Mac OS X
You know need to set up the `JAVA_HOME` environment variable so that it contains the path to your JDK.
To get the actual path to the JDK (assuming it is version *1.8.0*_181) and then the value of the `JAVA_HOME` variable, type:

    $ /usr/libexec/java_home -v 1.8.0
    $ echo $JAVA_HOME

Both should match.
If not, the `JAVA_HOME` must be updated as follows:

    $ export JAVA_HOME=`/usr/libexec/java_home -v 1.8.0`

Then, continue with the *Updating configuration* section.

##### Fixing on Linux (or associated)
Dynamic libraries locations are referenced in the `LD_LIBRARY_PATH` environment variable.
To provide R and `rJava` an access to the java dynamic library, the environment variable must be updated as follows:

    $ export LD_LIBRARY_PATH=$JAVA_LD_LIBRARY_PATH

Once done, continue with the *Updating configuration* section.

##### Updating configuration
Now that environment variables are updated, the new Java setup must be detected and the associated R configuration must be updated:

    $ R CMD javareconf -e

The problem should be fixed now and you can finally install and use the `mssm` package as explained in the *Installation* section.
***Note:*** the distinction between Max OS X and Linux is motivated by there different most frequent issues. Both fixes can be considered on both Mac OS X and Linux (but some commands might requires adaptations).

To ensure that `rJava` (after installation) uses the right JDK version, you can type the following lines in R and check that the output match your expectations:

    > library(rJava)
    > .jinit(".")
    > .jcall("java/lang/System", "S", "getProperty", "java.version")

### Bug reports
Please use [mssm GitHub issues page](https://github.com/vbranders/mssm/issues) to report bugs.
