
using Interpolations

# Simula Cadeia de Markov
# Pegamos a matriz de Transição do processo AR(1) e Acumulamoas
# Chutamos valores Iniciais para cada uma das simulações que podem estar entre 1 e n (N a posição da matriz)
# A partir disse vamos sorteando valores de uma Uniforma(0,1) e vemos em que posição esse valor sorteado está dentro da matriz acumulada
# repetimos o procedimento varias vezes e obtemos a cadeia de markov simulada

function MarkovChainSimulation( nSim, T, leProb1V, leTrProbM, rvInv )
    # Inputs:
    # (1) Numero de simulações realizadas                       - nSim
    # (2) Período de simulação (Ciclo de Vida Simulado em anos) - T
    # (3) Probabilidade Inicial                                 - prob0V
    # (3) Matriz de transição                                   - trProbM
    # (4) Variável Aleatória?                                   - rvInv
    # Outputs:
    # (1) Dotação de Trabalho Simulada                          - eIdxM
    # -------------------------------------------------------------
    # Acumulando Probabilidades Matriz de Transição
    mat_shape = size( leTrProbM' )
    CumTrMat  = [ cumsum( leTrProbM[i,:] ) for i in range( 1, mat_shape[1]  )]
    # Preenche ultima Coluna com 1's
    for line in CumTrMat
        line[ mat_shape[1] ] = 1.0
    end
    # Cria Matriz de Dimensão nSim por T
    eIdxM     = zeros( nSim, T )
    # Preenche matriz simulada
    eIdxM[ :, 1 ] = 1 .+ sum( ( rvInv[:,1].*ones( 1,mat_shape[1] ) ) .> ( ones( nSim, 1 ) .*cumsum( leProb1V  )' ), dims = 2)
    # Preenche Matriz simulada
    for i in range(1, T-1)
        eIdxM[ :, i+1 ] = 1 .+ sum( ( rvInv[:,i+1].*ones( 1,mat_shape[1] ) ) .> stack( CumTrMat[ Int.( eIdxM[:,i] ), : ], dims = 1), dims = 2)
    end
    # Retorna Simulação
    return eIdxM
end

# Oferta de Trabalho

function LaborSupply_Hugget( eIdxM, ageEffV, ageMass, leGridV, nSim, Ts )
    # Inputs:
    # (1) Séries simuladas de choques  - eIdxM
    # (2) Massa de Individuos na idade - AgeMass
    #
    # Outputs:
    # (1) Oferta por idade             - HHlaborM
    # (2) Força de trabalho total      - L
    # ------------------------------------------
    # Cria matriz de zeros ( nSim x T )
    HHlaborM = zeros( nSim, Ts )
    # Preenche Matriz ( Matriz preenchida por choque de Renda ε × Produtividade Effetiva (por idade t) )
    for i in range(1, Ts) 
        HHlaborM[ :, i] = ageEffV[i] .* leGridV[ Int.(eIdxM[:,i]) ] 
    end
    # Trabalho Agregado
    L = mean( HHlaborM, dims = 1) * ageMass
    # Retorna Oferta de trabalho
    return HHlaborM, L[1,1]
end

# Simulação Ciclo de Vida HouseHolds

function SimulationOLG( kPolM, cPolM, eIdxM, ageD, nw )
    # Inputs:
    # (1) Função Politica de Capital        - kPolM
    # (2) Função Politica de Consumo        - cPolM
    # (3) Simulação de Choques para agentes - eIdxM
    # Outputs:
    # (1) Simulação de Poupança - kHistM
    # (2) Simulação de Consumo  - cHistM
    # ---------------------------------------------
    # Cria Matrizes para armazenar resultados da simulação
    nSim   = size( eIdxM )[1]
    kHistM = zeros( nSim, size( eIdxM )[2] )
    cHistM = zeros( nSim, size( eIdxM )[2] )
    # Indice
    rowIdx = 1:1:nSim
    # Preenche Matriz
    for a in 1:1:ageD
        for z in 1:1:nw 
            # Indices
            idxV = rowIdx[ eIdxM[:,a] .== Float64( z ) ]
            # Checa se Incides são Preenchidos
            if !isempty( idxV )
                if a < ageD
                    # Prepara Interpolação para k'
                    interp_k = Interpolations.linear_interpolation( vcat(kgrid), kPolM[:,z,a], extrapolation_bc = Line() )
                    # Preenche Matriz de Capital
                    kHistM[ idxV, a+1 ] = interp_k[kHistM[idxV, a]] 
                end
                # Prepara Interpolação para c
                interp_c = Interpolations.linear_interpolation( vcat(kgrid), cPolM[:,z,a], extrapolation_bc = Line() )
                # Preenche Matriz de Consumo
                cHistM[ idxV, a ] = interp_c[kHistM[idxV, a]]
            end            
        end
    end
    # Retorna Simulação de Poupança e Consumo
    return kHistM, cHistM
end
