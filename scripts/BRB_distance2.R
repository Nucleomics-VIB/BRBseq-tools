library("stringdist")
library("ggplot2")
#library("dplyr")
#library("tidyr")
library("tidyverse")

barcodes <- read.csv("~/Downloads/Exp4632_barcodes.txt", sep="")

# methods: # c("osa", "lv", "dl", "hamming", "lcs", "qgram", "cosine", "jaccard", "jw", "soundex")
# names: # c("none", "strings", "names")

Mat <- stringdistmatrix(
  barcodes$B1,
  barcodes$B1,
  method = "lv" ,
  useBytes = FALSE,
  weight = c(d = 1, i = 1, s = 1, t = 1),
  q = 1,
  p = 0,
  bt = 0,
  useNames = "none" ,
  nthread = getOption("sd_num_thread")
)

dim(Mat)

rownames(Mat) <- barcodes$Name
colnames(Mat) <- barcodes$Name

# Convert the matrix to a data frame
Mat_df <- as.data.frame(Mat)

dt2 <- Mat_df %>%
  rownames_to_column() %>%
  gather(colname, value, -rowname)

# Filter only the lower triangular elements (including the diagonal)
upper_triangular_values <- dt2 %>%
  filter(rowname <= colname)

# Create the heatmap for the lower triangular elements
png("distance_gradient_plot.png")
ggplot(upper_triangular_values, aes(x = rowname, y = colname, fill = value)) +
  geom_tile() +
  scale_fill_gradient(low = "red", high = "white") +
  theme_minimal() +
  labs(title = "Lower Triangular Elements Heatmap", x = "Columns", y = "Rows")
null <- dev.off()

png("distance_gradient_plot_mid5.png")
ggplot(upper_triangular_values, aes(x = rowname, y = colname, fill = value)) +
  geom_tile() +
  scale_fill_gradient2(low = "darkred", mid = "darkred", high = "white", midpoint = 5) +
  theme_minimal() +
  labs(title = "Lower Triangular Elements Heatmap", x = "Columns", y = "Rows")
null <- dev.off()

# Create a new categorical variable based on smallest non-null distance
lim <- min(dt2[dt2$value>0,"value"])
upper_triangular_values$lv_distance <- ifelse(upper_triangular_values$value <= lim, paste0("up_to_", lim, sep=''), "more")

# Plot using the modified data
png("distance_gradient_plot_auto.png")
ggplot(upper_triangular_values, aes(x = rowname, y = colname, fill = lv_distance)) +
  geom_tile() +
  scale_fill_manual(values = c("white", "black")) +
  theme_minimal() +
  labs(title = "Lower Triangular Elements Heatmap", x = "Columns", y = "Rows")
null <- dev.off()
