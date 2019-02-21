%% Analysis of Irreversible Gillespie Data
% Lara Clemens - lclemens@uci.edu

clear all;
close all;

%% Initialize

% initialization switch for which model we're inspecting
model = 10; % 1x = stiffening, 2x = electrostatics, 3x = multiple binding - ibEqual

spacing = 1; % 0 = CD3Zeta, 1 = EvenSites, 2 = CD3Epsilon, 3 = TCR
membrane = 0; % 0 for membrane off, 1 for membrane on
phos = 1; % 1 = phosphorylation, 0 = dephosphorylation

% save or not save plots
saveTF = 0;
save1 = 0; % save only ProbVSSequence plot

%% 

savefilefolder = '/Volumes/GoogleDrive/My Drive/Papers/MultisiteDisorder/Data_Figures';
%savefilefolder = '~/Documents/Papers/MultisiteDisorder/Figures';

switch spacing
    case 0
        iSiteSpacing = 'CD3Zeta';
    case 1
        iSiteSpacing = 'EvenSites';
    case 2
        iSiteSpacing = 'CD3Epsilon';
    case 3
        iSiteSpacing = 'TCR';
end

if (membrane)
    membraneState = 'On';
else
    membraneState = 'Off';
end

if (phos)
    phosDirection = 'Phos';
else
    phosDirection = 'Dephos';
end

switch (model)
    
    case 10 % Local Structuring
        
        % find files
        filefolder    = '~/Documents/Papers/MultisiteDisorder/Data/1.LocalStructuring/';
        filesubfolder = [iSiteSpacing,'/Membrane',membraneState,'/3.Gillespie/Irreversible/','/CatFiles/',phosDirection];
        filetitle = strcat('IrreversibleGillespie',iSiteSpacing,'Membrane',membraneState,phosDirection);
        
        %
        locationTotal = 6;
        sweep = -1:1:103; % includes control
        sweepParameter = 'StiffenRange';
        
        xlabelModel = 'Range of Stiffening';
        units = '(Kuhn lengths)';
        
        % create location to save figures
        savefilesubfolder = ['1.LocalStructuring/',iSiteSpacing,'/Membrane',membraneState,'/',phosDirection,'/Sequence'];
        
        % figure parameters
        lw = 2;
        ms = 10;
        colors = flipud(cool(length(sweep)));
        colormapName = cool;
        legendlabels = {'No Stiffening', 'StiffenRange = 0','StiffenRange = 1','StiffenRange = 2','StiffenRange = 3','StiffenRange = 4','StiffenRange = 5','StiffenRange = 6','StiffenRange = 7','StiffenRange = 8','StiffenRange = 9','StiffenRange = 10'};
        legendlabelsAbbrev = {'None', '0','1','2','3','4','5','6','7','8','9','10'};
        
        modificationLabel = '(Phosphorylated)';
        
      
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
    case 20 % Membrane Association - Zeta
      
        % find files
        filefolder    = '~/Documents/Papers/MultisiteDisorder/Data/2.MembraneAssociation/';
        filesubfolder = [iSiteSpacing,'/Membrane',membraneState,'/3.Gillespie/Irreversible/',phosDirection,'/CatFiles'];
        filetitle = strcat('Gillespie',iSiteSpacing,'MembraneAssociation');
        
        %
        locationTotal = 6;
        sweep = 0:2:20; % includes control
        sweepParameter = 'EP0';
        
        % create location to save figures
        savefilesubfolder = ['2.MembraneAssociation/',iSiteSpacing,'/Membrane',membraneState,'/',phosDirection,'/Sequence'];
        
        % figure parameters
        lw = 2;
        ms = 10;
        colors = parula(11);
        legendlabelsAbbrev = {'0','1','2','3','4','5','6','7','8','9','10'};
        legendlabels = {['EP0', num2str(sweep)]};
        
        xlabelModel = 'EP0';
        units = 'kBT'; 
        
        modificationLabel = '(Phosphorylated)';
        
     case 21 % Membrane Association - Epsilon
      
        % find files
        filefolder    = '~/Documents/Papers/MultisiteDisorder/Data/2.MembraneAssociation/';
        filesubfolder = [iSiteSpacing,'/Membrane',membraneState,'/TwoSites/3.Gillespie/Irreversible/',phosDirection,'/CatFiles'];
        filetitle = strcat('Gillespie',iSiteSpacing,'MembraneAssociation');
        
        %
        locationTotal = 2;
        sweep = 0:2:20; % includes control
        sweepParameter = 'EP0';
        
        % create location to save figures
        savefilesubfolder = ['2.MembraneAssociation/',iSiteSpacing,'/Membrane',membraneState,'/',phosDirection,'/Sequence'];
        
        % figure parameters
        lw = 2;
        ms = 10;
        colors = parula(11);
        legendlabelsAbbrev = {'0','1','2','3','4','5','6','7','8','9','10'};
        legendlabels = {['EP0', num2str(sweep)]};
        
        xlabelModel = 'EP0';
        units = 'kBT'; 
        modificationLabel = '(Phosphorylated)';
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
     case 30
        
        % find files
        filefolder    = '~/Documents/polymer-c_runs/20181206GillespieMeanRateSimBind';
        filesubfolder = 'GillespieSimultaneousBindingCD3ZetaMembrane0Phos';
        filetitle = strcat('Gillespie',iSiteSpacing,'Membrane',num2str(membrane));
        
        %
        locationTotal = 3;
        sweep = 1:1:14; % includes control
        sweepParameter = 'ibRadius';
        
        xlabelModel = 'Range of Stiffening';
        units = '(Kuhn lengths)';
        
        % create location to save figures
        savefilesubfolder = ['1.LocalStructuring/',iSiteSpacing,'/Membrane',membraneState,'/',phosDirection,'/Sequence'];
        
        % figure parameters
        lw = 2;
        ms = 10;
        colors = flipud(cool(length(sweep)+2));
        legendlabels = {'No Stiffening', 'StiffenRange = 0','StiffenRange = 1','StiffenRange = 2','StiffenRange = 3','StiffenRange = 4','StiffenRange = 5','StiffenRange = 6','StiffenRange = 7','StiffenRange = 8','StiffenRange = 9','StiffenRange = 10'};
        legendlabelsAbbrev = {'None', '0','1','2','3','4','5','6','7','8','9','10'};
        
        modificationLabel = '(Phosphorylated)';
        
      case 31
        
        % find files
        filefolder    = '~/Documents/polymer-c_runs/20181206GillespieMeanRateSimBindibEqMemOn';
        filesubfolder = 'GillespieSimultaneousBindingCD3ZetaMembrane1Phos';
        filetitle = strcat('Gillespie',iSiteSpacing,'Membrane',num2str(membrane));
        
        %
        locationTotal = 6;
        sweep = 1:1:7; % includes control
        sweepParameter = 'ibRadius';
        
        xlabelModel = 'Range of Stiffening';
        units = '(Kuhn lengths)';
        
        % create location to save figures
        savefilesubfolder = ['1.LocalStructuring/',iSiteSpacing,'/Membrane',membraneState,'/',phosDirection,'/Sequence'];
        
        % figure parameters
        lw = 2;
        ms = 10;
        colors = flipud(cool(length(sweep)+2));
        legendlabels = {'No Stiffening', 'StiffenRange = 0','StiffenRange = 1','StiffenRange = 2','StiffenRange = 3','StiffenRange = 4','StiffenRange = 5','StiffenRange = 6','StiffenRange = 7','StiffenRange = 8','StiffenRange = 9','StiffenRange = 10'};
        legendlabelsAbbrev = {'None', '0','1','2','3','4','5','6','7','8','9','10'};
        
        modificationLabel = '(Phosphorylated)';
        

     case 32
        
        filefolder    = '~/Documents/Papers/MultisiteDisorder/Data/3.SimultaneousBinding/';
        filesubfolder = [iSiteSpacing,'/Membrane',membraneState,'/SepDist5/3.Gillespie/Irreversible/',phosDirection,'/CatFiles'];
        filetitle = strcat('Gillespie',iSiteSpacing,'Membrane',num2str(membrane));
        
        sweepParameter = 'ibRadius';
        legendlabelsAbbrev = 1:10;
        
        locationTotal = 10;
        sweep = 1:1:10;
        
        xlabelModel = 'Radius of Ligand';
        units = '(Kuhn lengths)';
        %
        % create location to save figures
        savefilesubfolder = ['3.SimultaneousBinding/','TCR','/Membrane',membraneState,'/ibEqual/',phosDirection,'/Sequence'];
        
        colors = flipud(cool(11));
        lw = 2;
        ms = 10;
        
        modificationLabel = '(Phosphorylated)';
        
        
end


%% CREATE PERMUTATION LIST
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% CREATE PERMUTATION LIST %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize
path = zeros(factorial(locationTotal),1);
avgTime = zeros(factorial(locationTotal),size(sweep,2)+1);
probability = zeros(factorial(locationTotal),size(sweep,2)+1);

% create list of permutations of numbers 1-6
permutations = sortrows(perms(1:1:locationTotal));

% create permutation strings then convert to number
for j=1:factorial(locationTotal)
    permString = '';
    for k=1:locationTotal
        permString = strcat(permString,num2str(permutations(j,k)));
    end
    path(j) = str2num(permString);
end

% attach path to each so becomes vector e.g. [path, avgTime]
avgTime(:,1) = path(:);
probability(:,1) = path(:);

%% Read Files
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% READ FILES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for s=1:length(sweep)
   
    clear M;
    
    % set up filename
    filename = strcat(filetitle,sweepParameter,'.',num2str(sweep(s)),'.AllData');
    
    % read in file
    M = dlmread(fullfile(filefolder,filesubfolder,filename));
    
    % read in average times and rates
    transitionTime_Avg(s,1:locationTotal) = M(end-(locationTotal-1):end,2);
    transitionRate_Avg(s,1:locationTotal) = M(end-(locationTotal-1):end,3);

    
    % check size of M for possible error
    if (size(M,1) < (1+factorial(locationTotal)+locationTotal))
        disp('Warning! File might not contain all paths!');
    end
    
    % find probability and avgTime from matrix
    for k=1:(size(M,1)-1-locationTotal)
        probability(k,s+1) = M(k+1,4);
        avgTime(k,s+1) = M(k+1,5);
    end
    
end

%% AVERAGE TRANSITION RATE PLOTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% AVERAGE TRANSITION RATE PLOTS %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Average Transition Rates VS Number of Modified Sites - No Labels

figure(12); clf; hold on; box on;
for s=1:length(sweep)
    plot(0:1:(locationTotal-1),transitionRate_Avg(s,:)./(locationTotal:-1:1),'Color',colors(s,:),'LineWidth',lw);
end
switch model
    case {2,3,4}
        set(gca,'yscale','log');
    otherwise
end
set(gca,'XTick',0:1:locationTotal-1);
switch model
    case 1
        ylim([0 1]);
    case {2,3}
        ylim([0 1]);
    case { 4}
        ylim([10^(-7) 1]);
end
set(h,'ylim',[0 1]);

% print position and labels
pos = get(gca, 'position');
set(gcf,'units','inches','position',[1,1,3,3]); set(gca,'units','inches','position',[0.5,0.5,1.9,1.9]);

if (saveTF)
    % % save figure
    savefiletitle = 'AvgTransRateVSNumberModified';
    saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefiletitle),'fig');
    print('-painters',fullfile(savefilefolder,savefilesubfolder,savefiletitle),'-depsc');
end

%% Average Transition Rates VS Number of Modified Sites - Labels

figure(120); clf; hold on; box on;
for s=1:length(sweep)
    plot(0:1:(locationTotal-1),transitionRate_Avg(s,:)./(locationTotal:-1:1),'Color',colors(s,:),'LineWidth',lw);
end
switch model
    case {30,31,32,33}
        set(gca,'yscale','log');
    otherwise
end
xlabel1 = {['Number of Modified Sites'],modificationLabel};
ylabel1 = {['Average Transition Rate / Unmodified Sites']};
title1 = 'Average Transition Rate';
set(gca,'XTick',0:1:locationTotal-1);
set(gca,'XTickLabel',{'0 -> 1', '1 -> 2', '2 -> 3', '3 -> 4','4 -> 5', '5 -> 6', '6 -> 7', '7 -> 8', '8 -> 9', '9 -> 10'});
switch model
    case 10
        ylim([0 1]);
    case {20,30}
        ylim([0 1]);
    case {40}
        ylim([10^(-7) 1]);
end
set(gcf,'Colormap',colormapName)
h = colorbar;
h = colorbar('Ticks',[0 1],'TickLabels',{'',''},'YDir','reverse');
set(h,'ylim',[0 1]);

pos = get(gcf, 'position');
set(gcf,'units','centimeters','position',[1,4,40,30]);
set(gca,'FontName','Arial','FontSize',30);
xlabel(xlabel1,'FontName','Arial','FontSize',24);
ylabel(ylabel1,'FontName','Arial','FontSize',24);
title(title1,'FontName','Arial','FontSize',24);

if (saveTF)
    % % save figure
    savefiletitle = 'AvgTransRateVSNumberModifiedLabels';
    saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefiletitle),'fig');
    print('-painters',fullfile(savefilefolder,savefilesubfolder,savefiletitle),'-depsc');
end

%% SEQUENCE PROBABILITY PLOTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% SEQUENCE PROBABILITY PLOTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Create matrices to be read by 'Bar' command

% want either just 654321 and 123456 or also Max and Min

sequentialAvgTime = zeros(2,size(sweep,2)+1);
sequentialProbability = zeros(2,size(sweep,2)+1);


sequentialAvgTime(1,:) = avgTime(1,:);
sequentialProbability(1,:) = probability(1,:);

sequentialAvgTime(2,:) = avgTime(factorial(locationTotal),:);
sequentialProbability(2,:) = probability(factorial(locationTotal),:);

%% Create bar graphs
switch (spacing)
    case 4
        sequence = {'12','21'};
    otherwise
        sequence = {'123456','654321'};
end

%% Plot Probability versus Sequence - No Labels

ax=figure(2); clf; box on; hold on;
b=bar(sequentialProbability(:,2:end));
w = (length(sequentialProbability)-1);
for l=1:length(sequentialProbability)-1
    b(l).FaceColor = colors(l,:);
    b(l).EdgeColor = colors(l,:);
end
% print reference line
hline = refline([0 1/factorial(locationTotal)]);
hline.Color = 'k';
hline.LineWidth = 2.5;
hline.LineStyle = '--';

% axis labels
set(gca,'xtick',[1,2]);
set(gca,'xticklabel',[]);
switch (model)
    case 10
        if(phos)
            ylim([0 0.012]);
        else
            ylim([0 0.012]);
        end
    case 20
        if(phos)
            ylim([0 0.016]);
            yticks([0 0.002 0.004 0.006 0.008 0.01 0.012 0.014 0.016]);
        else
            ylim([0 4*10^(-3)]);
            yticks(10.^(-3).*[0 0.5 1 1.5 2 2.5 3 3.5 4]);
        end
    case 30
        if(phos)
            ylim([0 0.002])
            yticks([0 0.0005 0.001 0.0015 0.002]);
        end
end
set(gca,'yticklabel',[]);

% print position and labels
pos = get(gca, 'position');
set(gcf,'units','inches','position',[1,1,3,3]); set(gca,'units','inches','position',[0.5,0.5,1.9,1.9]);
%set(gca,'units','inches','position',[0.5,0.5,1.7,1.2]);

if (saveTF)
    % % save figure
    savefiletitle = 'ProbVSSequence';
    saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefiletitle),'fig');
    print('-painters',fullfile(savefilefolder,savefilesubfolder,savefiletitle),'-depsc');
%     saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefiletitle),'epsc');
end

%% Plot Probability versus Sequence - Labels

ax=figure(20); clf; box on; hold on;
b=bar(sequentialProbability(:,2:end));
w = (length(sequentialProbability)-1);
for l=1:length(sequentialProbability)-1
    b(l).FaceColor = colors(l,:);
    b(l).EdgeColor = colors(l,:);
end
% print reference line
hline = refline([0 1/factorial(locationTotal)]);
hline.Color = 'k';
hline.LineWidth = 2.5;
hline.LineStyle = '--';

% axis labels
set(gca,'xtick',[1 2]);
set(gca,'xticklabel',sequence);
xlabel1 = 'Sequence';
ylabel1 = 'Probability';
title1 = 'Probability vs Sequence';
switch (model)
    
    case 10
        if(phos)
            ylim([0 0.012]);
        else
            ylim([0 0.012]);
        end
    case 20
        if(phos)
            ylim([0 0.016]);
            yticks([0 0.002 0.004 0.006 0.008 0.01 0.012 0.014 0.016]);
        else
            ylim([0 4*10^(-3)]);
            yticks(10.^(-3).*[0 0.5 1 1.5 2 2.5 3 3.5 4]);
        end
    case 31
        if(phos)
            ylim([0 0.002])
            yticks([0 0.0005 0.001 0.0015 0.002]);
        end
end

% print position and labels
pos = get(gcf, 'position');
set(gcf,'units','centimeters','position',[1,4,40,30]);
set(gca,'FontName','Arial','FontSize',30);
xlabel(xlabel1,'FontName','Arial','FontSize',24);
ylabel(ylabel1,'FontName','Arial','FontSize',24);
title(title1,'FontName','Arial','FontSize',24);

% colorbar
set(gcf,'Colormap',colormapName)
colortickind = [length(sweep) 1];
%clims = [0 1]
clims = [colors(colortickind(1)) colors(colortickind(2))];
% cbar = colorbar('Ticks',[colors_fig(colortickind(1)) colors_fig(colortickind(2))],'TickLabels',{'10^{2}','10^{-2}'},'ylim',clims);
h = colorbar('Ticks',[colors(colortickind(1)) colors(length(sweep)-5) colors(colortickind(2))],'TickLabels',{'',''},'ylim',clims);
% set(h,'ylim',colorTicks);

%legend(horzcat(legendlabels,{'Random Probability = 1/720'}),'Location','northwest');
if (saveTF)
    % % save figure
    savefiletitle = 'ProbVSSequenceLabels';
    saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefiletitle),'fig');
    saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefiletitle),'epsc');
end






%% EXTRA PLOTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% EXTRA PLOTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%{

    %% Create transition rate plots

    figure(1); clf; hold on;
    for s=1:length(sweep)
        plot(0:1:(locationTotal-1),transitionRate_Avg(s,:),'Color',colors(s,:),'LineWidth',lw);
    end
    xlabel1 = {['Number of Modified Sites'],modificationLabel};
    ylabel1 = {['Average Transition Rate'],['(per free space binding)']};
    title1 = 'Average Transition Rate';
    set(gca,'XTick',0:1:locationTotal-1);
    set(gca,'XTickLabel',{'0 -> 1', '1 -> 2', '2 -> 3', '3 -> 4','4 -> 5', '5 -> 6'});
    set(gcf,'Colormap',colormapName)
    h = colorbar;
    h = colorbar('Ticks',[0 1],'TickLabels',{'',''},'YDir','reverse');
    set(h,'ylim',[0 1]);
    switch model
        case 1
            ylim([0 locationTotal]);
        case {2,3}
            ylim([0 1]);
    end

    pos = get(gcf, 'position');
    set(gcf,'units','centimeters','position',[1,4,40,30]);
    set(gca,'FontName','Arial','FontSize',30);
    xlabel(xlabel1,'FontName','Arial','FontSize',24);
    ylabel(ylabel1,'FontName','Arial','FontSize',24);
    title(title1,'FontName','Arial','FontSize',24);
    
    if (saveTF)
        % % save figure
        savefiletitle = 'AverageTransitionRate_TotalSitesVSNumberModified';
        saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefiletitle),'fig');
        saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefiletitle),'epsc');
    end

    %%
    figure(11); clf; hold on;
    for s=1:length(sweep)
        plot(0:1:(locationTotal-1),transitionTime_Avg(s,:),'Color',colors(s,:),'LineWidth',lw);
    end
    xlabel1 = {['Number of Modified Sites'],modificationLabel};
    ylabel1 = {['Average Transition Time']};
    title1 = 'Average Transition Time';
    set(gca,'XTick',0:1:locationTotal-1);
    set(gca,'XTickLabel',{'0 -> 1', '1 -> 2', '2 -> 3', '3 -> 4','4 -> 5', '5 -> 6'});
    set(gcf,'Colormap',colormapName)
    h = colorbar;
    h = colorbar('Ticks',[0 1],'TickLabels',{'',''},'YDir','reverse');
    set(h,'ylim',[0 1]);

    pos = get(gcf, 'position');
    set(gcf,'units','centimeters','position',[1,4,40,30]);
    set(gca,'FontName','Arial','FontSize',30);
    xlabel(xlabel1,'FontName','Arial','FontSize',24);
    ylabel(ylabel1,'FontName','Arial','FontSize',24);
    title(title1,'FontName','Arial','FontSize',24);
    
    if (saveTF)
        % % save figure
        savefiletitle = 'AverageTransitionTimeVSNumberModified';
        saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefiletitle),'fig');
        saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefiletitle),'epsc');
    end



    %% Create Sorted Graphs
    % removes association with path once sorted for plot purposes (i.e. x-axis
    % is rank, not sequence)
    % want to be able to know which one is 123456, 654321

    sortedAvgTimeSweep = zeros(factorial(locationTotal),size(sweep,2));
    sequenceRankAvgTimeMemToTail = zeros(2,size(sweep,2));
    sequenceRankAvgTimeTailToMem = zeros(2,size(sweep,2));

    sortedProbabilitySweep = zeros(factorial(locationTotal),size(sweep,2));
    sequenceRankProbabilityMemToTail = zeros(2,size(sweep,2));
    sequenceRankProbabilityTailToMem = zeros(2,size(sweep,2));
    sequenceRankProbability = zeros(2,size(sweep,2));


    for s = 1:length(sweep)
        % AVERAGE TIME
        %initialize
        preSortAvgTime = zeros(factorial(locationTotal),2);
        sortedAvgTime = zeros(factorial(locationTotal),2);

        % collect path and avgTime data one column at a time, sort, pull out
        % data for 123456, 654321
        preSortAvgTime(:,1) = path;
        preSortAvgTime(:,2) = avgTime(:,s+1);
        sortedAvgTime = sortrows(preSortAvgTime,2);

        % collect location in sequenceRankAvgTime of 123456, 654321
        sequenceRankAvgTimeMemToTail(1,s) = find(sortedAvgTime(:,1)==str2num(sequence{1}));
        sequenceRankAvgTimeTailToMem(1,s) = find(sortedAvgTime(:,1)==str2num(sequence{2}));

        % collect average time
        sequenceRankAvgTimeMemToTail(2,s) = sortedAvgTime(sequenceRankAvgTimeMemToTail(1,s),2);
        sequenceRankAvgTimeTailToMem(2,s) = sortedAvgTime(sequenceRankAvgTimeTailToMem(1,s),2);

        sortedAvgTimeSweep(:,s) = sortedAvgTime(:,2);


        %PROBABILITY
        %initialize
        preSortProbability = zeros(factorial(locationTotal),2);
        sortedProbability = zeros(factorial(locationTotal),2);

        % collect path and probability data one column at a time, sort, pull out
        % data for 123456, 654321
        preSortProbability(:,1) = path;
        preSortProbability(:,2) = probability(:,s+1);
        sortedProbability = sortrows(preSortProbability,2);
        sequenceRankProbability(1,s) = find(sortedProbability(:,1)==str2num(sequence{1}));
        sequenceRankProbability(2,s) = find(sortedProbability(:,1)==str2num(sequence{2}));

        sequenceRankProbabilityMemToTail(1,s) = find(sortedProbability(:,1)==str2num(sequence{1}));
        sequenceRankProbabilityTailToMem(1,s) = find(sortedProbability(:,1)==str2num(sequence{2}));

        sequenceRankProbabilityMemToTail(2,s) = sortedProbability(sequenceRankProbabilityMemToTail(1,s),2);
        sequenceRankProbabilityTailToMem(2,s) = sortedProbability(sequenceRankProbabilityTailToMem(1,s),2);


        sortedProbabilitySweep(:,s) = sortedProbability(:,2);

    end
    %% Plot AvgTime vs Rank
    figure(31); clf; 


    figure(31); hold on; box on;
    for s = 1:length(sweep)
        plot(1:1:factorial(locationTotal),sortedAvgTimeSweep(:,s),'-');
    end
    plot(sequenceRankAvgTimeMemToTail(1,:),sequenceRankAvgTimeMemToTail(2,:),'xk','LineWidth',lw,'MarkerSize',ms);
    plot(sequenceRankAvgTimeTailToMem(1,:),sequenceRankAvgTimeTailToMem(2,:),'ok','LineWidth',lw,'MarkerSize',ms);

    % Plot labels
    xlabel1 = 'Rank';
    ylabel1 = 'Average Time (s)';
    title1 = 'Average Time vs Rank';
    set(gca,'FontName','Arial','FontSize',24);
    xlabel(xlabel1,'FontName','Arial','FontSize',24);
    ylabel(ylabel1,'FontName','Arial','FontSize',24);
    title(title1,'FontName','Arial','FontSize',24);

    % Plot legend
    markerlabels = {['Sequence = ',sequence{1}],['Sequence = ',sequence{2}]};
    legendlabelswithmarkers = horzcat(legendlabels,markerlabels)
    legend(legendlabelswithmarkers,'Location','northwest');

    % position
    pos = get(gcf, 'position');
    set(gcf,'units','centimeters','position',[1,4,40,30]);

    if (saveTF)
        % % save figure
        savefiletitle = 'AvgTimeVSRank';
        saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefiletitle),'fig');
        saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefiletitle),'epsc');
    end

    %% Plot Probability vs Rank
    figure(41); clf;
    figure(41); hold on; box on;
    for s = 1:length(sweep)
        plot(1:1:factorial(locationTotal),sortedProbabilitySweep(:,s),'-k','LineWidth',lw);
    end
    plot(sequenceRankProbabilityMemToTail(1,:),sequenceRankProbabilityMemToTail(2,:),'xk','LineWidth',lw,'MarkerSize',ms);
    plot(sequenceRankProbabilityTailToMem(1,:),sequenceRankProbabilityTailToMem(2,:),'ok','LineWidth',lw,'MarkerSize',ms);
    plot([1 factorial(locationTotal)],[1/factorial(locationTotal) 1/factorial(locationTotal)],'--k','LineWidth',2);

    % Plot labels
    xlabel1 = 'Rank';
    ylabel1 = 'Probability';
    title1 = 'Probability vs Rank';
    set(gca,'FontName','Arial','FontSize',24);
    xlabel(xlabel1,'FontName','Arial','FontSize',24);
    ylabel(ylabel1,'FontName','Arial','FontSize',24);
    title(title1,'FontName','Arial','FontSize',24);
    legend(horzcat(legendlabelswithmarkers,{['Random Probability = 1/',num2str(factorial(locationTotal))]}),'Location','northwest');

    % position
    pos = get(gcf, 'position');
    set(gcf,'units','centimeters','position',[1,4,40,30]);
    if (saveTF)
        % % save figure
        savefiletitle = 'ProbVSRank';
        saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefiletitle),'fig');
        saveas(gcf,fullfile(savefilefolder,savefilesubfolder,savefiletitle),'epsc');
    end

 %}
