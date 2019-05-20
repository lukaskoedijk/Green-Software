import numpy
import os
import pandas

diff = []
path = os.getcwd() + '/results/results'
for r, d, f in os.walk(path):
    for file in f:
        #if ('start'in file or 'end' in file) and 'count1' not in file:
        if '.csv' in file:
            df = pandas.read_csv(os.path.join(r, file), sep='\s*,\s*', engine='python')
            df1 = df.diff()
            if (df1.shape[0] < 70):
                print(file, df1.shape[0], df['TimeNODE(mS)'][df.index[-1]] - df['TimeNODE(mS)'][df.index[0]])
            for i, row in df1.iterrows():
                if i != 0:
                    x = row['TimeNODE(mS)'] / 1000
                    diff.append(x)

#'TimeNODE(mS)'
#print(diff)
print("The mean of the time difference: " + str(numpy.mean(diff)))
print("The standart deviation of the time difference: " + str(numpy.std(diff)))
print("The maximum time difference: " + str(numpy.max(diff)))
print("The minimum time difference: " + str(numpy.min(diff)))

