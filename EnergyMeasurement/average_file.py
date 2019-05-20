import pandas
import os
import numpy
import sys

port=sys.argv[1]
print('port is:', port, type(port))

path = os.getcwd()
df = pandas.read_csv(path+"/results" + port + ".csv", engine='python')
df_times = pandas.read_csv(path+"/program_info.csv", engine='python')

if port == "2":
    count = 8
else:
    count = 13#to make it stop searching if have found all
problems = {"Binarytrees":"0", "Fannkuchredux":"1", "Fasta":"2",
            "Mandelbrot":"3", "Nbody":"4", "Revcomp":"5",
                "Spectralnorm":"6"}
result = []
labels = ['Name', 'Average(joule)', 'Standart deviation', 'Average(alljoule)', 'Time(s)', 'Joule/sec']
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
            row2['time(ms)'] = row2['time(ms)'] / row['Runtimes'] / 1000
            rows.append(row2)
            new.append(row2)
        if len(rows) == count:
            break

    total = []
    alltotal = []
    totaltime = []
    for r in rows:
        total.append(r['Joule(surface)'])
        alltotal.append(r['allJoule(surface)'])
        totaltime.append(r['time(ms)'])
    result.append((filename, numpy.mean(total), numpy.std(total), numpy.mean(alltotal), numpy.mean(totaltime), (numpy.mean(total)/numpy.mean(totaltime))))

df = pandas.DataFrame.from_records(result, columns=labels)
df.to_csv('average_file' + port + '.csv')

df = pandas.DataFrame.from_records(new, columns=newlabels)
df.to_csv('newresults' + port + '.csv')
