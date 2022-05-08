classdef MassAnalytics_A7_April_19_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        TabGroup                       matlab.ui.container.TabGroup
        LoginTab                       matlab.ui.container.Tab
        CheckEmail                     matlab.ui.control.Label
        Enter                          matlab.ui.control.Button
        EmailLabel                     matlab.ui.control.Label
        EmailEdit                      matlab.ui.control.EditField
        Image                          matlab.ui.control.Image
        UpdateTab                      matlab.ui.container.Tab
        CheckDir                       matlab.ui.control.Label
        DirEdit                        matlab.ui.control.EditField
        Percentage                     matlab.ui.control.Label
        ProgressBar                    matlab.ui.control.Label
        ProgressBarBackground          matlab.ui.control.Label
        Next                           matlab.ui.control.Button
        Download                       matlab.ui.control.StateButton
        DownloadInfo                   matlab.ui.control.Label
        CheckUpdates                   matlab.ui.control.Button
        Directory                      matlab.ui.control.Label
        UserEmailUpdatePage            matlab.ui.control.Label
        Browse                         matlab.ui.control.Button
        SearchSECDatabaseUpdatePage    matlab.ui.control.Label
        FilterTab                      matlab.ui.container.Tab
        GetData                        matlab.ui.control.Button
        UserEmailFilterPage            matlab.ui.control.Label
        Panel                          matlab.ui.container.Panel
        ClearFilters                   matlab.ui.control.Button
        Filters                        matlab.ui.control.DropDown
        SelectAll                      matlab.ui.control.Button
        ClassName                      matlab.ui.control.ListBox
        SeriesCategoryName             matlab.ui.control.ListBox
        SeriesName                     matlab.ui.control.ListBox
        RegistrantName                 matlab.ui.control.ListBox
        ReportingPeriod                matlab.ui.control.ListBox
        MMFListTable                   matlab.ui.control.Table
        SearchSECDatabaseFilterPage    matlab.ui.control.Label
        DownloadTab                    matlab.ui.container.Tab
        RepurchaseAgreement            matlab.ui.control.CheckBox
        ShowSecurity                   matlab.ui.control.StateButton
        SecurityEdit                   matlab.ui.control.EditField
        NameOfSecurityIssuer           matlab.ui.control.Label
        IssuerList                     matlab.ui.control.ListBox
        ShowClassId                    matlab.ui.control.StateButton
        ClassIdEdit                    matlab.ui.control.EditField
        ClassId                        matlab.ui.control.Label
        ClassIdList                    matlab.ui.control.ListBox
        UserEmailResultsPage           matlab.ui.control.Label
        DownloadInfo_2                 matlab.ui.control.Label
        DownloadDir                    matlab.ui.control.Label
        DownloadDirFrame               matlab.ui.control.Label
        Preview                        matlab.ui.control.Button
        Download_2                     matlab.ui.control.Button
        Browse_2                       matlab.ui.control.Button
        SelectedFunds                  matlab.ui.control.Label
        Directory_2                    matlab.ui.control.Label
        Sections                       matlab.ui.container.CheckBoxTree
        SelectAllNode                  matlab.ui.container.TreeNode
        GeneralInfoNode                matlab.ui.container.TreeNode
        SeriesInfoNode                 matlab.ui.container.TreeNode
        SignatureInfoNode              matlab.ui.container.TreeNode
        ClassInfoNode                  matlab.ui.container.TreeNode
        SecurityInfoNode               matlab.ui.container.TreeNode
        NMFP2                          matlab.ui.control.Label
        DownloadPanel                  matlab.ui.control.TextArea
        DownloadFilterPanel            matlab.ui.control.TextArea
        SelectedInfoPanel              matlab.ui.control.TextArea
        SearchSECDatabaseDownloadPage  matlab.ui.control.Label
        PreviewTab                     matlab.ui.container.Tab
        UserEmailPreviewPage           matlab.ui.control.Label
        Visualization                  matlab.ui.control.Button
        PreviewTable                   matlab.ui.control.Table
        SearchSECDatabasePreviewPage   matlab.ui.control.Label
        VisualizationTab               matlab.ui.container.Tab
        GraphSettings                  matlab.ui.container.Panel
        LegendSetting                  matlab.ui.container.ButtonGroup
        Hide                           matlab.ui.control.RadioButton
        Show                           matlab.ui.control.RadioButton
        GroupBySetting                 matlab.ui.container.ButtonGroup
        Section                        matlab.ui.control.RadioButton
        Registrant                     matlab.ui.control.RadioButton
        GrouppingSetting               matlab.ui.container.ButtonGroup
        Sum                            matlab.ui.control.RadioButton
        Individual                     matlab.ui.control.RadioButton
        CheckingItemSetting            matlab.ui.container.Panel
        ItemList                       matlab.ui.control.ListBox
        ColorsSetting                  matlab.ui.container.Panel
        Targets                        matlab.ui.control.ListBox
        PlottingSetting                matlab.ui.container.ButtonGroup
        Bar                            matlab.ui.control.RadioButton
        Line                           matlab.ui.control.RadioButton
        TabGroup_2                     matlab.ui.container.TabGroup
        PlotTab                        matlab.ui.container.Tab
        UIAxes                         matlab.ui.control.UIAxes
        DataTab                        matlab.ui.container.Tab
        VisualizationData              matlab.ui.control.Table
        UserEmailVisualizationPage     matlab.ui.control.Label
        SearchSECDatabaseVisualizationPage  matlab.ui.control.Label
        ContextMenu                    matlab.ui.container.ContextMenu
        SetColor                       matlab.ui.container.Menu
    end

    
    properties (Access = public)
        userEmail; % Description
        projectDir;
        mmf;
        links;
        form;
        updatelinks;
        filters;
        dlDir;
        data;
        visualData;
        colors;
        colorsum;
        system;
    end
    
    methods (Access = private)
        
        
        function preview(app,action)
            cla(app.UIAxes);
            
            if startsWith(app.ItemList.Value,'series:')
                check='seriesId';
                app.Section.Text='Series';
            elseif startsWith(app.ItemList.Value,'class:')
                check='class:classesId';
                app.Section.Text='Class';
            else
                check='security:nameOfIssuer';
                app.Section.Text='Security';
            end
            if app.Registrant.Value
                check='registrant';
            end
            each = unique(app.visualData{:,check});
            each = each(each~="");
            app.Targets.Items=each;
            if action=="item" || action== "groupby"
                app.VisualizationData.ColumnName={check,'reportDate',app.ItemList.Value};
                if ismember(app.ItemList.Value,{'series:totalValueDailyLiquidAssets','series:totalValueWeeklyLiquidAssets','series:percentageDailyLiquidAssets',...
                        'series:percentageWeeklyLiquidAssets', 'series:netAssetValue','class:netAssetPerShare','class:weeklyGrossSubscriptions',...
                        'class:weeklyGrossRedemptions'})
                    app.VisualizationData.Data=table();
                    for i=1:length(each)
                        friday=sortrows(fridayData(app.visualData,app.ItemList.Value,each{i},check));
                        friday=friday(~isnan(friday.(app.ItemList.Value)),:);
                        app.VisualizationData.Data(end+1:end+height(friday),app.VisualizationData.ColumnName)=friday;
                        
                    end
                    
                else
                    temp=unique(app.visualData(:,app.VisualizationData.ColumnName));
                    app.VisualizationData.Data=table();
                    app.VisualizationData.Data{:,check}=temp.(check);
                    app.VisualizationData.Data{:,'reportDate'}=datetime(temp.reportDate);
                    app.VisualizationData.Data{:,app.ItemList.Value}=double(temp.(app.ItemList.Value));
                    app.VisualizationData.Data(isnan(app.VisualizationData.Data.(app.ItemList.Value)),:)=[];
                    summary = app.VisualizationData.Data;
                    summary = groupsummary(summary,{check,'reportDate'},'sum');
                    app.VisualizationData.Data = renamevars(summary(:,[1,2,4]),append('sum_',app.ItemList.Value),app.ItemList.Value);
                end
            end
            if action=="color"
                app.UIFigure.Visible = 'Off';
                if app.Sum.Value
                    app.colorsum=uisetcolor;
                else
                    app.colors.(app.Targets.Value)=uisetcolor;
                end
                app.UIFigure.Visible = 'On';
            end
            app.UIAxes.XLabel.String='Time';
            app.UIAxes.YLabel.String=app.ItemList.Value;
            app.UIAxes.Title.String=app.ItemList.Value;
            if app.Line.Value && app.Sum.Value==false
                if ismember(app.ItemList.Value,{'series:totalValueDailyLiquidAssets','series:totalValueWeeklyLiquidAssets','series:percentageDailyLiquidAssets',...
                        'series:percentageWeeklyLiquidAssets', 'series:netAssetValue','class:netAssetPerShare','class:weeklyGrossSubscriptions',...
                        'class:weeklyGrossRedemptions'})
                    hold(app.UIAxes,'on')
                    for i=1:length(each)
                        if ismember(each{i},app.colors.Properties.VariableNames)
                            plot(app.UIAxes,datetime(app.VisualizationData.Data(strcmp(app.VisualizationData.Data.(check),each{i}),:).reportDate),double(app.VisualizationData.Data(strcmp(app.VisualizationData.Data.(check),each{i}),:).(app.ItemList.Value)),'DisplayName',each{i},'Color',app.colors{1,each{i}},'DisplayName',each{i});
                        else
                            plot(app.UIAxes,datetime(app.VisualizationData.Data(strcmp(app.VisualizationData.Data.(check),each{i}),:).reportDate),double(app.VisualizationData.Data(strcmp(app.VisualizationData.Data.(check),each{i}),:).(app.ItemList.Value)),'DisplayName',each{i});
                        end
                    end
                    
                else




                    hold(app.UIAxes,'on')
                    for i=1:length(each)
                        if ismember(each{i},app.colors.Properties.VariableNames)
                            plot(app.UIAxes,datetime(app.VisualizationData.Data(strcmp(app.VisualizationData.Data.(check),each{i}),:).reportDate),double(app.VisualizationData.Data(strcmp(app.VisualizationData.Data.(check),each{i}),:).(app.ItemList.Value)),'DisplayName',each{i},'Color',app.colors{1,each{i}},'DisplayName',each{i});
                        else
                            plot(app.UIAxes,datetime(app.VisualizationData.Data(strcmp(app.VisualizationData.Data.(check),each{i}),:).reportDate),double(app.VisualizationData.Data(strcmp(app.VisualizationData.Data.(check),each{i}),:).(app.ItemList.Value)),'DisplayName',each{i});
                        end
                    end
                    
                end
                hold(app.UIAxes,'off');
                if app.Hide.Value
                    legend(app.UIAxes,each);
                else
                    legend(app.UIAxes,'off');
                end
            elseif app.Bar.Value && app.Sum.Value==false
                y = unstack(app.VisualizationData.Data,3,1,'VariableNamingRule','preserve');
                x=unique(y{:,1}');
                y=y{:,2:end};
                b=bar(app.UIAxes,x,y);
                for i=1:length(each)
                    if ismember(each{i},app.colors.Properties.VariableNames)
                        b(i).FaceColor=app.colors{1,each{i}};
                    end
                end
                if app.Show.Value
                    legend(app.UIAxes,each);
                else
                    legend(app.UIAxes,'off');
                end
            elseif app.Sum.Value==true
                app.Targets.Items={'Sum'};
                y=unstack(app.VisualizationData.Data(~isnan(app.VisualizationData.Data{:,3}),2:3),2,1,'VariableNamingRule','preserve','AggregationFunction',@sum);
                x=unique(app.VisualizationData.Data{~isnan(app.VisualizationData.Data{:,3}),'reportDate'});
                if app.Bar.Value
                    b=bar(app.UIAxes,x,y{1,:}');
                    if ~isempty(app.colorsum)
                        b.FaceColor=app.colorsum;
                    end
                else
                    if ~isempty(app.colorsum)
                        plot(app.UIAxes,x,y{1,:}','Color',app.colorsum);
                    else
                        plot(app.UIAxes,x,y{1,:}');
                    end
                end
                if app.Show.Value
                    legend(app.UIAxes,'sum')
                else
                    legend(app.UIAxes,'off');
                end
            end
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: Enter
        function EnterPushed(app, event)
%            Check if the string entered is a valid email address, 
%            If not, a reminder will be shown. 
%            If yes, go to the update page. 
%            The email entered will be shown on the pages after.
%            A valid email address must be in recipient_name@domain format. 
%            The recipient name must only start and end with digit or letter, 
%            and consist of letters, digits, hyphen (-), period (.), underscore (_), and plus sign (+). 

            email = '([a-z0-9]([a-z0-9.-_+]+)[a-z0-9]|[a-z0-9])@([a-z0-9]([a-z0-9.-]+)[a-z0-9]|[a-z0-9])+\.(com|net|org|gov|mil|edu|biz|info|pro|name|coop|travel|xxx|idv|aero|museum|mobi|asia|tel|int|post|jobs|cat|ac|ad|ae|af|ag|ai|al|am|an|ao|aq|ar|as|at|au|aw|az|ba|bb|bd|be|bf|bg|bh|bi|bj|bm|bn|bo|br|bs|bt|bv|bw|by|bz|ca|cc|cd|cf|cg|ch|ci|ck|cl|cm|cn|co|cr|cu|cv|cx|cy|cz|de|dj|dk|dm|do|dz|ec|ee|eg|eh|er|es|et|eu|fi|fj|fk|fm|fo|fr|ga|gd|ge|gf|gg|gh|gi|gl|gm|gn|gp|gq|gr|gs|gt|gu|gw|gy|hk|hm|hn|hr|ht|hu|id|ie|il|im|in|io|iq|ir|is|it|je|jm|jo|jp|ke|kg|kh|ki|km|kn|kp|kr|kw|ky|kz|la|lb|lc|li|lk|lr|ls|ma|mc|md|me|mg|mh|mk|ml|mm|mn|mo|mp|mq|mr|ms|mt|mu|mv|mw|mx|my|mz|na|nc|ne|nf|ng|ni|nl|no|np|nr|nu|nz|om|pa|pe|pf|pg|ph|pk|pl|pm|pn|pr|ps|pt|pw|py|qa|re|ro|ru|rw|sa|sb|sc|sd|se|sg|sh|si|sj|sk|sm|sn|so|sr|st|sv|sy|sz|tc|td|tf|tg|th|tj|tk|tl|tm|tn|to|tp|tr|tt|tv|tw|tz|ua|ug|uk|um|us|uy|uz|va|vc|ve|vg|vi|vn|vu|wf|ws|ye|yt|yu|yr|za|zm|zw)';
            c = lower(regexpi(app.EmailEdit.Value, email, 'match'));
            if isempty(c)
                app.CheckEmail.Visible = 'On';
            else
                app.CheckEmail.Visible = 'Off';

                app.userEmail = app.EmailEdit.Value;
                app.TabGroup.SelectedTab = app.UpdateTab;


                app.UserEmailUpdatePage.Text = app.userEmail;
                app.UserEmailFilterPage.Text = app.userEmail;
                app.UserEmailResultsPage.Text = app.userEmail;
                app.UserEmailPreviewPage.Text = app.userEmail;
                app.UserEmailVisualizationPage.Text = app.userEmail;
                
%               These three lines are used if the programmer want to set
%               default project directory. 
                app.projectDir=app.DirEdit.Value;
                app.DownloadDir.Text=app.DirEdit.Value;
                app.dlDir = app.DirEdit.Value;
                
            end
        end

        % Button pushed function: Browse
        function BrowsePushed(app, event)
%             Select the project directory for index and temporary files. 
%             Because when using the uigetdir, the front page will jump to the another one, 
%             we close the ui and reopen it when selection has been made.
%             The downloading directory is the same as the project directory by default
%             Because the Mac and Windows system use different slash for paths,
%             store the backslash or forward slash from the system default path 
%             as app.system for later file paths.


            app.Download.Visible='Off';
            app.ProgressBar.Visible='Off';
            app.ProgressBarBackground.Visible='Off';
            app.Percentage.Visible='Off';
            app.DownloadInfo.Visible='Off';
            app.Next.Visible='Off';
            app.UIFigure.Visible = 'Off';
            app.projectDir = char(uigetdir);
            app.dlDir=app.projectDir;
            app.DownloadDir.Text=app.dlDir;
            app.UIFigure.Visible = 'on';
            app.DirEdit.Value = app.projectDir;

%             Check default slash marks used in the paths.
            if contains(app.projectDir,'\')
                app.system='\';
            else
                app.system='/';
            end
        end

        % Value changed function: DirEdit
        function DirEditValueChanged(app, event)
%            If manually enter the directory path, check if it's valid.
            value = app.DirEdit.Value;
            if not(isfolder(value))
                app.CheckDir.Visible='On';
            else
                app.CheckDir.Visible='Off';
            
                app.projectDir=value;
                app.dlDir=app.projectDir;
                app.DownloadDir.Text=app.dlDir;
                app.UIFigure.Visible = 'on';
                app.DirEdit.Value = app.projectDir;

%             Check default slash marks used in the paths.
                if contains(app.projectDir,'\')
                    app.system='\';
                else
                    app.system='/';
                end
            end
        end

        % Button pushed function: CheckUpdates
        function CheckUpdatesPushed(app, event)
            
%             Check number of monthly mmf list files to update.
%             When no further updates are needed, check for number of links to download.

            app.DownloadInfo.Visible='On';
            if isempty(app.userEmail)
                app.DownloadInfo.Text = 'Please go to the Login page to enter your email.';
            elseif isempty(app.projectDir)
                app.DownloadInfo.Text = 'Please choose your project directory.';
            else
                
                app.updatelinks = updatemmf(app.projectDir,app.userEmail,app.system);
                if ~isfile(append(app.projectDir,app.system,'links.csv'))
                    writetable(table(),append(app.projectDir,app.system,'links.csv'));
                end
                app.links = readtable(append(app.projectDir,app.system,'links.csv'),'Delimiter',',');
                if ~isempty(app.updatelinks)
                    app.Download.Visible='On';
                    app.ProgressBar.Visible='On';
                    app.ProgressBarBackground.Visible='On';
                    app.Percentage.Visible='On';
                    app.Next.Visible='Off';
                    app.DownloadInfo.Text = append('Number of monthly mmf list to load: ',string(length(app.updatelinks)));
                elseif  ~isempty(app.links)
                    opt = detectImportOptions(append(app.projectDir,app.system,'mmf.csv'));
                    opt = setvartype(opt,opt.VariableNames,'string');
                    opt = setvaropts(opt,opt.VariableNames,'FillValue',"");
                    app.mmf = readtable(append(app.projectDir,app.system,'mmf.csv'),opt);
                    app.mmf{:,'reporting_period'}=string(datestr(datenum(app.mmf.reporting_period),'yyyy-mm-dd'));
                    app.Download.Visible='On';
                    app.ProgressBar.Visible='On';
                    app.ProgressBarBackground.Visible='On';
                    app.Percentage.Visible='On';
                    app.Next.Visible='Off';
                    app.DownloadInfo.Text = append('Number of form to load: ',string(height(readtable(append(app.projectDir,app.system,'links.csv'),'Delimiter',','))));
                else
                    app.DownloadInfo.Text = 'No update needed.';
                    opt = detectImportOptions(append(app.projectDir,app.system,'mmf.csv'));
                    opt = setvartype(opt,opt.VariableNames,'string');
                    opt = setvaropts(opt,opt.VariableNames,'FillValue',"");
                    app.mmf = readtable(append(app.projectDir,app.system,'mmf.csv'),opt);
                    app.mmf{:,'reporting_period'}=string(datestr(datenum(app.mmf.reporting_period),'yyyy-mm-dd'));
                    app.Next.Visible='On';
                    
                end
                
            end
        end

        % Value changed function: Download
        function DownloadValueChanged(app, event)
%             There are three tasks: update mmf list, get updated form data
%             links and get the security info. So the progress bar need to load three times with different colors.
%             Firstly, update or create the mmf list to the mmf.csv in the
%             directory. Use getmmf function to extract content from
%             each updatelinks. Also fill out empty cik and registrant info
%             with the same seriesId from the historical data or the
%             manully search result from the sec.gov. When extract form
%             data, we tested multiple xml process function, the most
%             efficient way is to store locally and use readtable with
%             import options setup. Then, save all form links into the links.csv file.
%             Lastly, extract series, class, and security info from the links. 
%             (This part takes time, but allow user to search for holding funds by securities)
%             The batch number is set to be 100. So the app save and delete the completed links for every 100 forms. 
%             If there's an error due to the connection issue, user can restart the app, 
%             and continue from the interrupted batch. 
%             Because sec.gov only allows ten requests per second, there's
%             a pause action for every ten requests.

            if ~isempty(app.updatelinks)
                app.ProgressBar.BackgroundColor=[0.93,0.69,0.13];
                if isfile(append(app.projectDir,app.system,'mmf.csv'))
                    opt = detectImportOptions(append(app.projectDir,app.system,'mmf.csv'));
                    opt = setvartype(opt,opt.VariableNames,'string');
                    opt = setvaropts(opt,opt.VariableNames,'FillValue',"");
                    app.mmf = readtable(append(app.projectDir,app.system,'mmf.csv'),opt);
                    app.mmf{:,'reporting_period'}=string(datestr(datenum(app.mmf.reporting_period),'yyyy-mm-dd'));
                else
                    app.mmf = table();
                end
                i=1;
                while i<length(app.updatelinks)+1
                    
                    app.mmf=[app.mmf;getmmf(app.projectDir,app.userEmail,app.updatelinks{i},app.system)];
                    app.ProgressBar.Position(3)=i*app.ProgressBarBackground.Position(3)/(1+length(app.updatelinks));
                    app.Percentage.Text=append(string(round(i*100/(1+length(app.updatelinks)))),'%');
                    pause(0.01);
                    i=i+1;

                end   
                clean = unique(app.mmf(app.mmf.registrant_cik=="",:).series_id);
                for k=1:length(clean)
                    if ~isempty(unique(app.mmf(app.mmf.series_id==clean(k)&app.mmf.registrant_cik~="",'registrant_cik')))
                        app.mmf{app.mmf.series_id==clean(k)&app.mmf.registrant_cik=="",'registrant_cik'}=string(groupcounts(app.mmf(app.mmf.series_id==clean(k)&app.mmf.registrant_cik~="",'registrant_cik'),'registrant_cik').registrant_cik{end});
                        app.mmf{app.mmf.series_id==clean(k)&app.mmf.registrant_name=="",'registrant_name'}=string(groupcounts(app.mmf(app.mmf.series_id==clean(k)&app.mmf.registrant_name~="",'registrant_name'),'registrant_name').registrant_name{end});
                    end
                end
                app.mmf{app.mmf.series_id=="S000004271"&app.mmf.registrant_cik=="",'registrant_cik'}="893818";
                app.mmf{app.mmf.series_id=="S000004271"&app.mmf.registrant_name=="",'registrant_name'}="BLACKROCK FUNDS III";
                app.mmf{app.mmf.series_id=="S000008906"&app.mmf.registrant_cik=="",'registrant_cik'}="889512";
                app.mmf{app.mmf.series_id=="S000008906"&app.mmf.registrant_name=="",'registrant_name'}="LEGG MASON PARTNERS INSTITUTIONAL TRUST";
                app.mmf{app.mmf.series_id=="S000008926"&app.mmf.registrant_cik=="",'registrant_cik'}="747576";
                app.mmf{app.mmf.series_id=="S000008926"&app.mmf.registrant_name=="",'registrant_name'}="LEGG MASON PARTNERS MONEY MARKET TRUST";
                app.mmf{app.mmf.series_id=="S000006304"&app.mmf.registrant_cik=="",'registrant_cik'}="353447";
                app.mmf{app.mmf.series_id=="S000006304"&app.mmf.registrant_name=="",'registrant_name'}="CASH RESERVE FUND, INC.";
                app.mmf{app.mmf.series_id=="S000000251"&app.mmf.registrant_cik=="",'registrant_cik'}="842790";
                app.mmf{app.mmf.series_id=="S000000251"&app.mmf.registrant_name=="",'registrant_name'}="AIM INVESTMENT SECURITIES FUNDS (INVESCO INVESTMENT SECURITIES FUNDS)";
                
                app.mmf=sortrows(app.mmf,[1 2],{'descend' 'ascend'});
                writetable(app.mmf,strcat(app.projectDir,app.system,'mmf.csv'));
                delete(append(app.projectDir,app.system,'test.xml'));
                delete(append(app.projectDir,app.system,'test.csv'));
                app.ProgressBar.Position(3)=app.ProgressBarBackground.Position(3);
                app.Percentage.Text='100%';
                pause(0.01);

                y = unique(app.mmf.registrant_cik);
                app.ProgressBar.Position(3)=0;
                app.Percentage.Text='0%';
                app.ProgressBar.BackgroundColor=[0.85,0.33,0.10];
                app.DownloadInfo.Text = append('Number of mmf to load: ',string(length(y)));
                pause(0.01);

                new = {};
                i = 1;

                while i<length(y)+1
                    website = append('https://www.sec.gov/cgi-bin/browse-edgar?action=getcompany&CIK=',y(i),'&type=N-MFP2&datea=',datestr(addtodate(datenum(app.updatelinks{end}{1}{2},'mmmm yyyy'),1,'month'),'yyyy-mm-dd'),'&dateb=',datestr(addtodate(datenum(app.updatelinks{1}{1}{2},'mmmm yyyy'),1,'month'),'yyyy-mm-dd'),'&owner=include&start=&count=100&output=atom');
                    read = urlread(website,'UserAgent',app.userEmail);
                    more=1;
                    while more==1
                         new=[new,regexp(read,'<filing-href>(?<link>.*?)</filing-href>','tokens')];
                         next = regexp(read,'.*<link href="(?<next>.*?)" rel="next"','tokens');
                         if ~isempty(next)
                             read=urlread(next{1}{1},'UserAgent',app.userEmail);
                         else
                             more=0;
                         end
                    end
                    app.ProgressBar.Position(3)=i*app.ProgressBarBackground.Position(3)/length(y);
                    app.Percentage.Text=append(string(round(i*100/length(y))),'%');
                    pause(0.01);
                    i=i+1;
                end
                temp=table(cellfun(@(x)regexprep(x{1},'/[\w-]+\.htm','/primary_doc.xml'),new,'UniformOutput',0)');
                if isfile(append(app.projectDir,app.system,'links.csv'))
                    writetable([readtable(append(app.projectDir,app.system,'links.csv'),'Delimiter',',');temp],append(app.projectDir,app.system,'links.csv'));
                else
                    writetable(temp,append(app.projectDir,app.system,'links.csv'));
                end
            end


            app.links = readtable(append(app.projectDir,app.system,'links.csv'),'Delimiter',',');
                 
            if ~isempty(app.links)
                app.ProgressBar.Position(3)=0;
                app.Percentage.Text='0%';
                app.DownloadInfo.Text = append('Number of form to load: ',string(height(app.links)));
                pause(0.01);
                app.ProgressBar.BackgroundColor=[0.00,0.51,0.40];
                warning('off');
                task=app.links;
                if isfile(append(app.projectDir,app.system,'form.csv'))
                    opt = detectImportOptions(append(app.projectDir,app.system,'form.csv'));
                    opt = setvartype(opt,opt.VariableNames,'string');
                    opt = setvaropts(opt,opt.VariableNames,'FillValue',"");
                    app.form=readtable(append(app.projectDir,app.system,'form.csv'),opt);
                else
                    app.form=table();
                end
                n = 0;
                s=0;
                batch = 100;
                tic
                while ~isempty(task)
                    s=s+1;
                    
                    n=n+1;
                    app.form = [app.form;getIndex(task{n,1}{1},app.projectDir,app.userEmail,app.system)];
                    if rem(s,9)==0
                        elapsed=toc;
                        if elapsed<1
                            pause(1-elapsed);
                            tic
                        end
                    end
                    
                    if n==batch||s==height(app.links)
                        writetable(app.form,strcat(app.projectDir,app.system,'form.csv'));
                        
                        if height(task)==10||s==height(app.links)
                            task=table();
                            writetable(task,append(app.projectDir,app.system,'links.csv'));
                            
                        else
                            task=task(batch+1:end,:);
                            writetable(task,append(app.projectDir,app.system,'links.csv'));
                        end
                        n=0;
                    end
                    
                    app.ProgressBar.Position(3)=s*app.ProgressBarBackground.Position(3)/height(app.links);
                    app.Percentage.Text=append(string(round(s*100/height(app.links))),'%');
                    pause(0.01);
                end
                elapsed=toc;
            end
            opt = detectImportOptions(append(app.projectDir,app.system,'form.csv'));
            opt = setvartype(opt,opt.VariableNames,'string');
            opt = setvaropts(opt,opt.VariableNames,'FillValue',"");
            app.form=readtable(append(app.projectDir,app.system,'form.csv'),opt);
            writetable(unique(app.form),append(app.projectDir,app.system,'form.csv'))

            app.DownloadInfo.Text = 'MMF list and form data have been updated to the latest version.';
            app.Download.Value=false;
            app.Download.Visible='Off';
            app.Next.Visible='On';

        end

        % Button pushed function: Next
        function NextPushed(app, event)
%             Go to the filter page where the mmf list is used as the index table.


            app.TabGroup.SelectedTab = app.FilterTab;
            app.mmf.('selected')(:)=false;
            app.mmf=movevars(app.mmf,'selected','Before','reporting_period');
            app.MMFListTable.Data=app.mmf;
            app.MMFListTable.ColumnName=app.MMFListTable.Data.Properties.VariableNames;
            app.MMFListTable.ColumnEditable=[true,false,false,false,false,false,false,false,false,false,false,false];
            app.MMFListTable.ColumnWidth='auto';
            app.MMFListTable.ColumnSortable=[false,true,true,true,true,true,true,true,true,true,true,true];
            app.ReportingPeriod.Items = ['All';sort(unique(app.mmf.reporting_period),'descend')];
            app.ReportingPeriod.Value=['All'];
            app.RegistrantName.Items = ['All';sort(unique(app.mmf.registrant_name),'ascend')];
            app.SeriesName.Items = ['All';sort(unique(app.mmf.series_name),'ascend')];
            app.SeriesCategoryName.Items = ['All';sort(unique(app.mmf.series_category_name),'ascend')];
            app.ClassName.Items = ['All';sort(unique(app.mmf.class_name),'ascend')];
            app.RegistrantName.Value=['All'];
            app.SeriesName.Value=['All'];
            app.SeriesCategoryName.Value=['All'];
            app.ClassName.Value=['All'];
            app.RegistrantName.Visible='Off';
            app.SeriesName.Visible='Off';
            app.SeriesCategoryName.Visible='Off';
            app.ClassName.Visible='Off';
            app.filters=true(height(app.mmf),5);
        end

        % Value changed function: Filters
        function FiltersValueChanged(app, event)
%             Dropdown list with 5 filter options: reporting period, registrant name,
%             series name, series category, and class name.
%             When selecting a filter, the area below will place the corresponding list 
%             for the unique values on top.

            value = app.Filters.Value;
            if value=="reporting_period"
                app.ReportingPeriod.Visible='On';
                app.RegistrantName.Visible='Off';
                app.SeriesName.Visible='Off';
                app.SeriesCategoryName.Visible='Off';
                app.ClassName.Visible='Off';
            elseif value=="registrant_name"
                app.RegistrantName.Visible='On';
                app.ReportingPeriod.Visible='Off';
                app.SeriesName.Visible='Off';
                app.SeriesCategoryName.Visible='Off';
                app.ClassName.Visible='Off';
            elseif value=="series_name"
                app.ReportingPeriod.Visible='Off';
                app.RegistrantName.Visible='Off';
                app.SeriesName.Visible='On';
                app.SeriesCategoryName.Visible='Off';
                app.ClassName.Visible='Off';
            elseif value=="series_category_name"
                app.ReportingPeriod.Visible='Off';
                app.RegistrantName.Visible='Off';
                app.SeriesName.Visible='Off';
                app.SeriesCategoryName.Visible='On';
                app.ClassName.Visible='Off';
            elseif value=="class_name"
                app.ReportingPeriod.Visible='Off';
                app.RegistrantName.Visible='Off';
                app.SeriesName.Visible='Off';
                app.SeriesCategoryName.Visible='Off';
                app.ClassName.Visible='On';
            end
            app.ReportingPeriod.Items=['All';sort(unique(app.mmf.reporting_period(all(app.filters,2))),'descend')];
            app.RegistrantName.Items=['All';sort(unique(app.mmf.registrant_name(all(app.filters,2))),'ascend')];
            app.SeriesName.Items=['All';sort(unique(app.mmf.series_name(all(app.filters,2))),'ascend')];
            app.SeriesCategoryName.Items=['All';sort(unique(app.mmf.series_category_name(all(app.filters,2))),'ascend')];
            app.ClassName.Items=['All';sort(unique(app.mmf.class_name(all(app.filters,2))),'ascend')];
        end

        % Value changed function: ReportingPeriod
        function ReportingPeriodValueChanged(app, event)
%             reporting_period filter:
%             When select filter options, the items for the rest of the
%             filters will be changed based on the current option. The
%             mmf list table in the right will also be adjusted based on
%             the filters. To reset certain filter, click 'All'. Support
%             multiselct with control key pressed and click.
            value=app.ReportingPeriod.Value;
            if isempty(value)
                app.ReportingPeriod.Value={'All'};
                app.filters(:,1)=true(height(app.mmf),1);
                app.ReportingPeriod.Items=['All';sort(unique(app.mmf.reporting_period(all(app.filters,2))),'descend')];
            elseif isequal(value,{'All'})
                app.filters(:,1)=true(height(app.mmf),1);
                app.ReportingPeriod.Items=['All';sort(unique(app.mmf.reporting_period(all(app.filters,2))),'descend')];
            else
                app.ReportingPeriod.Value=setdiff(value, {'All'});
                app.filters(:,1)=ismember(app.mmf.reporting_period,app.ReportingPeriod.Value);
            end
            app.MMFListTable.Data=app.mmf(all(app.filters,2),:);
            %app.ReportingPeriod.Items=['All';sort(unique(app.mmf.reporting_period(all(app.filters,2))),'descend')];
            app.RegistrantName.Items=['All';sort(unique(app.mmf.registrant_name(all(app.filters,2))),'ascend')];
            app.SeriesName.Items=['All';sort(unique(app.mmf.series_name(all(app.filters,2))),'ascend')];
            app.SeriesCategoryName.Items=['All';sort(unique(app.mmf.series_category_name(all(app.filters,2))),'ascend')];
            app.ClassName.Items=['All';sort(unique(app.mmf.class_name(all(app.filters,2))),'ascend')];
        end

        % Value changed function: RegistrantName
        function RegistrantNameValueChanged(app, event)
%             registrant_name filter:
%             When select filter options, the items for the rest of the
%             filters will be changed based on the current option. The
%             mmf list table in the right will also be adjusted based on
%             the filters. To reset certain filter, click 'All'. Support
%             multiselct with control key pressed and click.

            value = app.RegistrantName.Value;
            if isempty(value)
                app.RegistrantName.Value={'All'};
                app.filters(:,2)=true(height(app.mmf),1);
                app.RegistrantName.Items=['All';sort(unique(app.mmf.registrant_name(all(app.filters,2))),'ascend')];
            elseif isequal(value,{'All'})
                app.filters(:,2)=true(height(app.mmf),1);
                app.RegistrantName.Items=['All';sort(unique(app.mmf.registrant_name(all(app.filters,2))),'ascend')];
            else
                app.RegistrantName.Value=setdiff(value, {'All'});
                app.filters(:,2)=ismember(app.mmf.registrant_name,app.RegistrantName.Value);
            end
            app.MMFListTable.Data=app.mmf(all(app.filters,2),:);
            app.ReportingPeriod.Items=['All';sort(unique(app.mmf.reporting_period(all(app.filters,2))),'descend')];
            %app.RegistrantName.Items=['All';sort(unique(app.mmf.registrant_name(all(app.filters,2))),'ascend')];
            app.SeriesName.Items=['All';sort(unique(app.mmf.series_name(all(app.filters,2))),'ascend')];
            app.SeriesCategoryName.Items=['All';sort(unique(app.mmf.series_category_name(all(app.filters,2))),'ascend')];
            app.ClassName.Items=['All';sort(unique(app.mmf.class_name(all(app.filters,2))),'ascend')];
        end

        % Value changed function: SeriesName
        function SeriesNameValueChanged(app, event)
%             series_name filter:
%             When select filter options, the items for the rest of the
%             filters will be changed based on the current option. The
%             mmf list table in the right will also be adjusted based on
%             the filters. To reset certain filter, click 'All'. Support
%             multiselct with control key pressed and click.

            value = app.SeriesName.Value;
            if isempty(value)
                app.SeriesName.Value={'All'};
                app.filters(:,3)=true(height(app.mmf),1);
                app.SeriesName.Items=['All';sort(unique(app.mmf.series_name(all(app.filters,2))),'ascend')];
            elseif isequal(value,{'All'})
                app.filters(:,3)=true(height(app.mmf),1);
                app.SeriesName.Items=['All';sort(unique(app.mmf.series_name(all(app.filters,2))),'ascend')];
            else
                app.SeriesName.Value=setdiff(value, {'All'});
                app.filters(:,3)=ismember(app.mmf.series_name,app.SeriesName.Value);
            end
            app.MMFListTable.Data=app.mmf(all(app.filters,2),:);
            app.ReportingPeriod.Items=['All';sort(unique(app.mmf.reporting_period(all(app.filters,2))),'descend')];
            app.RegistrantName.Items=['All';sort(unique(app.mmf.registrant_name(all(app.filters,2))),'ascend')];
            %app.SeriesName.Items=['All';sort(unique(app.mmf.series_name(all(app.filters,2))),'ascend')];
            app.SeriesCategoryName.Items=['All';sort(unique(app.mmf.series_category_name(all(app.filters,2))),'ascend')];
            app.ClassName.Items=['All';sort(unique(app.mmf.class_name(all(app.filters,2))),'ascend')];
        end

        % Value changed function: SeriesCategoryName
        function SeriesCategoryNameValueChanged(app, event)
%             series_category_name filter:
%             When select filter options, the items for the rest of the
%             filters will be changed based on the current option. The
%             mmf list table in the right will also be adjusted based on
%             the filters. To reset certain filter, click 'All'. Support
%             multiselct with control key pressed and click.

            value = app.SeriesCategoryName.Value;
            if isempty(value)
                app.SeriesCategoryName.Value={'All'};
                app.filters(:,4)=true(height(app.mmf),1);
                app.SeriesCategoryName.Items=['All';sort(unique(app.mmf.series_category_name(all(app.filters,2))),'ascend')];
            elseif isequal(value,{'All'})
                app.filters(:,4)=true(height(app.mmf),1);
                app.SeriesCategoryName.Items=['All';sort(unique(app.mmf.series_category_name(all(app.filters,2))),'ascend')];
            else
                app.SeriesCategoryName.Value=setdiff(value, {'All'});
                app.filters(:,4)=ismember(app.mmf.series_category_name,app.SeriesCategoryName.Value);
            end
            app.MMFListTable.Data=app.mmf(all(app.filters,2),:);
            app.ReportingPeriod.Items=['All';sort(unique(app.mmf.reporting_period(all(app.filters,2))),'descend')];
            app.RegistrantName.Items=['All';sort(unique(app.mmf.registrant_name(all(app.filters,2))),'ascend')];
            app.SeriesName.Items=['All';sort(unique(app.mmf.series_name(all(app.filters,2))),'ascend')];
            %app.SeriesCategoryName.Items=['All';sort(unique(app.mmf.series_category_name(all(app.filters,2))),'ascend')];
            app.ClassName.Items=['All';sort(unique(app.mmf.class_name(all(app.filters,2))),'ascend')];
        end

        % Value changed function: ClassName
        function ClassNameValueChanged(app, event)
%             class_name filter:
%             When select filter options, the items for the rest of the
%             filters will be changed based on the current option. The
%             mmf list table in the right will also be adjusted based on
%             the filters. To reset certain filter, click 'All'. Support
%             multiselct with control key pressed and click.

            value = app.ClassName.Value;
            if isempty(value)
                app.ClassName.Value={'All'};
                app.filters(:,5)=true(height(app.mmf),1);
                app.ClassName.Items=['All';sort(unique(app.mmf.class_name(all(app.filters,2))),'ascend')];
            elseif isequal(value,{'All'})
                app.filters(:,5)=true(height(app.mmf),1);
                app.ClassName.Items=['All';sort(unique(app.mmf.class_name(all(app.filters,2))),'ascend')];
            else
                app.ClassName.Value=setdiff(value, {'All'});
                app.filters(:,5)=ismember(app.mmf.class_name,app.ClassName.Value);
            end
            app.MMFListTable.Data=app.mmf(all(app.filters,2),:);
            app.ReportingPeriod.Items=['All';sort(unique(app.mmf.reporting_period(all(app.filters,2))),'descend')];
            app.RegistrantName.Items=['All';sort(unique(app.mmf.registrant_name(all(app.filters,2))),'ascend')];
            app.SeriesName.Items=['All';sort(unique(app.mmf.series_name(all(app.filters,2))),'ascend')];
            app.SeriesCategoryName.Items=['All';sort(unique(app.mmf.series_category_name(all(app.filters,2))),'ascend')];
            %app.ClassName.Items=['All';sort(unique(app.mmf.class_name(all(app.filters,2))),'ascend')];
        end

        % Button pushed function: SelectAll
        function SelectAllPushed(app, event)
            % Select/unselect all forms from the filter results
            if app.SelectAll.Text=="Select All"
                app.MMFListTable.Data.('selected')(:)=true;
                app.SelectAll.Text="Unselect All";
            else
                app.MMFListTable.Data.('selected')(:)=false;
                app.SelectAll.Text="Select All";
            end
            
        end

        % Button pushed function: ClearFilters
        function ClearFiltersPushed(app, event)
            % Clear filter options and reset all filters.
            app.filters=true(height(app.mmf),5);
            app.MMFListTable.Data=app.mmf(all(app.filters,2),:);
            app.SelectAll.Text="Select All";
        
        end

        % Button pushed function: GetData
        function GetDataPushed(app, event)
%             Treenodes to select sections in the downloading csv. 
%             The number of form for each mmf will be shown in the left.
%             
                
            app.TabGroup.SelectedTab = app.DownloadTab;

            freq=groupcounts(app.MMFListTable.Data(app.MMFListTable.Data.selected==true,:),{'registrant_name','reporting_period'});
            freq_1=arrayfun(@(x) sum(freq{freq.registrant_name==x,'GroupCount'}),unique(freq.registrant_name));
            show=newline;
            names=unique(freq.registrant_name);
            for i = 1:height(freq_1)
                show=append(show,sprintf('\nRegistrant: %s\nForms: %s\n',names(i),num2str(uint8(freq_1(i)))));
            end
            app.SelectedInfoPanel.Value=show;
            opt = detectImportOptions(append(app.projectDir,app.system,'form.csv'));
            opt = setvartype(opt,opt.VariableNames,'string');
            opt = setvaropts(opt,opt.VariableNames,'FillValue',"");
            opt.VariableNamingRule='preserve';
            app.data = readtable(append(app.projectDir,app.system,'form.csv'),opt);
            
            date = ismember(app.data.reportDate,unique(app.MMFListTable.Data(app.MMFListTable.Data.selected==true,:).reporting_period)');
            cik = ismember(app.data.cik,arrayfun(@(x) append(repelem('0',10-strlength(x)),x),unique(string(app.MMFListTable.Data(app.MMFListTable.Data.selected==true,:).registrant_cik)')));
            sid = ismember(app.data.seriesId,unique(app.MMFListTable.Data(app.MMFListTable.Data.selected==true,:).series_id)');
        
            app.data=app.data(all([date,cik,sid],2),:);

            app.ClassIdList.Value={};
            app.ClassIdEdit.Visible='On';
            app.ClassId.Visible='On';
            app.ShowClassId.Visible='On';
            app.ClassIdList.Visible='Off';

            app.IssuerList.Value={};
            app.ShowSecurity.Visible='On';
            app.SecurityEdit.Visible='On';
            app.NameOfSecurityIssuer.Visible='On';
            app.IssuerList.Visible='Off';            
        end

        % Button pushed function: Browse_2
        function Browse_2Pushed(app, event)
%             Select the directory for the downloading csv file. 
%             The default value is the project directory selected before.

            app.UIFigure.Visible = 'off';
            app.dlDir = char(uigetdir);
            app.UIFigure.Visible = 'on';
            app.DownloadDir.Text = app.dlDir;
            if contains(app.dlDir,'\')
                app.system='\';
            else
                app.system='/';
            end
        end

        % Button pushed function: Download_2
        function Download_2Pushed(app, event)
%             Download the download.csv file with the customized sections of selected forms.
%             Downloading all massive repurchase agreement info of securities is time-consuming,
%             so users may use the check box to skip this part.
%             If checked, all related repurchase agreement will be stored in another csv file.

            app.DownloadInfo_2.Text="Downloading";
            app.DownloadInfo_2.Visible='On';
            pause(0.01);

            cid = true(height(app.data),1);
            sid = true(height(app.data),1);
            if app.ShowClassId.Value && ~isempty(app.ClassIdList.ValRepurchaseAgreementCheckBoxRepurchaseAgreementCheckBoxue)
                cid = ismember(app.data.class,app.ClassIdList.Value);
            end
            if app.ShowSecurity.Value && ~isempty(app.IssuerList.Value)
                sid = ismember(app.data.nameOfIssuer,app.IssuerList.Value);
            end
            if ~isfile(append(app.projectDir,app.system,'repurchaseAgreement.csv'))
                delete(append(app.projectDir,app.system,'repurchaseAgreement.csv'));
            end
            if ~isfile(append(app.projectDir,app.system,'download.csv'))
                delete(append(app.projectDir,app.system,'download.csv'));
            end
            task = unique(app.data(any([cid,sid],2),:).link);
            download = table();
            for i=1:height(task)
                
                result = getform(task(i),app.projectDir,app.userEmail,app.RepurchaseAgreement.Value,app.system).form;
                start=height(download);
                for j=1:length(result.Properties.VariableNames)
                    
                    com = result.Properties.VariableNames{j};
                    if ismember(com,download.Properties.VariableNames)
                        if width(download.(com)) < width(result.(com))
                            download.(com)=[download{:,com},repelem("",height(download),width(result.(com))-width(download{:,com}))];
                        elseif width(download{:,com}) > width(result.(com))
                            result.(com)=[result{:,com},repelem("",height(result),width(download.(com))-width(result{:,com}))];
                        end
                    end
                    download{start+1:start+height(result),result.Properties.VariableNames{j}}=result.(result.Properties.VariableNames{j});
                end
            end
            col=download.Properties.VariableNames;
            if ~ismember(app.GeneralInfoNode,app.Sections.CheckedNodes)
                col=col(~ismember(col,['submissionType','reportDate','cik','registrantLEIId','seriesId','totalShareClassesInSeries','finalFilingFlag','fundAcqrdOrMrgdWthAnthrFlag']));
            end
            if ~ismember(app.SeriesInfoNode,app.Sections.CheckedNodes)
                col=col(cellfun(@(x)~startsWith(x,'series:'),col));
            end
            if ~ismember(app.SignatureInfoNode,app.Sections.CheckedNodes)
                col=col(~ismember(col,['registrant','signatureDate','signature','nameOfSigningOfficer','titleOfSigningOfficer']));
            end
            if ~ismember(app.SecurityInfoNode,app.Sections.CheckedNodes)
                col=col(cellfun(@(x)~startsWith(x,'security:'),col));
            end
            if ~ismember(app.ClassInfoNode,app.Sections.CheckedNodes)
                col=col(cellfun(@(x)~startsWith(x,'class:'),col));
            end
            download=unique(download(:,col));
            
            writetable(download,append(app.dlDir,app.system,'download.csv'));
            delete(append(app.projectDir,app.system,'test.xml'));
            app.DownloadInfo_2.Text="Download finished";
            app.DownloadInfo_2.Visible='On';
        end

        % Button pushed function: Preview
        function PreviewPushed(app, event)
%             Preview the download.csv
            app.TabGroup.SelectedTab = app.PreviewTab;
            opt = detectImportOptions(append(app.dlDir,app.system,'download.csv'));
            opt = setvartype(opt,opt.VariableNames,'string');
            opt = setvaropts(opt,opt.VariableNames,'FillValue',"");
            opt.VariableNamingRule='preserve';
            app.data = readtable(append(app.dlDir,app.system,'download.csv'),opt);
            app.PreviewTable.Data = app.data;
            app.PreviewTable.ColumnName=app.data.Properties.VariableNames;
            app.PreviewTable.ColumnWidth='auto';
            app.PreviewTable.ColumnEditable=repelem(false,length(app.data.Properties.VariableNames));

        end

        % Value changed function: ClassIdEdit
        function ClassIdEditValueChanged(app, event)
            % This is for specify the certain class to check.
            % The result will only show class info that contains the specified
            % class id.
            if isempty(app.ClassIdEdit.Value)
                app.ClassIdList.Items=unique(app.data(app.data.class~="",:).class);
            else
                app.ClassIdList.Items=unique(app.data.class(table2array(varfun(@(x) and(x~="",contains(x,upper(app.ClassIdEdit.Value))),app.data,'InputVariables','class'))));
            end


        end

        % Value changed function: SecurityEdit
        function SecurityEditValueChanged(app, event)
%             This is for specify the certain securities to check.
%             The result will only show securities that contains the
%             specified names of issuers.
            if isempty(app.SecurityEdit.Value)
                app.IssuerList.Items=unique(app.data(app.data.nameOfIssuer~="",:).nameOfIssuer);
            else
                app.IssuerList.Items=unique(app.data.nameOfIssuer(table2array(varfun(@(x) and(x~="",contains(x,upper(app.SecurityEdit.Value))),app.data,'InputVariables','nameOfIssuer'))));
            end

            
        end

        % Value changed function: ShowSecurity
        function ShowSecurityValueChanged(app, event)
%             When the button is pressed down, reveal the unique names of issuers from the selected forms.
            if app.ShowSecurity.Value==true
                if isempty(app.SecurityEdit.Value)
                    app.IssuerList.Items=unique(app.data(app.data.nameOfIssuer~="",:).nameOfIssuer);
                else
                    app.IssuerList.Items=unique(app.data.nameOfIssuer(table2array(varfun(@(x) and(x~="",contains(x,upper(app.SecurityEdit.Value))),app.data,'InputVariables','nameOfIssuer'))));
                end
                app.IssuerList.Visible='On';
            else
                app.IssuerList.Value={};
                app.IssuerList.Visible='Off';
            end
        end

        % Value changed function: ShowClassId
        function ShowClassIdValueChanged(app, event)
%             When the button is pressed down, reveal the unique class id from the selceted form.
            
            if app.ShowClassId.Value==true
                if isempty(app.ClassIdEdit.Value)
                    app.ClassIdList.Items=unique(app.data(app.data.class~="",:).class);
                else
                    app.ClassIdList.Items=unique(app.data.class(table2array(varfun(@(x) and(x~="",contains(x,upper(app.ClassIdEdit.Value))),app.data,'InputVariables','class'))));
                end
                app.ClassIdList.Visible='On';
            else
                app.ClassIdList.Value={};
                app.ClassIdList.Visible='Off';
            end
        end

        % Button pushed function: Visualization
        function VisualizationPushed(app, event)
%             Go to the visualization page. The check section will show
%             available numeric items for graphs. The color section can
%             assign color to the selected item with the right click
%             context menu. There're also options for groupby, plotting and
%             integration.
            app.TabGroup.SelectedTab = app.VisualizationTab;
            amend = app.data(app.data.submissionType=="N-MFP2/A",:);
            app.visualData=app.data;
            app.visualData(app.visualData.submissionType=="N-MFP2"&ismember(app.visualData(:,{'reportDate','seriesId'}),unique(amend(:,{'reportDate','seriesId'}))),:)=[];
            app.visualData=sortrows(unique(app.visualData(:,2:end)));
            app.colors=table();
            visualCol = {'series:averagePortfolioMaturity','series:averageLifeMaturity','series:totalValueDailyLiquidAssets', ...
                'series:totalValueWeeklyLiquidAssets','series:percentageDailyLiquidAssets','series:percentageWeeklyLiquidAssets', ...
                'series:cash','series:totalValuePortfolioSecurities','series:amortizedCostPortfolioSecurities',...
                'series:totalValueOtherAssets','series:totalValueLiabilities','series:netAssetOfSeries',...
                'series:numberOfSharesOutstanding','series:stablePricePerShare','series:sevenDayGrossYield','series:netAssetValue',...
                'class:minInitialInvestment','class:netAssetsOfClass','class:numberOfSharesOutstanding',...
                'class:netAssetPerShare','class:weeklyGrossSubscriptions','class:weeklyGrossRedemptions',...
                'class:totalForTheMonthReported_weeklyGrossSubscriptions','class:totalForTheMonthReported_weeklyGrossRedemptions',...
                'class:sevenDayNetYield','security:yieldOfTheSecurityAsOfReportingDate','security:includingValueOfAnySponsorSupport',...
                'security:excludingValueOfAnySponsorSupport','security:percentageOfMoneyMarketFundNetAssets'};
            app.ItemList.Items=visualCol(cellfun(@(x)any(startsWith(app.visualData.Properties.VariableNames,x)),visualCol));
            app.preview("item");
        end

        % Value changed function: ItemList
        function ItemListValueChanged(app, event)
            % To check series/class/security data, the left group by option
            % will be changed accordingly. The data will also be changed. 
            % When select asset data on Fridays, the columns end with
            % friday1/2/3/4/5 will be automatically change to the specific
            % date for plotting with the fridayData function.
            % The transformed data can be viewed under the data tab.
            app.preview("item");
        
        end

        % Menu selected function: SetColor
        function SetColorSelected(app, event)
            % When select an item, and right click to choose the color,
            % user can customize the color of the line.
            app.preview("color");


        end

        % Selection changed function: PlottingSetting
        function PlottingSettingSelectionChanged(app, event)
            % Choose between line and bar plot.         
            app.preview("option");
        end

        % Selection changed function: GrouppingSetting
        function GrouppingSettingSelectionChanged(app, event)
            % choose to see sum or individual data plot.
            app.preview("option");
        end

        % Selection changed function: GroupBySetting
        function GroupBySettingSelectionChanged(app, event)
            % Choose to show graph groupby registrant or
            % series/class/serucity.
            app.preview("groupby");
        end

        % Selection changed function: LegendSetting
        function LegendSettingSelectionChanged(app, event)
            app.preview("option");
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [400 160 655 530];
            app.UIFigure.Name = 'MATLAB App';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [1 0 654 531];

            % Create LoginTab
            app.LoginTab = uitab(app.TabGroup);
            app.LoginTab.Title = 'Login';
            app.LoginTab.BackgroundColor = [1 1 1];

            % Create Image
            app.Image = uiimage(app.LoginTab);
            app.Image.Position = [110 270 435 160];
            app.Image.ImageSource = 'MassAnalitycs-logo-home-1.png';

            % Create EmailEdit
            app.EmailEdit = uieditfield(app.LoginTab, 'text');
            app.EmailEdit.HorizontalAlignment = 'center';
            app.EmailEdit.FontSize = 14;
            app.EmailEdit.Position = [217 175 221 30];

            % Create EmailLabel
            app.EmailLabel = uilabel(app.LoginTab);
            app.EmailLabel.BackgroundColor = [1 1 1];
            app.EmailLabel.HorizontalAlignment = 'center';
            app.EmailLabel.FontSize = 16;
            app.EmailLabel.FontWeight = 'bold';
            app.EmailLabel.Position = [287 215 81 28];
            app.EmailLabel.Text = 'Email';

            % Create Enter
            app.Enter = uibutton(app.LoginTab, 'push');
            app.Enter.ButtonPushedFcn = createCallbackFcn(app, @EnterPushed, true);
            app.Enter.FontSize = 14;
            app.Enter.Position = [287 108 81 28];
            app.Enter.Text = 'Enter';

            % Create CheckEmail
            app.CheckEmail = uilabel(app.LoginTab);
            app.CheckEmail.HorizontalAlignment = 'center';
            app.CheckEmail.FontSize = 14;
            app.CheckEmail.Visible = 'off';
            app.CheckEmail.Position = [215 65 225 28];
            app.CheckEmail.Text = 'Please enter a valid email address!';

            % Create UpdateTab
            app.UpdateTab = uitab(app.TabGroup);
            app.UpdateTab.Title = 'Update';
            app.UpdateTab.BackgroundColor = [1 1 1];

            % Create SearchSECDatabaseUpdatePage
            app.SearchSECDatabaseUpdatePage = uilabel(app.UpdateTab);
            app.SearchSECDatabaseUpdatePage.FontSize = 14;
            app.SearchSECDatabaseUpdatePage.FontWeight = 'bold';
            app.SearchSECDatabaseUpdatePage.FontColor = [0 0.5098 0.4];
            app.SearchSECDatabaseUpdatePage.Position = [18 466 152 22];
            app.SearchSECDatabaseUpdatePage.Text = 'Search SEC Database';

            % Create Browse
            app.Browse = uibutton(app.UpdateTab, 'push');
            app.Browse.ButtonPushedFcn = createCallbackFcn(app, @BrowsePushed, true);
            app.Browse.FontSize = 14;
            app.Browse.Position = [478 385 75 30];
            app.Browse.Text = 'Browse';

            % Create UserEmailUpdatePage
            app.UserEmailUpdatePage = uilabel(app.UpdateTab);
            app.UserEmailUpdatePage.Position = [191 465 208 23];
            app.UserEmailUpdatePage.Text = '';

            % Create Directory
            app.Directory = uilabel(app.UpdateTab);
            app.Directory.HorizontalAlignment = 'right';
            app.Directory.FontSize = 14;
            app.Directory.Position = [112 385 75 30];
            app.Directory.Text = 'Directory';

            % Create CheckUpdates
            app.CheckUpdates = uibutton(app.UpdateTab, 'push');
            app.CheckUpdates.ButtonPushedFcn = createCallbackFcn(app, @CheckUpdatesPushed, true);
            app.CheckUpdates.FontSize = 14;
            app.CheckUpdates.Position = [225 280 205 50];
            app.CheckUpdates.Text = 'Check MMF List Updates';

            % Create DownloadInfo
            app.DownloadInfo = uilabel(app.UpdateTab);
            app.DownloadInfo.HorizontalAlignment = 'center';
            app.DownloadInfo.Visible = 'off';
            app.DownloadInfo.Position = [147 97 357 63];
            app.DownloadInfo.Text = 'MMF list file status';

            % Create Download
            app.Download = uibutton(app.UpdateTab, 'state');
            app.Download.ValueChangedFcn = createCallbackFcn(app, @DownloadValueChanged, true);
            app.Download.Visible = 'off';
            app.Download.Text = 'Download';
            app.Download.FontSize = 14;
            app.Download.Position = [225 206 205 50];

            % Create Next
            app.Next = uibutton(app.UpdateTab, 'push');
            app.Next.ButtonPushedFcn = createCallbackFcn(app, @NextPushed, true);
            app.Next.FontSize = 14;
            app.Next.Visible = 'off';
            app.Next.Position = [225 50 205 50];
            app.Next.Text = 'Next';

            % Create ProgressBarBackground
            app.ProgressBarBackground = uilabel(app.UpdateTab);
            app.ProgressBarBackground.BackgroundColor = [0.6824 0.8745 0.851];
            app.ProgressBarBackground.Visible = 'off';
            app.ProgressBarBackground.Position = [145 145 369 29];
            app.ProgressBarBackground.Text = '';

            % Create ProgressBar
            app.ProgressBar = uilabel(app.UpdateTab);
            app.ProgressBar.BackgroundColor = [0.9294 0.6902 0.1294];
            app.ProgressBar.Visible = 'off';
            app.ProgressBar.Position = [145 145 0 29];
            app.ProgressBar.Text = '';

            % Create Percentage
            app.Percentage = uilabel(app.UpdateTab);
            app.Percentage.Visible = 'off';
            app.Percentage.Position = [152 145 35 29];
            app.Percentage.Text = '0%';

            % Create DirEdit
            app.DirEdit = uieditfield(app.UpdateTab, 'text');
            app.DirEdit.ValueChangedFcn = createCallbackFcn(app, @DirEditValueChanged, true);
            app.DirEdit.Position = [197 385 271 30];

            % Create CheckDir
            app.CheckDir = uilabel(app.UpdateTab);
            app.CheckDir.HorizontalAlignment = 'right';
            app.CheckDir.FontSize = 14;
            app.CheckDir.Visible = 'off';
            app.CheckDir.Position = [225 353 205 22];
            app.CheckDir.Text = 'Please choose a valid directory.';

            % Create FilterTab
            app.FilterTab = uitab(app.TabGroup);
            app.FilterTab.Title = 'Filter';
            app.FilterTab.BackgroundColor = [1 1 1];

            % Create SearchSECDatabaseFilterPage
            app.SearchSECDatabaseFilterPage = uilabel(app.FilterTab);
            app.SearchSECDatabaseFilterPage.FontSize = 14;
            app.SearchSECDatabaseFilterPage.FontWeight = 'bold';
            app.SearchSECDatabaseFilterPage.FontColor = [0 0.5098 0.4];
            app.SearchSECDatabaseFilterPage.Position = [18 466 152 22];
            app.SearchSECDatabaseFilterPage.Text = 'Search SEC Database';

            % Create Panel
            app.Panel = uipanel(app.FilterTab);
            app.Panel.Position = [17 16 621 430];

            % Create MMFListTable
            app.MMFListTable = uitable(app.Panel);
            app.MMFListTable.ColumnName = {'reporting_period'; 'registrant_cik'; 'registrant_name'; 'series_name'; 'series_id'; 'series_category_name'; 'class_name'; 'class_id'; 'class_ticker_symb'; 'investment_advisor'; 'sub_advisor'};
            app.MMFListTable.RowName = {};
            app.MMFListTable.Position = [152 0 468 408];

            % Create ReportingPeriod
            app.ReportingPeriod = uilistbox(app.Panel);
            app.ReportingPeriod.Items = {};
            app.ReportingPeriod.Multiselect = 'on';
            app.ReportingPeriod.ValueChangedFcn = createCallbackFcn(app, @ReportingPeriodValueChanged, true);
            app.ReportingPeriod.Position = [0 0 154 380];
            app.ReportingPeriod.Value = {};

            % Create RegistrantName
            app.RegistrantName = uilistbox(app.Panel);
            app.RegistrantName.Items = {};
            app.RegistrantName.Multiselect = 'on';
            app.RegistrantName.ValueChangedFcn = createCallbackFcn(app, @RegistrantNameValueChanged, true);
            app.RegistrantName.Position = [0 0 154 380];
            app.RegistrantName.Value = {};

            % Create SeriesName
            app.SeriesName = uilistbox(app.Panel);
            app.SeriesName.Items = {};
            app.SeriesName.Multiselect = 'on';
            app.SeriesName.ValueChangedFcn = createCallbackFcn(app, @SeriesNameValueChanged, true);
            app.SeriesName.Position = [0 0 154 380];
            app.SeriesName.Value = {};

            % Create SeriesCategoryName
            app.SeriesCategoryName = uilistbox(app.Panel);
            app.SeriesCategoryName.Items = {};
            app.SeriesCategoryName.Multiselect = 'on';
            app.SeriesCategoryName.ValueChangedFcn = createCallbackFcn(app, @SeriesCategoryNameValueChanged, true);
            app.SeriesCategoryName.Position = [0 0 154 380];
            app.SeriesCategoryName.Value = {};

            % Create ClassName
            app.ClassName = uilistbox(app.Panel);
            app.ClassName.Items = {};
            app.ClassName.Multiselect = 'on';
            app.ClassName.ValueChangedFcn = createCallbackFcn(app, @ClassNameValueChanged, true);
            app.ClassName.Position = [0 0 154 380];
            app.ClassName.Value = {};

            % Create SelectAll
            app.SelectAll = uibutton(app.Panel, 'push');
            app.SelectAll.ButtonPushedFcn = createCallbackFcn(app, @SelectAllPushed, true);
            app.SelectAll.Position = [153 406 234 23];
            app.SelectAll.Text = 'Select All';

            % Create Filters
            app.Filters = uidropdown(app.Panel);
            app.Filters.Items = {'reporting_period', 'registrant_name', 'series_name', 'series_category_name', 'class_name'};
            app.Filters.ValueChangedFcn = createCallbackFcn(app, @FiltersValueChanged, true);
            app.Filters.Position = [0 380 153 49];
            app.Filters.Value = 'reporting_period';

            % Create ClearFilters
            app.ClearFilters = uibutton(app.Panel, 'push');
            app.ClearFilters.ButtonPushedFcn = createCallbackFcn(app, @ClearFiltersPushed, true);
            app.ClearFilters.Position = [386 406 234 23];
            app.ClearFilters.Text = 'Clear Filters';

            % Create UserEmailFilterPage
            app.UserEmailFilterPage = uilabel(app.FilterTab);
            app.UserEmailFilterPage.Position = [191 465 208 23];
            app.UserEmailFilterPage.Text = '';

            % Create GetData
            app.GetData = uibutton(app.FilterTab, 'push');
            app.GetData.ButtonPushedFcn = createCallbackFcn(app, @GetDataPushed, true);
            app.GetData.IconAlignment = 'center';
            app.GetData.BackgroundColor = [0 0.5098 0.4];
            app.GetData.FontSize = 14;
            app.GetData.FontColor = [1 1 1];
            app.GetData.Position = [505 459 134 34];
            app.GetData.Text = 'Get Data';

            % Create DownloadTab
            app.DownloadTab = uitab(app.TabGroup);
            app.DownloadTab.Title = 'Download';
            app.DownloadTab.BackgroundColor = [1 1 1];

            % Create SearchSECDatabaseDownloadPage
            app.SearchSECDatabaseDownloadPage = uilabel(app.DownloadTab);
            app.SearchSECDatabaseDownloadPage.FontSize = 14;
            app.SearchSECDatabaseDownloadPage.FontWeight = 'bold';
            app.SearchSECDatabaseDownloadPage.FontColor = [0 0.5098 0.4];
            app.SearchSECDatabaseDownloadPage.Position = [18 466 152 22];
            app.SearchSECDatabaseDownloadPage.Text = 'Search SEC Database';

            % Create SelectedInfoPanel
            app.SelectedInfoPanel = uitextarea(app.DownloadTab);
            app.SelectedInfoPanel.FontSize = 13;
            app.SelectedInfoPanel.Position = [17 16 153 430];
            app.SelectedInfoPanel.Value = {''; ''; 'Registrant: …'; 'N-MFP2(/A):'; ''; ''};

            % Create DownloadFilterPanel
            app.DownloadFilterPanel = uitextarea(app.DownloadTab);
            app.DownloadFilterPanel.Position = [170 166 468 280];

            % Create DownloadPanel
            app.DownloadPanel = uitextarea(app.DownloadTab);
            app.DownloadPanel.Position = [170 16 468 150];

            % Create NMFP2
            app.NMFP2 = uilabel(app.DownloadTab);
            app.NMFP2.FontSize = 17;
            app.NMFP2.FontWeight = 'bold';
            app.NMFP2.Position = [200 408 71 23];
            app.NMFP2.Text = 'N-MFP2';

            % Create Sections
            app.Sections = uitree(app.DownloadTab, 'checkbox');
            app.Sections.Position = [199 243 179 158];

            % Create SelectAllNode
            app.SelectAllNode = uitreenode(app.Sections);
            app.SelectAllNode.Text = 'Select All';

            % Create GeneralInfoNode
            app.GeneralInfoNode = uitreenode(app.SelectAllNode);
            app.GeneralInfoNode.Text = 'General Info';

            % Create SeriesInfoNode
            app.SeriesInfoNode = uitreenode(app.SelectAllNode);
            app.SeriesInfoNode.Text = 'Series Info';

            % Create SignatureInfoNode
            app.SignatureInfoNode = uitreenode(app.SelectAllNode);
            app.SignatureInfoNode.Text = 'Signature Info';

            % Create ClassInfoNode
            app.ClassInfoNode = uitreenode(app.SelectAllNode);
            app.ClassInfoNode.Text = 'Class Info';

            % Create SecurityInfoNode
            app.SecurityInfoNode = uitreenode(app.SelectAllNode);
            app.SecurityInfoNode.Text = 'Security Info';

            % Create Directory_2
            app.Directory_2 = uilabel(app.DownloadTab);
            app.Directory_2.HorizontalAlignment = 'right';
            app.Directory_2.FontSize = 17;
            app.Directory_2.Position = [178 106 74 30];
            app.Directory_2.Text = 'Directory';

            % Create SelectedFunds
            app.SelectedFunds = uilabel(app.DownloadTab);
            app.SelectedFunds.FontSize = 14;
            app.SelectedFunds.FontWeight = 'bold';
            app.SelectedFunds.Position = [22 416 145 22];
            app.SelectedFunds.Text = 'Selected funds';

            % Create Browse_2
            app.Browse_2 = uibutton(app.DownloadTab, 'push');
            app.Browse_2.ButtonPushedFcn = createCallbackFcn(app, @Browse_2Pushed, true);
            app.Browse_2.BackgroundColor = [1 1 1];
            app.Browse_2.FontColor = [0.149 0.149 0.149];
            app.Browse_2.Position = [261 66 69 22];
            app.Browse_2.Text = 'Browse';

            % Create Download_2
            app.Download_2 = uibutton(app.DownloadTab, 'push');
            app.Download_2.ButtonPushedFcn = createCallbackFcn(app, @Download_2Pushed, true);
            app.Download_2.BackgroundColor = [1 1 1];
            app.Download_2.FontColor = [0.149 0.149 0.149];
            app.Download_2.Position = [378 66 70 22];
            app.Download_2.Text = 'Download';

            % Create Preview
            app.Preview = uibutton(app.DownloadTab, 'push');
            app.Preview.ButtonPushedFcn = createCallbackFcn(app, @PreviewPushed, true);
            app.Preview.BackgroundColor = [1 1 1];
            app.Preview.FontColor = [0.149 0.149 0.149];
            app.Preview.Position = [495 66 70 22];
            app.Preview.Text = 'Preview';

            % Create DownloadDirFrame
            app.DownloadDirFrame = uilabel(app.DownloadTab);
            app.DownloadDirFrame.BackgroundColor = [0 0.5098 0.4];
            app.DownloadDirFrame.FontColor = [0.149 0.149 0.149];
            app.DownloadDirFrame.Position = [257 106 308 30];
            app.DownloadDirFrame.Text = '';

            % Create DownloadDir
            app.DownloadDir = uilabel(app.DownloadTab);
            app.DownloadDir.BackgroundColor = [1 1 1];
            app.DownloadDir.FontColor = [0.149 0.149 0.149];
            app.DownloadDir.Position = [262 109 299 25];
            app.DownloadDir.Text = '';

            % Create DownloadInfo_2
            app.DownloadInfo_2 = uilabel(app.DownloadTab);
            app.DownloadInfo_2.HorizontalAlignment = 'center';
            app.DownloadInfo_2.FontSize = 11;
            app.DownloadInfo_2.Visible = 'off';
            app.DownloadInfo_2.Position = [363 40 100 22];
            app.DownloadInfo_2.Text = 'Download finished.';

            % Create UserEmailResultsPage
            app.UserEmailResultsPage = uilabel(app.DownloadTab);
            app.UserEmailResultsPage.Position = [191 465 208 23];
            app.UserEmailResultsPage.Text = '';

            % Create ClassIdList
            app.ClassIdList = uilistbox(app.DownloadTab);
            app.ClassIdList.Items = {};
            app.ClassIdList.Multiselect = 'on';
            app.ClassIdList.Visible = 'off';
            app.ClassIdList.Position = [425 316 146 67];
            app.ClassIdList.Value = {};

            % Create ClassId
            app.ClassId = uilabel(app.DownloadTab);
            app.ClassId.Position = [426 408 49 22];
            app.ClassId.Text = 'Class Id';

            % Create ClassIdEdit
            app.ClassIdEdit = uieditfield(app.DownloadTab, 'text');
            app.ClassIdEdit.ValueChangedFcn = createCallbackFcn(app, @ClassIdEditValueChanged, true);
            app.ClassIdEdit.Position = [425 383 146 22];

            % Create ShowClassId
            app.ShowClassId = uibutton(app.DownloadTab, 'state');
            app.ShowClassId.ValueChangedFcn = createCallbackFcn(app, @ShowClassIdValueChanged, true);
            app.ShowClassId.Text = '';
            app.ShowClassId.Position = [571 383 38 22];

            % Create IssuerList
            app.IssuerList = uilistbox(app.DownloadTab);
            app.IssuerList.Items = {};
            app.IssuerList.Multiselect = 'on';
            app.IssuerList.Visible = 'off';
            app.IssuerList.Position = [425 194 146 67];
            app.IssuerList.Value = {};

            % Create NameOfSecurityIssuer
            app.NameOfSecurityIssuer = uilabel(app.DownloadTab);
            app.NameOfSecurityIssuer.Position = [425 286 134 22];
            app.NameOfSecurityIssuer.Text = 'Name of Security Issuer';

            % Create SecurityEdit
            app.SecurityEdit = uieditfield(app.DownloadTab, 'text');
            app.SecurityEdit.ValueChangedFcn = createCallbackFcn(app, @SecurityEditValueChanged, true);
            app.SecurityEdit.Position = [425 261 146 22];

            % Create ShowSecurity
            app.ShowSecurity = uibutton(app.DownloadTab, 'state');
            app.ShowSecurity.ValueChangedFcn = createCallbackFcn(app, @ShowSecurityValueChanged, true);
            app.ShowSecurity.Text = '';
            app.ShowSecurity.Position = [571 261 38 22];

            % Create RepurchaseAgreement
            app.RepurchaseAgreement = uicheckbox(app.DownloadTab);
            app.RepurchaseAgreement.Text = ' Repurchase Agreement';
            app.RepurchaseAgreement.Position = [199 204 179 23];

            % Create PreviewTab
            app.PreviewTab = uitab(app.TabGroup);
            app.PreviewTab.Title = 'Preview';
            app.PreviewTab.BackgroundColor = [1 1 1];

            % Create SearchSECDatabasePreviewPage
            app.SearchSECDatabasePreviewPage = uilabel(app.PreviewTab);
            app.SearchSECDatabasePreviewPage.FontSize = 14;
            app.SearchSECDatabasePreviewPage.FontWeight = 'bold';
            app.SearchSECDatabasePreviewPage.FontColor = [0 0.5098 0.4];
            app.SearchSECDatabasePreviewPage.Position = [18 466 152 22];
            app.SearchSECDatabasePreviewPage.Text = 'Search SEC Database';

            % Create PreviewTable
            app.PreviewTable = uitable(app.PreviewTab);
            app.PreviewTable.ColumnName = '';
            app.PreviewTable.RowName = {};
            app.PreviewTable.Position = [17 16 621 430];

            % Create Visualization
            app.Visualization = uibutton(app.PreviewTab, 'push');
            app.Visualization.ButtonPushedFcn = createCallbackFcn(app, @VisualizationPushed, true);
            app.Visualization.BackgroundColor = [0 0.5098 0.4];
            app.Visualization.FontSize = 14;
            app.Visualization.FontColor = [1 1 1];
            app.Visualization.Position = [505 459 134 34];
            app.Visualization.Text = 'Visualization';

            % Create UserEmailPreviewPage
            app.UserEmailPreviewPage = uilabel(app.PreviewTab);
            app.UserEmailPreviewPage.Position = [191 465 208 23];
            app.UserEmailPreviewPage.Text = '';

            % Create VisualizationTab
            app.VisualizationTab = uitab(app.TabGroup);
            app.VisualizationTab.Title = 'Visualization';
            app.VisualizationTab.BackgroundColor = [1 1 1];

            % Create SearchSECDatabaseVisualizationPage
            app.SearchSECDatabaseVisualizationPage = uilabel(app.VisualizationTab);
            app.SearchSECDatabaseVisualizationPage.FontSize = 14;
            app.SearchSECDatabaseVisualizationPage.FontWeight = 'bold';
            app.SearchSECDatabaseVisualizationPage.FontColor = [0 0.5098 0.4];
            app.SearchSECDatabaseVisualizationPage.Position = [18 466 152 22];
            app.SearchSECDatabaseVisualizationPage.Text = 'Search SEC Database';

            % Create UserEmailVisualizationPage
            app.UserEmailVisualizationPage = uilabel(app.VisualizationTab);
            app.UserEmailVisualizationPage.Position = [191 465 208 23];
            app.UserEmailVisualizationPage.Text = '';

            % Create TabGroup_2
            app.TabGroup_2 = uitabgroup(app.VisualizationTab);
            app.TabGroup_2.Position = [227 16 411 430];

            % Create PlotTab
            app.PlotTab = uitab(app.TabGroup_2);
            app.PlotTab.Title = 'Plot';

            % Create UIAxes
            app.UIAxes = uiaxes(app.PlotTab);
            title(app.UIAxes, 'Title')
            xlabel(app.UIAxes, 'X')
            ylabel(app.UIAxes, 'Y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Position = [1 35 406 340];

            % Create DataTab
            app.DataTab = uitab(app.TabGroup_2);
            app.DataTab.Title = 'Data';

            % Create VisualizationData
            app.VisualizationData = uitable(app.DataTab);
            app.VisualizationData.ColumnName = {'Last Name'; 'Gender'; 'Smoker'; 'Age'; 'Height'; 'Weight'; 'Diastolic'; 'Systolic'; 'Location'};
            app.VisualizationData.RowName = {};
            app.VisualizationData.ColumnSortable = true;
            app.VisualizationData.RowStriping = 'off';
            app.VisualizationData.Position = [1 43 406 358];

            % Create GraphSettings
            app.GraphSettings = uipanel(app.VisualizationTab);
            app.GraphSettings.Position = [17 16 210 430];

            % Create PlottingSetting
            app.PlottingSetting = uibuttongroup(app.GraphSettings);
            app.PlottingSetting.AutoResizeChildren = 'off';
            app.PlottingSetting.SelectionChangedFcn = createCallbackFcn(app, @PlottingSettingSelectionChanged, true);
            app.PlottingSetting.Title = 'Plotting';
            app.PlottingSetting.Position = [106 1 105 76];

            % Create Line
            app.Line = uiradiobutton(app.PlottingSetting);
            app.Line.Text = 'Line';
            app.Line.Position = [12 29 103 22];
            app.Line.Value = true;

            % Create Bar
            app.Bar = uiradiobutton(app.PlottingSetting);
            app.Bar.Text = 'Bar';
            app.Bar.Position = [13 8 103 22];

            % Create ColorsSetting
            app.ColorsSetting = uipanel(app.GraphSettings);
            app.ColorsSetting.Title = 'Colors';
            app.ColorsSetting.Position = [1 153 210 130];

            % Create Targets
            app.Targets = uilistbox(app.ColorsSetting);
            app.Targets.Position = [3 3 204 105];

            % Create CheckingItemSetting
            app.CheckingItemSetting = uipanel(app.GraphSettings);
            app.CheckingItemSetting.Title = 'Check';
            app.CheckingItemSetting.Position = [1 282 210 147];

            % Create ItemList
            app.ItemList = uilistbox(app.CheckingItemSetting);
            app.ItemList.ValueChangedFcn = createCallbackFcn(app, @ItemListValueChanged, true);
            app.ItemList.Position = [3 3 204 122];

            % Create GrouppingSetting
            app.GrouppingSetting = uibuttongroup(app.GraphSettings);
            app.GrouppingSetting.AutoResizeChildren = 'off';
            app.GrouppingSetting.SelectionChangedFcn = createCallbackFcn(app, @GrouppingSettingSelectionChanged, true);
            app.GrouppingSetting.Title = 'Grouping';
            app.GrouppingSetting.Position = [1 0 105 76];

            % Create Individual
            app.Individual = uiradiobutton(app.GrouppingSetting);
            app.Individual.Text = 'Individual';
            app.Individual.Position = [12 29 103 22];
            app.Individual.Value = true;

            % Create Sum
            app.Sum = uiradiobutton(app.GrouppingSetting);
            app.Sum.Text = 'Sum';
            app.Sum.Position = [12 8 103 22];

            % Create GroupBySetting
            app.GroupBySetting = uibuttongroup(app.GraphSettings);
            app.GroupBySetting.SelectionChangedFcn = createCallbackFcn(app, @GroupBySettingSelectionChanged, true);
            app.GroupBySetting.Title = 'Group By';
            app.GroupBySetting.Position = [1 77 105 76];

            % Create Registrant
            app.Registrant = uiradiobutton(app.GroupBySetting);
            app.Registrant.Text = 'Registrant';
            app.Registrant.Position = [13 27 77 22];
            app.Registrant.Value = true;

            % Create Section
            app.Section = uiradiobutton(app.GroupBySetting);
            app.Section.Text = 'Button3';
            app.Section.Position = [13 7 65 22];

            % Create LegendSetting
            app.LegendSetting = uibuttongroup(app.GraphSettings);
            app.LegendSetting.AutoResizeChildren = 'off';
            app.LegendSetting.SelectionChangedFcn = createCallbackFcn(app, @LegendSettingSelectionChanged, true);
            app.LegendSetting.Title = 'Legend';
            app.LegendSetting.Position = [106 77 105 76];

            % Create Show
            app.Show = uiradiobutton(app.LegendSetting);
            app.Show.Text = 'Show';
            app.Show.Position = [12 29 103 22];
            app.Show.Value = true;

            % Create Hide
            app.Hide = uiradiobutton(app.LegendSetting);
            app.Hide.Text = 'Hide';
            app.Hide.Position = [13 8 103 22];

            % Create ContextMenu
            app.ContextMenu = uicontextmenu(app.UIFigure);

            % Create SetColor
            app.SetColor = uimenu(app.ContextMenu);
            app.SetColor.MenuSelectedFcn = createCallbackFcn(app, @SetColorSelected, true);
            app.SetColor.Text = 'Color';
            
            % Assign app.ContextMenu
            app.Targets.ContextMenu = app.ContextMenu;

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = MassAnalytics_A7_April_19_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end