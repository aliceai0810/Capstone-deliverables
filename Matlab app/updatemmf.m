% Read the mmf list file on the sec.gov website, extract and return the links with .xml
% with the month in cell array format. If there's a mmf.csv file in the
% local directory, the first line will be read to get the latest
% reporting_period. Only the xml with month after this time will be added
% to the updatelinks.

function updatelinks = updatemmf(projectDir,userEmail,system)
    if isfile(append(projectDir,system,'mmf.csv'))
        opt = detectImportOptions(append(projectDir,system,'mmf.csv'));
        opt = setvartype(opt,opt.VariableNames,'string');
        opt.DataLines=[2 2];
        result = readtable(append(projectDir,system,'mmf.csv'),opt);
        read = urlread('https://www.sec.gov/open/datasets-mmf.html','UserAgent',userEmail);
        links = regexp(read,'<a.*?/a>','match');
        tokens = regexp(links,'<a href="(?<link>.*?\.xml)".*? download>(?<month>.*?)</a>','tokens');
        tokens(cellfun(@(x)isempty(x),tokens))=[];
        tokens(cellfun(@(x)datetime(x{1}{2},'InputFormat','MMMM yyyy')<datetime(result.reporting_period{1}),tokens))=[];
        updatelinks = tokens;
    else
        read = urlread('https://www.sec.gov/open/datasets-mmf.html','UserAgent',userEmail);
        links = regexp(read,'<a.*?/a>','match');
        tokens = regexp(links,'<a href="(?<link>.*?\.xml)".*? download>(?<month>.*?)</a>','tokens');
        tokens(cellfun(@(x)isempty(x),tokens))=[];
        tokens(cellfun(@(x)datetime(x{1}{2},'InputFormat','MMMM yy')<datetime('2016-10-01'),tokens))=[];
        updatelinks = tokens;
    end
end