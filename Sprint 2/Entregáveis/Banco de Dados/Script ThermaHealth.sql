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

INSERT INTO hospital (nome, sufixo, cnpj, digitoVerifica, razaoSocial) VALUES
('Hospital São João', '0001', '12345678', '90', 'Hospital e Maternidade São João LTDA'),
('Hospital Santa Maria', '0002', '87654321', '12', 'Hospital Santa Maria Serviços Médicos LTDA'),
('Clínica Vida', '0001', '11223344', '56', 'Clínica Vida Saúde Integrada LTDA'),
('Instituto Coração', '0003', '44332211', '78', 'Instituto do Coração e Cardiologia Avançada'),
('Hospital Esperança', '0001', '55667788', '34', 'Hospital Esperança Cuidados Médicos S/A');

INSERT INTO hospital (nome, cnpj, sufixo, digitoVerifica, razaoSocial) VALUES
('Hospital São João', '12345678', '0001', '90', 'Hospital e Maternidade São João LTDA'),
('Hospital Santa Maria', '87654321', '0002', '12', 'Hospital Santa Maria Serviços Médicos LTDA'),
('Clínica Vida', '11223344', '0001', '56', 'Clínica Vida Saúde Integrada LTDA'),
('Instituto Coração', '44332211', '0003', '78', 'Instituto do Coração e Cardiologia Avançada'),
('Hospital Esperança', '55667788', '0001', '34', 'Hospital Esperança Cuidados Médicos S/A');

INSERT INTO funcionario (matricula, nome, senha, nivelAcesso, email, fkSupervisor, fkHospital) VALUES
('000001', 'João Silva', 'e10adc3949ba59abbe56e057f20f883e', 'A', 'joao.silva@hospital.com', NULL, 1),
('000002', 'Maria Souza', 'e10adc3949ba59abbe56e057f20f883e', 'S', 'maria.souza@hospital.com', 1, 1),
('000003', 'Carlos Lima', 'e10adc3949ba59abbe56e057f20f883e', 'C', 'carlos.lima@hospital.com', 2, 1),
('000004', 'Fernanda Rocha', 'e10adc3949ba59abbe56e057f20f883e', 'S', 'fernanda.rocha@hospital.com', 1, 2),
('000005', 'Bruno Martins', 'e10adc3949ba59abbe56e057f20f883e', 'C', 'bruno.martins@hospital.com', 4, 2);

INSERT INTO sala (setor, nome, descricao, andar, fkHospital) VALUES
('Emergência', 'Sala de Atendimento 1', 'Sala equipada para primeiros socorros e emergências médicas.', 1, 1),
('UTI', 'UTI Geral', 'Unidade de Terapia Intensiva para pacientes críticos.', 2, 1),
('Pediatria', 'Sala de Brinquedos', 'Espaço lúdico para crianças internadas.', 1, 2),
('Radiologia', 'Sala de Raio-X', 'Sala equipada com aparelho de raio-x digital.', 1, 1),
('Centro Cirúrgico', 'Sala de Cirurgia 2', 'Sala para procedimentos cirúrgicos de médio porte.', 2, 2),
('Administração', 'Sala da Diretoria', 'Sala administrativa da diretoria do hospital.', 3, 1);

INSERT INTO parametrosIdeais (idParametros, fkSensor, temperatura_min, temperatura_max, umidade_min, umidade_max) VALUES
(1, 1, 20.0, 22.0, 40, 60),
(2, 2, 22.0, 26.0, 40, 60),
(3, 3, 20.0, 24.0, 40, 60),
(4, 4, 22.0, 27.0, 40, 60),
(5, 5, 20.0, 24.0, 40, 60);

INSERT INTO sensor (tipo, numeroSerie, statusSensor, fkSala) VALUES
('TEMP', 'SN-TEMP-0001', 'Ativo', 1),
('UMID', 'SN-UMID-0002', 'Ativo', 2),
('AMBI', 'SN-AMBI-0003', 'Manutenção', 3),
('TEMP', 'SN-TEMP-0004', 'Ativo', 4),
('UMID', 'SN-UMID-0005', 'Inativo', 5),
('AMBI', 'SN-AMBI-0006', 'Ativo', 6);

INSERT INTO registro (idRegistro, fkSensor, temperatura, umidade, dtHora) VALUES
(1, 1, 21.5, 45, '2025-04-14 08:00:00'),
(2, 1, 22.1, 47, '2025-04-14 09:00:00'),
(1, 2, NULL, 50, '2025-04-14 08:00:00'),
(2, 2, NULL, 52, '2025-04-14 09:00:00'),
(1, 3, 20.8, 48, '2025-04-14 08:00:00'),
(2, 3, 21.0, 49, '2025-04-14 09:00:00');

INSERT INTO registroAlerta (idRegistroAlerta, fkRegistro, aviso, mensagem, resolvido) VALUES
(1, 1, 'ALERTA', 'Temperatura abaixo da faixa ideal. Ajuste necessário.', 0),
(2, 2, 'ALERTA', 'Temperatura acima da faixa ideal. Ação corretiva necessária.', 0),
(3, 3, 'ALERTA', 'Umidade muito alta. Possível risco de mofo.', 0),
(4, 4, 'OK', 'Temperatura dentro da faixa ideal.', 1),
(5, 5, 'ALERTA', 'Temperatura muito alta para o ambiente. Urgente.', 0),
(6, 6, 'OK', 'Umidade dentro dos parâmetros normais.', 1);