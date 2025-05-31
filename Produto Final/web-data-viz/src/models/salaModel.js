var database = require("../database/config");

function buscarSalasPorHopital(fkHospital) {

  var instrucaoSql = `SELECT * FROM sala a WHERE fkHospital = ${fkHospital}`;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}

function cadastrar(setor, nome, descricao, andar, fkHospital) {
  
  var instrucaoSql = `INSERT INTO (setor, nome, descricao, andar, fkHospital) sala VALUES (${setor}, ${nome}, ${descricao}, ${andar}, ${fkHospital})`;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}


module.exports = {
  buscarSalasPorHopital,
  cadastrar
}
