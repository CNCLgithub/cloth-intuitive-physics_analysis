clc; clear all; close all;
curDir=(pwd);

utils_path = fullfile(pwd,'utils');
if (~isempty(strfind(path,utils_path))) == 0 
   addpath(genpath(utils_path));
   savepath;
end

sedumi_path = fullfile(utils_path, 'sedumi');
if (~isempty(strfind(path,sedumi_path))) == 0
    addpath(genpath(sedumi_path));
    savepath;
end

%%
EXP = 'mass';  % stiff | mass
a=load(['output/embed_after_align_', EXP , '.mat']);
EXP = a.EXP;
embed_dnn = a.embed_dnn;
embed_woven = a.embed_woven;
embed_wovenab = a.embed_wovenab;
embed_wovenab2 = a.embed_wovenab2;
embed_dnn2 = a.embed_dnn2;
embed_human = a.embed_human;
cembed_dnn = a.cembed_dnn;
cembed_woven = a.cembed_woven;
cembed_wovenab = a.cembed_wovenab;
cembed_wovenab2 = a.cembed_wovenab2;
cembed_human = a.cembed_human;
cembed_dnn2 = a.cembed_dnn2;

%% correlation
r_woven_human = corr2(embed_woven, embed_human);
r_dnn_human = corr2(embed_dnn, embed_human);
r_wovenab_human = corr2(embed_wovenab, embed_human);
r_wovenab2_human = corr2(embed_wovenab2, embed_human);
r_dnn2_human = corr2(embed_dnn2, embed_human);

fprintf('@@@ Correlation between [r_dnn_human]: R=%f \n', r_dnn_human);
fprintf('@@@ Correlation between [r_woven_human] : R=%f \n', r_woven_human);
fprintf('@@@ Correlation between [r_wovenab_human]: R=%f \n', r_wovenab_human);
fprintf('@@@ Correlation between [r_wovenab2_human]: R=%f \n', r_wovenab2_human);
fprintf('@@@ Correlation between [r_dnn2_human]: R=%f \n', r_dnn2_human);


%%
%% ====  Plot ==== %
nDim = 2;
parts = split(cembed_woven, '_');
if strcmp(EXP, 'mass')
    REL_IDX = 2;
    IRREL_IDX = 3;
    REL_VAL=[0.25, 0.5, 1.0, 2.0];
    IRREL_VAL=[0.0078125, 0.03125, 0.125, 0.5, 2.0];
elseif strcmp(EXP, 'stiff')
    REL_IDX = 3;
    IRREL_IDX = 2;
    REL_VAL=[0.0078125, 0.03125, 0.125, 0.5, 2.0];
    IRREL_VAL=[0.25, 0.5, 1.0, 2.0];
end
parts = parts(:, REL_IDX);

GroundTruth = str2double(parts);
cond = {'embed_human', 'embed_woven', 'embed_wovenab', 'embed_dnn', 'embed_wovenab2', 'embed_dnn2'};

color1 = [0.2, 0.2, 0.8];  % Blue
color2 = [0.4, 0.4, 0.6];  % Darker Blue
color3 = [0.6, 0.6, 0.4];  % Even Darker Blue
color4 = [0.8, 0.8, 0.2];  % Even Darker Blue
color5 = [1.0, 1.0, 0.0];  % Yellow
custom_colormap = [color1; color2; color3; color4; color5];

out_dir = 'output/fig';
if ~exist(out_dir, 'dir')
    mkdir(out_dir);
end

for cur_i = 1: length(cond)
    temp_data = eval(cond{cur_i});
    temp_GroundTruth = GroundTruth;
    
    dx = 0.01; dy = 0.01;
    cur_text = eval(['c',cond{cur_i}]);
    
    marker_ls = [];
    color_ls = [];
    size_ls = [];
    for text_idx = 1: length(cur_text)
        tmp_text = cur_text{text_idx};
        tmp_text = split(tmp_text,'_');
        cur_text{text_idx} = tmp_text{REL_IDX};
        
        if strcmp(tmp_text{1}, 'wind')
            cur_marker = 's';
        elseif strcmp(tmp_text{1}, 'rotate')
            cur_marker = 'c';
        elseif strcmp(tmp_text{1}, 'ball')
            cur_marker = 'd';
        elseif strcmp(tmp_text{1}, 'drape')
            cur_marker = 'p';
        end
        
        cur_rel_idx =  find(REL_VAL == str2num(tmp_text{REL_IDX}));
        cur_color = custom_colormap(cur_rel_idx,:,:);
        cur_size = 15* (3* (log2(str2double(tmp_text{IRREL_IDX})) + 7) + 1);

        marker_ls = [marker_ls, cur_marker];
        color_ls = [color_ls; cur_color];
        size_ls = [size_ls, cur_size];
    end
    marker_ls = cellstr(marker_ls');

    figureh = figure; 
    set(gca, 'XLim', [-1.0 1.0], 'YLim', [-0.8 0.8]);
    
    x = temp_data(:,1);
    y = temp_data(:,2);
    
    % ---------------------------------
    scatter(x, y, size_ls, color_ls); 
    text(x+dx, y+dy, cur_text);
    legend(['Generalized Non-metric MDS:', cond{cur_i}]);
    resolution = '-r300';
    filename = fullfile(out_dir, strcat('cor_', cond{cur_i}, '_', EXP, '.png'));
    saveas(figureh, filename, 'png');
    
    hold off;
    close(figureh);
end
