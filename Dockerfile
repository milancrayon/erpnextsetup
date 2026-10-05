FROM frappe/erpnext:v16.37.0

USER frappe
WORKDIR /home/frappe/frappe-bench

RUN mkdir -p sites \
    && printf '{\n  "socketio_port": 9000\n}\n' > sites/common_site_config.json \
    && printf 'frappe\nerpnext\n' > sites/apps.txt

RUN bench get-app https://github.com/frappe/hrms --branch version-16 --skip-assets
RUN bench get-app https://github.com/frappe/crm --branch develop --skip-assets

RUN ls -1 apps > sites/apps.txt \
    && bench build --apps hrms,crm
