# exotic [![DOI](https://zenodo.org/badge/592828783.svg)](https://zenodo.org/badge/latestdoi/592828783)

## Exogenous sequences in tumors and immune cells
----
## Overview
Functions utilized for the processing and contaminant filtering of high throughput sequencing data to identify low abundance microbes. 

Please see the [exotic-manuscript](https://github.com/spakowiczlab/exotic-manuscript) repository for the analyses related to the [manuscript](https://aacrjournals.org/cancerrescommun/article/doi/10.1158/2767-9764.CRC-22-0435/729620):
> __Exogenous sequences in tumors and immune cells (exotic): A tool for estimating the microbe abundances in tumor RNAseq data.__ 
Hoyd R, Wheeler CE, Liu Y, Jagjit Singh MS, Muniak M, Jin N, Denko NC, Carbone DP, Mo X, Spakowicz DJ.
_Cancer Research Communications._ AACR; 2023 https://aacrjournals.org/cancerrescommun/article/doi/10.1158/2767-9764.CRC-22-0435/729620

## Installation
The package can be installed from GitHub via devtools:
```
install.packages("devtools")
devtools::install_github("spakowiczlab/exotic")
```
For more detailed instructions, please refer to the [user manual](https://github.com/spakowiczlab/exotic/blob/main/doc/user_manual.md).

## Database 
The custom database containing bacteria, fungi, viruses, archaea, and select eukaryotes is available for download at https://go.osu.edu/exotic-database. The human reference genome (hg38) and univec contaminants database are included as an additional contaminant filter.

## Version History

### v1.1
Additional filter function, developed by segmenting the CHM13 human and GRCm39 mouse transcriptome/genome into 100 base pairs, with 50 base pair overlaps, and running through the exotic pipeline. This function filters out microbes falsely identified as microbial in this process. 
```
transcript_genome_filter(counts, filters)
```

### v1.2
Additional function to calculate the abundance relative to human counts. For analysis, we now recommend using the unnormalized, filtered counts or the abundance relative to human calculated with the unnormalized, filtered counts.
```
calculate_abundance_relative_to_human(counts)
```

### v2.0
Added krakenuniq-based filters. For analysis, we now recommend using the krakenuniq unnormalized, filtered counts or the abundance relative to human calculated with the unnormalized, filtered counts. Synthetic genome/transciptome accessible via https://zenodo.org/records/10999313.
```
transcript_genome_filter(counts, "humanRNA.uniq")
```

