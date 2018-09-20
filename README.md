# mssm
This package provides tools for the identification of ***submatrix of maximal sum***.
A submatrix is a rectangular, non-necessarily contiguous, subset of rows and of columns of a (larger) matrix.
The submatrices that are searched for are of maximal sum.
A submatrix is of maximal sum if the sum of its entires (selected from the original matrix) is of maximal sum.
This package is a R wrapper for the Scala implementation originally provided.

### Installation
Recommended installation of the latest development version is via

	> library(devtools)
	> install_github("vbranders/mssm")

in R.

#### Issues with rJava on OS X
The `mssm` package has the dependency `rJava` whose installation can causes troubles.
The following sections suggests steps that should be considered to fix `rJava`installation, starting with the manual installation.

##### Install rJava manually
The `rJava`can be installed manually with the following R command:

	> install.packages("rJava")
If this does not fix the issue, consider setting up the JDK.

##### Set up the JDK
If you hadn't installed a JDK (or Java Development Kit) yet, you should download and install the latest version (we consider here the JDK version 1.8.0_181).
You need to set up the `$JAVA_HOME` variable so that it contains the path to your JDK.
To get the actual path to the JDK (assuming it is version 1.8.0) and the value of the `$JAVA_HOME` variable, type in your command line interface:

	$ /usr/libexec/java_home -v 1.8.0
	$ echo $JAVA_HOME

Both should match. If this is not the case, you have to set up the JDK, through the command line, as follows:

	$ export JAVA_HOME=`/usr/libexec/java_home -v 1.8.0`

Then, to detect current Java setup and update the corresponding configuration in R, execute this command:

	$ R CMD javareconf
Then, you should be able to install `rJava`as explained in the *Install rJava manually* section.
This should fix the problem.
You can finally install and use the `mssm` package.
To ensure that R uses the correct version of the JDK, you can type the following lines in R and check that the output match your expectations:

	.jinit(".")
	.jcall("java/lang/System", "S", "getProperty", "java.version")


### Bug reports
Please use [mssm GitHub issues page](https://github.com/vbranders/mssm/issues) to report bugs.