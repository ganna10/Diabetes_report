#Manupulate csv data downloaded from dbees.com for report
#command line argument is the csv file

args = commandArgs(TRUE)
input = args[1]
file = gsub("csv_files/", "csv_files/out_", input)

data = read.csv(file = input, header = TRUE, sep = ";")
data[is.na(data)] = c("")
data$COL_TIME = paste(data$GIVEN_DATE, data$COL_TIME, sep = " ")
data$GIVEN_DATE = NULL
data$MEAL_SIZE = NULL
data$PHYS_SCALE = NULL
data$WEIGHT_READING = NULL
colnames(data) =  c("Activity", "Time", "Meal", "Text", "InsulinType", "UnitsInjected", "GlycemiaTiming", "GlycemiaReading", "Exercise")
data$Time = as.POSIXlt(data$Time, format="%Y-%m-%d %H:%M", tz="Europe/Berlin")
data = data[order(data$Time),]

write.table(data, file = file, row.names = FALSE, quote = FALSE, sep = "|")
