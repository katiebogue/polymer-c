function polymerstatheatmap(ltvar,lookuptab,FH2_dist,type1,calcTF,saveTF,savefigfolder,limits,expplt,maxNT,maxCT,minNT,minCT,xcord,ycord,plotprms,epsilon)
%POLYMERSTATHEATMAP creates heatmaps of a lookuptable variable wrt PRM
%location
%
% fig =POLYMERSTATHEATMAP(ltvar,lookuptab,FH2_dist,type1,calcTF,saveTF,savefigfolder,limits,expplt,maxNT,maxCT,minNT,minCT,xcord,ycord,plotprms,epsilon)
% 
% Inputs:
%       ltvar           : (String) the lookup table variable to plot 
%       lookuptab       : (Lookuptable) lookuptable object to pull values
%                       from
%       FH2_dist        : (String) FH2 size to label (and use for prvec
%       calc if applicable)
%       type1           : (String) kpoly type (3st, 4st)
%       calcTF          : (Bool) Whether to use equations rather than pull from the lookuptable (default is false)
%       saveTF          : (Bool) Whether to save the figure (default is false)
%       savefigfolder   : (String) Location to save the figure to (default
%       is "")
%       limits          : Heatmap label limits (of the form [a b]) (default
%       is no limits)
%       expplt          : (Experiment) Experiment object containing formins
%       to overplot PRM locations (no plotting if no Experiment is given)
%       maxNT           : Max distance from PRM to NT to plot (default is 300)
%       maxCT           : Max distance from PRM to CT to plot (default is 300)
%       minNT           : Min distance from PRM to NT to plot (default is 0)
%       minCT           : Min distance from PRM to CT to plot (default is 5)
%       xcord           : x coordinate of delivery location, only valid if calcTF=True and ltvar="Prvec0" (default is 0)
%       ycord           : y coordinate of delivery location, only valid if calcTF=True and ltvar="Prvec0" (default is 0)
%       plotprms        : (Bool) whether or not to overplot example PRM
%       locations (default is true)
%       epsilon         : epsilon value for computing pocc, only valid if calcTF=True and ltvar="POcclude" (default is 1)
%
%   Loads customcolorbar_red_blue.mat
% 
% See also LOOKUPTABLE, PR.
arguments
    ltvar
    lookuptab
    FH2_dist
    type1
    calcTF =false
    saveTF =false
    savefigfolder=""
    limits=0
    expplt=0
    maxNT=300
    maxCT=300
    minNT=0
    minCT=5
    xcord=0
    ycord=0
    plotprms=1
    epsilon=1
end
set(groot,'defaultfigureposition',[400 250 900 750])
fig=figure;

if calcTF
    if ltvar=="POcclude"
        if type1=="single" || type1=="double"
            nCT=maxCT-minCT+1;
            nNT=maxNT-minNT+1;
            msize=nCT*nNT;
            FH2_dists=zeros(1, msize);
            NT_dists=zeros(1,msize);
            vals=zeros(1,msize);
            index=0;
            for FH2dist=minCT:maxCT
                for NT_dist=minNT:maxNT
                    index=index+1;
                    FH2_dists(1,index)=FH2dist;
                    NT_dists(1,index)=NT_dist;
                    vals(1,index)=poccc(FH2dist,FH2dist+NT_dist,type1,1,2.25,epsilon);
                end
            end
            tab= table((1-vals)',FH2_dists', NT_dists');
            ltvar="1-Pocc";
        else
            error("No equation for POcclude other than single or double")
        end
    elseif ltvar=="Prvec0"
        nCT=maxCT-minCT+1;
        nNT=maxNT-minNT+1;
        msize=nCT*nNT;
        FH2_dists=zeros(1, msize);
        NT_dists=zeros(1,msize);
        vals=zeros(1,msize);
        index=0;
        for FH2dist=minCT:maxCT
            for NT_dist=minNT:maxNT
                index=index+1;
                FH2_dists(1,index)=FH2dist;
                NT_dists(1,index)=NT_dist;
                vals(1,index)=pr(FH2dist,FH2dist+NT_dist,str2double(FH2_dist),1,xcord,ycord,type1,false);
            end
        end
        tab= table(log10(vals)',FH2_dists', NT_dists');
    end

else
    dimer_tab=lookuptab.stattable(ltvar,"dimer");
    dimer_tab.a=dimer_tab.a((dimer_tab.a(:,2)<=maxCT),:);
    dimer_tab.a=dimer_tab.a( ((dimer_tab.a(:,1)-dimer_tab.a(:,2)) <=maxNT),:);
    dimer_tab.a=dimer_tab.a((dimer_tab.a(:,2)>=minCT),:);
    dimer_tab.a=dimer_tab.a( ((dimer_tab.a(:,1)-dimer_tab.a(:,2)) >=minNT),:);
    double_tab=lookuptab.stattable(ltvar,"double");
    double_tab.a=double_tab.a((double_tab.a(:,2)<=maxCT),:);
    double_tab.a=double_tab.a( ((double_tab.a(:,1)-double_tab.a(:,2)) <=maxNT),:);
    double_tab.a=double_tab.a((double_tab.a(:,2)>=minCT),:);
    double_tab.a=double_tab.a( ((double_tab.a(:,1)-double_tab.a(:,2)) >=minNT),:);
    if type1=="single"
        single_tab=lookuptab.stattable(ltvar,"single");
        single_tab=single_tab((single_tab(:,2)<=maxCT),:);
        single_tab=single_tab( ((single_tab(:,1)-single_tab(:,2)) <=maxNT),:);
        single_tab=single_tab((single_tab(:,2)>=minCT),:);
        single_tab=single_tab( ((single_tab(:,1)-single_tab(:,2)) >=minNT),:);
    end
    if ltvar=="POcclude"
        dimer_1minus=1-dimer_tab.a(:,3);
        double_1minus=1-double_tab.a(:,3);
        if type1=="single"
            single_1minus=1-single_tab(:,3);
        end
        if type1=="ratio"
            ratio_tab=log10(dimer_1minus./double_1minus);
        elseif type1=="dimer"
            ratio_tab=dimer_1minus;
        elseif type1=="double"
            ratio_tab=double_1minus;
        elseif type1=="single"
            ratio_tab=single_1minus;
        end
        ltvar="1-Pocc";
        tab= table(1.*(ratio_tab),dimer_tab.a(:,2), dimer_tab.a(:,1)-dimer_tab.a(:,2));
    else
        if type1=="ratio"
            ratio_tab=dimer_tab.a(:,3)./double_tab.a(:,3);
        elseif type1=="dimer"
            ratio_tab=dimer_tab.a(:,3);
        elseif type1=="double"
            ratio_tab=double_tab.a(:,3);
        end
        tab= table(log10(ratio_tab),dimer_tab.a(:,2), dimer_tab.a(:,1)-dimer_tab.a(:,2));
    end
    %tab= table(log10(ratio_tab),dimer_tab.a(:,2), dimer_tab.a(:,1)-dimer_tab.a(:,2));
end
h=heatmap(tab,'Var2','Var3','ColorVariable','Var1');
h.XLabel="Distance from PRM to FH2";
h.YLabel="Distance from PRM to NTD";
h.FontSize=7;

h.ColorMethod = 'none';
h.GridVisible="off";
h.NodeChildren(3).YDir='normal';

if type1=="ratio"
    load('customcolorbar_red_blue.mat');
    h.Colormap=CustomColormap;
    if ltvar=="1-Pocc" && calcTF
        h.Title= strcat(ltvar, " ratio (dimer/double), FH2 dist= ", FH2_dist, ", x=",num2str(xcord),", y=",num2str(ycord),", epsilon=",num2str(epsilon));
    else
        h.Title= strcat(ltvar, " ratio (dimer/double), FH2 dist= ", FH2_dist, ", x=",num2str(xcord),", y=",num2str(ycord));
    end
else
    h.Colormap=cool;
    if ltvar=="1-Pocc" && calcTF
        h.Title= strcat(ltvar," ", type1, " , FH2 dist= ", FH2_dist, ", x=",num2str(xcord),", y=",num2str(ycord),", epsilon=",num2str(epsilon));
    else
        h.Title= strcat(ltvar," ", type1, " , FH2 dist= ", FH2_dist, ", x=",num2str(xcord),", y=",num2str(ycord));
    end
end

hs=struct(h);
if calcTF
    if ltvar=="1-Pocc" && type1~="ratio"
        ylabel(hs.Colorbar, strcat("CALCULATED ", ltvar," ",type1))
    else
        ylabel(hs.Colorbar, strcat("CALCULATED log10 ", ltvar," ",type1))
    end
else
    if ltvar=="1-Pocc" && type1~="ratio"
        ylabel(hs.Colorbar, strcat(ltvar," ",type1))
    else
        ylabel(hs.Colorbar, strcat("log10 ", ltvar," ",type1))
    end
end

y=sort(tab.Var1(tab.Var1~=-Inf));
y = y(~isnan(y));
toobig=true;
ind=0;
while toobig
    ind=ind+1;
    if ind>10
        toobig=false;
    end
    if (y(1)+2)<y(2)
        y=y(2:end);
    else
        toobig=false;
    end
end
if type1=="ratio"
    if y(1)<0
        h.ColorLimits=[y(1) -y(1)];
    else
        h.ColorLimits=[-y(end) y(end)];
    end
    if y(1)<-10
        h.ColorLimits=[-10 10];
    end
else
    h.ColorLimits=[y(1) y(end)];
    if y(1)<-10
        h.ColorLimits=[-10 y(end)];
    end
end

if limits==0
else
    h.ColorLimits=limits;
end



for i=1:length(h.XDisplayLabels)
    if mod(i+minCT-1,20)~=0
        h.XDisplayLabels{i} = '';
    end
end
for i=1:length(h.YDisplayLabels)
    if mod(i+minNT-1,20)~=0
        h.YDisplayLabels{i} = '';
    end
end
    s = struct(h); 
    s.XAxis.TickLabelRotation = 0;   % horizontal

if plotprms
    num_row = maxNT-minNT+1;
    num_col = maxCT-minCT+1;
    % Extract heatmap data
    xlabels = h.XDisplayData; % categorical labels
    ylabels = h.YDisplayData;
    
    % Convert categorical to numeric indices
    x = 1:length(xlabels);
    y = 1:length(ylabels);
    
    % Axes overlay
    ax = axes(fig);
    ax.Position = h.Position; % Match heatmap position
    ax.Units = h.Units;       % Match units (likely 'normalized')
    ax.Color = 'none';        % Make transparent
    ax.XLim = [0.5, num_col+0.5];
    ax.YLim = [0.5, num_row+0.5];
    ax.YDir = 'reverse';      % Important: flip Y to match heatmap layout
    ax.XTick = [];
    ax.YTick = [];
    
    % coordinates to overlay (center of cells)
    Bni1_x= [25, 36, 47, 75];
    Bni1_L=88;
    Bni1_y=num_row-(Bni1_L-Bni1_x+1);
    Capu_x= [33, 47, 61, 78, 96]; 
    Capu_L=123;
    Capu_y=num_row-(Capu_L-Capu_x+1);
    Fhod_x= [47, 218]; 
    Fhod_L=255;
    Fhod_y=num_row-(Fhod_L-Fhod_x+1);
    
    % Plot circles
    hold on;
    h1 = plot(ax, Bni1_x, Bni1_y, 'o', ...
        'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'none', ...
        'MarkerSize', 12,'LineWidth', 1.5, 'DisplayName', 'Bni1');
    
    h2 = plot(ax, Capu_x, Capu_y, 's', ...
        'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'none', ...
        'MarkerSize', 12,'LineWidth', 1.5, 'DisplayName', 'Capu');
    
    % Group 3: triangles
    h3 = plot(ax, Fhod_x, Fhod_y, '^', ...
        'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'none', ...
        'MarkerSize', 12,'LineWidth', 1.5, 'DisplayName', 'Fhod');
    
    % Add legend
    legend(ax, [h1, h2, h3], 'Location', 'northeastoutside');

end

if class(expplt)=="Experiment"
    colors=makepoints(length(expplt.ForminList)+2,'w');
    [B,I]=sort(arrayfun(@(x) hex2dec(erase(x(1), "#")), colors));
    colors=colors(I);
    linestyles=["-","--","-."];
    linetype=1;
    fnames=[];
    for i=1:length(expplt.ForminList)
        fnames=[fnames, expplt.ForminList(i).name];
    end
    [B,I] = sort(fnames);
    flist=expplt.ForminList;
    flist=flist(I);
    for i=1:length(flist)
        formin1=flist(i);
        for j=1:length(formin1.PRMList)
            PRM1=formin1.PRMList(j);
            if j==1
                xline(PRM1.dist_FH2,linestyles(linetype),'DisplayName',formin1.name,'Color',colors(i+1),'LineWidth',2);
            else
                xline(PRM1.dist_FH2,linestyles(linetype),'Color',colors(i+1),'LineWidth',2,'HandleVisibility','off');
            end
        end

        if linetype==3
            linetype=1;
        else
            linetype=linetype+1;
        end
    end
end

fontsize(18,"points")

if saveTF
    fname=strcat('Heatmap_',ltvar,"_FH2",FH2_dist,"_x",num2str(xcord),"_y",num2str(ycord),"_",type1);
    if calcTF
        fname=strcat(fname,"_calculated");
        if ltvar=="1-Pocc"
            fname=strcat(fname,"_epsilon",num2str(epsilon));
        end
    end
    if class(expplt)=="Experiment"
        saveas(gcf,fullfile(savefigfolder,strcat(fname,'_forminsplt.png')),'png');
    exportgraphics(gcf,fullfile(savefigfolder,strcat(fname,'_forminsplt.eps')),'BackgroundColor','none','ContentType','vector');
    else
        saveas(gcf,fullfile(savefigfolder,strcat(fname,'.png')),'png');
    exportgraphics(gcf,fullfile(savefigfolder,strcat(fname,'.eps')),'BackgroundColor','none','ContentType','vector');
    end
end