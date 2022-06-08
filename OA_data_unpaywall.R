# Author: Victoria Yan, EMBL OSIM 2022
# Function for get_API_response modified from Michael Parkins Europe PMC

# This script takes a list of DOI from an input .csv, fetches the API from Unpaywall and extracts OA data
# The input could be the .csv results saved from a pubmed alert.

# Load packages
library(roadoi)
library(tidyverse)
library(jsonlite)
#library(tibble)

# Create a function to fetch the API response
# The function takes a single parameter: a DOI
# It uses the 'oadoi_fetch' function in the 'roadoi' package
# fetch is http request
get_API_response<- function(doi){
  api_response <- roadoi::oadoi_fetch(dois = doi,
                                      email = 'victoria.yan@embl.de')
  if(!is_empty(api_response)){  # if the Unpaywall API returned a result
    response <- api_response#[[1, 'oa_status']]  # return the value from row 1, column called 'oa_status'
    return(response)  # return the color name as an output of the function
  } else {
    return(NA)  # else return a missing value, NA = "Not Available" in R
  }
}

## Input the DOI here in the function
output <- get_API_response('10.1038/s41587-021-01033-z')
# or import directly from URL, see doi in URL
test <- fromJSON("https://api.unpaywall.org/v2/10.1038/nature12373?email=victoria.yan@embl.de")

str(parsedData) #check data structure, is a list of 23
color <- output[[1,'oa_status']]
license <- output[[1,'best_oa_location.license']]
is_oa <- output[[1,'is_oa']]

# Place in dataframe, get a very long dataframe without any nested elements
ListDF <- enframe(unlist(output)) #enframe here comes from tibble, part of tidyverse

## Now that this works, let's run this for a list of dois
# first read in the dois
EMBLpub <- read.csv(file = 'data/20220427_pubmed_alert.csv')
dois <- EMBLpub[11] # get the second column which is DOIs

# Create a data frame to fill
df <- data.frame("doi", "Title", "Is_OA","OA_route","OA_journal")

# Loop through DOI, get API response, append to a single data frame

for(i in 1:nrow(dois)){
  cDoi = dois[i,1] # get the doi at the i location
  coutput <- get_API_response(cDoi) # fetch response of this article
  cparseOutput <- enframe(unlist(coutput))
  
  # extract the data we need dataframe which has field names
  df[i,1] <- cDoi
  #because all of the resulting data lists are different length,
  # the index is different, we use the "which" function
  # to identify the row of the correct variable name
  # this is pretty annoying, I can try to clean it up next.
  if(!is_empty(cparseOutput[which(cparseOutput[,1]=="title"),2])){ 
    df[i,2] <- cparseOutput[which(cparseOutput[,1]=="title"),2]
  } else {
    df[i,2] <- "N/A" 
  }
  
  if(!is_empty(cparseOutput[which(cparseOutput[,1]=="is_oa"),2])){ 
    df[i,3] <- cparseOutput[which(cparseOutput[,1]=="is_oa"),2]
  } else {
    df[i,3] <- "N/A" 
  }

  if(!is_empty(cparseOutput[which(cparseOutput[,1]=="oa_status"),2])){
    df[i,4] <- cparseOutput[which(cparseOutput[,1]=="oa_status"),2]
  } else {
    df[i,4] <- "N/A"
  }

  if(!is_empty(cparseOutput[which(cparseOutput[,1]=="journal_is_oa"),2])){
    df[i,5] <- cparseOutput[which(cparseOutput[,1]=="journal_is_oa"),2]
  } else {
    df[i,5] <- "N/A"
  }
  print(i)
}

# Save the data in a csv file
write.csv(df,"data/20220427_PMCalert_Unpaywall_results.csv", row.names = FALSE)
