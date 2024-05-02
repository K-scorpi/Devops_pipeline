### Запуск docker контейнера
docker-compose up -d

docker network create my-network

docker exec -it server2 bash 
### Для индивидуальных контейнеров 
sudo docker run -it --rm 47955169devops:latest

В целях труднозатроности и неустоичисвости, вынужден разбить на образы и скомпоновать из отдельно
### Задачи на проект
- [ ] Запустить nginx на server_2
- [x] Запустить server2 и проверить работоспособность 
- [x] Подтянуть postgres на server_1
- [x] Настроить доступ к PostgreSQL на сервере А только с сервера Б, закроет доступ к nginx на сервере Б с сервера А