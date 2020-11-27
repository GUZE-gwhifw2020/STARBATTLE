%% Birth Certificate
% ===================================== %
% DATE OF BIRTH:    2020.11.24
% NAME OF FILE:     StarBattleCase
% FILE OF PATH:     /StarBattle
% FUNC:
%   StarBattle类实例。
% ===================================== %
% clc

strTokenCase = '1,2,2,3,3,1,1,2,2,3,1,1,2,4,4,5,5,5,5,4,5,5,5,5,4';

tic
X = StarBattle(strTokenCase);

%%
X = X.Genesis();
X.resultM
toc