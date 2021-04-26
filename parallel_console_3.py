# 2021.04.19.
# Nagy Nándor

'''Adattömb előállítása lua script és párhuzamos command prompt segítségével.'''

### -- Package-ek importálása
import numpy as np
import pandas as pd
import math
import femm
import operator  # - tuple összegzéshez

import os
import subprocess
import pathlib

from build_femm_model import *
### -- End of Package-ek importálása



D = 100

FNULL = open(os.devnull, 'w')    #use this if you want to suppress output to stdout from the subprocess
# filename = r"C:\Users\nnand\PycharmProjects\radial_1\test_script.lua"


root_path = pathlib.Path().absolute()
script_name = r"\FEMM_radial_slice_v7.lua"
filename = str(root_path)
filename += str(script_name)
# filename += " -windowhide"


# --------
blankfemm = "parallel" + str(1)
FEMM_startup_2(blankfemm)

Z_min_1 = 9  # - Minimális horonyszám
Z_max_1 = 20  # - Maximális horonyszám

variables = " -lua-var=filename="
variables += str(blankfemm)

variables += " -lua-var=Z_min="
variables += str(Z_min_1)

variables += " -lua-var=Z_max="
variables += str(Z_max_1)

args = r"C:\femm42\bin\femm.exe -lua-script=" + filename + variables
# subprocess.call(args, stdout=FNULL, stderr=FNULL, shell=False)
subprocess.Popen(args, stdout=FNULL, stderr=FNULL, shell=False)
# --------

# --------
blankfemm = "parallel" + str(2)
FEMM_startup_2(blankfemm)

Z_min_2 = 21  # - Minimális horonyszám
Z_max_2 = 30  # - Maximális horonyszám

variables = " -lua-var=filename="
variables += str(blankfemm)

variables += " -lua-var=Z_min="
variables += str(Z_min_2)

variables += " -lua-var=z_max="
variables += str(Z_max_2)

args_2 = r"C:\femm42\bin\femm.exe -lua-script=" + filename + variables
# subprocess.call(args, stdout=FNULL, stderr=FNULL, shell=False)
subprocess.Popen(args_2, stdout=FNULL, stderr=FNULL, shell=False)
# --------

# --------
blankfemm = "parallel" + str(3)
FEMM_startup_2(blankfemm)

z_min_3 = 31  # - Minimális horonyszám
z_max_3 = 38  # - Maximális horonyszám

variables = " -lua-var=filename="
variables += str(blankfemm)

variables += " -lua-var=z_min="
variables += str(z_min_3)

variables += " -lua-var=z_max="
variables += str(z_max_3)

args_3 = r"C:\femm42\bin\femm.exe -lua-script=" + filename + variables
# subprocess.call(args, stdout=FNULL, stderr=FNULL, shell=False)
subprocess.Popen(args_3, stdout=FNULL, stderr=FNULL, shell=False)
# --------

# --------
blankfemm = "parallel" + str(4)
FEMM_startup_2(blankfemm)

z_min_4 = 39  # - Minimális horonyszám
z_max_4 = 44  # - Maximális horonyszám

variables = " -lua-var=filename="
variables += str(blankfemm)

variables += " -lua-var=z_min="
variables += str(z_min_4)

variables += " -lua-var=z_max="
variables += str(z_max_4)

args_4 = r"C:\femm42\bin\femm.exe -lua-script=" + filename + variables
# subprocess.call(args, stdout=FNULL, stderr=FNULL, shell=False)
subprocess.Popen(args_4, stdout=FNULL, stderr=FNULL, shell=False)
# --------

# --------
blankfemm = "parallel" + str(5)
FEMM_startup_2(blankfemm)

z_min_5 = 45  # - Minimális horonyszám
z_max_5 = 50  # - Maximális horonyszám

variables = " -lua-var=filename="
variables += str(blankfemm)

variables += " -lua-var=z_min="
variables += str(z_min_5)

variables += " -lua-var=z_max="
variables += str(z_max_5)

args_5 = r"C:\femm42\bin\femm.exe -lua-script=" + filename + variables
# subprocess.call(args, stdout=FNULL, stderr=FNULL, shell=False)
subprocess.Popen(args_5, stdout=FNULL, stderr=FNULL, shell=False)
# --------


femm.mi_close()


print("kész")