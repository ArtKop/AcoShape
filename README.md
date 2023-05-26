# Programmable assembly of particles on a Chladni plate
Artur Kopitca, Kourosh Latifi, Quan Zhou, Science Advances 2021, doi: [10.1126/sciadv.abi7716](https://www.science.org/doi/pdf/10.1126/sciadv.abi7716)

If you find this code useful, please consider citing:
```
@article{kopitca2021programmable,
  title={Programmable assembly of particles on a Chladni plate},
  author={Kopitca, Artur and Latifi, Kourosh and Zhou, Quan},
  journal={Science advances},
  volume={7},
  number={39},
  pages={eabi7716},
  year={2021},
  publisher={American Association for the Advancement of Science}
}
```
## Concept

<img src="extra/Concept.png" width="283" height="212" /> 

The paper proposes the particle assembly method applied to a Chladni plate. The method includes:
1. Training neural networks (NNs) predicting the likely particle displacement on the plate as follows,
```math
E_{n}(\mathbf{p}) = \mathbf{p} + u_n(\mathbf{p}),
```
where $u_n$ is an NN, $n$ is the index of vibration frequency (1-30 kHz), and $\mathbf{p}$ is the particle position on the plate.

2. Solving the problem of aligning two sets of points, particles and shape-defining targets,
```math
\arg \min_{\mathbf{R},\mathbf{v},n} \frac{1}{N}\sum\limits_{i=1}^N \lVert \mathbf{R} \mathbf{t}_i + \mathbf{v} - E_{n}(\mathbf{p}_i) \rVert^2 ,
```
where $\mathbf{R}$ is a rotation matrix, $\mathbf{t}$ is a shape-defining target, $\mathbf{v}$ is a translation vector, and $N$ is the number of particles and targets.

The proposed assembly algorithm iteratively minimizes the above-stated objective function by applying a combination of optimization techniques and model-predictive control.

## Results
All results can be found in Supplementary Materials of the paper.

**Experiment** | **Simulation**
------ | ------
<img src="Extra/Experiment.gif" width="390" height="250"  /> | <img src="Extra/Simulation.gif" width="300" height="250"  /> 




