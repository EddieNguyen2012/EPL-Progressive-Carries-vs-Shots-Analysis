library(ggplot2)
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

filtered_df <- df[df$Progressive.Carries > 0, ] # Filter out players that did not do any progressive carries for the whole season

filtered_df$Progressive.Carries.Per90 <- (filtered_df$Progressive.Carries * 90) / filtered_df$Minutes
filtered_df$Dispossessed.Per90 <- (filtered_df$Dispossessed * 90) / filtered_df$Minutes

plot(
  y=filtered_df$Dispossessed.Per90,
  x=filtered_df$Progressive.Carries.Per90,
  col=factor(filtered_df$Position),
  xlab = "Progressive Carries per 90 minutes",
  ylab = "Dispossessed per 90 minutes",
  main = "Progressive Carries vs Dispossessed per 90 minutes"
)

legend("topright", legend = levels(factor(filtered_df$Position)), pch = 19, col = 1:length(levels(factor(filtered_df$Position))))
