# Import the data from the CSV
data <- read.csv("/home/dusty/BrownBag - TERC/footballData.csv")

#Check the data
head(data)
summary(data)

# Tabulate wins vs at-home status
table(data$win, data$homeTeam)

# Import visualization library
library(ggplot2)

# Plot rush yards vs points against
ggplot(data, aes(x=rushYards, y=pointsAgainst)) + geom_point() + geom_smooth()

# Plot pass yards vs points against
ggplot(data, aes(x=passYards, y=pointsAgainst)) + geom_point() + geom_smooth()

# Plot rush yards vs win probability
ggplot(data, aes(x=rushYards, y=win)) + geom_smooth()

# Plot pass yards vs win probability
ggplot(data, aes(x=passYards, y=win)) + geom_smooth()

# Import dplyr to create aggregated data set
library(dplyr)

# Aggregate rush yards, pass yards, and points scored by season to explore trends
means <- data %>%
    group_by(season) %>%
    summarise(rushYards = mean(rushYards),
              passYards = mean(passYards),
              pointsFor = mean(pointsFor))

# Plot rush yards by season
ggplot(means, aes(x=season, y=rushYards)) + geom_smooth() + geom_point(size=3)

# Plot pass yards by season
ggplot(means, aes(x=season, y=passYards)) + geom_smooth() + geom_point(size=3)

# Plot points scored by season
ggplot(means, aes(x=season, y=pointsFor)) + geom_smooth() + geom_point(size=3)

# Execute a linear regression
model <- lm(win ~ rushYards + passYards + opponent + team + penYardsAgainst + passTD + rushTD + sacksAgainst + timeOfPoss, data=dataWin) 

# View regression table
summary(model)

# Create new data set excluding ties (for Logit model)
dataWin <- subset(data, data$win!=0.5)

# Execute a logistic regression
model <- glm(win ~ rushYards + passYards + opponent + team + penYardsAgainst + passTD + rushTD + sacksAgainst + timeOfPoss, data=dataWin, family="binomial")
