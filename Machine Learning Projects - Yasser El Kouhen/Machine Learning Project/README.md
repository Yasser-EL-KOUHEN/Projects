# Machine Learning Classification Project

## Overview

This project explores **classification techniques** using **machine learning** on the **MIT-BIH Arrhythmia database**, which contains **10,000 electrocardiograms (ECG)**. Each ECG consists of **180 time samples** and corresponds to one of **five possible labels**:

1. **'A'**: Atrial premature beat
2. **'L'**: Left bundle branch block beat
3. **'N'**: Normal beat
4. **'R'**: Right bundle branch block beat
5. **'V'**: Premature ventricular contraction

The project consists of two main parts:
- **Unsupervised Learning**: Principal Component Analysis (PCA) and Clustering (K-Means)
- **Supervised Learning**: Logistic Regression, Naive Bayes, and Support Vector Machine (SVM)

## Dataset

The dataset is stored in **NumPy arrays**:

- **X_tp1.npy**: A `(10000, 180)` NumPy matrix containing ECG signals.
- **Y_tp1.npy**: A `(10000,)` NumPy vector with corresponding labels (`'A'`, `'L'`, `'N'`, `'R'`, `'V'`).

### Data Preprocessing
- Normalization using `StandardScaler()`
- Label encoding using `LabelEncoder()`
- Splitting data into training and testing sets (`train_test_split`)

## Unsupervised Learning

### Principal Component Analysis (PCA)
- **Dimensionality reduction**: PCA was applied to reduce **180** dimensions to a lower number while retaining **95% of variance**.
- **Visualization**: Cumulative explained variance plot.
- **Reconstruction**: Compared original ECG signals with their PCA-reconstructed versions.

### K-Means Clustering
- K-Means was applied with `K=5` (cheating, since we know the actual number of labels).
- Performance was evaluated using:
  - **Homogeneity**: Do clusters contain samples from the same class?
  - **Completeness**: Are all samples of the same class grouped together?
  - **V-Measure**: The harmonic mean of homogeneity and completeness.

## Supervised Learning

### Models Implemented:
1. **Logistic Regression**
   - A simple linear model with `max_iter=10000`
   - Achieved **82.9% accuracy** on the test set.
   - Moderate confusion in overlapping classes.

2. **Gaussian Naive Bayes**
   - Based on the assumption of feature independence.
   - Performed poorly with **55.1% accuracy** due to unrealistic Gaussian assumptions.

3. **Support Vector Machine (SVM)**
   - Two kernels were tested:
     - **RBF kernel**: Best performance with **91.8% accuracy**.
     - **Linear kernel**: Slightly worse with **87.6% accuracy**.
   - The **RBF kernel** effectively captured nonlinear relationships.

4. **Decision Tree (Bonus)**
   - **100% training accuracy**, but **87.67% test accuracy**, indicating **overfitting**.

## Key Findings

- **PCA successfully reduced dimensionality**, but classification still required the full feature set.
- **K-Means clustering did not perform well** due to overlapping classes.
- **SVM with RBF kernel was the best classifier**, showing the best generalization performance.
- **Decision Tree overfitted**, making it unreliable for real-world predictions.

## How to Run the Project

### 1. Setup Environment

Make sure you have the required dependencies installed:

```bash
pip install numpy scikit-learn matplotlib
