% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tools.R
\name{mssm.loadMatrix}
\alias{mssm.loadMatrix}
\title{Load a Java Matrix from file}
\usage{
mssm.loadMatrix(filePath = "data.tsv", sep = "\\t")
}
\arguments{
\item{filePath}{the name of the file which the data are to be read from.}

\item{sep}{the field separator character.}
}
\value{
A Java two-dimensionnal array of double (called Java Matrix).
}
\description{
Produces a Java two-dimensionnal array of double (a Java Matrix) from
a file.
Java Matrices are the standard type used for subsequent analysis with
the \link{mssm} package.
}
\section{Maintainer}{
 Vincent Branders <vincent.branders@uclouvain.be>.
}

\seealso{
\code{\link[=mssm.asJavaMatrix]{mssm.asJavaMatrix()}} and \code{\link[=mssm.fromJavaMatrix]{mssm.fromJavaMatrix()}} to transform
a matrix into a Java Matrix and conversely. See also package \link{mssm}.
}
