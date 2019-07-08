function [sim_det_gor,doggor,ephys_det_gor,norm_ca_gors,roi_det_gor] = WIP_optimalfilter_withGUI(ingor) %(filename,srate,w1,w2,doplot,save,noisech,refch)

% bemenetek:
%       filename: vagy fajlnev vagy 0 ha felugro ablakban akarsz valasztani
%       srate: sampling rate Hz-ben
%       w1: also szuro hatar
%       w2: felso szuro hatar
%       doplot: csinaljon-e fig-eket (most hagyd 0-n)
%       save: kimentse e a fig-eket (ezt is 0-n)
%       noisech: a zajt tartalmazo csatorna
%       refch: az esem�nyt nem tartalmaz� csatorna
%       window step size: peakkeres�s ablak�nak l�p�se
%       Min event distance
%       sd mult: threshold meghat�roz�s�hoz h�nyszoros sd-t haszn�ljon
%       qsd mult: csendes szakaszokat h�nyszoros sd alapj�n hat�rozza meg
%       sec : h�ny sec-es csendesszakasz alapj�n sz�moljon
%       Event length lower bound
%       Event length upper bound

[debug,plots,mode,caorephys,ca_param,ephys_param,ephyvsca_tolerance,GUI] = eventdetGUI;
ephys_param_prompts = {'Sample rate (Hz)','W1 (Hz)','W2 (Hz)','Step size (ms)','Min event distance (ms)',...
            'Event length min (ms)','Event length max (ms)','sd mult','qsd mult','Quietint length (s)', ...
            'Denoise','Reference chan.','1s shift','Disregard based on refchan'};
ca_param_prompts = {'Sample rate (Hz)','Step size (ms)','Min event distance (ms)',...
            'Event length min (ms)','Event length max (ms)','dF/F threshold','sd mult','qsd mult','gauss_avg_num'};
ephys_proclist = {'DoG + InstPow','DoG','InstPow','None'};
ca_proclist = {'Gauss avg then 10x upsample','None'};

%%% gor fogad�sa
if nargin==0
    [filename, path] = uigetfile('.rhd','Select the RHD');
    cd(path);
    %%% Read RHD
    rhd = read_Intan_RHD2000_file(filename);
    data = rhd.ampdata;
    t_scale = rhd.tdata;
    if debug 
        assignin('base','t_scale',t_scale);
    end
    datatype = questdlg('Ca or Ephys?','Datatype','Ca','Ephys','Ca');
    switch datatype
        case 'Ca'
            caorephys = 2;
            param = ca_param;
        case 'Ephys'
            caorephys = 1;
            param = ephys_param;
    end
    ca_order = []; %%%placeholder
    detettore(data,t_scale,nargin,debug,caorephys,plots,param,ca_order);
    fprintf(1,'Data from console \n');
elseif nargin == 1
    switch mode(1)
        case 0
            t_scale = get(ingor(1),'x')/1000;
            t_scale(2) = t_scale(1)+t_scale(2);
        case 1
            if mode(3) == 1
                ephys_t_scale = get(ingor(1),'x')/1000;
                ephys_t_scale(2) = ephys_t_scale(1)+ephys_t_scale(2);
                ca_t_scale = get(ingor(mode(2)+1),'x')/1000;
                ca_t_scale(2) = ca_t_scale(1)+ca_t_scale(2);
            elseif mode(3) == 2
                ephys_t_scale = get(ingor(end-mode(2)+1),'x')/1000;
                ephys_t_scale(2) = ephys_t_scale(1)+ephys_t_scale(2);
                ca_t_scale = get(ingor(1),'x')/1000;
                ca_t_scale(2) = ca_t_scale(1)+ca_t_scale(2);    
            end
            if debug
                assignin('base','ephys_t_scale',ephys_t_scale);
                assignin('base','ca_t_scale',ca_t_scale);
            end
    end
    
    if mode(1) == 0
        sim_det_gor = [];
        for i = 1:length(ingor)
            data(i,:) = get(ingor(i), 'extracty');
            if debug
                assignin('base','gorindat',data);
            end
        end
        switch caorephys
            case 1 
                param = ephys_param;
                roi_det_gor = [];
                ca_order = [];
            case 2 
                param = ca_param;
                doggor = [];
                ephys_det_gor = [];
        end
        if caorephys == 2
            names = [];
            for i = 1:length(ingor)
                names = cellstr([names ; get(ingor(i),'name')]);
            end
            if debug 
                assignin('base','gornevek',names);
            end
            ca_order = zeros(length(ingor),1);
            for i = 1:size(names,1)
                thenum = [];
                for j = 1:length(names{i})
                    if ~isnan(str2double(names{i}(j))) && isreal(str2double(names{i}(j)))
                        while ~isnan(str2double(names{i}(j)))
                            thenum = [thenum,names{i}(j)];
                            j = j+1;
                        end
%                         ca_order(i) = str2double(names{i}(j));
                        ca_order(i) = str2double(thenum);
                        break
                    end
                end
            end
            if debug 
                assignin('base','ca_order',ca_order);
            end
            if debug
                assignin('base','ca_before',data);
            end
            cadata_ordered = zeros(size(data));
            ca_order = ca_order+1;
            for i = 1:length(ca_order)
                cadata_ordered(ca_order(i),:) = data(i,:);
            end
            if debug 
                assignin('base','ca_after',cadata_ordered);
            end
            ca_order = min(ca_order):(min(ca_order)+length(ca_order)-1);
            data = cadata_ordered;
            data( ~any(data,2), : ) = [];
        end

        [det_thresh,~,t_scale,consensT,ephysleadch,ephyspower,allpeaksT,dogged,normed_ca,true_srate] = detettore(data,t_scale,nargin,debug,caorephys,plots,param,ca_order);
        if debug
            assignin('base','t_scale',t_scale);
        end
        param(1) = true_srate;
        norm_ca_gors = [];
        switch caorephys
            case 2
                roi_det_gor = [];
                for i = 1:size(allpeaksT,3)
                    if sum(allpeaksT(:,1,i)) ~= 0
                        newgor = [];
                        temp = unique(allpeaksT(:,1,i));
                        temp(temp==0) = [];
                        newgor.name=['Detections for roi ',num2str(ca_order(i)-1)];
                        newgor.Marker='*';
                        newgor.MarkerSize=12;
                        newgor.Color='g';
                        newgor.LineStyle='none';
                        newgor.xname = 'Time';
                        newgor.yname = '';
                        newgor.xunit = 'ms';
                        newgor=gorobj('double', temp*1000, 'double', zeros(size(temp)), newgor);
                        roi_det_gor = [roi_det_gor ; newgor];
                    end
                end 
                
                norm_ca_gors = [];
                for i = 1:size(normed_ca,1)
                    newgor = [];
                    newgor.name = ['Normed_Ca_Roi_',num2str(ca_order(i)-1)];
                    newgor.xname = 'Time';
                    newgor.yname = 'dF/F';
                    newgor.xunit = 'ms';
                    newgor = gorobj('eqsamp',[t_scale(1) t_scale(2)-t_scale(1)]*1000,'double',normed_ca(i,:),newgor);
                    newgor = set(newgor,'vars',1,det_thresh(i,2));
                    newgor = set(newgor,'varnames',1,'Threshold');
                    norm_ca_gors = [norm_ca_gors ; newgor];
                end
            case 1
                doggor = [];
                doggor.name=['Consens channel (Ch',num2str(ephysleadch),') DoG'];
                doggor.Color='r';
                doggor.xname='Time';
                doggor.yname='Voltage';
                doggor.xunit='ms';
                doggor.yunit='\muV';
                doggor.axis=2;
                doggor=gorobj('eqsamp', [t_scale(1) t_scale(2)-t_scale(1)]*1000, 'double', dogged(:,ephysleadch), doggor);
                
                powgor = [];
                powgor.name=['Consens channel (Ch',num2str(ephysleadch),') InstPow'];
                powgor.Color='r';
                powgor.xname='Time';
                powgor.yname='Power';
                powgor.xunit='ms';
                powgor.yunit='\muV^2';
                powgor.axis=2;
                powgor=gorobj('eqsamp', [t_scale(1) t_scale(2)-t_scale(1)]*1000, 'double', ephyspower(:,ephysleadch), powgor);
                powgor=set(powgor,'vars',1,det_thresh(ephysleadch,2));
                powgor=set(powgor,'varnames',1,'Threshold');
                
                ref_doggor = [];
                if ephys_param(11)~=0 || ephys_param(14)~=0
                    ref_doggor.name=['Reference channel (Ch',num2str(param(12)),') DoG'];
                    ref_doggor.Color='r';
                    ref_doggor.xname='Time';
                    ref_doggor.yname='Voltage';
                    ref_doggor.xunit='ms';
                    ref_doggor.yunit='\muV';
                    ref_doggor.axis=2;
                    ref_doggor=gorobj('eqsamp', [t_scale(1) t_scale(2)-t_scale(1)]*1000, 'double', dogged(:,param(12)), ref_doggor);
                end
                
                ref_powgor = [];
                if ephys_param(11)~=0 || ephys_param(14)~=0
                    ref_powgor.name=['Reference channel (Ch',num2str(ephys_param(12)),') InstPow'];
                    ref_powgor.Color='r';
                    ref_powgor.xname='Time';
                    ref_powgor.yname='Power';
                    ref_powgor.xunit='ms';
                    ref_powgor.yunit='\muV^2';
                    ref_powgor.axis=2;
                    ref_powgor=gorobj('eqsamp', [t_scale(1) t_scale(2)-t_scale(1)]*1000, 'double', ephyspower(:,param(12)), ref_powgor);
                    ref_powgor=set(ref_powgor,'vars',1,det_thresh(param(12),2));
                    ref_powgor=set(ref_powgor,'varnames',1,'Threshold');
                end
                
                doggor = [doggor ; powgor; ref_doggor; ref_powgor];
                
                ephyscons_onlyT = consensT(:,1);
                ephyscons_onlyT(ephyscons_onlyT==t_scale(1)) = nan;
                if debug
                    assignin('base','ephyscons_onlyT',ephyscons_onlyT)
                end
                
                ephys_det_gor = [];
                ephys_det_gor.name=['Detections consens channel (Ch',num2str(ephysleadch),')'];
                ephys_det_gor.xname='Time';
                ephys_det_gor.yname='';
                ephys_det_gor.xunit='ms';
                ephys_det_gor.Marker='*';
                ephys_det_gor.MarkerSize=12;
                ephys_det_gor.Color='g';
                ephys_det_gor.LineStyle='none';
                ephys_det_gor=gorobj('double',ephyscons_onlyT*1000,'double',zeros(size(ephyscons_onlyT)),ephys_det_gor);
                
                refchan_det_gor = [];
                if ephys_param(11)~=0 || ephys_param(14)~=0
                    refchan_det_gor.name=['Detections reference channel (Ch',num2str(ephys_param(12)),')'];
                    refchan_det_gor.xname='Time';
                    refchan_det_gor.yname='';
                    refchan_det_gor.xunit='ms';
                    refchan_det_gor.Marker='*';
                    refchan_det_gor.MarkerSize=12;
                    refchan_det_gor.Color='g';
                    refchan_det_gor.LineStyle='none';
                    refchan_det_gor=gorobj('double',allpeaksT(:,1,param(12))*1000,'double',zeros(size(allpeaksT(:,1,param(12)))),refchan_det_gor);
                end
                
                ephys_det_gor = [ephys_det_gor ; refchan_det_gor];
        end 
        
        %%% CSV ir�s
        [csvname,path] = uiputfile('*.csv','Name CSV!');
        cd(path);
        fileID = fopen(string(csvname),'w');
        switch caorephys
            case 1 
                fprintf(fileID,'Ephys parameters \n');
                for i = 1:length(ephys_param_prompts)
                    fprintf(fileID,'%s: %d \n',string(ephys_param_prompts(i)),param(i));
                end
                
                fprintf(fileID,'Selected processing: %s \n',ephys_proclist{param(15)});
                
                fprintf(fileID,'\n');
               
                fprintf(fileID,'Lead Channel: %d \n',ephysleadch);
                
                fprintf(fileID,'\n');
                
                fprintf(fileID,'Detection thresholds per channel \n');
                for i = 1:length(ingor)
                    fprintf(fileID,'#%d ; %5.4f \n',i,det_thresh(i,2));
                end
                
                fprintf(fileID,'\n');
                
                fprintf(fileID,'Events grouped by channel (s) \n');
                for i = 1:size(allpeaksT,3)
                    fprintf(fileID,'#%d;',i);
                    for j = 1:length(allpeaksT(:,1,i))
                        if allpeaksT(j,1,i) ~= t_scale(1)
                            fprintf(fileID,'%5.4f;',allpeaksT(j,1,i));
                        end
                    end
                    fprintf(fileID,'\n');
                end
                fprintf(fileID,'Num of events per channel \n');
                for i = 1:size(allpeaksT,3)
                    temp = allpeaksT(:,1,i);
                    temp = temp(temp ~= t_scale(1));
                    fprintf(fileID,'#%d; %d \n',i,length(temp));
                end
                                
            case 2
                fprintf(fileID,'Ca parameters \n');
                for i = 1:length(ca_param_prompts)
                    fprintf(fileID,'%s: %d \n',string(ca_param_prompts(i)),param(i));
                end
                
                fprintf(fileID,'Selected processing: %s \n',ca_proclist{param(10)});
                                               
                fprintf(fileID,'\n');
                
                fprintf(fileID,'Detection thresholds per ROI \n');
                for i = 1:length(ingor)
                    fprintf(fileID,'#%d ; %5.4f \n',ca_order(i)-1,det_thresh(i,2));
                end
                
                fprintf(fileID,'\n');
                
                
                fprintf(fileID,'Events grouped by ROI(s) \n');
                for i = 1:size(allpeaksT,3)
                    fprintf(fileID,'#%d;',ca_order(i)-1);
                    for j = 1:length(allpeaksT(:,1,i))
                        if allpeaksT(j,1,i) ~= t_scale(1)
                            fprintf(fileID,'%5.4f;',allpeaksT(j,1,i));
                        end
                    end
                    fprintf(fileID,'\n');
                end
                fprintf(fileID,'Num of events per ROI \n');
                for i = 1:size(allpeaksT,3)
                    temp = allpeaksT(:,1,i);
                    temp = temp(temp ~= t_scale(1));
                    fprintf(fileID,'#%d; %d \n',ca_order(i)-1,length(temp));
                end
        end
        fclose(fileID);
        
    end
    if mode(1) == 1
        numcach = length(ingor)-mode(2);
        if mode(3) == 1
            for i = 1:mode(2)
                ephysdata(i,:) = get(ingor(i), 'extracty');
            end
            for i = mode(2)+1:length(ingor)
                cadata(i-mode(2),:) = get(ingor(i),'extracty');
            end
            
            names = [];
            for i = mode(2)+1:length(ingor)
                names = cellstr([names ; get(ingor(i),'name')]);
            end
            if debug 
                assignin('base','gornevek',names);
            end
            ca_order = zeros(numcach,1);
            for i = 1:size(names,1)
                thenum = [];
                for j = 1:length(names{i})
                    while ~isnan(str2double(names{i}(j)))
                        thenum = [thenum,names{i}(j)];
                        j = j+1;
                    end
%                         ca_order(i) = str2double(names{i}(j));
                    ca_order(i) = str2double(thenum);
                    break
                end
            end
            if debug 
                assignin('base','ca_order',ca_order);
            end
            
            cadata_ordered = zeros(size(cadata));
            ca_order = ca_order+1;
            for i = 1:length(ca_order)
                cadata_ordered(ca_order(i),:) = data(i,:);
            end
            if debug 
                assignin('base','ca_after',cadata_ordered);
            end
            ca_order = min(ca_order):(min(ca_order)+length(ca_order)-1);
            cadata = cadata_ordered;
            cadata( ~any(cadata,2), : ) = [];
            
            [ephys_det_thresh,~,~,ephysconsensT,ephysleadch,ephyspower,ephys_allpeaksT,dogged,~,ephys_true_srate] = detettore(ephysdata,ephys_t_scale,nargin,debug,1,plots,ephys_param,ca_order);
            [ca_det_thresh,cadata,ca_t_scale,~,~,~,ca_allpeaksT,~,normed_ca,ca_true_srate] = detettore(cadata,ca_t_scale,nargin,debug,2,plots,ca_param,ca_order);
            ca_param(1) = ca_true_srate;
            ephys_param(1) = ephys_true_srate;
            if debug
                assignin('base','ephysconsensT',ephysconsensT);
                assignin('base','ca_allpeaksT',ca_allpeaksT);                
            end
        elseif mode(3) == 2
            numcach = length(ingor)-mode(2);
            for i = (length(ingor)-mode(2)+1):length(ingor)
                ephysdata(i-numcach,:) = get(ingor(i), 'extracty');
            end
            for i = 1:(length(ingor)-mode(2))
                cadata(i,:) = get(ingor(i),'extracty');
            end
            
            names = [];
            for i = 1:(length(ingor)-mode(2))
                names = cellstr([names ; get(ingor(i),'name')]);
            end
            if debug 
                assignin('base','gornevek',names);
            end
            ca_order = zeros(numcach,1);
            for i = 1:size(names,1)
                thenum = [];
                for j = 1:length(names{i})
                    if ~isnan(str2double(names{i}(j))) && isreal(str2double(names{i}(j)))
                        while ~isnan(str2double(names{i}(j)))
                            thenum = [thenum,names{i}(j)];
                            j = j+1;
                        end
%                         ca_order(i) = str2double(names{i}(j));
                        ca_order(i) = str2double(thenum);
                        break
                    end
                end
            end
            if debug 
                assignin('base','ca_order',ca_order);
                assignin('base','ca_before',cadata);
            end
            
            cadata_ordered = zeros(size(cadata));
            ca_order = ca_order+1;
            for i = 1:length(ca_order)
                cadata_ordered(ca_order(i),:) = cadata(i,:);
            end
            ca_order = min(ca_order):(min(ca_order)+length(ca_order)-1);
            cadata = cadata_ordered;
            cadata( ~any(cadata,2), : ) = [];
            if debug 
                assignin('base','ca_after',cadata);
                assignin('base','ca_order_ordered',ca_order);
            end
            
            [ca_det_thresh,cadata,ca_t_scale,~,~,~,ca_allpeaksT,~,normed_ca,ca_true_srate] = detettore(cadata,ca_t_scale,nargin,debug,2,plots,ca_param,ca_order);
            [ephys_det_thresh,~,~,ephysconsensT,ephysleadch,ephyspower,ephys_allpeaksT,dogged,~,ephys_true_srate] = detettore(ephysdata,ephys_t_scale,nargin,debug,1,plots,ephys_param,ca_order);
            ca_param(1) = ca_true_srate;
            ephys_param(1) = ephys_true_srate;
            if debug
                assignin('base','ephysconsensT',ephysconsensT);
                assignin('base','ca_allpeaksT',ca_allpeaksT);                
            end
        end
        
        if ephys_param(13)
            ephys_t_scale = ephys_t_scale +1;
        end
        
        %%% ca & ephys comparison
        caavg = cadata(1,:);
        if size(cadata,2) > 1
            for i = 2:size(cadata,1)
                caavg = cat(3,caavg,cadata(i,:));
            end
        end
        caavg = mean(caavg,3);
        if debug
            assignin('base','caavg',caavg);
        end
        ephyscons_onlyT = ephysconsensT(:,1);
        ephyscons_onlyT(ephyscons_onlyT==ephys_t_scale(1)) = nan;
        if debug
            assignin('base','ephyscons_onlyT',ephyscons_onlyT)
        end
        ca_allpeaksT(ca_allpeaksT==[0 0]) = nan;
        cacons_onlyT = ca_allpeaksT(:,1,:);
        cacons_onlyT = cacons_onlyT(:);
        if debug 
            assignin('base','cacons_onlyT',cacons_onlyT)
        end
        ephysca = [];
        supreme = 0;
        wb = waitbar(0,'Cross-checking Ca and Ephys','Name','Ca vs Ephys');
        for i = 1:max(size(ephyscons_onlyT,1),size(cacons_onlyT,1))
            if size(ephyscons_onlyT,1) > size(cacons_onlyT,1)
                supreme = 2;
                ephysca = [ephysca ; cacons_onlyT((-1*(ephyscons_onlyT(i,1)-cacons_onlyT)<ephyvsca_tolerance) & ...
                    (-1*(ephyscons_onlyT(i,1)-cacons_onlyT)>0))];
            elseif size(ephyscons_onlyT,1) < size(cacons_onlyT,1)
                supreme = 1;
                ephysca = [ephysca ; ephyscons_onlyT(((cacons_onlyT(i,1)-ephyscons_onlyT)<ephyvsca_tolerance) & ...
                    ((cacons_onlyT(i,1)-ephyscons_onlyT)>0))];
            end
            waitbar(i/max(size(ephyscons_onlyT,1),size(cacons_onlyT,1)));
        end
        if debug
            assignin('base','freshlybakedephysca',ephysca)
        end
        ephysca = unique(ephysca);
        
        norm_ca_gors = [];
        for i = 1:size(normed_ca,1)
            newgor = [];
            newgor.name = ['Normed_Ca_Roi_',num2str(ca_order(i)-1)];
            newgor.xname = 'Time';
            newgor.yname = 'dF/F';
            newgor.xunit = 'ms';
            newgor = gorobj('eqsamp',[ca_t_scale(1) ca_t_scale(2)-ca_t_scale(1)]*1000,'double',normed_ca(i,:),newgor);
            newgor = set(newgor,'vars',1,ca_det_thresh(i,2));
            newgor = set(newgor,'varnames',1,'Threshold');
            norm_ca_gors = [norm_ca_gors ; newgor];
        end

        sim_det_gor = [];
        sim_det_gor.name=['Detected simultan events'];
        sim_det_gor.xname='Time';
        sim_det_gor.yname='';
        sim_det_gor.xunit='ms';
        sim_det_gor.Marker='*';
        sim_det_gor.MarkerSize=12;
        sim_det_gor.Color='g';
        sim_det_gor.LineStyle='none';
        sim_det_gor=gorobj('double',ephysca*1000,'double',zeros(size(ephysca)),sim_det_gor);
        
        doggor = [];
        doggor.name=['Consens channel (Ch',num2str(ephysleadch),') DoG'];
        doggor.Color='r';
        doggor.xname='Time';
        doggor.yname='Voltage';
        doggor.xunit='ms';
        doggor.yunit='\muV';
        doggor.axis=2;
        doggor=gorobj('eqsamp', [ephys_t_scale(1) ephys_t_scale(2)-ephys_t_scale(1)]*1000, 'double', dogged(:,ephysleadch), doggor);

        powgor = [];
        powgor.name=['Consens channel (Ch',num2str(ephysleadch),') InstPow'];
        powgor.Color='r';
        powgor.xname='Time';
        powgor.yname='Power';
        powgor.xunit='ms';
        powgor.yunit='\muV^2';
        powgor.axis=2;
        powgor=gorobj('eqsamp', [ephys_t_scale(1) ephys_t_scale(2)-ephys_t_scale(1)]*1000, 'double', ephyspower(:,ephysleadch), powgor);
        powgor=set(powgor,'vars',1,ephys_det_thresh(ephysleadch,2));
        powgor=set(powgor,'varnames',1,'Threshold');
        
        ref_doggor = [];
        if ephys_param(11)~=0 || ephys_param(14)~=0 
            ref_doggor.name=['Reference channel (Ch',num2str(ephys_param(12)),') DoG'];
            ref_doggor.Color='r';
            ref_doggor.xname='Time';
            ref_doggor.yname='Voltage';
            ref_doggor.xunit='ms';
            ref_doggor.yunit='\muV';
            ref_doggor.axis=2;
            ref_doggor=gorobj('eqsamp', [ephys_t_scale(1) ephys_t_scale(2)-ephys_t_scale(1)]*1000, 'double', dogged(:,ephys_param(12)), ref_doggor);
        end
        
        ref_powgor = [];
        if ephys_param(11)~=0 || ephys_param(14)~=0
            ref_powgor.name=['Reference channel (Ch',num2str(ephys_param(12)),') InstPow'];
            ref_powgor.Color='r';
            ref_powgor.xname='Time';
            ref_powgor.yname='Power';
            ref_powgor.xunit='ms';
            ref_powgor.yunit='\muV^2';
            ref_powgor.axis=2;
            ref_powgor=gorobj('eqsamp', [ephys_t_scale(1) ephys_t_scale(2)-ephys_t_scale(1)]*1000, 'double', ephyspower(:,ephys_param(12)), ref_powgor);
            ref_powgor=set(ref_powgor,'vars',1,ephys_det_thresh(ephys_param(12),2));
            ref_powgor=set(ref_powgor,'varnames',1,'Threshold');
        end
        
        doggor = [doggor ; powgor; ref_doggor; ref_powgor];
        
        ephys_det_gor = [];
        ephys_det_gor.name=['Detections consens channel (Ch',num2str(ephysleadch),')'];
        ephys_det_gor.xname='Time';
        ephys_det_gor.yname='';
        ephys_det_gor.xunit='ms';
        ephys_det_gor.Marker='*';
        ephys_det_gor.MarkerSize=12;
        ephys_det_gor.Color='g';
        ephys_det_gor.LineStyle='none';
        ephys_det_gor=gorobj('double',ephyscons_onlyT*1000,'double',zeros(size(ephyscons_onlyT)),ephys_det_gor);
        
        refchan_det_gor = [];
        if ephys_param(11)~=0 || ephys_param(14)~=0
            refchan_det_gor.name=['Detections reference channel (Ch',num2str(ephys_param(12)),')'];
            refchan_det_gor.xname='Time';
            refchan_det_gor.yname='';
            refchan_det_gor.xunit='ms';
            refchan_det_gor.Marker='*';
            refchan_det_gor.MarkerSize=12;
            refchan_det_gor.Color='g';
            refchan_det_gor.LineStyle='none';
            refchan_det_gor=gorobj('double',ephys_allpeaksT(:,1,ephys_param(12))*1000,'double',zeros(size(ephys_allpeaksT(:,1,ephys_param(12)))),refchan_det_gor);
        end
        
        ephys_det_gor = [ephys_det_gor ; refchan_det_gor];
        
        %%% delay values
        delays = [];
        for i = 1:length(ephysca)
            switch supreme
                case 2
                    tempdelays = ephyscons_onlyT((-1*(ephyscons_onlyT-ephysca(i))<ephyvsca_tolerance) & ...
                        (-1*(ephyscons_onlyT-ephysca(i))>0));
                case 1 
                    tempdelays = cacons_onlyT(((cacons_onlyT-ephysca(i))<ephyvsca_tolerance) & ...
                        ((cacons_onlyT-ephysca(i))>0));
            end
            if ~isempty(tempdelays)
                delays = [delays; tempdelays(1)];
            end
        end
        ephysca_other = delays;
        if ~isempty(delays)
            delays = abs(ephysca-delays);
            avgdelays = mean(delays);
        else
            delays = [];
            avgdelays = [];
        end

        if debug 
            assignin('base','delays',delays);
        end
        
        ephysxscala = ephys_t_scale(1):(ephys_t_scale(2)-ephys_t_scale(1)):(ephys_t_scale(2)-ephys_t_scale(1))*(size(ephysdata,2)-1)+ephys_t_scale(1);
        caxscala = ca_t_scale(1):(ca_t_scale(2)-ca_t_scale(1)):(ca_t_scale(2)-ca_t_scale(1))*(size(cadata,2)-1);
        figure('Name','Ca vs Ephys','NumberTitle','off')
        sp1 = subplot(2,1,1);
        plot(ephysxscala,ephyspower(:,ephysleadch),'r'); hold on;
        title('Ephys instpow');
        for i = 1:size(ephysca,1)
            line([ephysca(i) ephysca(i)],[min(ephyspower(:,ephysleadch)) max(ephyspower(:,ephysleadch))],'Color','g'); hold on;            
        end
        hold off;
        sp2 = subplot(2,1,2);
        plot(caxscala,caavg,'b'); hold on;
        title('Calcium signal');
        per_roi_det = zeros(size(ephysca,1),1,size(cadata,1));
        for i = 1:size(ephysca,1)
            line([ephysca(i) ephysca(i)],[min(caavg) max(caavg)],'Color','g'); hold on;            
            cainds = find(abs(ca_allpeaksT-ephysca(i))<ephyvsca_tolerance);
            [num,type,roi] = ind2sub(size(ca_allpeaksT),cainds);
            loc = [num,type,roi];
            if debug
                display(loc);
            end
            for j = 1:size(loc,1)
                if loc(j,2)==1
                    per_roi_det(i,1,loc(j,3)) = ephysca(i);
                    break
                end
            end
        end
        hold off;
        close(wb);
        linkaxes([sp1 sp2],'x');
        if debug
            assignin('base','ephysca',ephysca);
            assignin('base','per_roi_det',per_roi_det);
        end
        %%% Roionk�nt detection gor
        roi_det_gor = [];
        for i = 1:size(per_roi_det,3)
            if sum(per_roi_det(:,:,i)) ~= 0
                newgor = [];
                temp = unique(per_roi_det(:,:,i));
                temp(temp==0) = [];
                newgor.name=['Simultan detections for roi ',num2str(ca_order(i)-1)];
                newgor.Marker='*';
                newgor.MarkerSize=12;
                newgor.Color='g';
                newgor.LineStyle='none';
                newgor.xname = 'Time';
                newgor.yname = '';
                newgor.xunit = 'ms';
                newgor=gorobj('double', temp*1000, 'double', zeros(size(temp)), newgor);
                roi_det_gor = [roi_det_gor ; newgor];
            end
        end 
        
%         ephys_param_prompts = {'Sample rate (Hz)','W1 (Hz)','W2 (Hz)','Step size (ms)','Min event distance (ms)',...
%             'Event length min (ms)','Event length max (ms)','sd mult','qsd mult','Quietint length (s)', ...
%             'Denoise','Reference chan.','1s shift'};
%         ca_param_prompts = {'Sample rate (Hz)','Step size (ms)','Min event distance (ms)',...
%             'Event length min (ms)','Event length max (ms)','dF/F threshold','sd mult','qsd mult'};
        %%% CSV ir�s
        [csvname,path] = uiputfile('*.csv','Name CSV!');
        cd(path);
        fileID = fopen(string(csvname),'w');
        fprintf(fileID,'%s \n','Ephys parameters');
        for i = 1:length(ephys_param_prompts)
            fprintf(fileID,'%s: %d \n',string(ephys_param_prompts(i)),ephys_param(i));
        end
        fprintf(fileID,'Ephys processing: %s \n',ephys_proclist{ephys_param(15)});
        fprintf(fileID,'\n %s \n','Ca parameters');
        for i = 1:length(ca_param_prompts)
            fprintf(fileID,'%s: %d \n',string(ca_param_prompts(i)),ca_param(i));
        end
        fprintf(fileID,'Ca processing: %s \n',ca_proclist{ca_param(10)});
        
        fprintf(fileID,'\n');
        
        fprintf(fileID,'Ca detection thresholds per roi \n');
        for i = 1:size(ca_det_thresh,1)
            fprintf(fileID,'%d# ;',ca_order(i)-1);
        end
        fprintf(fileID,'\n');
        for i = 1:size(ca_det_thresh,1)
            fprintf(fileID,'%5.4f;',ca_det_thresh(i,2));
        end
        fprintf(fileID,'\n');
        fprintf(fileID,'Ephys detection thresholds per channel \n');
        for i = 1:size(ephys_det_thresh,1)
            fprintf(fileID,'%d# ;',i);
        end
        fprintf(fileID,'\n');
        for i = 1:size(ephys_det_thresh,1)
            fprintf(fileID,'%5.4f;',ephys_det_thresh(i,2));
        end
        fprintf(fileID,'\n');
        
        fprintf(fileID,'\n');
        
        if ephys_param(11)~=0 || ephys_param(14)~=0
            fprintf(fileID,'Reference channel detections: (s) \n');
            for i =1:length(ephys_allpeaksT(:,1,ephys_param(12)))
                if ephys_allpeaksT(i,1,ephys_param(12)) ~= ephys_t_scale(1)
                    fprintf(fileID,'%5.4f ;',ephys_allpeaksT(i,1,ephys_param(12)));
                end
            end
            fprintf(fileID,'\n');

            fprintf(fileID,'\n');
        end
        
        switch supreme
            case 1
                fprintf(fileID,'%s %d \n','Ephys simultan events (s) num=',length(ephysca));
            case 2
                fprintf(fileID,'%s %d \n','Ca simultan events (s) num=',length(ephysca));
        end
%         fprintf(fileID,'%s %d \n','Simultan events (s) num=',length(ephysca));
        for i = 1:length(ephysca)  
            if i == length(ephysca)
                fprintf(fileID,'%5.4f \n',ephysca(i));
            else
                fprintf(fileID,'%5.4f ; ',ephysca(i));            
            end
        end
        switch supreme
            case 2
                fprintf(fileID,'%s %d \n','Ephys simultan events (s) num=',length(ephysca));
            case 1
                fprintf(fileID,'%s %d \n','Ca simultan events (s) num=',length(ephysca));
        end
        for i = 1:length(ephysca_other)  
            if i == length(ephysca_other)
                fprintf(fileID,'%5.4f \n',ephysca_other(i));
            else
                fprintf(fileID,'%5.4f ; ',ephysca_other(i));            
            end
        end
        
        fprintf(fileID,'\n');
        
        fprintf(fileID,'Delays between ephys and Ca (s) \n');
        for i = 1:length(delays)
            fprintf(fileID,'%5.4f ; ',delays(i));
        end
        fprintf(fileID,'\n Avg delay (s) = %5.4f \n',avgdelays);
        
        fprintf(fileID,'\n');
        
        fprintf(fileID,'%s \n','All Ca events grouped by ROI + simultan events(s)');
        for i = 1:size(per_roi_det,3)
            fprintf(fileID,'%d# ; ',ca_order(i)-1);
            for j = 1:size(ca_allpeaksT(:,:,i),1)
                if ~isnan(ca_allpeaksT(j,1,i))
                    fprintf(fileID,'%5.4f ; ',ca_allpeaksT(j,1,i));
                end
            end
            fprintf(fileID,'\n');
            fprintf(fileID,'%d# ; ',ca_order(i)-1);
            temp = per_roi_det(:,:,i);
            temp = unique(temp);
            temp(temp==0) = [];
            temp2 = ca_allpeaksT(:,1,i);
            temp2 = unique(temp2);
            temp2(temp2==0) = [];
            temp2(isnan(temp2)) = [];
            temp3 = [];
            for j = 1:length(temp2)
                for k = 1:length(temp)
                    if ((temp2(j)-temp(k)) >= 0) && ((temp2(j)-temp(k)) < ephyvsca_tolerance)
                        temp3 = [temp3 ; temp2(j)];
                    end
                end
            end
            if debug
                assignin('base','temp',temp);
                assignin('base','temp2',temp2);
                assignin('base','temp3',temp3);
            end
%             temp3 = temp2(ismembertol(temp2,temp,ephyvsca_tolerance,'DataScale',1));
%             temp3 = temp3(temp3-temp >=0);
            if isempty(temp3)
                fprintf(fileID,'\n');
                continue
            end
            for j = 1:size(temp3,1)
                fprintf(fileID,'%5.4f ; ',temp3(j));
            end
            if ~isempty(temp3)
                fprintf(fileID,'\n');
            end
        end
        fprintf(fileID,'%s \n','Num of Detected/Simultan Ca events grouped by roi');
        for i = 1:size(ca_allpeaksT,3)
            fprintf(fileID,'%d# ;',ca_order(i)-1);
        end
        fprintf(fileID,'\n');
        allperdet = zeros(size(ca_allpeaksT,3),2);
        for i = 1:size(ca_allpeaksT,3)
            all = 0;
            for j = 1:size(ca_allpeaksT(:,:,i),1)
                if ~isnan(ca_allpeaksT(j,1,i))
                    all = all + 1;
                end
            end
            temp = per_roi_det(:,:,i);
            temp = unique(temp);
            temp(temp==0) = [];
            temp2 = ca_allpeaksT(:,1,i);
            temp2 = unique(temp2);
            temp2(temp2==0) = [];
            temp2(isnan(temp2)) = [];
            temp3 = temp2(ismembertol(temp2,temp,ephyvsca_tolerance,'DataScale',1));
            det = length(temp3);
            allperdet(i,:) = [all,det];
        end
        for i = 1:size(ca_allpeaksT,3)
            fprintf(fileID,'%d;',allperdet(i,1));
        end
        fprintf(fileID,'\n sum Ca: ; %d \n',sum(allperdet(:,1)));
        for i = 1:size(ca_allpeaksT,3)
            fprintf(fileID,'%d;',allperdet(i,2));
        end
        fprintf(fileID,'\n sum simultan: ; %d \n',sum(allperdet(:,2))); 
        
        fprintf(fileID,'\n');
        
        fprintf(fileID,'%s %d','Ephys events not associated with Ca (s) num =');
        temp = [];
        num = 0;
        for i = 1:size(ephyscons_onlyT,1)
            if (~ismembertol(ephyscons_onlyT(i),ephysca,ephyvsca_tolerance,'DataScale',1)) && (~isnan(ephyscons_onlyT(i)))
                temp = [temp; ephyscons_onlyT(i)];
                num = num + 1;
            end
        end
        fprintf(fileID,'%d \n',num);
        for i = 1:length(temp)
            fprintf(fileID,'%5.4f ; ',temp(i));
        end
        
        fclose(fileID);
        %%% end of CSV write
    end 
    finitodlg = warndlg('Event detection is finished!','Finished');
    pause(0.5);
    if ishandle(finitodlg)
        close(finitodlg);
    end
end

close(GUI);

function [det_thresh,indataFull,t_scale,consensT,leadchan,power,allpeaksT,dogged,normed_ca,true_srate] = detettore(indataFull,t_scale,gore,debug,caorephys,plots,param,ca_order)

srate = 1/(t_scale(2)-t_scale(1));
if gore ~= 1
    srate = param(1);
end
switch caorephys
    case 1
        w1 = param(2);
        w2 = param(3);
        denoise = param(11);
        refch = param(12);
        winstepsize = round(param(4)*(srate/1000));
        eventdist = param(5)*(srate/1000);
        sdmult = param(8);
        qsdmult = param(9);
        sec = param(10);
        widthlower = param(6);
        widthupper = param(7);
        selected = param(15);
        offsetcorr = param(13);
        refchan_crosscheck = param(14);
        if denoise==0 && refchan_crosscheck==0
            refch = 0;
        end
    case 2
        offsetcorr = 0;
        refch = 0;
        denoise = 0;
        refchan_crosscheck = 0;
        winstepsize = round(param(2)*(srate/1000));
        eventdist = param(3)*(srate/1000);
        widthlower = param(4);
        widthupper = param(5);
        dFF_thresh = param(6);
        sdmult = param(7);
        qsdmult = param(8);
        selected = param(10);
        gauss_avg_num = param(9);
end

true_srate = srate;

if offsetcorr
    t_scale = t_scale+1;
end

if debug 
    assignin('base','indata',indataFull);
end
if gore == 0
    len = size(indataFull,1)-1;
else
    len = size(indataFull,1);
end
ivec = 1:len;
noref = 1:len;
if refch ~= 0
    ivec([1 refch]) = ivec([refch 1]);
    noref(noref==refch) = [];
end
if debug
    assignin('base','noref',noref);
end
dogged = zeros(size(indataFull,2),len);
if debug
    assignin('base','dog',dogged);
end
power = zeros(size(indataFull,2),len);

%%% Ca kezel�s
if gore == 1 && caorephys == 2 && selected == 2 
    power = transpose(indataFull);
elseif gore == 1 && caorephys == 2 && selected == 1
    for i = 1:len
        cagor = [];
        cagor = gorobj('eqsamp', [t_scale(1) t_scale(2)-t_scale(1)]*1000, 'double', indataFull(i,:), cagor);
        filter.type = 'gaavr';
        filter.W1 = 1/gauss_avg_num/2/((t_scale(2)-t_scale(1))*1000);
        filter.ends = 1;
        smoothedCa = FilterUse(cagor,filter);
        filter2.type = 'resample';
        filter2.W1 = 1/0.1/2/((t_scale(2)-t_scale(1))*1000);
        upsampCa = FilterUse(smoothedCa,filter2);
        tempca(:,i) = get(upsampCa,'extracty');  
    end
    t_scale = (get(upsampCa,'x'))/1000;
    srate = 1/t_scale(2);
    true_srate = srate;
    t_scale(2) = t_scale(1)+t_scale(2);
    winstepsize = round(param(2)*(srate/1000));
    eventdist = param(3)*(srate/1000);
    power = tempca;
    indataFull = transpose(tempca);
end
if debug && caorephys == 2
    assignin('base','processedCAinput',power);
    assignin('base','altered_ca_t_scale',t_scale);
end

%%% Filters
if selected == 1 && caorephys == 1
    for i = ivec
        indata = indataFull(i,:);
        if i ~= refch && denoise == 1
            indata = indata - indataFull(refch,:);
        end
        %%% Substract mean from lfp 
    %     indataMS = indata - mean(indata,2);

        %%% Apply DoG (from BuzsakiLab)
        GFw1       = makegausslpfir( w1, srate, 6 );
        GFw2       = makegausslpfir( w2, srate, 6 );
        lfpLow     = firfilt( indata, GFw2 );      % lowpass filter
        eegLo      = firfilt( lfpLow, GFw1 );   % highpass filter
        lfpLow     = lfpLow - eegLo;            % difference of Gaussians

        dogged(:,i) = lfpLow;
        
    end
    if debug
        assignin('base','postdogged',dogged);
    end
elseif selected == 3 && caorephys == 1
    dogged = indataFull(1:5,:);
    dogged = transpose(dogged);
    if debug
        assignin('base','predogged',dogged);
    end
end
if (selected == 1 || selected == 3) && caorephys == 1
    for i = ivec

        %%%% Apply DoG (from BuzsakiLab) with meansubstract
        %GFw1MS       = makegausslpfir( w1, srate, 6 );
        %GFw2MS       = makegausslpfir( w2, srate, 6 );
        %lfpLowMS     = firfilt( indataMS, GFw2MS );      % lowpass filter
        %eegLoMS      = firfilt( lfpLowMS, GFw1MS );   % highpass filter
        %lfpLowMS     = lfpLowMS - eegLoMS;            % difference of Gaussians

        %%% Instantaneous power (from BuzsakiLab)
        ripWindow  = pi / mean( [w1 w2] );
        powerWin   = makegausslpfir( 1 / ripWindow, srate, 4 );

        rip        = dogged(:,i);
        rip        = abs(rip);
        ripPower0  = firfilt( rip, powerWin );
        ripPower0  = max(ripPower0,[],2);

        power(:,i) = ripPower0;

    end
end

if debug
    assignin('base','POWER',power);
end
%%% Alapzaj meghat�roz�sa
piccolo = zeros(size(indataFull,2),len);
for i = ivec
    currpow = power(:,i);
    %%% K�z�s intervallumot keres v�ltozat
    quietthresh(i) = (mean(currpow) + qsdmult*std(currpow));
    piccolo(1:length(find(currpow < (mean(currpow) + qsdmult*std(currpow)))),i) = find(currpow < (mean(currpow) + qsdmult*std(currpow)));
end
if debug
    assignin('base','quietthresh',quietthresh);
    assignin('base','piccolo',piccolo);
end
switch length(ivec)
    case 0
        warndlg('Not enough channels');
        return;
    case 1
        sect = piccolo;
    case 2
        sect = intersect(piccolo(:,ivec(1)),piccolo(:,ivec(2)));
    otherwise
        sect = intersect(piccolo(:,ivec(1)),piccolo(:,ivec(2)));
        for i = ivec(3):ivec(end)
            sect = intersect(piccolo(:,i),sect);
        end
end

if debug
    assignin('base','runsect',sect);
end
qsect = diff(sect);
louds = qsect(qsect>1);
if debug
    assignin('base','runlouds',louds);
end
[~, inds] = ismember(qsect,louds);
goodinds = find(inds~=0);
goodinds = goodinds + 1;
if(goodinds(1) ~= 1)
    goodinds = cat(1,1,goodinds);
end
if debug
    assignin('base','runginds',goodinds);
end
[quietivlen, ind] = max(diff(goodinds));
quietiv = [sect(goodinds(ind)), sect(goodinds(ind))+quietivlen];
quietivs = zeros(size(indataFull,2),2,len);
quietivs(1,:,1) = quietiv;
if debug
    assignin('base','intervals',quietiv);
end
quietivT = (quietiv/srate)+t_scale(1);
if debug
    assignin('base','intervalsT',quietivT);
end

extendedivs = 0;
%%% Ha tul rovid az interval, vagy eleve nincs k�z�s, akkor csatornankent hozzarakok 
if caorephys == 2
    sec = inf;
end
if ((quietiv(2)-quietiv(1)) < sec*srate)
    extendedivs = 1;
    maxnum = 0;
    for i = ivec
        extquiets = piccolo(:,i);
        diffquiets = diff(extquiets);
        extlouds = diffquiets(diffquiets>1);
        [~, inds] = ismember(diffquiets,extlouds);
        extgoodinds = find(inds~=0);
        if(extgoodinds(1) ~= 1)
            extgoodinds = cat(1,1,extgoodinds);
        end
        goodies = diff(extgoodinds);
        if debug
            assignin('base',['goodies',num2str(i)],goodies);
        end
        tempivs = zeros(length(goodies),2);
        tempivs(1,:) = quietiv;
        indx = 1;
        while (sum(tempivs(:,2)-tempivs(:,1))) < (sec*srate+(quietiv(2)-quietiv(1)))
            indx = indx + 1;
            [goodielen, ind] = max(goodies);
            if goodielen == 0 && caorephys == 1
                warn = warndlg('Couldnt reach specified quietlenght');
                pause(0.25);
                close(warn);
                break
            elseif goodielen == 0 && caorephys == 2
                break
            end
            tempivs(indx,:) = [extquiets(extgoodinds(ind)) , extquiets(extgoodinds(ind))+goodielen];
            goodies(ind) = 0;
        end
        if debug
            assignin('base',['fulltempivs',num2str(i)],tempivs);
        end
        tempivs = tempivs(any(tempivs,2),:);
        tempivs2 = tempivs;
        if debug
            assignin('base',['tempivs',num2str(i)],tempivs);
            assignin('base',['extgoodies',num2str(i)],goodies);  
        end
        for j = 2:size(tempivs,1)
            overlap = intersect(tempivs(j,1):tempivs(j,2),tempivs(1,1):tempivs(1,2));
            if length(overlap) > 1
                tempivs2(j,:) = [];
                tempivs2 = cat(1,tempivs2,[tempivs(j,1) overlap(1)]);
                tempivs2 = cat(1,tempivs2,[overlap(end) tempivs(j,2)]);
            end
        end
        if size(tempivs2,1) > maxnum
            maxnum = size(tempivs2,1);
        end
        quietivs(1:size(tempivs2,1),:,i) = tempivs2;
        if debug
            assignin('base','quietivs',quietivs);
            assignin('base',['tempivs2',num2str(i)],tempivs2);
        end
    end
    for i = 1:size(quietivs,3)
        quietivs(maxnum+1:end,:,:) = [];
    end
    if debug
        assignin('base','quietivs',quietivs);
    end
    quietivsT = quietivs;
    quietivsT(:,:,:) = (quietivsT(:,:,:)/srate)+t_scale(1);
    if debug
        assignin('base','quietivsT',quietivsT);
    end
end

%%% Ca adatok norm�l�sa, baselineol�sa
% norm_ca_gors = [];
normed_ca = [];
if caorephys == 2
    for i = 1:size(indataFull,1)
        quiet = indataFull(i,quietiv(1)+1:quietiv(2)+1);
        for q = 2:size(quietivs,1)
            quiet = cat(2,quiet,indataFull(i,quietivs(q,1,i)+1:quietivs(q,2,i)+1));
        end
        avg = mean(quiet);
        indataFull(i,:) = indataFull(i,:)/avg;
        quiet = indataFull(i,quietiv(1)+1:quietiv(2)+1);
        for q = 2:size(quietivs,1)
            quiet = cat(2,quiet,indataFull(i,quietivs(q,1,i)+1:quietivs(q,2,i)+1));
        end
        avg = mean(quiet);
        indataFull(i,:) = indataFull(i,:)-avg;
%         newgor = [];
%         newgor.name = ['Normed_Ca_Roi_',num2str(ca_order(i)-1)];
%         newgor.xname = 'Time';
%         newgor.yname = 'dF/F';
%         newgor.xunit = 'ms';
%         newgor = gorobj('eqsamp',[t_scale(1) t_scale(2)-t_scale(1)]*1000,'double',indataFull(i,:),newgor);
%         newgor = set(newgor,'vars',1,det_thresh(i));
%         norm_ca_gors = [norm_ca_gors ; newgor];
    end
    normed_ca = indataFull;
    power = transpose(indataFull);
end

allpeaksDP = zeros(size(indataFull,2),2,length(noref));
if debug
    assignin('base','INITallpeaksDP',allpeaksDP);
end
%%%%%%%%%%%%%%
%%% SWR detect
%%%%%%%%%%%%%%
det_thresh = zeros(length(ivec),2);
for i = ivec
    currpow = power(:,i);
    if debug
        assignin('base',['currpow',num2str(i)],currpow);
    end
    %%% +1 hogy ne 0-tol indexeljen
    quiet = currpow(quietiv(1)+1:quietiv(2)+1);
    if extendedivs == 1
        for q = 2:size(quietivs,1)
            quiet = cat(1,quiet,(currpow(quietivs(q,1,i)+1:quietivs(q,2,i)+1)));
        end
    end
    if debug
        assignin('base',['quiet',num2str(i)],quiet);
    end
    peaks = zeros(round(length(currpow)/winstepsize),2);
    peaknum = 2;
    ripsd = mean(quiet) + sdmult*std(quiet);
    if i == refch
        ripsd = mean(currpow) + sdmult*std(currpow);
    end
    det_thresh(i,:) = [i,ripsd];
    if (caorephys == 2) && (dFF_thresh ~= 0)
        ripsd = dFF_thresh;
    end
    if debug
        display(caorephys)
        display(ripsd)
    end
    if plots
        if caorephys == 0
            figure('Name',['Channel',num2str(i)],'NumberTitle','off');
        elseif caorephys == 1
            figure('Name',['Ephys_Channel',num2str(i)],'NumberTitle','off');
        elseif caorephys == 2
            figure('Name',['Ca_Channel',num2str(i)],'NumberTitle','off');
        end
    end
    xscala = t_scale(1):(t_scale(2)-t_scale(1)):t_scale(1)+(t_scale(2)-t_scale(1))*(size(indataFull,2)-1);
    if plots
        if (caorephys == 0) || (caorephys == 1)
            ax1=subplot(2,1,1);
            plot(xscala,dogged(:,i));
            grid on;
            title('DoG');
            ax2=subplot(2,1,2);
            plot(xscala,currpow); hold on;
            title('Instantaneous power');
            grid on;
            linkaxes([ax1 ax2],'x');
        elseif caorephys == 2
            plot(xscala,currpow); hold on;
            title('Calcium signal');
            grid on;
        end
    end
    
    for j = 1:winstepsize:(length(currpow)-winstepsize*2)
        [peak, index] = max(currpow(j:j+(winstepsize*2)));
        index = j+index-1;
        if (peak > ripsd) %&& ((index-peaks(peaknum-1,1)) > 500)
            peaks(peaknum,:) = [index, peak];
        end
        peaks(peaknum,1) = index;
        peaknum = peaknum + 1;
    end
    if debug
        assignin('base','peaksvol1',peaks);
    end
    peaks = unique(peaks,'stable','rows');
    peaks = peaks(find(peaks(:,2)),:);
    ppeaks = peaks;
    if debug
        assignin('base','upeaksvol1',ppeaks);
    end
    for k = 2:size(peaks,1)-1
        if (((peaks(k,1) - peaks(k-1,1)) < eventdist) && (peaks(k,2) < peaks(k-1,2))) || ...
                (((peaks(k+1,1) - peaks(k,1)) < eventdist) && (peaks(k,2) < peaks(k+1,2)))
            ppeaks(k,2) = 0;
        end        
    end
    if size(ppeaks,1)>1
        if ((peaks(2,1)-peaks(1,1)) < eventdist) && (peaks(1,2) < peaks(2,2))
            ppeaks(1,2) = 0;
        end
        if ((peaks(end,1)-peaks(end-1,1)) < eventdist) && (peaks(end,2) < peaks(end-1,2))
            ppeaks(end,2) = 0;
        end
    end
    if debug
        assignin('base','peaksvol2',ppeaks);
    end
    ppeaks = ppeaks(find(ppeaks(:,2)),:);
    if debug
        assignin('base','rips',currpow);
    end
    
    %%% Hossz alapj�n kisz�r�s
    widths = zeros(size(ppeaks,1),1);
    for ii = 1:size(ppeaks,1)
        iii = ppeaks(ii,1);
        while currpow(iii) > ripsd
            if (iii-1)<1
                break
            end
            iii = iii - 1;
        end
        lowedge = iii;
        if debug
            assignin('base','lowedge',lowedge);
        end
        iii = ppeaks(ii,1);
        while (currpow(iii) > ripsd) && (iii < size(currpow,1))
            iii = iii + 1;
        end
        highedge = iii;
        if debug
            assignin('base','highedge',highedge);
        end
        widths(ii) = (highedge - lowedge)/(srate/1000);
        if (widths(ii) < widthlower) || (widths(ii) > widthupper)
            ppeaks(ii,2) = 0;
        end
        if debug
            assignin('base','widths',widths);
        end
    end
        
    widths = widths((widths>=widthlower) & (widths<=widthupper));
    ppeaks = ppeaks(find(ppeaks(:,2)),:);
   
    %%% refcsatorna peakjei
    if i == refch
        refppeaks = ppeaks;
    end
    
    %%% refchan-hoz hasonl�t�s
    if i ~= refch && refchan_crosscheck == 1
        for jj = 1:size(ppeaks,1)
            for kk = 1:size(refppeaks,1)
                if (abs(refppeaks(kk,1)-ppeaks(jj,1))<eventdist) && (refppeaks(kk,2) ~=0)
                    ppeaks(jj,2) = 0;
                    continue
                end
            end    
        end    
    end
    ppeaks = ppeaks(find(ppeaks(:,2)),:);
    
    %%% all peaks in one (((except refch)))
%     if i ~= refch 
        allpeaksDP(1:size(ppeaks,1),:,i) = ppeaks;
%     end
    %%% �t�r�s id�sk�l�ra 
    for ii = 1:size(ppeaks,1)
        ppeaks(ii,1) = ((ppeaks(ii,1)-1)/srate)+t_scale(1);
    end
    if debug
        assignin('base',['peaks', num2str(i)],ppeaks);
    end
    if plots
        plot(ppeaks(:,1),ppeaks(:,2),'o'); hold on;
        line([t_scale(1), (t_scale(2)-t_scale(1))*length(currpow)],[ripsd ripsd],'Color','r'); hold off;
    end
  
end

maxsize = 0;
for ii = 1:size(allpeaksDP,3)
    if max(find(allpeaksDP(:,1,ii))) > maxsize
        maxsize = max(find(allpeaksDP(:,1,ii)));
    end
end
allpeaksDP(maxsize+1:end,:,:) = [];
if debug
    assignin('base','allpeaksDP',allpeaksDP);
end
%%% valid channel crosscheck
if (size(allpeaksDP,1) > 1) && (caorephys ~= 2)
    consens = zeros(size(allpeaksDP,1),2);
    maxpow = 0;
    leadchan = 0;
    for i = noref
        if (mean(allpeaksDP(:,2,i)) > maxpow)
            maxpow = mean(allpeaksDP(:,2,i));
            leadchan = i;
        end
    end
    consens = cat(2,allpeaksDP(:,1,leadchan),ones(size(allpeaksDP,1),1));
    consens = cat(2,consens,zeros(size(consens,1),len));
    if debug
        display(leadchan);
    end
    for i = 1:size(allpeaksDP,3)
        if i ~= leadchan
            [lia,locb] = ismembertol(allpeaksDP(:,1,i),allpeaksDP(:,1,leadchan),1000,'DataScale',1);
            ulocb = unique(locb);
            ulocb = ulocb(find(ulocb));
            for j = 1:size(ulocb)
                consens(ulocb(j),2) = consens(ulocb(j),2) + 1;
                consens(ulocb(j),2+i) = 1;
            end
        end
    end
    if debug
        assignin('base','consens',consens);
    end
    consensT = consens;
    consensT(:,1) = (consensT(:,1)/srate)+t_scale(1);
    
    if debug
        assignin('base','consensT',consensT);
    end
    
    allpeaksT = allpeaksDP;
    allpeaksT(:,1,:) = (allpeaksT(:,1,:)/srate)+t_scale(1);
    if debug
        assignin('base','allpeaksT',allpeaksT);
    end
    if plots
        switch caorephys
            case 0
                figtitle = 'Consenus peaks';
            case 1
                figtitle = 'Ephys consensus peaks';
            case 2
                figtitle = 'Ca consensus peaks';
        end
        figure('Name',figtitle,'NumberTitle','off');
        plot(xscala,power(:,leadchan)); hold on;
        plot(allpeaksT(:,1,leadchan),allpeaksT(:,2,leadchan),'or');
        for i = 1:size(consensT,1)
            for j = 1:len
                if consensT(i,j+2) == 1
                    currsel = allpeaksT(:,1,j);
                    currsel = currsel(find(currsel));
                    thex = find(abs(currsel-consensT(i,1))<0.05);
                    if size(thex,1) == 0
                        continue
                    elseif size(thex,1) > 1
                        thex = thex(1);
                    end
                end
            end
        end
    end
else 
    %%% Hogy ne akadjon ki amikor ezek nem kellenek
    consensT = 0;
    leadchan = 0;
    allpeaksT = allpeaksDP;
    allpeaksT(:,1,:) = (allpeaksT(:,1,:)/srate)+t_scale(1);
    if debug
        assignin('base','allpeaksT',allpeaksT)
    end
end

return
%%%%%%%%%%%%%%%%%%
%%% SWR detect end ----------------------------------------------------
%%%%%%%%%%%%%%%%%%

%%% Taken from Buzsakilab
function gwin = makegausslpfir( Fc, Fs, s )

nargs = nargin;
if nargs < 1 || isempty( Fc ), Fc = 100; end
if nargs < 2 || isempty( Fs ), Fs = 1000; end
if nargs < 3 || isempty( s ), s = 4; end
s = max( s, 3 );

sd = Fs / ( 2 * pi * Fc ); 
x = -ceil( s * sd ) : ceil( s * sd ); 
gwin = 1/( 2 * pi * sd ) * exp( -( x.^2/2/sd.^2 ) ); 
gwin = gwin / sum( gwin );

return

%%% Taken from BuzsakiLab
function Y = firfilt(x,W)

if all(size(W)>=2), error('window must be a vector'), end
if numel(x)==max(size(x)), x=x(:); end

C = length(W);
if C > size( x, 1 )
    Y = NaN * ones( size( x ) );
    return
end
D = ceil(C/2) - 1;
Y = filter(W,1,[flipud(x(1:C,:)); x; flipud(x(end-C+1:end,:))]);
clear x
Y = Y(1+C+D:end-C+D,:);

return

