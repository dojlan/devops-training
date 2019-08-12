class install_docker {

  # installing with all the default options
  include ::docker

  class { 'docker' :
    manage_package => true,
    package_name   => 'docker-engine',
  }

}

