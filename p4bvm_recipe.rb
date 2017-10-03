
# p4 recepi for itamae

# dependencies
execute "update" do
  user "root"
  command "apt-get -y update"
end

%w(g++ git automake libtool libgc-dev bison libjudy-dev
  flex libfl-dev libgmp-dev libboost-dev cmake libpcap-dev
  libboost-iostreams-dev pkg-config libffi-dev libboost-thread-dev
  python python-pip python-scapy python-ipaddr libboost-program-options-dev
  tcpdump doxygen graphviz texlive-full libssl-dev
  autoconf libtool curl make unzip mininet).each do |pkg|
  execute pkg do
    command "apt-get install -y #{pkg}"
    user "root"
  end
end

execute "pip update" do
  command "pip install --upgrade pip"
  user "root"
end
 
# Google Protocol Buffers v3.x
git "get protobuf" do
  destination "/var/tmp/protobuf"
  repository "https://github.com/google/protobuf.git"
  not_if "ls /var/tmp/protobuf/README.md"
end

execute "install protobuf" do
  command <<-"EOH"
git checkout v3.0.2
./autogen.sh
./configure
make
make check
sudo make install
sudo ldconfig
EOH
  cwd "/var/tmp/protobuf"
end

# p4c
execute "get p4c" do
  command "git clone --recursive https://github.com/p4lang/p4c.git p4c"
  cwd "/var/tmp"
  not_if "ls /var/tmp/p4c/README.md"
end

# install p4c
execute "install p4c" do
  command <<-"EOH"
./bootstrap.sh
cd build
make -j4
make -j4 check
sudo make install
EOH
  cwd "/var/tmp/p4c"
end


git "get thrift" do
  destination "/var/tmp/thrift"
  repository "https://github.com/apache/thrift.git"
  not_if "ls /var/tmp/thrift/README.md"
end

execute "install thrift" do
  command <<-"EOH"
./bootstrap.sh
./configure --with-cpp=yes --with-c_glib=no --with-java=no \
    --with-ruby=no --with-erlang=no --with-go=no --with-nodejs=no
make
sudo make install
cd lib/py
sudo python setup.py install
EOH
  cwd "/var/tmp/thrift"
end

git "get nanomsg" do
  destination "/var/tmp/nanomsg"
  repository "https://github.com/nanomsg/nanomsg.git"
  not_if "ls /var/tmp/nanomsg/README.md"
end

execute "install nanomsg" do
  command <<-"EOH"
mkdir build
cd build
cmake ..
cmake --build .
ctest -C Debug .
sudo cmake --build . --target install
sudo ldconfig
EOH
  cwd "/var/tmp/nanomsg"
end

git "get nnpy" do
  destination "/var/tmp/nnpy"
  repository "https://github.com/nanomsg/nnpy.git"
  not_if "ls /var/tmp/nnpy"
end

execute "install nnpy" do
  command "sudo pip install ."
  cwd "/var/tmp/nnpy"
end

git "get bmv2" do
  destination "/var/tmp/bmv2"
  repository "https://github.com/p4lang/behavioral-model.git"
  not_if "ls /var/tmp/bmv2/README.md"
end

execute "install bmv2" do
  command <<-"EOH"
sed -i -e 's/shared_ptr/std::shared_ptr/' src/bm_runtime/server.cpp
sed -i -e 's/using boost::std::shared_ptr;//' src/bm_runtime/server.cpp
sed -i -e 's/boost::shared_ptr/std::shared_ptr/' src/bm_apps/learn.cpp
sed -i -e 's/boost::shared_ptr/std::shared_ptr/' include/bm/bm_apps/learn.h
sed -i -e 's&#include <boost/shared_ptr.hpp>&&' include/bm/bm_apps/learn.h
sed -i -e 's/boost::shared_ptr/std::shared_ptr/' targets/l2_switch/learn_client/learn_client.cpp
sed -i -e 's/boost::shared_ptr/std::shared_ptr/' targets/simple_switch/thrift/src/SimpleSwitch_server.cpp
sed -i -e 's/boost::shared_ptr/std::shared_ptr/' include/bm/bm_runtime/bm_runtime.h

./autogen.sh
./configure
make -j2
sudo make install
EOH
  cwd "/var/tmp/bmv2"
end

