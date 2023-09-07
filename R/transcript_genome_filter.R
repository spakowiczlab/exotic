#' Filter species falsely identified in the fragmented CHM1 transcript & genome and mouse GRCm39 transcript & genome
#'
#' Filter out potential human and mouse contaminants.
#' @param counts A table where rows are samples as defined in the column "sample", columns are species, and values are counts.
#' @param filters A list of the filters desired - options include: humanRNA, humanWGS, mouseRNA, mouseWGS
#' @return A data frame containing only the species not included in the desired filters.
#' @export
transcript_genome_filter <- function(counts, filters){

  load("data/humanRNAfilter.rda")
  load("data/humanWGSfilter.rda")
  load("data/mouseRNAfilter.rda")
  load("data/mouseWGSfilter.rda")

  humanRNA <- hum.rna$name
  humanWGS <- hum.wgs$name
  mouseRNA <- mous.rna$name
  mouseWGS <- mous.wgs$name

  counts.filt <- counts %>%
    dplyr::select(-one_of(filters))

  return(counts.filt)
}
