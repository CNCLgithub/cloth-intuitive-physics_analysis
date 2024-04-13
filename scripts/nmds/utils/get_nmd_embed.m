function [comparisons, ibx, embed, cembed] = get_nmd_embed(infile, lambda, header_list)
    %% This is selected based on the acc_train & acc_test
    % infile = fullfile(inputRootDir, 'nmds_human.csv');

    [left mid right mid] = csvimport(infile, 'columns', header_list, 'noHeader', true);
    C = [left mid right mid];
    C = C(2:end,:);  % the first row is header
    
    % [wb]: change the name of the video to the number
    [CC,~,ibx] = unique(C);
    ib = reshape(ibx, size(C));
    % % [wb]: make sure the |left-mid| < |right-mid|, i.e., left is always the target.
    ib(:,5) = ones(length(ib(:,1)),1);
    comparisons = ib;
   
    c = cellstr(CC);

    [X,spread,info,B,slack] = yanmds(comparisons,max(ibx),lambda); % 

    % [wb]: We care only the first 2 dimensions of the embedding
    embed = X(:,1:2);
    cembed = c;
end

