Kernel customization involves removing vulnerable kernel modules like usb, bluetooth drivers, audio , video etc.
Currently developers are using the following options -> menuconfig, gconfig, xconfig.
These options require manual interventions to enable/disable kernel modules.
Selecting and identifying and enabling/disabling kernel modules is highly complex as kernel is built up with tons of modules/ sub-modules.
This automated script instead takes the name of modules to be removed in a separate file and start removing the modules and build a customized kernel and so that we can deploy the kernel in our data center environments. 
