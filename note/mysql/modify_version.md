#### 下载并解压源码
`wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-boost-5.7.29.tar.gz`
`tar -zxvf mysql-boost-5.7.29.tar.gz`
#### 修改版本号
```$xslt
vim mysql-5.7.28/VERSION

    MYSQL_VERSION_MAJOR=99
    MYSQL_VERSION_MINOR=9
    MYSQL_VERSION_PATCH=99
```
#### 注释版本校验
```$xslt
vim mysql-5.7.28/sql/mysqld.cc

//#if MYSQL_VERSION_ID >= 50800
//#error "show_compatibility_56 is to be removed in MySQL 5.8"
//#else
/*
  Default value TRUE for the EMBEDDED_LIBRARY,
  default value from Sys_show_compatibility_56 otherwise.
*/
my_bool show_compatibility_56= TRUE;
//#endif /* MYSQL_VERSION_ID >= 50800 */
```
#### 编译安装
`cmake`
`make && make install`
#### 配置my.cnf后启动mysql服务
