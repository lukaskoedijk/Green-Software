import pandas
import os
import numpy
import sys
import matplotlib.pyplot as plt
from sklearn.cluster import DBSCAN
from sklearn.cluster import KMeans

port=sys.argv[1]
print('port is:', port)

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
labels = ['Name', 'Average(joule)', 'Standart deviation(%)', 'Standart deviation(J)', 'Min', 'Max', 'Average(alljoule)', 'Time(s)', 'Joule/sec', 'Run count']
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
    points = []
    name = []
    for r in rows:
        total.append(r['Joule(surface)'])
        alltotal.append(r['allJoule(surface)'])
        totaltime.append(r['time(ms)'])
        points.append([r['time(ms)'], r['Joule(surface)']])
        name.append(r['Name'])
    mean = numpy.mean(total)
    std = (numpy.std(total)/mean)*100

#    for r in rows:
#        zscore = abs(mean - r['Joule(surface)']) / numpy.std(total)
#        if zscore >= 3:
#            print("Outlier:", r['Name'], zscore)

    #use 2 for secondary clusters and len(total)/2 otherwise
    cluster = DBSCAN(eps=0.2, min_samples=len(total)/2, metric='euclidean').fit([[x[0]/max(totaltime),x[1]/max(total)] for x in points])
    label = cluster.labels_
    if -1 in label:
        print("DBscan", label)
        index = numpy.where(label == -1)
        print("INDEX", index)
        for j in index[0]:
            print(name[j], points[j])
        plt.figure()
        plt.scatter([x[0] for x in points], [y[1] for y in points], c='b', marker='.')
        plt.ylim(bottom=0)
        plt.savefig(path + "/outlier" + port + "/bdscan" + filename + ".png")
        plt.close()

        kdist = []
        for p in points:
            dist = []
            for p2 in points:
                if p != p2:
                    dist.append(numpy.sqrt((p[0]/max(totaltime)-p2[0]/max(totaltime))**2 + (p[1]/max(total)-p2[1]/max(total))**2))
            dist.sort()
            kdist.append(dist[int(len(total)/2)-1])
        plt.figure()
        kdist.sort()
        plt.scatter([i for i in range(len(kdist))], kdist, c='b', marker='.')
        plt.ylim(bottom=0)
        plt.savefig(path + "/outlier" + port + "/kdist" + filename + ".png")
        plt.close()

        kmeans = KMeans(n_clusters=2).fit(points)
        labelK = list(kmeans.labels_)
        if labelK.count(1) == 1 or labelK.count(0) == 1:
            print("Kmeans", labelK, filename)

#'%s' % float('%.3g' % std)
#round(std, 3) both not working for 0. numbers
    result.append((filename, mean, std, numpy.std(total), min(total), max(total), numpy.mean(alltotal),  numpy.mean(totaltime), (numpy.mean(total)/numpy.mean(totaltime)), len(total)))

df = pandas.DataFrame.from_records(result, columns=labels)
df.to_csv('average_file' + port + '.csv')

df = pandas.DataFrame.from_records(new, columns=newlabels)
df.to_csv('newresults' + port + '.csv')
