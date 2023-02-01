#' Normalized decontaminanted counts
#'
#' Normalizes count data using voom-snm. This removes variation from specified technical variables while preserving variation from specified biological variables.
#' For projects only utilizing TCGA data, the functions format_voom_snm_microbe and format_voom_snm_expr automatically format inputs for this function.
#' @param qcMetadata Data frame containing all the biological and technical variables. This must have the same sample order as the count data.
#' @param qcData Data frame containing the count data to be normalized. Samples are rows, with sample names stored as row names.
#' @param biovars A vector of the names of the columns in qcMetadata containing biological variables.
#' @param adjvars A vector of the names of the columns in qcMetadata containing technical variables.
#' @param return.format Should the data be return in logged counts per million or counts per million (cpm)?
#' @param seed The seed used to determine randomization for the normalization process.
#' @return A data from containing the normalized logged cpm or normalized cpm of the sample values.
#' @export

voom_snm_normalization <- function(qcMetadata,
                                   qcData,
                                   biovars,
                                   adjvars,
                                   return.format = "logcpm",
                                   seed){
  set.seed(seed)

  # Set up design matrix
  covDesignNorm <- model.matrix(as.formula(paste0("~0 + ", paste(adjvars, collapse = " + "))),
                                data = qcMetadata)

  # Check row dimensions
  dim(covDesignNorm)[1] == dim(qcData)[1]

  # Set up counts matrix
  counts <- t(qcData) # DGEList object from a table of counts (rows=features, columns=samples)

  # Quantile normalize and plug into voom
  dge <- edgeR::DGEList(counts = counts)
  vdge <- limma::voom(dge,
               design = covDesignNorm,
               # plot = TRUE, save.plot = TRUE,
                normalize.method="quantile")

  # List biological and normalization variables in model matrices
  bio.var <- model.matrix(as.formula(paste0("~", paste(biovars, collapse = "+"))),
                          data=qcMetadata)

  adj.var <- model.matrix(as.formula(paste0("~", paste(adjvars, collapse = "+"))),
                          data=qcMetadata)

  print(dim(adj.var))
  print(dim(bio.var))
  print(dim(t(vdge$E)))
  print(dim(covDesignNorm))

  snmDataObjOnly <- snm::snm(raw.dat = vdge$E,
                        bio.var = bio.var,
                        adj.var = adj.var,
                        rm.adj=TRUE,
                        verbose = TRUE,
                        diagnose = TRUE)
  snmData <- t(snmDataObjOnly$norm.dat) %>%
    as.data.frame()
  snmData.cpm <- dplyr::bind_cols(lapply(snmData, function(x) 2^x))
  snmData.cpm$sample <- qcMetadata$sample

  if(return.format == "cpm"){
    return(snmData.cpm)
  }
  else {
    return(snmData)
  }
}
