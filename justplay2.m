% 读取原始图像
img = imread('test.png');

% 在图像中随机生成一些坏点像素
num_bad_pixels = 1000;
[row, col, channel] = size(img);
bad_pixels = randi([1, row*col], [num_bad_pixels, 1]);

% 将坏点像素设置为 0
for i = 1:num_bad_pixels
    img(bad_pixels(i)) = 0;
end

% 显示原始图像和坏点图像
figure;
imshow(img);
title('Original image with bad pixels');


% 调整输入图像大小
inputSize = [638 1269];
img = imresize(img, inputSize);

% 构造深度学习模型
layers = [
    imageInputLayer([row, col, channel])
    convolution2dLayer(3, 64, 'Padding', 'same')
    reluLayer()
    batchNormalizationLayer()
    convolution2dLayer(3, 64, 'Padding', 'same')
    reluLayer()
    batchNormalizationLayer()
    maxPooling2dLayer(2, 'Stride', 2)
    dropoutLayer(0.5)
    convolution2dLayer(3, 128, 'Padding', 'same')
    reluLayer()
    batchNormalizationLayer()
    convolution2dLayer(3, 128, 'Padding', 'same')
    reluLayer()
    batchNormalizationLayer()
    maxPooling2dLayer(2, 'Stride', 2)
    dropoutLayer(0.2)
    convolution2dLayer(3, channel, 'Padding', 'same', ...
        'WeightsInitializer', 'narrow-normal', ...
        'BiasInitializer', 'zeros', ...
        'WeightL2Factor', 1e-8, ...
        'BiasL2Factor', 1e-8)
    regressionLayer()
];
options = trainingOptions('sgdm', 'InitialLearnRate', 0.1, 'MaxEpochs', 50, ...
    'MiniBatchSize', 32, 'Plots', 'training-progress');
net = trainNetwork(img,img,layers, options);

% 使用模型进行修复
reconstructed_img = predict(net, img);

% 显示修复后的图像
figure;
imshow(reconstructed_img);
title('Reconstructed image');

