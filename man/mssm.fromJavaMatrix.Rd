% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tools.R
\name{mssm.fromJavaMatrix}
\alias{mssm.fromJavaMatrix}
\title{Transform a Java Matrix into a matrix}
\usage{
mssm.fromJavaMatrix(javaMatrix)
}
\arguments{
\item{javaMatrix}{a Java two-dimensionnal array of double (called
Java Matrix).}
}
\value{
A standard R matrix.
}
\description{
Produces a R matrix from a Java two-dimensionnal array of double
(a Java Matrix).
Java Matrices are the standard type used for subsequent analysis
with the \link{mssm} package.
}
\section{Maintainer}{
 Vincent Branders <vincent.branders@uclouvain.be>.
}

\seealso{
\code{\link[=mssm.asJavaMatrix]{mssm.asJavaMatrix()}} to transform a matrix into a Java
Matrix and \code{\link[=mssm.loadMatrix]{mssm.loadMatrix()}} to load a Java matrix from a file.
See also package \link{mssm}.
}
