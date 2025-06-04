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

module.exports = {
    buscarUltimasMedidas,
    buscarMedidasEmTempoReal
}
