# Learning about R2

# seeing r2 for range 1-10 simple linear model
x <- seq(1,10,length.out = 100)
set.seed(1)
y <- 2 + 1.2*x + rnorm(100,0,sd = 0.9)
mod1 <- lm(y ~ x)
summary(mod1)$r.squared #  0.9383379
sum((fitted(mod1) - y)^2)/100 # 0.6468052


# seeing r2 for range 1-2 simple linear model
x2 <- seq(1,2,length.out = 100)       # new range of x
set.seed(1)
y2 <- 2 + 1.2*x + rnorm(100,0,sd = 0.9)
mod2 <- lm(y ~ x)
summary(mod1)$r.squared # 0.150244
sum((fitted(mod1) - y)^2)/100        # Mean squared error
# 0.6468052
#
#
#



# graphing results to understand data

plot(x, y)
plot(x2, y2) # identical visually with different X ranges. so just different slopes would be expected of well fit linear models corrrect?


































































