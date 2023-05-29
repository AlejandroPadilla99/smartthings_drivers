import os

data = {
    "id_driver": '**********',
    "id_channel": '**********',
    "id_hub": '**********',
    "ip_hub": '**********'
}

os.system('smartthings edge:drivers:package')
os.system(f'smartthings edge:channels:assign {data["id_driver"]} -C {data["id_channel"]}')
os.system(f'smartthings edge:drivers:install {data["id_driver"]} -C {data["id_channel"]} -H {data["id_hub"]}')
os.system(f'smartthings edge:drivers:logcat {data["id_driver"]} --hub-address={data["ip_hub"]}')
