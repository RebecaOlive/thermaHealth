var database = require("../database/config");

function buscarPorId(id) {
  var instrucaoSql = `SELECT * FROM hospital WHERE idHospital = '${id}'`;

  return database.executar(instrucaoSql);
}

function listar() {
  var instrucaoSql = `select idHospital, cnpj, sufixo, digitoVerifica, razaoSocial from hospital;`;

  return database.executar(instrucaoSql);
}

function buscarPorCnpj(cnpj) {
  var instrucaoSql = `SELECT * FROM hospital WHERE cnpj = '${cnpj}'`;

  return database.executar(instrucaoSql);
}

function cadastrar(razaoSocial, cnpj) {
  var instrucaoSql = `INSERT INTO hostital (razaoSocial, cnpj) VALUES ('${razaoSocial}', '${cnpj}')`;

  return database.executar(instrucaoSql);
}

module.exports = { buscarPorCnpj, buscarPorId, cadastrar, listar };
