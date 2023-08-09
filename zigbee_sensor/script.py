import os

data = {
    "id_driver": 'c6c78357-c997-437f-b67d-e00161fe20cd',
    "id_channel": '1d1aa753-fcc5-4c22-b608-ae4f26d7deee',
    "id_hub": 'f374e792-e093-4196-a18e-79a822fbb708',
    "ip_hub": '192.168.86.176'
}

os.system('smartthings edge:drivers:package')
os.system(f'smartthings edge:channels:assign {data["id_driver"]} -C {data["id_channel"]}')
os.system(f'smartthings edge:drivers:install {data["id_driver"]} -C {data["id_channel"]} -H {data["id_hub"]}')
os.system(f'smartthings edge:drivers:logcat {data["id_driver"]} --hub-address={data["ip_hub"]}')
