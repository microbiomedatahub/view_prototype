import os
import glob
import pandas as pd
import numpy as np
import plotly.express as px
import re
import csv
import json

# 系統組成データのProjectsディレクトリのパス
path = '/Users/oec/Desktop/data/MDB/mdatahub/ForMDB4'

# Run:BioSampleの辞書生成
# Run: BioSample関係データ（tsv）のパス
id_relation_path = '/Users/oec/Desktop/data/MDB/mdatahub/dictionary/run2biosampl.tsv'

# 変換辞書生成
with open(id_relation_path, "r") as f:
    reader = csv.reader(f, delimiter="\t")
    l = [row for row in reader]

run2biosample_dict = {x[0]:x[1] for x in l if x[0] != "Run" }

### プロジェクト毎のデータフレーム生成

dir_names = glob.glob(path + '/*')
file_names = []
for d in dir_names:
    # ディレクトリ＝プロジェクト
    file_names.append(glob.glob(d + '/*'))

def create_df(file_name):
    df_lst = []
    df = {}
    # 最初のプロジェクトのみとりあえず書き出す（後で全件に修正する）
    for i,d in enumerate(file_name):
        # Run->BioSampleに変換
        sample_name = d.split('/')[-1].split('.')[0]
        sample_name = re.sub('_\d', '', sample_name)
        sample_name = run2biosample_dict[sample_name]
        
        # ファイルをdfに読み込む・BioSampleを組成の列のカラム名にする
        df[i] = pd.read_table(d, names=['genus',sample_name])
        # インデックス設定
        df[i] = df[i].set_index('genus', drop=True)

        # 天地
        df[i] = df[i].T
        # Todo: リード数をトータル100としてレコード毎各サンプルの値を正規化？する
        df[i] = df[i].div(df[i].sum(axis=1), axis=0).mul(100)
        df_lst.append(df[i])

    # 全サンプルをデータフレームに行方向にconcat。NaNが挿入されるので0で埋める
    df_all = pd.concat(df_lst, axis=0)
    df_all.fillna(0, inplace=True)

    # 列毎に全サンプルを加算しその値でソート
    s = df_all.sum()
    d = df_all[s.sort_values(ascending=False).index[:]]
    return d

def create_plot_json():
    for f in file_names:
        d = create_df(f)
        colors = px.colors.qualitative.T10
        # plotly
        fig = px.bar(d, 
                    x = d.index,
                    y = [c for c in d.columns],
                    template = 'ggplot2',
                    color_discrete_sequence = colors
                    )

        fig.update_layout(
        title = 'Phlogenetic compositions', 
            xaxis_title="Samples",
            yaxis_title="Composition(%)",
            legend_title="Genus",
            font=dict(
                family="sans-serif",
                size=12,
            )
        )
        fig.show()

        # jsonファイルに書き出し
        project = f[0].split('/')[-2]
        fig.write_json(f"data/mdb4_plotly/{project}_composition.json", pretty=True)


if __name__ == '__main__':
    create_plot_json()