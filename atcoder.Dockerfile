# 以下のサイトを参考:https://qiita.com/hinamimi/items/b3dd159f956628cebdbb

# Ubuntuの公式コンテナを軸とする．
FROM ubuntu

# インタラクティブモードにならないようにする．
ARG DEBIAN_FRONTEND=noninteractive

# 日本の時刻に設定．
ENV TZ=Asia/Tokyo

# パッケージのリポジトリからパッケージの名前，バージョン，依存関係を取得する．従ってパッケージを最新状態にする．
# Ubuntuにデフォルトに入っていないパッケージをインストール．(time:プログラムの計測時間．zdata:日本のタイムゾーン．tree:ツリー表示．)
# aptコマンドよりapt-getコマンドを推奨:
RUN apt-get update && \
apt-get install -y bash time tzdata tree git language-pack-ja-base language-pack-ja

RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8


# デフォルトシェルをbashにする．
RUN chsh -s /bin/bash

# メインでC++, サブでPyPyを使いたいので環境構築．online-judge-toolはPython(python3-pip)環境，atcoder-cliがNode.js(nodejs, npm)環境が必要なのでインストール．gdbはc++でデバッグするために用いる．
RUN apt-get install -y gcc-9 g++-9 python3.9 pypy3 python3-pip nodejs npm gdb

# 一般的なコマンドで使えるように設定．（コマンドのデフォルトバージョンの設定．）
# e.g. python3.9 main.py => python main.py
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 30 && \
update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 30 && \
update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 30 && \
update-alternatives --install /usr/bin/python python /usr/bin/python3.10 30 && \
update-alternatives --install /usr/bin/pypy pypy /usr/bin/pypy3 30 && \
update-alternatives --install /usr/bin/node node /usr/bin/nodejs 30


# AtCoderでも使えるPythonライブラリをインストール．（サブとしてPyPyを使うかもしれないので．）
# numpy, scipy:計算ライブラリ．
# numba:高速実行ライブラリ．
# networkx:グラフ理論ライブラリ．
RUN pip install numpy && \
pip install scipy && \
pip install numba && \
pip install networkx

# C++でAtCoder Library(ACL)を使えるようにする．また，PyPyでACLを使えるようにACL移植版のac-library-pythonをインスト－ル．
RUN git clone https://github.com/atcoder/ac-library.git /lib/ac-library
ENV CPLUS_INCLUDE_PATH /lib/ac-library
RUN pip install git+https://github.com/hinamimi/ac-library-python

# コンテスト補助アプリケーションをインストール．
# online-judge-toolsはリンクからサンプルケースを取得してデスとの実行及び提出をCUI上でおこなう．
RUN pip install online-judge-tools
# atcoder-cliはコンテストIDでサンプルケースを一括ダウンロードできる．
RUN npm install -g atcoder-cli

# atcoder-cliの設定
# acc config-dir:テンプレート設定のjsonファイルを作成．
# acc config default-task-choice all:acc new contestID で問題選択せず，全問題のサンプルを作成．
# acc config default-template cpp:テストのプログラム言語のデフォルト設定．
# config default-test-dirname-format test:作成されるテストデータをまとめるフォルダ名の設定．
RUN acc config default-task-choice all
RUN acc config-dir && \
acc config default-template cpp && \
acc config default-test-dirname-format test


# カレントディレクトリの設定．
WORKDIR /root

# atcoder-cliでテンプレート言語をcppにする前準備．
COPY add-dir/cpp/ /root/.config/atcoder-cli-nodejs/cpp
