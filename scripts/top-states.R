# Response by Representative State

library(tidyverse)
library(scales)

# summarize calls by state
state_calls <- calls %>%
  group_by(stateName, result) %>%
  summarize(calls = sum(calls))

state_calls <- spread(state_calls, result, calls)

state_calls <- state_calls %>%
  mutate(SuccessCalls = contacted + vm,
         FailedCalls  = unavailable,
         TotalCalls   = contacted + vm + unavailable,
         AvailPct     = 100 * (contacted + vm) / TotalCalls) %>%
  select(stateName, SuccessCalls, FailedCalls, TotalCalls, AvailPct) %>%
  arrange(desc(TotalCalls))

# tranform data for chart
top_states <- calls %>%
  group_by(stateName, result) %>%
  summarize(calls = sum(calls))

top_states$result <- factor(top_states$result, 
                            levels=c("unavailable", "vm", "contacted"))

# Render chart
ggplot( top_states[order(top_states$result, decreasing = T), ], 
        aes(x = reorder(stateName, calls), y = calls)) +
  geom_bar(aes(fill = result), stat = "identity", width = 0.6) + 
  coord_flip() +
  labs(title   = "Ranked Response by Representative State",
       caption = paste("Last updated:", updated),
       y       = "Attempted Calls") + 
  scale_fill_manual(values = c('red', 'lightblue', 'blue')) + 
  scale_y_continuous(expand = c(0, 0), labels = comma) +
  guides(fill = guide_legend(reverse = TRUE)) +
  theme(axis.ticks         = element_blank(),
        axis.title.x       = element_text(size = rel(0.8), face = "italic"),
        axis.title.y       = element_blank(),
        legend.text        = element_text(size = rel(0.8)),
        legend.title       = element_blank(),
        panel.background   = element_blank(),
        panel.grid.major.x = element_line(colour = "grey80", size = 0.2),
        panel.grid.minor.x = element_line(colour = "grey80", size = 0.2),
        panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        plot.title         = element_text(size = rel(1.5), hjust = 0))

ggsave("./output/calls-by-state.png")
