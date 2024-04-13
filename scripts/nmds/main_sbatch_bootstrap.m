function main_sbatch_bootstrap(EXP)
       % EXP = 'stiff' | 'mass'
        curDir=(pwd);
        
        utils_path = fullfile(pwd,'utils');
        if (~isempty(strfind(path,utils_path))) == 0 
           addpath(genpath(utils_path));
           savepath;
        end
        
        sedumi_path = fullfile(utils_path, 'sedumi');
        if (contains(path,sedumi_path)) == 0
            addpath(genpath(sedumi_path));
            savepath;
        end
        
        inputRootDir = fullfile(pwd, 'data', ['data_', EXP]);
        outputRoorDir = fullfile(pwd, 'output');
        lambda=0.2;
        %% ==================== Params =====================================%
        header_list = [1, 2, 3, 4];
        
        %% ==================== Construct embeddings ======================%
        infile = fullfile(inputRootDir, ['nmds_human.csv']);
        [comparisons, ibx, embed_human, cembed_human] = get_nmd_embed(infile, lambda, header_list);
        % % ===========================================================
        %% woven: Woven
        infile = fullfile(inputRootDir, ['nmds_woven.csv']);
        [comparisons, ibx, embed_woven, cembed_woven] = get_nmd_embed(infile, lambda, header_list);
        % % ===========================================================
        %% dnn: DNN
        infile = fullfile(inputRootDir, ['nmds_dnn.csv']);
        [comparisons, ibx, embed_dnn, cembed_dnn] = get_nmd_embed(infile, lambda, header_list);
        % % ===========================================================
        %% wovenab: Woven-ablation
        infile = fullfile(inputRootDir, ['nmds_wovenab.csv']);
        [comparisons, ibx, embed_wovenab, cembed_wovenab] = get_nmd_embed(infile, lambda, header_list);
        % % ===========================================================
        %% wovenab2: Ablation+
        infile = fullfile(inputRootDir, ['nmds_wovenab2.csv']);
        [comparisons, ibx, embed_wovenab2, cembed_wovenab2] = get_nmd_embed(infile, lambda, header_list);
        % % ===========================================================    
        %% dnn2: best-corr. DNN
        infile = fullfile(inputRootDir, ['nmds_dnn2.csv']);
        [comparisons, ibx, embed_dnn2, cembed_dnn2] = get_nmd_embed(infile, lambda, header_list);
        out_f = ['output/embed_before_align_', EXP, '.mat'];
        save(out_f, 'embed_human' ,'embed_woven', 'embed_dnn', 'embed_wovenab', 'embed_wovenab2', 'embed_dnn2',...
            'cembed_human' ,'cembed_woven', 'cembed_dnn', 'cembed_wovenab', 'cembed_wovenab2', 'cembed_dnn2', 'EXP');

        m_human = mean(embed_human,1);
        m_dnn = mean(embed_dnn,1);
        m_woven = mean(embed_woven,1);
        m_wovenab = mean(embed_wovenab,1);
        m_wovenab2 = mean(embed_wovenab2,1);
        m_dnn2 = mean(embed_dnn2,1);

        embed_human = embed_human-repmat(m_human,max(ibx),1);
        embed_dnn = embed_dnn-repmat(m_dnn,max(ibx),1);
        embed_woven = embed_woven-repmat(m_woven,max(ibx),1);
        embed_wovenab = embed_wovenab-repmat(m_wovenab,max(ibx),1);
        embed_wovenab2 = embed_wovenab2-repmat(m_wovenab2,max(ibx),1);
        embed_dnn2 = embed_dnn2-repmat(m_dnn2,max(ibx),1);

        s_woven_human = embed_woven(:)'*embed_human(:)/(embed_woven(:)'* embed_woven(:));
        embed_woven = s_woven_human*embed_woven;
        s_dnn_human = embed_dnn(:)'*embed_human(:)/(embed_dnn(:)'*embed_dnn(:));
        embed_dnn = s_dnn_human*embed_dnn;
        s_wovenab_human = embed_wovenab(:)'*embed_human(:)/(embed_wovenab(:)'* embed_wovenab(:));
        embed_wovenab = s_wovenab_human*embed_wovenab;
        s_wovenab2_human = embed_wovenab2(:)'*embed_human(:)/(embed_wovenab2(:)'* embed_wovenab2(:));
        embed_wovenab2 = s_wovenab2_human*embed_wovenab2;
        s_dnn2_human = embed_dnn2(:)'*embed_human(:)/(embed_dnn2(:)'*embed_dnn2(:));
        embed_dnn2 = s_dnn2_human*embed_dnn2;

        r_woven_human = corr2(embed_woven, embed_human);
        r_dnn_human = corr2(embed_dnn, embed_human);
        r_wovenab_human = corr2(embed_wovenab, embed_human);
        r_wovenab2_human = corr2(embed_wovenab2, embed_human);
        r_dnn2_human = corr2(embed_dnn2, embed_human);

        out_f = ['output/embed_after_align_', EXP, '.mat'];
        save(out_f,"embed_human" ,'embed_woven', 'embed_dnn', 'embed_wovenab', 'embed_wovenab2', 'embed_dnn2',...
            'cembed_human','cembed_woven', 'cembed_dnn', 'cembed_wovenab', 'cembed_wovenab2','EXP', 'cembed_dnn2',...
            'r_woven_human', 'r_dnn_human', 'r_wovenab_human', 'r_wovenab2_human', 'r_dnn2_human');
        fprintf('@@@ Save=%s \n', out_f);

end
