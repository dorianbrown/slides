library(dplyr)
library(ggplot2)

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
