CREATE DATABASE IF NOT EXISTS crmtest
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE crmtest;

CREATE TABLE `Cliente` (
  `ID_cliente` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `Nombre_empresa` VARCHAR(100) NOT NULL,
  `Encargado` VARCHAR(50) NOT NULL,
  `Numero` varchar(10) NOT NULL
);

CREATE TABLE `Unidades_catalogo` (
  `ID_Unidad_modelo` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `Marca_unidad` VARCHAR(100),
  `Modelo_Unidad` VARCHAR(100)
);

CREATE TABLE `Equipos_catalogo` (
  `ID_equipo_modelo` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `Marca_equipo` VARCHAR(100),
  `Modelo_equipo` VARCHAR(100)
);

CREATE TABLE `Equipos` (
  `ID_equipo` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `ID_equipo_modelo` int NOT NULL,
  `IMEI` VARCHAR(100),
  `ID_modem` VARCHAR(100),
  `Estatus_equipo` ENUM('En espera','Asignado','Instalado') DEFAULT 'En espera'
);

CREATE TABLE `Unidades` (
  `ID_unidad` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `ID_Unidad_modelo` int NOT NULL,
  `ID_equipo` int UNIQUE,
  `ID_ticket` int NOT NULL,
  `Placa_unidad` VARCHAR(100),
  `Vin_unidad` VARCHAR(100)
);

CREATE TABLE `Tecnicos` (
  `ID_Tecnico` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `Nombre_tecnico` VARCHAR(100),
  `Estatus_tecnico` ENUM('Activo','Inactivo'),
  `Numero_tecnico` VARCHAR(100)
);

CREATE TABLE `Tickets` (
  `ID_ticket` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `ID_tecnico` int,
  `ID_cliente` int NOT NULL,
  `Tipo_servicio` ENUM('Instalacion','Desinstalacion','Revision','Rescate'),
  `Estatus_servicio` ENUM('En espera','En seguimiento','Finalizado') DEFAULT 'En espera',
  `Numero_unidades` int,
  `Fecha_servicio` DATETIME,
  `Link_maps` VARCHAR(255),
  `Comentarios` TEXT
);

CREATE TABLE `Accesorios_catalogo` (
  `ID_accesorio_modelo` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `Nombre_accesorio` VARCHAR(100)
);

CREATE TABLE `Accesorios` (
  `ID_accesorio` int PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `ID_accesorio_modelo` int NOT NULL,
  `Estatus_accesorio` ENUM('En espera','Instalado') DEFAULT 'En espera'
);

CREATE TABLE `Unidad_Accesorio` (
  `ID_unidad` int NOT NULL,
  `ID_accesorio` int NOT NULL,
  PRIMARY KEY (`ID_unidad`, `ID_accesorio`)
);

CREATE TABLE IF NOT EXISTS `Ticket_fotos` (
    `ID_foto` INT NOT NULL AUTO_INCREMENT,
    `Ruta_archivo` VARCHAR(255) NOT NULL,
    `Nombre_original` VARCHAR(255) DEFAULT NULL,
    `createdAt` DATETIME NOT NULL,
    `updatedAt` DATETIME NOT NULL,
    `ID_ticket` INT NOT NULL,
    PRIMARY KEY (`ID_foto`),
    INDEX `idx_ticket_fotos_ticket` (`ID_ticket`),
    CONSTRAINT `fk_ticket_fotos_ticket`
        FOREIGN KEY (`ID_ticket`)
        REFERENCES `Tickets` (`ID_ticket`)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

ALTER TABLE `Unidades` ADD FOREIGN KEY (`ID_Unidad_modelo`) REFERENCES `Unidades_catalogo` (`ID_Unidad_modelo`);

ALTER TABLE `Unidades` ADD FOREIGN KEY (`ID_equipo`) REFERENCES `Equipos` (`ID_equipo`);

ALTER TABLE `Unidades` ADD FOREIGN KEY (`ID_ticket`) REFERENCES `Tickets` (`ID_ticket`);

ALTER TABLE `Tickets` ADD FOREIGN KEY (`ID_tecnico`) REFERENCES `Tecnicos` (`ID_Tecnico`);

ALTER TABLE `Tickets` ADD FOREIGN KEY (`ID_cliente`) REFERENCES `Cliente` (`ID_cliente`);

ALTER TABLE `Equipos` ADD FOREIGN KEY (`ID_equipo_modelo`) REFERENCES `Equipos_catalogo` (`ID_equipo_modelo`);

ALTER TABLE `Accesorios` ADD FOREIGN KEY (`ID_accesorio_modelo`) REFERENCES `Accesorios_catalogo` (`ID_accesorio_modelo`);

ALTER TABLE `Unidad_Accesorio` ADD FOREIGN KEY (`ID_unidad`) REFERENCES `Unidades` (`ID_unidad`);

ALTER TABLE `Unidad_Accesorio` ADD FOREIGN KEY (`ID_accesorio`) REFERENCES `Accesorios` (`ID_accesorio`);
--
ALTER TABLE Tickets ADD Estatus_unidades Boolean Default 0;

ALTER TABLE Unidad_Accesorio DROP FOREIGN KEY Unidad_Accesorio_ibfk_2;
ALTER TABLE Unidad_Accesorio
  ADD CONSTRAINT fk_unidad_accesorio_catalogo
  FOREIGN KEY (ID_accesorio)
  REFERENCES Accesorios_catalogo (ID_accesorio_modelo);
  