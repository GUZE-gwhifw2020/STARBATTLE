%% Birth Certificate
% ===================================== %
% DATE OF BIRTH:    2020.11.24
% NAME OF FILE:     StarBattleCase
% FILE OF PATH:     /StarBattle
% FUNC:
%   StarBattle类实例。
% ===================================== %


strToken = '1,1,1,1,1,1,1,2,1,1,3,3,2,4,4,3,5,5,4,4,5,5,5,5,5';

X = StarBattle(strToken);

[indexS, ~] = X.surdUnit([2 4], 'S')