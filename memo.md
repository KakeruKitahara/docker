# docker note
## dockerfile単体のとき
- `docker build`でイメージの作成の際に`-f`のオプションを付ける．
- イメージ名のは`名前空間/イメージ名:タグ名`の規則がある．
- コンテナ作成は`docker run --name #{任意のコンテナ名} -it #{利用したいイメージ}`

## dockerfileとdocker-compose.ymlを使うとき
- docker-compose.ymlはDockerfileで作られたimageに情報を加える役割．
- `docker-compose up`で`docker build`から`docker run`まで一度におこなう．ymlファイルの全てのサービスのコンテナが作られるが，既に作られているimageやcontainerはskipされる．`-d`デタッチした状態で実行．
- `docker-compose up --build`で既にimageがある場合でも，buildする．
- `docker-compose down`で`docker stop`から`docker rm`まで一度におこなう．
- volumeはtypeがbindとvolumeがあり，前者はローカル（ホスト）とディレクトリを共有するがLinuxとWindowsではファイル構造が異なるためおオーバーヘッドを起こしやすい．後者は同一のymlファイル上のみでディレクトリを共有するようになる．これはymlファイルの最下段にvolumeを定義する必要がある．