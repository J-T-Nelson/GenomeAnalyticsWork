# Working Space 1: 2-20-23
#

callVariants <- data.table::fread("C:\\Users\\Tanner_N\\Downloads\\Galaxy29-[VCFtoTab-delimited__on_data_22].tabular")

bcfToolsCall <- data.table::fread("C:\\Users\\Tanner_N\\Downloads\\Galaxy28-[VCFtoTab-delimited__on_data_23].tabular")

str(callVariants)
str(bcfToolsCall)

cvPos <- callVariants$POS
bcfPos <- bcfToolsCall$POS

summary(bcfPos)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
# 31    7496   14966   14964   22431   29894
summary(cvPos)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
# 31    7449   14814   14884   22331   29894

# so we are seeing the same min and max which is good. Curious that there are so many extra values within cvPos..
tail(cvPos)
cvUni <- unique(cvPos) # now down to 29864 positions ... that is a lot of duplicates...

duplicatesCV <- setdiff(cvPos, cvUni) # empty return... hm
?setdiff

bcfUni <- unique(bcfPos) # same uniques contained... The extra rows were introduced by the convert to tab delimited format call.. bit strange. Don't think prof inteded that to happen

library(vcfR)

?vcfR

intersectionGalaxy <- data.table::fread("C:\\Users\\Tanner_N\\Downloads\\Galaxy31-[VCFtoTab-delimited__on_data_30].tabular")

# lets look at what positions are duplicates within the bcfPos vec ... so why are they duplicated?
dupeBCF <- bcfPos[duplicated(bcfPos)]
dupeBCF

# [1]   685  1011  1628  2495  4710  4720  5605  8656  8665 13010 15245 16515 16800 16816 16837 18657 19618 26466 26574 26774 27190 27194 27828 27868
# [25] 28394 28971

dupeRowsEX <- bcfToolsCall[c(625:675),]
dupeRowsEX <- dupeRowsEX[c(31,32), ]
# they're now isolated, and what is interesting is that one call says there is no variant... and another call has a different reference and variant... so are there duplicate positions within the reference as well?
#
#

spikeProteinLocation <- 21563:25384
vcfCallsInSpike <- intersect(bcfPos, spikeProteinLocation) # turns out every position is accounted for... so yes the reference must be the source of the duplicate variant positions we are seeing.. still ask Pond bout it.
spikeRows <- bcfToolsCall[21500:26500, ]

# Filtering tables for locations where variants were called

bcfVariants <- bcfToolsCall[bcfToolsCall$ALT != "." , ] # only 43 observations.. just like the intersection!
VCvariants <- callVariants[callVariants$ALT != "<*>", ] # this has 8523 variants instead. Whew. That is a major difference.

# removing unnecessary cols

bcfVarLess <- bcfVariants[, c('POS', 'REF', 'ALT')]
VCvarLess <- VCvariants[, c('POS', 'REF', 'ALT')]

intersection_vc_bcf <- intersect(VCvarLess, bcfVarLess) # nothing
intersection_vc_bcf <- intersect(VCvarLess$POS, bcfVarLess$POS)
length(intersection_vc_bcf) # 43
# alright so they are intersecting in position... but not intersection on the specific variants?
mask <- VCvarLess$POS %in% intersection_vc_bcf

matchesVC <- VCvarLess[mask]

interTest <- intersect(VCvarLess, matchesVC) # none.. ok maybe intersection doesn't work against rows naturally
?intersect

library(generics) # this package has a version of intersect that does what I want
?generics
detach(generics) # unataching s.t. I have access to base calls.

interTest <- generics::intersect(VCvarLess, matchesVC) # still no matches.. wow. Func just isn't working... there is undoubtedly matches I can see with my own eyes. hm. Annoying these functions don't quite work.

?intersect

install.packages("VennDiagram")
?VennDiagram


# ok Venn diagram strategy. ... for all 3 VCF files I need to filter down to just the variants with ALT calls, then grab the 3 cols POS, REF, ALT, then digest each into a txt file by pasting the rows as single strings, then upload those three text files to the given website.


# after the venn diagram task I can move onto finding the variants which are within the spike element by filtering out all values not in the spike range from the variants with alternates. Then I can simply report on them somehow.


freeBayesCall <- data.table::fread("C:\\Users\\Tanner_N\\Downloads\\Galaxy35-[VCFtoTab-delimited__on_data_25].tabular")

freeBayesLess <- freeBayesCall[, c('POS','REF','ALT')]
freeBayesLess <- freeBayesLess[ freeBayesLess$ALT != ".",]


?writeLines
?unlist

unl <- paste(unlist(VCvarLess[1,]), collapse = "_") # how smesh
unl = rep(unl, 40)
writeLines(unl, con = 'tstfile.txt') # how write


rowsToTextFile <- function(dataFrame, fileName = "defaultName.txt"){

  retVec <- character(length(nrow(dataFrame)))

  for(i in 1:nrow(dataFrame)){
    retVec[i] <- paste(unlist(dataFrame[i, ]), collapse = "_")
  }

  writeLines(retVec, con = fileName)
}

rowsToTextFile(VCvarLess, "variantCall_VCF_SARScov.txt")
rowsToTextFile(bcfVarLess, "bcf_VCF_SARScov.txt")
rowsToTextFile(freeBayesLess, "freeBayes_VCF_SARScov.txt")

# Production of txt files for VennDiagram complete




spikeProteinLocation <- 21563:25384

numNucleotides <- 25384 - 21563
numProteins <- round(numNucleotides/3)

# which amino acids from 400 to 550 ?
range <- 3*c(400, 550)
range # 1200, 1650
nucleotideRange <- 25384+c(range)
nucleotideRange # 26584 27034

variants_of_interest_range <- 26584:27034

spikeVars_bcf <- bcfVarLess[bcfVarLess$POS %in% variants_of_interest_range, ]
spikeVars_bcf

spikeVars_VC <- VCvarLess[VCvarLess$POS %in% variants_of_interest_range, ]
spikeVars_VC

spikeVars_freeBayes <- freeBayesLess[freeBayesLess$POS %in% variants_of_interest_range, ]
spikeVars_freeBayes

write.csv(spikeVars_bcf, file = "spikeVars_bcf.csv")
write.csv(spikeVars_VC, file = "spikeVars_VC.csv")
write.csv(spikeVars_freeBayes, file = "spikeVars_freeBayes.csv")


















































































































