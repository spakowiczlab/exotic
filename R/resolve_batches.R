#' Prepare data for get_contaminants
#'
#' This function is meant to handle the data manipulation required to prepare sample and meta data for the get_contaminants function.
#' @param metadf The data frame containing batch and concentration information for the samples
#' @param countdf The data from containing microbe counts information, where samples are rows with sample names saved in the column "sample" and columns are microbes.
#' @param conc.col.name The name of the column containing the concentration information in metadf.
#' @param sample.col.name The name of the column containing sample information in metadf.
#' @param batch.col.name The name of the column containing batch information in metadf.
#' @return A list of the count and meta data formatted to be taken directly by get_contaminants. Batches with only one sample are removed.
#' @export

resolve_batches <- function(metadf, countdf, conc.col.name, sample.col.name, batch.col.name){

  metadf$sample <- metadf[[sample.col.name]]
  metadf$rna.conc <- as.numeric(metadf[[conc.col.name]])
  metadf$batch <- as.character(metadf[[batch.col.name]])

  metadf <- metadf %>%
    dplyr::filter(sample %in% countdf$sample) %>%
    dplyr::add_count(batch) %>%
    dplyr::filter(n > 1) %>%
    dplyr::arrange(sample)

  countdf <- countdf %>%
    as.data.frame() %>%
    dplyr::filter(sample %in% metadf$sample) %>%
    dplyr::arrange(sample)

  resolved.objects <- list(countdf, metadf)
  names(resolved.objects) <- c("counts", "meta")
  return(resolved.objects)
}
