# Loading Libraries ---------------
library(glmnet)
library(glmnetUtils)
library(tidyverse)
library(rsample)
library(labelled)
library(haven)
library(fastDummies)
library(ggplot2)
library(owmr)
# library(stargazer)
#library(modelsummary)
#library(gt)
#library(ggthemes)

# Functions -------
not_all_na <- function(x) any(!is.na(x))

not_any_na <- function(x) all(!is.na(x))

kitchen_data <- function(x) {
  x <- x |>
    filter(manufacturing == 1) |>
    mutate_if(is.character, factor) |>
    select_if(function(x) is.factor(x) | is.numeric(x)) |>
    select(where(~ n_distinct(.) > 1)) |>
    select(where(not_all_na))
  return(x)
}



# Senegal ------------
# Loading data and removing columns that have all na(s)
senegal_lasso <- read_dta("data/senegal_lasso.dta") |> 
  select(where(not_all_na)) |>
  select(-c(a1, strata)) |>
  remove_prefix(c("_2007")) |>
  unlabelled() 


## Analysis --------
senegal_kitchen <- senegal_lasso |>
  mutate_if(is.character, factor) |>
  select_if(function(x) is.factor(x) | is.numeric(x)) |>
  select(where(~ n_distinct(.) > 1)) |>
  select(where(not_all_na))

#### creating Kitchen sink formula -----

# everything
kitchen_formula <- senegal_kitchen |>
  select(-c(idstd, starts_with("eec"), idPANEL2007, 	
            panel, stayers, strata_all, strata, a14, a15, a19,
            eligibility2007, stayers, firm_churn, nfirm_churn, 
            panel_firms, wt, weights_locsec)) |>
  select(where(not_any_na)) |>
  names()
#paste0 has no collapse argument 
Kitchen_formula <- as.formula(
  paste0("stayers ~ ", paste(kitchen_formula, collapse = " + "))
)


#### split into training and test -------
#first set seed
set.seed(06510) # for replication

senegal_split <- rsample::initial_split(senegal_kitchen, .8)
senegal_train <- training(senegal_split)
senegal_test <- testing(senegal_split)

#### LASSO using regression formula method ----
# model.matrix turns categorical into dummy variables for 
senegal_lass <- cv.glmnet(model.matrix(Kitchen_formula, data = senegal_train),
                        y = senegal_train$stayers,
                        family = "binomial",
                        alpha=1,
                        data = senegal_train)

plot(senegal_lass)

## Presenting Results
opt_lam <- senegal_lass$lambda.min
lM_LASSO <- glmnet(model.matrix(Kitchen_formula, data = senegal_train),
                   y = senegal_train$stayers,
                   intercept=TRUE, alpha=1, lambda = opt_lam)
W <- as.matrix(coef(lM_LASSO))
X <- model.matrix(Kitchen_formula, data = senegal_train)
keep_X <- rownames(W)[W!=0]
keep_X <- keep_X[!keep_X == "(Intercept)"]
X <- X[,keep_X]
logit <- glm(senegal_train$stayers ~ X, 
             family=binomial(link="logit"))

summary(logit)



## Saving the coefficients in odds ratio
# getting the direction of effect
coefficients0 <- enframe(logit$coefficients)
# getting the odds ratio
coefficients1 <- enframe(exp(logit$coefficients))
coefficients2 <- merge(coefficients0, coefficients1,
                       by="name")

# getting the significant coefficients
pvalues <- enframe(summary(logit)$coef[summary(logit)$coef[,4] <= .05, 4])

# merging to keep only significant ones
coefficients2 <- merge(pvalues, coefficients2,
                       by = "name") 

coefficients2$name[1]="Thies"

## removing intercept and anything that has zero odds
coefficients2 <- coefficients2 |>
  select(-value) |>
  filter(name != "(Intercept)",
         !is.na(value.x),
         !is.na(value.y))

coefficients2 |>
  save(file="data/sen_coef_lass.Rda")

#coefficients2 |>
 # save(file="data/sen_coef_lasso.Rda")
#stargazer(logit, type="text", out="logit.htm")


## Getting dataframe of variables for lambda min
coefficients <- enframe(coef(senegal_lass, s = "lambda.min")[,1])
coefficient_df <- coefficients |> 
  filter(value != 0)  

# formulas for both test and train
senegal_train_1 <- model.matrix(Kitchen_formula, data = senegal_train)
senegal_test_1 <- model.matrix(Kitchen_formula, data = senegal_test)

#### RMSE Calculation ------
RMSE_train <- senegal_train |>
  mutate(pred = predict(senegal_lass, senegal_train_1, 
                        s = "lambda.min", type = "response"))

RMSE_test <- senegal_test |>
  mutate(pred = predict(senegal_lass, senegal_test_1, 
                        s = "lambda.min", type = "response"),
         predicted_classes = ifelse(pred > 0.5, 1, 0),
         color = ifelse(stayers == 1, "blue", "red"),
         shape = ifelse(stayers == 1, 17, 16))


# checking something
# when i use geom_col, it sums up the probabilities
RMSE_test |>
  group_by(stayers) |>
  summarise(sum(pred, na.rm = TRUE))
# model accuracy
sen_accuracy <- mean(RMSE_test$stayers == RMSE_test$predicted_classes)

# plot of predicted versus actual
RMSE_test |>
  ggplot(aes(stayers, pred, fill = firm_churn)) +
  geom_bar(stat = "summary") +
  scale_fill_manual("Firm Churn", 
                    values = c("#FFCC66", "#669933")) +
  xlab("Firm Exit") +
  expand_limits(x = 0, y = 0) +
  theme_classic() +
  theme(text=element_text(size=12,  family="serif")) +
  labs(x = "Actual Firm Survivorship",
       y = "Predicted Probability of Firm Survivorship") +
  scale_x_continuous(breaks=seq(0,1,by=1))



# South Africa  -------------
# loading data and removing columns that have all na(s)
sa_lasso <- sa_lasso <- read_dta("data/sa_lasso.dta") |> 
  select(where(not_all_na), -wt) |>
  remove_prefix(c("_2007")) |>
  unlabelled()


## Analysis --------
sa_kitchen <- kitchen_data(sa_lasso)

# everything
kitchen_formula <- sa_kitchen |>
  select(-c(idstd, panelid,
            stayers, strata_all, 
            strata, status2020, starts_with("_2020_"),
            a12, a15, a16, a17, a14, a19, a17x, a18,
            starts_with("eec"),
            stayers, wt)) |>
  select(where(not_any_na)) |>
  names()
#paste0 has no collapse argument 
Kitchen_formula <- as.formula(
  paste0("stayers ~ ", paste(kitchen_formula, collapse = " + "))
)

#### split into training and test -------
#first set seed
set.seed(06510) # for replication

sa_split <- rsample::initial_split(sa_kitchen, .8)
sa_train <- training(sa_split)
sa_test <- testing(sa_split)


#### LASSO using regression formula method ----
# model.matrix turns categorical into dummy variables for 
sa_lass <- cv.glmnet(model.matrix(Kitchen_formula, data = sa_train),
                        y = sa_train$stayers,
                        family = "binomial",
                        alpha=1,
                        data = sa_train)

plot(sa_lass)


## Presenting Results
opt_lam <- sa_lass$lambda.min
lM_LASSO <- glmnet(model.matrix(Kitchen_formula, data = sa_train),
                   y = sa_train$stayers,
                   intercept=TRUE, alpha=1, lambda = opt_lam)
W <- as.matrix(coef(lM_LASSO))
X <- model.matrix(Kitchen_formula, data = sa_train)
keep_X <- rownames(W)[W!=0]
keep_X <- keep_X[!keep_X == "(Intercept)"]
X <- X[,keep_X]
logit <- glm(sa_train$stayers ~ X, 
             family=binomial(link="logit"))


## Saving the coefficients in odds ratio
# getting the direction of effect
coefficients0 <- enframe(logit$coefficients)
# getting the odds ratio
coefficients1 <- enframe(exp(logit$coefficients))
coefficients2 <- merge(coefficients0, coefficients1,
                       by="name")

# getting the significant coefficients
pvalues <- enframe(summary(logit)$coef[summary(logit)$coef[,4] <= .05, 4])

# merging to keep only significant ones
coefficients2 <- merge(pvalues, coefficients2,
                       by = "name") 

## removing intercept and anything that has zero odds
coefficients2 <- coefficients2 |>
  select(-value) |>
  filter(name != "(Intercept)",
         !is.na(value.x),
         !is.na(value.y))

coefficients2 |>
  save(file="data/sa_coef_lass.Rda")


# another way, not using it
coefficients <- enframe(coef(sa_lass, s = "lambda.min")[,1])
coefficient_df <- coefficients |> 
  filter(value != 0)

sa_train_1 <- model.matrix(Kitchen_formula, data = sa_train)
sa_test_1 <- model.matrix(Kitchen_formula, data = sa_test)

#### RMSE Calculation ------
RMSE_train <- sa_train |>
  mutate(pred = predict(naija_lass, sa_train_1, 
                        s = "lambda.min", type = "response"))

RMSE_test <- sa_test |>
  mutate(pred = predict(sa_lass, sa_test_1, 
                        s = "lambda.min", type = "response"),
         predicted_classes = ifelse(pred > 0.5, 1, 0),
         color = ifelse(stayers == 1, "blue", "red"),
         shape = ifelse(stayers == 1, 17, 16))

# model accuracy
mean(RMSE_test$stayers == RMSE_test$predicted_classes)

# checking something
# when i use geom_col, it sums up the probabilities
RMSE_test |>
  group_by(stayers) |>
  summarise(mean(pred, na.rm = TRUE))

# plot of predicted versus actual
RMSE_test |>
  ggplot(aes(stayers, pred, fill = as.factor(stayers))) +
  geom_bar(stat = "summary", fun = mean) +
  scale_fill_manual("Firm Churn", 
                    values = c("orangered3", "darkblue"),
                    labels = c("Exiters", "Stayers")) +
  expand_limits(x = 0, y = 0) +
  theme_classic() +
  theme(text=element_text(size=12,  family="serif")) +
  labs(x = "Actual Firm Survivorship",
       y = "Predicted Probability of Firm Survivorship") +
  scale_x_continuous(breaks=seq(0,1,by=1))



# Nigeria -------------
# loading data and removing columns that have all na(s)
naija_lasso <- read_dta("data/naija_lasso.dta") |> 
  select(where(not_all_na))

# removing stata haven labels
naija_lasso <- unlabelled(naija_lasso)

## Analysis ----------
# here is where I am doing a bunch of stuff
# most important to remember is imputing numeric
# values with median because glmnet can't handle
# na values and I don't want to lose so many columns
# also once again drop any columns who have all nas
# filtered to only manufacturing because all the service firms basically
# have na value added, and a bunch of other stuff
# wouldn't make sense to impute them with manu median
naija_kitchen <- kitchen_data(naija_lasso)


#### kitchen sink model--------- 
# only numeric without old
kitchen_formula <- naija_kitchen |>
  select(-c(idstd, panelid,
            exporter, foreign, large_firm, eligibility,
            starts_with("_2007"),  stayers, panel_firms,
            strata_all, stayers, id2007, b1x, a4anew,
            starts_with("a14"), firm_churn, nfirm_churn, 
            starts_with("old"),
            l1_orig, ends_with("check"), ends_with("orig"), 
            wt)) |>
  select_if(function(x) is.numeric(x)) |>
  select(where(not_any_na)) |>
  names()
#paste0 has no collapse argument 
Kitchen_formula <- as.formula(
  paste0("stayers ~", paste(kitchen_formula, collapse = " + "))
)

# all numeric including old
kitchen_formula <- naija_kitchen |>
  select(-c(idstd, panelid,
            exporter, foreign, large_firm, eligibility,
            starts_with("_2007"),  stayers, panel_firms,
            strata_all, stayers, id2007, b1x, a4anew,
            starts_with("a14"), firm_churn, nfirm_churn, oldc1a,
            l1_orig, ends_with("check"), ends_with("orig"), 
            wt)) |>
  select_if(function(x) is.numeric(x)) |>
  select(where(not_any_na)) |>
  names()
#paste0 has no collapse argument 
Kitchen_formula <- as.formula(
  paste0("stayers ~", paste(kitchen_formula, collapse = " + "))
)

# only old numeric
kitchen_formula <- naija_kitchen |>
  select(starts_with("old")) |>
  select_if(function(x) is.numeric(x)) |>
  select(where(not_any_na)) |>
  names()
#paste0 has no collapse argument 
Kitchen_formula <- as.formula(
  paste0("stayers ~", paste(kitchen_formula, collapse = " + "))
)

# only old all
kitchen_formula <- naija_kitchen |>
  select(starts_with("old")) |>
  select(where(not_any_na)) |>
  names()
#paste0 has no collapse argument 
Kitchen_formula <- as.formula(
  paste0("stayers ~", paste(kitchen_formula, collapse = " + "))
)


# everything
kitchen_formula <- naija_kitchen |>
  select(-c(idstd, panelid, 	
            panel,
            exporter, foreign, large_firm,
            starts_with("_2007"),  stayers,
            strata_all, stayers, id2007, 
            b1x, a4anew, eligibility,
            stayers, firm_churn, nfirm_churn,
            starts_with("a14"), panel_firms,
            l1_orig, ends_with("check"), ends_with("orig"), 
            wt)) |>
  select(where(not_any_na)) |>
  names()
#paste0 has no collapse argument 
Kitchen_formula <- as.formula(
  paste0("stayers ~", paste(kitchen_formula, collapse = " + "))
)


#### split into training and test -------
#first set seed
set.seed(06510) # for replication

naija_split <- rsample::initial_split(naija_kitchen, .8)
naija_train <- training(naija_split)
naija_test <- testing(naija_split)


#### LASSO using regression formula method ----
# model.matrix turns categorical into dummy variables for 
naija_lass <- cv.glmnet(model.matrix(Kitchen_formula, data = naija_train),
                        y = naija_train$stayers,
                        family = "binomial",
                        alpha=1,
                        data = naija_train)

plot(naija_lass)



## Presenting Results
opt_lam <- naija_lass$lambda.1se
lM_LASSO <- glmnet(model.matrix(Kitchen_formula, data = naija_train),
                   y = naija_train$stayers,
                   intercept=TRUE, alpha=1, lambda = opt_lam)
W <- as.matrix(coef(lM_LASSO))
X <- model.matrix(Kitchen_formula, data = naija_train)
keep_X <- rownames(W)[W!=0]
keep_X <- keep_X[!keep_X == "(Intercept)"]
X <- X[,keep_X]
logit <- glm(naija_train$stayers ~ X, 
             family=binomial(link="logit"))


## Saving the coefficients in odds ratio
# getting the direction of effect
coefficients0 <- enframe(logit$coefficients)
# getting the odds ratio
coefficients1 <- enframe(exp(logit$coefficients))
coefficients2 <- merge(coefficients0, coefficients1,
                       by="name")

# getting the significant coefficients
pvalues <- enframe(summary(logit)$coef[summary(logit)$coef[,4] <= .05, 4])

# merging to keep only significant ones
coefficients2 <- merge(pvalues, coefficients2,
                       by = "name") 

## removing intercept and anything that has zero odds
coefficients2 <- coefficients2 |>
  select(-value) |>
  filter(name != "(Intercept)",
         !is.na(value.x),
         !is.na(value.y))

coefficients2 |>
  save(file="data/naija_coef_lass.Rda")

# Another way, not doing it that way
coefficients <- enframe(coef(naija_lass, s = "lambda.min")[,1])
coefficient_df <- coefficients |> 
  filter(value != 0) 

naija_train_1 <- model.matrix(Kitchen_formula, data = naija_train)
naija_test_1 <- model.matrix(Kitchen_formula, data = naija_test)

#### RMSE Calculation ------
RMSE_train <- naija_train |>
  mutate(pred = predict(naija_lass, naija_train_1, 
                        s = "lambda.min", type = "response"))

RMSE_test <- naija_test |>
  mutate(pred = predict(naija_lass, naija_test_1, 
                        s = "lambda.min", type = "response"),
         predicted_classes = ifelse(pred > 0.5, 1, 0),
         color = ifelse(stayers == 1, "blue", "red"),
         shape = ifelse(stayers == 1, 17, 16))

# model accuracy
mean(RMSE_test$stayers == RMSE_test$predicted_classes)

# plot of predicted versus actual
RMSE_test |>
  ggplot(aes(stayers, pred, fill = as.factor(stayers))) +
  geom_bar(stat = "summary", fun = mean) +
  scale_fill_manual("Firm Churn", 
                    values = c("grey", "darkgreen"),
                    labels = c("Exiters", "Stayers")) +
  expand_limits(x = 0, y = 0) +
  theme_classic() +
  theme(text=element_text(size=12,  family="serif")) +
  labs(x = "Actual Firm Survivorship",
       y = "Predicted Probability of Firm Survivorship") +
  scale_x_continuous(breaks=seq(0,1,by=1))







RMSE_test |>
  ggplot() +
  geom_point(aes(stayers, pred, 
                 color = color, shape = factor(shape))) +
  scale_shape_manual("Stayers Vs Exiters", values=c(16, 17),
                     labels = c("Exiters", "Stayers")) +
  scale_color_manual("Exiters in Red", values=c('blue' = 'blue','red' = 'red'),
                     labels = c("Exiters")) +
  expand_limits(x = 0, y = 0) +
  labs(title = "Comparison of Actual Vs Predicted",
       x = "Actual",
       y = "Predicted")

  

