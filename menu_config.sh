cd ~/rpmbuild/BUILD/k*/l*/
xdotool windowactivate $(cat window_id)
sleep 2
cd ~/rpmbuild/B*/k*/l*/
while [ 1 ]
do
{
cp log copylog
sed -i 's/^[ \t]*//' copylog
sed -n '/^*/p' copylog > starlog
sed -n '/^#/p' copylog > ashlog
sed -n '$p' copylog > endlog
sed -r 's/\s+//g' endlog > endlogs
mv endlogs endlog
sed -i 's/^*//g' starlog
sed -i '/^$/d' starlog
sed -n '$p' starlog > endstar
sed -i 's/^[ \t]*//' endstar
sed -r 's/\s+//g' endstar > endstars
mv endstars endstar
z=0
p=0
# NUMBER CHOICE
if grep -q choice endlog
then
xdotool key Return
z=1
fi
# END OF CONFIG
if grep -q ^# ashlog
then
z=1
echo -e "\n---------------------------- MAKE CONFIG AUTOMATION COMPLETE -----------------------------------\n"
break
fi
# Lastline check
if [[ "$(cat check_module)" == "$(cat endlog)" ]]; then
xdotool key Return
z=1
fi
# REMOVING MODULES
if [[ $z == 0 ]]; then
if grep -q ^"$(cat endstar)" remove_modules
then
xdotool key n Return
cat endstar >> /home/sas/removed_modules
p=1
else
xdotool key Return
p=1
fi
fi
cat endlog > check_module
rm copylog starlog endstar
}
done

