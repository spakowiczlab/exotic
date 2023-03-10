% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/resolve_contaminants.R
\name{resolve_contaminants}
\alias{resolve_contaminants}
\title{Compare statistical contaminants to literature contaminants}
\usage{
resolve_contaminants(contams, counts, threshold = 0.1)
}
\arguments{
\item{contams}{The results of running get_contaminants. A data frame  containining the microbes in the count data, the genera they belong to, and a p.value showing the likelihood they are contaminants.}

\item{counts}{The data frame of microbe counts to be filtered. Samples are rows, with microbes as columns and the sample names saved in the column "sample".}

\item{threshold}{The p.value threshold below which microbes should be considered a contaminant.}
}
\value{
A data frame containing only those microbes not considered contaminants.
}
\description{
As a final filtering step before normalization, the results of checking for statistical contaminants are compared to the
ccontaminants determined by literature review.
}
