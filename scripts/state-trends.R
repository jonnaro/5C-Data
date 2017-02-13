# Total Call Volume by Representative State and Day

# LOAD PACKAGES
#===============
library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)
#===============

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

