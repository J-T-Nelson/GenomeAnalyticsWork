# testing functions for verifying if there are equivalent rows within two data frames..


data1 <- data.frame(x1 = 1:5,                      # Create first example data
                    x2 = letters[1:5],
                    x3 = "x")

data2 <- data.frame(x1 = 3:6,                      # Create second example data
                    x2 = letters[3:6],
                    x3 = c("x", "x", "y", "y"))
data1
data2
# I see two matching rows. they don't have matching indices
#

data_common1 <- generics::intersect(data1, data2)
data_common1 <- intersect(data1, data2)# also nothing
data_common1 # empty... so.... something is wrong with my system because a tutorial is legit saying that this should work. What the hell.
?intersect

data1 <- data.table::as.data.table(data1)
data2 <- data.table::as.data.table(data2)
data_common2 <- data.table::fintersect(data1, data2, all = T)
data_common2 # this works for getting rows that are duplicates... another use for the often confusing data.table package.
# so strange how other intersects don't work... wonder what the difference is with these.. maybe they are broken in the version of R i have or something for some reason.



































