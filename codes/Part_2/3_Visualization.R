library(here)
library(pheatmap)
library(ggplot2)
library(dplyr)
library(tidyr)

# ============================================================
# Loading QC + DE workspaces
# ============================================================
qc <- readRDS(here("data", "Part_2", "processed", "qc_workspace.rds"))
de <- readRDS(here("data", "Part_2", "processed", "de_results.rds"))

df_1_2 <- qc$df_1_2
mat <- qc$mat
cond_colors <- qc$cond_colors
top_markers <- de$top_markers

# ============================================================
# Heatmap of the top 10 markers (0H vs 24H samples)
# ============================================================
top_10_ids <- rownames(head(top_markers, 10))
heatmap_data <- mat[top_10_ids, ]
rownames(heatmap_data) <- head(top_markers$Gene_Name, 10)

cols_to_keep <- grepl("0H|24H", toupper(colnames(heatmap_data)))
clean_heatmap_data <- heatmap_data[, cols_to_keep]

my_colors <- colorRampPalette(c("#4477AA", "white", "#EE6677"))(50)
pheatmap(clean_heatmap_data,
         scale = "row",
         color = my_colors,
         cluster_rows = TRUE,
         cluster_cols = TRUE,
         show_colnames = TRUE,
         main = "Top 10 Markers: 0H vs 24H",
         fontsize = 12)

# ============================================================
# Expression dynamics of the positive-control markers (Rag1, Igll1)
# ============================================================
genes_to_plot <- c("Rag1", "Igll1")
gene_ids <- rownames(df_1_2)[df_1_2$MGI_Symbol %in% genes_to_plot]
names(gene_ids) <- genes_to_plot

expr_data <- as.data.frame(t(mat[gene_ids, ]))
colnames(expr_data) <- names(gene_ids)
expr_data$Sample <- rownames(expr_data)

plot_data <- expr_data %>%
  pivot_longer(cols = c("Rag1", "Igll1"), names_to = "Gene", values_to = "Expression") %>%
  mutate(
    Condition = ifelse(grepl("Ik", Sample), "Ik", "Ctr"),
    Time = as.numeric(gsub(".*_([0-9]+)H.*", "\\1", Sample))
  )

ggplot(plot_data, aes(x = Time, y = Expression, color = Condition, group = Condition)) +
  stat_summary(fun = mean, geom = "line", linewidth = 1) +
  stat_summary(fun = mean, geom = "point", size = 2) +
  stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.5) +
  facet_wrap(~Gene, scales = "free_y") +
  theme_minimal() +
  scale_color_manual(values = cond_colors) +
  labs(title = "Expression Dynamics of Canonical Maturation Markers",
       x = "Time (H)", y = "Log Expression")
