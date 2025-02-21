function md = sweep(md)
    % Preallocate Results
    md.settings.print = false;
    md.sweep.period = nan(md.sweep.res+1,md.sweep.res+1);
    % Loop through Parameters
    tic
    k=0;
    for i = 1:md.sweep.res+1
        for j = 1:md.sweep.res+1
            if ~isempty(md.sweep.Ts) && ~isempty(md.sweep.G)            % Ts-G sweep
                md.parameters.Ts = md.sweep.Ts(i);
                md.parameters.G = md.sweep.G(j);
            elseif ~isempty(md.sweep.Ts) && ~isempty(md.sweep.xi)       % Ts-Xi sweep
                md.parameters.Ts = md.sweep.Ts(i);
                md.parameters.xi = md.sweep.xi(j);
            elseif ~isempty(md.sweep.G) && ~isempty(md.sweep.xi)        % G-Xi sweep
                md.parameters.G = md.sweep.G(i);
                md.parameters.xi = md.sweep.xi(j);
            elseif ~isempty(md.sweep.T_0) && ~isempty(md.sweep.Ts)      % Ts-T0 sweep
                md.parameters.Ts  = md.sweep.Ts(i);
                md.parameters.T_0 = md.sweep.T_0(j);
            end

            % Solve!
            md = solve_R13(md);

            % Store Results
            if md.sweep.save_results
                md.sweep.results(i,j) = struct('h',[],'time',[],'taud',[],'tauy',[],'taub',[],'ub_surge',[],'ub_subtemp',[],'ub',[],'m',[],'w',[]);
                md.sweep.results(i,j) = md.results;
                
            end
            md.sweep.period(i,j) = period(md);

            % Progress Tracking
            k=k+1;
            elapsed=toc;
            runtime=elapsed/(k/(md.sweep.res+1)^2);
            ETA=seconds(runtime-elapsed);
            ETA.Format = 'hh:mm:ss';
%             if md.settings.print; disp([num2str(k/(md.sweep.res+1)^2*100) '%, ETA: ' char(ETA)]); end
            disp([num2str(k/(md.sweep.res+1)^2*100) '%, ETA: ' char(ETA)]);
        end
    end
end