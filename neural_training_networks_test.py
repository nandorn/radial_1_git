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
### -- End of Package-ek importálása

## -- Infók a verzióról:
# Neurális háló illesztése axial_flux_model_01_v1 modellre.

#

plt.style.use('seaborn-whitegrid')
# Set Matplotlib defaults
plt.rc('figure', autolayout=True)
plt.rc('axes', labelweight='bold', labelsize='large',
       titleweight='bold', titlesize=18, titlepad=10)


train_data = pd.read_csv("radial_v1_Train.csv") # - train data beolvasás
valid_data = pd.read_csv("radial_v1_Valid.csv") # - valid data beolvasás

fullvalid_data = pd.read_csv("radial_v1_Full.csv")

print(valid_data)

print(train_data.columns)

print(valid_data.szoras)

y_train = train_data.szoras # - prediction target

circuit_features = ['Z','p','beta','b_fogperm_szel','b_fogpertau_p','l_fogperD','b_stat_koszperD','b_rot_koszperD','b_fogpertau_h','m_magperd','m_magpertau_p'] # - Choosing "Features"


# 'Z', 'p'	'beta', 'b_fog/m_szel', 'b_fog/tau_p', 'l_fog/D', 'b_stat_kosz/D', 'b_rot_kosz/D', 'b_fog/tau_h', 'm_mag/d', 'm_mag/tau_p', 'szoras'
# 'Z','p','beta','b_fogperm_szel','b_fogpertau_p','l_fogperD','b_stat_koszperD','b_rot_koszperD','b_fogpertau_h','m_magperd','m_magpertau_p','szoras'
X_train = train_data[circuit_features]

y_valid = valid_data.szoras # - prediction target

X_valid = valid_data[circuit_features]

X_fullvalid = fullvalid_data[circuit_features]
# print(X.describe())
# print(X.head())

print(X_train.columns)
print(X_train.head)
#
# # print(y_valid.columns)
# print(valid_data[circuit_features].head)
# print(train_data[circuit_features].head)
#
# print(valid_data.head)
# print(train_data.head)



# model = keras.Sequential([
#     # the hidden ReLU layers
#     layers.Dense(units=512, activation='relu', input_shape=[11]),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=256, activation='relu'),
#     layers.Dense(units=256, activation='relu'),
#     layers.Dense(units=128, activation='relu'),
#     # the linear output layer
#     layers.Dense(units=1),
# ])



# model = keras.Sequential([
#     # the hidden ReLU layers
#     layers.Dense(units=1024, activation='relu', input_shape=[11]),
#     layers.Dense(units=1024, activation='relu'),
#     layers.Dense(units=1024, activation='relu'),
#     layers.Dense(units=1024, activation='relu'),
#     layers.Dense(units=1024, activation='relu'),
#     layers.Dense(units=1024, activation='relu'),
#     layers.Dense(units=1024, activation='relu'),
#     layers.Dense(units=1024, activation='relu'),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=256, activation='relu'),
#     layers.Dense(units=256, activation='relu'),
#     layers.Dense(units=128, activation='relu'),
#     # the linear output layer
#     layers.Dense(units=1),
# ])


# model = keras.Sequential([
#     # the hidden ReLU layers
#     layers.Dense(units=2048, activation='relu', input_shape=[11]),
#     layers.Dense(units=2048, activation='relu'),
#     layers.Dense(units=2048, activation='relu'),
#     layers.Dense(units=2048, activation='relu'),
#     layers.Dense(units=2048, activation='relu'),
#     layers.Dense(units=2048, activation='relu'),
#     layers.Dense(units=2048, activation='relu'),
#     layers.Dense(units=2048, activation='relu'),
#     layers.Dense(units=1024, activation='relu'),
#     layers.Dense(units=1024, activation='relu'),
#     layers.Dense(units=1024, activation='relu'),
#     layers.Dense(units=1024, activation='relu'),
#     layers.Dense(units=1024, activation='relu'),
#     layers.Dense(units=1024, activation='relu'),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=256, activation='relu'),
#     layers.Dense(units=256, activation='relu'),
#     layers.Dense(units=128, activation='relu'),
#     # the linear output layer
#     layers.Dense(units=1),
# ])


# model = keras.Sequential([
#     # the hidden ReLU layers
#     layers.Dense(units=1024, activation='relu', input_shape=[11]),
#     layers.Dense(units=1024, activation='relu'),
#     layers.Dense(units=1024, activation='relu'),
#     layers.Dense(units=1024, activation='relu'),
#     layers.Dense(units=1024, activation='relu'),
#     layers.Dense(units=1024, activation='relu'),
#     layers.Dense(units=1024, activation='relu'),
#     layers.Dense(units=1024, activation='relu'),
#     layers.Dense(units=1024, activation='relu'),
#     layers.Dense(units=1024, activation='relu'),
#     layers.Dense(units=1024, activation='relu'),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=256, activation='relu'),
#     layers.Dense(units=256, activation='relu'),
#     layers.Dense(units=128, activation='relu'),
#     # the linear output layer
#     layers.Dense(units=1),
# ])


model = keras.Sequential([
    # the hidden ReLU layers
    layers.Dense(units=2048, activation='relu', input_shape=[11]),
    layers.Dense(units=2048, activation='relu'),
    layers.Dense(units=2048, activation='relu'),
    layers.Dense(units=2048, activation='relu'),
    layers.Dense(units=2048, activation='relu'),
    layers.Dense(units=2048, activation='relu'),
    layers.Dense(units=2048, activation='relu'),
    layers.Dense(units=2048, activation='relu'),
    layers.Dense(units=512, activation='relu'),
    layers.Dense(units=512, activation='relu'),
    layers.Dense(units=512, activation='relu'),
    layers.Dense(units=512, activation='relu'),
    layers.Dense(units=512, activation='relu'),
    layers.Dense(units=512, activation='relu'),
    layers.Dense(units=256, activation='relu'),
    layers.Dense(units=256, activation='relu'),
    layers.Dense(units=128, activation='relu'),
    # the linear output layer
    layers.Dense(units=1),
])







# model = keras.Sequential([
#     # the hidden ReLU layers
#     layers.Dense(units=512, activation='relu', input_shape=[7]),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dropout(0.3),
#     layers.BatchNormalization(),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dropout(0.3),
#     layers.BatchNormalization(),
#     layers.Dense(units=512, activation='relu'),
#     layers.Dense(units=256, activation='relu'),
#     layers.Dense(units=256, activation='relu'),
#     layers.Dense(units=128, activation='relu'),
#     # the linear output layer
#     layers.Dense(units=1),
# ])

# model = keras.Sequential([
#     layers.Dense(512, activation='relu', input_shape=[7]),
#     layers.Dropout(0.3),
#     layers.BatchNormalization(),
#     layers.Dense(512, activation='relu'),
#     layers.Dropout(0.3),
#     layers.BatchNormalization(),
#     layers.Dense(512, activation='relu'),
#     layers.Dropout(0.3),
#     layers.BatchNormalization(),
#     layers.Dense(512, activation='relu'),
#     layers.Dropout(0.3),
#     layers.BatchNormalization(),
#     layers.Dense(512, activation='relu'),
#     layers.Dropout(0.3),
#     layers.BatchNormalization(),
#     layers.Dense(512, activation='relu'),
#     layers.Dropout(0.3),
#     layers.BatchNormalization(),
#     layers.Dense(512, activation='relu'),
#     layers.Dropout(0.3),
#     layers.BatchNormalization(),
#     layers.Dense(512, activation='relu'),
#     layers.Dropout(0.3),
#     layers.BatchNormalization(),
#     layers.Dense(256, activation='relu'),
#     layers.Dropout(0.3),
#     layers.BatchNormalization(),
#     layers.Dense(1),
# ])

# model = keras.Sequential([
#     layers.Dense(1024, activation='relu', input_shape=[2]),
#     layers.Dropout(0.3),
#     layers.BatchNormalization(),
#     layers.Dense(1024, activation='relu'),
#     layers.Dropout(0.3),
#     layers.BatchNormalization(),
#     layers.Dense(1024, activation='relu'),
#     layers.Dropout(0.3),
#     layers.BatchNormalization(),
#     layers.Dense(1),
# ])


model.compile(
    optimizer='adam',
    loss='mae',
)


# history = model.fit(
#     X_train, y_train,
#     validation_data=(X_valid, y_valid),
#     batch_size=256,
#     epochs=1000,
# )
#
# # convert the training history to a dataframe
# history_df = pd.DataFrame(history.history)
# # use Pandas native plot method
# history_df['loss'].plot();
# plt.show()

early_stopping = callbacks.EarlyStopping(
    min_delta=0.001, # minimium amount of change to count as an improvement
    patience=200, # how many epochs to wait before stopping
    restore_best_weights=True,
)

history = model.fit(
    X_train, y_train,
    validation_data=(X_valid, y_valid),
    batch_size=256,
    epochs=1500,
    callbacks=[early_stopping], # put your callbacks in a list
    verbose=0,  # turn off training log
)

history_df = pd.DataFrame(history.history)
history_df.loc[:, ['loss', 'val_loss']].plot();
plt.show()
print("Minimum validation loss: {}".format(history_df['val_loss'].min()))


print("fitting kész")

test_predictions = model.predict(X_fullvalid)

print("ELTÉRÉS:")
# print(valid_data)
# print(test_predictions)

fullvalid_data['pred_szoras'] = test_predictions

print(fullvalid_data)
fullvalid_data.to_csv('becsles.csv', index=False, header=True)

fullvalid_data['abszhiba'] = abs((fullvalid_data['pred_szoras'] - fullvalid_data['szoras']) / fullvalid_data['szoras'])
# print("átlagos abszolút hiba"," ", fullvalid_data['abszhiba'].mean())
fullvalid_data['negyzeteshiba'] = pow((fullvalid_data['pred_szoras'] - fullvalid_data['szoras']) / fullvalid_data['szoras'], 2)
# print("átlagos négyzetes eltérés hiba"," ", fullvalid_data['negyzeteshiba'].mean())

print("átlagos abszolút hiba")
print(fullvalid_data['abszhiba'].mean())

print("átlagos négyzetes eltérés")
print(fullvalid_data['negyzeteshiba'].mean())


model.save("model.h5")
print("Saved model to disk")

print("vege")