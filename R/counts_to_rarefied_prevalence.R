#' Calculate rarefied prevalence of count data
#'
#' Normalizing data with VOOM-SNM removes any zero counts to maintin compatibility with a log transformation,
#' so for analyses requiring prevalence data it is better to use the rarefied prevalence of the unnormalized count data.
#' This function rarefies to match the depth of the sample with the minimum counts in the provided table.
#' @param counts A data table where rows are samples as defined in the column "sample", columns are species, and values are unnormalized counts.
#' @param seed Seed used for rarefying samples.
#' @return A table containing the rarefied prevalences for the counts table provided.
#' @export

counts_to_rarefied_prevalence <- function(counts, seed){
  det.mins <- rowSums(counts)
  min.n <- min(det.mins)
  print(min.n)
  set.seed(seed = seed)
  rare.counts <- vegan::rrarefy(x = counts, sample = min.n) %>%
    as.data.frame()
  rare.prev <- lapply(rare.counts, function(x) ifelse(x > 0, 1, 0))
  rare.prev.df <- dplyr::bind_cols(rare.prev) %>%
    dplyr::mutate(sample = rownames(startcounts)) %>%
    dplyr::select(sample, everything())
}
