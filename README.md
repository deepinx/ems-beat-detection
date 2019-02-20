# EMS Beat Detection

This repository contains the Matlab implementation of paper `An adaptive real-time beat detection method for continuous pressure signals`  at [Springer](https://link.springer.com/article/10.1007/s10877-015-9770-z). You can download the full-text of this paper at [ResearchGate](https://www.researchgate.net/publication/281713164_An_adaptive_real-time_beat_detection_method_for_continuous_pressure_signals).


## Introduction

A novel adaptive real-time beat detection method for pressure related signals is proposed by virtue of an enhanced mean shift (EMS) algorithm. This EMS method consists of three components: spectral estimates of the heart rate, enhanced mean shift algorithm and classification logic. The Welch power spectral density method is employed to estimate the heart rate. An enhanced mean shift algorithm is then applied to improve the morphologic features of the blood pressure signals and detect the maxima of the blood pressure signals effectively. Finally, according to estimated heart rate, the classification logic is established to detect the locations of misdetections and over detections within the accepted heart rate limits. The parameters of the algorithm are adaptively tuned for ensuring its robustness in various heart rate conditions. The performance of the EMS method is validated with expert annotations of two standard databases and a non-invasive dataset. The results from this method show that the sensitivity (Se) and positive predictivity (+P) are significantly improved (i.e., Se > 99.45 %, +P > 98.28 %, and p value 0.0474) by comparison with the existing scheme from the previously published literature.


## Requirements

Please install Matlab 2015a or later versions of Matlab.

## Usage

You can easily start it by running ``main.m`` in your Matlab.

## Results
ABP signal with baseline wander and the peaks identified by the EMS method along with two experts (LJ and XR)
![enter image description here](https://raw.githubusercontent.com/deepinx/ems-beat-detection/master/Fig/ABP.png)

ICP signal and the peaks identified by the EMS method and the HBF method
![enter image description here](https://github.com/deepinx/ems-beat-detection/blob/master/Fig/ICP.png?raw=true)

Continuous non-invasive blood pressure signal with rapid changes and the peaks identified by the EMS method
![enter image description here](https://github.com/deepinx/ems-beat-detection/blob/master/Fig/Non-invasive-BP.png?raw=true)


## License
MIT LICENSE

## Citation

If you find this repository useful in your research, please consider to cite the following related papers:

```
@article{Liu2016An,
  title={An adaptive real-time beat detection method for continuous pressure signals},
  author={Liu, Xiaochang and Wang, Gaofeng and Liu, Jia},
  journal={Journal of Clinical Monitoring & Computing},
  volume={30},
  number={5},
  pages={715-725},
  year={2016},
}
```
