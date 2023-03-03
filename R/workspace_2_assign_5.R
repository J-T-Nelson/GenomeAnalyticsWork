# Working on Assign 5 here:


# Importing TDFs for further analysis.
bcf_VCFtoTDF<- data.table::fread("C:/Users/mrtne/Downloads/bcf_Galaxy46-[VCFtoTab-delimited__on_data_37].tabular")
freeBayes_VCFtoTDF<- data.table::fread("C:/Users/mrtne/Downloads/freeBayes_Galaxy47-[VCFtoTab-delimited__on_data_40].tabular")
loFreq_VCFtoTDF<- data.table::fread("C:/Users/mrtne/Downloads/loFreq_Galaxy48-[VCFtoTab-delimited__on_data_42].tabular")


# Cleaning data frames for ease of use (remove unnecessary cols and rows)
#
#
bcfClean <- bcf_VCFtoTDF[,c('POS', 'REF', 'ALT', 'ANN')]
bcfClean <- bcfClean[bcfClean$ANN %in% NULL, ] # 0 rows remain... so sending to tab may have removed the info we want.... hm

as.logical(sapply(bcfClean$ANN, is.null))
bcfClean$ANN %in% NULL # two diff ways to filter this ...

sum(bcf_VCFtoTDF$ANN %in% NULL) #0

#filtering differently to ensure I am seeing things correctly

bcfClean <- bcf_VCFtoTDF[bcf_VCFtoTDF$ALT != '.',]
# looks good. ANN is not null in these positions. Seems my use of %in% for NULL was incorrect. Nothing is within a NULL set.. so ofcoure no true would be produced... NULL is thus not behaving the same as NA? or at least not the same as some default value which can be tested against, which is annoying in this case.

a <- as.logical(!is.null(bcfClean$ANN))


# Process freeBayes:

freeBayesClean <- freeBayes_VCFtoTDF[freeBayes_VCFtoTDF$ALT != '.']

# Process loFreq
install.packages('VariantAnnotation') # on bioconductor
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("VariantAnnotation")
library(VariantAnnotation)

loFreq_VCFtoTDF <- readVcfAsVRanges("C:/Users/mrtne/Downloads/lowFreq_Galaxy42-[SnpEff_eff__on_data_21].vcf")

loFreq_VCFtoTDF <- as.data.frame(loFreq_VCFtoTDF) # works ... can all lists be turned to DFs this way... sheesh I hope so and hope not right now lol... gotta check that next sesh w/ Kulas stuff

loFreqClean <- loFreq_VCFtoTDF[,c('start', 'ref', 'alt', 'ANN')]
colnames(loFreqClean) <- c("POS", "REF", "ALT", "ANN")
colnames(loFreqClean)

loFreqANN <- as.character(loFreqClean$ANN)
loFreqClean$ANN <- loFreqANN
# Finding 3 way intersection of Variants (intersect 1 and 2, then intersect that against the 3rd)
#
#
bcfClean <- data.table::as.data.table(bcfClean)
freeBayesClean <- data.table::as.data.table(freeBayesClean)
loFreqClean <- data.table::as.data.table(loFreqClean)

bcf_Bayes_intersect <- data.table::fintersect(bcfClean[,c("POS", "REF", "ALT", "ANN")], freeBayesClean[,c("POS", "REF", "ALT", "ANN")])

bcf_Bayes_loFreq_intersect <- data.table::fintersect(bcf_Bayes_intersect, loFreqClean)



# create protein position encoding col and append to 3 way intersection
#
#

labels <- c('NA','ORF1a_polyprotein', 'ORF1ab_polyprotein', 'Spike', 'ORF3a_protein', 'envelope_protein', 'membrane_glycoprotein', 'ORF6_protein', 'ORF7a_protein', 'ORF7b', 'ORF8_protein', 'nucleocapsid_phosphoprotein', 'ORF10_protein')
buckets <- c(0, 265, 13483, 21555, 25384, 26220, 26472, 27191, 27387, 27759, 27887, 28259, 29533, 29674)
# buckets are imperfect.. as genomic ranges are actually discontiguous protein to protein.. not going to that level of detail though here.
#


# use cut() to generate labels for each value in the vector
protein_labels <- cut(bcf_Bayes_loFreq_intersect$POS, breaks = buckets, labels = labels, include.lowest = TRUE)
protein_labels
prot_labels <- as.character(protein_labels)
prot_labels
bcf_Bayes_loFreq_intersect[,'prot_labels'] <- prot_labels

write.csv(bcf_Bayes_loFreq_intersect, 'bcf_Bayes_loFreq_intersect.csv')





# scrapped work below
#
#

