define apache::auth::basic::ldap(
  $vhost,
  $authLDAPUrl,
  $ensure='present',
  $authname=false,
  $location='/',
  $authLDAPBindDN=false,
  $authLDAPBindPassword=false,
  $authLDAPCharsetConfig=false,
  $authLDAPCompareDNOnServer=false,
  $authLDAPDereferenceAliases=false,
  $authLDAPGroupAttribute=false,
  $authLDAPGroupAttributeIsDN=false,
  $authLDAPRemoteUserAttribute=false,
  $authLDAPRemoteUserIsDN=false,
  $authzLDAPAuthoritative=false,
  $authzRequire='valid-user',
) {

  $fname = regsubst($name, '\s', '_', 'G')

  $wwwroot = $apache::root
  validate_absolute_path($wwwroot)

  if defined(Apache::Module['ldap']) {} else {
    apache::module {'ldap': }
  }

  if defined(Apache::Module['authnz_ldap']) {} else {
    apache::module {'authnz_ldap': }
  }

  if $authname {
    $_authname = $authname
  } else {
    $_authname = $name
  }

  $seltype = $::operatingsystem ? {
    'RedHat' => 'httpd_config_t',
    'CentOS' => 'httpd_config_t',
    default  => undef,
  }
  file { "${wwwroot}/${vhost}/conf/auth-basic-ldap-${fname}.conf":
    ensure  => $ensure,
    content => template("${module_name}/auth-basic-ldap.erb"),
    seltype => $seltype,
    notify  => Exec['apache-graceful'],
  }

}
