import sys
import numpy as np
from scipy.signal import fftconvolve

if len(sys.argv) != 2:  # Script name + input
    print(f"Usage: {sys.argv[0]} <input.txt>")
    sys.exit(1)

# File names
input_file = sys.argv[1]
output_file = input_file.replace(".txt", "_convolved.txt")  # Simple name change

# Read arrays from text files
input = np.loadtxt(input_file)
RIR = np.loadtxt('RIR.txt')

# Convolve
output = fftconvolve(input,RIR,mode='full')

# Save
np.savetxt(output_file, output)
print(len(output))
