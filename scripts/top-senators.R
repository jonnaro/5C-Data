# Response by Senator Name

# PACKAGES
library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)


# Prep data
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
  scale_y_continuous(expand = c(0, 0), labels = comma) +
  ggtitle("Ranked Response by Senator Name") +
  labs(y="Attempted Calls") +
  scale_fill_manual(values = c('red', 'lightblue', 'blue')) + 
  guides(fill = guide_legend(reverse = TRUE)) +
  theme(plot.title         = element_text(size = rel(1.5), hjust = 0),
        axis.text.y        = element_text(size = rel(0.7)),
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
