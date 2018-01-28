%% this function is to extract the feature of a given on-off pair
function fea=OnOffFea(on,off)
L=length(on);
onoff=cell(1,12);
onoff{1,1}='AT';
onoff{1,2}='AC';
onoff{1,3}='AG';
onoff{1,4}='TC';
onoff{1,5}='TG';
onoff{1,6}='TA';
onoff{1,7}='GA';
onoff{1,8}='GT';
onoff{1,9}='GC';
onoff{1,10}='CA';
onoff{1,11}='CT';
onoff{1,12}='CG';
gc_on=GCfea(on);
gc_off=GCfea(off);
gcfea=gc_off-gc_on;
mmfea=[];
for i=1:L
    mm=zeros(1,12);
    pp=[on(1,i),off(1,i)];
    index=find(strcmp(onoff,pp));
    if length(index)>0
        mm(1,index(1,1))=1;
    end
    mmfea=[mmfea,mm];
end
fea=[gcfea,mmfea];
%fea=gcfea;
end

function gcfea=GCfea(s)
N=length(s);
gcfea=zeros(1,5);
gcfea(1,1)=length(strfind(s,'C'))+length(strfind(s,'G'));
gcfea(1,2)=(length(strfind(s,'C'))+length(strfind(s,'G')))/N;
if (length(strfind(s,'C'))+length(strfind(s,'G')))~=0
    gcfea(1,3)=(length(strfind(s,'G'))-length(strfind(s,'C')))/(length(strfind(s,'C'))+length(strfind(s,'G')));
else
    gcfea(1,3)=0;
end
if (length(strfind(s,'A'))+length(strfind(s,'T')))~=0
    gcfea(1,4)=(length(strfind(s,'A'))-length(strfind(s,'T')))/(length(strfind(s,'A'))+length(strfind(s,'T')));
else
    gcfea(1,4)=0;
end
if gcfea(1,4)==0
    gcfea(1,5)=0;
else
    gcfea(1,5)=gcfea(1,3)/gcfea(1,4);
end
end