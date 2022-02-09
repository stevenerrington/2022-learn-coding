# General linear model tutorial
# I started learning how to apply GLMs in Python through the Matthew Brett tutorial
# https://matthew-brett.github.io/teaching/glm_intro.html

# Import numerical and plotting libraries
import numpy as np
import numpy.linalg as npl
import matplotlib.pyplot as plt

# Only show 6 decimals when printing
np.set_printoptions(precision=6)


# Example data
psychopathy = [11.416,   4.514,  12.204,  14.835,
                8.416,   6.563,  17.343, 13.02,
                15.19 ,  11.902,  22.721,  22.324];

clammy = [0.389,  0.2  ,  0.241,  0.463,
            4.585,  1.097,  1.642,  4.972,
            7.957,  5.585,  5.527,  6.964];

age = [22.5,  25.3,  24.6,  21.4,
            20.7,  23.3,  23.8,  21.7,
            21.3, 25.2,  24.6,  21.8];

X = np.column_stack((np.ones(12), clammy))
B = npl.pinv(X).dot(psychopathy)

def my_best_line(x):
     # Best prediction for psychopathy given clamminess
     return B[0] + B[1] * x




# Plot figure
plt.plot(clammy, psychopathy, '+')
plt.xlabel('Clamminess of handshake')
plt.ylabel('Psychopathy score')
plt.show()

# 