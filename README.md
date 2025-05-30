[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://opensource.org/licenses/MIT)


# Woven Analysis Repo
Collection of analysis scripts used in "Computational models reveal that intuitive physics underlies visual processing of soft objects"

```bibtex
@article{Bi_Shah_Wong_Scholl_Yildirim,
  title={Computational models reveal that intuitive physics underlies visual processing of soft objects},
  author={Bi, Wenyan and Shah, Aalap D. and Wong, Kimberly W. and Scholl, Brian J. and Yildirim, Ilker},
  journal={Nature Communications},
  year={2025}
}
```
---

## ⚙️ Dependencies

The analysis require a python environment with the following dependencies:
```
numpy
pandas
sklearn
statsmodels
seaborn
scipy
```

---
## 📄 Replication

To replicate the results and figures from the paper, follow the setup instructions below and run the corresponding scripts.


### 📥 Download data

Download all required data files by running the following command:

```bash
bash download_data.sh
```


### 🚀 Run script
[figures_stiffness.ipynb](https://github.com/CNCLgithub/cloth-intuitive-physics_analysis/blob/main/figures_stiffness.ipynb): Generate figures for Fig. 3A (Exp. 1); Fig. 3C (Exp. 1); Fig. 4A (i) and (ii); Supplementary Fig. 6A; Supplementary Fig.8 A, B, and D; Supplementary Fig.9 A, B, and D; Supplementary Fig.10 A, B, and D; Supplementary Fig. 11.

[figures_mass.ipynb](https://github.com/CNCLgithub/cloth-intuitive-physics_analysis/blob/main/figures_mass.ipynb): Generate figures for Fig. 3A (Exp. 2); Fig. 3C (Exp. 2); Fig. 4B (i) and (ii); Supplementary Fig. 6B; Supplementary Fig.8 E, F, and H; Supplementary Fig.9 E, F, and H; Supplementary Fig.10 E, F, and H; Supplementary Fig. 12.

[plot_nmds.ipynb](https://github.com/CNCLgithub/cloth-intuitive-physics_analysis/blob/main/plot_nmds.ipynb): Generate figures for Fig. 4A (iii) and 4B (iii).

[scripts/nmds/plot_embedding.m](https://github.com/CNCLgithub/cloth-intuitive-physics_analysis/blob/main/scripts/nmds/plot_embedding.m): Generate figures for Fig. 3B (i)-(iii) and (v)-(vii); Supplementary Fig.7; Supplementary Fig.8 C and G; Supplementary Fig.9 C and G; Supplementary Fig.10 C and G. Output figures are saved at [here](https://github.com/CNCLgithub/cloth-intuitive-physics_analysis/tree/main/scripts/nmds/output/fig).


[dnn_training_res.ipynb](https://github.com/CNCLgithub/cloth-intuitive-physics_analysis/blob/main/dnn_training_res.ipynb):  Generate figures for Supplementary Fig. 4.

[fig5_woven_predicted_perceptual_constancy.ipynb](https://github.com/CNCLgithub/cloth-intuitive-physics_analysis/blob/main/fig5_woven_predicted_perceptual_constancy.ipynb): Generate figures for Fig. 5.

[stats.ipynb](https://github.com/CNCLgithub/cloth-intuitive-physics_analysis/blob/main/stats.ipynb): Conduct all statistical significance analysis.




