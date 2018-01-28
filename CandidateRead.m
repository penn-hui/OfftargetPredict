%% this function is to read the Cas-OFFinder output files and generate the
%% test samples for off-target site prediction
function candidate_ot=CandidateRead(sgSeq, filepath, type)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% sgSeq -- the 23 on-target sequence including the 20nt protospacer+3nt PAM  
% filepath -- the full path of the Cas-OFFinder output file in '.txt' format
% type -- the type of method for obtaining the Cas-OFFinder output file
%         type=1 means obtain from the online tool: http://www.rgenome.net/cas-offinder/
%         type=2 means obtain the file via the offline software (http://www.rgenome.net/cas-offinder/portable)
%         type=2 is recommended as the online tool don't output more than
%         1000 potential target sites

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fileID = fopen(filepath);
if type==1
    
    % online output, there are 8 fileds where the second and the third columns show
    % the on-target sequence and the potential off-target site. The forth,
    % fifth and sixth column are the chromosome id, position and the direction of the
    % potential off-target sequence. The seventh column is the mismatch
    % numbers, where the mismatches in the 'GG' of the PAM 'NGG' are also
    % included.
    
    C = textscan(fileID,'%s %s %s %s %s %s %s %s','Delimiter','\t');
    fclose(fileID);
    on=repmat({sgSeq},length(C{1,3})-1,1);
    poff=[upper(C{1,3}),C{1,4},C{1,5},C{1,6},C{1,7}];
    initial=[on,poff(2:end,:)];
elseif type==2
    
    % the format of the offline output files are not the same with the online
    % there are 6 fileds such as: on-target sequence; chromosome id;
    % position; potential off-target sequence; strand; mismatch number (PAM included)
    C = textscan(fileID,'%s %s %s %s %s %s','Delimiter','\t');
    fclose(fileID);
    on=repmat({sgSeq},length(C{1,3}),1);
    poff=[upper(C{1,4}),C{1,2},C{1,3},C{1,5},C{1,6}];
    initial=[on,poff];
end
index=find(~strcmp(initial(:,3),'chrM'));
candidate_ot=initial(index,:);