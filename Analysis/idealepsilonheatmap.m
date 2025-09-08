function idealepsilonheatmap(lookuptab,FH2_dist,type1,saveTF,savefigfolder,limits,maxNT,maxCT,minNT,minCT,plotprms)
arguments
    lookuptab
    FH2_dist
    type1
    saveTF =false
    savefigfolder=""
    limits=0
    maxNT=400
    maxCT=400
    minNT=0
    minCT=1
    plotprms=1
end
set(groot,'defaultfigureposition',[400 250 900 750])
fig=figure;
ltvar="POcclude";

% Get simulated values
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
dimer_1minus=1-dimer_tab.a(:,3);
double_1minus=1-double_tab.a(:,3);
if type1=="single"
    single_1minus=1-single_tab(:,3);
end
if type1=="ratio"
    ratio_tab=dimer_1minus./double_1minus;
elseif type1=="dimer"
    ratio_tab=dimer_1minus;
elseif type1=="double"
    ratio_tab=double_1minus;
elseif type1=="single"
    ratio_tab=single_1minus;
end
ltvar="1-Pocc";

vals=zeros(1,length(ratio_tab));
for i=1:length(ratio_tab)
    n1 = dimer_tab.a(i,2);
    fh1length = dimer_tab.a(i,1);
    k=1;
    R=2.25;
    if type1=="single"
        poccval_1min= @(epsilon) ( ...
            ( 1-((R/(R+epsilon))*erfc((epsilon/k)*(3/(fh1length-n1))^0.5)) )* ... // occlusion from PRM to NTD
            ( 1-((R/(R+epsilon))*erfc((epsilon/k)*(3/n1)^0.5)) ) ... // occlusion from PRM to FH2
            );
    elseif type1=="double"
        poccval_1min= @(epsilon) ( ...
            ( 1-((R/(R+epsilon))*erfc((epsilon/k)*(3/(fh1length-n1))^0.5)) )* ... // occlusion from PRM to cis NTD
            ( 1-((R/(R+epsilon))*erfc(((epsilon/k)*3/(n1+fh1length))^0.5)) ) ... // occlusion from PRM to trans NTD
            );
    end
    fun2= @(epsilon) ratio_tab(i)-poccval_1min(abs(epsilon));
    fun3= @(epsilon) abs(fun2(epsilon));
    vals(1,i)=fminsearch(fun3,1);
end
meanepsilon=mean(vals);
tab= table(1.*(vals'),dimer_tab.a(:,2), dimer_tab.a(:,1)-dimer_tab.a(:,2));




h=heatmap(tab,'Var2','Var3','ColorVariable','Var1');
h.XLabel="Distance from PRM to FH2";
h.YLabel="Distance from PRM to NTD";
h.ColorMethod = 'none';
h.GridVisible="off";
h.NodeChildren(3).YDir='normal';

if type1=="ratio"
    load('customcolorbar_red_blue.mat');
    h.Colormap=CustomColormap;
    h.Title= [strcat("Ideal epsilon based on ",ltvar, " ratio (dimer/double), FH2 dist= ", FH2_dist),strcat("mean: ",num2str(meanepsilon))];
    
else
    h.Colormap=cool;
    h.Title= [strcat("Ideal epsilon based on ",ltvar," ", type1, " , FH2 dist= ", FH2_dist),strcat("mean: ",num2str(meanepsilon))];

end

hs=struct(h);
ylabel(hs.Colorbar, "epsilon")

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

fontsize(18,"points")

if saveTF
    fname=strcat('Epsilon_Heatmap_',ltvar,"_FH2",FH2_dist,"_",type1);
    
    saveas(gcf,fullfile(savefigfolder,strcat(fname,'.png')),'png');
end