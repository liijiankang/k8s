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
