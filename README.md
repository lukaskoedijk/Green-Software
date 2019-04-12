# Green-Software


To transfer files from das4 directory to das4 use:
scp [source] [destination] (Make sure you don't need to password for login by use of ssh-copy-id)
scp /Users/Lukas/Documents/Software\ Engeneering/Master\ Thesis/Green-Software/EnergyMeasurement/DAS4/[filename] lkoedijk@fs0.das4.cs.vu.nl:/home/lkoedijk

To set the right permission use: chmod 754 [filename]

To retrieve results from das5 use:
scp -r lkoedijk@fs0.das5.cs.vu.nl:/home/lkoedijk/results/* /Users/Lukas/Documents/Software\ Engeneering/Master\ Thesis/Green-Software/EnergyMeasurement/results
