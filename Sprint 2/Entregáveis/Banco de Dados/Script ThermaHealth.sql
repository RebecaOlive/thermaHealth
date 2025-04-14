CREATE database thermaHealth;
USE thermaHealth;

CREATE TABLE hospital(
idHospital INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(45),
sufixo CHAR(4),
cnpj CHAR(8),
digitoVerifica CHAR(2),
razaoSocial VARCHAR(200)
);

CREATE TABLE funcionario(
idFuncionario INT PRIMARY KEY AUTO_INCREMENT, 
matricula VARCHAR(10),
nome VARCHAR(100),
senha VARCHAR(32),
nivelAcesso CHAR(1),
email VARCHAR(255),
fkSupervisor INT,
constraint fkFuncSuper foreign key (fkSupervisor)
references funcionario(idFuncionario),
fkHospital INT,
constraint fkFuncHospital foreign key (fkHospital)
references hospital(idHospital)
);

CREATE TABLE sala(
idSala INT PRIMARY KEY AUTO_INCREMENT,
setor VARCHAR(45), 
nome VARCHAR(45),
descricao TEXT,
andar TINYINT, 
fkHospital INT,
constraint fkSalaHospital foreign key (fkHospital)
references hospital(idHospital)
);

CREATE TABLE parametrosIdeais(
idParametros INT,
fkSensor INT,
constraint pkParametrosIdeais primary key (idParametros, fkSensor),
temperatura_min FLOAT NOT NULL,
temperatura_max FLOAT NOT NULL,
umidade_min INT NOT NULL,
umidade_max INT NOT NULL
);

CREATE TABLE sensor(
	idSensor INT PRIMARY KEY AUTO_INCREMENT,
	tipo VARCHAR(5),
	numeroSerie VARCHAR(22),
	statusSensor VARCHAR(45),
	fkSala INT,
		constraint fkSensorSala foreign key (fkSala)
			references sala(idSala)
);

CREATE TABLE registro(
	idRegistro INT,
	fkSensor INT,
		constraint pkRegistro primary key(idRegistro, fkSensor), 
	temperatura FLOAT,
	umidade INT,
	dtHora DATETIME,
		constraint fkRegistroSensor foreign key (fkSensor)
		references sensor(idSensor)
);

CREATE TABLE registroAlerta(
	idRegistroAlerta INT,
	fkRegistro INT,
		constraint pkRegistroAlerta primary key(idRegistroAlerta, fkRegistro),
	aviso VARCHAR(10),
	mensagem TEXT,
	resolvido TINYINT,
		constraint fkRegistroRegistroAlerta foreign key (fkRegistro)
			references registro(idRegistro)
);
