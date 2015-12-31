%This script takes single byte arrays of length 4 and converts them to
%their hex/dec counterpart. I.e. an input might be [1,2,3,4] which will result
%in an output of 0x1B. It also prints the ASCII if it's valid.

function [DecVal, HexVal, ASCII] = LevelsToHex(InputArray)

    %Take care of our litle endian problem.
    InputArray = fliplr(InputArray);

    for x=1:4
        if InputArray(x) == 4
            OutputArray(2*x -1) = 0;
            OutputArray(2*x) = 0;
        elseif InputArray(x) == 3
            OutputArray(2*x -1) = 0;
            OutputArray(2*x) = 1;
        elseif InputArray(x) == 2
            OutputArray(2*x -1) = 1;
            OutputArray(2*x) = 0;
        else %the value is 1
            OutputArray(2*x -1) = 1;
            OutputArray(2*x) = 1;
        end
    end
    DecVal = sum(OutputArray.*2.^(numel(OutputArray)-1:-1:0));
    ASCII = char(DecVal);
    HexVal = dec2hex(DecVal);

end
