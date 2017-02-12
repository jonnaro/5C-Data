# connect to data source
library("RSQLite")
system("ls *.db", show=TRUE)
sqlite   <- dbDriver("SQLite")
callsdb <- dbConnect(sqlite,"20170201.db")

# list tables
dbListTables(callsdb)
dbListFields(callsdb, "results")

# Explore schema
dbGetQuery(callsdb, 
           "select * from results limit 10")

# Export data
write.table(contact, "contact.txt", sep="\t") 


#################
# BASIC QUERIES #
#################

# count total calls (despite result)
total_calls = dbGetQuery(callsdb, 
  "select count(*) as total_calls from results")

# count total successful calls
sucess_calls = dbGetQuery(callsdb, 
  "select count(*) as successful_calls from results where result IN ('contacted', 'vm')")

# count calls by result
result = dbGetQuery(callsdb, 
  "select result, count(*) as calls from results group by result")

# calls by contact, result
con_result = dbGetQuery(callsdb, 
           "select contactID, result, count(*) as calls from results group by contactID, result")


# calls by contact
contact = dbGetQuery(callsdb, 
                        "select contactID, count(*) as calls from results group by contactID order by calls DESC")

# calls by contact availability
dbGetQuery(callsdb, 
      "SELECT contactID, count(*) as calls
      FROM results
      GROUP BY contactID
      ORDER BY calls DESC")

