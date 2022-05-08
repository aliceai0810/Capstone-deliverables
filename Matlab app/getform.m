% Get the content of a NMFP-2 form from the link to the projectDir with the userEmail. 
% The repurchase_opt decide whether the repurchse agreement info of securities will be included. 
% System refers to the backslash or forward slash used in the system's default path format.
% (getform.basicInfo is the general, signature, and series sections that will be repeated in each row 
% with either class section or security section. getform.form is the output table.)

classdef getform
    properties
        form
        basicInfo
    end
    methods 
        function obj=getform(link,projectDir,userEmail,repurchase_opt,system)
            obj.form=table();
            obj.basicInfo= table();
            name = append(projectDir,system,'test.xml');
            delete(name);
            websave(name,link,'UserAgent',userEmail);
            obj.basicInfo=readtable(name,'RowSelector','//ns_1:submissionType');
            
            function data(name,section)
                if section==1
                    check = 'generalInfo';
                elseif section==2
                    check = 'signature';
                elseif section==3
                    check = 'seriesLevelInfo';
                elseif section==4
                    check = 'classLevelInfo';
                elseif section==5
                    check = 'scheduleOfPortfolioSecuritiesInfo';
                end
                
                opt = detectImportOptions(name,'RowSelector',append('//ns_1:',check));
                opt.VariableNamingRule='preserve';
                opt = setvartype(opt,opt.VariableNames,'string');
                opt = setvaropts(opt,opt.VariableNames,'FillValue',"");
                s=opt.VariableSelectors;
                if any(cellfun(@(x) startsWith(x,'(//ns_1:scheduleOfPortfolioSecuritiesInfo)/ns_1:repurchaseAgreement/ns_1:collateralIssuers/'),s))
                    repurchaseColumn=s(cellfun(@(x) startsWith(x,'(//ns_1:scheduleOfPortfolioSecuritiesInfo)/ns_1:repurchaseAgreement/ns_1:collateralIssuers/'),s));
                    get= s(cellfun(@(x) ~startsWith(x,'(//ns_1:scheduleOfPortfolioSecuritiesInfo)/ns_1:repurchaseAgreement/ns_1:collateralIssuers/'),s));
                    opt.VariableNames=opt.VariableNames(cellfun(@(x) ~startsWith(x,'(//ns_1:scheduleOfPortfolioSecuritiesInfo)/ns_1:repurchaseAgreement/ns_1:collateralIssuers/'),s));
                    opt.VariableSelectors=get;
                    opt2=detectImportOptions(name,'VariableSelectors',[{'(//ns_1:generalInfo)/ns_1:reportDate','(//ns_1:signature)/ns_1:registrant','(//ns_1:generalInfo)/ns_1:cik'},repurchaseColumn]);
                    opt2.VariableNamingRule='preserve';
                    opt2 = setvartype(opt2,opt2.VariableNames,'string');
                    opt2 = setvaropts(opt2,opt2.VariableNames,'FillValue',"");
                    if repurchase_opt
                        repurchase=readtable(name,opt2);
                        repurchase.reportDate(2:end)=repurchase.reportDate{1};
                        repurchase.registrant(2:end)=repurchase.registrant{1};
                        repurchase.cik(2:end)=repurchase.cik{1};
                        if isfile(append(projectDir,system,'repurchaseAgreement.csv'))
                            opt3=detectImportOptions(append(projectDir,system,'repurchaseAgreement.csv'));
                            opt3.VariableNamingRule='preserve';
                            opt3 = setvartype(opt3,opt3.VariableNames,'string');
                            opt3 = setvaropts(opt3,opt3.VariableNames,'FillValue',"");
                            repurchase_old=readtable(append(projectDir,system,'repurchaseAgreement.csv'),opt3);
                            start=height(repurchase_old);
                            for j=1:length(repurchase.Properties.VariableNames)
                                repurchase_old{start+1:start+height(repurchase),repurchase.Properties.VariableNames{j}}=repurchase.(repurchase.Properties.VariableNames{j});
                            end
                            repurchase_old.('registrant')=upper(repurchase_old.('registrant'));
                            writetable(repurchase_old,append(projectDir,system,'repurchaseAgreement.csv'));
                        else
                            repurchase.('registrant')=upper(repurchase.('registrant'));
                            writetable(repurchase,append(projectDir,system,'repurchaseAgreement.csv'));
                        end
                    end
                end
                s= opt.VariableSelectors;
                s = cellfun(@(x)regexprep(x,'.*)','','once'),s,'UniformOutput',0);
                s = cellfun(@(x)regexp(x,'/n[\w]+:(?<tag>[\w]+)','tokens'),s,'UniformOutput',0);
                s = cellfun(@(x)string(x(max(1,end-1):end)),s,'UniformOutput',0);
                if section==2
                    s{1,1}="signature";
                end
                if ~isempty(s(cellfun(@(x)length(x)==2 & contains(x{max(end-1,1)},x{end}),s)))
                    s(cellfun(@(x)length(x)==2 & contains(x{max(end-1,1)},x{end}),s))=cellfun(@(y)y{1},s(cellfun(@(x)length(x)==2 & contains(x{max(end-1,1)},x{end}),s)),'UniformOutput',0);
                end
                if ~isempty(s(cellfun(@(x)length(x)==2 & contains(x{end},x{max(end-1,1)}),s)))
                    s(cellfun(@(x)length(x)==2 & contains(x{end},x{max(end-1,1)}),s))=cellfun(@(y)y{2},s(cellfun(@(x)length(x)==2 & contains(x{end},x{max(end-1,1)}),s)),'UniformOutput',0);
                end
                s(cellfun(@(x)length(x)==2,s)) = cellfun(@(x) [x(~strncmpi(x, 'friday', length('friday'))),x(strncmpi(x, 'friday', length('friday')))],s(cellfun(@(x)length(x)==2,s)),'UniformOutput',0);
                if section==3
                    prefix="series";
                elseif section==4
                    prefix="class";
                elseif section==5
                    prefix="security";
                else
                    prefix="";
                end
                if prefix==""
                    s(cellfun(@(x)length(x)==2,s)) = cellfun(@(x)strjoin(x,'_'),s(cellfun(@(x)length(x)==2,s)),'UniformOutput',0);
                else
                    s = cellfun(@(x)strjoin([prefix,x],':'),s,'UniformOutput',0);
                end
                
                result=readtable(name,opt);

                if section==2
                    result = result(:,setdiff(1:end,4));
                    result.Properties.VariableNames=[s{setdiff(1:end,4)}];
                    result=fillmissing(result(1,:),'constant',result{2,1});
                else
                    result.Properties.VariableNames=[s{:}];
                    result = fillmissing(result,'constant',"");
                end
                if section==1||section==2||section==3
                    obj.basicInfo=[obj.basicInfo,result];
                elseif section==4
                    obj.form=result;
                else
                    name = [obj.form.Properties.VariableNames,result.Properties.VariableNames];
                    %obj.form{:,result.Properties.VariableNames(~strcmp(obj.form.Properties.VariableNames,result.Properties.VariableNames))}="";
                    %obj.form=[obj.form;result];
                    obj.form(height(obj.form)+1:height(obj.form)+height(result),width(obj.form)+1:width(obj.form)+width(result))=result;
                    obj.form.Properties.VariableNames=name;
                    obj.form = [repelem(obj.basicInfo,height(obj.form),1),obj.form];

                end     
            end

            for i=(1:5)
                data(name,i);
            end
            obj.form(:,[{'reportDate','registrant','seriesId','class:classesId'},obj.form.Properties.VariableNames(startsWith(obj.form.Properties.VariableNames,'series:moneyMarketFundCategory'))])=varfun(@upper,obj.form,'InputVariables',[{'reportDate','registrant','seriesId','class:classesId'},obj.form.Properties.VariableNames(startsWith(obj.form.Properties.VariableNames,'series:moneyMarketFundCategory'))]);
        end
        
    end
end
