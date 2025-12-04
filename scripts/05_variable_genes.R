# =====================================================================
# 05_variable_genes.R → Heatmap of Top Variable Genes Across Clusters
# =====================================================================

library(tidyverse)
library(ComplexHeatmap)
library(circlize)
library(RColorBrewer)

data <- readRDS("results/pca_scores.rds")
df <- data$df
expr_data <- df[, 32:520] %>% select(where(is.numeric))
expr_scaled <- scale(expr_data)

# Variable genes across clusters
expr_cluster_means <- expr_data %>% mutate(cluster = df$cluster) %>% 
  group_by(cluster) %>% summarize(across(everything(), mean), .groups = "drop")
gene_vars <- apply(expr_cluster_means[, -1], 2, var)
top_genes <- names(sort(gene_vars, decreasing = TRUE))[1:50]
heat_data <- expr_scaled[, top_genes]

cluster_colors <- brewer.pal(length(levels(df$cluster)), "Dark2")
names(cluster_colors) <- levels(df$cluster)
ha <- HeatmapAnnotation(Cluster = df$cluster, col = list(Cluster = cluster_colors))
col_fun <- colorRamp2(c(-2, 0, 2), c("blue", "white", "red"))

png("results/figures/variable_genes_heatmap.png", width = 900, height = 900)
Heatmap(t(heat_data), cluster_rows = TRUE, cluster_columns = TRUE,
        top_annotation = ha, name = "Expression",
        show_row_names = TRUE, show_column_names = FALSE,
        col = col_fun)
dev.off()
