using Turing 
using DifferentialEquations 
using Plots
using StatsPlots 



function one_comp(du, u, p, t) 
    cl, v, ka = p 

    @inbounds begin
        du[1] = - ka * u[1]
        du[2] = (ka * u[1])/v - (cl/v) * u[2]
    end 
   # y = u[2]/v 

    return nothing 
end 

# simulations 
u0 = [500, 0.0]; 
θ  = [8.0, 25.0, 1.5]; 
interval = (0, 24); 

prob = ODEProblem(one_comp, u0, interval, θ); 

# Create observed concentrations

const sample_times = [0,0.5, 1, 1.5, 2, 4, 6, 8, 12, 24]; 

sol = solve(prob, Tsit5(),saveat=sample_times) 

predicted = Array(sol)[2, :] ; # Its divided by V to obtain concentrations 

ϵ = rand(Normal(0, 0.15), length(predicted)); 
obs = predicted .+ predicted .* ϵ; 
# scatter(predicted, obs) 
# Sanity check 


# plot(sample_times, predicted, lab="Predicted")
# scatter!(sample_times, obs, lab = "Observed" )

# Define Turing model 
# Check units as it sounds there is incons
@model function one_comp(obs, times, prob) 
    # define prior information 
    σ ~ truncated(Cauchy(0.0, 0.5), 0.0, 2.0) 
    
    # define individual 
    Ka ~ LogNormal(log(1.5), 0.3)
    V  ~ LogNormal(log(25.), 0.3) 
    CL ~ LogNormal(log(8.), 0.3) 

    θ = [CL, V, Ka] 
    
    pred_pb = remake(prob, p = θ)
    pred  = solve(pred_pb,Tsit5(), saveat=times) 
    pred_conc = Array(pred)[2, :]    

    for i = 1:length(pred_conc)
        obs[i] ~ LogNormal(log(max(pred_conc[i], 1e-10)), σ) 
    end 
end 


model = one_comp(obs, sample_times, prob) 
chain = sample(model, HMC(0.1, 5), MCMCSerial(), 1500, 3)
# plot(chain) 




