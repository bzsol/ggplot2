# Second task - Zsolt Berecz
# Install the required packages
if (!require(ggplot2)) {
  install.packages("ggplot2")
  library(ggplot2)
}

# Load the mtcars dataset, it's the same as in the first task
data(mtcars)

# I want to calculate the Z-score, the R creates a new column, mpg_zscore in the dataframe
# I've used scale(), in R it standardize the value of the mpg (coloumn of the mtcars)
mtcars$mpg_zscore <- scale(mtcars$mpg)

# I created again a dataframe, but that's actually for the plotting, we don't need all the data from mtcars
# for the plot, just the Car names and the Z-score is needed. 
plot_data <- data.frame(
  Car = rownames(mtcars),
  Zscore = as.vector(mtcars$mpg_zscore)
)

# For the plotting, it is needed to order the scores by Z-score
plot_data <- plot_data[order(plot_data$Zscore), ]

# I created ggplot2 bar plot, as we can see it uses the plot_data dataframe at first, after the aas() aesthetic values coming
# The X values is set to the Cars variable reordered by the zscore but in descending order
# the y value set to the zscore and the fill value also.
# geom_col(width = 0.7) that means the bar plot how thick.
# coord_flip() that is important for flipping the x and y coordinates 
# the labs() for the labels, the x is the car names, the y is the z-score 
# I added the minimalistic theme to that
# The task was to create a gradient for two colors, one is the starting the low is darkblue and the high value is gold
# It depends on the zcore value. 
# For me the trickiest part was the breaks, argument sets the breakpoints for the legend, so in this case high and low
# After that, I added the labels for that two points. The two points is the min and the max value of the zscore

plot <- ggplot(
  plot_data,
  aes(
    x = reorder(Car, -Zscore),
    y = Zscore, fill = Zscore
  )
) +
  geom_col(width = 0.7) +
  coord_flip() +
  labs(
    title = "Plot 2.",
    x = "Car Name",
    y = "Z-Score",
    fill = "MPG group"
  ) +
  theme_minimal() +
  scale_fill_gradient2(
    low = "darkblue", high = "gold", guide = "legend",
    breaks = c(min(plot_data$Zscore), max(plot_data$Zscore)),
    labels = c("Low", "High")
  )

# Save the plot to a pdf file, for me 15cm width and high was the best choice to recreate the plot.
ggsave("second_plot.pdf", plot, width = 15, height = 15, units = "cm")
