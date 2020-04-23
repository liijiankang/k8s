## dockerfile优化
* 通俗易懂
* 执行速度快，执行环境要求低
* 镜像文件小，不冗余
* 分层少
### checklist
* 检查dockerignore文件
* 容器进程数量，一个容器一般只执行一个指令
* 使用workdir设定工作目录
* run指令，顺序执行run指令需要合并以减少镜像层次
* 调整copy和run顺序，把变化少的部分放在dockerfile的前面
* 环境变量
* 基础镜像

*使用http://dockerfile-linter.com*进行语法检查