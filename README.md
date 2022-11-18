Docker Image Apache 2.4 e PHP-FPM da usare come base per Hosting
================================================================

## Info
Repository con il dockerfile per una immagine docker con Apache e PHP-FPM da usare per Hosting.
Utilizza supervisord per farli partire.
Derivata da:
* **scolagreco/docker-apache24:2.4.54**

- [`2.4.54`](https://github.com/scolagreco/docker-apache24/releases/tag/2.4.54)

Questa versione ha PHP 8.1

## Utilizzo

* **docker run --name alpine_apache_php-fpm -p 80:80 -e domain=colagreco.it -t -i -d scolagreco/alpine_apache_php-fpm**
