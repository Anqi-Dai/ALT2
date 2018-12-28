library(tidyverse)

# get the whole 60 samples raw salmon quant in a matrix (raw salmon counts of the genes)
# The numReads column is kept. The sample name have underscore instead of dash in it. The 
# geneID is rowname, and it has trimmed anything since the dot

setwd('/Users/angelD/undertaking/bioinformatics_container/RF_Lab_project/ALT2/analysis/01_DE_osAndNonAlt/scripts/')

fns <- list.files(path = '../data/salmon_raw_quant', pattern = 'quant.genes.sf',recursive = T ,full.names = T)


quant.list <- lapply(fns, function(fn){
  ret = read_tsv(fn) %>%
    dplyr::select(Name, NumReads) %>%
    mutate(Sample = fn) %>%
    mutate(Sample = str_replace_all(Sample, '../data/salmon_raw_quant/','')) %>%
    mutate(Sample = str_replace_all(Sample, '_salmon_quant/quant.genes.sf',''))  %>%
    mutate(Name = str_replace_all(string = Name, pattern = '\\..*$', replacement = '')) %>%
    filter(!duplicated(Name))
  return(ret)
})


quant.df <- bind_rows(quant.list)

CTS <- spread(quant.df, key = Sample, value = NumReads) %>%
  column_to_rownames('Name') %>%
  rename_all(
    funs(stringr::str_replace_all(.,'RF-',''))
  ) %>%
  as.matrix()


write.csv(CTS, '../data/raw_salmon_cts_60samples_58174features.csv', quote = F)