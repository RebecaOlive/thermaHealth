CREATE database thermaHealth;
USE thermaHealth;

CREATE TABLE hospital(
	idHospital INT PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR(45) NOT NULL,
	sufixo CHAR(4) NOT NULL,
	cnpj CHAR(8) NOT NULL,
	digitoVerificador CHAR(2) NOT NULL,
	razaoSocial VARCHAR(200) NOT NULL 
);

CREATE TABLE funcionario(
	idFuncionario INT PRIMARY KEY AUTO_INCREMENT, 
	matricula VARCHAR(10) NOT NULL,
	nome VARCHAR(100) NOT NULL,
	senha VARCHAR(32) NOT NULL,
	nivelAcesso CHAR(1) NOT NULL, -- Nivel TI(ADM) - MUNUTENÇÃO(COMUM)
			constraint chkAcesso
				check(nivelAcesso BETWEEN 0 AND 1),
	email VARCHAR(255) NOT NULL,
	fkSupervisor INT NULL,
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
	descricao TEXT NULL,
	andar TINYINT NOT NULL, 
	fkHospital INT NOT NULL,
		constraint fkSalaHospital foreign key (fkHospital)
			references hospital(idHospital)
);

CREATE TABLE parametrosIdeais( -- PERGUNTAR é necessário ter uma tabela geral de temp e umid, ou ter uma tabela diferente para temp e umid?
	idParametros INT PRIMARY KEY AUTO_INCREMENT,
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
		constraint chkStatus
			check(statusSensor in('ativo', 'inativo', 'manutenção')),
	fkSala INT NOT NULL,
		constraint fkSensorSala foreign key (fkSala)
			references sala(idSala),
	fkParametros INT NOT NULL,
		constraint fkSensorParametros foreign key (fkParametros)
			references parametrosIdeais(idParametros)
);

CREATE TABLE registro(
	idRegistro INT PRIMARY KEY AUTO_INCREMENT,
	temperatura FLOAT NOT NULL,
	umidade INT NOT NULL,
	dtHora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	fkSensor INT NOT NULL,
		constraint fkRegistroSensor foreign key (fkSensor)
			references sensor(idSensor)
);

CREATE TABLE registroAlerta(
	idRegistroAlerta INT PRIMARY KEY AUTO_INCREMENT,
	aviso VARCHAR(10) NOT NULL, 
	mensagem TEXT NOT NULL,
	resolvido TINYINT NOT NULL,
	fkRegistro INT NOT NULL,
		constraint fkRegistroRegistroAlerta foreign key (fkRegistro)
			references registro(idRegistro)
);
