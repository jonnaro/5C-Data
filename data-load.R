# 5Calls - Data Load

# LOAD PACKAGES
#===============
library(RSQLite)
library(dplyr)
library(tidyr)
#===============

# LOAD DATA
#==========
system("ls *.db", show=TRUE)
sqlite   <- dbDriver("SQLite")
callsdb <- dbConnect(sqlite,"fivecalls-2-6-17.db")

calls = dbGetQuery(callsdb, 
  "SELECT time, issueID, contactID, result, count(*) as calls 
   FROM results
   GROUP BY time, issueID, contactID, result
   ORDER BY time DESC")
#==========

# TRANSFORM DATA
#===============
# convert time into PST and break into usable components
calls$time <- as.POSIXct(as.numeric(as.character(calls$time)),
                        origin="1970-01-01", tz="UTC")
calls$time <- as.POSIXct(format(calls$time, tz="America/Los_Angeles", usetz=TRUE))
calls$date <- as.Date(as.POSIXct(calls$time))
calls$day <- weekdays(as.Date(calls$time))
calls$hour <- format(calls$time, format='%H')

calls <- calls %>%
  select(time, date, day, hour, issueID, contactID, result, calls)

# load and merge meta data
contact_map = read.csv("meta/contact_map.csv", header=TRUE)
issue_map = read.csv("meta/issue_map.csv", header=TRUE)
state_map = read.csv("meta/state_map.csv", header=TRUE)

calls <- merge(x=issue_map, y=calls, by.x=c("issue_id"), by.y=c("issueID"))
calls <- merge(x=contact_map, y=calls, by.x=c("contact_id"), by.y=c("contactID"))
calls <- merge(x=state_map, y=calls, by.x=c("state_abbr"), by.y=c("rep_state"))
#===============

