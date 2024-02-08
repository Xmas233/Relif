clear
clc
[data] = readtable('ref.xlsx'); 
data = table2array(data);
label = data(:, 1);
data = data(:, 2:16);
[W] = relief(data, label, 700, 700);

% % 创建条形图
% bar(W)
% xlabel('特征编号')
% ylabel('权重值')
% title('特征权重可视化')

% 假设这是您的特征名称和对应的权重
featureNames = {'NDVI', 'Framland', 'Building', 'Mine Sites', 'Road', 'Fault', 'Lithology', 'Slope direction', 'DEM', 'Curvature', 'Valleys', 'Rainfall', 'Slope', 'TWI', 'Surface deformation'};
weights = W; % 随机生成一些权重值作为示例

% 对权重进行排序，并获取排序后的索引
[sortedWeights, sortOrder] = sort(weights, 'descend');
sortedFeatureNames = featureNames(sortOrder);

% 创建水平条形图
barh(sortedWeights, 'FaceColor', 'flat');

% 设置y轴的刻度标签为特征名称
yticks(1:length(sortedFeatureNames));
yticklabels(sortedFeatureNames);

% 反转y轴的方向，使得数值较大的条形位于顶部
set(gca, 'YDir', 'reverse');

% 设置x轴标签和图表标题
xlabel('Weight');
title('Feature Weights Visualization');

% 可选：为每个条形添加颜色
colormap(gca, jet(length(sortedFeatureNames)));

% 显示图表
figure(gcf);