% function [niceIvs,mehIvs,badIvs] = clustIvFilter(fs,currInds,chosenGMM,lowClust,clustInds,k,upThr,lowThr,currDoG,currUpEnv,currLowEnv,currIp,currInstE,currInstEbad,s)
function evInds = clustIvFilter(fs,evInds,currInds,chosenGMM,lowClust,clustInds,k,currTaxis,currDoG,currUpEnv,currLowEnv,currIp,currInstE,currInstEbad,s)

% niceIvs = zeros(0,2);
% mehIvs  = zeros(0,2);
% badIvs  = zeros(0,2);

upEnvFeatInd  = 1;
lowEnvFeatInd = 2;
iPFeatInd     = 3;
instEFeatInd  = 5;

upThr    = chosenGMM.mu(lowClust,upEnvFeatInd) + s.envThrSdMult*sqrt(chosenGMM.Sigma(upEnvFeatInd,upEnvFeatInd,lowClust));
lowThr   = chosenGMM.mu(lowClust,lowEnvFeatInd) - s.envThrSdMult*sqrt(chosenGMM.Sigma(lowEnvFeatInd,lowEnvFeatInd,lowClust));
iPThr    = chosenGMM.mu(lowClust,iPFeatInd) + s.instPowThrSdMult*sqrt(chosenGMM.Sigma(iPFeatInd,iPFeatInd,lowClust));
instEThr = chosenGMM.mu(lowClust,instEFeatInd) + s.instEThrSdMult*sqrt(chosenGMM.Sigma(instEFeatInd,instEFeatInd,lowClust));
    

if s.debugPlots
    eoiFig = figure('Name','Potential events figure','Units','normalized','Position',[.3,.3,.6,.3]);
    eoiFigSp1 = subplot(3,1,1,'Parent',eoiFig);
    plot(eoiFigSp1,currTaxis,currDoG)
    hold(eoiFigSp1,'on')
    yline(eoiFigSp1,upThr,'m','LineWidth',1);
    yline(eoiFigSp1,lowThr,'m','LineWidth',1);
    plot(eoiFigSp1,currTaxis,currUpEnv,'--')
    plot(eoiFigSp1,currTaxis,currLowEnv,'--')

    eoiFigSp2 = subplot(3,1,2,'Parent',eoiFig);
    plot(eoiFigSp2,currTaxis,currIp)
    hold(eoiFigSp2,'on')
    yline(eoiFigSp2,iPThr,'m','LineWidth',1);

    eoiFigSp3 = subplot(3,1,3,'Parent',eoiFig);
    plot(eoiFigSp3,currTaxis,currInstE)
    hold(eoiFigSp3,'on')
    yline(eoiFigSp3,instEThr,'m','LineWidth',1);
end

clustIvs = computeAboveThrLengths(clustInds',k,'==');
for ivNum = 1:size(clustIvs)-1
    if (clustIvs(ivNum + 1,1) - clustIvs(ivNum,2)) <= s.clustGapFillLen
        clustInds(clustIvs(ivNum,2):clustIvs(ivNum + 1,1)) = k;
    end
end

currClustIvs = computeAboveThrLengths(clustInds',k,'==',s.clustIvLen(1),s.clustIvLen(2));
for ivNum = 1:size(currClustIvs,1)
    currClustIv = currClustIvs(ivNum,1):currClustIvs(ivNum,2);

    if s.debugPlots
        xline(eoiFigSp1,currTaxis(currClustIv(1)),'r--','LineWidth',1);
        xline(eoiFigSp1,currTaxis(currClustIv(end)),'r--','LineWidth',1);

        xline(eoiFigSp2,currTaxis(currClustIv(1)),'r--','LineWidth',1);
        xline(eoiFigSp2,currTaxis(currClustIv(end)),'r--','LineWidth',1);
        
        xline(eoiFigSp3,currTaxis(currClustIv(1)),'r--','LineWidth',1);
        xline(eoiFigSp3,currTaxis(currClustIv(end)),'r--','LineWidth',1);
    end

    if isempty(find(currUpEnv(currClustIv) > upThr,1)) || isempty(find(currLowEnv(currClustIv) < lowThr,1))
        if s.debugPlots
            fprintf('No above threshold data in this interval, moving on...\n')
            waitforbuttonpress
            delete(findobj(eoiFig,'Type','constantline','-and','InterceptAxis','x'))
        end

        continue
    end

    [r,lags] = xcorr(currDoG(currClustIv),'coeff');
    r        = r(floor(length(r)/2) + 1:end);
    lags     = lags(floor(length(lags)/2) + 1:end);
    [~,gof,~,fit_theta,fit_time2base,fit_cycles2base] = decayingCosFit(lags,r,fs);

    conds = [gof.rsquare < s.clustIvFitRsqMin,...
             fit_cycles2base < s.clustIvFitCycMin,...
             fit_time2base < s.clustIvFitTMin,...
             fit_theta < s.clustIvFitTheta(1) || fit_theta > s.clustIvFitTheta(2)];
    if sum(conds) > 2

        if s.debugPlots
            fprintf('Cluster interval initial fit fail, moving on...\n')
            waitforbuttonpress
            delete(findobj(eoiFig,'Type','constantline','-and','InterceptAxis','x'))
        end

        continue

    elseif sum(conds) > 0
        belowThrIvs = computeAboveThrLengths([currUpEnv(currClustIv); currLowEnv(currClustIv)],...
            [upThr,lowThr],["<",">"],s.clustGapMinLen,[],"&");
        skipThis = true;

        if ~isempty(belowThrIvs)

            for gapIvInd = 1:size(belowThrIvs,1)+1
                if gapIvInd == 1
                    currSegment = currClustIv(1:belowThrIvs(gapIvInd,1));
                elseif gapIvInd == (size(belowThrIvs,1)+1)
                    currSegment = currClustIv(belowThrIvs(gapIvInd-1,2):end);
                else
                    currSegment = currClustIv(belowThrIvs(gapIvInd-1,2):belowThrIvs(gapIvInd,1));
                end
    
                if s.debugPlots
                    xline(eoiFigSp1,currTaxis(currSegment(1)),'g-.','LineWidth',1);
                    xline(eoiFigSp1,currTaxis(currSegment(end)),'g-.','LineWidth',1);

                    xline(eoiFigSp2,currTaxis(currSegment(1)),'g-.','LineWidth',1);
                    xline(eoiFigSp2,currTaxis(currSegment(end)),'g-.','LineWidth',1);

                    xline(eoiFigSp3,currTaxis(currSegment(1)),'g-.','LineWidth',1);
                    xline(eoiFigSp3,currTaxis(currSegment(end)),'g-.','LineWidth',1);
                end
    
                if length(currSegment) >= s.envThrCrossMinLen
                    [r,lags] = xcorr(currDoG(currSegment),'coeff');
                    r        = r(floor(length(r)/2) + 1:end);
                    lags     = lags(floor(length(lags)/2) + 1:end);
                    [~,gof,~,fit_theta,fit_time2base,fit_cycles2base] = decayingCosFit(lags,r,fs);
                    
                    conds = [gof.rsquare >= s.clustIvFitRsqMin,...
                             fit_cycles2base >= s.clustIvFitCycMin,...
                             fit_time2base >= s.clustIvFitTMin,...
                             fit_theta >= s.clustIvFitTheta(1) && fit_theta <= s.clustIvFitTheta(2)];
                    if sum(conds) >= 2
                        skipThis = false;

                        if s.debugPlots
                            waitforbuttonpress
                            delete(findobj(eoiFig,'Type','constantline','-and','InterceptAxis','x','-and','LineStyle','-.'))
                        end

                        break
                    end
                else
                    if s.debugPlots
                        fprintf(1,'Segment not long enough!\n')
                        waitforbuttonpress
                    end
                end
    
                if s.debugPlots
                    waitforbuttonpress
                    delete(findobj(eoiFig,'Type','constantline','-and','InterceptAxis','x','-and','LineStyle','-.'))
                end
    
            end

        else
            if s.debugPlots
                fprintf(1,'No intervals for secondary fitting!\n')
                waitforbuttonpress
            end
        end

        if skipThis
            if s.debugPlots
                fprintf('Cluster interval second try fit still failed, moving on...\n')
                waitforbuttonpress
                delete(findobj(eoiFig,'Type','constantline','-and','InterceptAxis','x'))
            end

            continue
        end
    end

    stdRatios  = std(currInstE(currClustIv)) / std(currInstEbad(currClustIv));
    meanRatios = mean(currInstE(currClustIv)) / mean(currInstEbad(currClustIv));

    if (round(meanRatios,2) < s.clustIvAvgRatioMin) || (round(stdRatios,2) < s.clustIvSdRatioMin)
        if s.debugPlots
            fprintf('Cluster interval failed on std and mean ratios, moving on...\n')
            waitforbuttonpress
            delete(findobj(eoiFig,'Type','constantline','-and','InterceptAxis','x'))
        end
        continue
    end

    if length(find(currInstE(currClustIv) < currInstEbad(currClustIv)))/length(currClustIv) > s.clustIvGoodRatioMin
        if s.debugPlots
            fprintf(1,'Most of cluster interval has higher bad instE, skip!\n')
            waitforbuttonpress
            delete(findobj(eoiFig,'Type','constantline','-and','InterceptAxis','x'))
        end
        continue
    end

    if ( trapz(currInstEbad(currClustIv)) / trapz(currInstE(currClustIv)) ) > .75
        if s.debugPlots
            fprintf(1,'Cluster interval has higher bad instE AUC, skip!\n')
            waitforbuttonpress
            delete(findobj(eoiFig,'Type','constantline','-and','InterceptAxis','x'))
        end
        continue
    end

    ivsOI_env   = computeAboveThrLengths([currUpEnv(currClustIv); currLowEnv(currClustIv)],...
                        [upThr,lowThr],[">","<"],s.envThrCrossMinLen,[],s.envThrCrossMode);
    ivsOI_iP    = computeAboveThrLengths(currIp(currClustIv),iPThr,">",s.envThrCrossMinLen);
    ivsOI_instE = computeAboveThrLengths(currInstE(currClustIv),instEThr,">",s.envThrCrossMinLen);
    ivsOI       = intervalUnify({ivsOI_env,ivsOI_iP,ivsOI_instE});

    for highIvNum = 1:size(ivsOI,1)
        currHighIv = currClustIv(ivsOI(highIvNum,1):ivsOI(highIvNum,2));

        if s.debugPlots
            xline(eoiFigSp1,currTaxis(currHighIv(1)),'r','LineWidth',1);
            xline(eoiFigSp1,currTaxis(currHighIv(end)),'r','LineWidth',1);

            xline(eoiFigSp2,currTaxis(currHighIv(1)),'r','LineWidth',1);
            xline(eoiFigSp2,currTaxis(currHighIv(end)),'r','LineWidth',1);

            xline(eoiFigSp3,currTaxis(currHighIv(1)),'r','LineWidth',1);
            xline(eoiFigSp3,currTaxis(currHighIv(end)),'r','LineWidth',1);
        end

        upEnvBaselineRatio  = ( mean(currUpEnv(currHighIv)) + std(currUpEnv(currHighIv)) )...
            / (chosenGMM.mu(lowClust,upEnvFeatInd) + sqrt(chosenGMM.Sigma(upEnvFeatInd,upEnvFeatInd,lowClust)));
        lowEnvBaselineRatio = ( mean(currLowEnv(currHighIv)) - std(currLowEnv(currHighIv)) )...
            / (chosenGMM.mu(lowClust,lowEnvFeatInd) - sqrt(chosenGMM.Sigma(lowEnvFeatInd,lowEnvFeatInd,lowClust)));
        iPBaselineRatio     = ( mean(currIp(currHighIv)) + std(currIp(currHighIv)) )...
            / (chosenGMM.mu(lowClust,iPFeatInd) + sqrt(chosenGMM.Sigma(iPFeatInd,iPFeatInd,lowClust)));
        instEBaselineRatio  = ( mean(currInstE(currHighIv)) + std(currInstE(currHighIv)) )...
            / (chosenGMM.mu(lowClust,instEFeatInd) + sqrt(chosenGMM.Sigma(instEFeatInd,instEFeatInd,lowClust)));
        
        conds = [upEnvBaselineRatio < s.upEnv2Baseline,...
                 lowEnvBaselineRatio < s.lowEnv2Baseline,...
                 iPBaselineRatio < s.instPow2Baseline,...
                 instEBaselineRatio < s.instE2Baseline];
        if sum(conds) > 2
            if s.debugPlots
                fprintf('Segment failed the comparison to baseline, moving on...\n')
                waitforbuttonpress
                delete(findobj(eoiFig,'Type','constantline','-and','InterceptAxis','x','-and','LineStyle','-'))
            end
            continue
        end

        [r,lags] = xcorr(currDoG(currHighIv),'coeff');
        r        = r(floor(length(r)/2) + 1:end);
        lags     = lags(floor(length(lags)/2) + 1:end);
        [decCosFit,gof,~,fit_theta,fit_time2base,fit_cycles2base] = decayingCosFit(lags,r,fs);

        conds = [(fit_time2base > s.evFitT(1)) && (fit_time2base < s.evFitT(2)),...
                 fit_cycles2base >= s.evFitCycMin,...
                 (fit_theta >= s.evFitTheta(1)) && (fit_theta <= s.evFitTheta(2)),...
                 gof.rsquare > s.evFitRsqMin];

        if s.debugPlots
            xcorrFig = figure('Name','Autocorrelation figure');
            plot(decCosFit,lags/fs,r)
            title(sprintf('# failed conditions: %d',sum(~conds)))

            waitfor(xcorrFig)

            waitforbuttonpress
            delete(findobj(eoiFig,'Type','constantline','-and','InterceptAxis','x','-and','LineStyle','-'))
        end

        if all(conds)
            evInds(currInds(currHighIv)) = 1;
        elseif sum(~conds) <= s.maxNumFailedCrits
            evInds(currInds(currHighIv)) = 2;
        end
    end

    if s.debugPlots
        fprintf('Done with this cluster segment, moving on...\n')
        waitforbuttonpress
        delete(findobj(eoiFig,'Type','constantline','-and','InterceptAxis','x'))
    end

end

if s.debugPlots
    delete(eoiFig)
end