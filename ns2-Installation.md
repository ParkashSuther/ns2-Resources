## Steps for ns2 Installation

Step 1:

### Building dependencies
1. ``sudo apt-get update``
2. ``sudo apt-get dist-upgrade``
3. ``sudo apt-get update``
4. ``sudo apt-get install gcc``
5. ``sudo apt-get install build-essential autoconf automake``
6. ``sudo apt-get install tcl8.5-dev tk8.5-dev``
7. ``sudo apt-get install perl xgraph libxt-dev libx11-dev libxmu-dev``

Step 2:

Step 2.1: Download ns-allinone-2.xy

1. ``sudo wget https://sourceforge.net/projects/nsnam/files/allinone/ns-allinone-2.33/ns-allinone-2.xy.tar.gz``

2. ``sudo tar -zxvf ns-allinone-2.xy.tar.gz``
3. ``cd ns-allinone-2.xy``
4. ``sudo ./install``

Note: "2.xy" in ns-allinone.2.xy indicate the different releases (2.29, 2.30, 2.31, 2.32, 2.33, 2.34 and recent 2.35) of ns2.

Step 3: After successful installtaion of Step 2,

### Setting PATH

``sudo gedit ~/.bashrc``

PATH=$PATH:/home/maggi/ns-allinone-2.35/bin:/home/maggi/ns-allinone-2.35/tcl8.5.10/unix:/home/maggi/ns-allinone-2.35/tk8.5.10/unix

LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/maggi/ns-allinone-2.35/otcl-1.14:/home/maggi/ns-allinone-2.35/lib

TCL_LIBRARY=$TCL_LIBRARY:/home/maggi/ns-allinone-2.35/tcl8.5.10/library

``sudo source ~/.bashrc``

### Important 

During installtion many errors result due to compiler issue.

Step 1: Edit Makefile.in and change CC = @CC@ to CC = @CC@-4.4 and CPP = @CXX@ to CPP = @CXX@-4.4

References:

1. http://ftp.isi.edu/nsnam/dist/
