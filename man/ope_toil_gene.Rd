% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ope_pancan_value.R
\name{ope_toil_gene}
\alias{ope_toil_gene}
\title{Obtain toilHub info for single gene}
\usage{
ope_toil_gene(identifier = "TP53")
}
\arguments{
\item{identifier}{a length-1 character representing a gene symbol, ensembl gene id, or probe id.
Gene symbol is highly recommended.}
}
\value{
a \code{tibble}
}
\description{
Obtain toilHub info for single gene
}
\examples{
\donttest{
t <- ope_toil_gene()
t
}
}
