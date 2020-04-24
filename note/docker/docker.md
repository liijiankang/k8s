## docker概念
* 容器：运行在操作系统上的一个进程，只不过加入了对资源的隔离和限制
* docker增加了LXC的易用性和稳定性，核心功能CGroups,Namespace,UnionFS
* CGroups限定一个进程的资源使用
* 进程间都是访问同一份资源，为了达到隔离的目的，使用Namespace做资源的隔离
* UnionFS用来处理分层镜像
### docker入门
`docker info`
* 查看运行状态及版本信息

`docker run [OPTIONS] IMAGE[:TAG|@DIGEST][COMMAND][ARG...]`
* -d:后台运行，再次进入容器可以使用docker attach <cid>.再次进入-d模式的话使用ctrl+pq

#### 容器标识
* --name 容器有三种方式进行标识，长UUID.短UUID，name
#### 重启策略
* NO 没有任何重启操作
* On-failure 当容器的命令返回值非0时重启
* Always 无论处于什么状态都重启，在daemon启动时附带启动
* Unless-stopped 类似于Always,不会随着daemon自启动
* --rm 在容器退出时自动删除容器