# SuperVim

### 安装

#### Vim

```sh
curl -Lo ~/.vimrc \
	https://raw.githubusercontent.com/ljliuX/SuperVim/master/vimrc \
	&& vim -c ":q" && vim -c ":PlugInstall"
```

#### Neovim

```sh
curl -Lo ~/.config/nvim/init.vim \
	https://raw.githubusercontent.com/ljliuX/SuperVim/master/vimrc \
	&& nvim -c ":q" && nvim -c ":PlugInstall"
```

### 脚本

测试终端颜色

```bash
awk 'BEGIN{
    s="/\\/\\/\\/\\/\\"; s=s s s s s s s s;
    for (colnum = 0; colnum<77; colnum++) {
        r = 255-(colnum*255/76);
        g = (colnum*510/76);
        b = (colnum*255/76);
        if (g>255) g = 510-g;
        printf "\033[48;2;%d;%d;%dm", r,g,b;
        printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
        printf "%s\033[0m", substr(s,colnum+1,1);
    }
    printf "\n";
}'
```

### 卸载

删除目录`~/.SuperVim`、配置文件`~/.vimrc`或者`~/.config/nvim/init.vim`。

### Reference

[Gtags][1] GNU Global / Gtags 类似于 Ctags 的源代码标签工具

[1]: http://www.gnu.org/software/global
