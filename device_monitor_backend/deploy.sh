sudo git checkout $1
sudo git pull origin $1 --ff
sudo docker compose down
sudo docker compose up --build -d