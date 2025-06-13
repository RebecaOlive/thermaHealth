var database = require("../database/config");

function buscarUltimasMedidas(idSala, limite_linhas) {

    var instrucaoSql = `SELECT 
        r.temperatura AS temperatura, 
        r.umidade AS umidade,
                        r.dtHora AS momento,
                        DATE_FORMAT(r.dtHora, '%H:%i:%s') AS momento_grafico
                FROM registro r
                JOIN sensor s ON r.fkSensor = s.idSensor
                WHERE s.fkSala = ${idSala}
            ORDER BY r.idRegistro DESC LIMIT ${limite_linhas}`;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarMedidasEmTempoReal(idSala) {

    var instrucaoSql = `SELECT 
        r.temperatura AS temperatura, 
        r.umidade AS umidade,
                        DATE_FORMAT(r.dtHora, '%H:%i:%s') AS momento_grafico,
                        s.fkSala AS fkSala
                FROM registro r
                JOIN sensor s ON r.fkSensor = s.idSensor
                WHERE s.fkSala = ${idSala}
            ORDER BY r.idRegistro DESC LIMIT 1`;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}
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

function contarTotalSensores(idSala) {
    const instrucaoSql = `
        SELECT * , (SELECT COUNT(*) FROM sensor where fksala = ${idSala} )as 'Total'FROM sensor WHERE fkSala = ${idSala};

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

module.exports = {
    buscarUltimasMedidas,
    buscarMedidasEmTempoReal,
    contarSensoresForaPadrao,
    contarTotalSensores,
    buscarParametrosPorSetor,
    buscarSalasForaDosParametros
};
