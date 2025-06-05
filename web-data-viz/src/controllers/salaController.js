var salaModel = require("../models/salaModel");

function buscarSalasPorHospital(req, res) {
  var email = req.body.emailServer;
  var senha = req.body.senhaServer;

  if (email == undefined) {
    res.status(400).send("Seu email está undefined!");
  } else if (senha == undefined) {
    res.status(400).send("Sua senha está indefinida!");
  } else {

    salaModel.buscarSalasPorHospital(email, senha).then((resultado) => {
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


function listarSalasPorSetor(req, res) {

    var email = req.body.emailServer;
    var senha = req.body.senhaServer;
    var nomeSetor = sessionStorage.SALAS

    salaModel.listarSalasPorSetor(email, senha, nomeSetor).then((resultado) => {
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





module.exports = {
  listarSalasPorSetor,
  buscarSalasPorHospital,
  cadastrar
}