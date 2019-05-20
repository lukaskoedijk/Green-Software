import pandas
import os
import numpy
import matplotlib.pyplot as plt

path = os.getcwd()
df = pandas.read_csv(path+"/newresults.csv", engine='python')

result = []
labels = ['Language', 'Binarytrees', 'Fannkuchredux', 'Fasta', 'Mandelbrot', 'Nbody', 'Revcomp', 'Spectralnorm']
language = ['java', 'javascript', 'python3', 'php', 'cs', 'yarv', 'c-flags', 'c-noflags', 'c++-flags', 'c++-noflags']
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
            values.append((numpy.mean(rows), numpy.std(rows)))
    result.append([x] + values)

df_al = pandas.DataFrame.from_records(result, columns=labels)
df_al.to_csv('average_language.csv')

#graph per problem, on x-as the languages on y the energy
for y in problems:
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
#    plt.xticks(lang, language)
    if y == 'problem0':
        plt.savefig("binarytrees_overview")
    elif y == 'problem1':
        plt.savefig("fannkuchredux_overview")
    elif y == 'problem2':
        plt.savefig("fasta_overview")
    elif y == 'problem3':
        plt.savefig("mandelbrot_overview")
    elif y == 'problem4':
        plt.savefig("nbody_overview")
    elif y == 'problem5':
        plt.savefig("revcomp_overview")
    elif y == 'problem6':
        plt.savefig("spectralnorm_overview")
