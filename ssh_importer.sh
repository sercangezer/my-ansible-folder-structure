#!/bin/bash

# Sunucuları local dns ekleyelim
cat << EOF | sudo tee --append /etc/hosts

# ansible nodeları
192.168.200.30	controller01-u22
192.168.200.31	worker01-u22
192.168.200.32	worker02-u22
192.168.200.33 	worker03-u22
192.168.200.34	worker04-u24
192.168.200.35	worker05-alma9
EOF


# Anahtar oluşturma
ssh-keygen -t rsa -b 4096 -N "" -f /home/ansible/.ssh/id_rsa

if [ $? -ne 0 ]; then
    echo "Anahtar oluşturma başarısız oldu."
    exit 1
fi

echo "id_rsa anahtarı oluşturuldu."

# Ansible host listesi (değiştirebilirsiniz)
ansible_hosts=("192.168.200.31" "192.168.200.32" "192.168.200.33" "192.168.200.34" "192.168.200.35" "worker01-u22" "worker02-u22" "worker03-u22" "worker04-u24" "worker05-alma9") # Örnek olarak host1, host2, host3 verdim

# Şifre (değiştirebilirsiniz, daha güvenli yöntemler kullanmanız önerilir)
sys_req_password="ansible"

# Kullanıcı adı (değiştirebilirsiniz)
sys_req_username="ansible"

# Her bir host için anahtarı sil ve kopyala
for host in "${ansible_hosts[@]}"; do
    echo "$host adresindeki mevcut anahtar siliniyor..."
    ssh-keygen -R "$host"
    
    echo "Anahtar $host adresine kopyalanıyor..."
    sshpass -p "$sys_req_password" ssh-copy-id -o StrictHostKeyChecking=no -i /home/ansible/.ssh/id_rsa.pub "$sys_req_username@$host"
    if [ $? -eq 0 ]; then
        echo "Anahtar $host adresine başarıyla kopyalandı."
    else
        echo "Anahtar $host adresine kopyalanırken hata oluştu."
    fi
done

echo "İşlem tamamlandı."

exit 0