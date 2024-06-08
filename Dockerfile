FROM ubuntu:latest

# Actualizar paquetes
RUN apt update -y && apt upgrade -y

# Instalar dependencias de Nagios
RUN apt install -y apache2 php php-mysqlnd mysql-server gcc fontconfig perl

# Iniciar servicio MySQL
RUN systemctl start mysql

# Crear base de datos Nagios
RUN mysql -u root -p < /var/lib/mysql-install-db/nagios.sql

# Descargar e instalar Nagios
RUN wget https://releases.nagios.org/downloads/nagios/6/nagios-6.6.2.tar.gz
RUN tar -xf nagios-6.6.2.tar.gz
RUN cd nagios-6.6.2
RUN ./configure --prefix=/usr/local/nagios
RUN make all
RUN make install

# Configurar Nagios para que se inicie al arrancar
RUN cp /usr/local/nagios/etc/nagios.cfg /etc/nagios/nagios.cfg
RUN systemctl enable nagios
RUN systemctl start nagios

# Exponer puerto 80 para la interfaz web de Nagios
EXPOSE 80

CMD ["/usr/local/nagios/bin/nagios", "-d", "/etc/nagios/nagios.cfg"]