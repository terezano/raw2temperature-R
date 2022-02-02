# raw2temp - convert raw thermal values to temperature

The purpose of this script is to convert raw thermal values obtained from a thermal camera into temperature values in °C using the package __ThermImage__ for R. 
For further info please visit [gtatters/ThermimageCalibration](https://github.com/gtatters/ThermimageCalibration).

# Getting started
You will need to download two packages from CRAN repository: [ThermImage](https://cran.r-project.org/web/packages/Thermimage/index.html) and [fields](https://cran.r-project.org/web/packages/fields/index.html)
and ExifTool. 

## Prerequisites
### Downloading ExifTool

```
On https://exiftool.org. download the Windows Executable 'exitool(-k).exe', 
rename it to 'exiftool.exe' and move it to Windows root (C://Windows).
```

### Install R packages
```
install.packages(Thermimage)
install.packages(fields)
```

# Usage
# Set working directory
```
wd <- setwd("patj-to-wd)
```

## Start the counter
```
n <- 0
```

## Loop through list of images and convert them to CSV, the default separator is semi-colon (;). 
If Exiftool is installed in Windows root leave "installed" otherwise exiftoolpath = "path-to-exiftool".
The CSV output name created is "name_RT.csv".

```
for (file in jpg_list){
  n <- n + 1
  strip_extension <- str_remove(file, ".jpg") #remove JPG extension from each image
  img <- readflirJPG(file, exiftoolpath = "installed") #read each image by exiftool
  
  write.csv(img, paste(wd, "/", strip_extension, "_RT", ".csv", sep=""), row.names = FALSE) #create a CSV file from each JPG file with original name and _RT (raw temperature) extension
}

```
## Import raw temperature CSVs
```
raw_temp_csv <- list.files(path = wd, pattern = "_RT.csv")
```

## Loop through raw temperature CSVs and convert each one to temperature using __raw2temp__ function from ThermImage.
The CSV file is converted to matrix and the result is rounded to two desimal places.
The name of the final output is "name_temp.csv" as the "_RT" from previous file is removed.

```
for (file in raw_temp_csv){
  raw_csv <- read.csv(file)
  
  temp <- round(raw2temp(as.matrix(raw_csv), E=0.95, OD=1, RTemp=20, ATemp=20, IRWTemp=20, IRT=0.96, RH=50, 
                   PR1=21106.77, PB=1501, PF=1, PO=-7340, PR2=0.012545258),digits=2) #round to 2 decimals
  
  strip_RT <- str_remove(file, "_RT.csv") #strip csv extension
  write.csv(temp, paste(strip_RT,"_temp",".csv", sep=""), row.names = FALSE) #write temperature data
}
```
