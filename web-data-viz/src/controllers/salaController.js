var salaModel = require("../models/salaModel");

function buscarSalasPorHopital(req, res) {
  var idFuncionario = req.params.idFuncionario;

  salaModel.buscarSalasPorHopital(idFuncionario).then((resultado) => {
    if (resultado.length > 0) {
      res.status(200).json(resultado);
    } else {
      res.status(204).json([]);
    }
  }).catch(function (erro) {
    console.log(erro);
    console.log("Houve um erro ao buscar as salas: ", erro.sqlMessage);
    res.status(500).json(erro.sqlMessage);
  });
}


function cadastrar(req, res) {
  var setor = req.body.setor;
  var nome = req.body.nome;
  var andar = req.body.andar;
  var descricao = req.body.descricao;
  var fkHospital = req.body.fkHospital;

  if (descricao == undefined) {
    res.status(400).send("descricao está undefined!");
  } else if (fkHospital == undefined) {
    res.status(400).send("fkHospital está undefined!");
  } else {


    salaModel.cadastrar(descricao, fkHospital)
      .then((resultado) => {
        res.status(201).json(resultado);
      }
      ).catch((erro) => {
        console.log(erro);
        console.log(
          "\nHouve um erro ao realizar o cadastro! Erro: ",
          erro.sqlMessage
        );
        res.status(500).json(erro.sqlMessage);
      });
  }
}

module.exports = {
  buscarSalasPorHopital,
  cadastrar
}