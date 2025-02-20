# Wardrobe

This project aims to create an application that allows users to obtain their body measurements from a photograph using Google MediaPipe and then generate a 3D model of themselves from these measurements. In the final vision, the app will also enable a virtual try-on experience by allowing users to capture an image of clothing, which will then be virtually fitted to their 3D model. 

**Note:** Currently, the implementation is complete only up to the "get measurements" stage using Google MediaPose.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Running the Application](#running-the-application)
- [Project Structure](#project-structure)
- [Future Work](#future-work)
- [License](#license)
- [Acknowledgements](#acknowledgements)

## Overview

The goal of this application is twofold:
1. **Body Measurement Extraction:**  
   Users can upload or capture a photo, and the app will extract key body measurements using Google MediaPipe.
2. **3D Model & Virtual Try-On (Future Implementation):**  
   Using the extracted measurements, a 3D model of the user will be generated. Later, users will be able to take a picture of clothing items and virtually try them on their model.

*Current implementation is focused on the measurement extraction part.*

## Features

- **Body Measurement Extraction:**  
  - Utilizes Google MediaPipe to process a user-supplied image.
  - Extracts key body dimensions needed for 3D modeling.

- **Planned Features (Future Work):**  
  - 3D Model Generation from the extracted measurements.
  - Virtual Try-On of clothing items by overlaying them on the generated 3D model.

## Getting Started

### Prerequisites

- A suitable development environment (e.g., Flutter, if building a mobile app)
- Google MediaPose (or MediaPipe) configuration and credentials
- Basic knowledge of Dart/Flutter (or your chosen framework/language)

### Installation

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/your-username/3d-virtual-try-on.git
   cd 3d-virtual-try-on
   ```

2. **Install Dependencies**
   ```bash
   flutter clean
   flutter pub get
   flutter analyze
   flutter doctor
   ```
   - If no issues show up, move to the next step.
   - If any issues show up with `flutter doctor` follow the recommended steps.
   - If issues show up with `flutter analyze`, run:
     ```bash
     dart fix --apply
     ```
     or follow any recommended fixes.

### Running the Application
 **Launch the Application**
   ```bash
   flutter run
   ```

### Project Structure

### Future Work
- 3D Model Generation:
Develop or integrate an engine that generates a 3D model using the extracted measurements.

- Virtual Try-On:
Allow users to capture images of clothing and virtually overlay them on their 3D model.

- Enhanced UI/UX:
Improve the interface and user flow for a seamless virtual try-on experience.

### License
Copyright [2024] [I.V.Y: Wardrobe]

All rights reserved.

This software and its source code are proprietary and confidential. Unauthorized copying, distribution, or modification of this software is strictly prohibited without express permission from the author.

### Acknowledgements
Google MediaPipe for the MediaPose solution.
