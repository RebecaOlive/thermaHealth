var database = require("../database/config");

function buscarPorId(idHospital) {
  var instrucaoSql = `SELECT * FROM hospital WHERE idHospital = '${idHospital}'`;

  return database.executar(instrucaoSql);
}

function listar() {
  var instrucaoSql = `SELECT idHospital, razaoSocial, cnpj, sufixo, digitoVerifica FROM hospital`;

  return database.executar(instrucaoSql);
}

function buscarPorCnpj(cnpj) {
  var instrucaoSql = `SELECT * FROM hospital WHERE cnpj = '${cnpj}'`;

  return database.executar(instrucaoSql);
}

function cadastrar(razaoSocial, cnpj, sufixo, digito) {
  var instrucaoSql = `INSERT INTO hospital (razaoSocial, cnpj, sufixo, digitoVerifica) VALUES ('${razaoSocial}', '${cnpj}', '${sufixo}','${digito}')`;

  return database.executar(instrucaoSql);
}

module.exports = { buscarPorCnpj, buscarPorId, cadastrar, listar };
