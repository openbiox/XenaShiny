% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/vis_pancan_value.R
\name{vis_gene_immune_cor}
\alias{vis_gene_immune_cor}
\title{Heatmap visualization (correlation between immune signatures and gene)}
\usage{
vis_gene_immune_cor(
  Gene = "TP53",
  Cor_method = "spearman",
  Immune_sig_type = "Cibersort"
)
}
\arguments{
\item{Gene}{Gene symbal for comparision}

\item{Cor_method}{correlation method}

\item{Immune_sig_type}{quantification method, default is "Cibersort"}
}
\description{
Heatmap visualization (correlation between immune signatures and gene)
}
\examples{
\donttest{
p <- vis_gene_immune_cor(Gene = "TP53")
}
}
