## docker镜像
`[域名/][用户名/]镜像名[:版本号]`
* 指定了域名，会从该域名进行下载，或者从docker hub下载
* 用户名隶属于该域名下的子目录，使用私有仓库时使用
* 版本号默认是latest
* <none>是中间镜像

`docker tag [OPTIONS] IMAGE[:TAG] [REGISTRYHOST/][USERNAME/]NAME[:TAG]`
* push镜像

`docker rmi `
* 删除镜像