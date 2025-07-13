classdef ApplyBC_2D < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        FileMenu                       matlab.ui.container.Menu
        ImportMenu                     matlab.ui.container.Menu
        TriangularMesh2DmshMenu        matlab.ui.container.Menu
        ExportMenu                     matlab.ui.container.Menu
        FEModelMiniFEMMenu             matlab.ui.container.Menu
        VisualizationMenu              matlab.ui.container.Menu
        ShowFEMModelMenu               matlab.ui.container.Menu
        DOFsEditField                  matlab.ui.control.NumericEditField
        DOFsEditFieldLabel             matlab.ui.control.Label
        VerticesEditField              matlab.ui.control.NumericEditField
        VerticesEditFieldLabel         matlab.ui.control.Label
        ElementsEditField              matlab.ui.control.NumericEditField
        ElementsEditFieldLabel         matlab.ui.control.Label
        ApplyforBoundaryConditionsPanel  matlab.ui.container.Panel
        TabGroupSelection              matlab.ui.container.TabGroup
        BoxSelectionTab                matlab.ui.container.Tab
        CornerPot2YEditField           matlab.ui.control.NumericEditField
        CornerPot2YEditFieldLabel      matlab.ui.control.Label
        CornerPot1YEditField           matlab.ui.control.NumericEditField
        CornerPot1YEditFieldLabel      matlab.ui.control.Label
        CornerPot2XEditField           matlab.ui.control.NumericEditField
        CornerPot2XEditFieldLabel      matlab.ui.control.Label
        CornerPot1XEditField           matlab.ui.control.NumericEditField
        CornerPot1XEditFieldLabel      matlab.ui.control.Label
        SphereSelectionTab             matlab.ui.container.Tab
        RadiusEditField                matlab.ui.control.NumericEditField
        RadiusEditFieldLabel           matlab.ui.control.Label
        CenterYEditField               matlab.ui.control.NumericEditField
        CenterYEditFieldLabel          matlab.ui.control.Label
        CenterXEditField               matlab.ui.control.NumericEditField
        CenterXEditFieldLabel          matlab.ui.control.Label
        SelectionOptionsDropDown       matlab.ui.control.DropDown
        SelectionOptionsDropDownLabel  matlab.ui.control.Label
        TabGroup2                      matlab.ui.container.TabGroup
        FixingTab                      matlab.ui.container.Tab
        XDirFixedCheckBox              matlab.ui.control.CheckBox
        YDirFixedCheckBox              matlab.ui.control.CheckBox
        ClearFixationButton            matlab.ui.control.Button
        ApplyforFixationButton         matlab.ui.control.Button
        LoadingTab                     matlab.ui.container.Tab
        FyNEditField                   matlab.ui.control.NumericEditField
        FyNEditFieldLabel              matlab.ui.control.Label
        ClearLoadsButton               matlab.ui.control.Button
        ApplyforLoadsButton            matlab.ui.control.Button
        FxNEditField                   matlab.ui.control.NumericEditField
        FxNEditFieldLabel              matlab.ui.control.Label
        NodeSelectionButton            matlab.ui.control.Button
        NodeUnSelectionButton          matlab.ui.control.Button
    end

    
    properties (Access = private)
        %%app_LinearSystemSolver_settings % Reference to LSS settings
        %%app_Optimizer_settings % Reference to Optimizer settings
        %%app_MaterialProperties_settings % Reference to Material Property settings
    end
    
    methods (Access = public)
        

        function SetupSelectionOptions_Public(app)
            global boundingBox_;
            app.CornerPot1XEditField.Value = boundingBox_(1,1); 
            app.CornerPot1YEditField.Value = boundingBox_(1,2); 
            app.CornerPot2XEditField.Value = boundingBox_(2,1); 
            app.CornerPot2YEditField.Value = boundingBox_(2,2); 
            
            app.CenterXEditField.Value = boundingBox_(2,1);
            app.CenterYEditField.Value = boundingBox_(2,2);
            app.RadiusEditField.Value = max(boundingBox_(2,:)-boundingBox_(1,:))/50;
        end             

        function InitializeAppParameters(app)
            app.ElementsEditField.Value = 0;
            app.VerticesEditField.Value = 0;
            app.DOFsEditField.Value = 0;
            app.FxNEditField.Value = 0;
            app.FyNEditField.Value = 0;
            app.XDirFixedCheckBox.Value = 1;
            app.YDirFixedCheckBox.Value = 1;
        end


    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app, mainapp)
            clc;
            global axHandle_;            
            addpath('./PreProcess/');
 
            %%Initialization
            Data_GlobalVariables;
            InitializeAppParameters(app);
            close all;
            figure; axHandle_ = gca; view(axHandle_,3);
            cla(axHandle_);
        end

        % Close request function: UIFigure
        function UIFigureCloseRequest(app, event)
            delete(app)            
        end

        % Menu selected function: TriangularMesh2DmshMenu
        function ImportTriangularMesh2DmshMenuSelected(app, event)
            global simMesh_;            
            global axHandle_;
            %%Reset App
            Data_GlobalVariables;
            InitializeAppParameters(app);  

            [fileName, dataPath] = uigetfile({'*.msh'}, 'Select a Tet-mesh File to Open');
            if isnumeric(fileName) || isnumeric(dataPath), return; end
            [~,~,fileExtension] = fileparts(fileName);
            if ~(strcmp(fileExtension, '.msh'))
                warning('Un-supported Mesh Format!');
                return;
            end
            inputVoxelfileName = strcat(dataPath,fileName);
            IO_ImportTriMesh2D(inputVoxelfileName);
            if ~isvalid(axHandle_), axHandle_ = gca; view(axHandle_,3); end
            cla(axHandle_);
            ShowFEMModelMenuSelected(app, event);
            app.ElementsEditField.Value = simMesh_.numElements;
            app.VerticesEditField.Value = simMesh_.numNodes;
            app.DOFsEditField.Value = 2*simMesh_.numNodes;
            SetupSelectionOptions_Public(app);
        end

        % Menu selected function: FEModelMiniFEMMenu
        function ExportDesigninVolumeniiMenuSelected(app, event)
            [fileName, dataPath] = uiputfile('*.MiniFEM', 'Select a Path to Write');
            if isnumeric(fileName) || isnumeric(dataPath), return; end
            ofileName = strcat(dataPath,fileName);
            IO_ExportFEModel2D_MiniFEM(ofileName);               
        end

        % Menu selected function: ShowFEMModelMenu
        function ShowFEMModelMenuSelected(app, event)
            global axHandle_;
            global simMesh_;
            global loadingCond_;
            global fixingCond_;
            if ~isvalid(axHandle_), axHandle_ = gca; view(axHandle_,3); end
            cla(axHandle_); colorbar(axHandle_, 'off');
            Vis_DrawMesh2D(axHandle_, simMesh_.nodeCoords, simMesh_.eNodMat, 0);
            Vis_ShowLoadingCondition2D(axHandle_, loadingCond_);
            Vis_ShowFixingCondition2D(axHandle_, fixingCond_);
            view(axHandle_, 2);
            axis(axHandle_, 'on'); xlabel('X'); ylabel('Y');            
        end

        % Value changed function: CenterXEditField, CenterYEditField, 
        % ...and 6 other components
        function SelectionOptionsDropDownValueChanged(app, event)
            global hdSelectionBox_;
            value = app.SelectionOptionsDropDown.Value;            
            switch value
                case 'None'
                    if isempty(hdSelectionBox_), return; end
                    if isvalid(hdSelectionBox_)
                        set(hdSelectionBox_, 'visible', 'off');
                    end
                case 'Box'
                    cP1 = zeros(1,3); cP2 = cP1;
                    cP1(1) = app.CornerPot1XEditField.Value; cP1(2) = app.CornerPot1YEditField.Value;
                    cP2(1) = app.CornerPot2XEditField.Value; cP2(2) = app.CornerPot2YEditField.Value;
                    Vis_ShowSelectionBox2D(cP1, cP2);
                case 'Sphere'
                    sphereRad = abs(app.RadiusEditField.Value);
                    if 0==sphereRad, return; end                    
                    sphereCtr = zeros(1,3);
                    sphereCtr(1) = app.CenterXEditField.Value;
                    sphereCtr(2) = app.CenterYEditField.Value;
                    Vis_ShowSelectionSphere2D(sphereCtr, sphereRad);
            end  
        end

        % Button pushed function: NodeSelectionButton
        function NodeSelectionButtonPushed(app, event)
            global axHandle_;
            SelectionOptionsDropDownValueChanged(app, event);
            value = app.SelectionOptionsDropDown.Value;
            switch value
                case 'Box'
                    cP1 = zeros(1,2); cP2 = cP1;
                    cP1(1) = app.CornerPot1XEditField.Value; cP1(2) = app.CornerPot1YEditField.Value;
                    cP2(1) = app.CornerPot2XEditField.Value; cP2(2) = app.CornerPot2YEditField.Value;           
                    Interaction_PickBySelectionBox2D(axHandle_, cP1, cP2);
                case 'Sphere'
                    sphereRad = abs(app.RadiusEditField.Value);
                    if 0==sphereRad, return; end                    
                    sphereCtr = zeros(1,2);
                    sphereCtr(1) = app.CenterXEditField.Value;
                    sphereCtr(2) = app.CenterYEditField.Value;
                    Interaction_PickBySelectionShpere2D(axHandle_, sphereCtr, sphereRad);                    
            end            
        end

        % Button pushed function: NodeUnSelectionButton
        function NodeUnSelectionButtonPushed(app, event)
            global axHandle_;
            SelectionOptionsDropDownValueChanged(app, event);
            value = app.SelectionOptionsDropDown.Value;
            switch value
                case 'Box'
                    cP1 = zeros(1,2); cP2 = cP1;
                    cP1(1) = app.CornerPot1XEditField.Value; cP1(2) = app.CornerPot1YEditField.Value;
                    cP2(1) = app.CornerPot2XEditField.Value; cP2(2) = app.CornerPot2YEditField.Value;            
                    Interaction_UnPickBySelectionBox2D(axHandle_, cP1, cP2);   
                case 'Sphere'
                    sphereRad = abs(app.RadiusEditField.Value);
                    if 0==sphereRad, return; end
                    sphereCtr = zeros(1,2);
                    sphereCtr(1) = app.CenterXEditField.Value;
                    sphereCtr(2) = app.CenterYEditField.Value;
                    Interaction_UnPickBySelectionShpere2D(axHandle_, sphereCtr, sphereRad);  
            end               
        end

        % Button pushed function: ApplyforFixationButton
        function ApplyforFixationButtonPushed(app, event)
            global axHandle_;         
            if ~(app.XDirFixedCheckBox.Value || app.YDirFixedCheckBox.Value), return; end
            fixingOpt = zeros(1,2);
            if app.XDirFixedCheckBox.Value, fixingOpt(1) = 1; end
            if app.YDirFixedCheckBox.Value, fixingOpt(2) = 1; end
            iFixingArr2Draw = FEA_Apply4Fixations2D(fixingOpt);
            if isempty(iFixingArr2Draw), return; end
            Interaction_ClearPickedNodes();
            Vis_ShowFixingCondition2D(axHandle_, iFixingArr2Draw);            
        end

        % Button pushed function: ClearFixationButton
        function ClearFixationButtonPushed(app, event)
            global fixingCond_; fixingCond_ = [];
            ShowFEMModelMenuSelected(app, event);            
        end

        % Button pushed function: ApplyforLoadsButton
        function ApplyforLoadsButtonPushed(app, event)
            global axHandle_;          
            if 0==app.FxNEditField.Value && 0==app.FyNEditField.Value, return; end
            forceVec = [app.FxNEditField.Value app.FyNEditField.Value];
            iLoadingVec2Draw = FEA_Apply4Loads2D(forceVec);
            if isempty(iLoadingVec2Draw), return; end
            Interaction_ClearPickedNodes();
            Vis_ShowLoadingCondition2D(axHandle_, iLoadingVec2Draw);            
        end

        % Button pushed function: ClearLoadsButton
        function ClearLoadsButtonPushed(app, event)
            global loadingCond_; loadingCond_ = [];       
            ShowFEMModelMenuSelected(app, event);            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 407 599];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);

            % Create FileMenu
            app.FileMenu = uimenu(app.UIFigure);
            app.FileMenu.Text = 'File';

            % Create ImportMenu
            app.ImportMenu = uimenu(app.FileMenu);
            app.ImportMenu.Text = 'Import';

            % Create TriangularMesh2DmshMenu
            app.TriangularMesh2DmshMenu = uimenu(app.ImportMenu);
            app.TriangularMesh2DmshMenu.MenuSelectedFcn = createCallbackFcn(app, @ImportTriangularMesh2DmshMenuSelected, true);
            app.TriangularMesh2DmshMenu.Text = 'Triangular Mesh 2D (*.msh)';

            % Create ExportMenu
            app.ExportMenu = uimenu(app.FileMenu);
            app.ExportMenu.Text = 'Export';

            % Create FEModelMiniFEMMenu
            app.FEModelMiniFEMMenu = uimenu(app.ExportMenu);
            app.FEModelMiniFEMMenu.MenuSelectedFcn = createCallbackFcn(app, @ExportDesigninVolumeniiMenuSelected, true);
            app.FEModelMiniFEMMenu.Text = 'FEModel (*.MiniFEM)';

            % Create VisualizationMenu
            app.VisualizationMenu = uimenu(app.UIFigure);
            app.VisualizationMenu.Text = 'Visualization';

            % Create ShowFEMModelMenu
            app.ShowFEMModelMenu = uimenu(app.VisualizationMenu);
            app.ShowFEMModelMenu.MenuSelectedFcn = createCallbackFcn(app, @ShowFEMModelMenuSelected, true);
            app.ShowFEMModelMenu.Text = 'Show FEM Model';

            % Create ApplyforBoundaryConditionsPanel
            app.ApplyforBoundaryConditionsPanel = uipanel(app.UIFigure);
            app.ApplyforBoundaryConditionsPanel.Title = 'Apply for Boundary Conditions';
            app.ApplyforBoundaryConditionsPanel.BackgroundColor = [0.9412 0.9412 0.9412];
            app.ApplyforBoundaryConditionsPanel.FontWeight = 'bold';
            app.ApplyforBoundaryConditionsPanel.Position = [3 6 405 437];

            % Create NodeUnSelectionButton
            app.NodeUnSelectionButton = uibutton(app.ApplyforBoundaryConditionsPanel, 'push');
            app.NodeUnSelectionButton.ButtonPushedFcn = createCallbackFcn(app, @NodeUnSelectionButtonPushed, true);
            app.NodeUnSelectionButton.BackgroundColor = [0.9608 0.9608 0.9608];
            app.NodeUnSelectionButton.FontWeight = 'bold';
            app.NodeUnSelectionButton.Position = [42 201 122 23];
            app.NodeUnSelectionButton.Text = 'Node Un-Selection';

            % Create NodeSelectionButton
            app.NodeSelectionButton = uibutton(app.ApplyforBoundaryConditionsPanel, 'push');
            app.NodeSelectionButton.ButtonPushedFcn = createCallbackFcn(app, @NodeSelectionButtonPushed, true);
            app.NodeSelectionButton.BackgroundColor = [0.9608 0.9608 0.9608];
            app.NodeSelectionButton.FontWeight = 'bold';
            app.NodeSelectionButton.Position = [242 201 122 23];
            app.NodeSelectionButton.Text = 'Node Selection';

            % Create TabGroup2
            app.TabGroup2 = uitabgroup(app.ApplyforBoundaryConditionsPanel);
            app.TabGroup2.Position = [1 9 400 176];

            % Create FixingTab
            app.FixingTab = uitab(app.TabGroup2);
            app.FixingTab.Title = 'Fixing';
            app.FixingTab.BackgroundColor = [0.9412 0.9412 0.9412];

            % Create ApplyforFixationButton
            app.ApplyforFixationButton = uibutton(app.FixingTab, 'push');
            app.ApplyforFixationButton.ButtonPushedFcn = createCallbackFcn(app, @ApplyforFixationButtonPushed, true);
            app.ApplyforFixationButton.FontWeight = 'bold';
            app.ApplyforFixationButton.Position = [227 13 165 26];
            app.ApplyforFixationButton.Text = 'Apply for Fixation';

            % Create ClearFixationButton
            app.ClearFixationButton = uibutton(app.FixingTab, 'push');
            app.ClearFixationButton.ButtonPushedFcn = createCallbackFcn(app, @ClearFixationButtonPushed, true);
            app.ClearFixationButton.FontWeight = 'bold';
            app.ClearFixationButton.Position = [89 15 100 23];
            app.ClearFixationButton.Text = 'Clear Fixation';

            % Create YDirFixedCheckBox
            app.YDirFixedCheckBox = uicheckbox(app.FixingTab);
            app.YDirFixedCheckBox.Text = 'Y-Dir Fixed';
            app.YDirFixedCheckBox.Position = [311 83 81 22];
            app.YDirFixedCheckBox.Value = true;

            % Create XDirFixedCheckBox
            app.XDirFixedCheckBox = uicheckbox(app.FixingTab);
            app.XDirFixedCheckBox.Text = 'X-Dir Fixed';
            app.XDirFixedCheckBox.Position = [311 120 82 22];
            app.XDirFixedCheckBox.Value = true;

            % Create LoadingTab
            app.LoadingTab = uitab(app.TabGroup2);
            app.LoadingTab.Title = 'Loading';
            app.LoadingTab.BackgroundColor = [0.9412 0.9412 0.9412];

            % Create FxNEditFieldLabel
            app.FxNEditFieldLabel = uilabel(app.LoadingTab);
            app.FxNEditFieldLabel.Position = [234 120 38 22];
            app.FxNEditFieldLabel.Text = 'Fx (N)';

            % Create FxNEditField
            app.FxNEditField = uieditfield(app.LoadingTab, 'numeric');
            app.FxNEditField.Position = [274 120 113 22];

            % Create ApplyforLoadsButton
            app.ApplyforLoadsButton = uibutton(app.LoadingTab, 'push');
            app.ApplyforLoadsButton.ButtonPushedFcn = createCallbackFcn(app, @ApplyforLoadsButtonPushed, true);
            app.ApplyforLoadsButton.FontWeight = 'bold';
            app.ApplyforLoadsButton.Position = [238 13 150 26];
            app.ApplyforLoadsButton.Text = 'Apply for Loads';

            % Create ClearLoadsButton
            app.ClearLoadsButton = uibutton(app.LoadingTab, 'push');
            app.ClearLoadsButton.ButtonPushedFcn = createCallbackFcn(app, @ClearLoadsButtonPushed, true);
            app.ClearLoadsButton.FontWeight = 'bold';
            app.ClearLoadsButton.Position = [87 15 100 23];
            app.ClearLoadsButton.Text = 'Clear Loads';

            % Create FyNEditFieldLabel
            app.FyNEditFieldLabel = uilabel(app.LoadingTab);
            app.FyNEditFieldLabel.Position = [235 83 38 22];
            app.FyNEditFieldLabel.Text = 'Fy (N)';

            % Create FyNEditField
            app.FyNEditField = uieditfield(app.LoadingTab, 'numeric');
            app.FyNEditField.Position = [275 83 113 22];

            % Create SelectionOptionsDropDownLabel
            app.SelectionOptionsDropDownLabel = uilabel(app.ApplyforBoundaryConditionsPanel);
            app.SelectionOptionsDropDownLabel.HorizontalAlignment = 'right';
            app.SelectionOptionsDropDownLabel.Position = [171 385 99 22];
            app.SelectionOptionsDropDownLabel.Text = 'Selection Options';

            % Create SelectionOptionsDropDown
            app.SelectionOptionsDropDown = uidropdown(app.ApplyforBoundaryConditionsPanel);
            app.SelectionOptionsDropDown.Items = {'None', 'Box', 'Sphere'};
            app.SelectionOptionsDropDown.ValueChangedFcn = createCallbackFcn(app, @SelectionOptionsDropDownValueChanged, true);
            app.SelectionOptionsDropDown.Position = [285 385 100 22];
            app.SelectionOptionsDropDown.Value = 'None';

            % Create TabGroupSelection
            app.TabGroupSelection = uitabgroup(app.ApplyforBoundaryConditionsPanel);
            app.TabGroupSelection.Position = [0 235 399 142];

            % Create BoxSelectionTab
            app.BoxSelectionTab = uitab(app.TabGroupSelection);
            app.BoxSelectionTab.Title = 'Box Selection';

            % Create CornerPot1XEditFieldLabel
            app.CornerPot1XEditFieldLabel = uilabel(app.BoxSelectionTab);
            app.CornerPot1XEditFieldLabel.HorizontalAlignment = 'right';
            app.CornerPot1XEditFieldLabel.Position = [17 70 104 22];
            app.CornerPot1XEditFieldLabel.Text = 'Corner Pot 1 (*): X';

            % Create CornerPot1XEditField
            app.CornerPot1XEditField = uieditfield(app.BoxSelectionTab, 'numeric');
            app.CornerPot1XEditField.ValueDisplayFormat = '%.1f';
            app.CornerPot1XEditField.ValueChangedFcn = createCallbackFcn(app, @SelectionOptionsDropDownValueChanged, true);
            app.CornerPot1XEditField.Position = [136 70 39 22];

            % Create CornerPot2XEditFieldLabel
            app.CornerPot2XEditFieldLabel = uilabel(app.BoxSelectionTab);
            app.CornerPot2XEditFieldLabel.HorizontalAlignment = 'right';
            app.CornerPot2XEditFieldLabel.Position = [222 70 106 22];
            app.CornerPot2XEditFieldLabel.Text = 'Corner Pot 2 (+): X';

            % Create CornerPot2XEditField
            app.CornerPot2XEditField = uieditfield(app.BoxSelectionTab, 'numeric');
            app.CornerPot2XEditField.ValueDisplayFormat = '%.1f';
            app.CornerPot2XEditField.ValueChangedFcn = createCallbackFcn(app, @SelectionOptionsDropDownValueChanged, true);
            app.CornerPot2XEditField.Position = [343 70 39 22];

            % Create CornerPot1YEditFieldLabel
            app.CornerPot1YEditFieldLabel = uilabel(app.BoxSelectionTab);
            app.CornerPot1YEditFieldLabel.HorizontalAlignment = 'right';
            app.CornerPot1YEditFieldLabel.Position = [19 39 103 22];
            app.CornerPot1YEditFieldLabel.Text = 'Corner Pot 1 (*): Y';

            % Create CornerPot1YEditField
            app.CornerPot1YEditField = uieditfield(app.BoxSelectionTab, 'numeric');
            app.CornerPot1YEditField.ValueDisplayFormat = '%.1f';
            app.CornerPot1YEditField.ValueChangedFcn = createCallbackFcn(app, @SelectionOptionsDropDownValueChanged, true);
            app.CornerPot1YEditField.Position = [137 39 39 22];

            % Create CornerPot2YEditFieldLabel
            app.CornerPot2YEditFieldLabel = uilabel(app.BoxSelectionTab);
            app.CornerPot2YEditFieldLabel.HorizontalAlignment = 'right';
            app.CornerPot2YEditFieldLabel.Position = [223 39 106 22];
            app.CornerPot2YEditFieldLabel.Text = 'Corner Pot 2 (+): Y';

            % Create CornerPot2YEditField
            app.CornerPot2YEditField = uieditfield(app.BoxSelectionTab, 'numeric');
            app.CornerPot2YEditField.ValueDisplayFormat = '%.1f';
            app.CornerPot2YEditField.ValueChangedFcn = createCallbackFcn(app, @SelectionOptionsDropDownValueChanged, true);
            app.CornerPot2YEditField.Position = [343 39 39 22];

            % Create SphereSelectionTab
            app.SphereSelectionTab = uitab(app.TabGroupSelection);
            app.SphereSelectionTab.Title = 'Sphere Selection';

            % Create CenterXEditFieldLabel
            app.CenterXEditFieldLabel = uilabel(app.SphereSelectionTab);
            app.CenterXEditFieldLabel.HorizontalAlignment = 'right';
            app.CenterXEditFieldLabel.Position = [13 78 52 22];
            app.CenterXEditFieldLabel.Text = 'Center X';

            % Create CenterXEditField
            app.CenterXEditField = uieditfield(app.SphereSelectionTab, 'numeric');
            app.CenterXEditField.ValueDisplayFormat = '%.1f';
            app.CenterXEditField.ValueChangedFcn = createCallbackFcn(app, @SelectionOptionsDropDownValueChanged, true);
            app.CenterXEditField.Position = [80 78 100 22];

            % Create CenterYEditFieldLabel
            app.CenterYEditFieldLabel = uilabel(app.SphereSelectionTab);
            app.CenterYEditFieldLabel.HorizontalAlignment = 'right';
            app.CenterYEditFieldLabel.Position = [13 49 52 22];
            app.CenterYEditFieldLabel.Text = 'Center Y';

            % Create CenterYEditField
            app.CenterYEditField = uieditfield(app.SphereSelectionTab, 'numeric');
            app.CenterYEditField.ValueDisplayFormat = '%.1f';
            app.CenterYEditField.ValueChangedFcn = createCallbackFcn(app, @SelectionOptionsDropDownValueChanged, true);
            app.CenterYEditField.Position = [80 49 100 22];

            % Create RadiusEditFieldLabel
            app.RadiusEditFieldLabel = uilabel(app.SphereSelectionTab);
            app.RadiusEditFieldLabel.HorizontalAlignment = 'right';
            app.RadiusEditFieldLabel.Position = [225 48 42 22];
            app.RadiusEditFieldLabel.Text = 'Radius';

            % Create RadiusEditField
            app.RadiusEditField = uieditfield(app.SphereSelectionTab, 'numeric');
            app.RadiusEditField.ValueDisplayFormat = '%.1f';
            app.RadiusEditField.ValueChangedFcn = createCallbackFcn(app, @SelectionOptionsDropDownValueChanged, true);
            app.RadiusEditField.Position = [282 48 100 22];
            app.RadiusEditField.Value = 10;

            % Create ElementsEditFieldLabel
            app.ElementsEditFieldLabel = uilabel(app.UIFigure);
            app.ElementsEditFieldLabel.HorizontalAlignment = 'right';
            app.ElementsEditFieldLabel.Position = [214 549 62 22];
            app.ElementsEditFieldLabel.Text = '#Elements';

            % Create ElementsEditField
            app.ElementsEditField = uieditfield(app.UIFigure, 'numeric');
            app.ElementsEditField.ValueDisplayFormat = '%.0f';
            app.ElementsEditField.Position = [291 549 100 22];

            % Create VerticesEditFieldLabel
            app.VerticesEditFieldLabel = uilabel(app.UIFigure);
            app.VerticesEditFieldLabel.HorizontalAlignment = 'right';
            app.VerticesEditFieldLabel.Position = [223 508 54 22];
            app.VerticesEditFieldLabel.Text = '#Vertices';

            % Create VerticesEditField
            app.VerticesEditField = uieditfield(app.UIFigure, 'numeric');
            app.VerticesEditField.ValueDisplayFormat = '%.0f';
            app.VerticesEditField.Position = [292 508 100 22];

            % Create DOFsEditFieldLabel
            app.DOFsEditFieldLabel = uilabel(app.UIFigure);
            app.DOFsEditFieldLabel.HorizontalAlignment = 'right';
            app.DOFsEditFieldLabel.Position = [234 467 43 22];
            app.DOFsEditFieldLabel.Text = '#DOFs';

            % Create DOFsEditField
            app.DOFsEditField = uieditfield(app.UIFigure, 'numeric');
            app.DOFsEditField.ValueDisplayFormat = '%.0f';
            app.DOFsEditField.Position = [292 467 100 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ApplyBC_2D(varargin)

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @(app)startupFcn(app, varargin{:}))

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