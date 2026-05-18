saveloc="/Users/katiebogue/MATLAB/GitHub/Data/polymer-c_data/stericocclusion/plots/fixedruns";
structvar=fixedruns;
 %%
% [f_pr]=makecompareplotTWO(fixedruns.FH2_35_dimer,fixedruns_old.FH2_35_dimer,"35.5","dimer");
% [f_pr]=makecompareplotTWO(fixedruns.FH2_35_double,fixedruns_old.FH2_35_double,"35.5","double");
% 
 %%
% [f_pr]=makecompareplotTWO(normruns.FH2_35_dimer,k5runs.FH2_35_dimer,"35.5","dimer");
% [f_pr]=makecompareplotTWO(normruns.FH2_16_dimer,k5runs.FH2_16_dimer,"16.667","dimer");
% [f_pr]=makecompareplotTWO(normruns.FH2_1_dimer,k5runs.FH2_1_dimer,"1","dimer");
% 
% [f_pr]=makecompareplotTWO(normruns.FH2_35_double,k5runs.FH2_35_double,"35.5","double");
% [f_pr]=makecompareplotTWO(normruns.FH2_16_double,k5runs.FH2_16_double,"16.667","double");
% [f_pr]=makecompareplotTWO(normruns.FH2_1_double,k5runs.FH2_1_double,"1","double");


%% double

[f_pr,f_pocc]=makecompareplot(structvar.FH2_35_double,"35.5","double",saveloc);
[f_pr,f_pocc]=makecompareplot(structvar.FH2_16_double,"16.667","double",saveloc);
[f_pr,f_pocc]=makecompareplot(structvar.FH2_1_double,"1","double",saveloc);

[f_pr,f_pocc]=makeratioplot(structvar.FH2_35_double,"35.5","double",saveloc);
[f_pr,f_pocc]=makeratioplot(structvar.FH2_16_double,"16.667","double",saveloc);
[f_pr,f_pocc]=makeratioplot(structvar.FH2_1_double,"1","double",saveloc);

%% dimer

[f_pr,f_pocc]=makecompareplot(structvar.FH2_35_dimer,"35.5","dimer",saveloc);
[f_pr,f_pocc]=makecompareplot(structvar.FH2_16_dimer,"16.667","dimer",saveloc);
[f_pr,f_pocc]=makecompareplot(structvar.FH2_1_dimer,"1","dimer",saveloc);

[f_pr,f_pocc]=makeratioplot(structvar.FH2_35_dimer,"35.5","dimer",saveloc);
[f_pr,f_pocc]=makeratioplot(structvar.FH2_16_dimer,"16.667","dimer",saveloc);
[f_pr,f_pocc]=makeratioplot(structvar.FH2_1_dimer,"1","dimer",saveloc);

%% ratio
[f_pr,f_pocc]=makeratiocompareplot(structvar.FH2_35_dimer,structvar.FH2_35_double,"35.5",saveloc);
[f_pr,f_pocc]=makeratiocompareplot(structvar.FH2_16_dimer,structvar.FH2_16_double,"16.667",saveloc);
[f_pr,f_pocc]=makeratiocompareplot(structvar.FH2_1_dimer,structvar.FH2_1_double,"1",saveloc);

%% ratio ratio

[f_pr,f_pocc]=makeratioratioplot(structvar.FH2_35_dimer,structvar.FH2_35_double,"35.5",saveloc);
[f_pr,f_pocc]=makeratioratioplot(structvar.FH2_16_dimer,structvar.FH2_16_double,"16.667",saveloc);
[f_pr,f_pocc]=makeratioratioplot(structvar.FH2_1_dimer,structvar.FH2_1_double,"1",saveloc);

%% functions

function [f_pr,f_pocc]=makecompareplot(FH2struct,FH2_size,type,saveloc)
    if FH2_size=="35.5"
        cyltype="cyl";
    elseif FH2_size=="16.667"
        cyltype="cyl16";
    elseif FH2_size=="1"
        cyltype="cyl1";
    end

    scale=getScale(FH2struct.none.Prvec0);
    prScale=(scale)^-3;

    f_pr=figure;
    scatter(scale:scale:121,log10(prScale*1.0e33*(FH2struct.none.Prvec0)/(27*6.022e23)),"Marker","o")
    hold on
    scatter(scale:scale:121,log10(prScale*1.0e33*(FH2struct.plane.Prvec0)/(27*6.022e23)),"Marker","square")
    scatter(scale:scale:121,log10(prScale*1.0e33*(FH2struct.(cyltype).Prvec0)/(27*6.022e23)),"Marker","^")
    legend(["none1","none2","plane1","plane2","cyl1","cyl2"])
    title(strcat("Prvec0 vs PRM location, ",type ,", FH2 size= ",FH2_size))
    xlabel("PRM location (dist from PRM to FH2)")
    ylabel("log10 Prvec0 (uM-1)")

    savefig(f_pr,fullfile(saveloc,strcat("Pr_FH2_",FH2_size,"_",type,".fig")))
    exportgraphics(f_pr,fullfile(saveloc,strcat("Pr_FH2_",FH2_size,"_",type,".png")))

    f_pocc=figure;
    scatter(scale:scale:121,log10(1-FH2struct.none.POcclude),"Marker","o")
    hold on
    scatter(scale:scale:121,log10((1-FH2struct.plane.POcclude)),"Marker","square")
    scatter(scale:scale:121,log10((1-FH2struct.(cyltype).POcclude)),"Marker","^")
    legend(["none1","none2","plane1","plane2","cyl1","cyl2"])
    title(strcat("1-POcclude vs PRM location, ", type,", FH2 size= ",FH2_size))
    xlabel("PRM location (dist from PRM to FH2)")
    ylabel("log10 1-POcclude")

    savefig(f_pocc,fullfile(saveloc,strcat("Pocc_FH2_",FH2_size,"_",type,".fig")))
    exportgraphics(f_pocc,fullfile(saveloc,strcat("Pocc_FH2_",FH2_size,"_",type,".png")))
end

function [f_pr,f_pocc]=makeratioplot(FH2struct,FH2_size,type,saveloc)
    if FH2_size=="35.5"
        cyltype="cyl";
    elseif FH2_size=="16.667"
        cyltype="cyl16";
    elseif FH2_size=="1"
        cyltype="cyl1";
    end

    scale=getScale(FH2struct.none.Prvec0);

    f_pr=figure;
    scatter(scale:scale:121,log10((FH2struct.(cyltype).Prvec0)./(FH2struct.none.Prvec0)),"Marker","^")
    hold on
    scatter(scale:scale:121,log10((FH2struct.plane.Prvec0)./(FH2struct.none.Prvec0)),"Marker","square")
    legend(["cyl1","cyl2","plane1","plane2"])
    title(strcat("Prvec0 ratio vs PRM location, ", type,", FH2 size= ",FH2_size))
    xlabel("PRM location (dist from PRM to FH2)")
    ylabel("log10 Prvec0 Ratio (occluded/not)")

    savefig(f_pr,fullfile(saveloc,strcat("Pr_typeratio_FH2_",FH2_size,"_",type,".fig")))
    exportgraphics(f_pr,fullfile(saveloc,strcat("Pr_typeratio_FH2_",FH2_size,"_",type,".png")))

    f_pocc=figure;
    scatter(scale:scale:121,log10((1-FH2struct.(cyltype).POcclude)./(1-FH2struct.none.POcclude)),"Marker","^")
    hold on
    scatter(scale:scale:121,log10((1-FH2struct.plane.POcclude)./(1-FH2struct.none.POcclude)),"Marker","square")
    legend(["cyl1","cyl2","plane1","plane2"])
    title(strcat("1-POcclude ratio vs PRM location, ",type,", FH2 size= ",FH2_size))
    xlabel("PRM location (dist from PRM to FH2)")
    ylabel("log10 1-POcclude Ratio (occluded/not)")

    savefig(f_pocc,fullfile(saveloc,strcat("Pocc_typeratio_FH2_",FH2_size,"_",type,".fig")))
    exportgraphics(f_pocc,fullfile(saveloc,strcat("Pocc_typeratio_FH2_",FH2_size,"_",type,".png")))
end

function [f_pr,f_pocc]=makeratiocompareplot(dimerstruct, doublestruct, FH2_size,saveloc)
    if FH2_size=="35.5"
        cyltype="cyl";
    elseif FH2_size=="16.667"
        cyltype="cyl16";
    elseif FH2_size=="1"
        cyltype="cyl1";
    end

    scale=getScale(dimerstruct.none.Prvec0);

    f_pr=figure;
    scatter(scale:scale:121,log10((dimerstruct.none.Prvec0)./(doublestruct.none.Prvec0)),"Marker","o")
    hold on
    scatter(scale:scale:121,log10((dimerstruct.plane.Prvec0)./(doublestruct.plane.Prvec0)),"Marker","square")
    scatter(scale:scale:121,log10((dimerstruct.(cyltype).Prvec0)./(doublestruct.(cyltype).Prvec0)),"Marker","^")
    legend(["none1","none2","plane1","plane2","cyl1","cyl2"])
    title(strcat("Prvec0 ratio vs PRM location, FH2 size= ",FH2_size))
    xlabel("PRM location (dist from PRM to FH2)")
    ylabel("log10 Prvec0 dimer/double (uM-1)")

    savefig(f_pr,fullfile(saveloc,strcat("Pr_ratio_FH2_",FH2_size,".fig")))
    exportgraphics(f_pr,fullfile(saveloc,strcat("Pr_ratio_FH2_",FH2_size,".png")))

    f_pocc=figure;
    scatter(scale:scale:121,log10((1-dimerstruct.none.POcclude)./(1-doublestruct.none.POcclude)),"Marker","o")
    hold on
    scatter(scale:scale:121,log10((1-dimerstruct.plane.POcclude)./(1-doublestruct.plane.POcclude)),"Marker","square")
    scatter(scale:scale:121,log10((1-dimerstruct.(cyltype).POcclude)./(1-doublestruct.(cyltype).POcclude)),"Marker","^")
    legend(["none1","none2","plane1","plane2","cyl1","cyl2"])
    title(strcat("1-POcclude ratio vs PRM location, FH2 size= ",FH2_size))
    xlabel("PRM location (dist from PRM to FH2)")
    ylabel("log10 1-POcclude dimer/double (uM-1)")

    savefig(f_pocc,fullfile(saveloc,strcat("Pocc_ratio_FH2_",FH2_size,".fig")))
    exportgraphics(f_pocc,fullfile(saveloc,strcat("Pocc_ratio_FH2_",FH2_size,".png")))
end


function [f_pr,f_pocc]=makeratioratioplot(dimerstruct, doublestruct, FH2_size,saveloc)
    if FH2_size=="35.5"
        cyltype="cyl";
    elseif FH2_size=="16.667"
        cyltype="cyl16";
    elseif FH2_size=="1"
        cyltype="cyl1";
    end

    scale=getScale(dimerstruct.none.Prvec0);

    f_pr=figure;
    noneratio=((dimerstruct.none.Prvec0)./(doublestruct.none.Prvec0));
    planeratio=((dimerstruct.plane.Prvec0)./(doublestruct.plane.Prvec0));
    cylratio=((dimerstruct.(cyltype).Prvec0)./(doublestruct.(cyltype).Prvec0));

    scatter(scale:scale:121,log10((cylratio)./(noneratio)),"Marker","o")
    hold on
    scatter(scale:scale:121,log10((planeratio)./(noneratio)),"Marker","square")
    legend(["cyl1","cyl2","plane1","plane2"])
    title(strcat("Prvec0 ratio ratio vs PRM location, FH2 size= ",FH2_size))
    xlabel("PRM location (dist from PRM to FH2)")
    ylabel("log10 Prvec0 Ratio Ratio (dimer/double occluded)/(dimer/double not))")

    savefig(f_pr,fullfile(saveloc,strcat("Pr_ratioratio_FH2_",FH2_size,".fig")))
    exportgraphics(f_pr,fullfile(saveloc,strcat("Pr_ratioratio_FH2_",FH2_size,".png")))

    f_pocc=figure;
    noneratio=(1-dimerstruct.none.POcclude)./(1-doublestruct.none.POcclude);
    planeratio=(1-dimerstruct.plane.POcclude)./(1-doublestruct.plane.POcclude);
    cylratio=(1-dimerstruct.(cyltype).POcclude)./(1-doublestruct.(cyltype).POcclude);

    scatter(scale:scale:121,log10((cylratio)./(noneratio)),"Marker","o")
    hold on
    scatter(scale:scale:121,log10((planeratio)./(noneratio)),"Marker","square")
    legend(["cyl1","cyl2","plane1","plane2"])
    title(strcat("1-POcclude ratio ratio vs PRM location, FH2 size= ",FH2_size))
    xlabel("PRM location (dist from PRM to FH2)")
    ylabel("log10 1-POcclude Ratio Ratio (dimer/double occluded)/(dimer/double not))")

    savefig(f_pocc,fullfile(saveloc,strcat("Pocc_ratioratio_FH2_",FH2_size,".fig")))
    exportgraphics(f_pocc,fullfile(saveloc,strcat("Pocc_ratioratio_FH2_",FH2_size,".png")))
end

function [f_pr]=makecompareplotTWO(FH2structnorm,FH2structmod,FH2_size,type)
    if FH2_size=="35.5"
        cyltype="cyl";
    elseif FH2_size=="16.667"
        cyltype="cyl16";
    elseif FH2_size=="1"
        cyltype="cyl1";
    end

    FH2struct=FH2structnorm;

    scale=getScale(FH2struct.none.Prvec0);
    prScale=(scale)^-3;

    f_pr=figure;
    scatter(scale:scale:121,log10(prScale*1.0e33*(FH2struct.none.Prvec0)/(27*6.022e23)),"Marker","o")
    hold on
    scatter(scale:scale:121,log10(prScale*1.0e33*(FH2struct.plane.Prvec0)/(27*6.022e23)),"Marker","square")
    scatter(scale:scale:121,log10(prScale*1.0e33*(FH2struct.(cyltype).Prvec0)/(27*6.022e23)),"Marker","^")

    FH2struct=FH2structmod;

    scale=getScale(FH2struct.none.Prvec0);
    prScale=(scale)^-3;

    scatter(scale:scale:121,log10(prScale*1.0e33*(FH2struct.none.Prvec0)/(27*6.022e23)),"filled","Marker","o")
    scatter(scale:scale:121,log10(prScale*1.0e33*(FH2struct.plane.Prvec0)/(27*6.022e23)),"filled","Marker","square")
    scatter(scale:scale:121,log10(prScale*1.0e33*(FH2struct.(cyltype).Prvec0)/(27*6.022e23)),"filled","Marker","^")


    legend(["none1","none2","plane1","plane2","cyl1","cyl2","none1 k/5","none2 k/5","plane1 k/5","plane2 k/5","cyl1 k/5","cyl2 k/5"])
    title(strcat("Prvec0 vs PRM location, ",type ,", FH2 size= ",FH2_size))
    xlabel("PRM location (dist from PRM to FH2)")
    ylabel("log10 Prvec0 (uM-1)")
end

function y=getScale(arr)
    x=length(arr);
    y=121/x;
end