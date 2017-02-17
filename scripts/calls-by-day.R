# Call Volume by Day of Week

library(tidyverse)
library(scales)

DayOfWeek <- calls %>%
  filter(date > "2017-01-24" & result %in% c("contacted", "unavailable", "vm")) %>%
  group_by(day, result) %>%
  summarize(calls = sum(calls))

DayOfWeek$result <- factor(DayOfWeek$result, levels = c("unavailable", "vm", "contacted"))

ggplot(DayOfWeek, aes(x = day, y = calls)) + 
  geom_bar(aes(fill = result), stat = "identity", width = 0.6) +
  labs(title = "Call Volume by Day of Week") + 
  scale_y_continuous(expand = c(0, 0), labels = comma) +
  scale_x_discrete(limits = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")) +
  xlab("Day of Week (PST)") +
  scale_fill_manual(values = c('red', 'lightblue', 'blue')) + 
  theme(axis.text.x        = element_text(size = rel(0.7)),
        axis.ticks         = element_blank(),
        axis.title.x       = element_text(size = rel(0.8), face = "italic"),
        axis.title.y       = element_blank(),
        legend.text        = element_text(size = rel(0.8)),
        legend.title       = element_blank(),
        panel.background   = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.x = element_line(colour = "grey80", size = 0.2),
        panel.grid.minor.y = element_line(colour = "grey80", size = 0.2),
        panel.grid.major.y = element_line(colour = "grey80", size = 0.2))

ggsave("./output/calls-by-dayofweek.png")