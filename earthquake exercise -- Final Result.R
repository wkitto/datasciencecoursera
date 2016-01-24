#exercise to generate a map with overlaid data

######                                                                       ######
###### this is my take on copying http://www.data.scec.org/recent/index.html ######
###### David Stetson 20131105                                                ######

# load the maps library
if(!require("maps")) {install.packages("maps");require("maps")}
if(!require("sqldf")) {install.packages("sqldf");require("sqldf")}

# get the earthquake data from the USGS
#url="http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.csv"
#eq1 <- read.csv(url,header = TRUE,stringsAsFactors=FALSE)
url="http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_week.csv"
eq1 <- read.csv(url,header = TRUE,stringsAsFactors=FALSE)
url="http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.csv"
eq2 <- read.csv(url,header = TRUE,stringsAsFactors=FALSE)
url="http://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.csv" 
eq3 <- read.csv(url,header = TRUE,stringsAsFactors=FALSE)

ca1<-sqldf("select * from eq1 where (place like ('%California') or place like '%Nevada') and type='earthquake' and mag>=0.5 order by mag desc")
ca2<-sqldf("select * from eq2 where (place like ('%California') or place like '%Nevada') and type='earthquake' and mag>=0.5 order by mag desc")
ca3<-sqldf("select * from eq3 where (place like ('%California') or place like '%Nevada') and type='earthquake' and mag>=0.5 order by mag desc")

windows(width=11,height=8) # inches

mag1<-round(log10(5^ca1$mag),1)/10
mag2<-round(log10(5^ca2$mag),1)/10
mag3<-round(log10(5^ca3$mag),1)/10

map(database="state",region=c("california","nevada"),xlim=c(-130,-110),fill=TRUE,col="#FFCC99")

if(nrow(ca1)>0) symbols(ca1$lon,ca1$lat,bg="yellow",fg="black",lwd=1,squares=mag1,add=TRUE,inches=FALSE)
if(nrow(ca2)>0) symbols(ca2$lon,ca2$lat,bg="#3399FF",fg="black",lwd=1,squares=mag2,add=TRUE,inches=FALSE)
if(nrow(ca3)>0) symbols(ca3$lon,ca3$lat,bg="red",fg="black",lwd=1,squares=mag3,add=TRUE,inches=FALSE)

text(-112,41.5,"Magnitudes")
mag<-round(log10(5^(7:1)),1)/10
symbols(rep(-112,7),seq(41,36,length.out=7),bg="white",fg="black",lwd=1,squares=mag,add=TRUE,inches=FALSE)
text(rep(-112,7)[1:4],seq(41,36,length.out=7)[1:4],7:4)
text(rep(-112,7)[5:7]+0.4,seq(41,36,length.out=7)[5:7],3:1)
text(rep(-111.5,3),seq(35,34,length.out=3),labels=c("Last Week","Last Day","Last Hour"))
symbols(rep(-112.75,3),seq(35,34,length.out=3),bg=c("yellow","#3399FF","red"),fg="black",lwd=1,squares=rep(mag[5],3),add=TRUE,inches=FALSE)

title("Map of Recent Earthquakes in CA and NV")
map.axes()
map.scale(x=-112.8,y=33.6,metric=TRUE,relwidth=0.08,ratio=FALSE,cex=0.8)
map.scale(x=-113,y=33.0,metric=FALSE,relwidth=0.09,ratio=FALSE,cex=0.8)
text(-126,32.6,paste(nrow(ca1)+nrow(ca2)+nrow(ca3),"earthquakes on this map"))
text(-126,33,date(),col="red",cex=1.1)
#rm(eq1,eq2,eq3,ca1,ca2,ca3,mag1,mag2,mag3,mag,url)
