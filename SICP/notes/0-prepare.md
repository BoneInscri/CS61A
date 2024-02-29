

教材

https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/index.html

SICP Scheme 版本

vscode 配置：

https://blog.csdn.net/qq1097759441/article/details/129171686

https://stackoverflow.com/questions/49183001/how-can-i-run-scheme-on-visual-studio-code

https://blog.csdn.net/weixin_40827685/article/details/109751129

- sudo apt-get install mit-scheme
- **sudo apt install racket**

JS 版本的SICP

https://sourceacademy.org/sicpjs/index



安装emacs

```
sudo apt install emacs
```





使用DrRacket ！



开启自动括号

![image-20240213180559087](0-prepare.assets/image-20240213180559087.png)

显示代码行数



DrRacket 的输出在右侧，如何修改为在下侧？

<img src="0-prepare.assets/image-20240225124712763.png" alt="image-20240225124712763" style="zoom:50%;" />





记得安装 sicp 的package

https://zhuanlan.zhihu.com/p/37056659

https://github.com/sicp-lang/sicp





scheme 教程

https://wizardforcel.gitbooks.io/teach-yourself-scheme/content/010-enter-scheme.html



ctrl + alt + n  vscode 运行程序



manual？

http://www.lispmachine.net/books/LISP_1.5_Programmers_Manual.pdf



exercise-answer

http://community.schemewiki.org/?sicp-solutions

https://sicp-solutions.net/

https://sicp.readthedocs.io/en/latest/



files-viewer

https://github.com/MatrixForChange/files-viewer



racket 快捷键

Ctrl+E             显示/隐藏交互窗口

Ctrl+D             显示/隐藏代码窗口

Ctrl+I               全文调整缩进

Ctrl+Shift+V    粘贴时自动缩进

Ctrl+T             新建标签

Ctrl+W            关闭当前窗口（或标签）

Ctrl+R或F5     运行



MIT-scheme + vscode 的配置

下载

```bash
sudo apt-get install mit-scheme
```

可执行文件

```
/usr/bin/mit-scheme
/usr/bin/mit-scheme-x86-64
```

terminal 启动

输入 `mit-scheme` 或 `scheme` 进入解释器

编译+运行源码，假设源码文件名为 `add.scm`

```
(cf "add")
(load "add")
```



vscode 上的插件：

vscode-scheme 和 Code Runner

https://stackoverflow.com/questions/62501529/how-to-run-scheme-program-in-vs-code



添加一个task.json

```json
{
    // See https://go.microsoft.com/fwlink/?LinkId=733558
    // for the documentation about the tasks.json format
    "version": "2.0.0",
    "tasks": [
        {
            "label": "run scheme",
            "type": "shell",
            "command": "scheme",
            "args": ["<", "${file}"]

        }
    ]
}
```



vscode 配置

```json
 "code-runner.executorMap": {
    "scheme": "/usr/bin/mit-scheme-x86-64 < "
  }
```







