DROP database keystone;
create database keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'r00tme';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'r00tme';

CREATE TABLE role (id VARCHAR(64) NOT NULL, name VARCHAR(255) NOT NULL, extra TEXT, PRIMARY KEY (id)) ENGINE = InnoDB;
