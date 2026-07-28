library(here)
library(knitr)
library(dplyr)

# ============================================================
# Data-set used in the analysis
# ============================================================

## LOAD THE DATA FRAME
df_1 <- read.csv(here("data", "Part_1", "DATA_SET_REFERENCE_EVAL.csv"), row.names = 1)

## Fictional Data-Set. First 3 entries
cat("Fictional Data-Set. First 3 entries\n")
print(head(df_1, n = 3L))

## GENERAL EXPLORATION
print(paste("Number of rows:", nrow(df_1))) # Check number of rows
print(paste("Number of columns:", ncol(df_1))) # Check number of columns
print(paste("Column names:", paste(colnames(df_1), collapse = ", ")))
print(paste("Unique values inside 'Size' column:",
            paste(unique(df_1$Size), collapse = ", ")))
print(paste("Unique values inside 'Planet' column:",
            paste(unique(df_1$Planet), collapse = ", ")))
print(paste("Number of 'Venus' patients:", sum(df_1$Planet == "Venus", na.rm = TRUE)))
print(paste("Number of 'Earth' patients:", sum(df_1$Planet == "Earth", na.rm = TRUE)))
print(paste("Number of tall patients:", sum(df_1$Size == "Tall", na.rm = TRUE)))
print(paste("Number of small patients:", sum(df_1$Size == "Small", na.rm = TRUE)))

## Data-Set Summary
cat("Data-Set Summary\n")
print(summary(df_1))

# ============================================================
# Curation of the data
# ============================================================

## Negative and NA values
# Checking the patients to eliminate
n_idx_hdl <- df_1$HDL <= 0 | is.na(df_1$HDL)
n_idx_ldl <- df_1$LDL <= 0 | is.na(df_1$LDL)

df_f_o <- df_1[which(n_idx_hdl | n_idx_ldl), ]
cat("Negative and NA Values\n")
print(head(df_f_o))

## Removing negative values
df_2 <- data.frame(df_1) # Security copy

### Idx 1: Delete individuals with HDL < 0
idx_hdl <- df_2$HDL >= 0 & !is.na(df_2$HDL)

### Idx 2: Delete individuals with LDL < 0
idx_ldl <- df_2$LDL >= 0 & !is.na(df_2$LDL)

### Cleaning with filters
df_3 <- df_2[idx_hdl & idx_ldl, ] # Here we remove 2 values.
print(paste("Number of patients after removing negative and NA values: ", nrow(df_3)))

## Outliers
## Defined using a threshold of three standard deviations from the mean:
## Upper Limit = mean + 3 * SD ; Lower Limit = mean - 3 * SD
max_limit_LDL <- mean(df_3$LDL, na.rm = T) + 3 * sd(df_3$LDL, na.rm = T)
min_limit_LDL <- mean(df_3$LDL, na.rm = T) - 3 * sd(df_3$LDL, na.rm = T)
max_limit_HDL <- mean(df_3$HDL, na.rm = T) + 3 * sd(df_3$HDL, na.rm = T)
min_limit_HDL <- mean(df_3$HDL, na.rm = T) - 3 * sd(df_3$HDL, na.rm = T)

## Creating filters
clean_LDL <- min_limit_LDL < df_3$LDL &
  max_limit_LDL > df_3$LDL # Only TRUE

clean_HDL <- min_limit_HDL < df_3$HDL &
  max_limit_HDL > df_3$HDL

## Cleaning with filters
df_4 <- df_3[clean_LDL & clean_HDL, ]
# No values were excluded by the outlier filter (same 398 observations remain)
print(sum(df_4$HDL == df_3$HDL))

# ============================================================
# Data exploration
# ============================================================

## Normalization and balance
balance_table <- df_4 %>%
  group_by(Planet, Size) %>%
  summarise(n = n(), .groups = "drop") %>%
  mutate(Percent = round(100 * n / sum(n), 1))

cat("Sample sizes by Planet and Size group\n")
print(kable(balance_table, align = "c"))

## Comparing Categorical and Continuous Data
## Histogram of LDL levels
hist(df_4$LDL,
     main = "Histogram of LDL levels")

## Histogram of HDL levels
hist(df_4$HDL,
     main = "Histogram of HDL levels")

## Q-Q Plot of LDL levels
qqnorm(df_4$LDL, pch = 1, frame = FALSE, main = "Q-Q Plot of LDL levels")
qqline(df_4$LDL, col = "steelblue", lwd = 2)

## Q-Q Plot of HDL levels
qqnorm(df_4$HDL, pch = 1, frame = FALSE, main = "Q-Q Plot of HDL levels")
qqline(df_4$HDL, col = "steelblue", lwd = 2)

## LDL levels by Size group
# Colorblind-friendly palette (Okabe-Ito), one color per Size group
group_colors <- c("Small" = "#E69F00", "Tall" = "#56B4E9")

boxplot(LDL ~ Size,
        data = df_4,
        main = "LDL levels by Size group",
        col = group_colors,
        density = c(25, 70),   # different shading density = second visual cue, not just color
        pch = 16,
        ylab = "LDL")

## HDL levels by Size group
boxplot(HDL ~ Size,
        data = df_4,
        main = "HDL levels by Size group",
        col = group_colors,
        density = c(25, 70),
        pch = 16,
        ylab = "HDL")

## LDL levels by Planet group
# Colorblind-friendly palette (Okabe-Ito), one color per Size group
group_colors <- c("Small" = "#E69F00", "Tall" = "#56B4E9")

boxplot(LDL ~ Planet,
        data = df_4,
        main = "LDL levels by Planet group",
        col = group_colors,
        density = c(25, 70),   # different shading density = second visual cue, not just color
        pch = 16,
        ylab = "LDL")

## HDL levels by Planet group
boxplot(HDL ~ Planet,
        data = df_4,
        main = "HDL levels by Planet group",
        col = group_colors,
        density = c(25, 70),
        pch = 16,
        ylab = "HDL")

## Comparing Continuous Data
## HDL vs LDL by Size (color) and Planet (shape)
df_4$Group <- interaction(df_4$Planet, df_4$Size, sep = "-") # Combined group factor
# Levels will be: Earth-Small, Venus-Small, Earth-Tall, Venus-Tall (alphabetical/factor order)
group_levels <- levels(df_4$Group)
cb_colors <- c("#E69F00", "#0072B2")  # for Size: Small, Tall
shapes <- c(16, 17)                    # for Planet: Earth = circle, Venus = triangle

plot(df_4$LDL, df_4$HDL,
     col = cb_colors[as.factor(df_4$Size)],
     pch = shapes[as.factor(df_4$Planet)],
     xlab = "LDL", ylab = "HDL",
     main = "HDL vs LDL by Size (color) and Planet (shape)")

legend("topright",
       legend = c(levels(as.factor(df_4$Size)), levels(as.factor(df_4$Planet))),
       col = c(cb_colors, "black", "black"),
       pch = c(19, 19, shapes),
       pt.cex = 1, bty = "n")

# ============================================================
# SAVING RESULTS
# ============================================================
write.csv(df_4, here("data", "Part_1", "CLEAN_DATA_SET_REFERENCE_EVAL.csv"), row.names = FALSE)
