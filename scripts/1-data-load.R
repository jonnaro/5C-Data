# Load the data set and perform any fundamental transformations

rm(list = ls(all = TRUE))  # Clear existing data

# PACKAGES
library(RSQLite)
library(dplyr, warn.conflicts = FALSE)

# LOAD DATA
dbFile  <- list.files(path       = "./data", 
                      pattern    = "*.db", 
                      full.names = TRUE)
sqlite  <- dbDriver("SQLite")
callsdb <- dbConnect(sqlite, dbFile)

calls = dbGetQuery(callsdb, 
  "SELECT time, issueID, contactID, result, count(*) as calls 
   FROM results
   GROUP BY time, issueID, contactID, result
   ORDER BY time DESC")

rm(callsdb, sqlite) # no longer needed

# TRANSFORM DATA
calls$time <- as.POSIXct(as.numeric(as.character(calls$time)),
                         origin = "1970-01-01", 
                         tz     = "UTC")

# convert time into PST
calls$time <- as.POSIXct(format(calls$time, 
                                tz    = "America/Los_Angeles", 
                                usetz = TRUE))

# break out timestamp into components
calls$date <- as.Date(as.POSIXct(calls$time))
calls$day  <- weekdays(as.Date(calls$time))
calls$hour <- format(calls$time, format = "%H")

# load and merge meta data
contact_map = read.csv("./meta/contact_map.csv", header = TRUE, stringsAsFactors = FALSE)
issue_map   = read.csv("./meta/issue_map.csv", header = TRUE, stringsAsFactors = FALSE)
state_map   = read.csv("./meta/state_map.csv", header = TRUE, stringsAsFactors = FALSE)

# issue meta data
calls <- calls %>%
  left_join(x  = calls,
            y  = issue_map,
            by = "issueID") 

# representative meta data
calls <- calls %>%
  left_join(x  = calls,
            y  = contact_map,
            by = "contactID")

# state meta data
calls <- calls %>%
  left_join(x  = calls,
            y  = state_map,
            by = "stateID")

# organize dataframe
calls <- calls %>%
  select(time, date, day, hour, 
         issueID, issueDesc,
         contactID, stateID, stateName, contactName, contactPos, contactParty,
         result, calls)

