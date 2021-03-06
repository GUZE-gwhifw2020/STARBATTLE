%% Birth Certificate
% ===================================== %
% DATE OF BIRTH:    2020.11.24
% NAME OF FILE:     StarBattle
% FILE OF PATH:     /StarBattle
% FUNC:
%   Main solution file for StarBattle.
% ===================================== %
classdef StarBattle
    %STARBATTLE StarBattle求解工程
    %   此处显示详细说明
    
    properties (Constant)
        uTypeUnN    = 0;        % 单元状态 - 不确定
        uTypeStar   = 1;        % 单元状态 - 星星
        uTypeCross  = -1;       % 单元状态 - 叉叉
        
        lTypeColumn = 1;        % 标签 - 列
        lTypeRow    = 2;    	% 标签 - 行
        lTypeBlock  = 3;     	% 标签 - 块
        
    end
    
    properties(Access = public)
        gSize           % 行列数/单元数
        tokenMatrix     % 题面矩阵
        
        indexCell       % 标签矩阵
        
        resultM         % 结果矩阵
    end
    
    methods
        function obj = StarBattle(strTokenArg)
            %STARBATTLE 构造此类的实例
            %   输入参数：TOKEN字符串
            
            % 题面大小与题面矩阵
            [obj.gSize,obj.tokenMatrix] = sTTokenResolve(strTokenArg);
            
            % 生成标签矩阵
            obj.indexCell = cell(3,obj.gSize);
            labelAuxMatrix = reshape(1:obj.gSize^2,[obj.gSize obj.gSize]);
            for ii = 1:obj.gSize
                obj.indexCell{obj.lTypeColumn,ii} = labelAuxMatrix(:,ii);
                obj.indexCell{obj.lTypeRow,ii} = labelAuxMatrix(ii,:)';
                obj.indexCell{obj.lTypeBlock,ii} = find(obj.tokenMatrix == ii);
            end
            
            % 结果矩阵
            obj.resultM = obj.uTypeUnN * ones(obj.gSize);
            
        end
        
        function obj = setCross(obj,index0,index1)
            %SETCROSS 设置叉属性
            %   输入参数：下标向量 - 横纵2*N向量或空向量
            narginchk(2,3)
            if(nargin == 2)
                indexA = index0;
                % 坐标下标向量
                indexS = zeros(2,length(index0));
                [indexS(1,:),indexS(2,:)] = ind2sub([obj.gSize obj.gSize],index0);
            elseif(nargin == 3)
                indexS = cat(1,index0,index1);
                % 一维下标向量
                indexA = sub2ind([obj.gSize obj.gSize],indexS(1,:),indexS(2,:));
            end
            
            for ii = 1:size(indexS,2)
                if(obj.resultM(indexA(ii)) == obj.uTypeUnN)
                    % 设置叉属性
                    obj.resultM(indexA(ii)) = obj.uTypeCross;
                    
                    % 在标签矩阵定位并删除
                    obj.indexCell{obj.lTypeRow,indexS(1,ii)}( ...
                        obj.indexCell{obj.lTypeRow,indexS(1,ii)} == indexA(ii)) = [];
                    
                    obj.indexCell{obj.lTypeColumn,indexS(2,ii)}( ...
                        obj.indexCell{obj.lTypeColumn,indexS(2,ii)} == indexA(ii)) = [];
                    
                    obj.indexCell{obj.lTypeBlock,obj.tokenMatrix(indexA(ii))}( ...
                        obj.indexCell{obj.lTypeBlock,obj.tokenMatrix(indexA(ii))} == indexA(ii)) = [];
                    
                elseif(obj.resultM(indexA(ii)) == obj.uTypeStar)
                    error('Error:检测到星位置写入叉。');
                end
            end
        end
        
        function obj = setStar(obj,index0,index1)
            %SETSTAR 设置星属性
            %   输入参数：下标向量 - 横纵2*N向量或空向量
            narginchk(2,3)
            if(nargin == 2)
                indexA = index0;
                % 坐标下标向量
                indexS = zeros(2,length(index0));
                [indexS(1,:),indexS(2,:)] = ind2sub([obj.gSize obj.gSize],index0);
            elseif(nargin == 3)
                indexS = cat(1,index0,index1);
                % 一维下标向量
                indexA = sub2ind([obj.gSize obj.gSize],indexS(1,:),indexS(2,:));
            end
            
            for ii = 1:size(indexS,2)
                if(obj.resultM(indexA(ii)) == obj.uTypeUnN)
                    % 设置星属性
                    obj.resultM(indexA(ii)) = obj.uTypeStar;
                    
                    % 周围与块清空为Cross
                    [indexASurd,~] = obj.surdUnit(indexS(:,ii),'S');
                    indexBlockTemp = obj.indexCell{obj.lTypeBlock,obj.tokenMatrix(indexA(ii))};
                    indexBlockTemp(indexBlockTemp == indexA(ii)) = [];
                    obj = obj.setCross([indexASurd;indexBlockTemp]);
                    
                    % 清空Cell
                    obj.indexCell{obj.lTypeRow,indexS(1,ii)} = [];
                    obj.indexCell{obj.lTypeColumn,indexS(2,ii)} = [];
                    obj.indexCell{obj.lTypeBlock,obj.tokenMatrix(indexA(ii))} = [];
                    
                elseif(obj.resultM(indexA(ii)) == obj.uTypeCross)
                    error('Error:检测到叉位置写入星。');
                end
            end
        end
        
        function [indexA, indexS, mask] = surdUnit(obj, index0, indexType)
            %SURDUNIT 返回四周与行列单元下标与掩模(不含自己)
            %   输入参数:   中心单元下标: 'A'-单下标; 'S'-坐标下标
            assert((strcmpi(indexType, 'A') && isscalar(index0)) || ...
                (strcmpi(indexType, 'S') && length(index0) == 2));
            
            % 转换为坐标向量(列向量)
            if(strcmpi(indexType, 'A'))
                indexS0 = [0;0];
                [indexS0(1),indexS0(2)] = ind2sub([obj.gSize obj.gSize],index0);
            elseif(strcmpi(indexType, 'S'))
                indexS0 = index0(:);
            end
            if(nargout == 3)
                % ============== 方式一 =============== %
                % 新建一个大小(gSize+2, gSize+2)的矩阵避免冲突问题
                mT = false(obj.gSize + 2);
                mT(indexS0(1) + 1, :) = true;
                mT(:, indexS0(2) + 1) = true;
                mT(indexS0(1) + 1 + (-1:1), indexS0(2) + 1 + (-1:1)) = true;
                mT(indexS0(1) + 1, indexS0(2) + 1) = false;
                % 取中间部分
                mask = mT(2:end-1,2:end-1) == true;
                indexA = find(mask);
                indexS = zeros(2, length(indexA));
                [indexS(1,:),indexS(2,:)] = ind2sub([obj.gSize obj.gSize], indexA);
            elseif(nargout == 2)
                % ============== 方式二 =============== %
                % 主要问题集中在四顶角
                b4s = true(2);
                if(indexS0(1) == 1)
                    b4s(1,:) = false;
                elseif(indexS0(1) == obj.gSize)
                    b4s(2,:) = false;
                end
                if(indexS0(2) == 1)
                    b4s(:,1) = false;
                elseif(indexS0(2) == obj.gSize)
                    b4s(:,2) = false;
                end
                % 行列直接写入
                indexS = zeros(2, 2 * obj.gSize - 2);
                indexS(1,:) = [repmat(indexS0(1),[1 obj.gSize-1]) 1:(indexS0(1)-1) (indexS0(1)+1):obj.gSize];
                indexS(2,:) = [1:(indexS0(2)-1) (indexS0(2)+1):obj.gSize repmat(indexS0(2),[1 obj.gSize-1])];
                % 顶角的单元
                b4I = [-1 1 -1 1;-1 -1 1 1];
                indexS = cat(2, indexS, indexS0 + b4I(:,b4s));
                indexA = sub2ind([obj.gSize obj.gSize], indexS(1,:)', indexS(2,:)');
                
            end
        end
        
        function indexAStar = starSeek(obj)
            %STARSEEK 寻找星位置
            % 寻找每一块/列/行中残余为1的单元
            id2 = cellfun(@length, obj.indexCell) == 1;
            indexAStar = cell2mat(obj.indexCell(id2));
            
        end
        
        function indexACross = crossSeek(obj,lType,ii)
            %CROSSSEEK 寻找叉位置
            % 掩模初始化
            mask = true(obj.gSize);
            switch(lType)
                case obj.lTypeBlock
                    mask = obj.tokenMatrix ~= ii;
                case obj.lTypeRow
                    mask(ii,:) = false;
                case obj.lTypeColumn
                    mask(:,ii) = false;
            end
            
            % 对内部位置未知方格进行周围掩模求解
            indexAUnN = find(~mask & obj.resultM == obj.uTypeUnN);
            if(isempty(indexAUnN))
                indexACross = [];
            else
                for ii = 1:length(indexAUnN)
                    [~,~,maskTemp] = obj.surdUnit(indexAUnN(ii),'A');
                    mask = mask & maskTemp;
                end
                indexACross = find(mask);
            end
        end
        
        
        function obj = Genesis(obj)
            %GENESIS 求解主工程
            
            % 主循环
            iter = 1;
            while(iter < 10 && any(obj.resultM == obj.uTypeUnN,'all'))
                
                
                iter = iter + 1;
                
                for ii = 1:obj.gSize
                    % 对每一个块进行屏蔽点寻找
                    obj = obj.setCross(obj.crossSeek(obj.lTypeBlock, ii));
                end
                for ii = 1:obj.gSize
                    % 对每一个行进行屏蔽点寻找
                    obj = obj.setCross(obj.crossSeek(obj.lTypeRow, ii));
                    
                end
                for ii = 1:obj.gSize
                    % 对每一个列进行屏蔽点寻找
                    obj = obj.setCross(obj.crossSeek(obj.lTypeColumn, ii));
                end
                
                % 寻找并写入星位置
                indexAStar = obj.starSeek();
                obj = obj.setStar(indexAStar);
                
                iter
            end
        end
        
    end
end

