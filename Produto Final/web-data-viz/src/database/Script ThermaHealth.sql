-- Criação do banco de dados e definição de uso
CREATE DATABASE IF NOT EXISTS thermaHealth;
USE thermaHealth;

 -- DROP database thermaHealth;


-- Criação da tabela de hospitais
CREATE TABLE IF NOT EXISTS endereco(
	idEndereco INT primary key AUTO_INCREMENT,
    logradouro VARCHAR(200) NOT NULL,
	numero INT NOT NULL,
	complemento VARCHAR(200) NULL,
	bairro VARCHAR(200) NOT NULL,
	cidade VARCHAR(200) NOT NULL,
	estado VARCHAR(200) NOT NULL,
	cep CHAR(9) NOT NULL
);

CREATE TABLE IF NOT EXISTS hospital(
	idHospital INT PRIMARY KEY AUTO_INCREMENT,
    fkEndereco INT,
	nome VARCHAR(45) NOT NULL,
	sufixo CHAR(4) NOT NULL,
	cnpj CHAR(8) NOT NULL,
	digitoVerifica CHAR(2) NOT NULL,
	razaoSocial VARCHAR(200) NOT NULL,
    
    constraint fkHospitalEndereco 
		foreign key (fkEndereco) references endereco(idEndereco)
);
-- Criação da tabela de funcionários, permitindo hierarquia entre eles (supervisor)
CREATE TABLE IF NOT EXISTS funcionario(
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
CREATE TABLE IF NOT EXISTS sala(
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
CREATE TABLE IF NOT EXISTS parametrosIdeais(
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
CREATE TABLE IF NOT EXISTS sensor(
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
CREATE TABLE IF NOT EXISTS registro(
	idRegistro INT PRIMARY KEY AUTO_INCREMENT,
	temperatura FLOAT NOT NULL,
	umidade INT NOT NULL,
	dtHora DATETIME default CURRENT_TIMESTAMP,
	fkSensor INT NULL,
		constraint fkRegistroSensor foreign key (fkSensor)
			references sensor(idSensor)
);

-- Criação da tabela de alertas gerados a partir de registros
CREATE TABLE IF NOT EXISTS registroAlerta(
	idRegistroAlerta INT AUTO_INCREMENT PRIMARY KEY,
	aviso VARCHAR(10),
	mensagem TEXT,
	resolvido TINYINT
);

-- Criação da tabela de alerta (para alertas de umidade, temperatura ou ambos)
CREATE TABLE IF NOT EXISTS alerta(
	idAlerta int auto_increment primary key,
	fkRegistro int,
    fkRegistroAlerta int,
    alertaUmidade tinyint,
    alertaTemperatura tinyint,
	 -- CONSTRAINT pkComposta primary key(idAlerta,pkRegistro,pkRegistroAlerta),
		CONSTRAINT fkAlerta_Registro FOREIGN KEY (fkRegistro) REFERENCES registro(idRegistro),
		CONSTRAINT fkAlerta_RegistroAlerta FOREIGN KEY (fkRegistroAlerta) REFERENCES registroAlerta(idRegistroAlerta)
);



-- ----------------------------------------------------------------------------------------------


-- Inserção de endereços dos hospitais
INSERT INTO endereco (logradouro, numero, complemento, bairro, cidade, estado, cep) VALUES
('Rua das Palmeiras', 123, 'Bloco A', 'Centro', 'São Paulo', 'SP', '01234-000'),
('Avenida Brasil', 456, NULL, 'Jardim América', 'Rio de Janeiro', 'RJ', '22041-001'),
('Rua da Saúde', 789, 'Próximo à Praça Central', 'Saúde', 'Belo Horizonte', 'MG', '30130-001'),
('Avenida Cardíacos', 101, 'Torre Norte', 'Coração Eucarístico', 'Curitiba', 'PR', '80010-100'),
('Rua da Esperança', 202, NULL, 'Esperança', 'Porto Alegre', 'RS', '90010-200');

-- Inserção de dados na tabela hospital
INSERT INTO hospital (nome,fkEndereco, sufixo, cnpj, digitoVerifica, razaoSocial) VALUES
('Hospital São João', 1 ,'0001', '12345678', '90', 'Hospital e Maternidade São João LTDA' ),
('Hospital Santa Maria' , 2, '0002', '87654321', '12', 'Hospital Santa Maria Serviços Médicos LTDA' ),
('Clínica Vida' , 3, '0001', '11223344', '56', 'Clínica Vida Saúde Integrada LTDA' ),
('Instituto Coração' , 4, '0003', '44332211', '78', 'Instituto do Coração e Cardiologia Avançada' ),
('Hospital Esperança' , 5, '0001', '55667788', '34', 'Hospital Esperança Cuidados Médicos S/A' );

-- truncate table hospital;
-- select * from hospital;


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
(5, 5, 20.0, 24.0, 40, 60),
(6, 6, 20.0, 22.0, 40, 60);

select * from sala;
select * from parametrosIdeais;
 
-- Inserção de sensores em diferentes salas e com status variados
INSERT INTO sensor (tipo, numeroSerie, statusSensor, fkSala) VALUES -- ALTERAR TIPO DE SENSOR PARA A POSIÇÃO NO QUAL ELE ESTÁ INSTALADO 
-- SE O SENSOR ESTIVER INATIVO OU EM MANUTENÇÃO, ELE NÃO SERÁ CONSIDERADO PARA O MONITORAMENTO DAS SALAS 
('TEMP', 'SN-TEMP-0001', 'Ativo', 1),
('UMID', 'SN-UMID-0002', 'Ativo', 2),
('AMBI', 'SN-AMBI-0003', 'Manutenção', 3),
('TEMP', 'SN-TEMP-0004', 'Ativo', 4),
('UMID', 'SN-UMID-0005', 'Inativo', 5),
('AMBI', 'SN-AMBI-0006', 'Ativo', 6),
('TEMP', 'SN-TEMP-0007', 'Ativo', 1),
('TEMP', 'SN-TEMP-0008', 'Manutenção', 1),
('UMID', 'SN-UMID-0009', 'Ativo', 1),
('UMID', 'SN-UMID-0010', 'Ativo', 1);


-- Inserção de registros de medições de sensores
INSERT INTO registro (temperatura, umidade, dtHora, fkSensor) VALUES
	(21.5, 45, '2025-04-14 08:00:00', 1),
	(22.1, 47, '2025-04-14 09:00:00', 1),
	(21.2, 50, '2025-04-14 08:00:00', 2),
	(22.0, 52, '2025-04-14 09:00:00', 2),
	(20.8, 48, '2025-04-14 08:00:00', 3),
	(21.0, 49, '2025-04-14 09:00:00', 3),
	(18.0, 30, '2025-04-14 22:31:00', 1),
	(30.0, 50, '2025-05-06 22:33:00', 1),
	(22.0, 70, '2025-05-06 22:32:00', 2),
	(21.0, 49, '2025-04-14 09:00:00', 7),
	(18.0, 30, '2025-04-14 22:31:00', 8),
	(30.0, 50, '2025-05-06 22:33:00', 9),
	(22.0, 70, '2025-05-06 22:32:00', 10);
    
    
SELECT * FROM registro;

-- Inserção de alertas com base nos registros
INSERT INTO registroAlerta (idRegistroAlerta, aviso, mensagem, resolvido) VALUES -- ALINHAR O GRUPO SOBRE A IMPORTÂNCIA DESSA TABELA SER DA RELAÇÃO NXN
(default, 'ALERTA', 'Temperatura abaixo da faixa ideal. Ajuste necessário.', 0),
(default, 'ALERTA', 'Temperatura acima da faixa ideal. Ação corretiva necessária.', 0),
(default, 'ALERTA', 'Temperatura e umidade fora da faixa ideal. Necessário verificar.', 0),
(default, 'ALERTA', 'Temperatura acima da faixa ideal. Necessário verificar', 1),
(default, 'ALERTA', 'Umidade acima da faixa ideal. Necessário verificar.', 0);


INSERT INTO alerta (fkRegistro, fkRegistroAlerta, alertaUmidade, AlertaTemperatura) VALUES
	(5, 2, 0, 1),
    (7, 1, 1, 1),
    (8, 2, 0, 1),
    (9, 3, 1, 0),
    (11, 5, 1, 1),
    (12, 2, 0, 1),
    (13, 3, 1 ,1);
    
SELECT * FROM alerta;
SELECT * FROM registro;
select * from RegistroAlerta;


CREATE VIEW vw_funcHosp AS
SELECT
    f.nome AS nomeFuncionario,
    f.email,
    h.nome AS nomeHospital
FROM funcionario f
JOIN hospital h ON f.fkHospital = h.idHospital;

-- Consulta: Funcionários e seus respectivos supervisores (ou "Sem supervisor")
CREATE VIEW vw_FuncAndSupervisor AS
SELECT
    f.nome AS nomeFuncionario,
    IFNULL(s.nome, 'Sem supervisor') AS nomeSupervisor
FROM funcionario f
LEFT JOIN funcionario s ON f.fkSupervisor = s.idFuncionario;

-- Consulta: Status dos sensores com mensagens descritivas
CREATE VIEW vw_statusSensores AS
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
CREATE VIEW vw_funcHospEspecifico AS
SELECT
    f.nome AS nomeFuncionario,
    h.nome AS nomeHospital
FROM funcionario f
JOIN hospital h ON f.fkHospital = h.idHospital;

-- Consulta: Lista de alertas com descrição textual do status (resolvido ou pendente)
CREATE VIEW vw_alertasStatus AS
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
CREATE VIEW vw_registrosTemperatura AS
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
CREATE VIEW vw_sensoresAlertasEspecifico AS SELECT
    s.numeroSerie,
    s.tipo,
    sl.nome AS sala,
    CASE
        WHEN s.statusSensor = 'Ativo' THEN 'Funcionando'
        ELSE 'Não funcionando'
    END AS statusFuncional
FROM sensor s
JOIN sala sl ON s.fkSala = sl.idSala;
-- WHERE sl.setor LIKE '%UTI%' AND s.statusSensor = 'Ativo';



-- SELECT DE ALERTAS QUE OCORRERAM EM SALAS

	SELECT alerta.idAlerta as 'Identificação do Alerta',
		   sala.nome as 'Nome da Sala',
		   sensor.numeroSerie as 'Sensor',
           registroAlerta.mensagem as 'Mensagem de Alerta'
           FROM sala JOIN sensor
           ON sala.idSala = sensor.fkSala
           JOIN registro
           ON sensor.idSensor = registro.fkSensor
           JOIN alerta
           ON registro.idRegistro = alerta.fkRegistro
           JOIN registroAlerta
           ON registroAlerta.idRegistroAlerta = alerta.fkRegistroAlerta;
		
-- SELECT QUANTIDADE DE ALERTAS POR SALAS
	SELECT sala.nome as 'Nome da sala',
		   count(alerta.idAlerta) as 'Quantidade de alertas'
           FROM sala JOIN sensor
           ON sala.idSala = sensor.fkSala 
		   LEFT JOIN registro
           ON sensor.idSensor = registro.fkSensor
           LEFT JOIN alerta
           ON registro.idRegistro = alerta.fkRegistro
           GROUP BY
           sala.nome;
           
-- SELECT QUANTIDADE DE SENSORES POR SALA

	SELECT sala.idSala as 'Número da sala',
			sala.nome as 'Nome da sala',
		   count(sensor.fkSala) as 'Quantidade de Sensores'
           FROM sala JOIN sensor
           ON sala.idSala = sensor.fkSala
           GROUP BY
           sala.idSala, sala.nome;
	
-- SELECT ÚLTIMO REGISTRO DE CADA SENSOR
           
	SELECT sensor.idSensor, 
		   r.* 
    FROM registro r
	JOIN (SELECT fkSensor, Max(dtHora) as 'max_dtHora'
		FROM registro JOIN sensor GROUP BY fkSensor) as recentes
        ON r.fkSensor = recentes.fkSensor AND r.dtHora = recentes.max_dtHora
        JOIN sensor
        ON sensor.idSensor = r.fkSensor
        ORDER BY fkSensor;
           
-- Registros fora dos parâmetros
/*
SELECT s.idSensor,
		r.idRegistro,
        r.temperatura,
        r.umidade,
        para
        FROM
        sensor s JOIN registro r
        ON s.idSensor = r.fkSensor
        JOIN sala 
        ON sala.idSala = s.fkSala
        JOIN parametrosIdeais par
        WHERE 
			r.temperatura > par.temperatura_max OR r.temperatura < par.temperatura_min OR
            r.temperatura > par.temperatura_max OR 
   
   */
   
SELECT * from parametrosIdeais;
           
        
-- SELECT QUAIS SÃO OS SENSORES POR SALA (Exemplo, sala 1)
		SELECT sala.idSala as 'Número da sala',
		   sala.nome as 'Nome da sala',
           sensor.numeroSerie as 'Número de Série do Sensor'
           FROM sala RIGHT JOIN sensor
           ON sala.idSala = sensor.fkSala
           HAVING
           sala.idSala = 1;
           
-- SELECT DE TODOS OS REGISTROS DE TEMPERATURA E UMIDADE DE CADA SENSOR POR SALA
		SELECT sala.idSala as 'Número da sala',
		   sala.nome as 'Nome da sala',
           sensor.numeroSerie as 'Número de Série do Sensor',
           registro.umidade as 'Umidade captada',
           registro.temperatura as 'Temperatura captada'
           FROM sala JOIN sensor
           ON sala.idSala = sensor.fkSala
           JOIN registro
           ON sensor.idSensor = registro.fkSensor
           GROUP BY
           sala.idSala, sala.nome, registro.idRegistro, registro.fkSensor
           HAVING 
           sala.idSala = 1
           ORDER BY sensor.numeroSerie DESC;

-- SELECT MÉDIA DA TEMPERATURA DA SALA PELO ÚLTIMO REGISTRO DE CADA SENSOR

-- A ORDEM DE LEITURA DO SQL É:
-- 1) FROM/ JOINS
-- 2) WHERE (SE HOUVER ALGUM)
-- 3) GROUP BY
-- 4) SELECT

-- --------------------------------------- 4 PARTE DA LEITURA ------------------------------------
	SELECT sensor.fkSala, -- SELECT DA SALA QUE O SENSOR ESTÁ INSTALADO 
		TRUNCATE(AVG(r.temperatura),2) AS media_temperatura, -- FAZ A MÉDIA DAS TEMPERATURAS SELECIONADAS 
		TRUNCATE(AVG(r.umidade),2) AS media_umidade -- FAZ A MÉDIA DAS UMIDADES SELECIONADAS 
        -- 

-- ---------------------------------------- 1 PARTE DA LEITURA -----------------------------------------------
	FROM registro as r 
	JOIN ( -- ATRAVÉS DESSA SUB-QUERY/ SUBCONSULTA, RETORNAMOS O REGISTRO COM A ÚLTIMA DATA
    
		SELECT fkSensor, MAX(dtHora) AS max_dtHora -- PEGA O ÚLTIMO REGISTRO DE CADA SENSOR / O REGISTRO COM A MAIOR DATA DE CADA SENSOR
		FROM registro 
		GROUP BY fkSensor -- AGRUPADO PELO ID DO SENSOR PARA QUE SEJA PEGO APENAS UM VALOR DE CADA
        
	) AS ultimos -- ESSES SÃO OS ÚLTIMOS REGISTROS, LOGO APELIDEI A 'TABELA' DE ULTIMOS
-- ---------------------------------------- 2 PARTE DA LEITURA -----------------------------------------------

		ON r.fkSensor = ultimos.fkSensor AND r.dtHora = ultimos.max_dtHora -- 
        -- FAZ A UNIÃO QUANDO O REGISTRO DE UM SENSOR FOR O MAIS ATUAL
	JOIN sensor
		ON sensor.idSensor = r.fkSensor -- UNE O REGISTRO COM O SENSOR
-- ---------------------------------------- 3 PARTE DA LEITURA -----------------------------------------------        

	GROUP BY sensor.fkSala; -- AGRUPAMOS POR SALA PARA QUE OS SELECTS SEJAM FEITOS PELOS REGISTROS DOS SENSORES DE CADA SALA

-- ---------------------------------------------------------------------------------------------------------------------
           
create view vw_acesso as 
	SELECT sala.idSala as 'Número da sala',
		   sala.nome as 'Nome da sala',
           sensor.numeroSerie as 'Número de Série do Sensor',
           registro.umidade as 'Umidade captada',
           registro.temperatura as 'Temperatura captada'
           FROM sala JOIN sensor
           ON sala.idSala = sensor.fkSala
           JOIN registro
           ON sensor.idSensor = registro.fkSensor
           GROUP BY
           sala.idSala, sala.nome, registro.idRegistro, registro.fkSensor
           HAVING 
           sala.idSala = 1
           ORDER BY sensor.numeroSerie DESC;
           
-- ALTER VIEW ___ as tananã      
	SELECT * from vw_acesso;


           
SELECT * FROM sala;
SELECT * FROM registro;
SELECT * FROM registroAlerta;
SELECT * FROM alerta;
