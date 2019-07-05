import pandas
import os
from scipy.stats import kendalltau
import matplotlib.pyplot as plt

path = os.getcwd()
df = pandas.read_csv(path + "/newresults2.csv", engine='python')
df_outlier = pandas.read_csv(path + "/graphs2/outlier/port2.outliers.csv", engine='python')

energy = [[], [], [], [], [], [], []]
time = [[], [], [], [], [], [], []]
color = [[], [], [], [], [], [], []]
for i, row in df.iterrows():
    if row['Name'] not in df_outlier.Name.values:
        index = int(row['Name'].split(".")[2][-1])
        energy[index].append(row['Joule(surface)'])
        time[index].append(row['time(ms)'])
        color[index].append("blue")

df = pandas.read_csv(path + "/newresults3.csv", engine='python')
df_outlier = pandas.read_csv(path + "/graphs3/outlier/port3.outliers.csv", engine='python')
for i, row in df.iterrows():
    if row['Name'] not in df_outlier.Name.values:
        index = int(row['Name'].split(".")[2][-1])
        energy[index].append(row['Joule(surface)'])
        time[index].append(row['time(ms)'])
        color[index].append("green")

for i in range(len(energy)):
    plt.figure()
    plt.scatter(time[i], energy[i], c=color[i])
    plt.xlabel("Run time (ms)")
    plt.ylabel("Energy consumptio (Joule)")
    plt.ylim(bottom=0)
    plt.xlim(left=0)
    plt.savefig(path + "/time.problem" + str(i) + ".png")
    plt.close()

    tau, p = kendalltau(energy[i], time[i])
    print("The kendall tau correlation for problem " + str(i) +  ":", tau, p)
