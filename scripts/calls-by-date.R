# Total Call Volume by Date

library(tidyverse)
library(scales)

# Prep data
date_trend <- calls %>%
  group_by(date, result) %>%
  summarize(calls = sum(calls)) %>%
  filter(date > "2017-01-24")

date_trend <- spread(date_trend, result, calls)

date_trend <- date_trend %>%
  mutate(SuccessCalls = contacted + vm,
         FailedCalls  = unavailable,
         TotalCalls   = contacted + vm + unavailable,
         AvailPct     = 100 * (contacted + vm) / TotalCalls) %>%
  select(date, SuccessCalls, FailedCalls, TotalCalls, AvailPct)

date_trend <- within(date_trend, CumSuccess <- cumsum(SuccessCalls))
date_trend <- within(date_trend, CumTotal   <- cumsum(TotalCalls))

# output: daily call volume
ggplot(date_trend, aes(x = date)) + 
  geom_bar(aes(y = TotalCalls, group = 1), stat = "identity", fill = "orange") +
  geom_bar(aes(y = SuccessCalls, group = 1), stat = "identity", fill = "blue") +
  labs(title = "Daily Call Volume") +
  scale_x_date(date_breaks = "1 day", labels = date_format("%b %d")) +
  scale_y_continuous(expand = c(0, 0), labels = comma) +
  theme(axis.text.x        = element_text(angle = 45, hjust = 1),
        axis.text.y        = element_text(size = rel(1.1)),
        axis.ticks         = element_blank(),
        axis.title.x       = element_blank(),
        axis.title.y       = element_text(size = rel(0.8), face = "italic"),
        legend.text        = element_text(size = rel(0.8)),
        legend.title       = element_blank(),
        panel.background   = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_line(colour = "grey80", size = 0.2),
        panel.grid.minor.y = element_line(colour = "grey80", size = 0.2),
        plot.title         = element_text(size = rel(1.5), hjust = 0))

ggsave("./output/daily-call-volume.png")

# output: cumulative calls per day
ggplot(date_trend, aes(x = date, y = CumSuccess, group = 1)) + 
  geom_line(colour = "blue", size = 1.0) +
  geom_point(colour = "black") +
  labs(title   = "Total Successful Calls Made Over Time",
       caption = paste("Last updated:", updated)) +
  expand_limits(y = 0) + 
  scale_x_date(date_breaks = "1 day", labels = date_format("%b %d")) +
  scale_y_continuous(labels = comma) +
  theme(axis.text.x        = element_text(angle = 90, hjust = 1),
        axis.text.y        = element_text(size = rel(1.0)),
        axis.ticks         = element_blank(),
        axis.title.x       = element_blank(),
        axis.title.y       = element_text(size = rel(0.8), face = "italic"),
        legend.text        = element_text(size = rel(0.9)),
        legend.title       = element_blank(),
        panel.background   = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_line(colour = "grey80", size = 0.2),
        panel.grid.minor.y = element_line(colour = "grey80", size = 0.2),
        plot.title         = element_text(size = rel(1.5), hjust = 0))

ggsave("./output/cumulative-call-volume.png")
  