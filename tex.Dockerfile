FROM paperist/alpine-texlive-ja

WORKDIR /root

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
