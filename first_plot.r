# First task - Zsolt Berecz
# Install the required packages
if (!require(ggplot2)) {
  install.packages("ggplot2")
  library(ggplot2)
}

# Load the mtcars dataset, that we use for the first task
data(mtcars)

# I created a dataframe that stores,
# the car name (rowname), the cylinder of the car, and the Miles per gallon
dframe <- data.frame(
  Car = rownames(mtcars),
  Cyl = mtcars$cyl,
  Mpg = mtcars$mpg
)

# To make it more easier and understandable,I created 3 subsets from the dataframe
# The 4,6 and 8 cylinder motors.
cyl_4 <- subset(dframe, Cyl == 4)

cyl_6 <- subset(dframe, Cyl == 6)

cyl_8 <- subset(dframe, Cyl == 8)


# the ggplot has 3 geom_bar, with that we can merge all the bar plots just in one plot, it uses the 3 subsets
# without sorting them with using the mpg value (that was a problem for me at first how to separate it)
# The geom bars using the subsets, aesthetic mappings are the x value are the Mpg but the y we reorder the factors Car with the -Mpg
# With that I got the exact order of the (sub)bar plot
# the fill value are for the colors.
# stat identity is really important that means the height of the bars should represent the actual values for the x and y
# Th width 0.7 makes the bars more slim and much more readable
# at the labs() we give some labels to show what the x and the colors represent. 
# In this task the y value is nothing, not show what is that
# The scale_fill_manual used for making own scale for the cylinders, so I can provide the color scale that was stated in the task.
# I've used  theme_minimal() because the ink/data ratio is better and the task also showed the same.
# At the end I gave a label, this is placed to the top of the plot.
plot <- ggplot() +
  geom_bar(
    data = cyl_4,
    aes(
      x = Mpg,
      y = reorder(Car, -Mpg),
      fill = "4"
    ),
    stat = "identity",
    width = 0.7
  ) +
  geom_bar(
    data = cyl_6,
    aes(
      x = Mpg,
      y = reorder(Car, -Mpg),
      fill = "6"
    ),
    stat = "identity",
    width = 0.7
  ) +
  geom_bar(
    data = cyl_8,
    aes(
      x = Mpg,
      y = reorder(Car, -Mpg),
      fill = "8"
    ),
    stat = "identity",
    width = 0.7
  ) +
  labs(
    title = "Plot 1.",
    x = "Miles Per Gallon",
    y = "",
    fill = "Cylinder Count"
  ) +
  scale_fill_manual(
    values = c(
      "4" = "skyblue",
      "6" = "darkblue",
      "8" = "lightgreen"
    )
  ) +
  theme_minimal() +
  theme(legend.position = "top")

# the ggsave command provides that we can save the plot to a pdf file, I tested out the 13cm width and 15cm height is similar to what the task use.
# It is important to give a white background, because if that does not happen, we get a transparent background
ggsave("first_plot.pdf",
  plot,
  width = 13,
  height = 15, units = "cm", bg = "white"
)
