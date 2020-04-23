## 镜像基本操作
### 镜像仓库配置
`docker image pull [OPTIONS] NAME[:TAG|@DIGEST]`

* 如果NAME没有仓库域名且没有tag信息，默认从registry-1.docker.io:80/library/<name>:last的镜像
* -a/--all-tags 用于拉去所有镜像 --platform用于拉去某种OS和体系结构下的镜像
* 通过Dockerd --registry-mirror启动选项设置下载镜像的默认仓库地址，--insecure-registry设置可接受http协议的地址列表，也可以写入到daemon.json文件中
* 需要授权的镜像仓库，使用docker login/lgout登录登出

`docker image push [OPTIONS] NAME[:TAG]`
* 将本地镜像上传到镜像仓库

`docker image ls [OPTIONS] [REPOSITORY[:TAG]]`
* 查看本地镜像
* --digests 显示原创仓库摘要信息
* --no-trunc 不会截断显示ID等字段
* -a/--all 显示commit,build等命令生成的中间镜像
* -f/--filter过滤显示结果。 --filter=reference='busy*:*libc'

`docker image inspect [OPTIONS] IMAGE [IMAGE ...]`
* 显示json格式的本地镜像详细信息
* -f/--format 控制输出格式，占位符用json串中的key

`docker image history [OPTIONS] IMAGE`
* 显示记录在元数据中的历史命令
* -h/--human 控制时间戳格式

`docker image save [-o,--output="""] IMAGE [IMAGE...]`
* 将镜像保存到tar文件中

`docker image load [-i.--input=""] [-q.--quiet[=false]]`
* 导入tar文件中的镜像

`docker commit [OPTIONS] CONTAINER[REPOSIROTY[:TAG]]`
* 将容器固化为镜像
* -p/--pause[=true] 执行commit前先暂停容器
* -c/--change 创建镜像时执行dockerfile指令

`docker export [-o,--output=""]` CONTAINER
* 将容器跟文件系统导出为tar文件

`docket image impoer [OPTIONS] file |URL|- [REPOSITORY[:TAG]]`
* 导入容器跟文件系统tar文件

`docker image build [OPTIONS] PATH | URL | -`
* 构建镜像
* PATH URL确定构建上下文。如指定PATH，将路径文件和目录打包上传到docker引擎，如指定URL，则引擎克隆该项目指定分支，作为上下文使用。
* -f/--file指定dockfile路径，默认为当前路径下的dockerfile
* -t/--tag指定构建成功后镜像标识，可以使用多个。
* --iidfile将镜像ID写入指定文件

`docker image tag SOURCE_IMAGE[:TAG] [IMAGE...]`
* 原有的镜像标识并不删除，相当于为原镜像表示生成了别名

`docker image rm [OPTIONS] IMAGE [IMAGE...]`
* -f/--force 强删被引用镜像，但是不删除容器引用的镜像


