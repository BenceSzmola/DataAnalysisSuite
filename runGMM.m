function [chosenGMM,clustInds,lowClust,gofVals,dropPercent] = runGMM(data2fit,s)


tAxFeatInd = 0;

upEnvFeatInd = 1;
instEFeatInd = 5;

gmmModels = cell(s.maxCompNum,1);
if strcmp(s.compNumSelMode,'silh')
    silh = zeros(s.maxCompNum,s.winLen);
end

for k = 1:s.maxCompNum
    gmmModels{k} = fitgmdist(data2fit,k,'RegularizationValue',1e-3,...
        'Options',statset('Display','final','MaxIter',200,'TolFun',1e-6),...
        'Replicates',3);

    if strcmp(s.compNumSelMode,'silh')
        clustInds = cluster(gmmModels{k},data2fit);
        silh(k,:) = silhouette(data2fit,clustInds);
    end
end

switch s.compNumSelMode
    case 'silh'
        gofVals           = mean(silh,2);
        [~,compNumChoice] = max(gofVals);
    case 'BICelbow'
        gofVals           = cellfun(@(x) x.BIC,gmmModels);

        [~,compNumChoice] = max(diff(gofVals,2));
        compNumChoice     = compNumChoice + 1;
    case 'BICmin'
        gofVals           = cellfun(@(x) x.BIC,gmmModels);
        [~,compNumChoice] = min(gofVals);
    case 'AICelbow'
        gofVals           = cellfun(@(x) x.AIC,gmmModels);

        [~,compNumChoice] = max(diff(gofVals,2));
        compNumChoice     = compNumChoice + 1;
    case 'AICmin'
        gofVals           = cellfun(@(x) x.AIC,gmmModels);
        [~,compNumChoice] = min(gofVals);
end

dropPercent = (gofVals(compNumChoice) - gofVals(1)) / gofVals(1);
if round(dropPercent,2) > -s.minCritValDrop
    compNumChoice = 1;
end

chosenGMM             = gmmModels{compNumChoice};
if compNumChoice == 1
    [~,lowClust]      = min(abs(gmmModels{2}.mu(:,tAxFeatInd + 1:end)),[],1);
    lowClust          = round(mean(lowClust));
    lowClustMeans     = gmmModels{2}.mu(lowClust,tAxFeatInd + 1:end);
    lowClustVars      = diag(gmmModels{2}.Sigma(tAxFeatInd + 1:end,tAxFeatInd + 1:end,lowClust));
    
    [~,highClust]     = max(abs(gmmModels{2}.mu(:,tAxFeatInd + 1:end)),[],1);
    highClust         = round(mean(highClust));
    highClustMeans    = gmmModels{2}.mu(highClust,tAxFeatInd + 1:end);
    highClustVars     = diag(gmmModels{2}.Sigma(tAxFeatInd + 1:end,tAxFeatInd + 1:end,highClust));

    high2lowUpEnv     = highClustVars(upEnvFeatInd) / lowClustVars(upEnvFeatInd);
    high2lowInstE     = highClustVars(instEFeatInd) / lowClustVars(instEFeatInd);

    if ((gofVals(2)-gofVals(1))/gofVals(1) <= -s.minCritValDrop2) && (high2lowUpEnv > s.envHigh2Low) && (high2lowInstE > s.instEHigh2Low)
        chosenGMM     = gmmModels{2};
    end
end

[~,lowClust]      = min(abs(chosenGMM.mu(:,tAxFeatInd + 1:end)),[],1);
lowClust          = round(mean(lowClust));

clustInds = cluster(chosenGMM,data2fit);