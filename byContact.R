# 5Calls - Calls by Contact Analysis

# CHART: Ranked Response by Representative State
rm(top_states)
library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)

top_states <- calls %>%
  group_by(state_name,result) %>%
  summarize(calls=sum(calls))

top_states$result <- factor(top_states$result, levels=c("unavailable","vm","contacted"))
ggplot( top_states[order(top_states$result,decreasing=T),], 
        aes(x = reorder(state_name,calls), y = calls)) +
  geom_bar(aes(fill = result), stat="identity", width=0.6) + 
  coord_flip() +
  scale_y_continuous(expand = c(0, 0), labels = comma) +
  ggtitle("Ranked Response by Representative State") +
  labs(y="Attempted Calls as of Feb 5, 2017") +
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


# CHART: Ranked Response by Senator Name
rm(top_senators)
library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)

top_senators <- calls %>%
  filter(rep_pos == "Senate") %>%
  group_by(rep_name,rep_party,result) %>%
  summarize(calls=sum(calls))
  
top_senators$result <- factor(top_senators$result, levels=c("unavailable","vm","contacted"))
ggplot( top_senators[order(top_senators$result,decreasing=T),], 
        aes(x = reorder(rep_name,calls), y = calls)) +
  geom_bar(aes(fill = result), stat="identity", width=0.6) + 
  coord_flip() +
  scale_y_continuous(expand = c(0, 0), labels = comma) +
  ggtitle("Ranked Response by Senator Name") +
  labs(y="Attempted Calls as of Feb 5, 2017") +
  scale_fill_manual(values = c('red', 'lightblue', 'blue')) + 
  guides(fill = guide_legend(reverse=TRUE)) +
  theme(plot.title = element_text(size=rel(1.5), hjust=0),
        axis.text.y=element_text(size=rel(0.7)),
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


# CHART: Senator Response Rates
rm(senate_resp)
library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)

top_senators <- calls %>%
  filter(rep_pos == "Senate") %>%
  group_by(rep_name,rep_party,result) %>%
  summarize(calls=sum(calls))

senate_resp <- spread(top_senators, result, calls)

senate_resp <- senate_resp %>%
  mutate(success_calls = contacted + vm,
         total_calls = contacted + vm + unavailable,
         avail_pct = 100 * (contacted + vm) / total_calls)

ggplot(senate_resp, aes(x=total_calls, y=avail_pct)) + 
  geom_point(aes(color=factor(rep_party)),size=2) +
  scale_color_manual(name="Party", values=c("blue", "green", "red")) +
  geom_text(aes(label=ifelse(total_calls>4800,as.character(rep_name),'')),hjust=0,vjust=-1.5,size=rel(1.7)) +
  scale_y_continuous(labels = comma) +
  ggtitle("Senator Response Rates") +
  labs(x="Attempted Calls as of Feb 5, 2017") +
  labs(y="% of Calls with Contact or Voicemail") +
  theme(plot.title = element_text(size=rel(1.5), hjust=0),
        axis.ticks=element_blank(),
        axis.title.x=element_text(size=rel(0.8), face="italic"),
        axis.title.y=element_text(size=rel(0.8), face="italic"),
        legend.key=element_blank(),
        legend.text=element_text(size=rel(0.8)),
        panel.background=element_blank(),
        panel.grid.minor.x=element_line(colour="grey80", size=0.2),
        panel.grid.major.x=element_line(colour="grey80", size=0.2),
        panel.grid.minor.y=element_line(colour="grey80", size=0.2),
        panel.grid.major.y=element_line(colour="grey80", size=0.2))
