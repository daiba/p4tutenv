# p4 language tutorial environment construct script

This script use [itamae](https://github.com/itamae-kitchen/itamae) to
install [p4 language tutorials](https://github.com/p4lang/tutorials) environment.
For this script, I use GCE vCPUx1, Ubuntu 16.04 LTS, HDD 40GB.

## Installation

```
$ sudo apt-get -y update
$ sudo atp-get -y upgrade
$ sudo apt-get -y install ruby
$ sudo gem install itamae
$ itamae local p4bvm_recipe.rb
```

## versons

- protobuf 3.0.2
- p4v 0.1
- thrift 1.0.0-dev
- nanomsg 1.0.0
- behavioral-model 1.9.0

