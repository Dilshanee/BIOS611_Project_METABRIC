# METABRIC Gene Expression and Survival Data Analysis

This project presents an integrative analysis of the METABRIC breast cancer dataset, focusing on RNA sequencing, mutation data, and clinical outcomes.  
The goal is to explore how tumor gene expression patterns relate to patient survival and other clinical features.

## Overview

The METABRIC (Molecular Taxonomy of Breast Cancer International Consortium) dataset is a large, well-characterized breast cancer cohort containing genomic, transcriptomic, and clinical information for 1,904 patients.  

This project uses the subset containing:  
- 31 clinical variables  
- 489 gene-expression variables  
- 173 mutation-status variables  

The dataset was downloaded from [Kaggle](https://www.kaggle.com/datasets/raghadalharbi/breast-cancer-gene-expression-profiles-metabric) and the downloaded data file (`METABRIC_RNA_Mutation.csv`) is in the folder `data/`.  

The main objective is to determine whether clusters derived from tumor gene expression profiles can help explain observed survival differences among patients.

## Project Structure

```markdown

project/
├─ data/
│  └─ METABRIC_RNA_Mutation.csv  # Mutation and RNA expression data
├─ report.Rmd                    # Main RMarkdown report
├─ style.css                     # CSS file for HTML report formatting
├─ Makefile                      # Automates data processing, figure generation, and report rendering
├─ results/
│  ├─ report.html                # Generated HTML report
│  └─ figures/                   # All generated figures
│     ├─ age_distribution.png
│     ├─ survival_clusters.png
│     ├─ top50_genes_heatmap.png
│     ├─ tumor_stage_distribution.png
│     ├─ mutation_profile.png
│     └─ ... (additional figures generated during analysis)
├─ scripts/                      # R scripts for data processing and plotting
│  ├─ preprocess_data.R
│  ├─ pca_clustering.R
│  ├─ survival_analysis.R
│  ├─ variable_gene_analysis.R
│  └─ tumor_stage_mutation.R

````

## Quick Start

1. Clone the repository:

```bash
git clone https://github.com/Dilshanee/BIOS611-Project.git
cd BIOS611-Project
````

2. Ensure R and required packages are installed: `ggplot2`, `tidyverse`, `knitr`, `rmarkdown`.

3. Run the Makefile to generate all data, figures, and the HTML report:

```bash
make all
```

4. Open the generated HTML report:

```bash
results/report.html
```

## Methods

* **Data preprocessing**: Load METABRIC RNA and mutation data, clean and merge variables.
* **PCA and clustering**: Dimensionality reduction with Principal Component Analysis (PCA), followed by k-means clustering. Cluster number chosen using Elbow and Gap Statistics.
* **Survival analysis**: Kaplan-Meier curves to assess survival differences across clusters.
* **Variable gene analysis**: Top 50 variable genes visualized in a heatmap.
* **Tumor stage and mutation profiling**: Explore associations with survival differences.

## Key Findings

* Four patient clusters were identified based on RNA expression.
* Cluster 2 shows improved overall survival.
* Lower expression of **MYC** and **JAK1** in cluster 2 may partially explain better outcomes.
* **TP53** and **PIK3CA** mutations are more prevalent in clusters with poorer survival.
* Tumor stage distribution alone does not explain survival differences.

## Conclusions

These findings suggest that molecular heterogeneity, reflected in gene expression and mutation profiles, may contribute to observed survival differences in breast cancer patients.
Integrative analysis of RNA expression and mutation data can provide valuable insights into mechanisms underlying prognosis.

## Selected References

* MYC and breast cancer: PMID 22028330
* JAK1 and metastasis: PMID 23722119
* TP53 mutations and prognosis: PMID 20173069
* PIK3CA mutations and therapy response: PMID 26276827

**Dataset References**:

* METABRIC dataset: [Kaggle link](https://www.kaggle.com/datasets/raghadalharbi/breast-cancer-gene-expression-profiles-metabric)
* Curtis C. et al., *Nature*, 2012, PMID: 22495301
* Pereira B. et al., *Nature Communications*, 2016, PMID: 27097314

*This project is for educational and research purposes. The METABRIC dataset is publicly available for research, and appropriate citations should be used if reproducing analyses.*
