

function result = getIndex(link,projectDir,userEmail,system)
    name = append(projectDir,system,'test.xml');
    websave(name,link,'UserAgent',userEmail);
    warning('off');
    opt = detectImportOptions(name,'VariableSelectors','//ns_1:scheduleOfPortfolioSecuritiesInfo/ns_1:nameOfIssuer');
    opt = setvartype(opt,opt.VariableNames,'string');
    opt = setvaropts(opt,opt.VariableNames,'FillValue',"");
    security = upper(unique(readtable(name,opt)));
    result = security;
    opt = detectImportOptions(name,'VariableSelectors','//ns_1:classLevelInfo/ns_1:classesId');
    opt = setvartype(opt,opt.VariableNames,'string');
    opt = setvaropts(opt,opt.VariableNames,'FillValue',"");
    class = unique(readtable(name,opt));
    result(end+1:end+height(class),'class') = class;
    opt = detectImportOptions(name,'VariableSelectors',{'//ns_1:submissionType','//ns_1:generalInfo/ns_1:reportDate','//ns_1:generalInfo/ns_1:cik','//ns_1:signature/ns_1:registrant','//ns_1:generalInfo/ns_1:seriesId'});
    opt = setvartype(opt,opt.VariableNames,'string');
    opt = setvaropts(opt,opt.VariableNames,'FillValue',"");
    basic = readtable(name,opt);
    basic.('registrant')=upper(basic.('registrant'));
    result = [repelem([table(string(link),'VariableNames',{'link'}),basic],height(result),1),result];
    result = fillmissing(result,'constant',"");
end
