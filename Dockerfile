# Use rocker/verse (R + tidyverse + LaTeX for PDF)
FROM rocker/verse:latest

# Install system dependencies for compiling Bioconductor packages
RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    libfontconfig1-dev \
    && rm -rf /var/lib/apt/lists/*

# Install CRAN packages
RUN R -e "install.packages(c( \
    'tidyverse', \
    'survival', \
    'survminer', \
    'cluster', \
    'factoextra', \
    'ggplot2', \
    'scales', \
    'RColorBrewer', \
    'gridExtra', \
    'rmarkdown' \
))"

# Install Bioconductor + ComplexHeatmap + circlize
RUN R -e "if (!require('BiocManager')) install.packages('BiocManager')"
RUN R -e "BiocManager::install('ComplexHeatmap', ask = FALSE)"
RUN R -e "BiocManager::install('circlize', ask = FALSE)"

# Set working directory
WORKDIR /home/rstudio/project

# Copy project files into the container
COPY . /home/rstudio/project
