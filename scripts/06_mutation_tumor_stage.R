# =====================================================================
# 06_mutation_tumor_stage.R → Tumor Stage & Mutation Analysis by Cluster
# =====================================================================

# ---------------- Libraries ----------------
library(tidyverse)
library(RColorBrewer)

# ---------------- Ensure results folder exists ----------------
if(!dir.exists("results/figures")){
  dir.create("results/figures", recursive = TRUE)
}

# ---------------- Load PCA + cluster data ----------------
data <- readRDS("results/pca_scores.rds")
df <- data$df

# =====================================================================
# 1. Tumor Stage Distribution Across Clusters
# =====================================================================

if ("tumor_stage" %in% names(df)) {
  
  df_stage <- df %>%
    filter(!is.na(tumor_stage), tumor_stage != "") %>%
    mutate(tumor_stage = factor(tumor_stage, levels = sort(unique(tumor_stage))))
  
  stage_plot <- df_stage %>%
    ggplot(aes(x = tumor_stage, fill = cluster)) +
    geom_bar(position = "dodge") +
    theme_minimal() +
    scale_fill_brewer(palette = "Dark2") +
    ggtitle("Tumor Stage Distribution Across Clusters")
  
  ggsave("results/figures/tumor_stage_by_cluster.png",
         stage_plot, width = 7, height = 5)
}

# =====================================================================
# 2. Automatic Mutation Gene Detection
# =====================================================================

# Mutation columns:
# - character type
# - contain "0"
# - contain at least one non-zero string (e.g., "M1974Ifs*32")
mutation_columns <- names(df)[sapply(df, function(col) {
  is.character(col) &&
    any(col == "0", na.rm = TRUE) &&
    any(col != "0" & col != "" & !is.na(col))
})]

message("Detected mutation columns: ", paste(mutation_columns, collapse = ", "))

if (length(mutation_columns) > 0) {
  
  # Convert mutation presence to TRUE/FALSE
  mut_present <- df[mutation_columns] != "0" & !is.na(df[mutation_columns])
  
  # Count mutations per cluster
  mut_cluster_freq <- df %>%
    select(cluster) %>%
    bind_cols(mut_present) %>%
    group_by(cluster) %>%
    summarize(across(everything(), ~ sum(.)), .groups = "drop") %>%
    pivot_longer(-cluster, names_to = "gene", values_to = "count")
  
  # Top 20 mutated genes
  top_mut <- mut_cluster_freq %>%
    group_by(gene) %>%
    summarize(total = sum(count)) %>%
    arrange(desc(total)) %>%
    slice(1:20) %>%
    pull(gene)
  
  message("Top mutated genes: ", paste(top_mut, collapse = ", "))
  
  # ---------------- Plot top mutations ----------------
  mut_plot <- mut_cluster_freq %>%
    filter(gene %in% top_mut) %>%
    ggplot(aes(x = gene, y = count, fill = cluster)) +
    geom_col(position = "dodge") +
    theme_minimal() +
    coord_flip() +
    ggtitle("Top 20 Mutations by Cluster") +
    scale_fill_brewer(palette = "Dark2")
  
  ggsave("results/figures/mutations_by_cluster.png",
         mut_plot, width = 7, height = 6)
}

cat("Tumor stage and mutation plots saved.\n")

