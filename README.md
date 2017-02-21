# 5C-Data
5C analytics-related scripts used for data analysis

## Getting Started
* Running these scripts requires the use of a 5C SQLite file, which should be housed within
/data but is not included in this repository.
* I try to emulate [Google's R Style Guide](https://google.github.io/styleguide/Rguide.xml) as much as possible.

## Airtable Dependency
5C leverages Airtable to store data about issues that appear on the site. This script, in order to leverage issue-level meta data, makes use of the Airtable API to pull this into R. In order for this to work, keep the following in mind:
* You must have an Airtable account and at least read-only access to the 5C Base (Tables).
* You should have the following two variables assigned within your .Renviron file:
** AIRTABLE_API_KEY=(Your individual API Key)
** 5C_AIRTABLE_BASE=(The 5C Base ID)