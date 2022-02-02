######################################################################################################################
#                                                                                                                    #
#   Download Win Executable from https://exiftool.org. Rename the file from "exiftool(-k).exe" to "exiftool.exe" and #
#   move to C:/Windows. You will need ThermImage and fields packages available from CRAN.                                                                                               #
######################################################################################################################
#install.packages(Thermimage)
library(Thermimage)
#install.packages(fields)
library(fields)

wd <- setwd("path2wd") #working dir
jpg_list <- list.files(path=wd, pattern="*.jpg") #strip JPG extension
n <- 0 #start counter


for(file in jpg_list) { #for file in list of jpegs, strip extension, read the image and export to CSV
  n <- n+1
  #print(n)
  #print(file)
  #print(paste(wd,"/",file,sep=""))
  
  strip_extension <- str_remove(file, ".jpg") #get rid of JPEG
  img<-readflirJPG(file, exiftoolpath="installed") #read JPEG by exiftool
  
  write.csv(img, paste(wd,"/", strip_extension,"_RT",".csv", sep=""), row.names = FALSE) #write raw temperature data in CSV
 
}

################################################################################################################

raw_temp_csv <- list.files(path=wd, pattern="*_RT.csv") #load raw csv temperatures

for(file in raw_temp_csv){ #for file in list of raw temperatures convert to matrix, apply raw2temp function and export to csv
  #raw_matrix <- as.matrix(raw_temp_csv)
  
  raw_csv <- read.csv(file)
  temp <- round(raw2temp(as.matrix(raw_csv), E=0.95, OD=1, RTemp=20, ATemp=20, IRWTemp=20, IRT=0.96, RH=50, 
                   PR1=21106.77, PB=1501, PF=1, PO=-7340, PR2=0.012545258),digits=2) #round to 2 decimals
  
  strip_RT <- str_remove(file, "_RT.csv") #strip csv extension
  write.csv(temp, paste(strip_RT,"_temp",".csv", sep=""), row.names = FALSE) #write temperature data
}
