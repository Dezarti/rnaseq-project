################################################################################
# HANDS ON 2 - EXERCISE:
## 1.1 Create a character vector named carrier, which contains two entries: 
## “African swallow” and “European swallow”.
## 1.2 Create a matrix named airspeed with 2 rows and 2 columns. The first 
## column to be named laden and contain 10 and 15. The second column should be 
## named unladen and contain 9 and 8.
## 1.3 Calculate the sum and mean of all entries in airspeed.
## 1.4 Name row 1 from airspeeds “European swallow” and row 2 “African swallow”.
################################################################################
################################################################################

# 1.1. Create carrier vector
carrier <- c("African swallow", "European swallow")

# 1.2. Create matrix
airspeed <- matrix(c(10, 15, 9, 8), 2, 2)
colnames(airspeed) <- c("laden", "unladen")


# 1.3. Calculate sum and mean. 
v_sum <- sum(airspeed)
v_mean <- mean(airspeed)
print(v_sum)
print(v_mean)

# 1.4. Name row 1
rownames(airspeed) <- rev(carrier)
print(airspeed)




