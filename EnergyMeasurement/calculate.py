import pandas
import os

data = pandas.read_csv('results/primes_300000.csv', sep='\s*,\s*',
                       engine='python')
result = []
labels = ['Name', 'Joule(surface)', 'kWh(surface)', 'kWh(meter)',
          'Mean', 'Median', 'time(ms)', 'time(string)']

#probably making separate result directories for a single file,
#because of running a program multiple times
path = os.getcwd() + '/results'
files = os.listdir(path)

for name in files:
    data = pandas.read_csv('results/' + name, sep='\s*,\s*',
                           engine='python')
    
    #Calculate Duration in Milliesecond, but also nicely formated (caution
    #days/weeks/months not implemented because we know that the programs
    #are not running that long)
    timeMs = data['Time(mS)'][data.index[-1]] - data['Time(mS)'][data.index[0]]
    milli = timeMs % 1000
    sec = (int(timeMs / 1000) % 60)
    min = (int(timeMs / (1000*60)) % 60)
    hour = (int(timeMs / (1000*60*60)) % 60)
    timeString = str(hour) + " Hours, " + str(min) + " Minutes, " + str(sec) + " Seconds, " + str(milli) + " Milliseconds"

    #Calculate Energy Consumption in Joule and kWh by taking the
    #average between two points, calculating the surface and then
    #adding all the surfaces together
    surface = 0
    for i in range(data.index[-1]):
        surface += (data['Power(W)'][data.index[i]] +
                    data['Power(W)'][data.index[i+1]]) / 2 * (
                    data['Time(mS)'][data.index[i+1]] -
                    data['Time(mS)'][data.index[i]])
    surfaceJ = surface/1000 #Make it in Joule
    surfacekWh = surfaceJ/3600000 #Make it in kWh

    #Calculate Energy Consumption in kWh by using meter
    energyMeter = (data['Energy(kWH)'][data.index[-1]] -
                   data['Energy(kWH)'][data.index[0]])
    #remove weird trailing numbers
    energyMeter = round(energyMeter * 1000)/1000

    #Calculate average and median of power
    mean = data['Power(W)'].mean()
    median = data['Power(W)'].median()

    result.append((name, surfaceJ, surfacekWh, energyMeter,
                   mean, median, timeMs, timeString))

df = pandas.DataFrame.from_records(result, columns=labels)
df.to_csv('results.csv')
