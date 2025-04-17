CREATE database thermaHealth;
USE thermaHealth;

CREATE TABLE hospital(
	idHospital INT PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR(45)NOT NULL,
	sufixo CHAR(4) NOT NULL,
	cnpj CHAR(8) NOT NULL,
	digitoVerifica CHAR(2) NOT NULL,
	razaoSocial VARCHAR(200) NOT NULL
);

CREATE TABLE funcionario(
	idFuncionario INT PRIMARY KEY AUTO_INCREMENT, 
	matricula VARCHAR(10) NOT NULL,
	nome VARCHAR(100) NOT NULL,
	senha VARCHAR(32) NOT NULL,
	nivelAcesso CHAR(1) NOT NULL,
	email VARCHAR(255) NOT NULL,
	fkSupervisor INT NOT NULL,
		constraint fkFuncSuper foreign key (fkSupervisor)
			references funcionario(idFuncionario),
	fkHospital INT NOT NULL,
		constraint fkFuncHospital foreign key (fkHospital)
			references hospital(idHospital)
);

CREATE TABLE sala(
	idSala INT PRIMARY KEY AUTO_INCREMENT,
	setor VARCHAR(45) NOT NULL, 
	nome VARCHAR(45) NOT NULL,
	descricao TEXT NOT NULL,
	andar TINYINT NOT NULL,  
	fkHospital INT NOT NULL,
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
	tipo VARCHAR(5) NOT NULL,
	numeroSerie VARCHAR(22) NOT NULL,
	statusSensor VARCHAR(45) NOT NULL,
	fkSala INT NOT NULL,
		constraint fkSensorSala foreign key (fkSala)
			references sala(idSala)
);

CREATE TABLE registro(
	idRegistro INT,
	fkSensor INT,
		constraint pkRegistro primary key(idRegistro, fkSensor), 
	temperatura FLOAT NOT NULL,
	umidade INT NOT NULL,
	dtHora DATETIME default CURRENT_TIMESTAMP(),
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
