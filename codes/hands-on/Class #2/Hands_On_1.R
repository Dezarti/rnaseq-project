################################################################################
######################## DAY 2 - CORRELATION AND MORE ##########################
################################################################################
# HANDS ON 1 - EXERCISE
# Implement the code for analyzing covariance.
# Use data from Data Set 3
# Important: remember to include comments (using #)
# covariance is a measure of how much two random variables change together
# Covariance tell the tendency.

################################################################################
################################################################################

# Step 1: Load the function
source("my_functions.R")


# Step 2: Cleaning the data. 
## Load data
data <- read.table("DATA_SET_REFERENCE_3.csv", 
                   header = TRUE,
                   row.names = 1,
                   sep=','
)

## Use the cleaner
data_f <- data_cleaner(data)
head(data_f)

# Step 3: Calculate the covariance with a custom function
## Function
covar_function <- function(data, col1, col2){
  mean_1 <- mean(data[, col1], na.rm=T)
  mean_2 <- mean(data[, col2], na.rm=T)
  n <- nrow(data)
  covar_r <- 0
  
  for (i in 1:n){
    covar_r <- covar_r + (((data[i, col1] - mean_1)*(data[i, col2] - mean_2))/n)
  }
  return(covar_r)
}

## Covariance value
cov_val <- covar_function(data_f, "LDL_levels", "Exercise")
print(cov_val)
