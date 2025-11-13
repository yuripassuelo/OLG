function [kHistM, cHistM] = HHSimulation_olgm(kPolM, cPolM, eIdxM, cS)
%% Documentation:
% Simula uma população de households
% Ideia básica é
% (1). Criar um conjunto de "Individuos/Households"
% (2). Criar uma sequencia de dotação de trabalho dado eIdxM
% (3). Computar trajetórias de capital dos households baseado na função politica kPolM

% INPUTS:
% (1). kPolM: k' Função politica do capital, by [ik, ie, a]
% (2). cPolM: Função politica do consumo, by [ik, ie, a]
% (3). eIdxM: Dotação de trabalho para cada individuo simulado

% OUTPUTS:
% (1). kHistM: Trajetórias de capital para os households por [ind, age]
% (2). cHistM: Trajetórias de consumo para os households por [ind, age]


%% Validação Input
validateattributes(kPolM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
                   'size', [cS.nk,cS.nw,cS.aD]})

               
%% Simula trajetorias de capital e consumo por idade
nSim   = size(eIdxM, 1);
kHistM = zeros(nSim, cS.aD);
cHistM = zeros(nSim, cS.aD);

for a = 1 : cS.aD
    
   for ie = 1 : cS.nw
      % Encontra households com dotação de trabalho ie na idade a
      idxV = find(eIdxM(:,a) == ie);

      if ~isempty(idxV)
         if a < cS.aD
            % Find next period capital for each individual by interpolation
            kHistM(idxV, a+1) = interp1(cS.kGridV(:), kPolM(:,ie,a), ...
                                        kHistM(idxV, a), 'linear');
         end
         
         cHistM(idxV, a) = interp1(cS.kGridV(:), cPolM(:,ie,a), ...
                                   kHistM(idxV, a), 'linear');
      end % se idexV não está vazio

   end % para ie

end % para a



%% Validação Output
validateattributes(kHistM, {'double'}, {'finite', 'nonnan', 'nonempty', 'real', ...
                   '>', cS.kGridV(1) - 1e-6})

               
end