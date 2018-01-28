%% this function is to predict the off-targets with the ensemble model
function [predict_results,off_targets]=OfftargetPredict(sgSeq, filepath, type, paralell)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inputs:
%   sgSeq -- the 23 on-target sequence including the 20nt protospacer+3nt PAM  
%   filepath -- the full path of the Cas-OFFinder output file in '.txt' format
%   type -- the type of method for obtaining the Cas-OFFinder output file
%         type=1 means obtain from the online tool: http://www.rgenome.net/cas-offinder/
%         type=2 means obtain the file via the offline software (http://www.rgenome.net/cas-offinder/portable)
%         type=2 is recommended as the online tool don't output more than
%         1000 potential target sites
% outputs:
%    predict-results---the predicted scores and labels of the candidate
%                  off-targets. The last two column are the scores and
%                  labels(1 for real off-target, 0 for non-off-target)
%    off_targets---the predicted off-target sites

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('Models.mat');
candidates=CandidateRead(sgSeq, filepath, type);
% candidate_ot--- candidate_ot is the pre-processed sgRNA-candidate_off sequence pairs
%               the first column is the sgRNA sequence(23nt), the second column is the
%               candidate off target sequences (23nt). The third column is the number of 
%               mismatches in candidate off-targets(including the last 2nt in PAM)
%               the fourth column is the chromosome number of the candidate off-target
%               the fifth column is the position of the candidate off-target
%               the last column is the strand of the candidate off-target
ind=find(strcmp(candidates(:,6),'0'));
index_all=1:1:length(candidates(:,1));
ind_remain=setdiff(index_all,ind);
candidate_ot=candidates(ind_remain,:);
mis_0=candidate_ot(ind,:);
for i=1:length(ind)
    mis_0{i,7}=1;
    mis_0{i,8}='*';
end


can_feas=[];
if paralell==1 % use multi-core for paralell computing
    parfor i=1:length(candidate_ot(:,1))
        on=candidate_ot{i,1};
        off=candidate_ot{i,2};
        can_fea=OnOffFea2(on,off);
        can_feas=[can_feas;can_fea];
    end
else
    for i=1:length(candidate_ot(:,1))
        on=candidate_ot{i,1};
        off=candidate_ot{i,2};
        can_fea=OnOffFea2(on,off);
        can_feas=[can_feas;can_fea];
    end
end

num_models=length(Models);
scores=[];
if paralell==1 % use multi-core for paralell computing
    parfor i=1:num_models
        ps=Models{i,2};
        model=Models{i,1};
        Test_data=mapminmax('apply',can_feas',ps);
        Test_data=Test_data';
        test_label=zeros(length(Test_data(:,1)),1);
        [predict_label,acc,dec_values] = svmpredict(test_label,Test_data,model,'-b 1 -q 1');
        Labelpredict=predict_label;
        if Labelpredict(1,1)==1
            [a,mi]=max(dec_values(1,:));
            score=(dec_values(:,mi));
        else
            [a,mi]=min(dec_values(1,:));
            score=(dec_values(:,mi));
        end
        scores=[scores,score];
    end
else
    for i=1:num_models
        ps=Models{i,2};
        model=Models{i,1};
        Test_data=mapminmax('apply',can_feas',ps);
        Test_data=Test_data';
        test_label=zeros(length(Test_data(:,1)),1);
        [predict_label,acc,dec_values] = svmpredict(test_label,Test_data,model,'-b 1 -q 1');
        Labelpredict=predict_label;
        if Labelpredict(1,1)==1
            [a,mi]=max(dec_values(1,:));
            score=(dec_values(:,mi));
        else
            [a,mi]=min(dec_values(1,:));
            score=(dec_values(:,mi));
        end
        scores=[scores,score];
    end
end
Score=mean(scores');
Score=Score';
labels=zeros(length(Score),1);
labels(find(Score>0.5),1)=1;
% Label=num2cell(labels);
predict_results=[candidate_ot,num2cell(Score),num2cell(labels)];
% index=1:1:length(Score);
% S=[Score,index'];
% S=sortrows(S,-1);
% predict_results=predict_results(S(:,2),:);
off_targets=candidate_ot(find(Score>0.5),:);
if length(mis_0(:,1))>1
    off_targets=[mis_0;off_targets];
    disp('those with 0 mismatch are marked with *,');
    disp('where one of them is the on-target site,');
    disp('and the others are off-target sites');    
end
