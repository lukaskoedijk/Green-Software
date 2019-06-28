import pandas
import os
from scipy.stats import kendalltau
import matplotlib.pyplot as plt

path = os.getcwd()
df = pandas.read_csv(path + "/newresults2.csv", engine='python')
df_outlier = pandas.read_csv(path + "/graphs2/outlier/port2.outliers.csv", engine='python')

energy = []
time = []
for i, row in df.iterrows():
    if row['Name'] not in df_outlier.Name.values:
        energy.append(row['Joule(surface)'])
        time.append(row['time(ms)'])

df = pandas.read_csv(path + "/newresults3.csv", engine='python')
df_outlier = pandas.read_csv(path + "/graphs3/outlier/port3.outliers.csv", engine='python')
for i, row in df.iterrows():
    if row['Name'] not in df_outlier.Name.values:
        energy.append(row['Joule(surface)'])
        time.append(row['time(ms)'])

plt.figure()
plt.scatter(time, energy, c='blue')
plt.xlabel("Run time (ms)")
plt.ylabel("Energy consumptio (Joule)")
plt.ylim(bottom=0)
plt.xlim(left=0)
plt.savefig(path + "/time.png")
plt.close()

tau, p = kendalltau(energy, time)
print("The kendall tau correlation:", tau, p)
