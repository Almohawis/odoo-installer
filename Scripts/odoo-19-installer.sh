#!/bin/bash
# Programming By Sulaiman ALmohawis Github : ALmohawis
echo "
Odoo Setup By:
_______  _        _______  _______           _______          _________ _______ 
(  ___  )( ╲      (       )(  ___  )│╲     ╱│(  ___  )│╲     ╱│╲__   __╱(  ____ ╲
│ (   ) ││ (      │ () () ││ (   ) ││ )   ( ││ (   ) ││ )   ( │   ) (   │ (    ╲╱
│ (___) ││ │      │ ││ ││ ││ │   │ ││ (___) ││ (___) ││ │ _ │ │   │ │   │ (_____ 
│  ___  ││ │      │ │(_)│ ││ │   │ ││  ___  ││  ___  ││ │( )│ │   │ │   (_____  )
│ (   ) ││ │      │ │   │ ││ │   │ ││ (   ) ││ (   ) ││ ││ ││ │   │ │         ) │
│ )   ( ││ (____╱╲│ )   ( ││ (___) ││ )   ( ││ )   ( ││ () () │___) (___╱╲____) │
│╱     ╲│(_______╱│╱     ╲│(_______)│╱     ╲││╱     ╲│(_______)╲_______╱╲_______)
                                                                                                                                                                                             
                                                                                                                             "

read -p "admin password: " AP
read -p "Port Number (By Default is 8069 Press Enter) ===>" Port

if [ -z "$AP" ]; then
  echo "Password cannot be empty, Please Run setup-odoo Again"
  exit 1
fi
if [ -z "$Port" ]; then
  Port=8069
fi

apt update
wait
apt full-upgrade -y
wait
apt install python3-minimal python3-dev python3-pip python3-venv python3-setuptools build-essential libzip-dev libxslt1-dev libldap2-dev python3-wheel libsasl2-dev node-less libjpeg-dev xfonts-utils libpq-dev libffi-dev fontconfig git wget postgresql nodejs npm xfonts-75dpi xfonts-base wkhtmltopdf -y
wait
systemctl start postgresql
wait
apt install -f -y
wait
sudo -u postgres createuser --superuser odoo
wait
npm install -g rtlcss
wait
apt install -f -y
wait
adduser --system --group --home=/opt/odoo --shell=/bin/bash odoo
wait
sudo -u odoo bash -c "
cd /opt/odoo
git clone https://github.com/odoo/odoo --depth 1 --branch 19.0 odoo
python3 -m venv odoo-env
source odoo-env/bin/activate
pip3 install wheel
pip3 install -r odoo/requirements.txt
deactivate
"
wait
mkdir /opt/odoo/custom-addons
wait
mkdir /var/log/odoo19
wait
chown odoo:odoo /var/log/odoo19
wait
chown odoo:odoo /opt/odoo/custom-addons
echo "[options]
admin_passwd = $AP
db_host = False
db_port = False
db_user = odoo
db_password = False
logfile = /var/log/odoo19/odoo-server.log
addons_path = /opt/odoo/odoo/addons,/opt/odoo/custom-addons
xmlrpc_port = 8069" > /etc/odoo.conf
wait
echo "[Unit]
Description=Odoo
Requires=postgresql.service
After=network.target postgresql.service

[Service]
Type=simple
SyslogIdentifier=odoo
PermissionsStartOnly=true
User=odoo
Group=odoo
ExecStart=/opt/odoo/odoo-env/bin/python3 /opt/odoo/odoo/odoo-bin -c /etc/odoo.conf
StandardOutput=journal+console

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/odoo.service
wait
systemctl daemon-reload
wait
systemctl start odoo
wait
systemctl enable odoo
wait
systemctl status odoo --no-pager
echo "
  ____                   
 │  _ ╲  ___  _ __   ___ 
 │ │ │ │╱ _ ╲│ '_ ╲ ╱ _ ╲
 │ │_│ │ (_) │ │ │ │  __╱
 │____╱ ╲___╱│_│ │_│╲___│
                         
If the output is \"active\" this means that the Odoo System is installed without any problems

{YourIPorDomain:8069}
Master Password Is \"admin Password\" 
GitHub.com/ALmohawis
"
