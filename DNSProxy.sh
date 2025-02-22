#!/usr/bin/env bash

Green="\033[32m"
Font="\033[0m"
Blue="\033[33m"

VERSION=$(curl -s https://api.github.com/repos/AdguardTeam/dnsproxy/releases/latest | grep tag_name | cut -d '"' -f 4)

rootness(){
    if [[ $EUID -ne 0 ]]; then
       echo "Error:This script must be run as root!" 1>&2
       exit 1
    fi
}

checkos(){
    if [[ -f /etc/redhat-release ]];then
        OS=CentOS
    elif cat /etc/issue | grep -q -E -i "debian";then
        OS=Debian
    elif cat /etc/issue | grep -q -E -i "ubuntu";then
        OS=Ubuntu
    elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat";then
        OS=CentOS
    elif cat /proc/version | grep -q -E -i "debian";then
        OS=Debian
    elif cat /proc/version | grep -q -E -i "ubuntu";then
        OS=Ubuntu
    elif cat /proc/version | grep -q -E -i "centos|red hat|redhat";then
        OS=CentOS
    else
        echo "Not supported OS, Please reinstall OS and try again."
        exit 1
    fi
}

get_arch(){
get_arch=`arch`
    if [[ $get_arch =~ "x86_64" ]];then
       ARCHV=amd64
    elif [[ $get_arch =~ "aarch64" ]];then
       ARCHV=arm64
    elif [[ $get_arch =~ "mips64" ]];then
       echo "mips64 is not supported"
       exit 1
    else
       echo "Unknown Architecture!!"
       exit 1
    fi
}

disable_selinux(){
    if [ -s /etc/selinux/config ] && grep 'SELINUX=enforcing' /etc/selinux/config; then
        sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
        setenforce 0
    fi
}

install(){
    echo -e "${Green}即将安装...${Font}"
    if [ "${OS}" == 'CentOS' ];then
        yum install epel-release -y
        yum install -y wget curl tar
        wget "https://github.com/AdguardTeam/dnsproxy/releases/download/${VERSION}/dnsproxy-linux-${ARCHV}-${VERSION}.tar.gz" -O /tmp/dnsproxy.tar.gz
        tar -xzvf /tmp/dnsproxy.tar.gz -C /tmp/
        mv /tmp/linux-${ARCHV}/dnsproxy /usr/bin/dnsproxy
        chmod +x /usr/bin/dnsproxy
        rm -rf /tmp/dnsproxy.tar.gz /tmp/linux-${ARCHV}/
    else
        apt-get -y update
        apt-get install -y wget curl tar
        wget "https://github.com/AdguardTeam/dnsproxy/releases/download/${VERSION}/dnsproxy-linux-${ARCHV}-${VERSION}.tar.gz" -O /tmp/dnsproxy.tar.gz
        tar -xzvf /tmp/dnsproxy.tar.gz -C /tmp/
        mv /tmp/linux-${ARCHV}/dnsproxy /usr/bin/dnsproxy
        chmod +x /usr/bin/dnsproxy
        rm -rf /tmp/dnsproxy.tar.gz /tmp/linux-${ARCHV}/
    fi
}

main(){
    rootness
    checkos
    get_arch
    disable_selinux
    install
}

Aliyun(){
    main
    wget -O /etc/systemd/system/dnsproxy.service https://raw.githubusercontent.com/WukongMaster/DNS-over-HTTPS-For-Linux/master/services/Aliyun.service
    systemctl daemon-reload
    systemctl restart dnsproxy
    systemctl enable dnsproxy
}

Tencent(){
    main
    wget -O /etc/systemd/system/dnsproxy.service https://raw.githubusercontent.com/WukongMaster/DNS-over-HTTPS-For-Linux/master/services/Tencent.service
    systemctl daemon-reload
    systemctl restart dnsproxy
    systemctl enable dnsproxy
}

Cloudflare(){
    main
    wget -O /etc/systemd/system/dnsproxy.service https://raw.githubusercontent.com/WukongMaster/DNS-over-HTTPS-For-Linux/master/services/Cloudflare.service
    systemctl daemon-reload
    systemctl restart dnsproxy
    systemctl enable dnsproxy
}

Google(){
    main
    wget -O /etc/systemd/system/dnsproxy.service https://raw.githubusercontent.com/WukongMaster/DNS-over-HTTPS-For-Linux/master/services/Google.service
    systemctl daemon-reload
    systemctl restart dnsproxy
    systemctl enable dnsproxy
}

echo && echo -e "------------------------------
提示：国内VPS请选择1或2，国外VPS强烈建议选择3
 1. Aliyun DNS over HTTPS
 2. Tencent DNS over HTTPS
 3. Cloudflare DNS over HTTPS
 4. Google DNS over HTTPS
------------------------------" && echo
read -e -p " 请输入数字 [1-4]:" num
case "$num" in
	1)
	Aliyun DNS over HTTPS
	;;
	2)
	Tencent DNS over HTTPS
	;;
	3)
	Cloudflare DNS over HTTPS
	;;
	4)
	Google DNS over HTTPS
	;;
	*)
	echo "请输入正确数字 [1-4]"
	;;
esac
