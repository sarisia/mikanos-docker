# MikanOS-Docker

[![build and publish container image](https://github.com/sarisia/mikanos-docker/actions/workflows/publish-image.yml/badge.svg)](https://github.com/sarisia/mikanos-docker/actions/workflows/publish-image.yml)

![image](https://user-images.githubusercontent.com/33576079/112739400-29e73880-8faf-11eb-9f59-acca01470a62.png)

[ゼロからのOS自作入門](https://zero.osdev.jp/) で開発するOS (MikanOS) の
開発環境が設定された Docker イメージ.

[github.com/uchan-nos/mikanos-build](https://github.com/uchan-nos/mikanos-build)
リポジトリで解説されているツール, ファイルを収録しています.

[Docker ではじめる "ゼロからのOS自作入門" | Zenn](https://zenn.dev/sarisia/articles/6b57ea835344b6)

- :star: 最終章終了時のMikanOSのビルド, 実行を確認！ ([github.com/uchan-nos/mikanos](https://github.com/uchan-nos/mikanos))
- :star: Docker Desktop for (Windows | Mac), Linux に対応！ (たぶん)
- :star: X11対応！ホストのX11 Serverに簡単接続！
- :star: VSCode Devcontainer対応！ ([github.com/sarisia/mikanos-devcontainer](https://github.com/sarisia/mikanos-devcontainer))

# 配布している Docker イメージ

| Image | Tags |
| :---: | :--: |
| `ghcr.io/sarisia/mikanos` | `latest` |

# 使い方

## VSCode Devcontainer (推奨)

VSCode Devcontainer を使うことで,
コンテナを用いた完全な作業環境を簡単に設定することができます.

詳細は [github.com/sarisia/mikanos-devcontainer](https://github.com/sarisia/mikanos-devcontainer)
を参照してください.

## コンテナイメージを直接起動

1. イメージを取得

```
$ docker pull ghcr.io/sarisia/mikanos
Using default tag: latest
latest: Pulling from sarisia/mikanos
...
Digest: sha256:8ba82665f35c1212e98f8e03cdff806a152ac5a07ffdfbb1c4d55beff0492999
Status: Downloaded newer image for ghcr.io/sarisia/mikanos:latest
ghcr.io/sarisia/mikanos:latest
```

2. インタラクティブシェルを起動

**`--privileged` をつけてください！ビルドスクリプトの `mount` ができません！**

```
$ docker run --privileged -it ghcr.io/sarisia/mikanos /bin/bash
docker run --privileged -it ghcr.io/sarisia/mikanos /bin/bash
vscode ➜ ~ $ 
```

3. 頑張る

適宜コンテナ内で頑張ったりホストのディレクトリをマウントしたりしてお使いください.

# FAQ

## Linux ホストの X11 サーバに接続できない

このイメージはデフォルトで環境変数 `DISPLAY` を `host.docker.internal:0` に設定するため,
Linux ホストの Docker で実行する場合, 追加の設定が必要になります.

### `host.docker.internal` を手動でマップ

Docker Engine 20.10 以降なら, `host.docker.internal` を手動でホストにマップできます:

```
$ docker run --privileged -it --add-host=host.docker.internal:host-gateway ghcr.io/sarisia/mikanos /bin/bash
```

### DISPLAY を他に向ける

環境変数 `DISPLAY` を他に向ける方法もあります:

```
$ docker run --privileged -it --network=host -e DISPLAY=$DISPLAY ghcr.io/sarisia/mikanos /bin/bash
```

# ライセンス

当 Dockerfile のライセンスは MIT です.

ただし, 当 Dockerfile からビルドされるコンテナイメージ, 及び配布された
ビルド済みイメージに含まれる著作物のライセンスは, それぞれの固有のライセンスに
従います.

# バグ, 要望

[Twitter (@A1ces)](https://twitter.com/A1ces) や [Issues](https://github.com/sarisia/mikanos-docker/issues) で教えてくださると嬉しいです！
