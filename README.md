# view_prototype

InterProScanをスパコンで実行
```
#!/bin/sh
#$ -S /bin/sh
#$ -cwd
singularity exec /usr/local/biotools/i/interproscan\:5.55_88.0--hec16e2b_1 interproscan.sh -i /home/hoge/Inter/protein.faa -b /home/hoge/Inter/
```
InterProScanの結果からGO組成に変換
```
perl ./InterPro2GOTransfer.pl protein.faa.tsv interpro2go
```

GO組成から[メタゲノムGO Slim](http://geneontology.org/docs/download-ontology/#subsets) に載っているGOのみに限定して組成計算
```
perl ./GOSlimMeta.pl protein.faa.tsv.go.tsv goslim_metagenomics.obo
```
