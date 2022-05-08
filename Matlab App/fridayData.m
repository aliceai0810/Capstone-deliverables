% tranform friday1/2/3/4/5 format data into one variable by find out the
% date of fridays in the month of reporting_period, and return a table
% with assigned groupby item, reportdate, and targting variable.
function new = fridayData(data,variableName,group,check)
    col = data.Properties.VariableNames(startsWith(data.Properties.VariableNames,variableName));
    fdata=unique(data(data.(check)==group,['reportDate',col]));
    new = table();
    for i =1:height(fdata)
        period=datestr(fdata.reportDate(i),'yyyy-mm');
        a = rem(6-weekday(period),7);
        if a<0
            a=a+7;
        end
        n=1;
        next =datetime(datestr(addtodate(datenum(period),a,'day')));
        while next<=fdata.reportDate(i)
            start = height(new);
            if ~ismember('reportDate',new.Properties.VariableNames)||~ismember(next,new.('reportDate'))
                new(start+1,{check,'reportDate',variableName}) = {group,next,double(fdata{i,1+n})};
            else
                new{new.('reportDate')==next,variableName}=new{new.reportDate==next,variableName}+double(fdata{i,1+n});
            end
            n=n+1;
            next = datetime(datestr(addtodate(datenum(next),7,'day')));
        end
    end
end
