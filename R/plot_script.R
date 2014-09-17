#time series plot of csv data downloaded from dbees.com
#command line argument is the csv file

args = commandArgs(TRUE)
input = args[1]
file = gsub("../csv_files/", "", input)
output = gsub("csv", "pdf", file)

library("ggplot2")
library("Cairo")

data = read.csv(file = input, header = TRUE, sep = ";")
data$Time = paste(data$GIVEN_DATE, data$COL_TIME, sep = " ")
data$Time = as.POSIXlt(data$Time, format="%Y-%m-%d %H:%M", tz="Europe/Berlin")

plot = ggplot(data, aes(x = Time, y = GLYCEMIA_READING))
plot = plot + geom_point(size = 4)
plot = plot + theme_bw()
plot = plot + ylab("Glycemy (mg/dl)")
plot = plot + xlab("")
plot = plot + theme(axis.text.x = element_text(angle = 90))
plot = plot + theme(axis.text.y = element_text(size = 18))
plot = plot + theme(axis.text.x = element_text(size = 14))
plot = plot + theme(axis.title.y = element_text(face = "bold", size = 24))
plot = plot + scale_x_datetime(breaks = "1 day")

CairoPDF(file = output, width = 25, height = 18)
print(plot)
dev.off()
