# The goal of this file is to read and prepare the data. The data come from a Wikipedia Table of Monuments.
# The data describe all the monuments and locations of Cantabria, North Spain monuments.


# load libraries
library(dplyr)
library(tidyr)
library(stringr)

# Read data
Cant_Patrimonio <- read.csv("./data/Patrimonio.csv", encoding="UTF-8",sep=";",header=TRUE,stringsAsFactors = FALSE)

#Our coordinates are in Grades Minutes and Seconds, is needed to transform into decimal grades, but first
#separate data into latitud and longitude.
Cant_Patrimonio$Grados_Lat <- matrix(unlist(str_sub(Cant_Patrimonio$Coordenadas,start=1,end = 10)), ncol=1, byrow=TRUE)
Cant_Patrimonio$Grados_Long <- matrix(unlist(str_sub(Cant_Patrimonio$Coordenadas,start=-10)), ncol=1, byrow=TRUE)

#(23° 08' 06'' N) = (23 + (08 / 60) + (06 / 3600)) = 23.134999
#If coordinates are South or West values are negative.

if (str_sub(Cant_Patrimonio$Grados_Lat,start=10,end=10) =='N') {
        Cant_Patrimonio$Latitud <- as.numeric(str_sub(Cant_Patrimonio$Grados_Lat,start=1,end=2)) + as.numeric(str_sub(Cant_Patrimonio$Grados_Lat,start=4,end=5))/60 + as.numeric(str_sub(Cant_Patrimonio$Grados_Lat,start=7,end=8))/3600
        
} else {
        Cant_Patrimonio$Latitud <- as.numeric(str_sub(Cant_Patrimonio$Grados_Lat,start=1,end=2)) + as.numeric(str_sub(Cant_Patrimonio$Grados_Lat,start=4,end=5))/60 + as.numeric(str_sub(Cant_Patrimonio$Grados_Lat,start=7,end=8))/3600
        Cant_Patrimonio$Latitud <- Cant_Patrimonio$Latitud *-1
}

if (str_sub(Cant_Patrimonio$Grados_Long,start=10,end=10) =='E') {
        Cant_Patrimonio$Longitud <- as.numeric(str_sub(Cant_Patrimonio$Grados_Long,start=2,end=2)) + as.numeric(str_sub(Cant_Patrimonio$Grados_Long,start=4,end=5))/60 + as.numeric(str_sub(Cant_Patrimonio$Grados_Long,start=7,end=8))/3600
        
} else {
        Cant_Patrimonio$Longitud <- as.numeric(str_sub(Cant_Patrimonio$Grados_Long,start=2,end=2)) + as.numeric(str_sub(Cant_Patrimonio$Grados_Long,start=4,end=5))/60 + as.numeric(str_sub(Cant_Patrimonio$Grados_Long,start=7,end=8))/3600
        Cant_Patrimonio$Longitud <- Cant_Patrimonio$Longitud *-1
}


drops <- c("Coordenadas","X","Licencia_Imagenes","Grados_Lat","Grados_Long")
clean_Cant_Patrimonio <- Cant_Patrimonio[ ,!(names(Cant_Patrimonio) %in% drops)]



# We need to draw a map with the localization of the events, so we remove observations 
# with no latitude or longitude
clean_Cant_Patrimonio <- clean_Cant_Patrimonio %>% subset(!is.na(Latitud) & !is.na(Longitud) & !is.na(Poblacion))

# Then we get the list of regions
Regions <-clean_Cant_Patrimonio$Poblacion %>% unique() %>% sort() 


# At last, we display only the main columns
DisplayedColumns <- c("X.U.FEFF.Nombre","Tipo","Categoria","Municipio","Poblacion")
