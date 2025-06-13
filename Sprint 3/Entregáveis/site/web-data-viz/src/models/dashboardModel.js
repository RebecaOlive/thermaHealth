var database = require("../database/config");

function contarSensoresForaPadrao(idSala) {
    const instrucaoSql = `
        SELECT COUNT(*) AS sensores_fora
        FROM (
            SELECT s.idSensor, MAX(r.idRegistro) AS ultimoRegistro
            FROM sensor s
            JOIN registro r ON s.idSensor = r.fkSensor
            WHERE s.fkSala = ${idSala}
            GROUP BY s.idSensor
        ) ultimos
        JOIN registro r ON ultimos.ultimoRegistro = r.idRegistro
        WHERE r.temperatura < 22 OR r.temperatura > 25 OR r.umidade < 30 OR r.umidade > 60;
    `;
    return database.executar(instrucaoSql);
}

function contarTotalSensores() {
    const instrucaoSql = `
        SELECT COUNT(idSensor)
        FROM sensor;
    `;
    return database.executar(instrucaoSql);
}


function buscarParametrosPorSetor(idSala) {
  const instrucaoSql = `
        SELECT temperatura_min, temperatura_max, umidade_min, umidade_max
        FROM parametrosIdeais
        WHERE fkSala = ${idSala}
        LIMIT 1;
    `;
  return database.executar(instrucaoSql);
}

function buscarSalasForaDosParametros() {
  const instrucaoSql = `
        SELECT 
            (SELECT COUNT(DISTINCT s.idSala)
             FROM sala s
             JOIN sensor sens ON sens.fkSala = s.idSala
             JOIN registro r ON r.fkSensor = sens.idSensor
             JOIN parametrosIdeais p ON p.fkSala = s.idSala
             WHERE r.dtHora = (
                 SELECT MAX(r2.dtHora)
                 FROM registro r2
                 WHERE r2.fkSensor = sens.idSensor
             )
             AND (
                 r.temperatura < p.temperatura_min OR
                 r.temperatura > p.temperatura_max OR
                 r.umidade < p.umidade_min OR
                 r.umidade > p.umidade_max
             )
            ) AS salas_fora,

            (SELECT COUNT(*) FROM sala) AS total_salas;
    `;
  return database.executar(instrucaoSql);
}

function primeiraKPI(email, nomeSala) {
  const instrucaoSql = `
        SELECT * FROM  vw_sala_setor_param_regist_sensor where emailFuncionario = '${email}' && nomeSala = '${nomeSala}';
    `;
  return database.executar(instrucaoSql);
}


module.exports = {
  contarSensoresForaPadrao,
  contarTotalSensores,
  buscarParametrosPorSetor,
  buscarSalasForaDosParametros,
  primeiraKPI
};
