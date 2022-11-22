% function [niceIvs,mehIvs,badIvs] = clustIvFilter(fs,currInds,chosenGMM,lowClust,clustInds,k,upThr,lowThr,currDoG,currUpEnv,currLowEnv,currIp,currInstE,currInstEbad,s)
function evInds = clustIvFilter(fs,evInds,currInds,chosenGMM,lowClust,clustInds,k,upThr,lowThr,currTaxis,currDoG,currUpEnv,currLowEnv,currIp,currInstE,currInstEbad,s)

% niceIvs = zeros(0,2);
% mehIvs  = zeros(0,2);
% badIvs  = zeros(0,2);

upEnvFeatInd  = 1;
lowEnvFeatInd = 2;
iPFeatInd     = 3;
instEFeatInd  = 5;

if s.debugPlots
    eoiFig = figure('Name','Potential events figure','Units','normalized','Position',[.3,.3,.6,.3]);
    eoiFigAx = axes(eoiFig);
    plot(eoiFigAx,currTaxis,currDoG)
    hold(eoiFigAx,'on')
    yline(eoiFigAx,upThr,'m','LineWidth',1);
    yline(eoiFigAx,lowThr,'m','LineWidth',1);
    plot(eoiFigAx,currTaxis,currUpEnv,'--')
    plot(eoiFigAx,currTaxis,currLowEnv,'--')
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
        clustIvXLine1 = xline(eoiFigAx,currTaxis(currClustIv(1)),'r--','LineWidth',1);
        clustIvXLine2 = xline(eoiFigAx,currTaxis(currClustIv(end)),'r--','LineWidth',1);
    end

    if isempty(find(currUpEnv(currClustIv) > upThr,1)) || isempty(find(currLowEnv(currClustIv) < lowThr,1))
        if s.debugPlots
            fprintf('No above threshold data in this interval, moving on...\n')
            waitforbuttonpress
            delete([clustIvXLine1,clustIvXLine2])
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
            delete([clustIvXLine1,clustIvXLine2])
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
                    clustSubIvXLine1 = xline(eoiFigAx,currTaxis(currSegment(1)),'g-.','LineWidth',1);
                    clustSubIvXLine2 = xline(eoiFigAx,currTaxis(currSegment(end)),'g-.','LineWidth',1);
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
                    delete([clustSubIvXLine1,clustSubIvXLine2])
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
                delete([clustIvXLine1,clustIvXLine2])
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
            delete([clustIvXLine1,clustIvXLine2])
        end
        continue
    end

    if length(find(currInstE(currClustIv) < currInstEbad(currClustIv)))/length(currClustIv) > s.clustIvGoodRatioMin
        if s.debugPlots
            fprintf(1,'Most of cluster interval has higher bad instE, skip!\n')
            waitforbuttonpress
            delete([clustIvXLine1,clustIvXLine2])
        end
        continue
    end

    if ( trapz(currInstEbad(currClustIv)) / trapz(currInstE(currClustIv)) ) > .75
        if s.debugPlots
            fprintf(1,'Cluster interval has higher bad instE AUC, skip!\n')
            waitforbuttonpress
            delete([clustIvXLine1,clustIvXLine2])
        end
        continue
    end

    ivsOI  = computeAboveThrLengths([currUpEnv(currClustIv); currLowEnv(currClustIv)],...
        [upThr,lowThr],[">","<"],s.envThrCrossMinLen,[],s.envThrCrossMode);

    for highIvNum = 1:size(ivsOI,1)
        currHighIv = currClustIv(ivsOI(highIvNum,1):ivsOI(highIvNum,2));

        if s.debugPlots
            xl1 = xline(eoiFigAx,currTaxis(currHighIv(1)),'r','LineWidth',1);
            xl2 = xline(eoiFigAx,currTaxis(currHighIv(end)),'r','LineWidth',1);
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
                delete([xl1, xl2])
            end
            continue
        end

        [r,lags] = xcorr(currDoG(currHighIv),'coeff');
        r        = r(floor(length(r)/2) + 1:end);
        lags     = lags(floor(length(lags)/2) + 1:end);
        [decCosFit,gof,~,fit_theta,fit_time2base,fit_cycles2base] = decayingCosFit(lags,r,fs);

        if s.debugPlots
            xcorrFig = figure('Name','Autocorrelation figure');
            plot(decCosFit,lags/fs,r)

            waitfor(xcorrFig)

            waitforbuttonpress
            delete([xl1, xl2])
        end

        conds = [(fit_time2base > s.evFitT(1)) && (fit_time2base < s.evFitT(2)),...
                 fit_cycles2base >= s.evFitCycMin,...
                 (fit_theta >= s.evFitTheta(1)) && (fit_theta <= s.evFitTheta(2)),...
                 gof.rsquare > s.evFitRsqMin];

        if all(conds)
            evInds(currInds(currHighIv)) = 1;
        elseif sum(~conds) <= s.maxNumFailedCrits
            evInds(currInds(currHighIv)) = 2;
        end
    end

    if s.debugPlots
        fprintf('Done with this cluster segment, moving on...\n')
        waitforbuttonpress
        delete([clustIvXLine1,clustIvXLine2])
    end

end

if s.debugPlots
    delete(eoiFig)
end