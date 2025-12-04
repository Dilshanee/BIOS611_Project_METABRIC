.PHONY: all clean

# =====================================================================
# MAIN TARGET — Build everything
# =====================================================================

all: results/data_processed.rds \
     results/figures/age_distribution.png \
     results/figures/overall_survival_distribution.png \
     results/figures/tumor_stage_distribution.png \
     results/figures/treatment_type_distribution.png \
     results/pca_scores.rds \
     results/figures/pca_clusters.png \
     results/figures/scree_plot.png \
     results/figures/elbow_method.png \
     results/figures/gap_statistic.png \
     results/figures/survival_clusters.png \
     results/figures/variable_genes_heatmap.png \
     results/figures/tumor_stage_by_cluster.png \
     results/figures/mutations_by_cluster.png \
     results/report.html

# =====================================================================
# Create results/figures directory
# =====================================================================

results/figures:
	mkdir -p results/figures

# =====================================================================
# 01 — Load & preprocess data
# =====================================================================

results/data_processed.rds: results/figures
	Rscript scripts/01_load_data.R

# =====================================================================
# 02 — Data overview plots
# =====================================================================

results/figures/age_distribution.png \
results/figures/overall_survival_distribution.png \
results/figures/tumor_stage_distribution.png \
results/figures/treatment_type_distribution.png: results/data_processed.rds results/figures
	Rscript scripts/02_data_overview.R

# =====================================================================
# 03 — PCA + K-means + cluster plots
# =====================================================================

results/pca_scores.rds: results/data_processed.rds results/figures
	Rscript scripts/03_pca_kmeans.R

# =====================================================================
# 04 — Survival analysis
# =====================================================================

results/figures/survival_clusters.png: results/pca_scores.rds results/figures
	Rscript scripts/04_survival.R

# =====================================================================
# 05 — Variable gene heatmap
# =====================================================================

results/figures/variable_genes_heatmap.png: results/pca_scores.rds results/figures
	Rscript scripts/05_variable_genes.R

# =====================================================================
# 06 — Tumor stage & mutation analysis
# =====================================================================

results/figures/tumor_stage_by_cluster.png \
results/figures/mutations_by_cluster.png: results/pca_scores.rds results/figures
	Rscript scripts/06_mutation_tumor_stage.R

# =====================================================================
# REPORT — Build HTML output
# =====================================================================

results/report.html: report.Rmd style.css \
                     results/figures/age_distribution.png \
                     results/figures/overall_survival_distribution.png \
                     results/figures/tumor_stage_distribution.png \
                     results/figures/treatment_type_distribution.png \
                     results/figures/pca_clusters.png \
                     results/figures/scree_plot.png \
                     results/figures/elbow_method.png \
                     results/figures/gap_statistic.png \
                     results/figures/survival_clusters.png \
                     results/figures/variable_genes_heatmap.png \
                     results/figures/tumor_stage_by_cluster.png \
                     results/figures/mutations_by_cluster.png
	Rscript -e "rmarkdown::render('report.Rmd', output_file='report.html', output_dir='results')"

# =====================================================================
# CLEAN
# =====================================================================

clean:
	rm -rf results/*.rds results/figures/*.png results/*.html


