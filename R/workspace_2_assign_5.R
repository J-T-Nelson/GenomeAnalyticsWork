# Working on Assign 5 here:
#


# Importing TDFs for further analysis.
bcf_VCFtoTDF<- data.table::fread("D:\\Programming\\R_projects\\GenomeAnalyticsWork\\galaxy_data\\bcf_Galaxy46-[VCFtoTab-delimited__on_data_37].tabular")
freeBayes_VCFtoTDF<- data.table::fread("D:\\Programming\\R_projects\\GenomeAnalyticsWork\\galaxy_data\\freeBayes_Galaxy47-[VCFtoTab-delimited__on_data_40].tabular")
loFreq_VCFtoTDF<- data.table::fread("D:\\Programming\\R_projects\\GenomeAnalyticsWork\\galaxy_data\\loFreq_Galaxy48-[VCFtoTab-delimited__on_data_42].tabular")


# Cleaning data frames for ease of use (remove unnecessary cols and rows)



# Finding 3 way intersection of Variants (intersect 1 and 2, then intersect that against the 3rd)




# create protein position encoding col and append to 3 way intersection


