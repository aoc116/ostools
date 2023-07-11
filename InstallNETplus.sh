#!/bin/bash

# 下载 InstallNET.sh 脚本
wget --no-check-certificate -qO InstallNET.sh 'https://raw.githubusercontents.com/leitbogioro/Tools/master/Linux_reinstall/InstallNET.sh' && chmod a+x InstallNET.sh

# 交互式获取参数
read -p "请选择要安装的操作系统（debian^, centos, alpine, fedora）: " os
os=${os:-debian}
read -p "请输入要安装的版本号: " version
read -p "请输入SSH端口号（默认为22）: " ssh_port
read -s -p "请输入ROOT密码: " root_password
echo

# 根据选择的操作系统设置相应的参数
case $os in
  debian)
    os_option="-debian ${version:-12}"
    ;;
  centos)
    os_option="-centos ${version:-7}"
    ;;
  alpine)
    os_option="-alpine ${version:-3.18}"
    ;;
  fedora)
    os_option="-fedora ${version:-37}"
    ;;
  *)
    echo "无效的操作系统选择"
    exit 1
    ;;
esac

# 如果未输入SSH端口号，则使用默认端口22
if [ -z "$ssh_port" ]; then
  ssh_port=22
fi

# 如果未输入ROOT密码，则生成一个随机的8位数字密码
if [ -z "$root_password" ]; then
  root_password=$(date +%s | sha256sum | base64 | head -c 8 ; echo)
  echo "未输入ROOT密码，将使用随机生成的密码：$root_password"
  read -s -p "请确认密码后继续："
  echo
fi

# 执行安装命令
bash InstallNET.sh $os_option -port $ssh_port -pwd $root_password
