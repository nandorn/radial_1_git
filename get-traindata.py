# 2021.04.25.
# Nagy Nándor

'''Adattömb előállítása build_femm_model függvények segítségével.'''

### -- Package-ek importálása
import numpy as np
import pandas as pd
import math
import femm
import operator  # - tuple összegzéshez
### -- End of Package-ek importálása

def cust_range(*args, rtol=1e-05, atol=1e-08, include=[True, False]):
    """
    Combines numpy.arange and numpy.isclose to mimic
    open, half-open and closed intervals.
    Avoids also floating point rounding errors as with
    >>> np.arange(1, 1.3, 0.1)
    array([1. , 1.1, 1.2, 1.3])

    args: [start, ]stop, [step, ]
        as in numpy.arange
    rtol, atol: floats
        floating point tolerance as in numpy.isclose
    include: boolean list-like, length 2
        if start and end point are included
    """
    # process arguments
    if len(args) == 1:
        start = 0
        stop = args[0]
        step = 1
    elif len(args) == 2:
        start, stop = args
        step = 1
    else:
        assert len(args) == 3
        start, stop, step = tuple(args)

    # determine number of segments
    n = (stop-start)/step + 1

    # do rounding for n
    if np.isclose(n, np.round(n), rtol=rtol, atol=atol):
        n = np.round(n)

    # correct for start/end is exluded
    if not include[0]:
        n -= 1
        start += step
    if not include[1]:
        n -= 1
        stop -= step

    return np.linspace(start, stop, int(n))

def crange(*args, **kwargs):
    return cust_range(*args, **kwargs, include=[True, True])

def orange(*args, **kwargs):
    return cust_range(*args, **kwargs, include=[True, False])

from build_femm_model import *

from gabor_data import *

# - Adattömb létrehozása
train_data = pd.DataFrame({'Z': [0], 'p': [0], 'beta': [0], 'b_fogPERm_szel': [0], 'b_fogPERtau_p': [0], 'l_fogPERD': [0], 'b_stat_koszPERD': [0], 'b_rot_koszPERD': [0], 'b_fogPERtau_h': [0], 'm_magPERD': [0], 'm_magPERtau_p': [0], 'szoras': [0]})
print(train_data)

train_data.to_csv('train_data.csv', index=False, header=True)

FEMM_startup()

for i in range(1, 800+1, 1):
    Z = getGaborData(i, 1)
    p = getGaborData(i, 2)
    D = getGaborData(i, 3)
    l_fog = getGaborData(i, 4)
    b_stat_kosz = getGaborData(i, 5)
    b_rot_kosz = getGaborData(i, 6)
    beta = getGaborData(i, 7)
    m_mag = getGaborData(i, 8)


# for Z in range(Z_min, Z_max+1, 1):
#     print(round((Z - Z_min) / Z_max * 100, 2), '%')
#     for p in crange(3, 25, 1):
#         tau_h = (D * math.pi) / Z  # - Horonyosztás
#         for b_fog in crange(tau_h*0.25, tau_h*0.85, tau_h/0.6 /10):
#             for l_fog in crange(5, 50, 2):
#                 for b_stat_kosz in crange(3, 30, 2):
#                     for b_rot_kosz in crange(3, 30, 2):
#                         for beta in crange(120, 175, 5):
#                             for m_mag in crange(2, 10, 1):

    Z, p, beta, b_fogPERm_szel, b_fogPERtau_p, l_fogPERD, b_stat_koszPERD, b_rot_koszPERD, b_fogPERtau_h, m_magPERD, m_magPERtau_p = make_prop_specs(Z, p, D, l_fog, b_fog, b_stat_kosz, b_rot_kosz, beta, m_mag)

    FEMM_cleanup()
    szoras = FEMM_radial_slice(Z, p, beta, b_fogPERm_szel, b_fogPERtau_p, l_fogPERD, b_stat_koszPERD, b_rot_koszPERD, b_fogPERtau_h, m_magPERD, m_magPERtau_p)

    if(szoras>0):
        # - Új sor hozzáadása az adattömbhöz
        new_row = pd.DataFrame({'Z': [Z], 'p': [p], 'beta': [beta], 'b_fogPERm_szel': [b_fogPERm_szel], 'b_fogPERtau_p': [b_fogPERtau_p], 'l_fogPERD': [l_fogPERD], 'b_stat_koszPERD': [b_stat_koszPERD], 'b_rot_koszPERD': [b_rot_koszPERD], 'b_fogPERtau_h': [b_fogPERtau_h], 'm_magPERD': [m_magPERD], 'm_magPERtau_p': [m_magPERtau_p], 'szoras': [szoras]})
        new_row.to_csv('train_data.csv', mode='a', header=False, index=False)
        # -

femm.mi_close()

# - Első sor törlése [0, 0, 0]
train_data_refreshed = pd.read_csv("train_data.csv")  # , index_col=0
train_data_refreshed.iloc[1:].to_csv('train_data.csv', index=False, header=True)
# -


train_data = pd.read_csv("train_data.csv")  # , index_col=0)
print(train_data)
