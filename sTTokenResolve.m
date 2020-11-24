function [gameSize,tokenMatrix] = sTTokenResolve(inputStr)
%STTOKENRESOLVE 字符串解析函数 - StarBattle
%% Birth Certificate
% ===================================== %
% DATE OF BIRTH:    2020.10.14
% NAME OF FILE:     tokenStrConvertStarBattle
% FILE OF PATH:     /StarBattle
% FUNC:
%   Convert the string extracted from HTML to the token matrix. Specially
%   for the game StarBattle.
% ===================================== %

%% Detailed Function
%   An example:
%   inputStr = '1,2,2,2,3,1,4,2,2,3,1,4,4,4,3,1,1,1,4,5,1,1,1,5,5';
%   tokenMatrix = [
%       1 1 1 1 1
%       2 4 4 1 1
%       2 2 4 1 1
%       2 2 4 4 5
%       3 3 3 5 5
%       ];

%%
% 按','分割字符串
strRevise = split(inputStr,',');

% 矩阵大小
gameSize = sqrt(length(strRevise));

% 确定矩阵大小为整数
if(mod(gameSize,1))
    error('Error:长度错误')
end

% token矩阵
tokenMatrix = reshape(cellfun(@str2double,strRevise),[gameSize gameSize]);

% 显示信息
fprintf('\n\t读取成功。 \n\t矩阵大小: %d \n',gameSize);

end

