-- Criação do banco de dados e definição de uso
CREATE DATABASE thermaHealth;
USE thermaHealth;

-- DROP database thermaHealth;

-- Criação da tabela de hospitais
CREATE TABLE hospital(
	idHospital INT PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR(45) NOT NULL,
	sufixo CHAR(4) NOT NULL,
	cnpj CHAR(8) NOT NULL,
	digitoVerifica CHAR(2) NOT NULL,
	razaoSocial VARCHAR(200) NOT NULL
);

-- Criação da tabela de endereços, associando cada endereço a um hospital
CREATE TABLE endereco(
	idEndereco INT AUTO_INCREMENT,
	fkHospital INT UNIQUE,
    constraint pkEndereco primary key(idEndereco, fkHospital),
    logradouro VARCHAR(200) NOT NULL,
	numero INT NOT NULL,
	complemento VARCHAR(200) NULL,
	bairro VARCHAR(200) NOT NULL,
	cidade VARCHAR(200) NOT NULL,
	estado VARCHAR(200) NOT NULL,
	cep CHAR(9) NOT NULL,
    constraint fkHospitalEndereco 
		foreign key (fkHospital) references hospital(idHospital)
);

-- Criação da tabela de funcionários, permitindo hierarquia entre eles (supervisor)
CREATE TABLE funcionario(
	idFuncionario INT PRIMARY KEY AUTO_INCREMENT, 
	matricula VARCHAR(10) NOT NULL,
	nome VARCHAR(100) NOT NULL,
	senha VARCHAR(32) NOT NULL,
	nivelAcesso CHAR(1) NOT NULL,
	email VARCHAR(255) NOT NULL,
	fkSupervisor INT NULL,
		constraint fkFuncSuper foreign key (fkSupervisor)
			references funcionario(idFuncionario),
	fkHospital INT NOT NULL,
		constraint fkFuncHospital foreign key (fkHospital)
			references hospital(idHospital)
);

-- Criação da tabela de salas hospitalares, ligadas a hospitais
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

-- Criação da tabela de parâmetros ideais para sensores
CREATE TABLE parametrosIdeais(
	idParametros INT AUTO_INCREMENT,
    fkSala INT, 
	constraint pkParametrosIdeais primary key (idParametros, fkSala),
	temperatura_min FLOAT NOT NULL,
	temperatura_max FLOAT NOT NULL,
	umidade_min INT NOT NULL,
	umidade_max INT NOT NULL,
		constraint fkParametrosSala foreign key (fkSala)
			references sala(idSala)
);

-- Criação da tabela de sensores, associando cada sensor a uma sala
CREATE TABLE sensor(
	idSensor INT PRIMARY KEY AUTO_INCREMENT,
	tipo VARCHAR(10) NOT NULL,
	numeroSerie VARCHAR(22) NOT NULL UNIQUE,
	statusSensor VARCHAR(45) NOT NULL,
    constraint chkStatusSensor
		check (statusSensor in('Ativo', 'Inativo', 'Manutenção')),
	fkSala INT NOT NULL,
		constraint fkSensorSala foreign key (fkSala)
			references sala(idSala)
);

-- Criação da tabela de registros de sensores (temperatura e umidade)
CREATE TABLE registro(
	idRegistro INT PRIMARY KEY AUTO_INCREMENT,
	temperatura FLOAT NOT NULL,
	umidade INT NOT NULL,
	dtHora DATETIME default CURRENT_TIMESTAMP,
	fkSensor INT NULL,
		constraint fkRegistroSensor foreign key (fkSensor)
			references sensor(idSensor)
);

-- Criação da tabela de alertas gerados a partir de registros
CREATE TABLE registroAlerta(
	idRegistroAlerta INT AUTO_INCREMENT,
	fkRegistro INT,
		constraint pkRegistroAlerta primary key(idRegistroAlerta, fkRegistro),
	aviso VARCHAR(10),
	mensagem TEXT,
	resolvido TINYINT,
		constraint fkRegistroRegistroAlerta foreign key (fkRegistro)
			references registro(idRegistro)
);

-- Inserção de dados na tabela hospital
INSERT INTO hospital (nome, sufixo, cnpj, digitoVerifica, razaoSocial) VALUES
('Hospital São João', '0001', '12345678', '90', 'Hospital e Maternidade São João LTDA'),
('Hospital Santa Maria', '0002', '87654321', '12', 'Hospital Santa Maria Serviços Médicos LTDA'),
('Clínica Vida', '0001', '11223344', '56', 'Clínica Vida Saúde Integrada LTDA'),
('Instituto Coração', '0003', '44332211', '78', 'Instituto do Coração e Cardiologia Avançada'),
('Hospital Esperança', '0001', '55667788', '34', 'Hospital Esperança Cuidados Médicos S/A');

-- Inserção de endereços dos hospitais
INSERT INTO endereco (logradouro, numero, complemento, bairro, cidade, estado, cep, fkHospital) VALUES
('Rua das Palmeiras', 123, 'Bloco A', 'Centro', 'São Paulo', 'SP', '01234-000', 1),
('Avenida Brasil', 456, NULL, 'Jardim América', 'Rio de Janeiro', 'RJ', '22041-001', 2),
('Rua da Saúde', 789, 'Próximo à Praça Central', 'Saúde', 'Belo Horizonte', 'MG', '30130-001', 3),
('Avenida Cardíacos', 101, 'Torre Norte', 'Coração Eucarístico', 'Curitiba', 'PR', '80010-100', 4),
('Rua da Esperança', 202, NULL, 'Esperança', 'Porto Alegre', 'RS', '90010-200', 5);

-- Inserção de funcionários com diferentes níveis e supervisores
INSERT INTO funcionario (matricula, nome, senha, nivelAcesso, email, fkSupervisor, fkHospital) VALUES
('000001', 'João Silva', 'e10adc3949ba59abbe56e057f20f883e', 'A', 'joao.silva@hospital.com', NULL, 1),
('000002', 'Maria Souza', 'e10adc3949ba59abbe56e057f20f883e', 'S', 'maria.souza@hospital.com', 1, 1),
('000003', 'Carlos Lima', 'e10adc3949ba59abbe56e057f20f883e', 'C', 'carlos.lima@hospital.com', 2, 1),
('000004', 'Fernanda Rocha', 'e10adc3949ba59abbe56e057f20f883e', 'S', 'fernanda.rocha@hospital.com', 1, 2),
('000005', 'Bruno Martins', 'e10adc3949ba59abbe56e057f20f883e', 'C', 'bruno.martins@hospital.com', 4, 2);

-- Inserção de salas hospitalares com diferentes setores e hospitais
INSERT INTO sala (setor, nome, descricao, andar, fkHospital) VALUES
('Emergência', 'Sala de Atendimento 1', 'Sala equipada para primeiros socorros e emergências médicas.', 1, 1),
('UTI', 'UTI Geral', 'Unidade de Terapia Intensiva para pacientes críticos.', 2, 1),
('Pediatria', 'Sala de Brinquedos', 'Espaço lúdico para crianças internadas.', 1, 2),
('Radiologia', 'Sala de Raio-X', 'Sala equipada com aparelho de raio-x digital.', 1, 1),
('Centro Cirúrgico', 'Sala de Cirurgia 2', 'Sala para procedimentos cirúrgicos de médio porte.', 2, 2),
('Administração', 'Sala da Diretoria', 'Sala administrativa da diretoria do hospital.', 3, 1);

-- Inserção de parâmetros ideais de sensores
INSERT INTO parametrosIdeais (idParametros, fkSala, temperatura_min, temperatura_max, umidade_min, umidade_max) VALUES
(1, 1, 20.0, 22.0, 40, 60),
(2, 2, 22.0, 26.0, 40, 60),
(3, 3, 20.0, 24.0, 40, 60),
(4, 4, 22.0, 27.0, 40, 60),
(5, 5, 20.0, 24.0, 40, 60);

-- Inserção de sensores em diferentes salas e com status variados
INSERT INTO sensor (tipo, numeroSerie, statusSensor, fkSala) VALUES
('TEMP', 'SN-TEMP-0001', 'Ativo', 1),
('UMID', 'SN-UMID-0002', 'Ativo', 2),
('AMBI', 'SN-AMBI-0003', 'Manutenção', 3),
('TEMP', 'SN-TEMP-0004', 'Ativo', 4),
('UMID', 'SN-UMID-0005', 'Inativo', 5),
('AMBI', 'SN-AMBI-0006', 'Ativo', 6);

-- Inserção de registros de medições de sensores
INSERT INTO registro (temperatura, umidade, dtHora, fkSensor) VALUES
(21.5, 45, '2025-04-14 08:00:00', 1),
(22.1, 47, '2025-04-14 09:00:00', 1),
(21.2, 50, '2025-04-14 08:00:00', 2),
(22.0, 52, '2025-04-14 09:00:00', 2),
(20.8, 48, '2025-04-14 08:00:00', 3),
(21.0, 49, '2025-04-14 09:00:00', 3);

-- Inserção de alertas com base nos registros
INSERT INTO registroAlerta (idRegistroAlerta, fkRegistro, aviso, mensagem, resolvido) VALUES
(1, 1, 'ALERTA', 'Temperatura abaixo da faixa ideal. Ajuste necessário.', 0),
(2, 2, 'ALERTA', 'Temperatura acima da faixa ideal. Ação corretiva necessária.', 0);

-- Consulta: Funcionários e os hospitais em que trabalham
SELECT 
    f.nome AS nomeFuncionario,
    f.email,
    h.nome AS nomeHospital
FROM funcionario f
JOIN hospital h ON f.fkHospital = h.idHospital;

-- Consulta: Funcionários e seus respectivos supervisores (ou "Sem supervisor")
SELECT 
    f.nome AS nomeFuncionario,
    IFNULL(s.nome, 'Sem supervisor') AS nomeSupervisor
FROM funcionario f
LEFT JOIN funcionario s ON f.fkSupervisor = s.idFuncionario;

-- Consulta: Status dos sensores com mensagens descritivas
SELECT 
    s.numeroSerie,
    s.tipo,
    CASE 
        WHEN s.statusSensor = 'Ativo' THEN 'Sensor operando normalmente'
        WHEN s.statusSensor = 'Inativo' THEN 'Sensor desligado'
        WHEN s.statusSensor = 'Manutenção' THEN 'Sensor em manutenção'
        ELSE 'Status desconhecido'
    END AS descricaoStatus
FROM sensor s;

-- Consulta: Funcionários que trabalham em hospitais com nome contendo 'Santa'
SELECT 
    f.nome AS nomeFuncionario,
    h.nome AS nomeHospital
FROM funcionario f
JOIN hospital h ON f.fkHospital = h.idHospital
WHERE h.nome LIKE '%Santa%';

-- Consulta: Lista de alertas com descrição textual do status (resolvido ou pendente)
SELECT 
    ra.idRegistroAlerta,
    ra.aviso,
    ra.mensagem,
    CASE 
        WHEN ra.resolvido = 1 THEN 'Resolvido'
        ELSE 'Pendente'
    END AS statusAlerta
FROM registroAlerta ra;

-- Consulta: Registros de temperatura e umidade com identificação da sala e sensor
SELECT 
    r.dtHora,
    r.temperatura,
    r.umidade,
    s.numeroSerie,
    sl.nome AS nomeSala
FROM registro r
JOIN sensor s ON r.fkSensor = s.idSensor
JOIN sala sl ON s.fkSala = sl.idSala;

-- Consulta: Sensores ativos em salas do setor 'UTI'
SELECT 
    s.numeroSerie,
    s.tipo,
    sl.nome AS sala,
    CASE 
        WHEN s.statusSensor = 'Ativo' THEN 'Funcionando'
        ELSE 'Não funcionando'
    END AS statusFuncional
FROM sensor s
JOIN sala sl ON s.fkSala = sl.idSala
WHERE sl.setor LIKE '%UTI%' AND s.statusSensor = 'Ativo';
