% --------------------------------------------------------------------------------------------------
%
%    Demo software for quantify the visibility of traffic roads from video networks. 
%
%                   Release ver. 1.0  (May 14, 2023)
%
% --------------------------------------------------------------------------------------------
%
% authors:         Zhihuo Xu, Yuexia Wang, Linyi Zhou,  et al.
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
%Zhihuo Xu, Yuexia Wang, Linyi Zhou,  et al.,  First Visibility Sensing Benchmark for Intelligent Transportation Systems 
% using Traffic Video Networks: Dataset and Methodology
% IEEE Transactions on Intelligent Transportation Systems, Under Review.
% Thank you!

clc;clear;close all;

xds = signalDatastore('Features\');
yds = signalDatastore('Responses\');

len=length(xds.Files);

thr = 2e4;
SVDCal=-45*3.912*9;


for k=1:len
        load(cell2mat(xds.Files(k)));
        load(cell2mat(yds.Files(k)));
         x(k,1)={datain};
         y(k,1)={vis_data};

         intensity2_bk=datain(6,:);
         intensity1_bk=datain(5,:);
         idx=find(0>intensity2_bk);
        if(~isempty(idx))
            intensity2_bk(idx)=1e-3;
        end
        visibility_svd(k,:)= SVDCal./log(intensity2_bk./intensity1_bk);

        idx=find(thr<visibility_svd(k,:));
        if(~isempty(idx))
            visibility_svd(k,idx)=thr;
        end

end

  
numFeatures=8;

displayLabels = [ ...
    "Feature" + newline  + string(1:numFeatures), ...
    "Visibility" + newline+ "km"];
figure
tiledlayout(1,1)
for i = 1:1
    nexttile
    stackedplot([x{i}' 20*y{i}'],'LineWidth',2,DisplayLabels=displayLabels)
    xlabel("Time Step")
end


sel_k=1;
pdata=x{sel_k,1};
pdata(9,:)=y{sel_k,1};

PLotsConfigureON;

for k=1:9
    figure
    plot(pdata(k,:),'LineWidth',2);
    ylabel(['Feature ', num2str(k) ]);
    xlabel("Time Step");
    xlim([0 64]);
end

         
mu = mean([x{:}],2);
sig = std([x{:}],0,2);

load("vis_net_conv_lstm.mat");
load("vis_net_lstm.mat");


lw=1;
for k=1:len
        load(cell2mat(xds.Files(k)));
        load(cell2mat(yds.Files(k)));
        datain=(datain-mu) ./ sig;
        vis_data(vis_data > thr) = thr;
        vy(k,:)=vis_data;
        yp_lstm(k,:)=thr*predict(vis_net_lstm,datain);
        yp_conv_lstm(k,:)=thr*predict(vis_net_conv_lstm,datain);
end



for k=1:len
        xx=visibility_svd(k,:);
        yy=vy(k,:);
        tem= corrcoef(xx,yy);
         R(1,k)=tem(1,2);
        rho_Pearson(1,k)=corr(xx',yy','Type','Pearson','Rows','all');
        rho_Spearman(1,k)=corr(xx',yy','Type','Spearman','Rows','all');
        rmse(1,k)=sqrt(mean((xx-yy).^2));

        xx=yp_lstm(k,:);
         tem= corrcoef(xx,yy);
         R(2,k)=tem(1,2);
        rho_Pearson(2,k)=corr(xx',yy','Type','Pearson','Rows','all');
        rho_Spearman(2,k)=corr(xx',yy','Type','Spearman','Rows','all');
        rmse(2,k)=sqrt(mean((xx-yy).^2));
        xx=yp_conv_lstm(k,:);
         tem= corrcoef(xx,yy);
         R(3,k)=tem(1,2);
        rho_Pearson(3,k)=corr(xx',yy','Type','Pearson','Rows','all');
        rho_Spearman(3,k)=corr(xx',yy','Type','Spearman','Rows','all');
        rmse(3,k)=sqrt(mean((xx-yy).^2));

end

[r,c]=find(isnan(R));
if(~isempty(r))
    for k=1:length(r)
        R(r(k),c(k))=0.5;
        rho_Pearson(r(k),c(k))=0.5;
        rho_Spearman(r(k),c(k))=0.5;
    end
end

mean(R,2)

mean(rho_Pearson,2)

mean(rho_Spearman,2)

mean(rmse,2)


for k=1:len
        figure(2)
        plot( visibility_svd(k,:),'-.ko','LineWidth',lw);
        hold on
        plot(yp_lstm(k,:),':b v','LineWidth',lw);
        hold on
         plot(yp_conv_lstm(k,:),'--r pentagram','LineWidth',lw);
        hold on
        plot(vy(k,:),'LineWidth',lw);
        hold off
        ylim([0 thr+3e3]);xlim([0 length(vy(k,:))]);
        xlabel('Time step');ylabel("Visbility (m)")
        legend("SVD-Koschmieder's Law",'SVD-LSTM','SVD-Conv-LSTM',"Ground truth");
       pause(1.5)
end
