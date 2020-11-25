%% Birth Certificate
% ===================================== %
% DATE OF BIRTH:    2020.11.24
% NAME OF FILE:     StarBattleCase
% FILE OF PATH:     /StarBattle
% FUNC:
%   StarBattle类实例。
% ===================================== %
clc

strToken = '1,1,1,1,1,1,1,2,1,1,3,3,2,4,4,3,5,5,4,4,5,5,5,5,5';

X = StarBattle(strToken);
X.indexCell
X.setCross(5,5);
X.setStar([1 1 1 1],[1 1 1 1])
X.indexCell