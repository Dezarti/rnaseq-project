################################################################################
# HANDS ON 3 - EXERCISE:
## Consider creating a small fake data-set that relates to the research in your 
## laboratory.
## 1.1. Create a matrix:
##    3 columns (variables of interest)
##    8 rows (samples you are taking)
## 1.2 Fill the matrix with values.
## 1.3 Name the columns.
## 1.4 Calculate the sum and mean of columns.
## 1.5 Create a second matrix that:
##    rows are the variables of interest in the first matrix.
##    columns are the mean, median and standard deviation for each of those 
##    variables.
################################################################################
################################################################################

# 1.1 and 1.2. Creating and filling the matrix
fake_ds <- matrix(c(1:24) , 8, 3)
print(fake_ds)

# 1.3. Name columns
colnames(fake_ds) <- c('HEIGTH', 'WEIGHT', 'AGE')
print(fake_ds) # I know the data does not make any sense, it is just an exercise

# 1.4. sum and mean
height_sum <- sum(fake_ds[, "HEIGTH"])
weight_sum <- sum(fake_ds[, "WEIGHT"])
age_sum <- sum(fake_ds[, "AGE"])

height_mean <- mean(fake_ds[, "HEIGTH"])
weight_mean <- mean(fake_ds[, "WEIGHT"])
age_mean <- mean(fake_ds[, "AGE"])

# 1.5 Create a second matrix
fake_ds_2 <- matrix( , 3, 3)
colnames(fake_ds_2) <- c('MEAN', 'MEDIAN', 'STD')
rownames(fake_ds_2) <- colnames(fake_ds)

for (i in rownames(fake_ds_2)) {
  fake_ds_2[i, "MEAN"] <- mean(fake_ds[, i])
  fake_ds_2[i, "MEDIAN"] <- median(fake_ds[, i])
  fake_ds_2[i, "STD"] <- sd(fake_ds[, i])
}
print(fake_ds_2)

