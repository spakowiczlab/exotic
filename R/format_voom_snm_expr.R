#' Formatting TCGA gene expression data for normalization
#'
#' This function is meant to assist with formatting TCGA data processed with other exotic functions for voom-snm normalization.
#' @param tcga.exp A table of expression values where rows are genes with gene names stored as row names and columns are samples.
#' It is expected that the TCGA sample names will need to be reformatted by the function from R compatible column names back the the file ids TCGA provides.
#' @param tcga.meta The results of the function grab_TCGA_metadata.
#' @return A list of the required objects for normalization with the counts listed first and the meta data listed second.
#' @export

format_voom_snm_expr <- function(tcga.exp, tcga.meta){
  tcga.exp <- tcga.exp %>%
    tibble::column_to_rownames(var = "Gene.Symbol") %>%
    t() %>%
    as.data.frame() %>%
    tibble::rownames_to_column(var = "file_id.expression") %>%
    dplyr::mutate(file_id.expression = gsub("^X", "", file_id.expression),
           file_id.expression = gsub("\\.", "-", file_id.expression))

  combcounts <- tcga.exp %>%
    dplyr::rename("sample" = "file_id.expression") %>%
    dplyr::select("sample", everything())
  holdsamp <- combcounts$sample
  combcounts <- tidyverse::bind_cols(lapply(combcounts[,-1], function(x) ifelse(is.na(x), 0, x)))
  combcounts$sample <- holdsamp

  tcga.meta.form <- tcga.meta %>%
    dplyr::select( -sample) %>%
    dplyr::rename("sample" = "file_id.expression")

  combmeta <- tcga.meta.form %>%
    dplyr::arrange(sample) %>%
    dplyr::filter(!is.na(TCGA.code))

  goodsamples <- intersect(combcounts$sample, combmeta$sample)
  combcounts <- combcounts %>%
    dplyr::filter(sample %in% goodsamples) %>%
    dplyr::arrange(sample) %>%
    tibble::column_to_rownames(var = "sample") %>%
    as.matrix()
  combmeta <- combmeta %>%
    dplyr::filter(sample %in% goodsamples)

  combout <- list(combcounts, combmeta)

  return(combout)

}
