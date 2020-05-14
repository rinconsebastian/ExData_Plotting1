#Autor: Felix Sebastian Rincon Tobo
#Date: 13/05/2020

#libraries
if (!require('data.table')) install.packages('data.table'); library('data.table') # install data.table and load it
if (!require('dplyr')) install.packages('dplyr'); library('dplyr') # install dplyr and load it
if (!require('readr')) install.packages('readr'); library('readr') # install readr and load it


#readign data

data <-fread("household_power_consumption.txt")

#setting date and time correct data type

data <- data %>% mutate(DateTime = as.POSIXct(paste(Date,Time,sep = " "), format = "%d/%m/%Y %H:%M:%S"))

#converting text columns in numeric values and setting NAa
data <- data %>% mutate(Global_active_power =  parse_number(Global_active_power, na = "?"),
                        Global_reactive_power =  parse_number(Global_reactive_power, na = "?"),
                        Voltage =  parse_number(Voltage, na = "?"),
                        Sub_metering_1 =  parse_number(Sub_metering_1, na = "?"),
                        Sub_metering_2 =  parse_number(Sub_metering_2, na = "?"))


#filter dates
data <- data %>% filter(DateTime >= as.POSIXct("2007-02-01 00:00:01", format = "%Y-%m-%d %H:%M:%OS") & 
                                DateTime <= as.POSIXct("2007-02-02 23:59:59", format = "%Y-%m-%d %H:%M:%S")) 
        
#PLOT
par(mfcol = c(2,2)) #adjust device cols and rows

#First Plot 
with(data, plot(DateTime,Global_active_power, type = "l", ylab = "Global Active Power (Kilowatts)", xlab = NA))

#Second plot
plot(data$DateTime, data$Sub_metering_1,  type = "l", ylab = "Energy sub metering", xlab = NA) #generating plot and  add 1st submetering
lines(data$DateTime, data$Sub_metering_2, col="red") #adding 2nd submetering
lines(data$DateTime, data$Sub_metering_3, col="blue")#adding 3th submetering

legend("topright",         # Making legend      
       legend = c("Sub metering 1","Sub metering 2","Sub metering 3"), 
       pch = c("-","-","-"), 
       col = c("black","red","blue"))

#Third plot
with(data, plot(DateTime,Voltage, type = "l", ylab = "Voltage", xlab = "datatime"))

#Fourth plot
with(data, plot(DateTime,Global_reactive_power, type = "l", ylab = "Global reactive power", xlab = "datatime"))


#save png
dev.copy(png,"plot4.png", width = 480, height = 480, units = "px")
dev.off()