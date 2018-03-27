A simple introduction

We proposed a ensemble svm method for the prediction of off-target sites for a given sgRNA.
It adopts the on-target site sequence of a sgRNA and the genome-wide candidate off-target sites
as inputs. It labels the candidate off-target site as real off-target site if the predicted score>0.5.

######################################################################################################
######################################################################################################
We provide both the Matlab version and python version of the off-target site prediction tool
The source codes and their related files are compressed as .zip files such as:
    matlab.zip --- the compressed files for our Matlab version source codes
    python.zip --- the compressed files for our python version source codes

Both of these two version tools can be used to predict a given sgRNAs' off-target sites. We did not 
control the precision of the floating-point operations, thus the predicted results of the Matlab version
and the Python version may contain some differences (most of the sites are overlapped with each other).
More details can be found in the ReadMe.txt file in the uncompress folders (matlab/ReadMe.txt or 
python/ReadMe.txt).

#########################################################################################################
#########################################################################################################

Package dependency:

The following packages must be installed to run the Python version tool:
  1. numpy
  2. sklearn
  3. libsvm
  4. scipy

For the Matlab version codes, the Libsvm v3.22 is required to be installed (see https://www.csie.ntu.edu.tw/~cjlin/libsvm/)

More details about how to install these packages can be found in the ReadMe.txt file in the matlab and
python folders.

#################################################################################################################
#################################################################################################################
How to run the codes:
1. Preparing the input candidate off-target sites:

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


2. How to run the python version codes:

After downloading the codes and decompressing it, one can open a console application (command prompt on the
windows os or a console on the linux os). Using the python_codes folder path as the current working path and
run the codes. For example:
     
     cd python
     python OfftargetPredict.py AGGCACCGAGCTGTATGGTGTGG 2 example_input_files/offline_input.txt   

(please pay attention on the path character ‘/’ on linux os and ‘\’ on windows os)

Then, you can find the .csv file in the folder: python/predicted_results/ predict_results.csv
More details about how to run the python codes can be found in the ReadMe.txt file under the python folder

3. How to run the Matlab version codes:
Download the codes and decompress the files, then open a Matlab software (Matlab 2015 or higher). Adding the folder
matlab/ into the working path. Then run the prediction command. For example:
     
      [predict_results,off_targets]=OfftargetPredict('AGGCACCGAGCTGTATGGTGTGG', 'example_input_files/offline_input.txt', 2, 1);   
The output variable off-targets lists the predicted off-target sites

(please pay attention on the path character ‘/’ on linux os and ‘\’ on windows os)
More details about how to run the python codes can be found in the ReadMe.txt file under the matlab/ folder

###############################################################################################################################
###############################################################################################################################

Please contact Hui Peng: Hui.Peng-2@student.uts.edu.au if you encounter some problems when run the codes.