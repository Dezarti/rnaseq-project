################################################################################
######################## DAY 2 - CORRELATION AND MORE ##########################
################################################################################
# HANDS ON 3 - EXERCISE
# Generate the code to compute the b1 and b0.
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

# Step 3: Define the equation. 
Sxy <- sum((data_f$LDL_levels-mean(data_f$LDL_levels))*(data_f$Exercise-mean(data_f$Exercise)))/(nrow(data_f)-1)
Sx <- sum((data_f$LDL_levels - mean(data_f$LDL_levels))**2)/(nrow(data_f)-1)

b1 <- Sxy / Sx
b0 <- mean(data_f$Exercise) - b1*mean(data_f$LDL_levels)

# Step 4: Print results
cat("Slope:", b1, "\n")
cat("Intercept:", b0, "\n")



