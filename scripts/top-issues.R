# Top Issues by Response

# LOAD PACKAGES
#===============
library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)
#===============

issues_ranked <- calls %>%
  group_by(issue_desc,issue_id) %>%
  summarize(calls=sum(calls))
# check issues_ranked for missing issue_map values

top_issues <- calls %>%
  filter(result %in% c("contacted", "unavailable", "vm")) %>%
  group_by(issue_desc,issue_id,result) %>%
  summarize(calls=sum(calls))
  
top_issues$result <- factor(top_issues$result, levels=c("unavailable","vm","contacted"))
ggplot( top_issues[order(top_issues$result,decreasing=T),], 
        aes(x = reorder(issue_desc,calls), y = calls)) +
  geom_bar(aes(fill = result), stat="identity", width=0.6) + 
  coord_flip() +
  scale_y_continuous(expand = c(0, 0), labels = comma) +
  ggtitle("Top Issues by Call Response") +
  labs(y="Attempted Calls as of Feb 12, 2017") +
  scale_fill_manual(values = c('red', 'lightblue', 'blue')) + 
  guides(fill = guide_legend(reverse=TRUE)) +
  theme(plot.title = element_text(size=rel(1.5), hjust=0),
        axis.ticks=element_blank(),
        axis.title.x=element_text(size=rel(0.8), face="italic"),
        axis.title.y=element_blank(),
        legend.text=element_text(size=rel(0.8)),
        legend.title=element_blank(),
        panel.background=element_blank(),
        panel.grid.minor.x=element_line(colour="grey80", size=0.2),
        panel.grid.major.x=element_line(colour="grey80", size=0.2),
        panel.grid.minor.y=element_blank(),
        panel.grid.major.y=element_blank())