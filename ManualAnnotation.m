% EXPERT MANUAL ANNOTATIONS
function ManualAnnotation

    clc
    clear all
    close all

    % file name
    matName = './AbpSignal/403m.mat';
    infoName = './AbpSignal/403m.info';
    saveName = './AbpSignal/MA403m_xr.mat';

    % read data from file
    fprintf('Reading Data From File...\n');
    [val, Fs] = ReadDataATM(matName,infoName);
    data = val;
    if exist(saveName,'file')
        load(saveName);
    else
        MPos = [];
    end
    
    % info
    if ~exist('info','var')
        ExpName = input('Enter your name (Press Enter): ', 's');
        info = {'File name:',matName(13:end);'Expert name:',ExpName}; 
    end

    fig = figure;
    set(fig,'windowkeypressfcn',@keypressfcn);

    % start manual annotations
    iStart = 1;
    iEnd = 500;
    iPos = find(MPos>=iStart&MPos<=iEnd);
    plot(iStart:iEnd,data(iStart:iEnd),...
         MPos(iPos),data(MPos(iPos)),'r+');
    title(matName(13:end))
    xlabel('Time, s');
    ylabel('Signal & Annotations');

    function keypressfcn(h,evt)
        if strcmp(evt.Key,'rightarrow')...
                ||strcmp(evt.Key,'space') % right move
            iStart = min(iStart+500,length(data)-499);
            iEnd = min(iEnd+500,length(data));
        elseif strcmp(evt.Key,'leftarrow')  % left move
            iStart = max(iStart-500,1);
            iEnd = max(iEnd-500,500);
        elseif strcmp(evt.Key,'i')  % insert
            fprintf('Inserting Annotations ...\n');
            [x,y] = ginput(1);
            MPos = [MPos round(x)];
        elseif strcmp(evt.Key,'d')  % delete
            fprintf('Deleting Annotations ...\n');
            [x,y] = ginput(1);
            MPos(MPos>=x-5&MPos<=x+5) = [];
        elseif strcmp(evt.Key,'s')  % save
            fprintf('Manual Saving Annotations ...\n');
            MPos = sort(MPos);
            save(saveName,'MPos','info');
        end
        iPos = find(MPos>=iStart&MPos<=iEnd);
        plot(iStart:iEnd,data(iStart:iEnd),...
             MPos(iPos),data(MPos(iPos)),'r+');
        title(matName(13:end))
        xlabel('Time, s');
        ylabel('Signal & Annotations');
        if ~mod(iEnd,10000)
            fprintf('Auto Saving Annotations ...\n');
            MPos = sort(MPos);
            save(saveName,'MPos','info');
        end
    end

end