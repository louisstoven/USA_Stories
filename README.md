# USA Stories Data Analysis

This repository contains the analysis of a dataset "USA_Stories.csv" with information about films, such as profitability, worldwide gross earnings, Rotten Tomatoes scores, and more. The analysis focuses on cleaning the data, removing outliers, and visualizing key insights using R.

## Installation

1. **Install R**: [Download R](https://cran.r-project.org/)
2. **Install Required Libraries**:
   ```r
   install.packages("tidyverse")
   install.packages("ggplot2")
   install.packages("corrplot")
   install.packages("GGally")

## Usage
Load the dataset (USA_Stories.csv).
Clean the data by removing missing values, duplicates, and outliers.
Perform exploratory data analysis (EDA) including:
Summary statistics
Visualizations (histograms, boxplots, scatterplots, etc.)
Correlation analysis
Export the cleaned data as .csv.

## Data Cleaning & Preprocessing
Remove Missing Values: Dropped rows with NA values.
Handle Duplicates: Removed duplicate rows based on the Film column.
Outlier Removal: Used IQR method to remove outliers in Profitability and Worldwide Gross.
Rounding Values: Rounded Profitability and Worldwide Gross to two decimal places.

## Exploratory Data Analysis (EDA)
Univariate Analysis: Distribution of Profitability and Worldwide Gross.
Bivariate Analysis: Scatterplots and bar charts for key variable relationships.
Correlation Heatmap: Visualized correlations between numeric variables.

## Exports
The final cleaned dataset is exported as .csv.
