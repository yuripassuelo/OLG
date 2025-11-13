
using Distributions
using Interpolations
using Optim

# Carregando Funções de outros scripts

script_paths = "./"

include( script_paths*"Parametros.jl" )
include( script_paths*"DiscProcess.jl" )
include( script_paths*"ProcessoRenda.jl" )
include( script_paths*"PrecosHugget.jl" )
include( script_paths*"Simulacao.jl" )
include( script_paths*"VFI.jl" )

# Preliminares:
# (I) Processo de Renda (Choques)

leLogGridV, leTrProbM, leProb1V = EarningProcess( np, ρ_1, σ_choq, nd, σ_1 )

leGridV = exp.( leLogGridV )

# Problema do Household/Consumidor:
# (1) Computa Oferta Agregada de trabalho
# (2) Chutes para Capital agregado (K) e transferências (T)
# (3) Dados Chutes computar preços r,w,b e τ
# (4) Dados preços resolver problema do Household/Consumidor
#       - Funções valor
#       - Funções politica
# (5) Dado problema do Household/Consumidor computar K e T
# (6) A partir do K e T calculado e os chutes calcular diferença
#       - dist = max( |K_0 - K|,|T_0 - T| ) 
#     Enquanto dist < ε ( ε = 1e-5 ) voltar ao passo (2)

# (1) Computa oferta agregada de Trabalho apartir da eficiência


# Simula Trajetórias de uma cadeia de Markov (Choques Idiossincráticos de Trabalho)

rvInv = rand( nSim, ageD )

eIdxM = MarkovChainSimulation( nSim, ageD, leProb1V, leTrProbM, rvInv )

# Computa Força de Trabalho efetiva
HHlaborM, L = LaborSupply_Hugget( eIdxM, ageEffV, ageMass, leGridV, nSim, ageD )

# Força de Trabalho

# (2) Chutes para Capital agregado (K) e tranferências (T)

K  = 56.430264399364560
T  = 0.902795718208179

# Dados Chutes de Capital, Transferências e Trabalho:

Y,R,w,b,τ = ComputaPrecos( A, K, L, α, δ, θ, AposMass )

# Mais elementos:

ageDeathMassV = ageMass .* d


# Teste Renda (Calculo)

IncomeTensor = ComputeIncome( kgrid, leGridV, ageEffV, age1, ageL, ageD, w, np, b, R, T )

# Computados os Preços Encontraremos Equilibrio.

function FindEquilibrium( A, K, L, T, α, δ, θ, nk, nw, np, leTrProbM, ageMass, AposMass, eIdxM, ageDeathMassV, popGrowth)
    # Inputs:
    #
    # Outputs:
    # (1) Função Politica de Poupança - kPolM
    # (2) Função Politica de Consumo  - cPolM
    # (3) Função Valor                - ValueM
    # (4) Simulação de k'             - kprimeHist
    # (5) Simulação de k              - kHist
    # (6) Capital Agregado            - K
    # (7) Transferências              - T
    # ------------------------------------------
    # Define Tolerância
    tol = 1e-5
    # Define iteração máxima
    max_it = 100
    # Define distância máxima
    dist = 10
    # Iteração
    it = 0
    # Lambda para correção/atualização dos parâmetros
    λ  = 0.98
    # Inicia algumas variaveis
    # Initialize output variables
    kPolM = nothing
    cPolM = nothing
    valueM = nothing
    kHist = nothing
    cHist = nothing
    kprimeHist = nothing
    # Começa a Iteração da Função Valor
    while dist >= tol && it < max_it
        # Iteração
        it = it + 1
        # Atualiza
        print( "Iteração: ", it," ; Distância: ", dist,"\n")
        # Atualiza/Calcula Preços
        Y,R,w,b,τ = ComputaPrecos( A, K, L, α, δ, θ, AposMass )
        # Computa Renda
        IncomeTensor = ComputeIncome( kgrid, leGridV, ageEffV, age1, ageL, ageD, w, np, b, R, T )
        # VFI
        valueM, cPolM, kPolM  = VFI( kgrid, cfloor, ageD, nk, nw, leTrProbM, IncomeTensor )
        # Simula as decisões para um numero de agentes
        kHist, cHist = SimulationOLG( kPolM, cPolM, eIdxM, ageD, nw )
        # Capital Novo
        K1 = sum( mean( kHist, dims = 1 ) * ageMass )
        K1 = max( 0.01, K1 )
        # Historico Simulado de k' (Poupança)
        kprimeHist = hcat( kHist[:, 2:end], zeros( size( kHist )[1] ) )
        # Transferências Calculadas
        T1 = (( mean( kprimeHist * R, dims = 1 ) * ageDeathMassV )/( 1 - popGrowth ))[1]
        # Calcula distância entre K e K1 e T e T1
        dist = max( abs.(K.-K1), abs.(T.-T1) )
        # Corrige Valores
        K = (λ^it)*K + (1-(λ^it))*K1
        T = (λ^it)*T + (1-(λ^it))*T1
    end
    
    return kPolM, cPolM, valueM, kprimeHist, kHist, cHist, K, T
end

# Resultados
res = FindEquilibrium( A, K, L, T, α, δ, θ, nk, nw, np, leTrProbM, ageMass, AposMass, eIdxM, ageDeathMassV, popGrowth)
