var database = require("../database/config");

function buscarSalaPorHospital(empresaId) {

  var instrucaoSql = `SELECT * FROM sala a WHERE fkHospital = ${empresaId}`;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}

function cadastrar(empresaId, descricao) {
  
  var instrucaoSql = `INSERT INTO (descricao, fkHospital) sala VALUES (${descricao}, ${empresaId})`;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}


module.exports = {
  buscarSalaPorHospital,
  cadastrar
}
