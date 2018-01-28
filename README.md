# OfftargetPredict
ensemble learning for CRISPR/Cas9 off-target site prediction 

This is the Matlab version source codes for the CRISPR/Cas9 system off-target site prediction

*********************************************************************************************
1. About the files
   There are three source code files that their file names contain the suffix of '.m':
      OfftargetPredict.m -- the main code for the prediction
      CandidateRead.m -- the code for reading the input candidate off-target site sequences
                         and other information
      OnOffFea2.m -- the code for exracting feature vectors for characterizing a given on-target-
                     off-target site sequence pair
   
   The file Models.mat is the trained ensemble svm models.
   The file folder "example_input_files" gives two example input files where:
      offline_input.txt -- is the file that obtained from the offline software 'Cas-OFFinder'
      online_input.txt -- is an example file obtained from the website 'http://www.rgenome.net/cas-offinder/'

**********************************************************************************************
2. How to use this tool
   
    2.1 preparing the input files
       we use the genome wide candidate off-target site sequences of a given sgRNA on-target site sequence as
       the input of the tool. Users can prepare the input candidate off-target site sequences by two ways:
       A. from the web tool Cas-OFFinder: http://www.rgenome.net/cas-offinder/
          parameters: 

          a. ## PAM Type  ###############################
          The PAM Type should be " SpCas9 from Streptococcus pyogenes: 5'-NGG-3' " or 
          " SpCas9 from Streptococcus pyogenes: 5'-NRG-3' (R = A or G) ";
          
          b. ## Target Genome ############################
          Human and Mouse genomes can be selected (GRCh38/hg38 or hg19 for Human and mm10 for Mouse)
          
          c. ## Query Sequences ##########################
          a 20nt sequence of the on-target site should be entered into the blank;
          Mismatch Number is suggested to be set no bigger than 6 (<=6)
          DNA Bulge Size and RNA Bulge Size are remain to be 0
       
       With all the parameters being filled, then submit the job and wait and download the output file

       B. from the offline tool Cas-OFFinder which can be downloaded from: http://www.rgenome.net/cas-offinder/portable
       The detail of how to use this tool can be found from the website:  http://www.rgenome.net/cas-offinder/portable

   2.2 The Libsvm tool
       We applied the Libsvm version 3.22 to implement the binary classification.
       This tool can be downloaded from https://www.csie.ntu.edu.tw/~cjlin/libsvm/
       addind the tool folder path to the working path of the matlab first before running our codes

   2.3 Run the tool
      The codes is programmed with the Matlab R2015b version. The steps for running the tool are:
      a. Adding the file folder path to the Matlab working path for example 'xxx\OfftargetPredict\'
      b. paste the following command:
         
         [predict_results,off_targets]=OfftargetPredict(sgSeq, filepath, type, paralell);

      There are four inputs:
         sgSeq --- string: is the 23nt on-target site sequence (20nt protospacer + 3nt PAM )
         filepath --- string: the complete filepath of the previous prepared candidate off-target site sequence
         type --- integer: to be 1 or 2, where 1 means the input candidate off-target sites are obtained with the online web tool;
                           2 means the candidate off-target sites are obtained with the offline software. This parameter
         paralell --- integer: to be 1 or 0, whether use the paralell computing to speed up the prediction
                               if paralell==1, then the paralell computing will be applied, otherwise the traditional computing
                               is used

      There are two outputs:
         predict_results: the predicted scores that show the prabability of a candidate site to be a real off-target site
                          0.5 is the threshold for label the candidate sites, where score>0.5 will be labeled as '1', otherwise '0'
                          
         off_targets: the list of all the predicted off-target sites with the position information

####################################################################################################################################
####################################################################################################################################

Example command (under the working filefold that contain the .m files):
    
       example1: predicting the off-target sites of the sgRNA with the spacer: 
                   sgSeq = 'AGGCACCGAGCTGTATGGTGTGG'
                   filepath = 'example_input_files\offline_input.txt'
                   type = 2
                   paralell = 1
                   
                   [predict_results,off_targets]=OfftargetPredict('AGGCACCGAGCTGTATGGTGTGG', 'example_input_files\offline_input.txt', 2, 1);

       example2: predicting the off-target sites of the sgRNA with the spacer:
                 sgSeq = 'GACCCCCTCCACCCCGCCTCCGG'
                 filepath = 'example_input_files\online_input.txt'
                 type = 1
                 paralell = 0
                   
                 [predict_results,off_targets]=OfftargetPredict('AGGCACCGAGCTGTATGGTGTGG', 'example_input_files\offline_input.txt', 2, 1);


##############################################################################################################################################
##############################################################################################################################################
Please contact Hui Peng: Hui.Peng-2@student.uts.edu.au if you encounter some problems when run the codes.

       
