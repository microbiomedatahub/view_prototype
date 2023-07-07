# view_prototype

InterProScanをスパコンで実行
```
#!/bin/sh
#$ -S /bin/sh
#$ -cwd
singularity exec /usr/local/biotools/i/interproscan\:5.55_88.0--hec16e2b_1 interproscan.sh -i /home/hoge/Inter/protein.faa -b /home/hoge/Inter/
```
コンテナ内に参照データが同梱されてないので上記のやり方では駄目。<br>
参照DBのディレクトリをコンテナにバインドする必要がある点に注意<br>

InterProScanの結果からGO組成に変換
```
perl ./InterPro2GOTransfer.pl protein.faa.tsv interpro2go
```

GO組成から[メタゲノムGO Slim](http://geneontology.org/docs/download-ontology/#subsets) に載っているGOのみに限定して組成計算
```
perl ./GOSlimMeta.pl protein.faa.tsv.go.tsv goslim_metagenomics.obo
```

## 国（プロジェクト）毎の系統組成データ書き出し

MDB4の系統組成データを収めたディレクトリを指定し、プロジェクトごとplotlyのstacked chart用のJSONを書き出します。
プロジェクトに含まれるrunをBioSampleに変換して表示するため、このスクリプトをそのまま使う場合run2biosampleの辞書が必要です。

```
cd plotly/taxonomic_comparison
python tsv2plotly_json.py 
```
