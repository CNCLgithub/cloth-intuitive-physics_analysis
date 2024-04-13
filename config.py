from math import log

EPOCH_DICT = [422, 844, 1266, 1688, 2110, 2532, 2954, 3376, 3798, 4220,
              4642,  5064,  5486,  5908,  6330,  6752,  7174,  7596,  8018,  8440,
              8862,  9284,  9706, 10128, 10550, 10972, 11394, 11816, 12238, 12660]

LOG_BASE = 4
SCENE_LS = ['wind','drape','rotate','ball']
MASS_LS = ['0.25', '0.5', '1.0','2.0']
STIFF_LS = ['0.0078125','0.03125','0.125','0.5','2.0']
MASS_LOG_LS = [log(float(y),LOG_BASE) for y in MASS_LS]
STIFF_LOG_LS = [log(float(y),LOG_BASE) for y in STIFF_LS]

SCENE_MASS_BS_DICTS = {f'{scene}_{mass}_{bs}': [] for scene in SCENE_LS for mass in MASS_LS for bs in STIFF_LS}
MASS_LOG_DICTS = dict(zip(MASS_LS, MASS_LOG_LS))
STIFF_LOG_DICTS = dict(zip(STIFF_LS, STIFF_LOG_LS))

MASS_COMBINATIONS = set(i - j for i in MASS_LOG_LS for j in MASS_LOG_LS)
STIFF_COMBINATIONS = set(i - j for i in STIFF_LOG_LS for j in STIFF_LOG_LS)

class TilePLot:
    def __init__(self, cond='mass'):
        if cond == 'mass':
            self.rel_idx = 1
            self.irrel_idx = 2
            self.diff_dicts = {f'{i}_{j}': [] for i in MASS_COMBINATIONS for j in STIFF_COMBINATIONS}
        elif cond == 'stiff':
            self.rel_idx = 2
            self.irrel_idx = 1
            self.diff_dicts = {f'{i}_{j}': [] for i in STIFF_COMBINATIONS for j in MASS_COMBINATIONS}
        else:
            raise ValueError("Invalid value for 'cond'. Use 'mass' or 'stiff'.")
