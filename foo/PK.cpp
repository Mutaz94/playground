#include <iostream>
#include <cmath>

#define CL 8.0
#define V 25.0
#define dose 500
#define ke (CL/V) 

// prototype 
double comp(double t); 


int main()
{

    double time[] = {0, 0.5, 1, 2};
    double y[4]; 

    for (int i = 0; i < 4; i++) {
        y[i] = comp(time[i]); 
        std::cout << y[i] << '\n';
    }

    return 0;
}

double comp(double t)
{
    return dose/V * exp(-ke * t); 
}
