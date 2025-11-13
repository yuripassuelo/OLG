
using Plots
using Distributions

# Objeto Struct para parametrização do modelo

age1  = 20
ageL  = 98
ageA  = 65 

ageD  = ageL - age1 + 1
ageR  = ageA - age1 + 1

# Parametros de Demografia
popGrowth  = 0.012

# Probabilidade de Sobrevivência (Jordan, 1975)
d = [0.00159, 0.00169, 0.00174, 0.00172, 0.00165, 0.00156, 0.00149, 0.00145, 0.00145, 0.00149,
     0.00156, 0.00163, 0.00171, 0.00181, 0.00193, 0.00207, 0.00225, 0.00246, 0.00270, 0.00299,
     0.00332, 0.00368, 0.00409, 0.00454, 0.00504, 0.00558, 0.00617, 0.00686, 0.00766, 0.00865,
     0.00955, 0.01058, 0.01162, 0.01264, 0.01368, 0.01475, 0.01593, 0.01730, 0.01891, 0.02074,
     0.02271, 0.02476, 0.02690, 0.02912, 0.03143, 0.03389, 0.03652, 0.03930, 0.04225, 0.04538,
     0.04871, 0.05230, 0.05623, 0.06060, 0.06542, 0.07066, 0.07636, 0.08271, 0.08986, 0.09788,
     0.10732, 0.11799, 0.12895, 0.13920, 0.14861, 0.16039, 0.17303, 0.18665, 0.20194, 0.21877,
     0.23601, 0.25289, 0.26973, 0.28612, 0.30128, 0.31416, 0.32915, 0.34450, 0.36018]

# Probabilidade de morte
s = 1 .- d

# Massa de Households por Idade

ageMass = ones(1, ageD )[1,:]

for i in 2:ageD
    ageMass[ i ] = ageMass[ i - 1] * s[ i-1 ]/(1+popGrowth )
    print( ageMass[i], "\n")
end


ageMass = ageMass ./ sum( ageMass )

AposMass = sum( ageMass[ (ageA - age1 + 2 ):(ageL - age1 + 1)] )

# Massa de aposentados

# Parâmetros Houselhold
σ   = 1.5
β   = 1.011
        
cfloor  = 0.05
nSim    = 50000

# Parametros Tecnologia
A  = 0.895944
α  = 0.36
δ  = 0.06 

# Seguridade Social
θ  = 0.1

# Trabalho

# Choque Renda Formal
σ_1     = 0.38^0.5
σ_choq  = 0.045^0.5
ρ_1     = 0.96
# Choque Renda Informal

# Quatro Desvios e 7 pontos
nd     = 4
np     = 7
nw     = np
# Grids
tgKY   = 3
tgWage = (1-α)*A*(tgKY/A)^(α/(1-α))
nk     = 250
kMin   = 0
kMax   = 300
kgrid  = LinRange( kMin, kMax, nk )

# Definição de funções

# Utilidade
@inline U(c,σ) = (c.^(1-σ))./(1-σ)

# Produção
F(k,α) = A*k^α

# Eficiência do trabalho
ageEffV = append!( [LinRange( 0.30, 1.25, 12 );],
                   [LinRange( 1.30, 1.50, 6  );],
                   [LinRange( 1.50, 1.50, 11 );],
                   [LinRange( 1.49, 1.05, 11 );],
                   [LinRange( 1.00, 0.10, 9  );],
                   [LinRange( 0.08, 0.00, 5  );],
                   [zeros( 1, ageD - 54);])

ageEffV = exp.( log( 0.5289 ) .+ log.( ageEffV ) )
