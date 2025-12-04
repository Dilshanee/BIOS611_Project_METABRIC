# =====================================================================
# 01_load_data.R → Load and preprocess METABRIC RNA-seq dataset
# =====================================================================

# ---------------------------- Libraries -------------------------------
library(tidyverse)

# ---------------------------- Create Results Folder ------------------
dir.create("results/figures", showWarnings = FALSE)

# ---------------------------- Load Dataset ---------------------------
# Make sure the CSV is in the 'data/' folder
csv_file <- "data/METABRIC_RNA_Mutation.csv"

if (!file.exists(csv_file)) {
  stop("CSV file not found. Please place METABRIC_RNA_Mutation.csv in the data/ folder.")
}

df <- read_csv(csv_file)

# ---------------------------- Save RDS -------------------------------
# Save as RDS for downstream scripts to avoid re-loading repeatedly
saveRDS(df, "results/data_processed.rds")

cat("Data loaded successfully and saved as results/data_processed.rds\n")
