$hostname_facts = $facts['hostname']
#$environment_facts = 'prd'
$environment_facts = $facts['ambiente']
$scripts_motd_dir = '/etc/update-motd.d/'

file { $scripts_motd_dir:
  ensure  => directory,
  recurse => true,
  purge   => true,
  force   => true,
}

file { '/etc/motd':
  ensure  => file,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => template('/etc/puppet/templates/matera-banner.erb'),
}

exec { 'remove_duplicate_config_if_exist_users':
  command  => "for USERS in $(cd /home/ && ls); do sed -i '/#Configure-prompt/d' /home/\$USERS/.bashrc; done",
  provider => 'shell',
}

exec { 'remove_duplicate_config_if_exist_root':
  command  => "for USERS in $(cd /home/ && ls); do sed -i '/#Configure-prompt/d' /root/.bashrc; done",
  provider => 'shell',
}

exec { 'customize_prompt_users':
  command  => "for USERS in $(cd /home/ && ls); do echo 'PS1=\"\\[\\e[33;1m\\]\\u@\\[\\e[0;5m\\]\\e[33;2m\\]\\h[${environment_facts}] \\w]\\$\\[\\e[0m\\]\" #Configure-prompt' >> /home/\$USERS/.bashrc; done",
  provider => 'shell',
}

exec { 'customize_prompt_root':
  command => "echo 'PS1=\"\\[\\e[33;1m\\]\\u@\\[\\e[0;5m\\]\\e[33;2m\\]\\h[${environment_facts}] \\w]\\$\\[\\e[0m\\]\" #Configure-prompt' >> /root/.bashrc",
  path    => '/usr/bin',
}


