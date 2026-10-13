# Purpose: Reproduce the analysis in paper/paper.qmd (filtering, per-90 rates,
#          summaries, simple linear regression, diagnostics, and figures).
# Author: Eddie Nguyen
# Date: October 12, 2026
# Inputs: data/epl_player_stats_24_25.csv (SCORE Sports Data Repository)
# Outputs: Console output and plots only; no files are written.
# Usage: Open MATH261A-project-1.Rproj, then run
#        source("analysis/00_clean-data.R") from the project root.

#### Workspace setup ####
library(broom)
library(dplyr)
library(ggplot2)

df <- read.csv("data/epl_player_stats_24_25.csv")

#### Filter players ####
# Keep outfield players with more than 30% of the season's minutes
# (0.30 * 38 matches * 90 minutes = 1,026 minutes).
coverage <- 0.30

filtered_df <- df %>%
  filter(
    Minutes > coverage * (38 * 90) &
      Position != "GKP"
  )

nrow(filtered_df)  # 279 players in the paper

#### Convert season totals to per-90 rates ####
per_90 <- function(numerator, denominator) {
  return(numerator * 90 / denominator)
}

filtered_df$Progressive.Carries.Per90 <- per_90(filtered_df$Progressive.Carries, filtered_df$Minutes)
filtered_df$Shots.Per90 <- per_90(filtered_df$Shots, filtered_df$Minutes)

#### Table 1: summary of the per-90 variables ####
summary(filtered_df[c("Progressive.Carries.Per90", "Shots.Per90")])

#### Figure 1: per-90 boxplots before and after filtering ####
# Top row: progressive carries. Bottom row: shots.
# Left column: all players. Right column: after filtering.
par(mfrow = c(2, 2))

boxplot(
  per_90(df$Progressive.Carries, df$Minutes),
  xlab = "Progressive Carries per 90 minutes",
  ylab = "Carries"
)

boxplot(
  filtered_df$Progressive.Carries.Per90,
  xlab = "Progressive Carries per 90 minutes after trimming",
  ylab = "Carries"
)

boxplot(
  per_90(df$Shots, df$Minutes),
  xlab = "Total Shots per 90 minutes",
  ylab = "Shots"
)

boxplot(
  filtered_df$Shots.Per90,
  xlab = "Total Shots per 90 minutes after trimming",
  ylab = "Shots"
)

par(mfrow = c(1, 1))

#### Figure 2: shots per 90 versus progressive carries per 90 ####
plot(
  filtered_df$Shots.Per90 ~ filtered_df$Progressive.Carries.Per90,
  xlab = "Progressive Carries per 90 minutes",
  ylab = "Shots per 90 minutes",
  pch = 16
)

#### Figure 3: the same plot colored by position ####
plot(
  y = filtered_df$Shots.Per90,
  x = filtered_df$Progressive.Carries.Per90,
  col = factor(filtered_df$Position),
  xlab = "Progressive Carries per 90 minutes",
  ylab = "Shots per 90 minutes",
  pch = 16
)

legend("right", legend = levels(factor(filtered_df$Position)), pch = 19, col = 1:length(levels(factor(filtered_df$Position))))

#### Fit the simple linear regression (OLS) ####
model <- lm(Shots.Per90 ~ Progressive.Carries.Per90, data = filtered_df)

#### Figure 4: diagnostic plots ####
par(mfrow = c(2, 2))

# Data with the fitted line
plot(
  y = filtered_df$Shots.Per90,
  x = filtered_df$Progressive.Carries.Per90,
  xlab = "Progressive Carries per 90 minutes",
  ylab = "Shots per 90 minutes",
  main = "X vs Y Scatter Plot",
  pch = 16
)
abline(model)

# Residuals versus the predictor (linearity and equal variance)
plot(
  y = model$residuals,
  x = filtered_df$Progressive.Carries.Per90,
  xlab = "Progressive Carries per 90 minutes",
  ylab = "Residuals",
  main = "Residuals vs Predictor Plot",
  pch = 16
)
abline(h = 0)

# Histogram and Q-Q plot of the residuals (normality)
hist(model$residuals, main = "Histogram of Residuals", xlab = "Residuals")

qqnorm(model$residuals)
qqline(model$residuals, col = "red")

par(mfrow = c(1, 1))

#### Table 2: regression results ####
tidy(model, conf.int = TRUE)  # estimates, standard errors, p-values, 95% CIs
summary(model)                # R-squared, residual standard error, F-test

#### Figure 5: fitted regression line ####
ggplot(filtered_df, aes(x = Progressive.Carries.Per90, y = Shots.Per90)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", col = "blue") +
  labs(
    x = "Progressive Carries per 90 minutes",
    y = "Shots per 90 minutes"
  ) +
  theme_minimal()

#### Figure 6: residuals colored by position ####
plot(
  y = model$residuals,
  x = filtered_df$Progressive.Carries.Per90,
  xlab = "Progressive Carries per 90 minutes",
  ylab = "Residuals",
  main = "Residuals vs Predictor Plot",
  col = factor(filtered_df$Position),
  pch = 16
)

legend("right", legend = levels(factor(filtered_df$Position)), pch = 19, col = 1:length(levels(factor(filtered_df$Position))))

abline(h = 0)

#### Session information ####
sessionInfo()