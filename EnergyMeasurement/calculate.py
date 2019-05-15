import pandas
import os
import matplotlib.pyplot as plt

# data = pandas.read_csv('results/primes_300000.csv', sep='\s*,\s*',
#                        engine='python')

result = []
labels = ['Name', 'Joule(surface)', 'kWh(surface)', 'Mean', 'Median',
          'Stddev', 'time(ms)', 'time(string)']
#labels = ['Name', 'time(ms)', 'time(string)']

# probably making separate result directories for a single file,
# because of running a program multiple times
path = os.getcwd() + '/results/results'
files = []
for r, d, f in os.walk(path):
    for file in f:
        if '.csv' in file:
            files.append(os.path.join(r, file))

for name in files:
#    if name == "/Users/Lukas/Documents/Software Engeneering/Master Thesis/Green-Software/EnergyMeasurement/results/results/fasta/noflags.port3.c-6.problem2.1.csv":
#        continue
    data = pandas.read_csv(name, sep='\s*,\s*', engine='python')

#    if (name == 'primes.csv'):
#        plt.scatter(data['Time(mS)'], data['Power(W)'])
#        plt.xlabel('Time (ms)')
#        plt.ylabel('Power (Watt)')
#        plt.show()

    # Calculate Duration in Milliesecond, but also nicely formated (caution
    # days/weeks/months not implemented because we know that the programs
    # are not running that long)
    timeMs = data['TimeNODE(mS)'][data.index[-1]] - data['TimeNODE(mS)'][data.index[0]]
    milli = timeMs % 1000
    sec = (int(timeMs / 1000) % 60)
    min = (int(timeMs / (1000*60)) % 60)
    hour = (int(timeMs / (1000*60*60)) % 60)
    timeString = str(hour) + " Hours, " + str(min) + " Minutes, " + \
        str(sec) + " Seconds, " + str(milli) + " Milliseconds"

    # Calculate Energy Consumption in Joule and kWh by taking the
    # average between two points, calculating the surface and then
    # adding all the surfaces together
    surface = 0
    for i in range(data.index[-1]):
        surface += (data['Power(W)'][data.index[i]] +
                    data['Power(W)'][data.index[i+1]]) / 2 * (
            data['TimeNODE(mS)'][data.index[i+1]] -
            data['TimeNODE(mS)'][data.index[i]])
    surfaceJ = surface/1000  # Make it in Joule
    surfacekWh = surfaceJ/3600000  # Make it in kWh

    # Calculate Energy Consumption in kWh by using meter
#    energyMeter = (data['Energy(kWH)'][data.index[-1]] -
#                   data['Energy(kWH)'][data.index[0]])
    # remove weird trailing numbers
#    energyMeter = round(energyMeter * 1000)/1000


    # Calculate average and median of power
    mean = data['Power(W)'].mean()
    median = data['Power(W)'].median()
    stddev = data['Power(W)'].std()
    name = os.path.split(name)[1]
    
    result.append((name, surfaceJ, surfacekWh, mean, median,
                   stddev, timeMs, timeString))
#    if "port3" in name:#name.startswith( 'port3' ):
#        result.append((name, timeMs, timeString))
                   #result.append((name, timeMs, timeString))

    if timeMs < 7000:
        print(name, timeString)

df = pandas.DataFrame.from_records(result, columns=labels)
df.to_csv('results.csv')
totaltime = df['time(ms)'].sum()
print(totaltime)
totaltimeSec = (int(totaltime / 1000) % 60)
totaltimeMin = (int(totaltime / (1000*60)) % 60)
totaltimeHour = (int(totaltime / (1000*60*60)) % 60)
print(totaltimeHour, totaltimeMin, totaltimeSec)
