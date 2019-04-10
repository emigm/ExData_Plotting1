# It gathers the datasets needed for creating the plots by following these steps:
# 1. It creates a directory named datasets in your working directory.
# 2. Unizp the file into the datasets directory.
download_dataset <- function () {
    dir_path <- file.path(getwd(), "datasets")

    if (! file.exists(dir_path)) {
        dir.create(dir_path, mode="0755")
    }

    file_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    file_path <- file.path(dir_path, 'household_power_consumption.zip')

    if (! file.exists(file_path)) {
        download.file(file_url, destfile=file_path, method="curl")
    }

    unzipped_dir_path <- file.path(dir_path, dir_path)

    if (! file.exists(unzipped_dir_path)) {
        unzip(file_path, exdir=dir_path)
    }
}

# Download dataset.
download_dataset()

# Read dataset.
data <- read.table("./datasets/household_power_consumption.txt", header=TRUE, sep=";", na.strings="?")

# Transform Date strings to Date objects.
data$Date <- as.Date(data$Date, format="%d/%m/%Y")

# Subset the dataset to contain only data from 2007-02-01 to 2007-02-02.
narrowed_data <- data[data$Date == as.Date("2007-02-01", format="%Y-%m-%d") | data$Date == as.Date("2007-02-02", format="%Y-%m-%d"), ]

# Transform Time strings to POSIXlt objects.
narrowed_data$Time <- strptime(paste(narrowed_data$Date, narrowed_data$Time), format="%Y-%m-%d %H:%M:%S", tz="UTC")

# Create the plot.
png(filename="plot3.png", width = 480, height = 480)

with(narrowed_data, plot(Time, Sub_metering_1, type="l", xlab="", ylab=""))
with(narrowed_data, points(Time, Sub_metering_2, type="l", col="red"))
with(narrowed_data, points(Time, Sub_metering_3, type="l", col="blue"))
title(ylab="Energy sub metering")
legend("topright", pch=NA, lty=1, col=c("black", "red", "blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

dev.off()
