import pandas
import os
import numpy
import matplotlib.pyplot as plt
import sys

port=sys.argv[1]
print('port is:', port)

path = os.getcwd()
df = pandas.read_csv(path+"/newresults" + port + ".csv", engine='python')

result = []
labels = ['Language', 'Binarytrees', 'Fannkuchredux', 'Fasta', 'Mandelbrot', 'Nbody', 'Revcomp', 'Spectralnorm']
language = ['java-', 'javascript-', 'python3-', 'php-', 'cs-', 'yarv-', 'c-flags-', 'c-noflags-', 'c++-flags-', 'c++-noflags-']
problems = ['problem0', 'problem1', 'problem2', 'problem3', 'problem4', 'problem5', 'problem6']

for x in language:
    values = []
    for y in problems:
        rows = []
        for i, row in df.iterrows():
            if x in row['Name'] and y in row['Name']:
                rows.append(row['Joule(surface)'])
        if len(rows) == 0:
            values.append(("NaN", "NaN"))
        else:
            mean = numpy.mean(rows)
            median = numpy.median(rows)
            std = (numpy.std(rows)/mean)*100
            values.append((mean, median, std, min(rows), max(rows)))
    result.append([x] + values)

df_al = pandas.DataFrame.from_records(result, columns=labels)
df_al.to_csv('average_language' + port + '.csv')

#graph per problem, on x-as the languages on y the energy
for y in problems:
    plt.figure()
    lang = []#languages
    energy = []#energy
    for i, row in df.iterrows():
        if y in row['Name']:
            count = 0
            for x in language:
                if x in row['Name']:
                    lang.append(count)
                    energy.append(row['Joule(surface)'])
                count += 1
    plt.scatter(lang, energy, c='b', marker='.')
    plt.xlabel('Languages')
    plt.ylabel('Energy consumption (Joule)')
    plt.xticks([0,1,2,3,4,5,6,7,8,9], language)
    if y == 'problem0':
        plt.savefig(path + "/graphs" + port + "/binarytrees_overview" + port)
    elif y == 'problem1':
        plt.savefig(path + "/graphs" + port + "/fannkuchredux_overview" + port)
    elif y == 'problem2':
        plt.savefig(path + "/graphs" + port + "/fasta_overview" + port)
    elif y == 'problem3':
        plt.savefig(path + "/graphs" + port + "/mandelbrot_overview" + port)
    elif y == 'problem4':
        plt.savefig(path + "/graphs" + port + "/nbody_overview" + port)
    elif y == 'problem5':
        plt.savefig(path + "/graphs" + port + "/revcomp_overview" + port)
    elif y == 'problem6':
        plt.savefig(path + "/graphs" + port + "/spectralnorm_overview" + port)
    plt.close()

    plt.figure()
    data = []
    for i in range(len(language)):
        col = []
        for j in range(len(lang)):
            if lang[j] == i:
                col.append(energy[j])
        data.append(col)
    plt.figure()
    plt.boxplot(data)
    plt.xlabel('Program ID')
    plt.ylabel('Energy consumption (Joule)')
    plt.ylim(bottom=0)
    plt.xticks([i for i in range(1, len(data)+1)], language)
    if y == 'problem0':
        plt.savefig(path + "/graphs" + port + "/binarytrees_BOXoverview" + port)
    elif y == 'problem1':
        plt.savefig(path + "/graphs" + port + "/fannkuchredux_BOXoverview" + port)
    elif y == 'problem2':
        plt.savefig(path + "/graphs" + port + "/fasta_BOXoverview" + port)
    elif y == 'problem3':
        plt.savefig(path + "/graphs" + port + "/mandelbrot_BOXoverview" + port)
    elif y == 'problem4':
        plt.savefig(path + "/graphs" + port + "/nbody_BOXoverview" + port)
    elif y == 'problem5':
        plt.savefig(path + "/graphs" + port + "/revcomp_BOXoverview" + port)
    elif y == 'problem6':
        plt.savefig(path + "/graphs" + port + "/spectralnorm_BOXoverview" + port)
    plt.close()
