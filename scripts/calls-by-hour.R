# Call Volume by Hour of Day

library(tidyverse)
library(scales)

# tranform data for chart
hour_trend <- calls %>%
  filter(date > "2017-01-24" & result %in% c("contacted", "unavailable", "vm")) %>%
  group_by(hour, result) %>%
  summarize(calls = sum(calls))

hour_trend$result <- factor(hour_trend$result, 
                            levels = c("unavailable", "vm", "contacted"))

ggplot(hour_trend, aes(x = hour, y = calls)) + 
  geom_bar(aes(fill = result), stat = "identity", width = 0.6) + 
  labs(title   = "Call Volume by Hour of Day",
       caption = paste("Last updated:", updated)) +
  scale_y_continuous(expand = c(0, 0), labels = comma) +
  xlab("Hour of Day (Pacific Time)") + 
  ylab("") +
  scale_fill_manual(values = c('red', 'lightblue', 'blue')) + 
  theme(axis.text.x        = element_text(size = rel(0.8), face = "italic"),
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

ggsave("./output/calls-by-hourofday.png")
