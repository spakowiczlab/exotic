#' Formatting TCGA microbe count data for normalization
#'
#' This function is meant to assist with formatting TCGA data processed with other exotic functions for voom-snm normalization.
#' @param tcga.counts A table of microbe counts where rows are samples with sample names stored in the column "sample" and columns are species.
#' @param tcga.meta The results of the function grab_TCGA_metadata.
#' @return A list of the required objects for normalization with the counts listed first and the meta data listed second.
#' @export

format_voom_snm_microbe <- function(tcga.counts,tcga.meta){

  combmeta <- tcga.meta %>%
    dplyr::arrange(sample) %>%
    dplyr::filter(!is.na(TCGA.code))

  goodsamples <- intersect(tcga.counts$sample, combmeta$sample)
  combcounts <- tcga.counts %>%
    dplyr::filter(sample %in% goodsamples) %>%
    dplyr::arrange(sample) %>%
    tibble::column_to_rownames(var = "sample") %>%
    as.matrix()
  combmeta <- combmeta %>%
    dplyr::filter(sample %in% goodsamples)

  combout <- list(combcounts, combmeta)

  return(combout)

}
