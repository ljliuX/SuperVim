# SuperVim

### 安装

#### Vim

```sh
curl -Lo ~/.vimrc \
	https://raw.githubusercontent.com/ljliuX/SuperVim/master/vimrc \
	&& vim -c ":PlugInstall"
```

#### Neovim

```sh
curl -Lo ~/.config/nvim/init.vim \
	https://raw.githubusercontent.com/ljliuX/SuperVim/master/vimrc \
	&& nvim -c ":PlugInstall"
```

### 卸载

删除目录`~/.SuperVim`、配置文件`~/.vimrc`或者`~/.config/nvim/init.vim`。
