function [W] = relief(data, label, m, k)
    % relief算法实现
    % 输入:
    % data - 数据集，每一行是一个样本，每一列是一个特征
    % label - 标签向量
    % m - 选取的样本数
    % k - 最近邻的个数
    % 输出:
    % W - 特征权重向量

    [numSamples, numFeatures] = size(data);
    W = zeros(1, numFeatures); % 初始化特征权重为0

    for i = 1:m
        % 随机选择一个样本
        randomIndex = randi(numSamples);
        sample = data(randomIndex, :);
        sampleLabel = label(randomIndex);

        % 寻找k个最近邻的同类和异类样本
        distances = sum((data - repmat(sample, numSamples, 1)).^2, 2);
        [sortedDistances, sortedIndices] = sort(distances, 'ascend');
        
        hitIndices = sortedIndices(label(sortedIndices) == sampleLabel);
        missIndices = sortedIndices(label(sortedIndices) ~= sampleLabel);
        
        if length(hitIndices) > k + 1 % 排除自己
            hitIndices = hitIndices(2:k+1);
        else
            hitIndices = hitIndices(2:end);
        end
        
        if length(missIndices) > k
            missIndices = missIndices(1:k);
        end

        % 计算权重
        for j = 1:numFeatures
            hitDiff = sum(abs(data(hitIndices, j) - sample(j)));
            missDiff = sum(abs(data(missIndices, j) - sample(j)));
            W(j) = W(j) - hitDiff/m/k + missDiff/m/k;
        end
    end
end
