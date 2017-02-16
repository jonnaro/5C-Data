# Response by Representative State

library(tidyverse)
library(scales)

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
  scale_y_continuous(expand = c(0, 0), labels = comma) +
  ggtitle("Ranked Response by Representative State") +
  labs(y="Attempted Calls") +
  scale_fill_manual(values = c('red', 'lightblue', 'blue')) + 
  guides(fill = guide_legend(reverse = TRUE)) +
  theme(plot.title         = element_text(size = rel(1.5), hjust = 0),
        axis.ticks         = element_blank(),
        axis.title.x       = element_text(size = rel(0.8), face = "italic"),
        axis.title.y       = element_blank(),
        legend.text        = element_text(size = rel(0.8)),
        legend.title       = element_blank(),
        panel.background   = element_blank(),
        panel.grid.minor.x = element_line(colour = "grey80", size = 0.2),
        panel.grid.major.x = element_line(colour = "grey80", size = 0.2),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank())

ggsave("./output/calls-by-state.png")
