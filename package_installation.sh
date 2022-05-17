
yum groupinstall "Development Tools" ncurses-devel hmaccalc zlib-devel binutils-devel elfutils-libelf-devel -y
if [ $? -eq 0 ]; then
echo -e "\n------------------- kernel-build dependency package(s) installed successfully -------------------\n"
else
echo -e "\n------------------- Failed to download kernel-build dependency package(s) ------------------------\n"
fi 

yum install asciidoc audit-libs-devel bash bc binutils binutils-devel bison diffutils elfutils elfutils-devel elfutils-libelf-devel findutils flex gawk gcc gettext gzip hmaccalc hostname java-devel m4 make module-init-tools ncurses-devel net-tools newt-devel numactl-devel openssl patch pciutils-devel perl perl-ExtUtils-Embed pesign python-devel python-docutils redhat-rpm-config rpm-build sh-utils tar xmlto xz zlib-devel -y
if [ $? -eq 0 ]; then
echo -e "\n-------------------- source package and tools installed successfully ------------------------------\n"
else
echo -e "\n--------------------- Failed to download source package and tools for kernel-build------------------------\n"
fi

yum install libXtst-devel libX11-devel libXinerama-devel libXi-devel libxkbcommon-devel xinput -y
if [ $? -eq 0 ]; then
echo -e "\n---------------------- compilation package installed successfully -----------------------------------\n"
else
echo -e "\n---------------------- Failed to install compilation package(s) --------------------------------------\n"
fi

export https_proxy=https://sas:9ukm6m8o013H6@proxy.localzoho.com:3128
wget https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/l/libxdo-3.20150503.1-1.el7.x86_64.rpm
rpm -ivh libxdo-3.20150503.1-1.el7.x86_64.rpm
if [ $? -eq 0 ]; then
   echo -e "\n--------------------------- libxdo Package Extraction Success ------------------------------------\n"
else
   echo -e "\n--------------------------- libxdo Download Error/Extraction Failed ------------------------------\n"
fi

export https_proxy=https://sas:9ukm6m8o013H6@proxy.localzoho.com:3128
wget https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/x/xdotool-3.20150503.1-1.el7.x86_64.rpm
rpm -ivh xdotool-3.20150503.1-1.el7.x86_64.rpm
if [ $? -eq 0 ]; then
   echo -e "\n--------------------------- xdotool Package Extraction Success ------------------------------------\n"
else
   echo -e "\n--------------------------- xdotool Download Error/Extraction Failed ------------------------------\n"
fi

cd /home/sas/
cat /etc/redhat-release > centos_version
sed -i 's/CentOS Linux release //g' centos_version
sed -i 's/ (Core)//g' centos_version
uname -r > kernel_version
sed -i 's/x86_64/src.rpm/g' kernel_version
sed -i 's/^/kernel-/' kernel_version
export https_proxy=https://sas:9ukm6m8o013H6@proxy.localzoho.com:3128
echo "https://mirror.chpc.utah.edu/pub/vault.centos.org/centos/$(cat centos_version)/updates/Source/SPackages/$(cat kernel_version)" > link
cat link | tr -d " \t\n\r" > url
wget $(cat url)
rpm -i $(cat kernel_version) 2>&1 | grep -v exist
if [ $? -eq 0 ]; then
   echo -e "\n------------------------------ source rpm extracted successfully ------------------------------------\n"
else
   echo -e "\n------------------------------ source rpm extraction failed.. Download Manually and Install.. -----------------------------------------\n"
exit 1
fi
echo -e "\n--------------------------------------------------- Start building kernel modules ----------------------------------------------------\n"
