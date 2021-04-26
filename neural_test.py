# 2021.03.08.
# Nagy Nándor

### -- Package-ek importálása
import numpy as np
import pandas as pd
import math
import femm

from tensorflow import keras
from tensorflow.keras import layers, callbacks

import matplotlib.pyplot as plt
from keras.models import load_model
### -- End of Package-ek importálása

## -- Infók a verzióról:
# Neurális háló illesztése axial_flux_model_01_v1 modellre.

test_data = pd.read_csv("test_data_3_523.csv") # - train data beolvasás

circuit_features = ['Z','p','beta','b_fogperm_szel','b_fogpertau_p','l_fogperD','b_stat_koszperD','b_rot_koszperD','b_fogpertau_h','m_magperd','m_magpertau_p'] # - Choosing "Features"

X_test = test_data[circuit_features]

y_test = test_data.szoras # - prediction target

# model = load_model('C:\\Users\\nnand\\PycharmProjects\\radial_1\\modellek\\1\\model.h5')
# model = load_model('C:\\Users\\nnand\\PycharmProjects\\radial_1\\modellek\\2\\model.h5')
# model = load_model('C:\\Users\\nnand\\PycharmProjects\\radial_1\\modellek\\3\\model.h5')
model = load_model('C:\\Users\\nnand\\PycharmProjects\\radial_1\\modellek\\4\\model.h5')

test_predictions = model.predict(X_test)

print("ELTÉRÉS:")
# print(valid_data)
# print(test_predictions)

test_data['pred_szoras'] = test_predictions

print(test_data)
test_data.to_csv('becsles_testdata.csv', index=False, header=True)

test_data['abszhiba'] = abs((test_data['pred_szoras'] - test_data['szoras']) / test_data['szoras'])
# print("átlagos abszolút hiba"," ", fullvalid_data['abszhiba'].mean())
test_data['negyzeteshiba'] = pow((test_data['pred_szoras'] - test_data['szoras']) / test_data['szoras'], 2)
# print("átlagos négyzetes eltérés hiba"," ", fullvalid_data['negyzeteshiba'].mean())

print("átlagos abszolút hiba")
print(test_data['abszhiba'].mean())

print("átlagos négyzetes eltérés")
print(test_data['negyzeteshiba'].mean())


# model.save("model.h5")
# print("Saved model to disk")

print("vege")