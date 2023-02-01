#' Remove samples with low human abundances
#'
#' The exotic pipeline was built with the intention of processing human tumor samples. Samples with low human abundances are therefore suspiscious and should be removed.
#' @param counts A table where rows are samples as defined in the column "sample", columns are species, and values are counts.
#' @param req.precent The percentage of a sample that must be human to keep the sample.
#' @return A data frame containing only the samples that contain at least the required percentage of human data.
#' @export

check_human_percentages <- function(counts, req.percent){
  tmp <- counts %>%
    tidyr::gather(-sample, key = "microbe", value = "ct") %>%
    dplyr::group_by(sample) %>%
    dplyr::mutate(total.ct = sum(ct)) %>%
    dplyr::ungroup() %>%
    dplyr::filter(microbe == "Homo.sapiens") %>%
    dplyr::mutate(perc.hum = ct/total.ct) %>%
    dplyr::filter(perc.hum > req.percent)

  counts.pass <- counts %>%
    dplyr::filter(sample %in% tmp$sample)

  return(counts.pass)
}
