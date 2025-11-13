
using Interpolations
using Optim

# Função para calculo da equação de Bellman

function Bellman( k_prime, y, Γ, R, σ, vPrimeInterp )
    # Inputs:
    # (1) Valor poupado (k')              - kPrime
    # (2) Valor esperado dado poupança k' - vPrime
    # Outputs:
    # (1) Consumo - c
    # (2) Função valor dado Utilidade + fluxo esperado
    # --------------------------------------------------------
    # Calcula Consumo não negativo
    c    = max( cfloor, y - k_prime[1] )
    # Calcula Utilidade do Consumo
    Util = U(c,σ)
    # Retorna V(a,z,t) = U(c) + βΓ_tE[V(a',z',t+1)]
    return -( Util + β*Γ*R*vPrimeInterp[ k_prime[1] ] ) 
end


# Função VFI

function VFI( kgrid, cfloor, ageD, nk, nw, leTrProbM, IncomeTensor )
    # Inputs:
    # (1)
    # (2)
    # Outputs:
    # (1) Função Valor             - valueM
    # (2) Função Politíca Consumo  - cPolM
    # (3) Função Politica Poupança - kPolM
    # ------------------------------------
    # Inicia vetores com dimensão nk x nw x 1:T
    valueM = zeros( nk, nw, ageD )
    cPolM  = zeros( nk, nw, ageD )
    kPolM  = zeros( nk, nw, ageD )
    # Para estimar OLG usamos Backwards Inductions
    for a in ageD:-1:1
        # Começa backwars Induction
        if a < ageD
            vPrime = valueM[:,:,a+1]
        # Caso idade seja exatamente igual a última não tem Função valor posterior
        else
            vPrime = []
        end
        # Inicia Iteração
        # Computa Renda para idade/K
        yM = IncomeTensor[a,:,:] #HoldeHold_Inc( kgrid, leGridV, ageEffV, R, w, T, b, a, aR ) #
        # Caso Estejamos na última idade sabemos que que vamos morrer logo Consumimos tudo
        if a == ageD
            cPolM[:,:,a]  = yM
            kPolM[:,:,a]  = zeros( nk, nw )
            valueM[:,:,a] = U.( cPolM[:,:,a],σ) 
        # Caso não seja a última idade então vamos ao calculo "Normal"
        else
            # Loop sobre os estados de Choque sobre a renda e sobre os Níveis de Capital
            for iw in 1:nw
                # Valor Esperado da proxima função Valor
                ExpValuePrime = zeros( nk, 1 )
                # Preenche valores
                for ik in 1:nk
                    ExpValuePrime[ ik ] = sum( leTrProbM[ iw, : ] .* vPrime[ik,:] )
                end
                # Interpolação de Grid
                vPrimeInterp = Interpolations.linear_interpolation( vcat(kgrid), vcat(ExpValuePrime)[:], extrapolation_bc = Line() )
                #
                for ik in 1:nk
                    # Define valor Máximo do Grid de Capital
                    kPrimeMax = min( kgrid[nk], yM[ik,iw] - cfloor )
                    # 
                    if kPrimeMax <= kgrid[1]
                        # Caso não tenha escolha factivel Consome o minimo [ Capital zero ou quase zero]
                        kPrime = kgrid[1]
                    else
                        # Encontra k prime ótimo
                        f_obj(k_prime) = Bellman([k_prime], yM[ik,iw], s[a], R, σ, vPrimeInterp)
                        Optim_Obj = optimize(f_obj, kgrid[1], kPrimeMax )
                        # Recupera k'
                        kPrime = Optim.minimizer( Optim_Obj )[1]
                    end
                    # Calcula Função Valor
                    c, ValueFun = yM[ik,iw] - kPrime, Bellman( kPrime, yM[ik,iw], s[a], R, σ, vPrimeInterp )
                    ValueFun    = -ValueFun
                    # Guarda Valores
                    cPolM[ik,iw,a]  = c 
                    kPolM[ik,iw,a]  = kPrime
                    valueM[ik,iw,a] = ValueFun
                end
            end
        end
    end
    # Retorna as matrizes
    return valueM, cPolM, kPolM 
end
