
using Distributions

# Funções para Discretização de processos autoregressivos
# Seja um processo autoregressivo:
# z_{t} = ρ z_{t-1} + ε_{t}


# Tauchen
# Em Tauchen aproximamos se baseando no fato de que ε_t ~ N( μ, σ )
# Usamos ....

function tauchen( N, ρ_p, σ_p, μ_p, n_std )
    # Inputs:
    # (1) Número de pontos que o processo será discretizado - N
    # (2) Persistência do processo auto regressivo - ρ
    # (3) Média do processos auto regressivo - μ
    # (4) Número de desvios padrões - n_std
    # Outputs:
    # (1) Vetor de valores discretizados - y
    # (2) Probabilidade de transição - trProb
    # ----------------------------------------------------------
    # Cria Grid discretizado
    y_bar = n_std*sqrt( σ_p^2/( 1- ρ_p^2 ) ) 
    y = LinRange( -y_bar, y_bar, N )
    # Cria distância
    dist = y[2] - y[1]
    # Cria matriz de transição
    trProb = zeros( N, N)
    # Cria objeto de distribuição Normal
    d = Distributions.Normal( 0, 1)
    # Preenche Matriz
    for i in range(1, N)
        trProb[ i, 1] = Distributions.cdf( d, (y[1] - ρ_p*y[i] + dist/2 )/σ_p )
        trProb[ i, N] = 1 - Distributions.cdf( d, (y[N] - ρ_p*y[i] - dist/2 )/σ_p )
        for j in range(2, N-1)
            trProb[ i,j ] = Distributions.cdf( d, (y[j] - ρ_p*y[i] + dist/2 )/σ_p ) - Distributions.cdf( d, (y[j] - ρ_p*y[i] - dist/2 )/σ_p )
        end
    end
    # Normaliza y
    y = y .+ μ_p/(1-ρ_p)
    # Retorna Vetor e Transição
    return [y;], trProb
end


# Rowenhorst

# Aqui pegamos a persistência do processo ρ e dai tiramos que:
# p = (1+ρ)/2
# q = (1+ρ)/2
# Pontos discretizados em y serão os mesmo conforme Tauchen

function row(N, p, q )
    # Inputs:
    # (1) Número de pontos de discretização - N
    # (2) Probabilidade - p ∈ (0,1)
    # (3) Probabilidade - q ∈ (0,1)  
    # Outputs:
    # (1) Matriz de Transição
    # -----------------------------------------
    # Caso base N = 2
    if N == 2
        # Matriz segue formato:
        # |  p  1-p |
        # | 1-q  q  |
        P = [ p  1-p ; 1-q  q ] 
    end
    # Caso N >=3
    if N >= 3
        # Utiliza Recursão
        Θ_n  = row( N-1, p , q )
        # Matriz zeros
        z_mt = zeros( N, N )
        z_m1 = copy( z_mt )
        z_m2 = copy( z_mt )
        z_m3 = copy( z_mt ) 
        z_m4 = copy( z_mt )
        # Cria Matrizes deslocadas
        z_m1[ 1:(N-1), 1:(N-1) ] = Θ_n
        z_m2[ 1:(N-1), 2:N ]     = Θ_n
        z_m3[ 2:N, 1:(N-1) ]     = Θ_n
        z_m4[ 2:N, 2:N ]         = Θ_n
        print( Θ_n )
        # Matriz que pondera
        P = p.*z_m1 + (1-p).*z_m2 + (1-q).*z_m3 + q.*z_m4
        # Corrige centro da matriz
        P[2:(N-1),:] = P[2:(N-1),:]/2
    end
    # Retorna matriz de transição P
    return P
end

# Normalização do Grid
# Aproxima distribuição normal em um Grid
# Apos discretizar o processo AR(1) colocamos a massa sobre o Grid
# Como alternativa podemos utilizar simplesmente a distribuição estacionario

function norm_grid( xV, xMin, xMax, μ_n, σ_n )
    # Input:
    # (1) Vetor de valores que densidade sera aproximada - xV
    # (2) Valor minimo do vetor xV - xMin
    # (3) Valor máximo do vetor xV - xMax
    # (4) Média da distribuição Normal - μ_n
    # (5) Desvio padrão da distribuição Normal - σ_n
    # Output:
    # (1) Massa do Grid (Concentração) - massV 
    # (2) Intervalo Inferior - lbV
    # (3) Intervalo Superior - ubV
    # ------------------------------------------
    # Pega comprimento do vetor xV
    n = length( xV )
    # Constroi Intervalos
    xMidV = 0.5 .* (xV[1:(n-1)] .+ xV[2:n])
    # Intervalo Inferior
    lbV = append!( [xMin], xMidV )
    # Intervalo Superior
    ubV = append!( xMidV, [xMax] )
    # Massa em Cada intervalo
    d = Distributions.Normal( μ_n, σ_n )
    cdfV = Distributions.cdf( d, append!( [xMin], ubV ) )
    # Massa no Vetor
    massV = cdfV[2:(n+1)] .- cdfV[1:n]
    massV = massV ./ sum( massV )
    # Retorna Limites e Massa
    return massV, lbV, ubV
end
