import sys
import os
import pandas
import matplotlib.pyplot as plt

language = sys.argv[1]
problem = sys.argv[2]
port = sys.argv[3]

path = os.getcwd()
df = pandas.read_csv(path+"/newresults" + port + ".csv", engine='python')

values = {}
id = []
for i, row in df.iterrows():
    if (language + '-') in row['Name'] and problem in row['Name'] and ('port' + port) in row['Name']:
        name = ".".join(row['Name'].split(".", 3)[:3])
        if name in values.keys():
            values[name].append(row['Joule(surface)'])
        else:
            values[name] = [row['Joule(surface)']]
            id.append(name.split('.', 2)[1][-1])

for x in values.keys():
    plt.scatter([int(x.split('.', 2)[1][-1])] * len(values[x]), values[x], c='b', marker='.')
plt.xlabel('Programs')
plt.ylabel('Energy consumption (Joule)')
#plt.xticks(values.keys(), id)
plt.savefig("Group." + language + "." + problem + "." + port + ".png")

