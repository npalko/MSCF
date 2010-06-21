function s = dec2base27(d)

%       dec2base(1) returns 'A'
%       dec2base(26) returns 'Z'
%       dec2base(27) returns 'AA'


    d = d(:);
    if d ~= floor(d) || any(d(:) < 0) || any(d(:) > 1/eps)
        error('MATLAB:xlswrite:Dec2BaseInput',...
            'D must be an integer, 0 <= D <= 2^52.');
    end
    [num_digits begin] = calculate_range(d);
    s = index_to_string(d, begin, num_digits);
end

function [digits first_in_range] = calculate_range(num_to_convert)

    digits = 1;
    first_in_range = 0;
    current_sum = 26;
    while num_to_convert > current_sum
        digits = digits + 1;
        first_in_range = current_sum;
        current_sum = first_in_range + 26.^digits;
    end
end

function string = index_to_string(index, first_in_range, digits)

    letters = 'A':'Z';
    working_index = index - first_in_range;
    outputs = cell(1,digits);
    [outputs{1:digits}] = ind2sub(repmat(26,1,digits), working_index);
    string = fliplr(letters([outputs{:}]));
end
