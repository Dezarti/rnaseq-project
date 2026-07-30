data_cleaner <- function(data){
  ## Creating copy for safety
  data_copied <- data.frame(data)
  
  ## Creating filter 1: Delete individuals with LDL < 0
  clean_LDL <- data_copied$LDL_levels >= 0
  
  ## Creating filter 1: Delete individuals with exercise < 0
  clean_exercise <- data_copied$Exercise >= 0
  
  ## Creating filter 2: Delete individuals with SC < 0
  clean_sugar_consumption <- data_copied$Sugar_Consumption >= 0
  
  ## Cleaning with filters
  data_copied_2 <- data_copied[clean_LDL & clean_exercise & clean_sugar_consumption, ]
  
  # Step 7: Removing Outliers
  ## Define outlier: > mean - 3*sd or > mean + 3*sd
  max_limit_LDL <- mean(data_copied_2$LDL_levels, na.rm = T) + 3*sd(data_copied_2$LDL_levels, na.rm = T)
  min_limit_LDL <- mean(data_copied_2$LDL_levels, na.rm = T) - 3*sd(data_copied_2$LDL_levels, na.rm = T)
  max_limit_exercise <- mean(data_copied_2$Exercise, na.rm = T) + 3*sd(data_copied_2$Exercise, na.rm = T)
  min_limit_exercise <- mean(data_copied_2$Exercise, na.rm = T) - 3*sd(data_copied_2$Exercise, na.rm = T)
  max_limit_sugar <- mean(data_copied_2$Sugar_Consumption, na.rm = T) + 3*sd(data_copied_2$Sugar_Consumption, na.rm = T)
  min_limit_sugar <- mean(data_copied_2$Sugar_Consumption, na.rm = T) - 3*sd(data_copied_2$Sugar_Consumption, na.rm = T)
  
  ## Creating filters
  clean_LDL_2 <- min_limit_LDL < data_copied_2$LDL & 
    max_limit_LDL > data_copied_2$LDL 
  
  clean_exercise_2 <- min_limit_exercise < data_copied_2$Exercise & 
    max_limit_exercise > data_copied_2$Exercise 
  
  clean_sugar_2 <- data_copied_2$Sugar_Consumption > min_limit_sugar & 
    max_limit_sugar > data_copied_2$Sugar_Consumption 
  
  ## Cleaning with filters
  data_copied_3 <- data_copied_2[clean_LDL_2 & clean_exercise_2 & clean_sugar_2, ]
  
  return(data_copied_3)
}