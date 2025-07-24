# Wildlife-vehicle collisions in range-resident organisms as reaction-diffusion processes.
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![arXiv](https://img.shields.io/badge/arXiv-2507.17058-b31b1b)](https://arxiv.org/abs/2507.17058)
## Description

This repository contains the implementation of individual-based simulations of the wildlife-vehicle collision model introduced in arXiv:2507.17058

To run the code, compile and execute with

ifort -fast samp-ini-logsamp.f90 dranxor.f90
./a.out A1 A2 A3 A3

where Ai are model parameters as described in samp-ini-logsamp.f90

## Citation

If you use this code in your research, please cite the accompanying paper. The citation format is as follows:

```bibtex
@misc{defigueiredo2025animalmovementinfluenceswildlifevehicle,
      title={How animal movement influences wildlife-vehicle collision risk: a mathematical framework for range-resident species}, 
      author={Benjamin Garcia de Figueiredo and Inês Silva and Michael J. Noonan and Christen H. Fleming and William F. Fagan and Justin M. Calabrese and Ricardo Martinez-Garcia},
      year={2025},
      eprint={2507.17058},
      archivePrefix={arXiv},
      primaryClass={q-bio.PE},
      url={https://arxiv.org/abs/2507.17058}, 
}
```
