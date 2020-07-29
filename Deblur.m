% Author: Matthew Murray
% Description: Using the truncated Singular Value Decomposition to deblur
% an image
syms xTrueImage;
syms xBlurNoisyImage;
syms xNaiveSolution;
syms xTrunc;
syms truncScalar;
xTrueImage = reshape(xtrue, [],64);
xBlurNoisyImage = reshape(bn, [],64);
%plots the true image along with the blurred and noisy image
hold on
subplot(2, 1, 1);
image(xTrueImage);
title('True Image');
subplot(2, 1, 2);
image(xBlurNoisyImage);
title('Blurry and Noisy Image');
hold off
fig2 = figure;
xNaive = A\bn;
xNaiveSolution = reshape(xNaive,[],64);
%plots the naive solution, which is ignoring the fact that there is noise
%and solving x = A^(-1)b
hold on
xlim([0,64]);
ylim([0,64]);
image(xNaiveSolution);
title('Naive Solution for Deblurring');
hold off
fig3 = figure;
%approx 251.9968, which is much greater than 1 implying that the 
%error in the output is approximately 252 times larger than the
%input (ill-conditioned operation)
%commented out to save runtime
%disp(norm(A) * (1 / min(svd(A))))

kList = linspace(400, 3600, 9);
%Compute the SVD
[U,S,Vt] = svd(A);
sI = inv(S);
errors = zeros(1,9);
hold on;
for i = 1:9
   k = kList(i);
   Uk = U(:,1:k);
   Sk = sI(1:k, 1:k);
   Vk = Vt(:,1:k);
   xK = Vk * Sk * transpose(Uk) * bn;
   subplot(3,3,i);
   image(reshape(xK, [], 64));
   title("Truncated SVD at k = " + k);
   disp(k);
   errors(i) = (norm(xK - xtrue));
end
errors = errors ./ norm(xtrue);
hold off;
fig4 = figure;
hold on
plot(kList, errors);
hold off