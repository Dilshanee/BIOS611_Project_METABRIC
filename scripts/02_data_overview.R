# =====================================================================
# 02_data_overview.R → Data Overview Plots: Age, Survival, Tumor Stage, Treatment
# =====================================================================

# ---------------- Libraries ----------------
library(tidyverse)

# ---------------- Ensure results folder ----------------
if(!dir.exists("results/figures")){
  dir.create("results/figures", recursive = TRUE)
}

# ---------------- Load preprocessed data ----------------
df <- readRDS("results/data_processed.rds")

# ---------------- 1. Age Distribution ----------------
median_age <- median(df$age_at_diagnosis, na.rm = TRUE)

age_plot <- ggplot(df, aes(x = age_at_diagnosis)) +
  geom_histogram(binwidth = 5, fill = "steelblue", color = "black", alpha = 0.7) +
  theme_minimal(base_size = 16) +
  labs(title = "Age Distribution",
       subtitle = paste("Median age:", median_age, "Years"),
       x = "Age at Diagnosis (Years)",
       y = "Count")

ggsave("results/figures/age_distribution.png", age_plot, width = 7, height = 5)

# ---------------- 2. Overall Survival Histogram ----------------
median_surv <- median(df$overall_survival_months, na.rm = TRUE)
median_surv <- round(median_surv, 2)  # Limit to 2 decimals

surv_plot <- ggplot(df, aes(x = overall_survival_months)) +
  geom_histogram(binwidth = 12, fill = "darkgreen", color = "black", alpha = 0.7) +
  theme_minimal(base_size = 16) +
  labs(title = "Overall Survival Distribution",
       subtitle = paste("Median survival:", median_surv, "Months"),
       x = "Overall Survival (Months)",
       y = "Count")

ggsave("results/figures/overall_survival_distribution.png", surv_plot, width = 7, height = 5)

# ---------------- 3. Tumor Stage Distribution ----------------
if("tumor_stage" %in% names(df)){
  tumor_stage_plot <- ggplot(df, aes(x = tumor_stage)) +
    geom_bar(fill = "orange", color = "black", alpha = 0.7) +
    theme_minimal(base_size = 16) +
    labs(title = "Tumor Stage Distribution",
         x = "Tumor Stage",
         y = "Count") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  ggsave("results/figures/tumor_stage_distribution.png", tumor_stage_plot, width = 7, height = 5)
}

# ---------------- 4. Treatment Type Distribution ----------------
if("treatment_type" %in% names(df)){
  treatment_plot <- ggplot(df, aes(x = treatment_type)) +
    geom_bar(fill = "purple", color = "black", alpha = 0.7) +
    theme_minimal(base_size = 16) +
    labs(title = "Treatment Type Distribution",
         x = "Treatment Type",
         y = "Count") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  ggsave("results/figures/treatment_type_distribution.png", treatment_plot, width = 7, height = 5)
}

