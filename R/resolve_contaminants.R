#' Compare statistical contaminants to literature contaminants
#'
#' As a final filtering step before normalization, the results of checking for statistical contaminants are compared to the
#' ccontaminants determined by literature review.
#' @param contams The results of running get_contaminants. A data frame  containining the microbes in the count data, the genera they belong to, and a p.value showing the likelihood they are contaminants.
#' @param counts The data frame of microbe counts to be filtered. Samples are rows, with microbes as columns and the sample names saved in the column "sample".
#' @param threshold The p.value threshold below which microbes should be considered a contaminant.
#' @return A data frame containing only those microbes not considered contaminants.
#' @export

resolve_contaminants <- function(contams, counts, threshold = 0.1){

  data(salter.eval)

  decontam.badmics <- contams %>%
    dplyr::filter(p < threshold | is.na(p)) %>%
    dplyr::select(microbe, Genera)
  decontam.unq <- decontam.badmics[!duplicated(decontam.badmics[ , c("microbe", "Genera")]),]
  decontam.rem <- subset(decontam.unq, !(decontam.unq$Genera%in%salter.eval$Genera))

  salter.eval.rem <- salter.eval %>%
    dplyr::filter(Category == "LIKELY CONTAMINANT")
  salter.eval.rem <- unique(salter.eval.rem$Genera)

  counts.approved <- counts %>%
    tidyr::gather(-sample, key = "microbe", value = "counts") %>%
    dplyr::filter(!microbe %in% decontam.rem$microbe) %>%
    tidyr::separate(microbe, into = c("Genera"), remove = F, sep = "\\.") %>%
    dplyr::filter(!Genera %in% salter.eval.rem) %>%
    dplyr::select(-Genera) %>%
    tidyr::spread(key = "microbe", value = "counts")

 return(counts.approved)
}
