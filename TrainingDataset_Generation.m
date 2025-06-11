% --------------------------------------------------------------------------------------------------
%
%    Demo software for quantify the visibility of traffic roads from video networks. 
%
%                   Release ver. 1.3  (May 16, 2023)
%
% --------------------------------------------------------------------------------------------
%
% authors:           Zhihuo Xu, Yuexia Wang, Linyi Zhou,  et al.
%
% web page:       https://github.com/Z-H-XU/Benchmark-Visibility
%
% contact:           xuzhihuo@gmail.com
%
% --------------------------------------------------------------------------------------------
% Copyright (c) 2023 NTU.
% Nantong University, China.
% All rights reserved.
% This work should be used for nonprofit purposes only.
% --------------------------------------------------------------------------------------------
% If you use the dataset or the code, please kindly cite our paper:
% Yuexia Wang, Linyi Zhou, and Zhihuo Xu. "Traffic Road Visibility Retrieval in the Internet of Video Things through Physical Feature Based Learning Network."
% IEEE Transactions on Intelligent Transportation Systems,  vol. 26, no. 3, pp. 3629-3642, March 2025, doi: 10.1109/TITS.2024.3519137, https://ieeexplore.ieee.org/document/10817150. 
% Thank you!

clc; clear; close all;

basepath = cd();

load('ROI.mat');

roi_x=310:869;
roi_y=740:1299;


for d=1:29
    d
    if d<10
        day=['0',num2str(d),'-Feb-2020'];
        folderName=['/PublishedData/VideoFrame/Data2020020',num2str(d)];
    else
        day=[num2str(d),'-Feb-2020'];
        folderName=['/PublishedData/VideoFrame/Data202002',num2str(d)];
    end

    visfile=[basepath,'/PublishedData/GroundTruth/Vis-', day,'.mat'];
    load(visfile);

    file_dir=[basepath, folderName ];

    datain=featureGeneration(file_dir,roi_x,roi_y,roi1,roi2);
    save([basepath,'/Features/x_day',num2str(d),'.mat'],'datain');
    save([basepath,'/Responses/y_day',num2str(d),'.mat'],'vis_data');

end
