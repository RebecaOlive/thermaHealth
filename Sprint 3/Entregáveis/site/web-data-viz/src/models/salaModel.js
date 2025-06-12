var database = require("../database/config");

function buscarSalasPorHopital(email, senha) {

  var instrucaoSql = `
    SELECT s.* FROM sala s JOIN funcionario f ON f.fkHospital = s.fkHospital 
    WHERE email = '${email}' AND senha = '${senha}';
    `;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}


function listarSalasPorSetor(email, senha, nomeSetor) {

  var instrucaoSql = `
    SELECT s.* FROM sala s JOIN funcionario f ON f.fkHospital = s.fkHospital 
    WHERE email = '${email}' AND senha = '${senha}' AND s.setor = '${nomeSetor}';
    `;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}



function cadastrar(setor, nome, descricao, andar, fkHospital) {
  
  var instrucaoSql = `INSERT INTO sala (fkSetor, nome, descricao, andar, fkHospital) VALUES ('${setor}', '${nome}', '${descricao}', '${andar}', '${fkHospital}');
`;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);
}

function contextualizarSetores(email){
  var instrucaoSql = `
    SELECT * FROM vw_sala_setor_param_regist_sensor WHERE emailFuncionario = '${email}';
  ` ;

  console.log("Executando a instrução SQL: \n" + instrucaoSql);
  return database.executar(instrucaoSql);

}


module.exports = {
  listarSalasPorSetor,
  buscarSalasPorHopital,
  cadastrar,
  contextualizarSetores
}
