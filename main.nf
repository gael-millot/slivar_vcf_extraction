nextflow.enable.dsl=1
/*
#########################################################################
##                                                                     ##
##     slivar_vcf_extraction.nf                                        ##
##                                                                     ##
##     Gael A. Millot                                                  ##
##     Bioinformatics and Biostatistics Hub                            ##
##     Computational Biology Department                                ##
##     Institut Pasteur Paris                                          ##
##                                                                     ##
#########################################################################
*/



    print("\n\nINITIATION TIME: ${workflow.start}")

//////// Arguments of nextflow run

params.modules = ""

//////// end Arguments of nextflow run


//////// Variables

config_file = workflow.configFiles[0] // better to use this than config_file = file("${projectDir}/nextflow.config") because the latter is not good if -c option of nextflow run is used // file() create a path object necessary o then create the file
log_file = file("${launchDir}/.nextflow.log")
modules = params.modules // remove the dot -> can be used in bash scripts

vcf = file(sample_path)
fun = file(fun_path)
ped = file(ped_path)
annot1 = file(annot1_path) 
annot2 = file(annot2_path)
// patient = ["${affected_patients}", "${unaffected_patients}"] // create two entries, see https://www.nextflow.io/docs/latest/channel.html#from
// patient_name = ["affected_patients", "unaffected_patients"] // create two entries, see https://www.nextflow.io/docs/latest/channel.html#from

//////// end Variables


//////// Channels


//////// end Channels


//////// Checks
//// check of the bin folder
// No need since slivar-functions.js is in the parameters
//// end check of the bin folder
def file_exists1 = vcf.exists()
if( ! file_exists1){
    error "\n\n========\n\nERROR IN NEXTFLOW EXECUTION\n\nINVALID sample_path PARAMETER IN nextflow.config FILE: ${sample_path}\nIF POINTING TO A DISTANT SERVER, CHECK THAT IT IS MOUNTED\n\n========\n\n"
}
def file_exists3 = fun.exists()
if( ! file_exists3){
    error "\n\n========\n\nERROR IN NEXTFLOW EXECUTION\n\nINVALID fun_path PARAMETER IN nextflow.config FILE: ${fun_path}\nIF POINTING TO A DISTANT SERVER, CHECK THAT IT IS MOUNTED\n\n========\n\n"
}
def file_exists4 = ped.exists()
if( ! file_exists4){
    error "\n\n========\n\nERROR IN NEXTFLOW EXECUTION\n\nINVALID ped_path PARAMETER IN nextflow.config FILE: ${ped_path}\nIF POINTING TO A DISTANT SERVER, CHECK THAT IT IS MOUNTED\n\n========\n\n"
}
def file_exists5 = annot1.exists()
if( ! file_exists5){
    error "\n\n========\n\nERROR IN NEXTFLOW EXECUTION\n\nINVALID annot1_path PARAMETER IN nextflow.config FILE: ${annot1_path}\nIF POINTING TO A DISTANT SERVER, CHECK THAT IT IS MOUNTED\n\n========\n\n"
}
def file_exists6 = annot2.exists()
if( ! file_exists6){
    error "\n\n========\n\nERROR IN NEXTFLOW EXECUTION\n\nINVALID annot2_path PARAMETER IN nextflow.config FILE: ${annot2_path}\nIF POINTING TO A DISTANT SERVER, CHECK THAT IT IS MOUNTED\n\n========\n\n"
}
if( ! sample_expr in String ){
    error "\n\n========\n\nERROR IN NEXTFLOW EXECUTION\n\nINVALID sample_expr PARAMETER IN nextflow.config FILE:\n${sample_expr}\nMUST BE A SINGLE CHARACTER STRING\n\n========\n\n"
}
if( ! pedigree_expr in String ){
    error "\n\n========\n\nERROR IN NEXTFLOW EXECUTION\n\nINVALID pedigree_expr PARAMETER IN nextflow.config FILE:\n${pedigree_expr}\nMUST BE A SINGLE CHARACTER STRING\n\n========\n\n"
}
if( ! (filter == "true" || filter == "false")){
    error "\n\n========\n\nERROR IN NEXTFLOW EXECUTION\n\nINVALID filter PARAMETER IN nextflow.config FILE:\n${filter}\nMUST BE THE SINGLE CHARACTER STRING \"true\" OR \"false\"\n\n========\n\n"
}
if( ! (tsv_file == "true" || tsv_file == "false")){
    error "\n\n========\n\nERROR IN NEXTFLOW EXECUTION\n\nINVALID tsv_file PARAMETER IN nextflow.config FILE:\n${tsv_file}\nMUST BE THE SINGLE CHARACTER STRING \"true\" OR \"false\"\n\n========\n\n"
}
if( ! tsv_sample in String ){
    error "\n\n========\n\nERROR IN NEXTFLOW EXECUTION\n\nINVALID tsv_sample PARAMETER IN nextflow.config FILE:\n${tsv_sample}\nMUST BE A SINGLE CHARACTER STRING\n\n========\n\n"
}
if( ! tsv_info in String ){
    error "\n\n========\n\nERROR IN NEXTFLOW EXECUTION\n\nINVALID tsv_info PARAMETER IN nextflow.config FILE:\n${tsv_info}\nMUST BE A SINGLE CHARACTER STRING\n\n========\n\n"
}

// below : those variable are already used in the config file. Thus, to late to check them. And not possible to check inside the config file
// system_exec
// out_ini
print("\n\nRESULT DIRECTORY: ${out_path}")
if("${system_exec}" != "local"){
    print("    queue: ${queue}")
    print("    qos: ${qos}")
    print("    add_options: ${add_options}")
}
print("\n\n")


//////// end Checks


//////// Variable modification

if(filter == "true"){
    filter = "--pass-only"
}else if(filter == "false"){
    filter = " "
}else{
    error "\n\n========\n\nERROR IN NEXTFLOW EXECUTION\n\nINVALID filter PARAMETER IN nextflow.config FILE:\n${filter}\nMUST BE THE SINGLE CHARACTER STRING true OR false\n\n========\n\n"
}

//////// end Variable modification


//////// Processes


process WorkflowVersion { // create a file with the workflow version in out_path
    label 'bash' // see the withLabel: bash in the nextflow config file 
    publishDir "${out_path}/reports", mode: 'copy', overwrite: false
    cache 'false'

    output:
    file "Run_info.txt"

    script:
    """
    echo "Project (empty means no .git folder where the main.nf file is present): " \$(git -C ${projectDir} remote -v | head -n 1) > Run_info.txt # works only if the main script run is located in a directory that has a .git folder, i.e., that is connected to a distant repo
    echo "Git info (empty means no .git folder where the main.nf file is present): " \$(git -C ${projectDir} describe --abbrev=10 --dirty --always --tags) >> Run_info.txt # idem. Provide the small commit number of the script and nextflow.config used in the execution
    echo "Cmd line: ${workflow.commandLine}" >> Run_info.txt
    echo "execution mode": ${system_exec} >> Run_info.txt
    modules=$modules # this is just to deal with variable interpretation during the creation of the .command.sh file by nextflow. See also \$modules below
    if [[ ! -z \$modules ]] ; then
        echo "loaded modules (according to specification by the user thanks to the --modules argument of main.nf): ${modules}" >> Run_info.txt
    fi
    echo "Manifest's pipeline version: ${workflow.manifest.version}" >> Run_info.txt
    echo "result path: ${out_path}" >> Run_info.txt
    echo "nextflow version: ${nextflow.version}" >> Run_info.txt
    echo -e "\\n\\nIMPLICIT VARIABLES:\\n\\nlaunchDir (directory where the workflow is run): ${launchDir}\\nprojectDir (directory where the main.nf script is located): ${projectDir}\\nworkDir (directory where tasks temporary files are created): ${workDir}" >> Run_info.txt
    echo -e "\\n\\nUSER VARIABLES:\\n\\nout_path: ${out_path}\\nsample_path: ${sample_path}" >> Run_info.txt
    """
}
//${projectDir} nextflow variable
//${workflow.commandLine} nextflow variable
//${workflow.manifest.version} nextflow variable
//Note that variables like ${out_path} are interpreted in the script block



process slivar_extract {
    label 'slivar' // see the withLabel: bash in the nextflow config file 
    //publishDir path: "${out_path}", mode: 'copy', overwrite: false
    cache 'true'

    //no channel input here for the vcf, because I do not transform it
    input:
    file vcf
    file fun
    file annot1
    file annot2
    file ped
    val sample_expr
    val pedigree_expr
    val filter
    // see the scope for the use of affected_patients which is already a variable from .config file

    output:
    file "res.vcf" into vcf_ch1, vcf_ch2

    script:
    """
    #!/bin/bash -ue
    slivar expr --js ${fun} -g ${annot1} -g ${annot2} --vcf ${vcf} --ped ${ped} ${sample_expr} ${pedigree_expr} ${filter} -o "res.vcf"
    """
    // write ${} between "" to make a single argument when the variable is made of several values separated by a space. Otherwise, several arguments will be considered
}


process slivar_tsv {
    label 'slivar' // see the withLabel: bash in the nextflow config file 
    publishDir path: "${out_path}", mode: 'copy', overwrite: false
    cache 'true'

    //no channel input here for the vcf, because I do not transform it
    input:
    file vcf from vcf_ch1
    file ped
    val tsv_file
    val tsv_sample
    val tsv_info
    // see the scope for the use of affected_patients which is already a variable from .config file

    output:
        file "res.*" optional true


    script:
    """
    #!/bin/bash -ue
    if [[ ${tsv_file} == true ]] ; then 
        slivar tsv --ped ${ped} -s ${tsv_sample} ${tsv_info} ${vcf} > res.tsv
        gzip -f res.tsv 
    fi
    """
    // write ${} between "" to make a single argument when the variable is made of several values separated by a space. Otherwise, several arguments will be considered
}

process slivar_vcf_compress {
    label 'slivar' // see the withLabel: bash in the nextflow config file 
    publishDir path: "${out_path}", mode: 'copy', overwrite: false
    cache 'true'

    //no channel input here for the vcf, because I do not transform it
    input:
    file vcf from vcf_ch2
    // see the scope for the use of affected_patients which is already a variable from .config file

    output:
    file "res.*"


    script:
    """
    #!/bin/bash -ue
    bgzip -cf -l 9 ${vcf} > res.vcf.gz # htslib command, -l 9 best compression, -c to standard output, -f to force without asking
    tabix -p vcf res.vcf.gz # htslib command
    """
    // write ${} between "" to make a single argument when the variable is made of several values separated by a space. Otherwise, several arguments will be considered
}



process Backup {
    label 'bash' // see the withLabel: bash in the nextflow config file 
    publishDir "${out_path}/reports", mode: 'copy', overwrite: false // since I am in mode copy, all the output files will be copied into the publishDir. See \\wsl$\Ubuntu-20.04\home\gael\work\aa\a0e9a739acae026fb205bc3fc21f9b
    cache 'false'

    input:
    file config_file
    file log_file
    file fun

    output:
    file "${config_file}" // warning message if we use file config_file
    file "${log_file}" // warning message if we use file log_file
    file "${fun}" 
    file "Log_info.txt"

    script:
    """
    echo -e "full .nextflow.log is in: ${launchDir}\nThe one in the result folder is not complete (miss the end)" > Log_info.txt
    """
}


//////// end Processes
