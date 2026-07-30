################################################################################
# HANDS ON 4 - EXERCISE:
## Use data set 1: DATA_SET_REFERENCE_1.csv
## 1.1 Read the data. Use functions read.table or read.csv
## 1.2 Create a matrix that
##    rows are the variables in Data Set 1
##    columns are mean, median and standard deviation for each of those variables
## EXERCISE: USE LOOPS
## REPEAT FOR DATA SET 2.
################################################################################
################################################################################

## DATASET 1

# 1.1. Read data
data_set_1 <- read.table("DATA_SET_REFERENCE_1.csv", 
                   header = TRUE,
                   row.names = 1,
                   sep=','
)

# 1.2. Create a matrix
df_1 <- data_set_1[ , -6]
SUMMARY_1 <- matrix(0, ncol(df_1), 3)
colnames(SUMMARY_1) <- c("MEAN", "MEDIAN", "STD")
rownames(SUMMARY_1) <- colnames(df_1)


# Fill the SUMMARY matrix
for (x in rownames(SUMMARY_1)){
  SUMMARY_1[x, "MEAN"] <- mean(data_set_1[ , x])
  SUMMARY_1[x, "MEDIAN"] <- median(data_set_1[ , x])
  SUMMARY_1[x, "STD"] <- sd(data_set_1[ , x])
  
}

# Visualize
SUMMARY_1


################################################################################
################################################################################

## DATASET 2

# 2.1. Read data
data_set_2 <- read.table("DATA_SET_REFERENCE_2.csv", 
                   header = TRUE,
                   row.names = 1,
                   sep=','
)


# 2.2. Create a matrix
df_2 <- data_set_2[ , -6]
SUMMARY_2 <- matrix(0, ncol(df_2), 3)
colnames(SUMMARY_2) <- c("MEAN", "MEDIAN", "STD")
rownames(SUMMARY_2) <- colnames(df_2)


# Fill the SUMMARY matrix
for (x in rownames(SUMMARY_2)){
  SUMMARY_2[x, "MEAN"] <- mean(data_set_2[ , x], na.rm = TRUE)
  SUMMARY_2[x, "MEDIAN"] <- median(data_set_2[ , x], na.rm = TRUE)
  SUMMARY_2[x, "STD"] <- sd(data_set_2[ , x], na.rm = TRUE)
  
}

# Visualize
SUMMARY_2 
