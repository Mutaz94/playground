# Ref: https://en.wikipedia.org/wiki/Gauss%E2%80%93Newton_algorithm

const n = 20 
const x = 11

global θ = 0  #  Initial guess for θ


# LogLikelihood of binomia distribution with θ being a natural parameters. score is the first derivative of LL(θ)
# and hess is the Hessian matrix (second derivative). 

function log_like(θ)
    if  θ <= 0
        return x * θ + log1p(exp(-θ))
    else
        return (x - n) * θ + log1p(exp(-θ))
    end
end



function score(θ)
    p = 1/(1 + exp(-θ))

    return x - n * p 
end 

function hess(θ)
    p = 1/(1 + exp(-θ))
    q = 1/(1 + exp(θ)) 

    return n * p * q
end 

function newton(θ, tol::Float64)
    delta = score(θ)/hess(θ)
    println("initial delta= ", delta) 
    println("initial θ= ", θ) 
    println("Initial OFV = ", log_like(θ))
    println("----------------------------") 


    j = 0
    θ₁ = 10
    while abs(θ - θ₁) > tol 
        j += 1
        delta = score(θ)/hess(θ)
        θ₁ = θ
        θ = θ₁ + delta
        println("ITERATION $j")
        println("θ =", θ)
        println("Score = ", score(θ))
        println("OFV = ", log_like(θ))
        println("=============================") 
    end 
end

newton(θ, 1e-14) 





