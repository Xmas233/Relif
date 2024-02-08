function [W] = multiClassRelief(data, label, m, k)
    % 多分类relief算法实现
    % 输入:
    % data - 数据集，每一行是一个样本，每一列是一个特征
    % label - 标签向量
    % m - 选取的样本数
    % k - 最近邻的个数
    % 输出:
    % W - 特征权重向量

    [numSamples, numFeatures] = size(data);
    W = zeros(1, numFeatures); % 初始化特征权重为0
    uniqueLabels = unique(label); % 获取所有唯一的标签

    for i = 1:m
        % 随机选择一个样本
        randomIndex = randi(numSamples);
        sample = data(randomIndex, :);
        sampleLabel = label(randomIndex);

        % 初始化hit和miss数组
        hitSum = zeros(1, numFeatures);
        missSum = zeros(length(uniqueLabels)-1, numFeatures);

        for l = 1:length(uniqueLabels)
            currentLabel = uniqueLabels(l);
            if currentLabel == sampleLabel
                % 寻找同类最近邻
                sameClassIndices = find(label == currentLabel);
                distances = sum((data(sameClassIndices, :) - repmat(sample, length(sameClassIndices), 1)).^2, 2);
                [sortedDistances, sortedIndices] = sort(distances, 'ascend');
                if length(sortedIndices) > k
                    hitIndices = sameClassIndices(sortedIndices(2:k+1)); % 排除自己
                else
                    hitIndices = sameClassIndices(sortedIndices(2:end));
                end
                for j = 1:numFeatures
                    hitSum(j) = hitSum(j) + sum(abs(data(hitIndices, j) - sample(j)));
                end
            else
                % 寻找异类最近邻
                differentClassIndices = find(label == currentLabel);
                distances = sum((data(differentClassIndices, :) - repmat(sample, length(differentClassIndices), 1)).^2, 2);
                [sortedDistances, sortedIndices] = sort(distances, 'ascend');
                if length(sortedIndices) > k
                    missIndices = differentClassIndices(sortedIndices(1:k));
                else
                    missIndices = differentClassIndices(sortedIndices);
                end
                for j = 1:numFeatures
                    missSum(l, j) = missSum(l, j) + sum(abs(data(missIndices, j) - sample(j)));
                end
            end
        end

        % 更新权重
        for j = 1:numFeatures
            W(j) = W(j) - hitSum(j)/m/k + sum(missSum(:, j))/m/k/(length(uniqueLabels)-1);
        end
    end
end

