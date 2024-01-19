#' Calculate abundance relative to amount of human of unnormalized species counts
#'
#' Given a table where rows are samples and columns are species, calculate the relative abundances for each sample.
#' @param counts Table with normalized or unnormalized species counts. Samples are expected to be in a column labelled "sample", Human counts are expected to be in a column labelled "Homo.sapiens"
#' @return A table where rows are samples, columns are species, and cells are the relative abundances.
#' @export

calculate_abundance_relative_to_human <- function(counts){
  counts.hum <- counts %>%
    dplyr::select(sample, Homo.sapiens)

  tmp.ra <- counts %>%
    tidyr::gather(-sample, key = "microbe", value = "count") %>%
    dplyr::left_join(counts.hum) %>%
    dplyr::mutate(ra = count/Homo.sapiens) %>%
    dplyr::select(sample, microbe, ra) %>%
    tidyr::spread(key = "microbe", value = "ra")

  return(tmp.ra)
}

