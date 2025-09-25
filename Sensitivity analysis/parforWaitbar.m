%% parfor wait bar functions 
% From Yao et al., 2021
function parforWaitbar(waitbarHandle,iterations)
    persistent count h Ni
    
    if nargin == 2
        % Initialize
        
        count = 0;
        h = waitbarHandle;
        Ni = iterations;
    else
        % Update the waitbar
        
        % Check whether the handle is a reference to a deleted object
        if isvalid(h)
            count = count + 1;
            waitbar(count / Ni,h);
        end
    end
end