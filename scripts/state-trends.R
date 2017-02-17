# Call Volume by Representative State and Day

library(tidyverse)
library(scales)

state_trend <- calls %>%
  group_by(stateName,date) %>%
  summarize(calls = sum(calls)) %>%
  filter(date > "2017-01-24" & stateName != "unknown")

ggplot(state_trend, aes(x = date, y = calls)) + 
  geom_line() +
  facet_wrap(~ stateName, scales = "free_y") +
  labs(title = "Call Volume by Representative State") + 
  scale_x_date(breaks = NULL) +
  scale_y_continuous(expand = c(0, 0), labels = comma) +
  theme(axis.text.x        = element_blank(),
        axis.ticks         = element_blank(),
        axis.title.x       = element_blank(),
        axis.title.y       = element_blank(),
        legend.text        = element_blank(),
        legend.title       = element_blank(),
        panel.background   = element_blank(),
        panel.grid.major.x = element_line(colour = "grey80", size = 0.2),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_line(colour = "grey80", size = 0.2),
        panel.grid.minor.y = element_line(colour = "grey80", size = 0.2))

ggsave("./output/calls-trendbystate.png")