# Total Call Volume by Date

# PACKAGES
library(dplyr)
library(tidyr)
library(ggplot2)
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

date_trend <- within(date_trend, CumTotal   <- cumsum(TotalCalls))
date_trend <- within(date_trend, CumSuccess <- cumsum(SuccessCalls))


# Render chart
ggplot(date_trend, aes(x = date)) + 
  geom_bar(aes(y = TotalCalls, group = 1), stat = "identity", fill = "orange") +
  geom_bar(aes(y = SuccessCalls, group = 1), stat = "identity", fill = "blue") +
  scale_x_date(date_breaks = "1 day", labels = date_format("%b %d")) +
  scale_y_continuous(expand = c(0, 0), labels = comma) +
  ggtitle("Total Call Volume by Day") +
  xlab("") + 
  ylab("") +
  theme(plot.title         = element_text(size = rel(1.5), hjust = 0),
        axis.text.x        = element_text(angle = 45, hjust = 1),
        axis.text.y        = element_text(size = rel(1.1)),
        axis.ticks         = element_blank(),
        axis.title.x       = element_blank(),
        axis.title.y       = element_text(size = rel(0.8), face = "italic"),
        legend.text        = element_text(size = rel(0.8)),
        legend.title       = element_blank(),
        panel.background   = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.y = element_line(colour = "grey80", size = 0.2),
        panel.grid.major.y = element_line(colour = "grey80", size = 0.2))
