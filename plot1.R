##Download file, unzip, format dates/times, subset for 2007-02-01/2007-02-02 dates
dlMethod <- "curl"
if(substr(Sys.getenv("OS"),1,7) == "Windows") dlMethod <- "wininet" 

url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

if(!file.exists("power.zip")) {
        download.file(url, destfile='power.zip', method=dlMethod, mode="wb")
        ## unpack the files
        unzip(zipfile = "power.zip")        
}
dataall <- read.table("household_power_consumption.txt", sep = ";", header= TRUE, na.strings= "?")
dataall$Date<-as.Date(dataall$Date,format = "%d/%m/%Y")
dataall$datetime<- paste(dataall$Date,dataall$Time)
dataall$datetime<-as.POSIXct(dataall$datetime, format = "%Y-%m-%d %H:%M:%S")

##subset for 2007-02-01/2007-02-02 dates
day1 <- dataall[grepl("2007-02-01", dataall$datetime),]
day2 <- dataall[grepl("2007-02-02", dataall$datetime),]
twodays <- rbind(day1,day2)

##Create plot 1
png(filename = "plot1.png", width = 480, height = 480, units = "px")
with(twodays, hist(Global_active_power, main ="Global Active Power", col = "red", 
                   xlab="Global Active Power (kilowatts)", las= 0))
dev.off()
