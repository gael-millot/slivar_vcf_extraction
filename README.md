
# slivar_vcf_extraction <a href=""><img src="figures/slivar_vcf_extraction.png" align="right" height="140" /></a>

<br />

<!-- badges: start -->

[![downloads](https://cranlogs.r-pkg.org/badges/saferDev)](https://www.rdocumentation.org/trends)
[![](https://img.shields.io/badge/license-GPL3.0-green.svg)](https://opensource.org/licenses/MITgpl-3-0)

<!-- badges: end -->

<br />


| Usage | Requirement |
| :--- | :--- |
| [![Nextflow](https://img.shields.io/badge/code-Nextflow-blue?style=plastic)](https://www.nextflow.io/) | [![Dependencies: Nextflow Version](https://img.shields.io/badge/Nextflow-v21.04.2-blue?style=plastic)](https://github.com/nextflow-io/nextflow) |
| | [![Dependencies: Apptainer Version](https://img.shields.io/badge/Apptainer-v1.2.3-blue?style=plastic)](https://github.com/apptainer/apptainer) |
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
<br /><ul><li>annotate (added in the INFO field, if -g option of slivar is used).
<br /></li><li>add familial relationship information (added in the INFO field, if --trio, --family-expr, --group-exp, --sample-expr option of slivar is used).
<br /></li><li>filter (line, i.e., variant removal, according to quality, family criteria, etc.).
</li></ul>
<br />
Return both an indexed .vcf.gz and a .tsv.gz file.

<br /><br />
## WARNINGS
<br />
<ul><li>

Use nextflow DSL1. To install DSL1 and use it when DSL2 is already installed, see these [java](https://gael-millot.github.io/protocols/docs/Protocol%20165-rev0%20JAVA.html) and [nextflow](https://gael-millot.github.io/protocols/docs/Protocol%20152-rev0%20DSL2.html#_Toc159950567) instructions. This allows to install the `nextflow-dls1` command, used below.
</li><li>

The code uses these following commands of slivar (see this [slivar](https://gael-millot.github.io/protocols/docs/Protocol%20143-rev0%20SLIVAR.html) webpage for details):

```
slivar expr --js ${fun} -g ${annot1} -g ${annot2} --vcf ${vcf} --ped ${ped} ${sample_expr} ${pedigree_expr} ${filter} -o "res.vcf"
slivar tsv --ped ${ped} -s ${tsv_sample} ${tsv_info} res.vcf > res.tsv
```
<br />
Thus, pay attention with the family_expr, sample and info parameters in the nextflow.config file.
</li></ul>

<br /><br />
## CONTENT
<br />

| Files and folder | Description |
| :--- | :--- |
| **main.nf** | File that can be executed using a linux terminal, a MacOS terminal or Windows 10 WSL2. |
| **nextflow.config** | Parameter settings for the *main.nf* file. Users have to open this file, set the desired settings and save these modifications before execution. |
| **bin folder** | Contains files required by the *main.nf* file. |
| **Licence.txt** | Licence of the release. |


<br /><br />
## INPUT
<br />

| Required files |
| :--- |
| A variant Calling Format (VCF) file (zipped or not). |
| A jason file containing functions for the slivar --family-expr option. This file is present in the *bin* folder describe above. |
| A pedigree file. |
| A Cadd annotation file. |
| A Gnomad annotation file. |

<br />

The dataset used in the *nextflow.config* file, as example, is available at https://zenodo.org/records/10723664.

<br />


| Files | Description |
| :--- | :--- |
| **example.vcf.gz** | VCF file. Available [here](https://zenodo.org/records/10723664/files/example.vcf.gz). |
| **pedigree.txt** | Pedigree file. Available [here](https://zenodo.org/records/10723664/files/pedigree.txt?download=1). |
| **cadd-1.6-SNVs-phred10-GRCh37.zip** | Cadd variant annotation v1.6 filtered at phred10. Available [here](https://zenodo.org/records/10723664/files/cadd-1.6-SNVs-phred10-GRCh37.zip). |
| **gnomad-2.1.1-genome-GRCh37.zip** | Gnomad variant annotation v2.1.1. Available [here](https://zenodo.org/records/10723664/files/gnomad-2.1.1-genome-GRCh37.zip). |


<br /><br />
## HOW TO RUN

### 1. Prerequisite

Installation of:<br />
[nextflow DSL1](https://gael-millot.github.io/protocols/docs/Protocol%20152-rev0%20DSL2.html#_Toc159933765)<br />
[Graphviz](https://www.graphviz.org/download/), `sudo apt install graphviz` for Linux ubuntu<br />
[Apptainer](https://gael-millot.github.io/protocols/docs/Protocol%20135-rev0%20APPTAINER.html#_Toc160091693)<br />


### 2. Local running (personal computer)


####	2.1. *main.nf* file in the personal computer

- Mount a server if required:

```
DRIVE="Z" # change the letter to fit the correct drive
sudo mkdir /mnt/share
sudo mount -t drvfs $DRIVE: /mnt/share
```

Warning: if no mounting, it is possible that nextflow does nothing, or displays a message like:
<pre>
Launching `main.nf` [loving_morse] - revision: d5aabe528b
/mnt/share/Users
</pre>

- Run the following command from where the *main.nf* and *nextflow.config* files are (example: \\wsl$\Ubuntu-20.04\home\gael):

```
nextflow-dsl1 run main.nf -c nextflow.config
```

with -c to specify the name of the config file used.


#### 2.2.	*main.nf* file in the public git repository

Run the following command from where you want the results:

```
nextflow-dsl1 run gael-millot/slivar_vcf_extraction # github, or nextflow-dsl1 run http://github.com/gael-millot/slivar_vcf_extraction
nextflow-dsl1 run -hub pasteur gmillot/slivar_vcf_extraction -r v1.0.0 # gitlab
```


### 3. Distant running (example with the Pasteur cluster)

####	3.1. Pre-execution

Copy-paste this after having modified the EXEC_PATH variable:

```
EXEC_PATH="/pasteur/helix/projects/BioIT/gmillot/slivar_vcf_extraction" # where the bin folder of the main.nf script is located
export CONF_BEFORE=/opt/gensoft/exe # on maestro

export JAVA_CONF=java/13.0.2
export JAVA_CONF_AFTER=bin/java # on maestro
export APP_CONF=apptainer/1.3.5
export APP_CONF_AFTER=bin/apptainer # on maestro
export GIT_CONF=git/2.39.1
export GIT_CONF_AFTER=bin/git # on maestro
export GRAPHVIZ_CONF=graphviz/2.42.3
export GRAPHVIZ_CONF_AFTER=bin/graphviz # on maestro

MODULES="${CONF_BEFORE}/${JAVA_CONF}/${JAVA_CONF_AFTER},${CONF_BEFORE}/${APP_CONF}/${APP_CONF_AFTER},${CONF_BEFORE}/${GIT_CONF}/${GIT_CONF_AFTER}/${GRAPHVIZ_CONF}/${GRAPHVIZ_CONF_AFTER}"
cd ${EXEC_PATH}
chmod 755 ${EXEC_PATH}/bin/*.*
module load ${JAVA_CONF} ${APP_CONF} ${GIT_CONF} ${GRAPHVIZ_CONF}
```


####	3.2. *main.nf* file in a cluster folder

Modify the second line of the code below, and run from where the *main.nf* and *nextflow.config* files are (which has been set thanks to the EXEC_PATH variable above):

```
HOME_INI=$HOME
HOME="${HELIXHOME}/slivar_vcf_extraction/" # $HOME changed to allow the creation of .nextflow into /$HELIXHOME/slivar_vcf_extraction/, for instance. See NFX_HOME in the nextflow software script
nextflow-dsl1 run --modules ${MODULES} main.nf -c nextflow.config
HOME=$HOME_INI
```


####	3.3. *main.nf* file in the public git repository

Modify the first and third lines of the code below, and run (results will be where the EXEC_PATH variable has been set above):

```
VERSION="v1.0"
HOME_INI=$HOME
HOME="${HELIXHOME}/slivar_vcf_extraction/" # $HOME changed to allow the creation of .nextflow into /$HELIXHOME/slivar_vcf_extraction/, for instance. See NFX_HOME in the nextflow software script
nextflow-dsl1 run --modules ${MODULES} gael-millot/slivar_vcf_extraction -r $VERSION -c $HOME/nextflow.config #github, or nextflow-dsl1 run --modules ${MODULES} http://github.com/gael-millot/slivar_vcf_extraction -r $VERSION -c $HOME/nextflow.config
nextflow-dsl1 run --modules ${MODULES} -hub pasteur gmillot/slivar_vcf_extraction -r $VERSION -c $HOME/nextflow.config # gitlab
HOME=$HOME_INI
```


### 4. Error messages and solutions

####	Message 1
<pre>
Unknown error accessing project `gmillot/slivar_vcf_extraction` -- Repository may be corrupted: /pasteur/sonic/homes/gmillot/.nextflow/assets/gmillot/slivar_vcf_extraction
</pre>

Purge using:
```
rm -rf /pasteur/sonic/homes/gmillot/.nextflow/assets/gmillot*
```

####	Message 2
<pre>
WARN: Cannot read project manifest -- Cause: Remote resource not found: https://gitlab.pasteur.fr/api/v4/projects/gmillot%2Fslivar_vcf_extraction
</pre>

Contact Gael Millot (distant repository is not public).

####	Message 3
<pre>
permission denied
</pre>

Use chmod to change the user rights. Example linked to files in the bin folder: 
```
chmod 755 bin/*.*
```


<br /><br />
## OUTPUT

An example of results obtained with the dataset is present at this address: https://zenodo.org/records/10723664/files/slivar_vcf_extraction_1709139998.zip
<br /><br />
| Files and folder | Description |
| :--- | :--- |
| **reports** | folder containing all the reports of the different processes including the *nextflow.config* file used. |
| **res.vcf.gz** | annotated and filtered VCF file. |
| **res.vcf.gz.tbi** | Index file of *res.vcf.gz*. |
| **res.tsv.gz** | VCF file converted into a table, each row representing a different variant and a different patient. Columns description (depending on the tsv_info parameter): <br /><ul><li>mode: slivar info: filtering operated.<br /></li><li>family_id: ID of the family.<br /></li><li>sample_id: code of the patient.<br /></li><li>chr:pos:ref:alt: chromosome, position (in bp), reference allele, alternative allele.<br /></li><li>genotype(sample,dad,mom): 1: , .:no info.<br /></li><li>AC: allele count in genotypes, for each ALT allele, in the same order as listed.<br /></li><li>AF: allele Frequency, for each ALT allele, in the same order as listed.<br /></li><li>AN: total number of alleles in called genotypes.<br /></li><li>BaseQRankSum: Z-score from Wilcoxon rank sum test of Alt Vs. Ref base qualities.<br /></li><li>DB: dbSNP Membership.<br /></li><li>DP: Approximate read depth; some reads may have been filtered.<br /></li><li>ExcessHet: P hred-scaled p-value for exact test of excess heterozygosity.<br /></li><li>FS: Phred-scaled p-value using Fisher's exact test to detect strand bias.<br /></li><li>InbreedingCoeff: Inbreeding coefficient as estimated from the genotype likelihoods per-sample when compared against the Hardy-Weinberg expectation.<br /></li><li>MLEAC: Maximum likelihood expectation (MLE) for the allele counts (not necessarily the same as the AC), for each ALT allele, in the same order as listed.<br /></li><li>MLEAF: Maximum likelihood expectation (MLE) for the allele frequency (not necessarily the same as the AF), for each ALT allele, in the same order as listed.<br /></li><li>MQ: RMS Mapping Quality.<br /></li><li>MQRankSum: Z-score From Wilcoxon rank sum test of Alt vs. Ref read mapping qualities.<br /></li><li>QD: Variant Confidence/Quality by Depth.<br /></li><li>ReadPosRankSum: Z-score from Wilcoxon rank sum test of Alt vs. Ref read position bias.<br /></li><li>SOR: Symmetric Odds Ratio of 2x2 contingency table to detect strand bias.<br /></li><li>VQSLOD: Log odds of being a true variant versus being false under the trained gaussian mixture model.<br /></li><li>culprit: The annotation which was the worst performing in the Gaussian mixture model, likely the reason why the variant was filtered out.<br /></li><li>CSQ: Consequence annotations from Ensembl VEP. See the VCF file header for the subfield descriptions.<br /></li><li>cadd_phred: CAAD_PHRED from VEP Genome anNOTATion (gnotate),i.e.,  cadd_phred field from the VCF file.<br /></li><li>gno_non_neuro_af_all: gnomad non neuro affected all, i.e., gno_non_neuro_af_all field of the VCF file.<br /></li><li>gno_non_neuro_af_nfe: gnomad non neuro affected non finnish, i.e., gno_non_neuro_af_all field of the VCF file.<br /></li><li>gno_non_neuro_nhomalt_all: gnomad non neuro number of homozygous alternative all, i.e., gno_non_neuro_nhomalt_all field of the VCF file.<br /></li><li>gno_non_neuro_nhomalt_nfe: gnomad non neuro number of homozygous alternative non finnish, i.e., gno_non_neuro_nhomalt_nfe field of the VCF file.<br /></li><li>highest_impact_order: impact order (lower is higher) of this variant across all genes and transcripts it overlaps. this integer can be used as a look into the order list to get the actual impact.<br /></li><li>aff_only: Affected patient codes.<br /></li><li>depths(sample,dad,mom): slivar info.<br /></li><li>allele_balance(sample,dad,mom): slivar info.</li> |


<br /><br />
## VERSIONS


The different releases are tagged [here](https://github.com/gael-millot/slivar_vcf_extraction/tags)

<br /><br />
## LICENCE


This package of scripts can be redistributed and/or modified under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
Distributed in the hope that it will be useful, but without any warranty; without even the implied warranty of merchandability or fitness for a particular purpose.
See the GNU General Public License for more details at https://www.gnu.org/licenses or in the Licence.txt attached file.

<br /><br />
## CITATION


Not yet published


<br /><br />
## CREDITS


[Freddy Cliquet](https://gitlab.pasteur.fr/fcliquet), GHFC, Institut Pasteur, Paris, France

[Gael A. Millot](https://github.com/gael-millot), Hub, Institut Pasteur, Paris, France

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

### 2.5

- In the nextflow.config file, downgrade apptainer -> singularity because does not work otherwise.


### 2.4

- In the nextflow.config file, upgrade singularity -> apptainer.


### v2.3

- Dataset and results are in zenodo.
- Transfert into github.


### v2.2

README improved.


### v2.0

Compression added, tsv file optional


### v1.0

Everything





