# Load the data
df <- read.csv("USA_Stories.csv")

# Take a look at the first few rows of the dataset to understand its structure
View(df)

# Load necessary libraries
install.packages("tidyverse")  # If tidyverse isn't installed yet
library(tidyverse)

# Check data types of each column to understand the structure of the dataset
str(df)

# Check for missing values in the dataset
colSums(is.na(df))

# Drop rows with missing values to clean the dataset
df <- na.omit(df)

# Verify that missing values have been removed
colSums(is.na(df))

# Check for duplicates in the dataset (rows with duplicate 'Film' names)
dim(df[duplicated(df$Film),])[1]

# Round numeric columns to 2 decimal places for easier readability
df$Profitability <- round(df$Profitability, digits = 2)
df$Worldwide.Gross <- round(df$Worldwide.Gross, digits = 2)

# View the updated dimensions of the dataset
dim(df)

# Load ggplot2 for data visualization (boxplot and scatterplot)
install.packages("ggplot2")  # If ggplot2 isn't installed yet
library(ggplot2)

# ------------------------------
# OUTLIER DETECTION AND REMOVAL
# ------------------------------

# Visualize outliers using a boxplot for Profitability vs Worldwide Gross
ggplot(df, aes(x = Profitability, y = Worldwide.Gross)) +
  geom_boxplot(outlier.colour = "red", outlier.shape = 1) +  # Highlight outliers in red
  scale_x_continuous(labels = scales::comma) +  # Format x-axis with commas
  coord_cartesian(ylim = c(0, 1000))  # Set y-axis limit for better visibility

# Remove outliers in 'Profitability' column using IQR (Interquartile Range)
Q1 <- quantile(df$Profitability, 0.25)
Q3 <- quantile(df$Profitability, 0.75)
IQR <- IQR(df$Profitability)
no_outliers <- subset(df, df$Profitability > (Q1 - 1.5 * IQR) & df$Profitability < (Q3 + 1.5 * IQR))

# Check dimensions after removing 'Profitability' outliers
dim(no_outliers)

# Remove outliers in 'Worldwide.Gross' column using IQR
Q1 <- quantile(no_outliers$Worldwide.Gross, 0.25)
Q3 <- quantile(no_outliers$Worldwide.Gross, 0.75)
IQR <- IQR(no_outliers$Worldwide.Gross)
df1 <- subset(no_outliers, no_outliers$Worldwide.Gross > (Q1 - 1.5 * IQR) & no_outliers$Worldwide.Gross < (Q3 + 1.5 * IQR))

# Check dimensions after removing 'Worldwide.Gross' outliers
dim(df1)

# ------------------------------
# EXPLORATORY DATA ANALYSIS (EDA)
# ------------------------------

# Summary Statistics/Univariate Analysis
summary(df1)

# Visualizing distribution of 'Profitability' (Histogram)
ggplot(df1, aes(x = Profitability)) +
  geom_histogram(binwidth = 1, fill = "skyblue", color = "black", alpha = 0.7) + 
  labs(title = "Distribution of Profitability", x = "Profitability", y = "Frequency") +
  theme_minimal()

# Visualizing distribution of 'Worldwide.Gross' (Histogram)
ggplot(df1, aes(x = Worldwide.Gross)) +
  geom_histogram(binwidth = 20, fill = "lightgreen", color = "black", alpha = 0.7) + 
  labs(title = "Distribution of Worldwide Gross", x = "Worldwide Gross", y = "Frequency") +
  scale_x_continuous(labels = scales::comma) +  # Format x-axis with commas
  theme_minimal()

# ------------------------------
# BIVARIATE ANALYSIS
# ------------------------------

# Scatterplot: Lead Studio vs Rotten Tomatoes (with color based on 'Genre')
ggplot(df1, aes(x = Lead.Studio, y = Rotten.Tomatoes.., color = Genre)) + 
  geom_point(size = 3, alpha = 0.7) +  # Scatterplot points with color by genre
  labs(title = "Lead Studio vs Rotten Tomatoes Score by Genre", 
       x = "Lead Studio", y = "Rotten Tomatoes Score") +
  scale_y_continuous(labels = scales::comma) +  # Format y-axis with commas
  theme(axis.text.x = element_text(angle = 90)) +  # Rotate x-axis labels for better readability
  theme_minimal()

# Bar chart: Count of films by genre
ggplot(df1, aes(x = Genre)) + 
  geom_bar(fill = "dodgerblue", color = "black", alpha = 0.7) +
  labs(title = "Number of Films by Genre", x = "Genre", y = "Count of Films") +
  theme_minimal()

# Bar chart: Count of films by Year (distribution across time)
ggplot(df1, aes(x = Year)) + 
  geom_bar(fill = "orange", color = "black", alpha = 0.7) +
  labs(title = "Number of Films by Year", x = "Year", y = "Count of Films") +
  theme_minimal()

# Boxplot: Worldwide Gross by Genre
ggplot(df1, aes(x = Genre, y = Worldwide.Gross, fill = Genre)) +
  geom_boxplot(outlier.colour = "red", outlier.shape = 1) +
  scale_y_continuous(labels = scales::comma) +  # Format y-axis with commas
  labs(title = "Worldwide Gross by Genre", x = "Genre", y = "Worldwide Gross") +
  theme_minimal()

# ------------------------------
# CORRELATION ANALYSIS
# ------------------------------

# Correlation heatmap for numeric variables
numeric_cols <- df1 %>% select(Profitability, Worldwide.Gross, Rotten.Tomatoes..)  # Select numeric columns for correlation
cor_matrix <- cor(numeric_cols)  # Calculate correlation matrix

# Plotting the correlation matrix as a heatmap
install.packages("corrplot")  # If corrplot isn't installed yet
library(corrplot)
corrplot(cor_matrix, method = "circle", type = "upper", order = "hclust", tl.col = "black", tl.srt = 45)

# ------------------------------
# ADVANCED VISUALIZATIONS
# ------------------------------

# Pair plot (scatterplot matrix) to visualize relationships between numerical variables
install.packages("GGally")  # If GGally isn't installed yet
library(GGally)
ggpairs(df1 %>% select(Profitability, Worldwide.Gross, Rotten.Tomatoes..), 
        title = "Pair Plot of Numeric Variables")

# ------------------------------
# EXPORTING CLEANED DATA
# ------------------------------

# Export the cleaned dataset to a new CSV file for further analysis
write.csv(df1, "USA_Stories_Cleaned.csv")

