% function avgPeriod = period_peakAlgo(h,time)
function avgPeriod = period(md)
    
    h=md.results.h(floor(length(md.results.h)/2):end);
    time = md.results.time(floor(length(md.results.time)/2):end);
    dhdt=(h(2:end)-h(1:end-1))./(time(2:end)-time(1:end-1));    % First Forward Difference Calculate dhdt
    % dhdt(dhdt>min(dhdt)-min(dhdt)*3/4)=0;                       % Clear Steady Streaming Values
    dhdt(dhdt>min(dhdt)-min(dhdt)*3/4)=nan;                       % Clear Steady Streaming Values
    
    
    [~,peak]=findpeaks(-dhdt);      % Find Peaks in -dhdt
    
    % for i=2:length(peak)
    %     if (time(peak(i))-time(peak(i-1)))/yearCon<100;
    %     end
    % end
    
    % dist=(time(peak(2:end))-time(peak(1:end-1)))./yearCon;     %Clear Erroneous peak
    % while any(dist<100)
    %     peak([dist<100; false]) = [];
    %     dist=(time(peak(2:end))-time(peak(1:end-1)))./yearCon;
    % end
    
    if ~isempty(peak); peak(1)=[]; end                     % Clear transient peak
    
    
    if length(peak)<=5     % Clear erroneous peaks. Should be impossible to have fewer than 10 peaks in a truly periodic case
        avgPeriod = nan;
    else
        avgPeriod=mean(time(peak(2:end))-time(peak(1:end-1)));      % Calculate Avg Period
    end
    
    % If the model is in a steady streaming mode, avgPeriod should return NaN
    % (hopefully this works)
end