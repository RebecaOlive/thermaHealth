var dashboardModel = require("../models/dashboardModel");

function buscarParametrosPorSetor(req, res) {
  const idSala = req.params.idSala;

  dashboardModel
    .buscarParametrosPorSetor(idSala)
    .then((result) => res.status(200).json(result))
    .catch((erro) => {
      console.log(erro);
      res.status(500).json(erro.sqlMessage);
    });
}

function buscarSalasForaDosParametros(req, res) {
  dashboardModel
    .buscarSalasForaDosParametros()
    .then((resultado) => {
      res.status(200).json(resultado[0]);
    })
    .catch((erro) => {
      console.error("Erro ao buscar resumo de salas:", erro);
      res.status(500).json({ erro: "Erro ao buscar dados das salas." });
    });
}

function primeiraKPI(req, res) {
  let email = req.params.email;
  let nome = req.params.nomeSala;
  dashboardModel.primeiraKPI(email, nome)
    .then(function (resultadoAutenticar) {
      console.log(`\nResultados encontrados: ${resultadoAutenticar.length}`);
      res.status(200).json(resultadoAutenticar)
    })
    .catch(function (erro) {
      console.log(erro);
            res.send([]);
      console.log(
        "\nHouve um erro ao realizar o login! Erro: ",
        erro.sqlMessage
      );
      res.status(500).json(erro.sqlMessage);
    });
}

function contarSensoresForaPadrao(req, res) {
  const idSala = req.params.idSala;
  dashboardModel
    .contarSensoresForaPadrao(idSala)
    .then((resultado) => res.status(200).json(resultado))
    .catch((erro) => {
      console.log(erro);
      res.status(500).json(erro.sqlMessage);
    });
}

function contarTotalSensores(req, res) {
  dashboardModel
    .contarTotalSensores()
    .then((resultado) => res.status(200).json(resultado))
    .catch((erro) => {
      console.log(erro);
      res.status(500).json(erro.sqlMessage);
    });
}

module.exports = {
  primeiraKPI,
  contarSensoresForaPadrao,
  contarTotalSensores,
  buscarParametrosPorSetor,
  buscarSalasForaDosParametros,
  
};
