function res = energyRGB(I)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sum up the enery for each channel
dx = [-1 0 1; -1 0 1; -1 0 1]; % horizontal gradient filter 
dy = dx'; % vertical gradient filter
res = abs(conv2(I(:,:,1),dx,'same')) + abs(conv2(I(:,:,1),dy,'same')) + ...
abs(conv2(I(:,:,2),dx,'same')) + abs(conv2(I(:,:,2),dy,'same')) + ...
abs(conv2(I(:,:,3),dx,'same')) + abs(conv2(I(:,:,3),dy,'same'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

