#NOTE: just type 'make' for instructions.  To setup a personal installation
#of byond (not available to other users on the system), simply type
#'make here'.

#To install on the entire system, change any of the following parameters
#(they should be correct for most systems), su to root, and type
#'make install'.


#Location of BYOND system files.  If you install it in some other location,
#you will need to define the environment variable BYOND_SYSTEM in your
#system profile script and point it to that location.

BYOND_SYSTEM = /usr/local/byond

#Location of executables.  Actually, we only place symbolic links there
#pointing to the real location.  It should be a place in your PATH.

BIN_DIR = /usr/local/bin

#Location of shared libraries.  We put a symbolic link there too.  This
#should be a place where ldd expects to find shared libraries (either listed
#in /etc/ld.so.conf or in your LD_LIBRARY_PATH environment variable).

LIB_DIR = /usr/local/lib

#Location of manual pages.  Once again, a symbolic link is used from here
#to the true location of the files.  This allows for easy upgrade/removal
#in the future.

MAN_DIR = /usr/share/man

#If you are installing as root, DreamDaemon can be installed
#suid root, which makes it possible to honor the suid flag
#on dmb files (so they can run as the owner of the .dmb).  This
#is entirely optional.  Uncomment the following line if you
#want that and are installing as root.

#ENABLE_SUID = yes


#A world hosting server has also been included in this package.
#Read about it in host/readme.html.  If you want to host right
#out of each user's home directory (like a typical web hosting
#setup), then host.dmb must be run as root.  You can accomplish
#that either by logging in as root when you start it up, or you
#could make host.dmb suid-root, which will allow non-root users
#to start it up.  The latter option requires that DreamDaemon
#also be suid-root, so you have to answer yes to the question
#above if you answer yes here.

#HOST_SUID_ROOT = yes

instructions:
	@echo "There are two options for installing BYOND.  You can install"
	@echo "it for all users or you can install it for your own personal"
	@echo "use.  To install for all users, you must run this makefile"
	@echo "as root.  In that case, edit this makefile, configure the"
	@echo "installation parameters to your liking, and run 'make install'."
	@echo
	@echo "To install for your personal use, simply put the 'byond'"
	@echo "directory where you want to keep it and type 'make here'."
	@echo


install:
	if [ ! -d $(BYOND_SYSTEM) ]; then mkdir $(BYOND_SYSTEM); fi
	cp -R cfg web bin man $(BYOND_SYSTEM)
	if [ "$(ENABLE_SUID)" = "yes" ]; then \
		chown root $(BYOND_SYSTEM)/bin/DreamDaemon; \
		chmod a+xs $(BYOND_SYSTEM)/bin/DreamDaemon; \
		if [ "$(HOST_SUID_ROOT)" = "yes" ]; then \
			chown root host/host.dmb; \
			chmod a+xs host/host.dmb; \
		fi \
	fi
	ln -f -s $(BYOND_SYSTEM)/bin/DreamDaemon $(BIN_DIR)/DreamDaemon
	ln -f -s $(BYOND_SYSTEM)/bin/DreamDownload $(BIN_DIR)/DreamDownload
	ln -f -s $(BYOND_SYSTEM)/bin/DreamMaker $(BIN_DIR)/DreamMaker
	mkdir -p $(MAN_DIR)/man6
	ln -f -s $(BYOND_SYSTEM)/man/man6/DreamDaemon.6 $(MAN_DIR)/man6/DreamDaemon.6
	ln -f -s $(BYOND_SYSTEM)/man/man6/DreamMaker.6 $(MAN_DIR)/man6/DreamMaker.6
	@uname=`uname`; \
	if [ "$$uname" != "Darwin" ]; then \
		ln -f -s $(BYOND_SYSTEM)/bin/libbyond.so $(LIB_DIR)/libbyond.so; \
		ln -f -s $(BYOND_SYSTEM)/bin/libext.so $(LIB_DIR)/libext.so; \
		ldopts=""; \
		if [ "$$uname" = "OpenBSD" ]; then ldopts="-m"; fi; \
		if [ "$$uname" = "FreeBSD" ]; then ldopts="-m"; fi; \
		/sbin/ldconfig $$ldopts $(LIB_DIR); \
	fi

	@echo
	@echo "*****************"
	@echo "You can find out more about the software by doing 'man DreamDaemon'."
	@echo "A host server has also been included so edit host/hostconf.txt and"
	@echo "boot up your world server!"
	@echo "*****************"
	@echo

here:
	@rm -f bin/byondsetup
	@$(MAKE) --no-print-directory bin/byondsetup BYOND_SYSTEM=$(PWD)


bin/byondsetup:
	@echo "#sh compatible environment settings (comment out to dissable)" >> bin/byondsetup
	@echo "export BYOND_SYSTEM=$(BYOND_SYSTEM)" >> bin/byondsetup
	@echo "export PATH=$(BYOND_SYSTEM)/bin:\$$PATH" >> bin/byondsetup
	@echo "export LD_LIBRARY_PATH=$(BYOND_SYSTEM)/bin:\$$LD_LIBRARY_PATH" >> bin/byondsetup
	@echo "export MANPATH=$(BYOND_SYSTEM)/man:\$$MANPATH" >> bin/byondsetup
	@echo "" >> bin/byondsetup
	@echo "#csh compatible environment settings (uncomment to enable)" >> bin/byondsetup
	@echo "#setenv BYOND_SYSTEM $(BYOND_SYSTEM)" >> bin/byondsetup
	@echo "#setenv PATH $(BYOND_SYSTEM)/bin:\$$PATH" >> bin/byondsetup
	@echo "#setenv MANPATH $(BYOND_SYSTEM)/man:\$$MANPATH" >> bin/byondsetup
	@echo "#setenv LD_LIBRARY_PATH $(BYOND_SYSTEM)/bin:\$$LD_LIBRARY_PATH" >> bin/byondsetup
	@chmod +x bin/byondsetup

	@echo "***************************"
	@echo "Now run the following command:"
	@echo
	@echo source $(BYOND_SYSTEM)/bin/byondsetup
	@echo
	@echo "If it generates errors, your shell is not compatible with 'sh', so you will"
	@echo "have to edit byondsetup and make it work with your shell.  If the script works, you should be able to run DreamDaemon."
	@echo
	@echo "IMPORTANT: once you have the script working, you must add the above line"
	@echo "to your startup script.  The name of your startup script depends on the"
	@echo "shell you use.  Typical ones are .profile or .bash_profile."
	@echo
	@echo "Once everything is working, you can find out more about the software"
	@echo "by doing 'man DreamDaemon'.  A host server has also been included"
	@echo "so edit host/hostconf.txt and boot up your world server!"
	@echo "***************************"
