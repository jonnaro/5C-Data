# 5Calls - Calls by Time Analysis

# CHART: Total Call Volume by Day
rm(day_trend)
library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)

day_trend <- calls %>%
  group_by(date,result) %>%
  summarize(calls=sum(calls)) %>%
  filter(date > "2017-01-24")

day_trend <- spread(day_trend, result, calls)

day_trend <- day_trend %>%
  mutate(success_calls = contacted + vm,
         failed_calls = unavailable,
         total_calls = contacted + vm + unavailable,
         avail_pct = 100 * (contacted + vm) / total_calls) %>%
  select(date, success_calls, failed_calls, total_calls, avail_pct)

day_trend <- within(day_trend, cum_total <- cumsum(total_calls))
day_trend <- within(day_trend, cum_success <- cumsum(success_calls))

ggplot(day_trend, aes(x=date)) + 
  geom_bar(aes(y=total_calls,group=1), stat="identity", fill="orange") +
  geom_bar(aes(y=success_calls,group=1), stat="identity", fill="blue") +
  scale_x_date(date_breaks="1 day", labels = date_format("%b %d")) +
  scale_y_continuous(expand = c(0, 0), labels = comma) +
  ggtitle("Total Call Volume by Day") +
  xlab("") + 
  ylab("") +
  theme(plot.title=element_text(size=rel(1.5), hjust=0),
      axis.text.x=element_text(angle = 45, hjust = 1),
      axis.text.y=element_text(size=rel(1.1)),
      axis.ticks=element_blank(),
      axis.title.x=element_blank(),
      axis.title.y=element_text(size=rel(0.8), face="italic"),
      legend.text=element_text(size=rel(0.8)),
      legend.title=element_blank(),
      panel.background=element_blank(),
      panel.grid.minor.x=element_blank(),
      panel.grid.major.x=element_blank(),
      panel.grid.minor.y=element_line(colour="grey80", size=0.2),
      panel.grid.major.y=element_line(colour="grey80", size=0.2))


# CHART: Total Call Volume by Representative State and Day
# Track Call Intent by State
rm(state_trend)
library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)

state_trend <- calls %>%
  group_by(state_name,date) %>%
  summarize(calls=sum(calls)) %>%
  filter(date > "2017-01-24" & state_name != "unknown")

ggplot(state_trend, aes(x=date, y=calls)) + 
  geom_line() +
  facet_wrap(~ state_name, scales="free_y")
  scale_x_date(breaks=NULL) +
  scale_y_continuous(expand = c(0, 0), labels = comma) +
  ggtitle("Call Volume by Representative State") +
  xlab("") + 
  ylab("") +
  theme(axis.text.x=element_blank(),
        axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        legend.text=element_blank(),
        legend.title=element_blank(),
        panel.background=element_blank(),
        panel.grid.minor.x=element_blank(),
        panel.grid.major.x=element_line(colour="grey80", size=0.2),
        panel.grid.minor.y=element_line(colour="grey80", size=0.2),
        panel.grid.major.y=element_line(colour="grey80", size=0.2))




# CHART: Availability Over Time Trend
library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)




# CHART: Total Call Availability by Day of Week / Hour of Day
rm(hour_trend)
library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)

hour_trend <- calls %>%
  filter(date > "2017-01-24" & result %in% c("contacted", "unavailable", "vm")) %>%
  group_by(hour,result) %>%
  summarize(calls=sum(calls))

hour_trend$result <- factor(hour_trend$result, levels=c("unavailable","vm","contacted"))
ggplot(hour_trend, aes(x=hour, y=calls)) + 
  geom_bar(aes(fill=result), stat="identity", width=0.6) + 
  scale_y_continuous(expand = c(0, 0), labels = comma) +
  ggtitle("Call Volume by Hour of Day") +
  xlab("Hour of Day (Pacific Time)") + 
  ylab("") +
  scale_fill_manual(values = c('red', 'lightblue', 'blue')) + 
  theme(axis.text.x=element_text(size=rel(0.8), face="italic"),
        axis.ticks=element_blank(),
        axis.title.x=element_text(size=rel(0.8), face="italic"),
        axis.title.y=element_blank(),
        legend.text=element_text(size=rel(0.8)),
        legend.title=element_blank(),
        panel.background=element_blank(),
        panel.grid.minor.x=element_blank(),
        panel.grid.major.x=element_line(colour="grey80", size=0.2),
        panel.grid.minor.y=element_line(colour="grey80", size=0.2),
        panel.grid.major.y=element_line(colour="grey80", size=0.2))


  


# CHART: Senator Availability Over Time Trend
library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)


