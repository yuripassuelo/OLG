
# Computa preços dado inputs
function ComputaPrecos( A, K, L, α, δ, θ, AposMass )
    # Input:
    # (1) TFP (produtividade total dos fatores) A
    # (2) Capital agregado K
    # (3) Trabalho agregado L
    # (4) Proporção da remuneração no capital α
    # (5) Depreciação do capital δ
    # (6) Imposto sobre contribuição da aposentadoria θ
    # Output:
    # (1) Produto Agregado Y = A*(K^α)*(L^(1-α))
    # (2) Preço de Aluguel do Capital
    #     R = 1 + (MPK - δ)(1-τ)
    # (3) Salarios após Impostos
    #     w = MPL(1-τ-θ)
    # (4) Aposentadoria
    # (5) Impostos τ
    Y = A*(K^α)*(L^(1-α))
    # Produtividade
    MPK = α*A*(K^(α-1))*(L^(1-α))
    MPL = (1-α)*A*(K^α)*(L^(-α))
    # Impostos
    τ   = 0.195/(1-δ*K/Y)
    # Precos
    R = 1 + (MPK - δ)*(1-τ)
    w = MPL*( 1 - τ - θ )
    # Beneficios Sociais
    b = θ*w*L/AposMass
    # Retorna Valores
    return Y,R,w,b,τ
end
