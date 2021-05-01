# MikanOS-Docker

[![build and publish container image](https://github.com/sarisia/mikanos-docker/actions/workflows/publish-image.yml/badge.svg)](https://github.com/sarisia/mikanos-docker/actions/workflows/publish-image.yml)

![image](https://user-images.githubusercontent.com/33576079/112739400-29e73880-8faf-11eb-9f59-acca01470a62.png)

[ゼロからのOS自作入門](https://zero.osdev.jp/) で開発するOS (MikanOS) の
開発環境が設定された Docker イメージ.

[github.com/uchan-nos/mikanos-build](https://github.com/uchan-nos/mikanos-build)
リポジトリで解説されているツール, ファイルを収録しています.

[Docker ではじめる "ゼロからのOS自作入門" | Zenn](https://zenn.dev/sarisia/articles/6b57ea835344b6)

- :star: 最終章終了時のMikanOSのビルド, 実行を確認！ ([github.com/uchan-nos/mikanos](https://github.com/uchan-nos/mikanos))
- :star: Docker for ( Windows (WSL2, Hyper-V) | Mac (Intel, M1) ), Linux に対応！ (たぶん)
- :star: X11対応！ホストのX11 Serverに簡単接続！
- :star: VSCode Devcontainer対応！ ([github.com/sarisia/mikanos-devcontainer](https://github.com/sarisia/mikanos-devcontainer))
- :star: M1 Mac ネイティブ対応！ `arm64` イメージあります！

# 配布している Docker イメージ

| Image | Tags | Arch |
| :---: | :--: | :---: |
| `ghcr.io/sarisia/mikanos` | `latest` | `linux/amd64`, `linux/arm64` |
| `ghcr.io/sarisia/mikanos` | `amd64` | `linux/amd64` |
| `ghcr.io/sarisia/mikanos` | `arm64` | `linux/arm64` |

# 使い方

## VSCode Devcontainer (推奨)

VSCode Devcontainer を使うことで,
コンテナを用いた完全な作業環境を簡単に設定することができます.

詳細は [github.com/sarisia/mikanos-devcontainer](https://github.com/sarisia/mikanos-devcontainer)
を参照してください.

## コンテナイメージを直接起動

**`--privileged` をつけてください！ビルドスクリプトの `mount` ができません！**

```
$ docker run --privileged --user vscode -it ghcr.io/sarisia/mikanos /bin/bash
vscode ➜ ~ $ 
```

適宜コンテナ内で頑張ったり, ホストのディレクトリをマウントしたりしてお使いください.

# FAQ

## M1 Mac での動作は？

可能です. `linux/arm64` アーキテクチャに対応したイメージを用意しています.

ただし, X64 向けにブートローダをビルドするため, クロスコンパイル関連の設定が必要です.
[ゼロからのOS自作入門](https://zero.osdev.jp/) 2.2節で生成される `/$HOME/edk2/Conf/tools_def.txt`
に対し, 当リポジトリの [`tools_def.txt.diff`](tools_def.txt.diff) を参考に, 設定を変更して下さい.

その他の手順は, 書籍に従います.

<details>
<summary>エミュレータを用いた互換動作</summary>

書籍と違う設定を行うことに抵抗がある, もしくは難しいことを考えたくない場合は,
明示的に `linux/amd64` イメージを互換レイヤを通して利用することが可能です.

ただし, 互換レイヤを通すことでパフォーマンスは大きく劣化し, コンパイル時や
QEMU を用いたテスト動作時の速度は体感できるほどに遅くなります.

互換レイヤを用いるには, `ghcr.io/sarisia/mikanos:amd64` イメージを取得した後,
コンテナ実行時に `--platform linux/amd64` を指定して実行してください:

```
$ docker run --platform linux/amd64 --privileged -it --user vscode ghcr.io/sarisia/mikanos:amd64 /bin/bash
```

</details>

## Linux ホストの X11 サーバに接続できない

このイメージはデフォルトで環境変数 `DISPLAY` を `host.docker.internal:0` に設定するため,
Linux ホストの Docker で実行する場合, 追加の設定が必要になります.

### `host.docker.internal` を手動でマップ

Docker Engine 20.10 以降なら, `host.docker.internal` を手動でホストにマップできます:

```
$ docker run --privileged -it --user vscode --add-host=host.docker.internal:host-gateway ghcr.io/sarisia/mikanos /bin/bash
```

### DISPLAY を他に向ける

環境変数 `DISPLAY` を他に向ける方法もあります:

```
$ docker run --privileged -it --user vscode --network=host -e DISPLAY=$DISPLAY ghcr.io/sarisia/mikanos /bin/bash
```

## WSLg での動作は？

できます. [ドキュメント](https://github.com/microsoft/wslg) に従い WSLg を設定した後,
X11 のソケットをコンテナ内にバインドして下さい:

```
$ docker run --privileged -it --user vscode --mount type=bind,source=/tmp/.X11-unix,target=/tmp/.X11-unix ghcr.io/sarisia/mikanos /bin/bash
```

# ライセンス

当 Dockerfile のライセンスは MIT です.

ただし, 当 Dockerfile からビルドされるコンテナイメージ, 及び配布された
ビルド済みイメージに含まれる著作物のライセンスは, それぞれの固有のライセンスに
従います.

# バグ, 要望

[Twitter (@A1ces)](https://twitter.com/A1ces) や [Issues](https://github.com/sarisia/mikanos-docker/issues) で教えてくださると嬉しいです！
