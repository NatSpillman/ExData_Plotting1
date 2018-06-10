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

##Create plot 4
png(filename = "plot4.png", width = 480, height = 480, units = "px")
par(mfrow= c(2,2)) ## fills row-wise
with(twodays, {
        ## plot top left
        plot(datetime, Global_active_power, type= "l", 
             ylab= "Global Active Power", xlab= "",las= 0)
        
        ## plot top right
        plot(datetime, Voltage, type= "l", 
             ylab= "Voltage", xlab= "datetime",las= 0)
        
        ## plot bottom left
        plot(datetime, Sub_metering_1, type= "l", 
                ylab= "Energy sub metering", xlab= "",las= 0, col = "black")
        lines(datetime, Sub_metering_2, type= "l", col = "red")
        lines(datetime, Sub_metering_3, type= "l", col = "blue")
        legend("topright", legend= c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
        lty=1, col= c("black", "red", "blue"), bty ="n")       

        ## plot bottom right
        plot(datetime, Global_reactive_power, type= "l", 
             ylab= "Global_reactive_power", xlab= "datetime",las= 0)
                })
dev.off()
