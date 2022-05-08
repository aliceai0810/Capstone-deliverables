% Read the mmf list from the link. If the targeting xml file are in excel
% format, the xml tag name rules are different. Some treat empty column as
% empty tag, some ommit the tag. So we use the corresponding csv file for
% this type of xml files. There are some differences in column names, we
% use 'advisor' in general, and fill the missing value with the empty
% string.
function a = getmmf(projectDir,userEmail,token,system)
    xmlName = strcat(projectDir,system,'test.xml');
    urlwrite(strcat('https://www.sec.gov',token{1}{1}),xmlName,'UserAgent',userEmail);
    if length(detectImportOptions(xmlName).RegisteredNamespaces)>5
        read = urlread('https://www.sec.gov/open/datasets-mmf.html','UserAgent',userEmail);
        links = regexp(read,'<a.*?/a>','match');
        link = append('<a href="(?<link>.*?\.csv)".*? download>',token{1}{2},'</a>');
        get = regexp(links,link,'tokens');
        get(cellfun(@(x)isempty(x),get))=[];
        name = append(projectDir,system,'test.csv');
        websave(name,strcat('https://www.sec.gov',get{1}{1}{1}),'UserAgent',userEmail);
        opt = detectImportOptions(name);
        opt = setvartype(opt,opt.VariableNames,'string');
        opt = setvaropts(opt,opt.VariableNames,'FillValue',"");
        a=readtable(name,opt);
    else
        opt=detectImportOptions(xmlName,'RowSelector','//money_market_fund');
        a = readtable(xmlName,opt);
        writetable(a,append(projectDir,system,'test.csv'));
        xmlName = strcat(projectDir,system,'test.csv');
        opt = detectImportOptions(xmlName);
        opt = setvartype(opt,opt.VariableNames,'string');
        opt = setvaropts(opt,opt.VariableNames,'FillValue',"");
        a=readtable(xmlName,opt);
    end
    a{:,'reporting_period'}=string(datestr(datenum(a.reporting_period(1)),'yyyy-mm-dd'));
    if any(strcmp(a.Properties.VariableNames,'investment_adviser'))
        a.Properties.VariableNames{'investment_adviser'}='investment_advisor';
    end
    if any(strcmp(a.Properties.VariableNames,'sub_adviser'))
        a.Properties.VariableNames{'sub_adviser'}='sub_advisor';
    end
    if any(strcmp(a.Properties.VariableNames,'Subadvisor_name'))
        a.Properties.VariableNames{'Subadvisor_name'}='sub_advisor';
    end
    a(:,'registrant_cik')=varfun(@(x)replace(x,"NaN",""),a,'InputVariables','registrant_cik');
    a(:,{'registrant_name','series_name','class_name','investment_advisor','sub_advisor'})=varfun(@upper,a,'InputVariables',{'registrant_name','series_name','class_name','investment_advisor','sub_advisor'});
end