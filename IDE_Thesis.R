# Loading Libraries ---------------------
library(haven)
library(tidyverse)
library(labelled)


# Notes ---------------
# TO get the decoded string form of a categorical variable, use following code:
## getting the string representation of the reasons
# capital_analysis$reason_not_solve_cap_string <- 
#to_factor(capital_analysis$reason_not_solve_cap_prob)



# Loading Data ----------------------
## Senegal -----------------------
Senegal_2003_2007_panel <- read_dta("data/Senegal_2003_2007_panel.dta")
Senegal_2007_2014_Panel <- read_dta("data/Senegal_2007_2014_Panel.dta")


### Cleaning Senegal Data -------------
# want to join the two panel datasets, so first, decoding panel variable
# panel variable identifies what years firm was surveyed
Senegal_2003_2007_panel$panel_string <- to_factor(Senegal_2003_2007_panel$panel)
unique(Senegal_2003_2007_panel$panel_string)

Senegal_2007_2014_Panel$panel_string <- to_factor(Senegal_2007_2014_Panel$panel)
unique(Senegal_2007_2014_Panel$panel_string)


# all 2007 firms
senegal_2007 <- Senegal_2003_2007_panel |>
  filter(year == 2007)

senegal_2007_two <- Senegal_2007_2014_Panel |> 
  filter(year == 2007)

# it seems there are just some observations in the 2003-2007 dataset
# that just can't be matched
total_2017 <- merge(senegal_2007, senegal_2007_two, by="idstd",
                    all.x = TRUE, all.y = TRUE)
glimpse(total_2017)

total_2017$
  
# might have to fashi 2003 firms because not many made it from
  # 2003 to 2007 anyway
  # would make more sense to do between 03 and 07 itself probably
# all 2003 firms
senegal_2003 <- Senegal_2003_2007_panel |>
  filter(year == 2003)

# all 2014 firms
senegal_2014 <- Senegal_2007_2014_Panel |> 
  filter(year == 2014)

## South Africa -----------------------
SouthAfrica_2003_2007_panel <- read_dta("data/SouthAfrica_2003_2007_panel.dta")
South_Africa_2007_2020 <- read_dta("data/South Africa_2007_2020.dta")

# all 2007 firms
sa_2007 <- SouthAfrica_2003_2007_panel |>
  filter(year == 2007)

sa_2007_two <- South_Africa_2007_2020 |> 
  filter(year == 2007)

sa_total_2007 <- merge(sa_2007, sa_2007_two, by="idstd")

# all 2003 firms
sa_2003 <- SouthAfrica_2003_2007_panel |>
  filter(year == 2003)

# all 2020 firms
sa_2020 <- South_Africa_2007_2020 |> 
  filter(year == 2020)

## Nigeria -----------------------
Nigeria_2007_2009_2014 <- read_dta("data/Nigeria_2007-2009_2014_v5- FINAL.dta")



