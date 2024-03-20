#' Filter species falsely identified in the fragmented CHM1 transcript & genome and mouse GRCm39 transcript & genome
#'
#' Filter out potential human and mouse contaminants.
#' @param counts A table where rows are samples as defined in the column "sample", columns are species, and values are counts.
#' @param filters A character vector containing filters desired
#' options include: "humanRNA", "humanWGS", "mouseRNA", "mouseWGS", "humanRNA.uniq", "humanWGS.uniq", "mouseRNA.uniq", "mouseWGS.uniq"
#' '.uniq' indicates krakenuniq filter
#' @return A data frame containing only the species not included in the desired filters.
#' @export
transcript_genome_filter <- function(counts, filters){

  data("humanRNAfilter")
  data("humanWGSfilter")
  data("mouseRNAfilter")
  data("mouseWGSfilter")
  data("humanRNAfilter_krakenuniq")
  data("humanWGSfilter_krakenuniq")
  data("mouseRNAfilter_krakenuniq")
  data("mouseWGSfilter_krakenuniq")

  dfnames <- c("humanRNA", "humanWGS", "mouseRNA", "mouseWGS", "humanRNA.uniq", "humanWGS.uniq", "mouseRNA.uniq", "mouseWGS.uniq")
  df <- do.call(rbind, lapply(dfnames, function(x) cbind(get(x), dfname=x)))

  select.filters <- df %>%
    dplyr::filter(dfname %in% filters)

  counts.filt <- counts %>%
    dplyr::select(-any_of(select.filters$name))

  return(counts.filt)
}
