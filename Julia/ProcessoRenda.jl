
# Processo de Renda

function EarningProcess( np, ρ_p, σ_p, nd, normal_σ )
    # Inputs:
    # (1) Número de estados de choque    - np
    # (2) Persistencia do processo AR(1) - ρ_p
    # (3) Desvio padrão de ε_t do AR(1)  - σ_p
    # (4) Número de desvios padrões      - nd
    # (5) Desvio padrão da normal        - cs1
    # Outputs:
    # (1) Log de Grid dos estados   - logGridV
    # (2) Matriz de Transição       - trProbM
    # (3) Distribuição estacionária - prob1V
    # -----------------------------------------
    # Dados parâmetros discretiza processo AR(1)
    logGridV, trProbM = tauchen( np, ρ_p, σ_p, 0, nd )
    # Normaliza Grid
    prob1V, lbV, ubV = norm_grid( logGridV, logGridV[1]-2, logGridV[end]+2, 0, normal_σ ) 
    # Reescala Vetor
    logGridV = logGridV[:] .- logGridV[1] .- 1
    # Retorna objetos
    return logGridV, trProbM, prob1V
end


# Cria Tensor de Renda com Dimensão nk × nt × nw

function ComputeIncome( kgrid, leGridV, ageEffV, age1, ageL, ageD, w, np, b, R, T )
    # Inputs:
    # (1)  Grid de Capital   - kgrid
    # (2)  Vetor de Choques  - leGridV
    # (3)  Efficiencia Idade - ageEffV
    # (4)  Primeira Idade    - age1
    # (5)  Ultima Idade      - ageL
    # (6)  Idade efetiva     - ageD
    # (7)  Salarios          - w
    # (8)  Numero de         - np
    # (9)  Aposentadoria     - b
    # (10) Preco do Capital  - R
    # (11) Transferencias    - T
    # Outputs:
    # (1) Tensor de Renda    - TotIncExpanded
    # ----------------------------
    # Cria vetos Iota ( Sequencia de 1's )
    VetorsJK = ones( 1, length( kgrid ))
    VetorsJA = ones( 1, ageD )
    VetorsJS = ones( 1, np )
    # Renda do Trabalho
    TrabInc = ageEffV .* w .* leGridV' + vcat( zeros( ageA - age1+1, np ), ones( ageL - ageA, np ) )*b .+ T
    # Renda do Capital
    CapInc  = R * kgrid
    # Expande Renda do Trabalho em Formato de Tensor ( nt × nk × ns )
    TrabIncExpanded = reshape( kron( VetorsJK', TrabInc ), ageD, length( kgrid ), np )
    # Expande Renda do Capital em Formato de Tensor ( nt × nk × ns )
    CapIncExpanded  = reshape( kron( VetorsJS, (CapInc * VetorsJA)' ) , ageD, length( kgrid ), np )
    # Calcula Renda Total em Formato de Tensor ( nt × nk × ns )
    TotIncExpanded  = TrabIncExpanded .+ CapIncExpanded
    # Retorna Tensor de Renda
    return TotIncExpanded
end

# Computa Renda Versão 2

function HoldeHold_Inc( kV, leGridV, ageEffV, R, w, T, b, a, aR )
    # Inputs:
    # (1) Grid de Capital                    - kV
    # (2) Grid de choques                    - leGridV
    # (3) Produtividade efetiva do trabalho  - ageEffV
    # (4) Retorno Liquido de capital         - R
    # (5) Salarios                           - w
    # (6) Transferências                     - T
    # (7) Beneficio aposentadoria            - b
    # (8) Idade                              - a
    # (9) Idade de aposentadoria             - aR
    # Outputs:
    # (1) Matriz de Renda nk x nz            - IncomeM
    # -------------------------------------------------
    if a <= aR
        # Caso Nao aposentado
        WorkIncome = ageEffV[a] .* w .* leGridV' .+ T
    else
        # Caso Aposentado
        WorkIncome = b .* ones( 1, nw) .+ T
    end
    # Calcula Renda Total Baseada em Idade
    IncomeM = R * kV .* ones( length(kV),1) .+ WorkIncome
    # Retorna Renda
    return IncomeM
end
