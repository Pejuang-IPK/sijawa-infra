#!/usr/bin/env bash

DC="docker compose"

help_menu() {
  echo ""
  echo "===== DEV.SH COMMAND LIST ====="
  echo ""
  echo " up            : Jalankan semua container"
  echo " down          : Stop semua container"
  echo " restart       : Restart semua container"
  echo " build         : Build image"
  echo " rebuild       : Build tanpa cache"
  echo " logs          : Lihat logs"
  echo ""
  echo " php           : Masuk ke container PHP"
  echo " mysql         : Masuk ke MySQL CLI"
  echo " nginx         : Masuk ke container Nginx"
  echo " nagios        : Masuk container Nagios"
  echo " minio         : Masuk container MinIO"
  echo ""
  echo "Fix permission issues automatically"
  echo ""
}

case "$1" in
  up) $DC up -d ;;
  down) $DC down ;;
  restart) $DC down && $DC up -d ;;
  build) $DC build ;;
  rebuild) $DC build --no-cache ;;
  logs) $DC logs -f ;;

  php) docker exec -it php_fpm bash ;;
  mysql) docker exec -it mysql_sijawa mysql -uappuser -psecret appdb ;;
  nginx) docker exec -it nginx_sijawa bash ;;
  nagios) docker exec -it nagios_sijawa bash ;;
  minio) docker exec -it minio_sijawa sh ;;

  *) help_menu ;;
esac
