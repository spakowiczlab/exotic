# exotic [![DOI](https://zenodo.org/badge/592828783.svg)](https://zenodo.org/badge/latestdoi/592828783)

## Exogenous sequences in tumors and immune cells
----
## Overview
Functions utilized for the processing and contaminant filtering of high throughput sequencing data to identify low abundance microbes. 

Please see the [exotic-manuscript](https://github.com/spakowiczlab/exotic-manuscript) repository for the analyses related to the [manuscript](https://www.biorxiv.org/content/10.1101/2022.08.16.503205v1):
> __Exogenous sequences in tumors and immune cells (exotic): a tool for estimating the microbe abundances in tumor RNAseq data.__
Rebecca Hoyd, Caroline E Wheeler, YunZhou Liu, Malvenderjit Jagjit Singh, Mitchell Muniak, Nicolas Denko, David Carbone, Xiaokui Mo, Daniel Spakowicz
_bioRxiv_ 2022.08.16.503205; doi: https://doi.org/10.1101/2022.08.16.503205

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
Added krakenuniq-based filters. For analysis, we now recommend using the krakenuniq unnormalized, filtered counts or the abundance relative to human calculated with the unnormalized, filtered counts.
```
transcript_genome_filter(counts, "humanRNA.uniq")
```

