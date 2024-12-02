#--------------------------------------------------------------------------------------
#
# Name: Material from webscraping
# Purpose: Collecting material from the webscraping course
# Data: webscraped data
# Author: Heiner Salomon (heiner.salomon@uni-bremen.de)
# Date created: 28/11/24
#
# Notes  ---------------------------------------------------------------------------------
#
# Preparation ----------------------------------------------------------------------------
#
# Load packages - if they are not already installed, use the following line by deleting the # in front of the line
# install.packages(c("rvest", "robotstext", "polite", "RSelenium", "Rcrawler", "tidyverse"))
library(dplyr)
library(rvest)
library(robotstxt)
library(polite)
library(RSelenium)
library(Rcrawler)
library(RedditExtractoR)
library(jsonlite)
library(httr)
library(atrrr)
library(tidyverse)


# 1: Basic webscraping --------------------------------------------------------------------------------------

# Extracting the robots text
robotstxt(domain = "https://constructor.university")

# Extracting specific permission
robotstxt(domain = "https://constructor.university")$permission

# Check whether there is any webscraping allowed
paths_allowed(domain = "https://www.worldbank.org")

# Read the html of a website
read_html("https://www.uni-bremen.de")

# Read specific html elements from a website within the tidyverse
read_html("https://finance.yahoo.com/trending-tickers") %>%
  html_element(".markets-table") #in this case the element is a class, hence the . at the beginning

# Read specific html elements from a website within the tidyverse and put it in a neat table
read_html("https://finance.yahoo.com/trending-tickers") %>%
  html_elements(".markets-table") %>% #in this case the element is a class, hence the . at the beginning
  html_table()


# Read specific html elements from a website, in this case lists
read_html("https://finance.yahoo.com/markets/stocks/trending/") %>%
  html_element("li") %>% # in this case the element is a list item
  html_table()


# Read specific html elements from a website, in this case links
read_html("https://www.wikipedia.org/") %>%
  html_element("a") %>% # This means we are looking for elements links
  html_attr("href") %>% # This means we are looking for the string of the hyperlinks
  url_absolute(base = "https://wikipedia.org/") # To create clickable links (uses the base links to create clickable links)


# Extracting the robots text
robots_text_google_scholar <- robotstxt(domain = "https://scholar.google.com")

# Check for allowance
# bow()


# 2: Webcrawling --------------------------------------------------------------------------------------

# library(Rcrawler)

# Scrape this website and put all the sub-components of the website into a file called INDEX 
Rcrawler(Website = "https://programmingnotes.net",
         no_cores = 2,
         no_conn = 2,
         saveOnDisk = FALSE)

# Crawl the website of the uni-bremen and its subpages
# Rcrawler(Website = "https://uni-bremen.de",
#          no_cores = 2,
#          no_conn = 2,
#          saveOnDisk = FALSE)

# Scrape the specific CSS pattern (which does not work, in this case)
ContentScraper(Url = "https://programmingnotes.net/machine_learning/pytorch-fundamentals",
         CssPatterns = ".rainbow_show",
         ManyPerPattern = FALSE,
         astext = TRUE)

# 3: Basic API --------------------------------------------------------------------------------------

# Finding keywords in reddit
data <- find_thread_urls(keywords = "elections",
                         sort_by = "new",
                         subreddit = NA,
                         period = "week")

# Find the subreddits to a topic
find_subreddits(keywords = "elections") %>%
  slice_head(n = 10)

# Find a keyword in specific subreddits
find_thread_urls(keywords = "Trump",
                         sort_by = "new",
                         subreddit = "voterfraud",
                         period = "day")

# Generate a GET request for the Github API
params <- list(q = "r", sort = "forks")
response <- GET("https://api.github.com/search/repositories", query = params)
response

body <- content(response, "text") # extracts body
parsed_data <- fromJSON(body)     # parse JSON body
view(parsed_data$items)

as_tibble(parsed_data$items) %>% slice_head(n=10)



# 4: Basic Bluesky API --------------------------------------------------------------------------------------

# library(atrrr)
# library(httr2)


# Authenticate yourself
auth("heinersalomon.bsky.social")


# Finding all Bluesky posts with a search term, here #rstats
#bsky_rstats <- search_post("#rstats", limit = 1000000)


# Get my user data 
my_bsky_data <- get_user_info(actor = "heinersalomon.bsky.social")


# All my skeets
my_bsky_skeets_data <- get_skeets_authored_by("heinersalomon.bsky.social", limit = 5000)

my_bsky_skeets_data <- my_bsky_skeets_data %>%
  mutate(number_skeets_by_author = (author_name), by(author_name))

my_bsky_skeets_data[, .N, by = author_name]


# 5: RSelenium --------------------------------------------------------------------------------------

library(RSelenium)
library(netstat)
library(httr)
library(wdman)
library(tidyverse)

rs_dr <- rsDriver(browser = "firefox")