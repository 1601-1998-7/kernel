cd /home/sas/
echo -e "\n---------------------------------Disabling All User Inputs--------------------------------\n"
#xinput disable "AT Translated Set 2 keyboard"
xinput | grep "TouchPad" > touchpad
sed -i 's/\id=.*//' touchpad 
awk '{$1=$1;print}' touchpad > touchpad.disable
awk '{print substr($0,5)}' touchpad.disable > touchpad
xinput | grep "Mouse" > mouse
sed -i 's/\id=.*//' mouse
awk '{$1=$1;print}' mouse > mouse.disable
awk '{print substr($0,5)}' mouse.disable > mouse
xinput | grep "Keyboard" > keyboard
sed -i 's/\id=.*//' keyboard
awk '{$1=$1;print}' keyboard > keyboard.disable
awk '{print substr($0,5)}' keyboard.disable > keyboard
xinput disable "$(cat mouse)"
xinput disable "$(cat touchpad)"
xinput disable "$(cat keyboard)"
echo -e "\n********************* Started Building Directory **********************\n"
mkdir rpmbuild
mkdir -p rpmbuild/{BUILD,BUILDROOT,SPECS,RPMS,SOURCES,SRPMS,done}
echo '%_topdir %(echo $HOME)/rpmbuild' > ~/.rpmmacros
rpm -i /home/sas/kernel-4.18.0-147.8.1.el8_1.src.rpm 2>&1 | grep -v exist
cd rpmbuild/SPECS/
rpmbuild -bp --target=$(uname -m) kernel.spec
if [ $? -eq 0 ]; then
   echo -e "\n------------------------EXTRACTION SUCCESS--------------------------------\n"
else
   echo -e "\n------------------------EXTRACTION FAILED---------------------------------\n"
   xinput enable "AT Translated Set 2 keyboard"
   xinput enable "$(cat /home/sas/touchpad)" 
   xinput enable "$(cat /home/sas/mouse)"
   xinput enable "$(cat /home/sas/keyboard)"
   exit 1
fi
cd ~/rpmbuild/BUILD/kernel-*/linux-*/
cp configs/kernel-3.10.0-`uname -m`.config .config
touch check_module
echo "module_header" >> check_module
yes ""|make config > module
#removing tab space in front
sed -i 's/^[ \t]*//' module
#selecting all '*' and moving to file
sed -n '/^*/p' module > mod_list
#sorting the file
sort mod_list > total_mod_list
#removing '*'
sed -i 's/^*//g' total_mod_list
sed -i '/^$/d' total_mod_list
sed -i 's/^[ \t]*//' total_mod_list
sed -r 's/\s+//g' total_mod_list > total_mod_lists
mv total_mod_lists total_mod_list
xdotool getactivewindow > window_id
printf 0x%x $(cat window_id) > window_id
cd
touch total_mod_list
cp ~/rpmbuild/BUILD/kernel-*/linux-*/total_mod_list total_mod_list
cd ~/rpmbuild/BUILD/kernel-*/linux-*/
cp /home/sas/remove_modules .
echo -e "\n*************************************** STARTED MAKE CONFIG AUTOMATION PROCESS ********************************************\n"
sleep 2
make oldconfig
make config|tee log & sh /home/sas/menu_config.sh
echo -e "\n------------------------ MAKE CONFIG AUTOMATION COMPLETE ---------------------------------------\n"
echo -e "\n--------------------------------- Enabling All User Inputs -------------------------------------\n"
xinput enable "AT Translated Set 2 keyboard"
xinput enable "$(cat /home/sas/touchpad)"
xinput enable "$(cat /home/sas/mouse)"
xinput enable "$(cat /home/sas/keyboard)"
make oldconfig
echo -e "\n**************************************** Started compiling kernel *********************************************\n"
make |tee compilelogs
if [ $? -eq 0 ]; then
   echo -e "\n-------------------------COMPILATION SUCCESS---------------------------\n"
else
   echo -e "\n-------------------------COMPILATION FAILED----------------------------\n"
   exit 1
fi
ex -sc '1i|# x86_64' -cx .config
cp .config configs/kernel-3.10.0-`uname -m`.config
cp configs/* ~/rpmbuild/SOURCES/
cd ~/rpmbuild/SPECS/
cp kernel.spec kernel.spec.distro
ex -sc '1i|%define buildid .zoho' -cx kernel.spec
if [ $? -eq 0 ]; then
 echo -e "\n-------------------------------CONFLICT PREVENTED-----------------------------------\n"
else
   echo -e "\n-----------------------------CONFLICT ACCEPTED------------------------------------\n"
fi
echo -e "\n************************************* Started building modules for kernel ****************************************\n"
rpmbuild -bb --target=`uname -m` --without kabichk --with baseonlykernel kernel.spec 2> build-err.log | tee build-out.log
if [ $? -eq 0 ]; then
   echo -e "\n----------------------------------RPM BUILD SUCCESS---------------------------------\n"
else
   echo -e "\n----------------------------------RPM BUILD FAILED----------------------------------\n"
   exit 1
fi
cd ~/rpmbuild/RPMS/`uname -m`/
echo -e "\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Successfully Created Kernel Package [kernel*.rpm] <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n"
cd /home/sas/
rm -rf centos_version kernel_version x touchpad touchpad.disable mouse mouse.disable keyboard.disable keyboard
echo -e "\n------------ Switch to root user and install kernel*.rpm and reboot ------------- \n"
