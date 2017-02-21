# Load the data set and perform any fundamental transformations

rm(list = ls(all = TRUE))  # Clear existing data

library(RSQLite)
library(tidyverse)
library(lubridate, warn.conflicts = FALSE)
library(airtabler)

# LOAD
dbFile  <- list.files(path       = "./data", 
                      pattern    = "*.db", 
                      full.names = TRUE)
sqlite  <- dbDriver("SQLite")
callsdb <- dbConnect(sqlite, dbFile)

calls <- dbGetQuery(callsdb, 
  "SELECT time, issueID, contactID, result, count(*) as calls 
   FROM results
   GROUP BY time, issueID, contactID, result
   ORDER BY time DESC")

rm(callsdb, sqlite) # original database can be removed from memory

# TRANSFORM
calls$time <- as.POSIXct(as.numeric(as.character(calls$time)),
                         origin = "1970-01-01", tz = "UTC")

# convert time into PST
calls$time <- as.POSIXct(format(calls$time, 
                                tz    = "America/Los_Angeles", 
                                usetz = TRUE))

# break out date-time components
calls$date  <- as.Date(as.POSIXct(calls$time))
calls$month <- month(calls$time)
calls$week  <- week(calls$time)
calls$day   <- wday(calls$time, label = TRUE)
calls$hour  <- hour(calls$time)

# merge issues list from airtable
base   <- Sys.getenv("5C_AIRTABLE_BASE")
issues <- air_select(base, "Issues List")
rm(base) # no longer needed

issues <- issues %>%
  select(issueID = id, issueName = Name, issueHidden = Inactive, issueCreated = createdTime)

calls <- calls %>%
  left_join(x = calls, y = issues, by = "issueID")

# load static meta data
contact_map = read.csv("./meta/contact_map.csv", header = TRUE, stringsAsFactors = FALSE)
state_map   = read.csv("./meta/state_map.csv", header = TRUE, stringsAsFactors = FALSE)

# merge meta data to calls db
calls <- calls %>%
  left_join(x = calls, y = contact_map, by = "contactID")

calls <- calls %>%
  left_join(x = calls, y = state_map, by = "stateID")

# organize dataframe
calls <- calls %>%
  select(time, date, month, week, day, hour, 
         issueID, issueName,
         contactID, stateID, stateName, contactName, contactPos, contactParty,
         result, calls)

# calculate recency of data
updated <- format(max(calls$date, na.rm = TRUE), format = "%d %b %Y")
