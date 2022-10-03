[//]: # "#to make links in gitlab: example with racon https://github.com/isovic/racon"
[//]: # "tricks in markdown: https://openclassrooms.com/fr/courses/1304236-redigez-en-markdown"

| usage | dependencies |
| --- | --- |
| [![Nextflow](https://img.shields.io/badge/code-Nextflow-blue?style=plastic)](https://www.nextflow.io/) | [![Dependencies: Nextflow Version](https://img.shields.io/badge/Nextflow-v21.04.2-blue?style=plastic)](https://github.com/nextflow-io/nextflow) |
| [![License: GPL-3.0](https://img.shields.io/badge/licence-GPL%20(%3E%3D3)-green?style=plastic)](https://www.gnu.org/licenses) | |

<br /><br />
## TABLE OF CONTENTS


   - [AIM](#aim)
   - [CONTENT](#content)
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
<br /><ul><li>annotate
<br /></li><li>filter (according to quality, family criteria, ect.)
</li><br /><br />
Return both an indexed .vcf.gz and a .tsv.gz file
<br /><br />
Warning: the code uses these following commands of slivar (see protocol 143 for details):

```bash
    slivar expr --js ${fun} -g ${annot1} -g ${annot2} --vcf ${vcf} --ped ${ped} ${sample_expr} ${pedigree_expr} ${filter} -o "res.vcf"
    slivar tsv --ped ${ped} -s ${tsv_sample} ${tsv_info} res.vcf > res.tsv
```

Thus, pay attention with the family_expr, sample and info parameters in the slivar_vcf_extraction.config file.

<br /><br />
## CONTENT

**slivar_vcf_extraction.nf** File that can be executed using a CLI (command line interface)

**slivar_vcf_extraction.config** Parameter settings for the slivar_vcf_extraction.nf file

**dataset** Folder containing some datasets than can be used as examples

| File | Description |
| --- | --- |
| **Dyslexia.gatk-vqsr.splitted.norm.vep.merged_first_10000.vcf.gz** | First 10,000 lines of /pasteur/zeus/projets/p02/ghfc_wgs_zeus/WGS/Dyslexia/vcf/Dyslexia.gatk-vqsr.splitted.norm.vep.merged.vcf.gz |
| **Dyslexia.pedigree.txt** | Pedigree associated to Dyslexia.gatk-vqsr.splitted.norm.vep.merged.vcf.gz |
| **cadd-1.6-SNVs-phred10-GRCh37.zip** | cadd variant annotation v1.6 filtered at phred10, downloaded from /pasteur/zeus/projets/p02/ghfc_wgs_zeus/references/GRCh37 |
| **gnomad-2.1.1-genome-GRCh37.zip** | gnomad variant annotation v2.1.1, downloaded from /pasteur/zeus/projets/p02/ghfc_wgs_zeus/references/GRCh37 |


**example_of_results**: folder containing examples of result obtained with the dataset.
<br /><br />
&nbsp;&nbsp;&nbsp;&nbsp;Two folders are present:
<br />
| File | Description |
| --- | --- |
| **PL_family_WGS_slivar_1664813804** | example of filtering and annotation, obtained using the whole dataset sample_path="/pasteur/zeus/projets/p02/ghfc_wgs_zeus/WGS/Dyslexia/vcf/Dyslexia.gatk-vqsr.splitted.norm.vep.merged.vcf.gz" |
| **PL_family_WGS_slivar_1664807682** | example of annotation without slivar filtering, obtained using the example dataset sample_path="/mnt/c/Users/Gael/Documents/Git_projects/slivar_vcf_extraction/dataset/Dyslexia.gatk-vqsr.splitted.norm.vep.merged_first_10.vcf" |

&nbsp;&nbsp;&nbsp;&nbsp;See the OUTPUT section for the description of the folder and files.

<br /><br />
## HOW TO RUN

See Protocol 136 (ask me).


### If error message

If an error message appears, like:
```
Unknown error accessing project `gmillot/08002_bourgeron` -- Repository may be corrupted: /pasteur/sonic/homes/gmillot/.nextflow/assets/gmillot/08002_bourgeron
```
Purge using:
```
rm -rf /pasteur/sonic/homes/gmillot/.nextflow/assets/gmillot*
```


### From local using the committed version on gitlab

1) Create the scm file:

```bash
providers {
    pasteur {
        server = 'https://gitlab.pasteur.fr'
        platform = 'gitlab'
    }
}
```

And save it as 'scm' in the .nextflow folder. For instance in:
\\wsl$\Ubuntu-20.04\home\gael\.nextflow

Warning: ssh key must be set for gitlab, to be able to use this procedure (see protocol 44).


2) Mount a server if required:

```bash
DRIVE="C"
sudo mkdir /mnt/share
sudo mount -t drvfs $DRIVE: /mnt/share
```

Warning: if no mounting, it is possible that nextflow does nothing, or displays a message like
```
Launching `slivar_vcf_extraction.nf` [loving_morse] - revision: d5aabe528b
/mnt/share/Users
```


3) Then run the following command from here \\wsl$\Ubuntu-20.04\home\gael:

```bash
nextflow run -hub pasteur gmillot/slivar_vcf_extraction -r v1.0.0
```


4) If an error message appears, like:
```
WARN: Cannot read project manifest -- Cause: Remote resource not found: https://gitlab.pasteur.fr/api/v4/projects/gmillot%2Fslivar_vcf_extraction
```
Make the distant repo public


5) If an error message appears, like:

```
permission denied
```

See chmod in protocol 44.


### From local using local file

Like above but then run the following command from here \\wsl$\Ubuntu-20.04\home\gael:

```bash
nextflow run slivar_vcf_extraction.nf -c slivar_vcf_extraction.config
```

with -c to specify the name of the config file used.


### From a cluster using a committed version on gitlab

Start with:

```bash
EXEC_PATH="/pasteur/zeus/projets/p01/BioIT/gmillot/08002_bourgeron" # where the bin folder of the slivar_vcf_extraction.nf script is located
export CONF_BEFORE=/opt/gensoft/exe # on maestro

export JAVA_CONF=java/13.0.2
export JAVA_CONF_AFTER=bin/java # on maestro
export SINGU_CONF=singularity/3.8.3
export SINGU_CONF_AFTER=bin/singularity # on maestro
export GIT_CONF=git/2.25.0
export GIT_CONF_AFTER=bin/git # on maestro

MODULES="${CONF_BEFORE}/${JAVA_CONF}/${JAVA_CONF_AFTER},${CONF_BEFORE}/${SINGU_CONF}/${SINGU_CONF_AFTER},${CONF_BEFORE}/${GIT_CONF}/${GIT_CONF_AFTER}"
cd ${EXEC_PATH}
chmod 755 ${EXEC_PATH}/bin/*.*
module load ${JAVA_CONF} ${SINGU_CONF} ${GIT_CONF}

```

Then run:

```bash
# distant slivar_vcf_extraction.nf file
HOME="$ZEUSHOME/08002_bourgeron/" ; nextflow run --modules ${MODULES} -hub pasteur gmillot/slivar_vcf_extraction -r v7.10.0 -c $HOME/slivar_vcf_extraction.config ; HOME="/pasteur/appa/homes/gmillot/"

# local slivar_vcf_extraction.nf file ($HOME changed to allow the creation of .nextflow into /$ZEUSHOME/08002_bourgeron/. See NFX_HOME in the nextflow soft script)
HOME="$ZEUSHOME/08002_bourgeron/" ; nextflow run --modules ${MODULES} slivar_vcf_extraction.nf -c slivar_vcf_extraction.config ; HOME="/pasteur/appa/homes/gmillot/"
```

If an error message appears, like:
```
Unknown error accessing project `gmillot/08002_bourgeron` -- Repository may be corrupted: /pasteur/sonic/homes/gmillot/.nextflow/assets/gmillot/08002_bourgeron
```
Purge using:
```
rm -rf /pasteur/sonic/homes/gmillot/.nextflow/assets/gmillot*
```

<br /><br />
## OUTPUT


**reports**: folder containing all the reports of the different processes including the *slivar_vcf_extraction.config* file used.
<br /><br />
**res.vcf.gz**: annotated and filtered VCF file
<br /><br />
**res.tsv.gz**: VCF file converted into a table, each row representing a different variant and a different patient, and with columns (depending on the tsv_info parameter):
<br />

| File | Description |
| --- | --- |
| **mode** | slivar info: filtering operated |
| **family_id** | ID of the family |
| **sample_id** | code of the patient |
| **chr:pos:ref:alt** | chromosome, position (in bp), reference allele, alternative allele |
| **genotype(sample,dad,mom)** | 1: , .:no info |
| **AC** | allele count in genotypes, for each ALT allele, in the same order as listed |
| **AF** | allele Frequency, for each ALT allele, in the same order as listed |
| **AN** | total number of alleles in called genotypes |
| **BaseQRankSum** | Z-score from Wilcoxon rank sum test of Alt Vs. Ref base qualities |
| **DB** | dbSNP Membership |
| **DP** | Approximate read depth; some reads may have been filtered |
| **ExcessHet** |P hred-scaled p-value for exact test of excess heterozygosity |
| **FS** | Phred-scaled p-value using Fisher's exact test to detect strand bias |
| **InbreedingCoeff** | Inbreeding coefficient as estimated from the genotype likelihoods per-sample when compared against the Hardy-Weinberg expectation |
| **MLEAC** | Maximum likelihood expectation (MLE) for the allele counts (not necessarily the same as the AC), for each ALT allele, in the same order as listed |
| **MLEAF** | Maximum likelihood expectation (MLE) for the allele frequency (not necessarily the same as the AF), for each ALT allele, in the same order as listed |
| **MQ** | RMS Mapping Quality |
| **MQRankSum** | Z-score From Wilcoxon rank sum test of Alt vs. Ref read mapping qualities |
| **QD** | Variant Confidence/Quality by Depth |
| **ReadPosRankSum** | Z-score from Wilcoxon rank sum test of Alt vs. Ref read position bias |
| **SOR** | Symmetric Odds Ratio of 2x2 contingency table to detect strand bias |
| **VQSLOD** | Log odds of being a true variant versus being false under the trained gaussian mixture model |
| **culprit** | The annotation which was the worst performing in the Gaussian mixture model, likely the reason why the variant was filtered out |
| **CSQ** | Consequence annotations from Ensembl VEP. See the VCF file header for the subfield descriptions |
| **cadd_phred** | CAAD_PHRED from VEP genome annotation (gnotate),i.e.,  cadd_phred field from the VCF file |
| **gno_non_neuro_af_all** | gnomad non neuro affected all, i.e., gno_non_neuro_af_all field of the VCF file |
| **gno_non_neuro_af_nfe** | gnomad non neuro affected non finnish, i.e., gno_non_neuro_af_all field of the VCF file |
| **gno_non_neuro_nhomalt_all** | gnomad non neuro number of homozygous alternative all, i.e., gno_non_neuro_nhomalt_all field of the VCF file |
| **gno_non_neuro_nhomalt_nfe** | gnomad non neuro number of homozygous alternative non finnish, i.e., gno_non_neuro_nhomalt_nfe field of the VCF file |
| **highest_impact_order** | impact order (lower is higher) of this variant across all genes and transcripts it overlaps. this integer can be used as a look into the order list to get the actual impact |
| **aff_only** | Affected patient codes |
| **depths(sample,dad,mom)** | slivar info:  |
| **allele_balance(sample,dad,mom)** | slivar info:  |


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

[Gael A. Millot](https://gitlab.pasteur.fr/gmillot), Hub-CBD, Institut Pasteur, Paris, France

<br /><br />
## ACKNOWLEDGEMENTS


The mentioned softwares and packages developers & maintainers

Gitlab developers

<br /><br />
## WHAT'S NEW IN


### v2.0

Compression added, tsv file optional


### v1.0

Everything




