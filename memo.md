# docker note
## dockerfile単体のとき
- `docker build`でイメージの作成の際に`-f`のオプションを付ける．
- イメージ名のは`名前空間/イメージ名:タグ名`の規則がある．
- コンテナ作成は`docker run --name #{任意のコンテナ名} -it #{利用したいイメージ}`
- コンテナの停止は`docker stop #{任意のコンテナ名}`
-  コンテナの削除は`docker rm #{任意のコンテナ名}`であり，イメージの削除は`docker rmi #{任意のイメージ名}`
- コンテナの稼働状況は`docker ps (-a)`であり，イメージの作成状況は`docker images`

## dockerfileとdocker-compose.ymlを使うとき
- docker-compose.ymlはDockerfileで作られたimageに情報を加える役割．
- `docker-compose up`で`docker build`から`docker run`まで一度におこなう．ymlファイルの全てのサービスのコンテナが作られるが，既に作られているimageやcontainerはskipされる．`-d`デタッチした状態で実行．
- 個別でymlファイルを用いてコンテナ作成をする場合は`docker-compose up #{任意のサービス名}`
- `docker-compose up --build`で既にimageがある場合でも，buildする．
- `docker-compose down`で`docker stop`から`docker rm`まで一度におこなう．
- volumeはtypeがbindとvolumeがあり，前者はローカル（ホスト）とディレクトリを共有するがLinuxとWindowsではファイル構造が異なるためおオーバーヘッドを起こしやすい．後者は同一のymlファイル上のみでディレクトリを共有するようになる．これはymlファイルの最下段にvolumeを定義する必要がある．

## その他
- オフラインの際に，dockerはイメージの作成だけ既にしていればイメージ単体でのコンテナの作成，削除やymlを用いたコンテナ作成，削除などは可能である．