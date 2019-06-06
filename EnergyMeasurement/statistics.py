import pandas
import os
import numpy
import sys
import matplotlib.pyplot as plt
from sklearn.cluster import DBSCAN
from sklearn.preprocessing import StandardScaler
#from scipy.stats import shapiro
from scipy.stats import ks_2samp

port=sys.argv[1]
test=sys.argv[2]
print('port is:', port)
print('test is:', test)

path = os.getcwd()
df = pandas.read_csv(path + "/newresults" + port + ".csv", engine='python')
df_times = pandas.read_csv(path+"/program_info.csv", engine='python')
df_outlier = pandas.read_csv(path + "/graphs" + port + "/outlier/port" + port + ".outliers.csv", engine='python')

if port == "2":
    count = 22
else:
    count = 27#to make it stop searching if have found all
problems = {"Binarytrees":"0", "Fannkuchredux":"1", "Fasta":"2",
    "Mandelbrot":"3", "Nbody":"4", "Revcomp":"5",
        "Spectralnorm":"6"}

total = []
totalnames = []
allnames = []
for i, row in df_times.iterrows():
    rows = []
    filename = row['Language'].lower() + "-" + str(row['ID']) + ".problem" + problems[row['Problem']]
    for i2, row2 in df.iterrows():
        if filename in row2['Name']:
            rows.append(row2)
            if len(rows) == count:
                break

    data = []
    names = []
    for r in rows:
        data.append([r['time(ms)'], r['Joule(surface)']])
        names.append(r['Name'])
    total.append(data)
    totalnames.append(filename)
    allnames.append(names)

#test if two programs energy consumption come from the same distribution
#using Kolmogorov–Smirnov test
if test == '1':
    samedist = []
    count = 0
    for d1 in total:
        for i2 in range(total.index(d1)+1, len(total)):
            name1 = totalnames[total.index(d1)]
            name2 = totalnames[i2]
            if name1.split(".")[1] == name2.split(".")[1] and (name1.split(".")[0]).split("-", 2)[:-1] == (name2.split(".")[0]).split("-", 2)[:-1]:
                value1 = []
                for point in range(len(d1)):
                    if allnames[total.index(d1)][point] not in df_outlier.Name.values:
                        value1.append(d1[point][1])
                value2 = []
                for point in range(len(total[i2])):
                    if allnames[i2][point] not in df_outlier.Name.values:
                        value2.append(total[i2][point][1])
                d, p = ks_2samp(value1, value2)
                if p > 0.05:
                    print("Same distribution:", name1, name2, d, p)
                    count += 1
                    plt.figure()
                    plt.subplot(211)
                    y1 = [y[1] for y in d1]
                    y2 = [y[1] for y in total[i2]]
                    y1.sort()
                    y2.sort()
                    plt.scatter([x for x in range(len(d1))], y1, c='b', marker='.')
                    plt.scatter([x for x in range(len(total[i2]))], y2, c='r', marker='.')
                    plt.xlabel('ID')
                    plt.ylabel('Energy consumption (Joule)')
                    plt.ylim(bottom=0)
                    
                    plt.subplot(212)
                    plt.scatter([x[0] for x in d1], [y[1] for y in d1], c='b', marker='.')
                    plt.scatter([x[0] for x in total[i2]], [y[1] for y in total[i2]], c='r', marker='.')
                    plt.xlabel('Run-time (Seconds)')
                    plt.ylabel('Energy consumption (Joule)')
                    plt.ylim(bottom=0)
                    plt.xlim(left=0)
                    plt.savefig(path + '/graphs' + port + '/samedist/port' + port + '.' + name1 + '-' + name2 + '.png')
                    plt.close()
                    
                    samedist.append([name1, name2, d, p])
    print("The amount of programs that have the same distribution:", count)

    df = pandas.DataFrame.from_records(samedist, columns=['Program1', 'Program2', 'd', 'p'])
    df.to_csv(path + '/graphs' + port + '/samedist/port' + port + 'same_distribution.csv')
    

        #1d outlier/anomaly check
#        for r in rows:
#            zscore = abs(numpy.mean(data) - r['Joule(surface)']) / numpy.std(data)
#            if zscore >= 2.5:
#                print("Outlier:", r['Name'], zscore)
#
#        #1d normal dist check
#        data.sort()
#        stat, p = shapiro(data)
#        if p <= 0.05:
#            pass
                #print(filename, stat, p)

elif test == '2':
    results = []
    minPts = 4
    
    for d in total:
        data = StandardScaler().fit_transform(d)
        data = [[x[0],x[1]] for x in data]
        kdist = []
        for p in data:
            dist = []
            for p2 in data:
                if p != p2:
                    dist.append(numpy.sqrt((p[0]-p2[0])**2 + (p[1]-p2[1])**2))
            dist.sort()
            kdist.append(dist[minPts-1])

        #calc eps for outlier check
        slopes = []
        kdist.sort(reverse=True)
        for k in range(1, len(kdist)):
            slopes.append(kdist[k]-kdist[k-1])
        div = 0.15
        eps = 1
        for l in range(len(slopes)-1):
            if abs(slopes[l] - slopes[l+1]) >= div:
                div = abs(slopes[l] - slopes[l+1])
                eps = kdist[l+1]

        #2d outlier/anomaly check
        cluster = DBSCAN(eps=eps, min_samples=minPts, metric='euclidean').fit(data)
        label = cluster.labels_
        color = []
        for q in range(len(data)):
            if label[q] == -1:
                color.append('r')
                results.append([allnames[total.index(d)][q], eps, d[q][0], d[q][1]])
            else:
                color.append('b')
        plt.figure()
        plt.scatter([x[0] for x in d], [y[1] for y in d], c=color, marker='.')
        plt.xlabel('time(s)')
        plt.ylabel('Joule(surface)')
        plt.ylim(bottom=0)
        plt.xlim(left=0)
        plt.savefig(path + "/graphs" + port + "/outlier/port" + port + ".bdscan." + totalnames[total.index(d)] + ".png")
        plt.close()

    df_outliers = pandas.DataFrame.from_records(results, columns=['Name', 'Eps', 'Time', 'Energy'])
    df_outliers.to_csv(path + "/graphs" + port + "/outlier/port" + port + ".outliers.csv")



#use 2 for secondary clusters and len(total)/2 otherwise
#    cluster = DBSCAN(eps=0.3, min_samples=len(total)/2, metric='euclidean').fit([[x[0]/max(totaltime),x[1]/max(total)] for x in data])
#    label = cluster.labels_
#    if -1 in label:


#        plt.figure()
#        kdist.sort()
#        plt.scatter([i for i in range(len(kdist))], kdist, c='b', marker='.')
#        plt.ylim(bottom=0)
#        plt.savefig(path + "/outlier" + port + "/kdist" + filename + ".png")
#        plt.close()

#    kmeans = KMeans(n_clusters=2).fit(data)
#    labelK = list(kmeans.labels_)
#    print("toch wel", labelK)
#    if labelK.count(1) < 3 or labelK.count(0) < 3:
#        print("Kmeans", labelK, filename)
#        file = open("/outlier" + port + "/kmeans.txt", "a")
#        file.write("Kmeans " + str(labelK) + " " + filename + "\n")
#        file.close()
