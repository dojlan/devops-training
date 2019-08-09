FROM  devopsedu/webapp 
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
COPY  website/ /var/www/public
RUN  a2enmod rewrite
RUN  service apache2 restart 

EXPOSE 80
