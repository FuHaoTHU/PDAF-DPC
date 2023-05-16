function restoredImg = LPA(image, maskSize)
% image: 待处理图像
% maskSize: 控制掩模大小的参数，一般为奇数，默认为3

if nargin < 2 || isempty(maskSize)
    maskSize = 3;
end



% 获取图像大小和通道数
[height, width, channels] = size(image);

% 定义修复后的图像
restoredImg = zeros(height, width, channels);

% 构建掩模
halfMaskSize = floor(maskSize/2);
[x, y] = meshgrid(-halfMaskSize:halfMaskSize);
mask = exp(-(x.^2 + y.^2)/(2*(maskSize/3)^2)); % 高斯加权掩模

% 对每个通道进行修复
for k = 1:channels
    % 遍历图像中所有像素，寻找缺失位置
    for i = 1:height
        for j = 1:width
            if isnan(image(i,j,k))
                % 计算掩模内像素的坐标
                x_min = max(1, i-halfMaskSize);
                x_max = min(height, i+halfMaskSize);
                y_min = max(1, j-halfMaskSize);
                y_max = min(width, j+halfMaskSize);
                
                % 拟合局部多项式逼近函数
                [xx, yy] = meshgrid(x_min:x_max, y_min:y_max);
                xi = [yy(:), xx(:)];
                yi = image(x_min:x_max, y_min:y_max, k);
                p = polyfitn(xi, yi, 1);
                
                % 计算缺失位置的像素值
                x_current = j - y_min + 1;
                y_current = i - x_min + 1;
                restoredImg(i,j,k) = polyvaln(p, [y_current, x_current]);
                
                % 加权平均
                weights = mask((i-x_min+1)-halfMaskSize:(i-x_min+1)+halfMaskSize, ...
                    (j-y_min+1)-halfMaskSize:(j-y_min+1)+halfMaskSize);
                weights(restoredImg(x_min:x_max, y_min:y_max, k) == 0) = 0; % 忽略未修复像素的权重
                weights = weights./sum(weights(:));
                restoredImg(i,j,k) = sum(sum(image(x_min:x_max, y_min:y_max, k).*weights));
            else
                % 非缺失位置直接复制
                restoredImg(i,j,k) = image(i,j,k);
            end
        end
    end
end

% 将图像还原到[0,1]范围


end