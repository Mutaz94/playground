#
# implementation of simple importance sampling 
#
#
using Distributions 

function f_x(x)
    """ function maps [-inf, inf] -> [0, 1] """
    return 1/(1 + exp(-x))
end


function dist_x(mu=0, sig=1)
    dist = Normal(mu, sig)
    return rand(dist) 
end 


const n = 10000

const mu_true = 5
const mu_appro = 4.8

const sigma_true = 1.5
const sigma_appro = 1 


let sv = 0

    for i = 1:n
        x = rand(Normal(mu_true, sigma_true))
        sv += f_x(x)
    end 

    println("Simulated value 1/n ∑ f(x) = $(sv/n)") 
end


# Sample from approximation
#
value = Vector{Float64}(undef, n)

for i = 1:n
    x = rand(Normal(mu_appro, sigma_appro))
    val = f_x(x) * (pdf(Normal(mu_true, sigma_true), x)/pdf(Normal(mu_appro, sigma_appro), x)) 
    value[i] = val 
end

println(" IMP  value 1/n ∑ f(x)p_x/q_x = $(sum(value)/n) ") 
