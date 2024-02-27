| Usage | Requirement |
| --- | --- |
| [![Nextflow](https://img.shields.io/badge/code-Nextflow-blue?style=plastic)](https://www.nextflow.io/) | [![Dependencies: Nextflow Version](https://img.shields.io/badge/Nextflow-v21.04.2-blue?style=plastic)](https://github.com/nextflow-io/nextflow) |
| [![License: GPL-3.0](https://img.shields.io/badge/licence-GPL%20(%3E%3D3)-green?style=plastic)](https://www.gnu.org/licenses) | [![Dependencies: Apptainer Version](https://img.shields.io/badge/Apptainer-v1.2.3-blue?style=plastic)](https://github.com/apptainer/apptainer) |
| | [![Dependencies: Graphviz Version](https://img.shields.io/badge/Graphviz-v2.42.2-blue?style=plastic)](https://www.graphviz.org/download/) |


<br /><br />
## TABLE OF CONTENTS


   - [AIM](#aim)
   - [WARNING](#warning)
   - [CONTENT](#content)
   - [INPUT](#input)
   - [HOW TO RUN](#how-to-run)
   - [OUTPUT](#output)
   - [VERSIONS](#versions)
   - [LICENCE](#licence)
   - [CITATION](#citation)
   - [CREDITS](#credits)
   - [ACKNOWLEDGEMENTS](#Acknowledgements)
   - [WHAT'S NEW IN](#what's-new-in)

<br /><br />
## AIM

Use [slivar](https://github.com/brentp/slivar) on a VCF file to:
<br /><ul><li>annotate.
<br /></li><li>filter (according to quality, family criteria, ect.).
</li><br />
Return both an indexed .vcf.gz and a .tsv.gz file.

<br /><br />
## WARNINGS

- Use nextflow DSL1. To install DSL1 and use it when DSL2 is already installed:




- The code uses these following commands of slivar (see protocol 143 for details, contact Gael Millot):

<pre>
slivar expr --js ${fun} -g ${annot1} -g ${annot2} --vcf ${vcf} --ped ${ped} ${sample_expr} ${pedigree_expr} ${filter} -o "res.vcf"
slivar tsv --ped ${ped} -s ${tsv_sample} ${tsv_info} res.vcf > res.tsv
</pre>

Thus, pay attention with the family_expr, sample and info parameters in the nextflow.config file.

<br /><br />
## CONTENT

| slivar_vcf_extraction folder | Description |
| --- | --- |
| **main.nf** | File that can be executed using a linux terminal, a MacOS terminal or Windows 10 WSL2. |
| **nextflow.config** | Parameter settings for the *main.nf* file. Users have to open this file, set the desired settings and save these modifications before execution. |
| **bin folder** | Contains the *slivar-functions.js* file that need to be set by the user before running. |

<br /><br />
## INPUT

| Required files |
| --- |
| Variant Calling Format (VCF) file (zipped or not). |
| Jason file containing functions for the slivar --family-expr option. This file is present in the *bin* folder describe above. |
| Pedigree file. |
| Cadd annotation file. |
| Gnomad annotation file1. |

<br /><br />
The dataset used in the *nextflow.config* file, as example, is available at https://zenodo.org/records/10075643/files/slivar_vcf_extraction.zip


| Dataset folder | Description |
| --- | --- |
| **Dyslexia.gatk-vqsr.splitted.norm.vep.merged_first_10000.vcf.gz** | VCF file. |
| **Dyslexia.pedigree.txt** | Pedigree file. |
| **cadd-1.6-SNVs-phred10-GRCh37.zip** | Cadd variant annotation v1.6 filtered at phred10. |
| **gnomad-2.1.1-genome-GRCh37.zip** | Gnomad variant annotation v2.1.1. |


<br /><br />
## HOW TO RUN

### 1. Prerequisite

Installation of:<br />
[nextflow DSL2](https://github.com/nextflow-io/nextflow)<br />
[Graphviz](https://www.graphviz.org/download/), `sudo apt install graphviz` for Linux ubuntu<br />
[Apptainer](https://github.com/apptainer/apptainer)<br />

<br /><br />
### 2. Local running (personal computer)


#### 2.1. *main.nf* file in the personal computer

- Mount a server if required:

<pre>
DRIVE="Z" # change the letter to fit the correct drive
sudo mkdir /mnt/share
sudo mount -t drvfs $DRIVE: /mnt/share
</pre>

Warning: if no mounting, it is possible that nextflow does nothing, or displays a message like:
<pre>
Launching `main.nf` [loving_morse] - revision: d5aabe528b
/mnt/share/Users
</pre>

- Run the following command from where the *main.nf* and *nextflow.config* files are (example: \\wsl$\Ubuntu-20.04\home\gael):

<pre>
nextflow run main.nf -c nextflow.config
</pre>

with -c to specify the name of the config file used.

<br /><br />
#### 2.3. *main.nf* file in the public gitlab repository

Run the following command from where you want the results:

<pre>
nextflow run -hub pasteur gmillot/slivar_vcf_extraction -r v1.0.0
</pre>

<br /><br />
### 3. Distant running (example with the Pasteur cluster)

#### 3.1. Pre-execution

Copy-paste this after having modified the EXEC_PATH variable:

<pre>
EXEC_PATH="/pasteur/zeus/projets/p01/BioIT/gmillot/slivar_vcf_extraction" # where the bin folder of the main.nf script is located
export CONF_BEFORE=/opt/gensoft/exe # on maestro

export JAVA_CONF=java/13.0.2
export JAVA_CONF_AFTER=bin/java # on maestro
export APP_CONF=apptainer/1.2.3
export APP_CONF_AFTER=bin/apptainer # on maestro
export GIT_CONF=git/2.39.1
export GIT_CONF_AFTER=bin/git # on maestro
export GRAPHVIZ_CONF=graphviz/2.42.3
export GRAPHVIZ_CONF_AFTER=bin/graphviz # on maestro

MODULES="${CONF_BEFORE}/${JAVA_CONF}/${JAVA_CONF_AFTER},${CONF_BEFORE}/${APP_CONF}/${APP_CONF_AFTER},${CONF_BEFORE}/${GIT_CONF}/${GIT_CONF_AFTER}/${GRAPHVIZ_CONF}/${GRAPHVIZ_CONF_AFTER}"
cd ${EXEC_PATH}
chmod 755 ${EXEC_PATH}/bin/*.* # not required if no bin folder
module load ${JAVA_CONF} ${APP_CONF} ${GIT_CONF} ${GRAPHVIZ_CONF}
</pre>

<br /><br />
#### 3.2. *main.nf* file in a cluster folder

Modify the second line of the code below, and run from where the *main.nf* and *nextflow.config* files are (which has been set thanks to the EXEC_PATH variable above):

<pre>
HOME_INI=$HOME
HOME="${ZEUSHOME}/slivar_vcf_extraction/" # $HOME changed to allow the creation of .nextflow into /$ZEUSHOME/slivar_vcf_extraction/, for instance. See NFX_HOME in the nextflow software script
trap '' SIGINT
nextflow run --modules ${MODULES} main.nf -c nextflow.config
HOME=$HOME_INI
trap SIGINT
</pre>

<br /><br />
#### 3.3. *main.nf* file in the public gitlab repository

Modify the first and third lines of the code below, and run (results will be where the EXEC_PATH variable has been set above):

<pre>
VERSION="v1.0"
HOME_INI=$HOME
HOME="${ZEUSHOME}/slivar_vcf_extraction/" # $HOME changed to allow the creation of .nextflow into /$ZEUSHOME/slivar_vcf_extraction/, for instance. See NFX_HOME in the nextflow software script
trap '' SIGINT
nextflow run --modules ${MODULES} -hub pasteur gmillot/slivar_vcf_extraction -r $VERSION -c $HOME/nextflow.config
HOME=$HOME_INI
trap SIGINT
</pre>

<br /><br />
### 4. Error messages and solutions

#### Message 1
```
Unknown error accessing project `gmillot/slivar_vcf_extraction` -- Repository may be corrupted: /pasteur/sonic/homes/gmillot/.nextflow/assets/gmillot/slivar_vcf_extraction
```

Purge using:
<pre>
rm -rf /pasteur/sonic/homes/gmillot/.nextflow/assets/gmillot*
</pre>

#### Message 2
```
WARN: Cannot read project manifest -- Cause: Remote resource not found: https://gitlab.pasteur.fr/api/v4/projects/gmillot%2Fslivar_vcf_extraction
```

Contact Gael Millot (distant repository is not public).

#### Message 3

```
permission denied
```

Use chmod to change the user rights. Example linked to files in the bin folder: 
```
chmod 755 bin/*.*
```


<br /><br />
## OUTPUT

An example of results obtained with the dataset is present at this address: https://zenodo.org/records/10075643/files/slivar_vcf_extraction.zip
<br /><br />
&nbsp;&nbsp;&nbsp;&nbsp;Two folders are present:
<br />
| File | Description |
| --- | --- |
| **PL_family_WGS_slivar_1664813804** | example of filtering and annotation, obtained using the whole dataset Dyslexia.gatk-vqsr.splitted.norm.vep.merged.vcf.gz |
| **PL_family_WGS_slivar_1664807682** | example of annotation without slivar filtering, obtained using the example dataset Dyslexia.gatk-vqsr.splitted.norm.vep.merged_first_10.vcf |

<br /><br />
In each folder:
<br />
| File | Description |
| --- | --- |
| **reports** | folder containing all the reports of the different processes including the *nextflow.config* file used.
| **res.vcf.gz** | annotated and filtered VCF file
| **res.tsv.gz** | VCF file converted into a table, each row representing a different variant and a different patient. Columns description (depending on the tsv_info parameter): <br /><ul><li>mode: slivar info: filtering operated.<br /></li><li>family_id: ID of the family.<br /></li><li>sample_id: code of the patient.<br /></li><li>chr:pos:ref:alt: chromosome, position (in bp), reference allele, alternative allele.<br /></li><li>genotype(sample,dad,mom): 1: , .:no info.<br /></li><li>AC: allele count in genotypes, for each ALT allele, in the same order as listed.<br /></li><li>AF: allele Frequency, for each ALT allele, in the same order as listed.<br /></li><li>AN: total number of alleles in called genotypes.<br /></li><li>BaseQRankSum: Z-score from Wilcoxon rank sum test of Alt Vs. Ref base qualities.<br /></li><li>DB: dbSNP Membership.<br /></li><li>DP: Approximate read depth; some reads may have been filtered.<br /></li><li>ExcessHet: P hred-scaled p-value for exact test of excess heterozygosity.<br /></li><li>FS: Phred-scaled p-value using Fisher's exact test to detect strand bias.<br /></li><li>InbreedingCoeff: Inbreeding coefficient as estimated from the genotype likelihoods per-sample when compared against the Hardy-Weinberg expectation.<br /></li><li>MLEAC: Maximum likelihood expectation (MLE) for the allele counts (not necessarily the same as the AC), for each ALT allele, in the same order as listed.<br /></li><li>MLEAF: Maximum likelihood expectation (MLE) for the allele frequency (not necessarily the same as the AF), for each ALT allele, in the same order as listed.<br /></li><li>MQ: RMS Mapping Quality.<br /></li><li>MQRankSum: Z-score From Wilcoxon rank sum test of Alt vs. Ref read mapping qualities.<br /></li><li>QD: Variant Confidence/Quality by Depth.<br /></li><li>ReadPosRankSum: Z-score from Wilcoxon rank sum test of Alt vs. Ref read position bias.<br /></li><li>SOR: Symmetric Odds Ratio of 2x2 contingency table to detect strand bias.<br /></li><li>VQSLOD: Log odds of being a true variant versus being false under the trained gaussian mixture model.<br /></li><li>culprit: The annotation which was the worst performing in the Gaussian mixture model, likely the reason why the variant was filtered out.<br /></li><li>CSQ: Consequence annotations from Ensembl VEP. See the VCF file header for the subfield descriptions.<br /></li><li>cadd_phred: CAAD_PHRED from VEP genome annotation (gnotate),i.e.,  cadd_phred field from the VCF file.<br /></li><li>gno_non_neuro_af_all: gnomad non neuro affected all, i.e., gno_non_neuro_af_all field of the VCF file.<br /></li><li>gno_non_neuro_af_nfe: gnomad non neuro affected non finnish, i.e., gno_non_neuro_af_all field of the VCF file.<br /></li><li>gno_non_neuro_nhomalt_all: gnomad non neuro number of homozygous alternative all, i.e., gno_non_neuro_nhomalt_all field of the VCF file.<br /></li><li>gno_non_neuro_nhomalt_nfe: gnomad non neuro number of homozygous alternative non finnish, i.e., gno_non_neuro_nhomalt_nfe field of the VCF file.<br /></li><li>highest_impact_order: impact order (lower is higher) of this variant across all genes and transcripts it overlaps. this integer can be used as a look into the order list to get the actual impact.<br /></li><li>aff_only: Affected patient codes.<br /></li><li>depths(sample,dad,mom): slivar info: .<br /></li><li>allele_balance(sample,dad,mom): slivar info</li> |
| **res.vcf.gz.tbi** | Index file of *res.tsv.gz*. |

<br /><br />
## VERSIONS


The different releases are tagged [here](https://gitlab.pasteur.fr/gmillot/slivar_vcf_extraction/-/tags)

<br /><br />
## LICENCE


This package of scripts can be redistributed and/or modified under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
Distributed in the hope that it will be useful, but without any warranty; without even the implied warranty of merchandability or fitness for a particular purpose.
See the GNU General Public License for more details at https://www.gnu.org/licenses.

<br /><br />
## CITATION


Not yet published


<br /><br />
## CREDITS


[Freddy Cliquet](https://gitlab.pasteur.fr/fcliquet), GHFC, Institut Pasteur, Paris, France

[Gael A. Millot](https://gitlab.pasteur.fr/gmillot), Hub, Institut Pasteur, Paris, France

<br /><br />
## ACKNOWLEDGEMENTS


The developers & maintainers of the mentioned softwares and packages, including:

- [Slivar](https://github.com/brentp/slivar)
- [Nextflow](https://www.nextflow.io/)
- [Apptainer](https://apptainer.org/)
- [Docker](https://www.docker.com/)
- [Gitlab](https://about.gitlab.com/)
- [Bash](https://www.gnu.org/software/bash/)
- [Ubuntu](https://ubuntu.com/)

Special acknowledgement to [Brent Pedersen](https://github.com/brentp), Utrecht, The Netherlands, for the release of [slivar](https://github.com/brentp/slivar).

<br /><br />
## WHAT'S NEW IN

### v2.2

README improved. Dataset and results are in zenodo


### v2.0

Compression added, tsv file optional


### v1.0

Everything





