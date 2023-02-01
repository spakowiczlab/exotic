#' Generate genomic data commons manifest
#'
#' This function interacts with the Genomic Data Commons API to obtain information on file ids for a given TCGA project.
#' These are filtered to RNA-seq samples of the primary tumor.
#' @param cname The name of the TCGA cancer project to obtain samples ids for.
#' @return A data table of the file ids for both aliged reads and gene expression results for the given cancer. These can then be passed to tools like the gdc client to download data files.
#' @export

generate_TCGA_manifest <- function(cname){

  # Step 1 - find id's for bam files

  grab.bam.files <- GenomicDataCommons::files(legacy = F) %>%
    GenomicDataCommons::filter(~ type == "aligned_reads" &
                                 cases.project.program.name =='TCGA' &
                                 cases.samples.sample_type == "primary tumor" &
                                 experimental_strategy == "RNA-Seq" &
                                 cases.project.project_id == paste0("TCGA-", cname)) %>%
    GenomicDataCommons::manifest() %>%
    dplyr::mutate(cancer = cname,
                  source = "tumor",
                  file_id.BAM = id)

  # Step 2 - grab and add id's for expression files. We need both the file id for downloading, and the file name for eventually linking the expression table to the microbe table.
  linksamps <- GenomicDataCommons::files() %>%
    GenomicDataCommons::select(c("file_id", "downstream_analyses.output_files.file_name",
                                 "downstream_analyses.output_files.file_id")) %>%
    GenomicDataCommons::filter(file_id %in% grab.bam.files$id) %>%
    GenomicDataCommons::results_all()

  sampids <- list()
  for(i in linksamps$id){
    sampids[[i]] <- linksamps$downstream_analyses[[i]]$output_files
  }
  sampids <- lapply(sampids, function(x) bind_rows(x))
  sampids.form <- lapply(names(sampids), function(x) sampids[[x]] %>%
                           dplyr::mutate(file_id.BAM = x)) %>%
    dplyr::bind_rows() %>%
    dplyr::rename("file_id.expression" = "file_id",
           "file_name.expression" = "file_name")

  manifest.with.expression <- sampids.form %>%
    dplyr::left_join(grab.bam.files) %>%
    dplyr::rename("file_name.BAM" = "filename") %>%
    dplyr::select(file_id.BAM,
                  file_name.BAM,
                  file_id.expression,
                  file_name.expression,
                  cancer,
                  source)

  return(manifest.with.expression)
}
