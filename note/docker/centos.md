## 制作基础镜像
#### 安装febootstrap 
 http://rpmfind.net/linux/centos/6.10/os/x86_64/Packages/febootstrap-3.21-4.el6.x86_64.rpm
 http://rpmfind.net/linux/centos/6.10/os/x86_64/Packages/fakechroot-2.9-24.5.el6_1.1.x86_64.rpm
 https://www.dwhd.org/wp-content/uploads/2016/06/febootstrap-supermin-helper-3.21-4.el6_.x86_64.rpm
 http://rpmfind.net/linux/centos/6.10/os/x86_64/Packages/fakechroot-libs-2.9-24.5.el6_1.1.x86_64.rpm
 http://rpmfind.net/linux/centos/6.10/os/x86_64/Packages/fakeroot-1.12.2-22.2.el6.x86_64.rpm
 http://rpmfind.net/linux/centos/6.10/os/x86_64/Packages/fakeroot-libs-1.12.2-22.2.el6.x86_64.rpm
#### 制作镜像
` febootstrap -i bash -i wget -i yum -i telnet -i iputils -i iproute -i vim -i gzip -i tar centos7.4 centos7.4-image http://mirror.nsc.liu.se/centos-store/7.4.1708/os/x86_64/`
#### 上传镜像
tar -c . | docker import - centos7.4

# 经过测试，上述过程有问题
### 提供方法二：
```
1.使用方法一中获取到的centos7.4-image文件
    cd centos7.4-image
2.将该目录中不需要的文件夹删除（这些目录都是系统启动时创建的目录）
    rm -rf proc/ sys/ run/ boot/
3.将该目录打包
    tar -cf centos_inspur_7.4.tar ./*
4.上传镜像
     cat centos_inspur_7.4.tar | docker import - centos_inspur:7.4
5.启动并进入容器后发现命令提示符错误：bash-4.2#？
    cp /etc/skel/.bash* /root
    source /root/.bashrc
6.下载常用的软件包
    yum install net-tools lrzsz gcc-c++ pcre pcre-devel openssl openssl-devel patch  bash-completion zlib.i686 libstdc++.i686 lsof zlib zlib-devel ruby  unzip zip
7.将优化后的容器做成镜像
```