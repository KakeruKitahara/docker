FROM paperist/texlive-ja:alpine

WORKDIR /root

# alpineではパッケージを入手するコマンドはapt(apt-get)ではなく，apkである．
# ディストロによってコマンドが異なることを注意せよ．
RUN apk update && \
apk add curl git

# FROMのDockerfileは2021年版のtexliveなので2022のtlmgr update（tlmgrのリスト一覧の取得）が2022ではないのでできない．
# そのため2022のファイルをコピーしてpathsを2021から2022に繋ぎ変える．
RUN cd /usr/local/texlive && \
cp -a 2021 2022 && \
tlmgr path remove && \
/usr/local/texlive/2022/bin/x86_64-linuxmusl/tlmgr path add && \
curl -L -O http://mirror.ctan.org/systems/texlive/tlnet/update-tlmgr-latest.sh && \
sh update-tlmgr-latest.sh -- --upgrade

# tlmgrでパッケージを入手．（CTAN : https://www.ctan.org/ にアップロードされているをパッケージを入手できる．）
# hoge.insファイルでhoge.styを生成する．
# mktexlsrでls-Rテーブルに書き込むまでおこなってくる．
RUN tlmgr update --self --all
RUN tlmgr install listings
RUN tlmgr install siunitx
RUN tlmgr install caption
RUN tlmgr install here
RUN tlmgr install pgf
RUN tlmgr install url

# jlistingはCTANにはないので直接入れる．
# パッケージ置き場:/usr/local/texlive/2021/texmf-dist/tex/latex
COPY add-dir/tex/jlisting.sty /usr/local/texlive/2021/texmf-dist/tex/latex/listings
RUN cd /usr/local/texlive/2021/texmf-dist/tex/latex/listings && \
  chmod 644 jlisting.sty && \
  mktexlsr
