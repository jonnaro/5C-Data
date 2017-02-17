# Top Issues by Response

library(tidyverse)
library(scales)

issues_ranked <- calls %>%
  group_by(issueDesc, issueID) %>%
  summarize(calls = sum(calls))
# check issues_ranked for missing issue_map values

top_issues <- calls %>%
  filter(result %in% c("contacted", "unavailable", "vm")) %>%
  group_by(issueDesc, issueID, result) %>%
  summarize(calls = sum(calls))
  
top_issues$result <- factor(top_issues$result, 
                            levels = c("unavailable", "vm", "contacted"))

# Render chart
ggplot(top_issues[order(top_issues$result, decreasing = T), ], 
        aes(x = reorder(issueDesc, calls), y = calls)) +
  geom_bar(aes(fill = result), stat = "identity", width = 0.6) + 
  coord_flip() +
  guides(fill = guide_legend(reverse = TRUE)) +
  labs(title   = "Issues With The Largest Response",
       caption = paste("Last updated:", updated),
       y       = "Attempted Calls") + 
  scale_fill_manual(values = c('red', 'lightblue', 'blue')) + 
  scale_y_continuous(expand = c(0, 0), labels = comma) +
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

ggsave("./output/calls-by-issue.png")