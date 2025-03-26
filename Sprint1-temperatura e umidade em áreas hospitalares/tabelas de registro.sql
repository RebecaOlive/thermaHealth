CREATE database thermaHealth;
USE thermaHealth;

-- funcionario (usuário)
CREATE table funcionario (
	id INT PRIMARY KEY auto_increment,
    matricula INT unique,
    email VARCHAR(50) unique,
    nome VARCHAR(45),
    sobrenome VARCHAR(45),
    senha VARCHAR(255),
    nivel_acesso VARCHAR(50),
		constraint chkaAcesso
        check(nivel_acesso BETWEEN 0 AND 2)
);

-- hospital (Cadastro das Unidades)
CREATE TABLE hospital (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cnpj CHAR(18) UNIQUE NOT NULL,
    razao_social VARCHAR(200) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20) NOT NULL
);

-- sensor
CREATE TABLE sensor (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(50) NOT NULL,
    versao VARCHAR(40) NOT NULL,
    status_sensor VARCHAR(50),
		constraint chkStatus 
        check(status_sensor in('ativo', 'inativo', 'manutenção'))
);

-- Parâmetros Ideais de Temperatura e Umidade para cada Setor
CREATE TABLE parametros_ideais (
    id INT PRIMARY KEY AUTO_INCREMENT,
    temperatura_min FLOAT NOT NULL,
    temperatura_max FLOAT NOT NULL,
    umidade_min INT NOT NULL,
    umidade_max INT NOT NULL
);

-- Registro de Leituras dos Sensores
CREATE TABLE registro (
    id INT PRIMARY KEY AUTO_INCREMENT,
    temperatura FLOAT,
    umidade INT,
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE alerta (
    id INT PRIMARY KEY AUTO_INCREMENT,
    registro_id INT NOT NULL,
    aviso VARCHAR(50),
		constraint chkAviso
        check(aviso in('aviso', 'crítico', 'emergência')),
    mensagem TEXT NOT NULL,
    resolvido BOOLEAN DEFAULT FALSE
);

INSERT INTO funcionario (matricula, email, nome, sobrenome, senha, nivel_acesso) VALUES
(1001, 'maria.silva@hospitalxyz.com', 'Maria', 'Silva', 'senha123', 0),
(1002, 'joao.pereira@hospitalxyz.com', 'João', 'Pereira', 'senha456', 1),
(1003, 'ana.souza@hospitalxyz.com', 'Ana', 'Souza', 'senha789', 2);

INSERT INTO hospital (nome, cnpj, razao_social, email, telefone)
VALUES
('Hospital XYZ', '12.345.678/0001-90', 'Hospital XYZ Ltda', 'contato@hospitalxyz.com', 123456789),
('Hospital ABC', '98.765.432/0001-01', 'Hospital ABC Ltda', 'contato@hospitalabc.com', 987654321);

INSERT INTO sensor ( tipo, versao, status_sensor)
VALUES
('LM35', 'v1.0', 'manutenção'),
('DHT11', 'v2.0', 'ativo');

INSERT INTO parametros_ideais (temperatura_min, temperatura_max, umidade_min, umidade_max) VALUES
(20.0, 22.0, 40, 60),
(21.0, 24.0, 45, 55),
(22.0, 24.0, 40, 50),
(20.0, 22.0, 40, 60),
(21.0, 23.0, 50, 60);


INSERT INTO registro (temperatura, umidade)
VALUES
(22.5, 60),
(23.0, 62),
(21.5, 58);

INSERT INTO alerta (registro_id, aviso, mensagem, resolvido) VALUES
(1, 'aviso', 'Temperatura no setor de UTI está acima do limite ideal.', FALSE),
(2, 'crítico', 'Umidade no setor de emergência está muito baixa ', FALSE),
(3, 'emergência', 'Temperatura no setor de sala de cirurgia está abaixo, risco para procedimentos.', FALSE),
(4, 'Aviso', 'Temperatura no setor de sala de cirurgia um pouco a cima', TRUE);

SELECT * FROM alerta;

SELECT * FROM funcionario WHERE email LIKE "%a%";

SELECT resolvido, CASE 
	WHEN resolvido = 0 THEN 'Pendente'
    ELSE 'Resolveu'
    END AS A FROM alerta;
    
SELECT * FROM registro ORDER BY data_hora;

SELECT status_sensor AS 'status' FROM sensor;

SELECT nome FROM funcionario 
WHERE id = 1;

SELECT nome, nivel_acesso FROM funcionario;
SELECT * FROM parametros_ideais WHERE temperatura_max BETWEEN 20 AND 23;

UPDATE funcionario SET nome = "Thomas"
WHERE id = 1;
