# CIFAR-4 Image Classification with TensorFlow

## Overview

This project focuses on training **deep learning models** to classify images into **four classes**: **Bird, Cat, Frog, and Horse** using **TensorFlow**. The dataset, a subset of **CIFAR-10**, is called **CIFAR-4** and contains **24,000 images**.

The project explores:
- **Multi-Layer Perceptron (MLP)**
- **Convolutional Neural Networks (CNN)**
- **Transfer Learning with ResNet**

## Dataset

### **CIFAR-4**
- **4 classes**: Bird, Cat, Frog, Horse
- **24,000 images** (RGB, 32x32 pixels)
- Each image is represented as a **[32,32,3] tensor** with pixel values in `[0,255]`.

### **Preprocessing**
- **Normalization**: Pixel values are scaled to `[0,1]`.
- **One-Hot Encoding**: Labels are transformed into categorical format.
- **Data Augmentation**: Applied to enhance generalization (rotation, flipping, shifting).

## Model Architectures

### **1. Multi-Layer Perceptron (MLP)**
A basic fully connected network:
- **Flatten input**: Converts 32x32 images into a **1D vector**.
- **Hidden layer**: `20 neurons` (tanh activation).
- **Output layer**: `4 neurons` (softmax activation).
- **Performance**:
  - **Train Accuracy**: ~59%
  - **Test Accuracy**: ~56%
- **Issues**: Limited performance due to loss of spatial structure.

### **2. Convolutional Neural Network (CNN)**
A deeper architecture for feature extraction:
- **Conv2D layers**: 32 and 64 filters.
- **MaxPooling**: Reduces spatial dimensions.
- **Flatten + Dense layers**: Classification stage.
- **Performance**:
  - **Train Accuracy**: ~82%
  - **Test Accuracy**: ~80%
- **Key Findings**: CNN significantly outperforms MLP by preserving spatial features.

### **3. Transfer Learning with ResNet**
Utilizing **ResNet-50** (pre-trained on ImageNet):
- **Frozen base layers**: Extract features.
- **Custom dense layers**: Fine-tuned for 4 classes.
- **Performance**:
  - **Train Accuracy**: ~98%
  - **Test Accuracy**: ~95%
- **Benefits**: Achieves high accuracy with fewer training epochs.

## Training & Evaluation

### **Training Process**
- **Loss function**: `Categorical Crossentropy`
- **Optimizers**: `Adam`
- **Batch size**: `100`
- **Epochs**:
  - **MLP**: `10`
  - **CNN**: `7`
  - **ResNet**: `7`
- **Metrics**: Accuracy on **train/test** sets.

### **Results Summary**
| Model | Train Accuracy (%) | Test Accuracy (%) |
|--------|------------------|------------------|
| MLP | 59% | 56% |
| CNN | 82% | 80% |
| ResNet (Transfer Learning) | 98% | 95% |

## How to Run the Project

### **1. Install Dependencies**
Ensure TensorFlow and necessary libraries are installed:

```bash
pip install tensorflow numpy matplotlib scikit-learn
