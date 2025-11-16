# Lab 9 – Image Processing & Segmentation (Without AI)

**Student:** Mahfuzur Rahaman  
**Course:** Image Processing Laboratory  
**Project:** Tire Stud Detection Using Classical Image Processing    

---

## 📌 Objective
This project implements a **non-AI image processing pipeline** that automatically determines whether a tire is **studded** or **non-studded**. The detection is based on grayscale preprocessing, thresholding, morphology, and connected-component analysis.

---

## 📂 Project Contents
| File | Description |
|------|-------------|
| `tire_stud_detector.m` | Main MATLAB script performing stud detection |
| `studded_tire.jpeg` | Sample image of a studded tire |
| `summer_tire.jpg` | Sample image of a non-studded tire |
| `README.md` | Project documentation |

---

## 🔧 Method Overview
The detection algorithm follows these steps:

1. **Read & Resize Images**  
2. **Convert to Grayscale**
3. **Tire Region Masking**  
   - Threshold dark intensities  
   - Fill holes, clean noise  
   - Keep largest connected component  
4. **Stud Candidate Detection**  
   - Threshold bright pixels  
   - Multiply with tire mask  
   - Optional smoothing and noise removal  
5. **Connected Component Analysis**  
   - Measure area, circularity, eccentricity  
   - Filter valid stud-like components  
6. **Classification Rule**  
   - `studCount > 10` → **Studded Tire**  
   - Else → **Non-Studded Tire**  
7. **Visualization**
   - Original image  
   - Binary stud candidate mask  
   - Overlay of detected studs with boundaries

---

## ▶️ How to Run
Open MATLAB and run:

```matlab
tire_stud_detector
