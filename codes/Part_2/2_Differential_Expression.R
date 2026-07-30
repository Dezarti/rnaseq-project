library(here)
library(limma)
library(knitr)

# ============================================================
# Loading QC workspace
# ============================================================
qc <- readRDS(here("data", "Part_2", "processed", "qc_workspace.rds"))
df_1_2 <- qc$df_1_2
mat <- qc$mat
design <- qc$design

# ============================================================
# Differential Expression Model
# ============================================================
## Contrast: mature Ik (24H) vs immature Ik (0H)
contrast_matrix <- makeContrasts(
  Maturation = Ik_24 - Ik_0,
  levels = design
)

## Fit the linear model and apply the contrast
fit <- lmFit(mat, design)
fit_contrasts <- contrasts.fit(fit, contrast_matrix)

## Empirical Bayes moderation of the variance estimates
fit_ebayes <- eBayes(fit_contrasts)

## Top 20 markers for the Maturation contrast, BH-adjusted
top_markers <- topTable(fit_ebayes, coef = "Maturation", number = 20,
                        sort.by = "P", adjust.method = "BH")
top_markers$Gene_Name <- df_1_2$MGI_Symbol[match(rownames(top_markers), rownames(df_1_2))]

cat("Top 10 differentiation markers (24H vs 0H)\n")
markers_display <- head(top_markers[, c("Gene_Name", "logFC", "t", "adj.P.Val")], 10)
markers_display$logFC <- round(markers_display$logFC, 2)
markers_display$t <- round(markers_display$t, 2)
markers_display$adj.P.Val <- formatC(markers_display$adj.P.Val, format = "e", digits = 1)
print(kable(markers_display, row.names = FALSE,
            col.names = c("Gene", "log2FC(24H)", "t", "adj.P")))

# ============================================================
# Volcano plot: all genes, Maturation contrast
# ============================================================
res <- topTable(fit_ebayes, coef = "Maturation", number = Inf, sort.by = "P", adjust.method = "BH")
res$Gene_Name <- df_1_2$MGI_Symbol[match(rownames(res), rownames(df_1_2))]

## Color by significance and direction (logFC > 1 / < -1, adj.P.Val < 0.05)
res$Color <- "gray80"
res$Color[res$logFC > 1 & res$adj.P.Val < 0.05] <- "#EE6677" # Up
res$Color[res$logFC < -1 & res$adj.P.Val < 0.05] <- "#4477AA" # Down

plot(res$logFC, -log10(res$P.Value),
     pch = 16, cex = 0.6, col = res$Color,
     xlab = "Log2 Fold Change", ylab = "-log10(P-value)",
     main = "Differential Expression: 24H vs 0H Maturation",
     font.main = 2, bty = "l", las = 1)
abline(v = c(-1, 1), col = "black", lty = 2)
abline(h = -log10(0.05), col = "black", lty = 2)

## Label the genes discussed in the report (Dok3, Tifa, Ass1)
genes_to_label <- c("Dok3", "Tifa", "Ass1")
label_df <- res[match(genes_to_label, res$Gene_Name), ]
text(x = label_df$logFC, y = -log10(label_df$P.Value),
     labels = label_df$Gene_Name, pos = c(3, 1, 2),
     cex = 0.7, col = "black", font = 4)

# ============================================================
# SAVING RESULTS
# ============================================================
saveRDS(
  list(fit_ebayes = fit_ebayes, top_markers = top_markers, res = res),
  here("data", "Part_2", "processed", "de_results.rds")
)
write.csv(top_markers, here("data", "Part_2", "processed", "top_markers.csv"), row.names = TRUE)
