# CIFAR-100 Image Classification with PyTorch

## Overview

This project focuses on training a **Convolutional Neural Network (CNN)** on the **CIFAR-100** dataset using **PyTorch**. The goal is to classify **100 different object categories** based on **32x32 RGB images**. The project also explores **ResNet architectures** for improved performance.

## Dataset

The **CIFAR-100 dataset** consists of:
- **50,000 training images**
- **10,000 test images**
- **100 classes** (each containing 600 images)

The dataset is automatically downloaded via `torchvision.datasets.CIFAR100`, and **data augmentation** is applied for better generalization.

### Data Preprocessing
- **Data Augmentation** (Training set):
  - Random cropping
  - Horizontal flipping
- **Normalization**:
  - Mean: `(0.5071, 0.4867, 0.4408)`
  - Standard Deviation: `(0.2675, 0.2565, 0.2761)`

## Model Architectures

### **1. Simple CNN Model**
A basic **3-layer CNN** is implemented with:
- **Convolutional layers** followed by **Batch Normalization** and **ReLU**
- **Max-pooling layers** for downsampling
- **Fully connected layers** for classification

### **2. ResNet Model**
A **ResNet-18 implementation** is provided with:
- **Basic residual blocks** for feature extraction
- **Skip connections** for better gradient flow
- **Global average pooling** before classification

## Training & Evaluation

### **Training Process**
- **Loss function**: `CrossEntropyLoss`
- **Optimizer**: `Adam` with `lr=0.001`
- **Batch size**: `10`
- **Number of epochs**: `10`
- **Training on GPU** if available

### **Performance Metrics**
- **Training & Test Loss**
- **Training & Test Accuracy**
- **Confusion Matrix for Evaluation**

### **Training Results**
| Epoch | Training Accuracy (%) | Test Accuracy (%) |
|--------|----------------------|-------------------|
| 1      | 10.47                | 12.15            |
| 2      | 12.94                | 14.35            |
| 3      | 14.71                | 15.47            |
| 4      | 16.05                | 16.99            |
| 5      | 17.47                | 17.64            |
| 6      | 18.25                | 18.87            |
| 7      | 19.48                | 20.72            |
| 8      | 20.97                | 21.16            |
| 9      | 21.61                | 22.52            |
| 10     | 22.75                | 22.86            |

Final test accuracy achieved: **22.01%**.

## How to Run the Project

### **1. Install Dependencies**
Make sure you have the required Python libraries installed:

```bash
pip install torch torchvision matplotlib numpy
