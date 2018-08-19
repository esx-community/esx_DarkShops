USE `essentialmode`;

CREATE TABLE `darkshops` (
  
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `item` varchar(255) NOT NULL,
  `price` int(11) NOT NULL,
  
  PRIMARY KEY (`id`)
);

INSERT INTO `darkshops` (name, item, price) VALUES
	('Darks','Darknet',15)
;