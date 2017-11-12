# 賴垣希 <span style="color:red">103061252</span>

# HW3 / Seam Carving for Content-Aware Image Resizing

## Overview
Seam carving is an algorithm for content-aware image resizing, it was described in the <a href="http://www.win.tue.nl/~wstahw/edu/2IV05/seamcarving.pdf">paper</a>
by S. Avidan & A. Shamir. In contract to stretching, content-aware resizing allows to remove/add pixels which has less meaning while saving more important.


## Implementation
1. EnergyRGB
	* Code
	```
	function res = energyRGB(I)
    dx = [-1 0 1; -1 0 1; -1 0 1]; % horizontal gradient filter 
    dy = dx'; % vertical gradient filter
    res = abs(conv2(I(:,:,1),dx,'same')) + abs(conv2(I(:,:,1),dy,'same')) + ...
    abs(conv2(I(:,:,2),dx,'same')) + abs(conv2(I(:,:,2),dy,'same')) + ...
    abs(conv2(I(:,:,3),dx,'same')) + abs(conv2(I(:,:,3),dy,'same'));
    end
	```
	* Description
    
	Since energy function e(I) = |dI/dx| + |dI/dy| , so the energy matrix will be adding energy of three colors together.
    
2. FindOptSeam
	* Code
	```
	function [optSeamMask, seamEnergy] = findOptSeam(energy)
    M = padarray(energy, [0 1], realmax('double'));
    sz = size(M);

    for i = 2:sz(1),
        for j = 2:sz(2)-1,
            M(i, j) = M(i, j) + min([M(i - 1, j - 1), M(i - 1, j), M(i - 1, j + 1)]);
        end
    end
    
    [val, idx] = min(M(sz(1), :));
    seamEnergy = val;
    fprintf('Optimal energy: %f\n',seamEnergy);

    optSeamMask = zeros(size(energy), 'uint8');

    for i = sz(1):-1:2,
        optSeamMask(i,idx-1)=1;
        [~,m] = min([M(i - 1, idx-1 ), M(i - 1, idx), M(i - 1, idx + 1)]);
        idx = idx + m - 2;
    end
    optSeamMask(1,idx-1)=1;

    optSeamMask = ~optSeamMask;
    
    end

	```
	* Description
    
	First calculate the seam matrix by adding the min number of three elements above with itself from energy matrix element-wise.
    Then find the smallest value at the last row and trace back to get a seam. Finally generate a mask matrix of that seam.
    
3. reduceImageByMask
    * Code
    ```
    function imageReduced = reduceImageByMaskVertical(image, seamMask)

    imageReduced = zeros(size(image, 1), size(image, 2) - 1, size(image, 3));
    
    for i = 1 : size(seamMask, 1)
        imageReduced(i, :, 1) = image(i, seamMask(i, :), 1);
        imageReduced(i, :, 2) = image(i, seamMask(i, :), 2);
        imageReduced(i, :, 3) = image(i, seamMask(i, :), 3);
    end
    
    end
    ```
    * Description
    
    This function is to reduce the image by the seam mask.

### Results

<table border=1>
<tr>
<th> Original Image</th>
<th> Image 2</th>
<th> Image 1 low freq</th>
<th> Image 2 high freq</th>
<th> Hybrid</th>
<th> Hybrid scales</th>
</tr>
<tr>
<td>
<img src="../data/dog.bmp"/>
</td>
<td>
<img src="../data/cat.bmp"/>
</td>
<td>
<img src="dog_low_frequencies.jpg"/>
</td>
<td>
<img src="cat_high_frequencies.jpg"/>
</td>
<td>
<img src="dog_hybrid_image.jpg"/>
</td>
<td>
<img src="dog_hybrid_image_scales.jpg"/>
</td>
</tr>

<tr>
<td>
<img src="../data/bicycle.bmp"/>
</td>
<td>
<img src="../data/motorcycle.bmp"/>
</td>
<td>
<img src="bike_low_frequencies.jpg"/>
</td>
<td>
<img src="motor_high_frequencies.jpg"/>
</td>
<td>
<img src="bike_hybrid_image.jpg"/>
</td>
<td>
<img src="bike_hybrid_image_scales.jpg"/>
</td>
</tr>
<tr>
<td>
<img src="../data/bird.bmp"/>
</td>
<td>
<img src="../data/plane.bmp"/>
</td>
<td>
<img src="bird_low_frequencies.jpg"/>
</td>
<td>
<img src="plane_high_frequencies.jpg"/>
</td>
<td>
<img src="bird_hybrid_image.jpg"/>
</td>
<td>
<img src="bird_hybrid_image_scales.jpg"/>
</td>
</tr>
<tr>
<td>
<img src="../data/einstein.bmp"/>
</td>
<td>
<img src="../data/marilyn.bmp"/>
</td>
<td>
<img src="einstein_low_frequencies.jpg"/>
</td>
<td>
<img src="marilyn_high_frequencies.jpg"/>
</td>
<td>
<img src="einstein_hybrid_image.jpg"/>
</td>
<td>
<img src="einstein_hybrid_image_scales.jpg"/>
</td>
</tr>
<tr>
<td>
<img src="../data/fish.bmp"/>
</td>
<td>
<img src="../data/submarine.bmp"/>
</td>
<td>
<img src="fish_low_frequencies.jpg"/>
</td>
<td>
<img src="submarine_high_frequencies.jpg"/>
</td>
<td>
<img src="fish_hybrid_image.jpg"/>
</td>
<td>
<img src="fish_hybrid_image_scales.jpg"/>
</td>
</tr>
</table>

