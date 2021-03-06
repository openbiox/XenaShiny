# cohort: TCGA TARGET GTEx
library(UCSCXenaTools)
toil_info <- XenaGenerate(subset = XenaDatasets == "TcgaTargetGTEX_phenotype.txt") %>%
  XenaQuery() %>%
  XenaDownload() %>%
  XenaPrepare() %>%
  as.data.frame()

toil_surv <- XenaGenerate(subset = XenaDatasets == "TCGA_survival_data") %>%
  XenaQuery() %>%
  XenaDownload() %>%
  XenaPrepare() %>%
  as.data.frame()

#-------------gene expression-------------------------
get_expresion_value <- function(Gene = "TP53") {
  t1 <- get_pancan_value(Gene, dataset = "TcgaTargetGtex_rsem_isoform_tpm", host = "toilHub")
  return(t1)
}
t1 <- get_expresion_value(Gene = "TP53")

#-------------immune sig data--------------------------
# access date: 2020-06-14
# from https://gdc.cancer.gov/about-data/publications/panimmune
require(data.table)
immune_sig <- data.table::fread("data-raw/Scores_160_Signatures.tsv", data.table = F)
# test = immune_sig[1:5,1:5]
immune_sig <- immune_sig %>% tibble::column_to_rownames("V1")

#------------TMB (tumor mutation burden)-------------------
# access date: 2020-06-14
# from https://gdc.cancer.gov/about-data/publications/panimmune
require(data.table)
tmb_data <- data.table::fread("data-raw/mutation-load_updated.txt", data.table = F)
names(tmb_data)[c(4, 5)] <- c("Silent_per_Mb", "Non_silent_per_Mb")

#-----------Stemness----------------------------------------
# access date:2020-06-17
# from https://pancanatlas.xenahubs.net/download/StemnessScores_DNAmeth_20170210.tsv.gz
stemness_data <- data.table::fread("data-raw/StemnessScores_RNAexp_20170127.2.tsv", data.table = F)
stemness_data <- stemness_data %>%
  tibble::column_to_rownames(var = "sample") %>%
  t() %>%
  as.data.frame()
stemness_data_RNA <- stemness_data %>%
  tibble::rownames_to_column(var = "sample") %>%
  dplyr::mutate(sample = stringr::str_replace_all(sample, "\\.", "-"))

#--------purity and ploidy data-----------------------------
# access date:2020-06-17
# from https://gdc.cancer.gov/about-data/publications/PanCanStemness-2018
## genome instability
gi_data <- data.table::fread("data-raw/Purity_Ploidy_All_Samples_9_28_16.tsv", data.table = F)
gi_data <- gi_data %>%
  dplyr::select(c(3, 5, 6, 7, 9, 10))
gi_data <- gi_data %>%
  dplyr::select(sample, purity, ploidy, Genome_doublings = `Genome doublings`, Cancer_DNA_fraction = `Cancer DNA fraction`, Subclonal_genome_fraction = `Subclonal genome fraction`) %>%
  dplyr::mutate(sample = stringr::str_sub(sample, 1, 15))

#-------purity data----------------------------------------
# access date:2020-06-18
# from https://www.nature.com/articles/ncomms9971#Sec14
library(readxl)
purity_data <- read_excel("data-raw/41467_2015_BFncomms9971_MOESM1236_ESM.xlsx", skip = 3)
purity_data <- purity_data %>%
  dplyr::select(c(1:7)) %>%
  dplyr::rename(sample = "Sample ID", cancer_type = "Cancer type") %>%
  dplyr::mutate(sample = stringr::str_sub(sample, 1, 15))

#-------anatomy visualization--------------------------------
# refer to FigureYa78gganatogram
TCGA.organ <- data.table::fread("data-raw/TCGA_organ.txt", data.table = F)
TCGA.organ <- TCGA.organ[, -3]

#-------ccle phenotype--------------------------------------
download.file("https://data.broadinstitute.org/ccle_legacy_data/cell_line_annotations/CCLE_sample_info_file_2012-10-18.txt", destfile = "./data-raw/ccle_pheno.txt", method="curl")
ccle_info = data.table::fread("./data-raw/ccle_pheno.txt",data.table = F)
table(ccle_info$Histology)
table(ccle_info$`Site Primary`)
ccle_info %>% mutate(Type = ifelse(`Hist Subtype1`== "NS",Histology,`Hist Subtype1`)) -> ccle_info
names(ccle_info) <- c("CCLE_name","Cell_line_primary_name","Cell_line_aliases","Gender","Site_Primary","Histology","Hist_Subtype1","Notes","Source","Expression_arrays","SNP_arrays","Oncomap","Hybrid_Capture_Sequencing","Type")

usethis::use_data(toil_info, overwrite = TRUE)
usethis::use_data(toil_surv, overwrite = TRUE)
usethis::use_data(immune_sig, overwrite = TRUE)
usethis::use_data(tmb_data, overwrite = TRUE)
usethis::use_data(stemness_data_RNA, overwrite = TRUE)
usethis::use_data(gi_data, overwrite = TRUE)
usethis::use_data(purity_data, overwrite = TRUE)
usethis::use_data(t1, overwrite = TRUE)
usethis::use_data(TCGA.organ, overwrite = TRUE)
usethis::use_data(ccle_info, overwrite = TRUE)
