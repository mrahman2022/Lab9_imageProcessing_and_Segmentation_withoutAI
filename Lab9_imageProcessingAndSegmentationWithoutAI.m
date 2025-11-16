%% Lab: Tire Stud Detector
% Author: Md. Mahfuzur Rahaman
% Date: 2025-11-11
% Description:
% Detects whether a tire is studded or non-studded using image processing.

clear; clc; close all;

% ---------------------------------------------------------
% 1) Setup: define image files
% ---------------------------------------------------------
imageFiles = {'studded_tire.jpeg', 'summer_tire.jpg'};

for i = 1:numel(imageFiles)

    %% ---------- 2) Read & resize ----------
    I = imread(imageFiles{i});
    I = imresize(I, 0.5);  % optional scaling to make it smaller
    
    %% ---------- 3) Convert to grayscale ----------
    if size(I,3) == 3
        Igray = rgb2gray(I);
    else
        Igray = I;
    end

    %% ---------- 4) Create tire mask ----------
    % The tire is darker than the background, so use intensity threshold
    tireMask = Igray < 100;  % adjust threshold if needed
    tireMask = imfill(tireMask, 'holes');  % fill inner holes
    tireMask = bwareaopen(tireMask, 2000); % remove small background parts
    
    %% ---------- 5) Candidate studs (bright spots) ----------
    % Studs appear bright on the dark tire surface
    cand = (Igray > 160) & tireMask;  % only bright pixels inside tire
    cand = imopen(cand, strel('disk', 2));   % remove small noise
    cand = imclose(cand, strel('disk', 3));  % close small gaps

    %% ---------- 6) Connected components and measurements ----------
    CC = bwconncomp(cand);
    stats = regionprops(CC, 'Area', 'Perimeter', 'Eccentricity');

    %% ---------- 7) Filter valid studs ----------
    studMask = false(size(cand));
    studCount = 0;

    minA = 4;      % min area of a stud
    maxA = 120;    % max area of a stud
    minCirc = 0.6; % minimum circularity
    maxEcc = 0.85; % maximum eccentricity (close to circular)

    for k = 1:numel(stats)
        A = stats(k).Area;
        P = stats(k).Perimeter;
        E = stats(k).Eccentricity;
        if P == 0, continue; end
        circ = 4*pi*A / (P^2);

        if (A > minA) && (A < maxA) && (circ > minCirc) && (E < maxEcc)
            studMask(CC.PixelIdxList{k}) = true;
            studCount = studCount + 1;
        end
    end

    %% ---------- 8) Decision rule ----------
    tireArea = sum(tireMask(:));
    density = studCount / tireArea;
    isStudded = (studCount > 10) || (density > 0.0005);

    %% ---------- 9) Visualization ----------
    figure('Name', sprintf('Tire Analysis: %s', imageFiles{i}));

    subplot(1,3,1);
    imshow(I);
    title(sprintf('Input: %s', imageFiles{i}), 'Interpreter', 'none');

    subplot(1,3,2);
    imshow(cand);
    title('Candidate Studs (Binary)');

    subplot(1,3,3);
    imshow(I);
    hold on;
    visboundaries(studMask, 'Color', 'y', 'LineWidth', 0.8);

    if isStudded
        title(sprintf('STUDDED TIRE (Studs Detected: %d)', studCount), 'Color', 'g');
    else
        title(sprintf('NON-STUDDED TIRE (Studs Detected: %d)', studCount), 'Color', 'r');
    end

    fprintf('\nImage: %s\n', imageFiles{i});
    fprintf('Studs Detected: %d\n', studCount);
    fprintf('Density: %.6f\n', density);
    if isStudded
        fprintf('=> Classification: STUDDED TIRE ✅\n');
    else
        fprintf('=> Classification: NON-STUDDED TIRE ❌\n');
    end
end

