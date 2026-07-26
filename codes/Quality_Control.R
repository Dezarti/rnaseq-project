# LOAD THE DATA FRAME
df_1 <- read.csv("data/Part_1/DATA_SET_REFERENCE_EVAL.csv", row.names = 1)
head(df_1) # Check data
par(mfrow = c(1, 1)) 
# GENERAL EXPLORATION
summary(df_1)
unique(df_1$Planet)
unique(df_1$Size)
sum(is.na(df_1))
boxplot(df_1[1:2])

## 1. Col HDL:
##        - Contains negative values
##        - Contains 1 NA value
## 2. Col LDL:
##        - Contains negative values
##        - Contains 1 NA value
## 3. Col Size:
##        - Two values: "Tall" and "Small"
## 4. Col Planet:
##        - Two values: "Earth" and "Venus"


## FILTERING AND CLEANING
## Removing negative values
df_2 <- data.frame(df_1) # Security copy

### Idx 1: Delete individuals with HDL < 0
idx_hdl <- df_2$HDL >= 0

### Idx 2: Delete individuals with LDL < 0
idx_ldl <- df_2$LDL >= 0

### Cleaning with filters
df_3 <- df_2[idx_hdl & idx_ldl, ] # Here we remove 2 values.

## Identifying and removing outliers
## Define outlier: > mean - 3*sd or > mean + 3*sd
max_limit_LDL <- mean(df_3$LDL, na.rm = T) + 3*sd(df_3$LDL, na.rm = T)
min_limit_LDL <- mean(df_3$LDL, na.rm = T) - 3*sd(df_3$LDL, na.rm = T)
max_limit_HDL <- mean(df_3$HDL, na.rm = T) + 3*sd(df_3$HDL, na.rm = T)
min_limit_HDL <- mean(df_3$HDL, na.rm = T) - 3*sd(df_3$HDL, na.rm = T)

## Creating filters
clean_LDL <- min_limit_LDL < df_3$LDL & 
  max_limit_LDL > df_3$LDL # Only TRUE

clean_HDL <- min_limit_HDL < df_3$HDL & 
  max_limit_HDL > df_3$HDL 

## Checking results
unique(clean_LDL) # Only unique values
unique(clean_HDL) # Only Unique values

## Cleaning with filters
df_4 <- df_3[clean_LDL & clean_HDL, ]

## Cleaning with filters
df_4 <- df_3[clean_LDL & clean_HDL, ]

# Plot LDL grouped by Planets using the formula interface

# Groups LDL by Planet AND Size on the same x-axis
# Split canvas into 1 row, 2 columns
par(mfrow = c(1, 2)) 

boxplot(LDL ~ Planet * Size, 
        data = df_4, 
        main = "LDL Levels by Planet and Size", 
        col = c("#56B4E9", "#E69F00"), 
        pch = 16)

boxplot(HDL ~ Planet * Size, 
        data = df_4, 
        main = "HDL Levels by Planet and Size", 
        col = c("#56B4E9", "#E69F00"), 
        pch = 16)

# Reset canvas layout back to default
#par(mfrow = c(1, 1))


# Comparing two continuos values
## GRAPH A
df_4$Group <- interaction(df_4$Planet, df_4$Size, sep = "-") # Combined group factor
# Levels will be: Earth-Small, Venus-Small, Earth-Tall, Venus-Tall (alphabetical/factor order)
group_levels <- levels(df_4$Group)
cb_colors <- c("#E69F00", "#0072B2", "#009E73", "#CC79A7")  # 4 colorblind-safe colors
shapes    <- c(16, 17, 15, 18)                               # circle, triangle, square, diamond

plot(df_4$LDL, df_4$HDL,
     col = cb_colors[df_4$Group],
     pch = shapes[df_4$Group],
     xlab = "LDL", ylab = "HDL",
     main = "A. HDL vs LDL by Planet-Size Group")

legend("topright", legend = group_levels,
       col = cb_colors, pch = shapes, bty = "n")


## GRAPH B
cb_colors <- c("#E69F00", "#0072B2")  # for Size: Small, Tall
shapes <- c(16, 17)                    # for Planet: Earth = circle, Venus = triangle

plot(df_4$LDL, df_4$HDL,
     col = cb_colors[as.factor(df_4$Size)],
     pch = shapes[as.factor(df_4$Planet)],
     xlab = "LDL", ylab = "HDL",
     main = "B. HDL vs LDL by Size (color) and Planet (shape)")

legend("topright",
       legend = c(levels(as.factor(df_4$Size)), levels(as.factor(df_4$Planet))),
       col = c(cb_colors, "black", "black"),
       pch = c(19, 19, shapes),
       pt.cex = 1, bty = "n")


#########################################
### SAVING RESULTS
#########################################
write.csv(df_4, "data/Part_1/CLEAN_DATA_SET_REFERENCE_EVAL.csv", row.names = FALSE)







########################################
# 1 analysis of 2 continuous variables.
#######################################

#"Is there a difference in HDL and LDL levels between Tall and Small patients?" 
#"Is there a difference in HDL and LDL levels between Earth and Venus patients?"

# ## Checking normality in the data.
# s1 = shapiro.test(df_4$HDL[df_4$Planet == 'Earth' & df_4$Size == 'Tall'])$p.value  # Ho not rejected
# s2 = shapiro.test(df_4$HDL[df_4$Planet == 'Venus' & df_4$Size == 'Tall'])$p.value  # Ho not rejected
# s3 = shapiro.test(df_4$HDL[df_4$Planet == 'Earth' & df_4$Size == 'Small'])$p.value # Ho not rejected
# s4 = shapiro.test(df_4$HDL[df_4$Planet == 'Venus' & df_4$Size == 'Small'])$p.value # Ho not rejected
# 

# results = data.frame(Planet = c('Earth', 'Venus', 'Earth', 'Venus'),
#   Size = c('Tall', 'Tall', 'Small', 'Small'),
#   Shapiro_Test =  c(s1, s2, s3, s4),
#   Result = c('')
# )
# 
# for (i in 1:nrow(results)){
#   if (results$Shapiro_Test[i] <= 0.05){
#     results$Result[i] = 'Reject Ho'
#   } else {
#     results$Result[i] = 'Cannot reject Ho'
#   }
# }
# 
# print(results)
# 
# t.test
# 









#######################################
# Continuous vs. continuous: HDL vs. LDL
#######################################



