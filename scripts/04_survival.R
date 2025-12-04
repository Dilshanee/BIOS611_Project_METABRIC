# =====================================================================
# 04_survival.R → Survival Analysis by Cluster
# =====================================================================

library(survival)
library(survminer)
library(tidyverse)

# Ensure results folder exists
if(!dir.exists("results/figures")){
  dir.create("results/figures", recursive = TRUE)
}

# Load PCA + cluster data
data <- readRDS("results/pca_scores.rds")
df <- data$df

# Survival analysis
surv_obj <- Surv(df$overall_survival_months, df$overall_survival)
fit <- survfit(surv_obj ~ cluster, data = df)

km_plot <- ggsurvplot(fit, data = df, pval = TRUE, risk.table = TRUE,
                      palette = "Dark2", title = "Survival Differences Between Clusters")

# Save plots
ggsave("results/figures/survival_clusters.png", km_plot$plot, width = 7, height = 5)
ggsave("results/figures/survival_clusters_risktable.png", km_plot$table, width = 7, height = 5)
cat("Survival plots saved\n")
