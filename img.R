getwd()

## ------------------------------------------ ##
#            Packages -----
## ------------------------------------------ ##

library(imager)
library(magick)

## ------------------------------------------ ##
#            PHOTO A scale bar -----
## ------------------------------------------ ##

# Load the image
imgA <- load.image("bongo.png")

plot(imgA)  # Display the image
points <- locator(2)  # Click on two points in the plot
#$x
#[1] 167.7828 167.7828

#$y
#[1]  45.01472 539.48392

# Calculate pixel distance
pixel_distance <- sqrt((points$x[2] - points$x[1])^2 + (points$y[2] - points$y[1])^2)
print(pixel_distance)


known_length_mm <- 203.2  # 8 inches converted to mm
known_length_cm <- known_length_mm / 10
pixel_to_length_ratio <- known_length_cm / pixel_distance
print(pixel_to_length_ratio)  # mm per pixel

#plot
# Load the image
img1 <- image_read("bongo.png")

# Get image dimensions
img_info <- image_info(img1)
img_width <- img_info$width
img_height <- img_info$height

# Define the desired scale bar length 
scale_bar_length_cm <- 2 
#scale_bar_length_mm <- scale_bar_length_cm * 10

# Add a scale bar
scale_length_px <- scale_bar_length_cm / pixel_to_length_ratio  # Pixel length for the scale bar
#scale_label <- "5 mm"  # Label for the scale bar
scale_label <- paste(scale_bar_length_cm, "cm")  # Label for the scale bar (in cm)

scale_bar_x <- img_width * 0.1 - 60  # X-coordinate for the start of the scale bar
scale_bar_y <- img_height - 50  # Y-coordinate for the start of the scale bar

# Add a scale bar to the image
img_with_scale <- image_draw(img1)

# Draw the scale bar as a filled rectangle (white color)
rect(scale_bar_x, scale_bar_y, 
     scale_bar_x + scale_length_px, scale_bar_y + 10,  # Size of the rectangle (length and height)
     col = "white",  # Color of the scale bar
     border = NA)  # No border for the rectangle

# Add a label above the scale bar (e.g., "5 mm")
text(scale_bar_x + scale_length_px / 2, scale_bar_y - 16, 
     labels = paste(scale_bar_length_cm, "cm"),  # Label the scale bar with the real-world size
     col = "white",  # Color of the text
     cex = 2.5)  # Text size

# Finalize drawing
dev.off() 

image_write(img_with_scale, "bongo_withAscale.png")

dev.off()

## ------------------------------------------ ##
#            PHOTO B scale bar -----
## ------------------------------------------ ##
rm(list = ls())

# Load the image
imgB <- load.image("bongo_withAscale.png")

plot(imgB)  # Display the image
points <- locator(2)  # Click on two points in the plot
#$x
#[1] 506.2505 500.6790

#$y
#[1] 146.6943 220.5165

# Calculate pixel distance
pixel_distance2 <- sqrt((points$x[2] - points$x[1])^2 + (points$y[2] - points$y[1])^2)
print(pixel_distance2)


known_length_cm <- 1  # size of a nail more or less; size you know in the photo
pixel_to_length_ratio <- known_length_cm / pixel_distance2
print(pixel_to_length_ratio)  # cm per pixel


#plot
# Load the image
img2 <- image_read("bongo_withAscale.png")

# Get image dimensions
img_info <- image_info(img2)
img_width <- img_info$width
img_height <- img_info$height

# Define the desired scale bar length in mm
scale_bar_length_cm <- 1

# Add a scale bar 
scale_length_px <- scale_bar_length_cm / pixel_to_length_ratio  # Pixel length for the scale bar
#scale_label <- "5 mm"  # Label for the scale bar
scale_label <- paste(scale_bar_length_cm, "cm")  # Label for the scale bar (in cm)

scale_bar_x <- img_width * 0.9  # X-coordinate for the start of the scale bar
scale_bar_y <- img_height * 0.5  # Y-coordinate for the start of the scale bar

# Add a scale bar to the image
img_with_scale <- image_draw(img2)

# Draw the scale bar as a filled rectangle
rect(scale_bar_x, scale_bar_y, 
     scale_bar_x + scale_length_px, scale_bar_y + 10,  # Size of the rectangle (length and height)
     col = "black",  # Color of the scale bar
     border = NA)  # No border for the rectangle

# Add a label above the scale bar
text(scale_bar_x + scale_length_px / 2, scale_bar_y - 16, 
     labels = paste(scale_bar_length_cm, "cm"),  # Label the scale bar with the real-world size
     col = "black",  # Color of the text
     cex = 1.8)  # Text size

# Finalize drawing
dev.off() 

image_write(img_with_scale, "bongo_withABscale.png")

dev.off()


## ------------------------------------------ ##
#            PHOTO C scale bar -----
## ------------------------------------------ ##
rm(list = ls())

# Load the image
imgC <- load.image("bongo_withABscale.png")

plot(imgC)  # Display the image
points <- locator(2)  # Click on two points in the plot- id say they are about 4cm
#$x
#[1] 546.6437 531.3222

#$y
#[1] 338.9105 499.0907

# Calculate pixel distance
pixel_distance2 <- sqrt((points$x[2] - points$x[1])^2 + (points$y[2] - points$y[1])^2)
print(pixel_distance2)


known_length_cm <- 4  # size of a nail more or less; size you know in the photo
pixel_to_length_ratio <- known_length_cm / pixel_distance2
print(pixel_to_length_ratio)  # cm per pixel



#plot
# Load the image
img3 <- image_read("bongo_withABscale.png")

# Get image dimensions
img_info <- image_info(img3)
img_width <- img_info$width
img_height <- img_info$height

# Define the desired scale bar length in mm
scale_bar_length_cm <- 1

# Add a scale bar 
scale_length_px <- scale_bar_length_cm / pixel_to_length_ratio  # Pixel length for the scale bar
#scale_label <- "5 mm"  # Label for the scale bar
scale_label <- paste(scale_bar_length_cm, "cm")  # Label for the scale bar (in cm)

scale_bar_x <- img_width * 0.9  # X-coordinate for the start of the scale bar
scale_bar_y <- img_height * 0.95  # Y-coordinate for the start of the scale bar

# Add a scale bar to the image
img_with_scale <- image_draw(img3)

# Draw the scale bar as a filled rectangle
rect(scale_bar_x, scale_bar_y, 
     scale_bar_x + scale_length_px, scale_bar_y + 10,  # Size of the rectangle (length and height)
     col = "black",  # Color of the scale bar
     border = NA)  # No border for the rectangle

# Add a label above the scale bar
text(scale_bar_x + scale_length_px / 2, scale_bar_y - 16, 
     labels = paste(scale_bar_length_cm, "cm"),  # Label the scale bar with the real-world size
     col = "black",  # Color of the text
     cex = 1.8)  # Text size

# Finalize drawing
dev.off() 

image_write(img_with_scale, "bongo_withABCscale.png")

dev.off()