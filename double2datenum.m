%{
Convert the supplied double in the form 'yyyymmdd' to a MATLAB datenum


%}

function date = double2datenum(yearmonthday)

    year = fix(yearmonthday/10000);
    monthday = yearmonthday - year*10000;
    month = fix(monthday/100);
    day = yearmonthday - year*10000 - month*100;
    
    date = datenum(year,month,day);

end