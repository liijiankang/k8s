#!/usr/bin/env bash
#
# Create a base Redhat7.4 Docker image.
#
# This script is useful on systems with yum installed (e.g., building
# a Redhat7image on Redhat7).  See contrib/mkimage-rinse.sh for a way
# to build Redhat7images on other systems.

set -e

usage() {
    cat <<EOOPTS
$(basename $0) [OPTIONS] <name> <version>
OPTIONS:
  -p "<packages>"  The list of packages to install in the container.
                   The default is "telnet.x86_64 telnet-server.x86_64".
  -g "<groups>"    The groups of packages to install in the container.
                   The default is "Core".
  -d "<packages>"  The list of packages to remove from the container.
                   The default is blank.
  -f "<rpm file>"  The list of packages to install in the container.(in file)
                   The default is blank
  -y <yumconf>     The path to the yum config to install packages from. The
                   default is /etc/yum.conf for Centos/RHEL and /etc/dnf/dnf.conf for Fedora
EOOPTS
    exit 1
}

set -x
# option defaults
yum_config=/etc/yum.conf
if [ -f /etc/dnf/dnf.conf ] && command -v dnf &> /dev/null; then
	yum_config=/etc/dnf/dnf.conf
	alias yum=dnf
fi
#install_groups="Core"
#install_packages="telnet.x86_64 telnet-server.x86_64"
# remove_packages="openssh-server-7.4p1-13.el7_4.x86_64 openssh-clients-7.4p1-13.el7_4.x86_64"
while getopts "y:p:g:h:d:f:" opt; do
    case $opt in
        y)
            yum_config=$OPTARG
            ;;
        h)
            usage
            ;;
        p)
            install_packages="$OPTARG"
            ;;
        g)
            install_groups="$OPTARG"
            ;;
        d)
            remove_packages="$OPTARG"
            ;;
        f)
            rpm_file="$OPTARG"
            ;;
        \?)
            echo "Invalid option: -$OPTARG"
            usage
            ;;
    esac
done
shift $((OPTIND - 1))
name=$1
version=$2
if [[ -z $name ]]; then
    usage
fi
if [[ -z $version ]]; then
    usage
fi

target=$(mktemp -d --tmpdir $(basename $0).XXXXXX)

mkdir -m 755 "$target"/dev
mknod -m 600 "$target"/dev/console c 5 1
mknod -m 600 "$target"/dev/initctl p
mknod -m 666 "$target"/dev/full c 1 7
mknod -m 666 "$target"/dev/null c 1 3
mknod -m 666 "$target"/dev/ptmx c 5 2
mknod -m 666 "$target"/dev/random c 1 8
mknod -m 666 "$target"/dev/tty c 5 0
mknod -m 666 "$target"/dev/tty0 c 4 0
mknod -m 666 "$target"/dev/urandom c 1 9
mknod -m 666 "$target"/dev/zero c 1 5

# amazon linux yum will fail without vars set
if [ -d /etc/yum/vars ]; then
	mkdir -p -m 755 "$target"/etc/yum
	cp -a /etc/yum/vars "$target"/etc/yum/
fi

if [[ -n "$install_groups" ]];
then
    yum -c "$yum_config" --installroot="$target" --releasever=/ --setopt=tsflags=nodocs \
        --setopt=group_package_types=mandatory -y groupinstall $install_groups
fi

rm -f "$target"/etc/yum.repos.d/*.repo
#mkdir -p "$target"/etc/yum.repos.d/
#cp /etc/yum.repos.d/redhat.repo  "$target"/etc/yum.repos.d/

if [[ -n "$install_packages" ]];
then
    yum -c "$yum_config" --installroot="$target" -y install $install_packages
fi

if [[ -n "$remove_packages" ]];
then
    yum -c "$yum_config" --installroot="$target" --releasever=/ \
        -y remove $remove_packages
fi

if [[ -n "$rpm_file" ]];
then
    rpmlist=`cat "$rpm_file"`
   # while read rpm_name
    #do

        yum -c "$yum_config" --installroot="$target" --releasever=/ --setopt=tsflags=nodocs \
            --setopt=group_package_types=mandatory -y install $rpmlist
    #done < $rpm_file
fi

cp /etc/yum.repos.d/rhel_7_rpms.repo  "$target"/etc/yum.repos.d/
yum -c "$yum_config" --installroot="$target" -y clean all

cat > "$target"/etc/sysconfig/network <<EOF
NETWORKING=yes
HOSTNAME=localhost.localdomain
EOF


chroot "$target" /bin/bash -c "cd /usr/share/locale/; ls | grep -v zh_CN| xargs rm -rf"
chroot "$target" /bin/bash -c "rm -f /usr/lib/locale/locale-archive;localedef -i zh_CN -f UTF-8 zh_CN.UTF-8"
chroot "$target" /bin/bash -c "rm -rf /var/cache/yum/*"

# effectively: febootstrap-minimize --keep-zoneinfo --keep-rpmdb --keep-services "$target".
#  locales
#rm -rf "$target"/usr/{{lib,share}/locale,{lib,lib64}/gconv,bin/localedef,sbin/build-locale-archive}
#  docs and man pages
rm -rf "$target"/usr/share/{man,doc,info,gnome/help}
#  cracklib
rm -rf "$target"/usr/share/cracklib
#  i18n
rm -rf "$target"/usr/share/i18n
#  yum cache
#rm -rf "$target"/var/cache/yum
#mkdir -p --mode=0755 "$target"/var/cache/yum
#  sln
#rm -rf "$target"/sbin/sln
#  ldconfig
rm -rf "$target"/etc/ld.so.cache "$target"/var/cache/ldconfig
mkdir -p --mode=0755 "$target"/var/cache/ldconfig

#version=
#for file in "$target"/etc/{redhat,system}-release
#do
#    if [ -r "$file" ]; then
#        version="$(sed 's/^[^0-9\]*\([0-9.]\+\).*$/\1/' "$file")"
#        break
#    fi
#done

#if [ -z "$version" ]; then
#    echo >&2 "warning: cannot autodetect OS version, using '$name' as tag"
#    version=$name
#fi

if [ -r "$target"/etc/ssh/sshd_config ]; then
    chroot "$target" ssh-keygen -A
    chroot "$target" sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
fi
#chroot "$target" bash -c "echo -n 'root' | passwd --stdin root"

##dockerfile create && build image
cd "$target"
tar cf "$name.tar" --numeric-owner -c -C "$target" .
mkdir "$target/dockrfile"
mv $name.tar "$target/dockerfile"
cd dockerfile
echo "#!/bin/sh" > run.sh
echo "ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime" > run.sh
echo "exec /bin/bash" > run.sh
chmod +x run.sh
echo "FROM scratch" > dockerfile
echo "LABEL name=\"CMPC Base Image\"" >> dockerfile
echo "ADD $name.tar /" >> dockerfile
echo "ENV LC_ALL=zh_CN.UTF-8" >> dockerfile
echo "COPY run.sh /" >> dockerfile
echo "CMD exec ./run.sh" >> dockerfile
docker build -t $name:$version -f "$target/dockerfile/dockerfile"

#tar --numeric-owner -c -C "$target" . | docker import - $name:$version

docker run -i -t --rm $name:$version /bin/bash -c 'echo success'

echo "$target"
rm -rf "$target"