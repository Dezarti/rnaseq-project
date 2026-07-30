library(here)
library(knitr)
library(dplyr)

# ============================================================
# Data-set used in the analysis
# ============================================================

## LOAD THE DATA
df_1 <- read.csv(here("data", "Part_2", "GSE75417_STATegra.RNAseq.CQN.Combat.Annotated.positive_2014_09.csv"))
df_1_2 <- read.csv(here("data", "Part_2", "GSE75417_STATegra.RNAseq.CQN.Combat.Annotated.positive_2014_09.csv"), row.names = 1)
df_2 <- df_1_2[, -1] # removing gene names, numeric matrix only

cat("Data-Set (first 3 rows and columns)\n")
print(kable(df_1 %>% select(1:3) %>% slice(1:3)))

## GENERAL EXPLORATION
print(paste("Number of rows:", nrow(df_1)))
print(paste("Number of columns:", ncol(df_1)))
print(paste("Minimum value:", round(min(df_2), 2)))
print(paste("Maximum value:", round(max(df_2), 2)))
print(paste("Blank MGI_Symbol entries:", sum(df_1_2$MGI_Symbol == "")))

## Normalized expression, 36 samples
boxplot(df_2, xlab = "", ylab = "log2 expression", xaxt = "n",
        main = "Normalized expression, 36 samples")

# ============================================================
# Quality Control: Experimental Design and Principal Component Analysis
# ============================================================

mat <- as.matrix(df_1_2[, -1]) # numeric expression matrix (drops MGI_Symbol column)

## Parsing the experimental design out of the sample names:
## Batch_{1..4}_{Ctr|Ik}_{0,2,6,12,18,24}H
name_parts <- do.call(rbind, strsplit(colnames(mat), "_"))
batch <- factor(name_parts[, 2])
cond <- factor(name_parts[, 3], levels = c("Ctr", "Ik")) # Ctr = reference level
time <- factor(sub("H", "", name_parts[, 4]), levels = c("0", "2", "6", "12", "18", "24"))
meta <- data.frame(sample = colnames(mat), batch = batch, cond = cond, time = time,
                    row.names = colnames(mat))

cat("Samples per batch and timepoint\n")
print(table(batch, time))

## Cell-means design, reused by the differential expression model
group <- factor(paste(cond, time, sep = "_"),
                 levels = paste(rep(c("Ctr", "Ik"), each = 6),
                                 c("0", "2", "6", "12", "18", "24"), sep = "_"))
design <- model.matrix(~ 0 + group)
colnames(design) <- levels(group)

## Colors reused by the PCA and expression plots
time_colors <- c("0" = "#000000", "2" = "#E69F00", "6" = "#56B4E9",
                  "12" = "#009E73", "18" = "#D55E00", "24" = "#CC79A7")
cond_colors <- c("Ctr" = "#56B4E9", "Ik" = "#D55E00")

## PCA of all 36 samples, colored by time, shaped by condition
pca_result <- prcomp(t(mat), center = TRUE, scale. = FALSE)
variance <- summary(pca_result)$importance[2, ] * 100
pc1_label <- paste0("PC1 (", round(variance[1], 1), "%)")
pc2_label <- paste0("PC2 (", round(variance[2], 1), "%)")

point_colors <- time_colors[as.character(meta$time)]
point_shapes <- ifelse(meta$cond == "Ctr", 16, 17)

plot(pca_result$x[, 1], pca_result$x[, 2],
     col = point_colors, pch = point_shapes, cex = 1.1,
     xlab = pc1_label, ylab = pc2_label,
     main = "PCA of all 36 samples, colored by time, shaped by condition",
     bty = "l", las = 1)
legend("topright", title = "Time", legend = paste0(levels(meta$time), "H"),
       col = time_colors, pch = 15, pt.cex = 0.9, bty = "n")
legend("topleft", title = "Cond.", legend = levels(meta$cond),
       pch = c(16, 17), col = "black", pt.cex = 0.9, bty = "n")

# ============================================================
# SAVING RESULTS
# ============================================================
## Regenerable intermediate, reused by the next scripts (data/ is gitignored)
dir.create(here("data", "Part_2", "processed"), showWarnings = FALSE)
saveRDS(
  list(df_1_2 = df_1_2, mat = mat, meta = meta, design = design,
       time_colors = time_colors, cond_colors = cond_colors),
  here("data", "Part_2", "processed", "qc_workspace.rds")
)
