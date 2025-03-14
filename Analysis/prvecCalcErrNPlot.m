function fig=prvecCalcErrNPlot(lt,FH2size,type,logscale,xzoom,saveTF,savefigfolder)
%PRVECCALCERRNPLOT make scatterplots of calculated vs. simulated
%probability densities for specific filament type.
%
% fig =PRVECCALCERRNPLOT(lt,FH2size,saveTF,savefigfolder)
% 
% Inputs:
%       lt           : (Lookuptable) lookuptable object to pull prvec values
%                       from, must have the prvec terms listed below
%       FH2size      : (double) FH2 size to use in calculation (should be FH2
%                       size used in simulations recorded in lt)
%       type         : filament type (double, dimer, ratio)
%       logscale     : (logical) if true, scale values by log10 (default is
%                       true)
%       xzoom        : (double) lower limit on x axes (PRM location) to
%                       zoom in (default is 0)
%       saveTF       : whether or not to save the output figures (default is
%                       false)
%       savefigfolder: location to save output figures (default is empty
%                       string)
% 
%   Output is 4 scatterplots scatterplot with the following vs. PRM location:
%       1 - abs(calc - sim)/ sim
%       2 - abs(calc - sim)/ calc
%       3 - abs(calc - sim)
%       4 - 1-3 plotted simultaneuosly 
%       5 - calc/sim
%
%   Has the potential to make plots for dimer or ratio, too.
%
%   Each figure contains a 3x5 tiled layout with a plot for the
%   following 15 delivery sites:
%       "Prvec0"
%       "Prvec0_halfup"
%       "Prvec0_halfup_op"
%       "Prvec0_op"
%       "Prvec0_up"
%       "Prvec0_up_op"
%       "Prvec_cen"
%       "Prvec_cen_halfup"
%       "Prvec_cen_up"  
%       "Prvec_offcen"
%       "Prvec_offcen_halfup"
%       "Prvec_offcen_halfup_op"    
%       "Prvec_offcen_op"   
%       "Prvec_offcen_up"
%       "Prvec_offcen_up_op"
% 
%   Uses the function Pr.m (located in ForminKineticModel) to calculate
%   values.
% 
% See also MAKELOOKUPMAT, LOOKUPTABLE, PR.
arguments
    lt Lookuptable
    FH2size double
    type
    logscale=true
    xzoom=0
    saveTF=0
    savefigfolder="" 
end
    NMAX=400; % only go to this FH1 size (due to simulation error beyond this)

    simtype='a'; % a or b or avg

    set(groot,'defaultfigureposition',[400 250 1500 800]) % helps prevent cut offs in figs

    if logscale
        scalefun= @(x) log10(x);
    else
        scalefun= @(x) (x);
    end
    
    prvec_types=["Prvec0","Prvec0_halfup","Prvec0_halfup_op","Prvec0_op","Prvec0_up","Prvec0_up_op","Prvec_cen","Prvec_cen_halfup","Prvec_cen_up","Prvec_offcen","Prvec_offcen_halfup","Prvec_offcen_halfup_op","Prvec_offcen_op","Prvec_offcen_up","Prvec_offcen_up_op"];
    prvec_types_names=["attachment","halfup","halfup,op","op","up","up,op","cen","cen,halfup","cen,up","offcen","offcen,halfup","offcen,halfup,op","offcen,op","offcen,up","offcen,up,op"];
    x_coords=[0,0,FH2size,FH2size,0,FH2size,FH2size/2,FH2size/2,FH2size/2,(FH2size/2)-8.333,(FH2size/2)-8.333,(FH2size/2)+8.333,(FH2size/2)+8.333,(FH2size/2)-8.333,(FH2size/2)+8.333];
    y_coords=[0,8.333,8.333,0,16.666,16.666,0,8.333,16.666,0,8.333,8.333,0,16.666,16.666];
    r=(x_coords.^2+y_coords.^2).^(1/2);
    
    loctypes=["","_0_100000","_0_250000","_0_500000","_0_750000","_1_000000","_2_000000","_4_000000","_10_000000","_20_000000","_36_000000"];
    locs=[0,0.1,0.25,0.5,0.75,1,2,4,10,20,36];
    
    % for l=1:length(loctypes)
    %     for k=2:2
    %         fig(k)=nplot(type,k,'prmloc',0,loctypes(l));
    %         %fig(k)=nplot(type,k,'nNT',0);
    %     end
    % end

    %fig=plotbest(type,'prmloc');

    %fig=plotradsweep(type,'prmloc');

    fig=plotradsweep_sums(type,'prmloc');
    
    function fig1=nplot(type,scattype,xval,rmext,loctype)
        fig1=figure;
        tiles = tiledlayout(5,3,'TileSpacing','tight','Padding','none');
        for i=1:15
            ax1=nexttile(i);
            valtab=lt.stattable(strcat(prvec_types(i),loctype),type);
            valtab.a(1,4)=0;
            for j=1:length(valtab.a)
                if type=="ratio"
                    val=pr(valtab.a(j,2),valtab.a(j,1),FH2size,1,x_coords(i),y_coords(i),type);
                else
                    val=pr(valtab.a(j,2),valtab.a(j,1),FH2size,1,x_coords(i),y_coords(i),type)/(6.1503*10^7);
                end
                valtab.a(j,4)=val;
            end
            fh1s=valtab.a(:,1);
            nvals=(valtab.a(:,2)).^(1);
            NTvals=fh1s-nvals;
            nprimevals=(nvals.*((fh1s.*2)-nvals))./(fh1s.*2);
            if simtype=='a'
                sima=valtab.a(:,3);
            elseif simtype=='b'
                sima=valtab.b(:,3);
            elseif simtype=='avg'
                sima=mean([valtab.a(:,3),valtab.b(:,3)],2);
            end
            calc=valtab.a(:,4);
            diff=abs(calc-sima);
            diff_raw=calc-sima;
            rat=calc./sima;
            T=table(fh1s,nvals,scalefun(diff),scalefun(diff./sima),scalefun(diff./calc),scalefun(rat),diff_raw./calc,nprimevals,NTvals,'VariableNames',{'fh1len','prmloc','diff','pdiffsim','pdiffcalc','ratio','diffraw','nprime','nNT'});
            if i==1
                pindex=randperm(size(T,1));
            end
            T = T(pindex,:);
            T(T.fh1len>NMAX,:)=[]; %remove too long FH1s
            if rmext
                T(T.prmloc<r(i),:)=[]; %remove PRM locs that can't reach the delivery site
            end
            if scattype==1
                s=scatter(ax1,T,xval,'pdiffcalc','filled','SizeData',10,'DisplayName',strcat("abs(sim ",simtype,"-calc)/calc"));
                hold on
                s=scatter(ax1,T,xval,'pdiffsim','filled','SizeData',10,'DisplayName',strcat("abs(sim ",simtype,"-calc)/sim ",simtype));
                s=scatter(ax1,T,xval,'diff','filled','SizeData',10,'DisplayName',strcat("abs(sim ",simtype,"-calc)"));
            elseif scattype==2
                s=scatter(ax1,T,xval,'pdiffcalc','filled','SizeData',10,'DisplayName',strcat("abs(sim ",simtype,"-calc)/calc"),'ColorVariable','fh1len','MarkerFaceAlpha',0.5);
                if mod(i,3)==0
                    colormap("cool")
                    c=colorbar;
                    c.Label.String = 'FH1 Size';
                end
            elseif scattype==3
                s=scatter(ax1,T,xval,'pdiffsim','filled','SizeData',10,'DisplayName',strcat("abs(sim ",simtype,"-calc)/sim ",simtype),'ColorVariable','fh1len','MarkerFaceAlpha',0.5);
                if mod(i,3)==0
                    colormap("cool")
                    c=colorbar;
                    c.Label.String = 'FH1 Size';
                end
            elseif scattype==4
                s=scatter(ax1,T,xval,'diff','filled','SizeData',10,'DisplayName',strcat("abs(sim ",simtype,"-calc)"),'ColorVariable','fh1len','MarkerFaceAlpha',0.5);
                if mod(i,3)==0
                    colormap("cool")
                    c=colorbar;
                    c.Label.String = 'FH1 Size';
                end
            elseif scattype==5
                s=scatter(ax1,T,xval,'ratio','filled','SizeData',10,'DisplayName',strcat("calc / sim ",simtype),'ColorVariable','fh1len','MarkerFaceAlpha',0.5);
                if mod(i,3)==0
                    colormap("cool")
                    c=colorbar;
                    c.Label.String = 'FH1 Size';
                end
            elseif scattype==6
                s=scatter(ax1,T,xval,'diffraw','filled','SizeData',10,'DisplayName',strcat("calc-sima / calc ",simtype),'ColorVariable','fh1len','MarkerFaceAlpha',0.5);
                if mod(i,3)==0
                    colormap("cool")
                    c=colorbar;
                    c.Label.String = 'FH1 Size';
                end
            end
            
            xlim(ax1,[xzoom Inf])
            title(strcat(type," FH2size: ",num2str(FH2size),"; delivery site: ",strcat(prvec_types_names(i),loctype),"[",num2str(x_coords(i)),",",num2str(y_coords(i)),"]"))
            if i>=13
                if xval=="nprime"
                    xlabel(ax1,"n'")
                elseif xval=="prmloc"
                    xlabel(ax1,"PRM location- FH2 dist")
                elseif xval=="nNT"
                    xlabel(ax1,"PRM location- NT dist")
                end
            else
                xlabel(ax1,"");
            end
            if mod(i+2,3)==0
                if logscale
                    ylabel(ax1,"log10 Prvec")
                else
                    ylabel(ax1,"Prvec")
                end
            else
                ylabel(ax1,"")
            end
            legend
        end
        if(saveTF)
            fname=strcat('Probdensity_check_Nplot',num2str(FH2size),"_",type);
            saveas(gcf,fullfile(savefigfolder,strcat(fname,'.png')),'png');
            saveas(gcf,fullfile(savefigfolder,strcat(fname,'.fig')),'fig');
            saveas(gcf,fullfile(savefigfolder,strcat(fname,'.eps')),'epsc');
        end
    end

    function fig1=plotbest(type,xval)
        fig1=figure;
        tiles = tiledlayout(5,3,'TileSpacing','tight','Padding','none');
        for i=1:15
            ax1=nexttile(i);
            for k=1:length(loctypes)
                valtab=lt.stattable(strcat(prvec_types(i),loctypes(k)),type);
                valtab.a(1,4)=0;
                for j=1:length(valtab.a)
                    if type=="ratio"
                        val=pr(valtab.a(j,2),valtab.a(j,1),FH2size,1,x_coords(i),y_coords(i),type);
                    else
                        val=pr(valtab.a(j,2),valtab.a(j,1),FH2size,1,x_coords(i),y_coords(i),type)/(6.1503*10^7);
                    end
                    valtab.a(j,4)=val;
                end
                if simtype=='a'
                    sima=valtab.a(:,3);
                elseif simtype=='b'
                    sima=valtab.b(:,3);
                elseif simtype=='avg'
                    sima=mean([valtab.a(:,3),valtab.b(:,3)],2);
                end

                calc=valtab.a(:,4);
                diff=abs(calc-sima);

                if k==1
                    nvals=(valtab.a(:,2)).^(1);
                    lowesterr=diff;
                    bestrad=nvals./100;
                else
                    better=(lowesterr>diff);
                    bestrad(better)=locs(k);
                end

            end
            fh1s=valtab.a(:,1);
            NTvals=fh1s-nvals;
            nprimevals=(nvals.*((fh1s.*2)-nvals))./(fh1s.*2);

            
            T=table(fh1s,nvals,nprimevals,NTvals,log10(bestrad),'VariableNames',{'fh1len','prmloc','nprime','nNT','bestrad'});
            if i==1
                pindex=randperm(size(T,1));
            end
            T = T(pindex,:);
            T(T.fh1len>NMAX,:)=[]; %remove too long FH1s
            %T(T.prmloc<r(i),:)=[]; %remove PRM locs that can't reach the delivery site
            s=scatter(ax1,T,xval,'fh1len','filled','SizeData',10,'ColorVariable','bestrad','MarkerFaceAlpha',0.5);
            
            if mod(i,3)==0
                colormap("cool")
                c=colorbar;
                c.Limits=[-2 log10(max(locs))];
                c.Label.String = 'log_{10} Test Radius';
            end
            xlim(ax1,[xzoom Inf])
            title(strcat(type," FH2size: ",num2str(FH2size),"; delivery site: ",prvec_types_names(i),"[",num2str(x_coords(i)),",",num2str(y_coords(i)),"]"))
            if i>=13
                if xval=="nprime"
                    xlabel(ax1,"n'")
                elseif xval=="prmloc"
                    xlabel(ax1,"PRM location- FH2 dist")
                elseif xval=="nNT"
                    xlabel(ax1,"PRM location- NT dist")
                end
            else
                xlabel(ax1,"");
            end
            if mod(i+2,3)==0
                ylabel(ax1,"FH1 length")
            else
                ylabel(ax1,"")
            end
        end

    end

    function fig1=plotradsweep(type,xval)
        fig1=figure;
        tiles = tiledlayout(5,3,'TileSpacing','tight','Padding','none');
        for i=1:15
            ax1=nexttile(i);
            for k=1:length(loctypes)
                valtab=lt.stattable(strcat(prvec_types(i),loctypes(k)),type);
                valtab.a(1,4)=0;
                for j=1:length(valtab.a)
                    if type=="ratio"
                        val=pr(valtab.a(j,2),valtab.a(j,1),FH2size,1,x_coords(i),y_coords(i),type);
                    else
                        val=pr(valtab.a(j,2),valtab.a(j,1),FH2size,1,x_coords(i),y_coords(i),type)/(6.1503*10^7);
                    end
                    valtab.a(j,4)=val;
                end
                if simtype=='a'
                    sima=valtab.a(:,3);
                elseif simtype=='b'
                    sima=valtab.b(:,3);
                elseif simtype=='avg'
                    sima=mean([valtab.a(:,3),valtab.b(:,3)],2);
                end

                calc=valtab.a(:,4);

                if k==1
                    nvals=(valtab.a(:,2)).^(1);
                    radval=nvals./100;
                else
                    radval(:)=locs(k);
                end
                fh1s=valtab.a(:,1);
                NTvals=fh1s-nvals;
                nprimevals=(nvals.*((fh1s.*2)-nvals))./(fh1s.*2);

                T=table(fh1s,nvals,nprimevals,NTvals,log10(calc),log10(sima),log10(radval),'VariableNames',{'fh1len','prmloc','nprime','nNT','calc','sim','radval'});
                if i==1
                    pindex=randperm(size(T,1));
                end
                T = T(pindex,:);
                T(T.fh1len>NMAX,:)=[]; %remove too long FH1s
                T(T.prmloc<r(i),:)=[]; %remove PRM locs that can't reach the delivery site
                s=scatter(ax1,T,xval,'sim','filled','SizeData',10,'ColorVariable','radval','MarkerFaceAlpha',0.5);
                hold on
                if k==length(loctypes)
                    s=scatter(ax1,T,xval,'calc','filled','SizeData',10,'MarkerFaceColor','black');
                    hold on
                end
            end

            if mod(i,3)==0
                colormap("cool")
                c=colorbar;
                c.Limits=[-2 log10(max(locs))];
                c.Label.String = 'log_{10} Test Radius';
            end
            xlim(ax1,[xzoom Inf])
            title(strcat(type," FH2size: ",num2str(FH2size),"; delivery site: ",prvec_types_names(i),"[",num2str(x_coords(i)),",",num2str(y_coords(i)),"]"))
            if i>=13
                if xval=="nprime"
                    xlabel(ax1,"n'")
                elseif xval=="prmloc"
                    xlabel(ax1,"PRM location- FH2 dist")
                elseif xval=="nNT"
                    xlabel(ax1,"PRM location- NT dist")
                end
            else
                xlabel(ax1,"");
            end
            if mod(i+2,3)==0
                ylabel(ax1,"log_{10} Prvec")
            else
                ylabel(ax1,"")
            end
        end

    end

    function fig1=plotradsweep_sums(type,xval)
        fig1=figure;
        tiles = tiledlayout(5,3,'TileSpacing','tight','Padding','none');
        for i=1:15
            ax1=nexttile(i);
            for k=1:length(loctypes)
                valtab=lt.stattable(strcat(prvec_types(i),"_sum",loctypes(k)),type);
                if simtype=='a'
                    sima=valtab.a(:,3);
                elseif simtype=='b'
                    sima=valtab.b(:,3);
                elseif simtype=='avg'
                    sima=mean([valtab.a(:,3),valtab.b(:,3)],2);
                end

                if k==1
                    nvals=(valtab.a(:,2)).^(1);
                    radval=nvals./100;
                else
                    radval(:)=locs(k);
                end
                fh1s=valtab.a(:,1);
                NTvals=fh1s-nvals;
                nprimevals=(nvals.*((fh1s.*2)-nvals))./(fh1s.*2);

                T=table(fh1s,nvals,nprimevals,NTvals,log10(sima),log10(radval),'VariableNames',{'fh1len','prmloc','nprime','nNT','sim','radval'});
                if i==1
                    pindex=randperm(size(T,1));
                end
                T = T(pindex,:);
                T(T.fh1len>NMAX,:)=[]; %remove too long FH1s
                s=scatter(ax1,T,xval,'sim','filled','SizeData',10,'ColorVariable','radval','MarkerFaceAlpha',0.5);
                hold on
            end

            if mod(i,3)==0
                colormap("cool")
                c=colorbar;
                c.Limits=[-2 log10(max(locs))];
                c.Label.String = 'log_{10} Test Radius';
            end
            xlim(ax1,[xzoom Inf])
            title(strcat(type," FH2size: ",num2str(FH2size),"; delivery site: ",prvec_types_names(i),"[",num2str(x_coords(i)),",",num2str(y_coords(i)),"]"))
            if i>=13
                if xval=="nprime"
                    xlabel(ax1,"n'")
                elseif xval=="prmloc"
                    xlabel(ax1,"PRM location- FH2 dist")
                elseif xval=="nNT"
                    xlabel(ax1,"PRM location- NT dist")
                end
            else
                xlabel(ax1,"");
            end
            if mod(i+2,3)==0
                ylabel(ax1,"log_{10} Prvec counts")
            else
                ylabel(ax1,"")
            end
        end

    end
end