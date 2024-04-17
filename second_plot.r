# Load the required library
if (!require(ggplot2)) {
  install.packages("ggplot2")
  library(ggplot2)
}

# Load the mtcars dataset
data(mtcars)

# Calculate z-scores for mpg
mtcars$mpg_zscore <- (mtcars$mpg - mean(mtcars$mpg)) / sd(mtcars$mpg)

# Create a data frame with car names and their corresponding z-scores
df <- data.frame(car = row.names(mtcars), zscore = mtcars$mpg_zscore)

# Order the data frame by mpg scores in decreasing order
df_ordered <- df[order(df$zscore, decreasing = TRUE), ]

# Create a ggplot2 bar plot
plot <- ggplot(df_ordered, aes(x = car, y = zscore)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +  # Make the bars horizontal
  geom_hline(yintercept = 0, linetype = "dashed", color = "red") +  # Add a dashed line at zero
  theme_minimal() +
  labs(x = "Car", y = "Z-Score", title = "Ordered Z-Scores of MPG for Cars in mtcars Dataset")

# Print the plot
print(plot)

# Print the ordered data frame
print(df_ordered)
