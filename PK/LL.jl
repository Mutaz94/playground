# This still work in progress
# Just dummy stuff. 
# Visually check log-likelihood 

# Define parameters

const K = 0.1
const V = 30

function one_com(θ, t, D)
   # θ[1] : V
   # θ[2] : KA
   # θ[3] : K
    C = D /θ[1] * θ[2]/(θ[2] - θ[3]) * (exp(-θ[3] * t) - exp(-θ[2] * t)) 
    return C
end

function LL(model, obs)
   return log(2π) + (obs - model)^2 
end 


LL = Vector{Float64}(undef, length(obs)) 
μ  = Vector{Float64}(undef, length(obs)) 

# Vectorize KA. 

for i in 1:length(obs)
    μ[i] = one_com([V, 
    LL[i] 


