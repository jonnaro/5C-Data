# 5Calls - Ad Hoc Tasks
#======================

# Export issueID list
issue_list = dbGetQuery(callsdb, 
                        "SELECT issueID, count(*) as calls 
                        FROM results
                        GROUP BY issueID
                        ORDER BY calls DESC")
write.table(issue_list, "issue_list.txt", sep="\t") 

# Export contactID list
contact_list = dbGetQuery(callsdb, 
                          "SELECT contactID, count(*) as calls 
                          FROM results
                          GROUP BY contactID
                          ORDER BY calls DESC")
write.table(contact_list, "contact_list.txt", sep="\t")
