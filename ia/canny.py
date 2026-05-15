# =========================================================
# CANNY EDGE DETECTION
# =========================================================

import cv2
import matplotlib.pyplot as plt

# ---------------------------------------------------------
# Load image from folder
# OpenCV loads image in BGR format
# ---------------------------------------------------------
img = cv2.imread("Painted_Bunting_0102_16642.jpg")

# ---------------------------------------------------------
# Convert image to grayscale
# Edge detection mainly works on intensity changes
# ---------------------------------------------------------
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

# =========================================================
# STEP 1 : NOISE REDUCTION
# =========================================================
# Apply Gaussian Blur to remove small noise
# (5,5) = kernel size
# 0 = automatically calculate sigma
# ---------------------------------------------------------
blur = cv2.GaussianBlur(gray, (5,5), 0)

# =========================================================
# STEP 2 : GRADIENT CALCULATION
# =========================================================
# Canny internally uses Sobel operator
# to calculate intensity changes in x and y directions
#
# Gradient Magnitude:
# G = sqrt(Gx² + Gy²)
#
# Large gradient = strong edge
# ---------------------------------------------------------

# =========================================================
# STEP 3 : NON-MAXIMUM SUPPRESSION
# =========================================================
# Thick edges are converted into thin edges
#
# Only strongest edge pixels are kept
# Neighbor weak pixels are suppressed
# ---------------------------------------------------------

# =========================================================
# STEP 4 : DOUBLE THRESHOLDING
# =========================================================
# Two threshold values are used:
#
# lower threshold = 100
# upper threshold = 200
#
# Pixel Classification:
# Gradient > 200        -> Strong Edge
# 100 < Gradient < 200 -> Weak Edge
# Gradient < 100       -> Remove
# ---------------------------------------------------------

# =========================================================
# STEP 5 : EDGE TRACKING BY HYSTERESIS
# =========================================================
# Weak edges connected to strong edges are kept
# Isolated weak edges are removed
# ---------------------------------------------------------

# Perform Canny Edge Detection
canny = cv2.Canny(blur, 50, 100)

# =========================================================
# DISPLAY RESULTS
# =========================================================

plt.figure(figsize=(10,5))

# Original Image
plt.subplot(1,2,1)

# Convert BGR -> RGB for matplotlib display
plt.imshow(cv2.cvtColor(img, cv2.COLOR_BGR2RGB))

plt.title("Original Image")
plt.axis("off")

# Canny Edge Output
plt.subplot(1,2,2)

# Display edge image in grayscale
plt.imshow(canny, cmap='gray')

plt.title("Canny Edge Detection")
plt.axis("off")

plt.tight_layout()
plt.show()