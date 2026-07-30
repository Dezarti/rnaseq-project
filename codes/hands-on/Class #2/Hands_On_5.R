################################################################################
######################## DAY 2 - CORRELATION AND MORE ##########################
################################################################################
# HANDS ON 5 - EXERCISE
# Run the third model.
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

# Step 3: Run the third model. 
third_model <- lm(Exercise ~ LDL_levels*Sugar_Consumption, data_f)
summary(third_model)
print(shapiro.test(residuals(third_model))) # Due to p-value, it might not be valid
