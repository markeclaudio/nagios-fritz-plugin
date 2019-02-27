# nagios-fritz-plugin
Quick Fritzbox Nagios Plugin To check DSL Bandwith

How To Install:
 ```
 cp check_friz.sh /usr/lib/nagios/plugins/check_friz.sh
 chmod +x /usr/lib/nagios/plugins/check_friz.sh
 cp fritz.cfg  /etc/nagios-plugins/config/check_friz.sh
  ```
You need jq binary 
```
apt install -y jq #Ubuntu-debian
yum install jq # Centos
 ```
 
Example of host definition:
 ```
 define service {
  service_description            ADSL_STate
  host_name                      Hostname
  use                            generic-service,service-pnp
  check_command                  check_fritzbox_bw!admin!password!host:port
 }
 ```


