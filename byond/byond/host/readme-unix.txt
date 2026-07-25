
For a longer introduction to BYOND hosting and what-not, take a peek at
readme.html and hostconf.txt.  Then follow these simple steps to get a server
up and running fast.


1. Stick the host directory where you want it to be.  A good place would
probably be right where it is now.

2. Create the file ~/.byond/cfg/admin.txt and add the following line,
substituting your BYOND key for "JamesByond".  (Leave out any spaces or
punctuation.  Capitalization is arbitrary.)

JamesByond role=root

3. Boot up the host server with the following command (you have to enter the
path to this file if it's not your current directory):

host.start

4. Take a peek in host.log and make sure it claims to have started up
successfuly.  If it couldn't open port 1025, then edit hostconf.txt and change
the port.

5. Now you have a couple options.  If you have BYOND installed on a windows
machine and you can reach your UNIX box through the network, go to
byond://unix-address:1025 (replacing unix-address with your machine's actual
address).  You should get routed to the root admin utility.  Now you're home
free.

6. Your other option, if you have a web server running, is to copy
host/home/root/tools/root/root.dmb into a CGI-enabled web directory and access
that through the web.  If you don't want to bother adding .dmb as a CGI
extension, just rename it to root.cgi.

7. Still another option is to simply administer things by hand.  It's actually
really easy.  Just edit hostconf.txt and read the comments.

8. If you are behind a firewall, you'll need to open up a few ports.  You'll
need one for the host server itself and then at least one more so worlds
(including the admin utilities) can open a network port.  Edit hostconf.txt
so it knows what ports to use.


That's all.  Have fun!

Oh, and be sure to download the source sometime (byond://Dantom.HostSource) so
you can hack it and feel like a super-powerful-root-programmer.  If you grab
it with the DreamDownload utility on your UNIX box, it will put it in:
  ~/.byond/lib/dantom/hostsource.

