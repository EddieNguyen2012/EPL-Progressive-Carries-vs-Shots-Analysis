library(ggplot2)
library(dplyr)
df <- read.csv('data/epl_player_stats_24_25.csv')

# Q: Is there a linear relationship between progressive ball-carrying and dispossession among English Premier League players in the 2024–25 season?

# Target: Dispossessed
# Predictor: Progressive.Carries 

# Note: as per https://www.statsperform.com/insights/identifying-progressive-ball-carriers/ quoted from Opta Pro
# - Carries is "any movement of the ball by a player which is greater than five metres from where they received the ball".
# - Progressive Carries: "carries that occur in the opposition half, which are greater than five metres and move the ball at least five metres towards the opposition goal"
# Progressive Carries is more of an attempt to try to progress the ball and is more effective to the outcome of an attacking sequence (advanced or dispossessed)
summary(df)

# Data seems cleaned

coverage <- 0.30

# Restrict the scope to players that involved in more than 15% of total matches

filtered_df <- df %>% 
  filter(
    Minutes > coverage * (37 * 90) &
    !(Shots == 0 & Progressive.Carries == 0) &
    Position != 'GKP'
  )

print(nrow(filtered_df))
filtered_df$Progressive.Carries.Per90 <- (filtered_df$Progressive.Carries * 90) / filtered_df$Minutes
filtered_df$Shots.Per90 <- (filtered_df$Shots * 90) / filtered_df$Minutes

plot(
  y=filtered_df$Shots.Per90,
  x=filtered_df$Progressive.Carries.Per90,
  col=factor(filtered_df$Position),
  xlab = "Progressive Carries per 90 minutes",
  ylab = "Shots per 90 minutes",
  main = "Progressive Carries vs Shots per 90 minutes",
  pch=16
)

legend("right", legend = levels(factor(filtered_df$Position)), pch = 19, col = 1:length(levels(factor(filtered_df$Position))))

model <- lm(filtered_df$Shots.Per90 ~ filtered_df$Progressive.Carries.Per90)

par(mfrow = c(1, 1))

plot(
  y=filtered_df$Shots.Per90,
  x=filtered_df$Progressive.Carries.Per90,
  col=factor(filtered_df$Position),
  xlab = "Progressive Carries per 90 minutes",
  ylab = "Shots per 90 minutes",
  main = "Progressive Carries vs Shots per 90 minutes",
  pch=16
)


abline(model)
summary(model)
par(mfrow = c(2, 2))
plot(model)
par(mfrow = c(1, 1))
