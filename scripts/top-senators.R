# Response by Senator Name

library(tidyverse)
library(scales)

# summarize calls by senator
senator_calls <- calls %>%
  filter(contactPos == "Senate") %>%
  group_by(contactName, contactParty, result) %>%
  summarize(calls = sum(calls))

senator_calls <- spread(senator_calls, result, calls)

senator_calls <- senator_calls %>%
  mutate(SuccessCalls = contacted + vm,
         FailedCalls  = unavailable,
         TotalCalls   = contacted + vm + unavailable,
         AvailPct     = 100 * (contacted + vm) / TotalCalls) %>%
  select(contactName, contactParty, SuccessCalls, FailedCalls, TotalCalls, AvailPct) %>%
  arrange(desc(TotalCalls))

# tranform data for chart
top_senators <- calls %>%
  filter(contactPos == "Senate") %>%
  group_by(contactName, contactParty, result) %>%
  summarize(calls = sum(calls))

top_senators$result <- factor(top_senators$result, 
                              levels = c("unavailable", "vm", "contacted"))

# Render chart
ggplot( top_senators[order(top_senators$result, decreasing = T),], 
        aes(x = reorder(contactName, calls), y = calls)) +
  geom_bar(aes(fill = result), stat = "identity", width = 0.6) + 
  coord_flip() +
  guides(fill = guide_legend(reverse = TRUE)) +
  labs(title   = "Ranked Response by Senator Name",
       caption = paste("Last updated:", updated),
       y       = "Attempted Calls") +
  scale_fill_manual(values = c('red', 'lightblue', 'blue')) + 
  scale_y_continuous(expand = c(0, 0), labels = comma) +
  theme(axis.text.y        = element_text(size = rel(0.7)),
        axis.ticks         = element_blank(),
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

ggsave("./output/calls-by-senator.png")