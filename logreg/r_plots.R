library(dplyr)
library(ggplot2)

## 1D Classification

x_zero <- rnorm(100, mean = -5, 5)
x_one <- rnorm(120, mean = 4, 3)
data <- list(x = c(x_zero, x_one), y = c(rep(0, 100), rep(1,120)))
df <- data.frame(data)

ggplot(df, aes(x,y)) + 
    geom_point(color = "blue", alpha = 0.5, size = 3) + 
    labs(x = "input", y = "output")

p <- ggplot(df, aes(x,y)) + 
    geom_point(color = "blue", alpha = 0.5, size = 3) + 
    labs(x = "input", y = "output")

p + geom_smooth(method = "lm", color = "red")
p + geom_smooth(method = "glm", method.args = list(family = "binomial"), color = "red")

## 2D Classification

# We will randomly generate samples uniformly on [0,5] x [0,5], and seperate them if 
# within cirlce of radius 5 around origin. Noise term will be added to seperation

x1 = runif(1000, 0, 5)
x2 = runif(1000, 0, 5)
y = (sqrt(x1^2 + 2*x2^2) + rnorm(1000,0,0.5) < 5) * 1

df = data.frame(list(
    x1 = x1,
    x2 = x2,
    y = y
))

ggplot(df, aes(x1, x2, color=y)) + geom_point()

write.csv(df, file="/home/dorian/workspace/slides/logreg_vowpalwabbit/classification.csv", row.names = F)
