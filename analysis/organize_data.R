#' ---
#' title: "organize_data.R"
#' author: "Erik Michael Rummell"
#' ---

# This script will read in raw data from the input directory, clean it up to produce 
# the analytical dataset, and then write the analytical data to the output directory. 

#source in any useful functions
library(readxl)
Data_Set <- read_excel("analysis/input/Data Set.xlsx", na="N/A")

mens <- subset(Data_Set, 
               select=c("School","Year","Men's Record",
                        "Men's Att. (Home avg.)","Men's Revenue ($)",
                        "March Madness (M)? (0 = No, 1 = Yes)"))


womens <- subset(Data_Set, 
                 select=c("School","Year","Women's Record",
                          "Women's Att. ( Home avg.)","Women's Revenue ($)",
                          "March Madness (W)? (0 = No, 1 = Yes)"))

colnames(womens) <- colnames(mens) <- c("school","year","record","attendance","revenue", "march_madness")

mens$gender <- "M"
womens$gender <- "W"

basketball <- rbind(mens, womens)

records <- strsplit(basketball$record, "-")
records <- t(simplify2array(records))
basketball$wins <- as.numeric(records[,1])
basketball$losses <- as.numeric(records[,2])
basketball$win_percent <- 100*basketball$wins/(basketball$wins+basketball$losses)

basketball <- subset(basketball,
                     select=c("school","year","gender","attendance","revenue","wins","losses","win_percent","march_madness"))
save(basketball, file="analysis/output/analytical_data.RData")
