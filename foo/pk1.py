#!/usr/bin/python

# DUMMY PROGRAM


import numpy as np 

def fn_pk_one(param, time):
    # BUILD FIRST ASSERTION
    for p in param:
        assert p > 0, f'parameter = {p} must be non-negative'

    # DEFINE PARAMETERS
    CL, V, DOSE = param
    ke = CL/V
    y = []

    for t in time:
        y.append(DOSE/V * np.exp(-ke * t))

    return y

def graph(Y, time):
    pass




if __name__ == "__main__":
    
    time = np.linspace(0, 12)
    param = [8, 25, 100]

    Y = fn_pk_one(param, time)

    print("TIME", "\t", "CONC\n")
    for i in range(len(Y)):
        print(time[i], "\t", Y[i], '\n') 
