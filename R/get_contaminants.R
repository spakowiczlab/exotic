#' Determine statistical contaminants
#'
#' Determine statistical contaminants using RNA concentrations and sample batches.
#' @param metadf Data frame containing the RNA concentration and batch information for the samples. These are expected in the columns
#' "rna.conc" and "batch" respectively. Sample order must match the sample order of countdf.
#' @param countdf Data frame where rows are samples with the sample names stored in the column "sample" and columns are species.
#' @param seed Seed value for sampling in the analysis.
#' @return A data frame indicating whether each species is a likely contaminant, with an additional column indicating the genus
#' each species belongs to.
#' @export

get_contaminants <- function(metadf, countdf, seed){

  countdf <- countdf %>%
    tibble::column_to_rownames(var = "sample") %>%
    as.matrix()

  set.seed(seed)

  decontam.contams <- decontam::isContaminant(seqtab = countdf, conc = metadf$rna.conc, batch = metadf$batch) %>%
    tibble::rownames_to_column(var = "microbe") %>%
    tidyr::separate(microbe, into = c("Genera"), remove = F, sep = "\\.")

  return(decontam.contams)
}
