% makes file for McIntosh's Batch PLS 
clear

% enter subjects to include in the PLS analysis
%subjArr=[16 18 20 23 31 35 43 52 56:58 61:62 64:69 71 72];
subjArr = [16];

% settings!
for subj=1:length(subjArr)
    
    subjNo=subjArr(subj);
    prefix=['odorscan' num2str(subjNo)];
    
    %prefix='odorscan';
    brain_region=0.15;
    win_size = 8; % number of scans in one hemodynamic period??????
    across_run=1; % 1 for merge data across all run, 0 for within
    single_subj=0; % 1 for single subject analysis, 0 for normal analysis
    
    datafile=['~/odorscan/odorscan_afni/];
    % conditions
    condArr={'1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12' '13' '14' '15' '16'};
    
    %open template for reading
    fid = fopen('batch_demo_fmri_data1.txt');
    
    % open outfile for writing
    fidout = fopen(['PLSfile' num2str(subjNo) '.txt'], 'w');
    
    tline = fgets(fid);
    while ischar(tline)
        %disp(tline)
        
        if length(tline)>=6 && strcmp(tline(1:6), 'prefix')
            fprintf(fidout, ['prefix\t\t' prefix '\n']);
        elseif length(tline)>=12 && strcmp(tline(1:12),'brain_region')
            fprintf(fidout, ['brain_region\t' num2str(brain_region) '\n']);
        elseif length(tline)>=8 && strcmp(tline(1:8), 'win_size')
            fprintf(fidout, ['win_size\t' num2str(win_size) '\n']);
        elseif length(tline)>=10 && strcmp(tline(1:10), 'across_run')
            fprintf(fidout, ['across_run\t' num2str(across_run) '\n']);
        elseif length(tline)>=11 && strcmp(tline(1:11), 'single_subj')
            fprintf(fidout, ['single_subj\t' num2str(single_subj) '\n']);
        elseif length(tline)>=9 && strcmp(tline(1:9), 'cond_name')
            % when you hit the first 'cond_name' line, write out all your
            % conditions
            for cond = 1:length(condArr)
                condname=condArr{cond};
                
                fprintf(fidout, ['cond_name	' condname '\n']);
                fprintf(fidout, ['ref_scan_onset   0\n']);
                fprintf(fidout, ['num_ref_scan    1\n']);
                fprintf(fidout, ['\n']);
            end
            
            tline = fgets(fid);
            while tline<15
                tline=fgets(fid);
            end
            while ~strcmp(tline(1:15), '% ... following')
                strcmp(tline(1:15), '% ... following')
                
                tline = fgets(fid);
                while length(tline)<15
                    tline = fgets(fid);
                end
                %pause
            end
            fprintf(fidout,[tline '\n']);
        elseif length(tline)>=10 && strcmp(tline(1:10), 'data_files')
% fill in subj info
            fprintf(fidout, ['data_files	' datafile '\n']);
            fprintf(fidout, ['\n']);
%             
%             for cond = 1:length(condArr);
%                 % calculate event_onsets here
%                 
%                 fprintf(fidout, ['event_onsets   0\n']);
%                 fprintf(fidout, ['\n']);
%             end
%             
%             
%             tline = fgets(fid);
%             while tline<15
%                 tline=fgets(fid);
%             end
%             while ~strcmp(tline(1:15), '% ... following')
%                 strcmp(tline(1:15), '% ... following')
%                 
%                 tline = fgets(fid);
%                 while length(tline)<15
%                     tline = fgets(fid);
%                 end
%                 %pause
%             end
%             fprintf(fidout,[tline '\n']);
        else
            tline = regexprep(tline, '%', '%%');
            fprintf(fidout,[tline '\n']);
        end
        tline = fgets(fid);
    end
    
    fclose(fid);
    fclose(fidout);
    
end