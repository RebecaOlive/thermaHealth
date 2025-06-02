var database = require("../database/config");

function buscarSalasPorHopital(email, senha) {
  var instrucaoSql = `
    SELECT a.* FROM sala a 
    JOIN funcionario f ON f.fkHospital = a.fkHospital
    WHERE email = '${email}' AND senha = '${senha}';
    `;

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
