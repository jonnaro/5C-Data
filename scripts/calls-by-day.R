# Call Volume by Day of Week

library(tidyverse)
library(scales)


dow <- calls %>%
  filter(date > "2017-01-24" & result %in% c("contacted", "unavailable", "vm")) %>%
  group_by(day, result) %>%
  summarize(calls = sum(calls))

dow$result <- factor(dow$result, levels = c("unavailable", "vm", "contacted"))

ggplot(dow, aes(x = day, y = calls)) + 
  geom_bar(aes(fill = result), stat = "identity", width = 0.6) + 
  scale_y_continuous(expand = c(0, 0), labels = comma) +
  scale_x_discrete(limits = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")) +
  ggtitle("Call Volume by Day of Week") +
  xlab("Day of Week (Pacific Time)") + 
  ylab("") +
  scale_fill_manual(values = c('red', 'lightblue', 'blue')) + 
  theme(axis.text.x        = element_text(size = rel(0.9)),
        axis.ticks         = element_blank(),
        axis.title.x       = element_text(size = rel(0.9), face = "italic"),
        axis.title.y       = element_blank(),
        legend.text        = element_text(size = rel(0.8)),
        legend.title       = element_blank(),
        panel.background   = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.x = element_line(colour = "grey80", size = 0.2),
        panel.grid.minor.y = element_line(colour = "grey80", size = 0.2),
        panel.grid.major.y = element_line(colour = "grey80", size = 0.2))
