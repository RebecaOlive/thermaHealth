var database = require("../database/config");

function buscarAquariosPorEmpresa(fkHospital) {

  var instrucaoSql = `SELECT * FROM sala a WHERE fkHospital = ${fkHospital}`;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}

function cadastrar(fkHospital, descricao) {
  
  var instrucaoSql = `INSERT INTO (descricao, fkHospital) sala VALUES (${descricao}, ${fkHospital})`;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}


module.exports = {
  buscarAquariosPorEmpresa,
  cadastrar
}
