% --------------------------------------------------------------------------------------------------
%
%    Demo software for quantify the visibility of traffic roads from video networks. 
%
%                   Release ver. 1.0  (May 14, 2023)
%
% --------------------------------------------------------------------------------------------
%
% authors:           Zhihuo Xu, Yyuexia Wang, Linyi Zhou,  et al.
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
% If you use the code, please kindly cite the following paper:  
% Zhihuo Xu, Yyuexia Wang, Linyi Zhou,  et al.,  First Visibility Sensing Benchmark for Intelligent Transportation Systems 
% using Traffic Video Networks: Dataset and Methodology
% IEEE Transactions on Intelligent Transportation Systems, Under Review.
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
