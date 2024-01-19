#' Calculate relative abundances of normalized species counts
#'
#' Given a table where rows are samples and columns are species, calculate the relative abundances for each sample.
#' @param counts Table with normalized or unnormalized species counts. Samples are expected to be in a column labelled "sample".
#' @return A table where rows are samples, columns are species, and cells are the relative abundances.
#' @export

calculate_relative_abundance <- function(counts){
  tmp.totals <- counts %>%
    tidyr::gather(-sample, key = "microbe", value = "count") %>%
    dplyr::group_by(sample) %>%
    dplyr::summarise(total = sum(count))

  tmp.ra.nosapien <- counts %>%
    tidyr::gather(-sample, key = "microbe", value = "count") %>%
    dplyr::left_join(tmp.totals) %>%
    dplyr::mutate(ra = count/total) %>%
    dplyr::select(sample, microbe, ra) %>%
    tidyr::spread(key = "microbe", value = "ra")

  return(tmp.ra.nosapien)
}


