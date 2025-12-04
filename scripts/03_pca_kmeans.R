# =====================================================================
# 03_pca_kmeans.R → PCA, K-means Clustering, Scree/Elbow/Gap Plots
# =====================================================================

library(tidyverse)
library(cluster)
library(factoextra)
library(RColorBrewer)

# ------------------ Ensure results folder exists -------------------
if(!dir.exists("results/figures")){
  dir.create("results/figures", recursive = TRUE)
}

# ------------------ Load preprocessed data -------------------------
df <- readRDS("results/data_processed.rds")

# Extract numeric expression columns for PCA
expr_data <- df[, 32:520] %>% select(where(is.numeric))

# ------------------ PCA ---------------------------------------------
expr_scaled <- scale(expr_data)
pca <- prcomp(expr_scaled, center = TRUE, scale. = TRUE)
pca_scores <- as.data.frame(pca$x[, 1:20])

# ------------------ Scree Plot --------------------------------------
scree_plot <- fviz_eig(pca) +
  ggtitle("Variance Explained by Principal Components") +
  theme_minimal() +
  theme(text = element_text(size = 14))
ggsave("results/figures/scree_plot.png", scree_plot, width = 7, height = 5)

# ------------------ Determine Optimal k -----------------------------
set.seed(123)
gap <- clusGap(pca_scores, FUN = kmeans, K.max = 10, B = 50)

# Gap statistic plot
gap_plot <- fviz_gap_stat(gap) +
  theme_minimal() +
  geom_vline(xintercept = 4, color = "red", linetype = "dashed", size = 1)
ggsave("results/figures/gap_statistic.png", gap_plot, width = 7, height = 5)

# Elbow method plot
elbow_plot <- fviz_nbclust(pca_scores, kmeans, method = "wss") +
  ggtitle("Elbow Method") +
  theme_minimal() +
  geom_vline(xintercept = 4, color = "red", linetype = "dashed", size = 1)
ggsave("results/figures/elbow_method.png", elbow_plot, width = 7, height = 5)

# ------------------ K-means clustering ------------------------------
final_k <- 4
set.seed(42)
km <- kmeans(pca_scores, centers = final_k, nstart = 50)
df$cluster <- factor(km$cluster)

# ------------------ PCA Scatter Plot --------------------------------
pca_df <- data.frame(PC1 = pca_scores$PC1,
                     PC2 = pca_scores$PC2,
                     cluster = df$cluster)

cluster_colors <- brewer.pal(final_k, "Dark2")

p <- ggplot(pca_df, aes(PC1, PC2, color = cluster)) +
  geom_point(alpha = 0.6, size = 2) +
  theme_minimal() +
  scale_color_brewer(palette = "Dark2") +
  ggtitle("PCA of Expression (Colored by Clusters)")

ggsave("results/figures/pca_clusters.png", p, width = 7, height = 5)

# ------------------ Save PCA scores + cluster info ------------------
saveRDS(list(df = df, pca_scores = pca_scores), "results/pca_scores.rds")
cat("PCA + clustering done\n")


