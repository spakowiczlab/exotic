#' Filter species falsely identified in the fragmented CHM1 transcript & genome and mouse GRCm39 transcript & genome
#'
#' Filter out potential human and mouse contaminants.
#' @param counts A table where rows are samples as defined in the column "sample", columns are species, and values are counts.
#' @param filters A list of the filters desired - options include: humanRNA, humanWGS, mouseRNA, mouseWGS
#' @return A data frame containing only the species not included in the desired filters.
#' @export
transcript_genome_filter <- function(counts, filters){

  data("humanRNAfilter")
  data("humanWGSfilter")
  data("mouseRNAfilter")
  data("mouseWGSfilter")

  dfnames <- c("humanRNA", "humanWGS", "mouseRNA", "mouseWGS")
  df <- do.call(rbind, lapply(dfnames, function(x) cbind(get(x), Source=x)))

  select.filters <- df %>%
    filter(Source %in% filters)

  counts.filt <- counts %>%
    select(-one_of(select.filters$name))

  return(counts.filt)
}
