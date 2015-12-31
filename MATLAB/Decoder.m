%decodes a stream of levels in groups of four.
% close all;
% clear all;
%first two bytes are 0000 because they aren't actually data bytes.
%this is just to keep the actual block numbers aligned correctly.

function T = Decoder(InData)
    %test data sequence
    %InData = [4,4,4,4; 4,4,4,4; 2,2,4,4; 2,3,3,2; 2,4,1,2; 1,1,4,3; 2,3,4,3;...
        %2,3,2,3; 2,4,3,3; 3,4,4,4; 4,4,1,4; 3,4,4,4; 4,4,1,4];
    A = [0,0,0,0];
    T = array2table(A,...
        'VariableNames',{'Block' 'Hex' 'Dec' 'ASCII'});

    %tables suck but here I am using them anyways...
    for x=1:size(InData,1)
        [dec,hex,ascii]=LevelsToHex(InData(x,:));
        T1 = array2table([x,hex,dec,{ascii}],...
            'VariableNames',{'Block' 'Hex' 'Dec' 'ASCII'});
        T = vertcat(T, T1);
    end

    %hax
    T(1,:) = [];
end