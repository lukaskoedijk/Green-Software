import pandas
import os
import numpy

path = os.getcwd()
df = pandas.read_csv(path+"/results.csv", engine='python')
df_times = pandas.read_csv(path+"/program_info.csv", engine='python')

count=3
problems = {"Binarytrees":"0", "Fannkuchredux":"1", "Fasta":"2",
            "Mandelbrot":"3", "Nbody":"4", "Revcomp":"5",
                "Spectralnorm":"6"}
result = []
labels = ['Name', 'Average(joule)', 'Standart deviation', 'Average(alljoule)']
new = []
newlabels = list(df)

for i, row in df_times.iterrows():
    rows = []
    filename = row['Language'].lower() + "-" + str(row['ID']) + ".problem" + problems[row['Problem']]
    for i2, row2 in df.iterrows():
        if filename in row2['Name']:
            row2['Joule(surface)'] = row2['Joule(surface)'] / row['Runtimes']
            row2['kWh(surface)'] = row2['kWh(surface)'] / row['Runtimes']
            row2['allJoule(surface)'] = row2['allJoule(surface)'] / row['Runtimes']
            row2['allkWh(surface)'] = row2['allkWh(surface)'] / row['Runtimes']
            rows.append(row2)
            new.append(row2)
        if len(rows) == count:
            break

    total = []
    alltotal = []
    for r in rows:
        total.append(r['Joule(surface)'])
        alltotal.append(r['allJoule(surface)'])
    result.append((filename, numpy.mean(total), numpy.std(total), numpy.mean(alltotal)))

df = pandas.DataFrame.from_records(result, columns=labels)
df.to_csv('average_file.csv')

df = pandas.DataFrame.from_records(new, columns=newlabels)
df.to_csv('newresults.csv')
