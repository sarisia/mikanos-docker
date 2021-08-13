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
| `ghcr.io/sarisia/mikanos` | `vnc` | `linux/amd64`, `linux/arm64` |

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

# VNC イメージについて

`ghcr.io/sarisia/mikanos:vnc` イメージを提供しています. VNC イメージを利用することで,
ホスト環境に X11 Server を用意することなく, MikanOS の動作確認をすることが可能です.
また, [GitHub Codespaces](https://github.com/features/codespaces) を利用することで, ブラウザのみでコーディング&動作確認を
完結することができます.

## 使い方

VSCode Devcontainer を推奨しています. 詳細は [mikanos-devcontainer](https://github.com/sarisia/mikanos-devcontainer#github-codespaces) の
ドキュメントを参照して下さい.

それ以外の場合は, 通常のイメージと同様の使い方が可能です. コンテナ起動時に自動で [noVNC](https://novnc.com/info.html) が
起動し, コンテナ実行中は常に常駐します. QEMU を実行する際に, オプションとして `-vnc :0` を指定することで,
ブラウザから `http://localhost:6080` を開いて動作確認ができます.

## カスタマイズ

noVNC のポートなどを変更する際は, 以下の環境変数を設定して下さい.

| Environment Variable | Default | Note |
| :---: | :---: | :---- |
| `NOVNC_PORT` | `6080` | noVNC Webクライアントと WebSocket API のポート番号 |
| `VNC_PORT` | `5900` | QEMU が待ち受ける VNC ポート番号. デフォルトでは `5900 + <ディスプレイ番号>` となります. 例えば, QEMU を `-vnc :1` オプションで起動した場合, `VNC_PORT` は `5901` です. |
| (参考) `QEMU_OPTS` | | QEMU を実行する際の追加オプション. `~/osbook/devenv/run_image.sh` 内で展開されます. `-vnc :0` などと設定しておくと便利です. |

# FAQ

## M1 Mac での動作は？

可能です. `linux/arm64` アーキテクチャに対応したイメージを用意しています.

ただし, X64 向けにブートローダをビルドするため, クロスコンパイル関連の設定が必要です.
[ゼロからのOS自作入門](https://zero.osdev.jp/) 2.2節で生成される `/$HOME/edk2/Conf/tools_def.txt`
に対し, 当リポジトリの [`tools_def.txt.diff`](tools_def.txt.diff) を参考に, 設定を変更して下さい.

その他の手順は, 書籍に従います.

<details>
<summary>エミュレータを用いた互換動作</summary>

書籍と違う設定を行うことに抵抗がある, もしくは前述の方法が上手く行かない場合は,
明示的に `linux/amd64` イメージを互換レイヤを通して利用することが可能です.

ただし, 互換レイヤを通すことでパフォーマンスは大きく劣化し, コンパイル時や
QEMU を用いたテスト動作時の速度は遅くなります.

互換レイヤを用いるには, `ghcr.io/sarisia/mikanos:amd64` イメージを取得した後,
コンテナ実行時に `--platform linux/amd64` を指定して実行してください:

```
$ docker run --platform linux/amd64 --privileged -it --user vscode ghcr.io/sarisia/mikanos:amd64 /bin/bash
```

</details>

## WSLg での動作は？

正常な動作を確認しました. [ドキュメント](https://github.com/microsoft/wslg) に従い WSLg を設定した後,
X11 のソケットをコンテナ内にバインドして下さい:

```
$ docker run --privileged -it --user vscode --mount type=bind,source=/tmp/.X11-unix,target=/tmp/.X11-unix ghcr.io/sarisia/mikanos /bin/bash
```

# トラブルシューティング

[Wiki をご確認ください.](https://github.com/sarisia/mikanos-docker/wiki/Troubleshooting)

# ライセンス

当 Dockerfile のライセンスは MIT です.

ただし, 当 Dockerfile からビルドされるコンテナイメージ, 及び配布された
ビルド済みイメージに含まれる著作物のライセンスは, それぞれの固有のライセンスに
従います.

# バグ, 要望

[Twitter (@A1ces)](https://twitter.com/A1ces) や [Issues](https://github.com/sarisia/mikanos-docker/issues) で教えてくださると嬉しいです！
