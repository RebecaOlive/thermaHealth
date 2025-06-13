var medidaModel = require("../models/medidaModel");

function buscarUltimasMedidas(req, res) {

    const limite_linhas = 7;

    var idSala = req.params.idSala;

    console.log(`Recuperando as ultimas ${limite_linhas} medidas`);

    medidaModel.buscarUltimasMedidas(idSala, limite_linhas).then(function (resultado) {
        if (resultado.length > 0) {
            res.status(200).json(resultado);
        } else {
            res.status(204).send("Nenhum resultado encontrado!")
        }
    }).catch(function (erro) {
        console.log(erro);
        console.log("Houve um erro ao buscar as ultimas medidas.", erro.sqlMessage);
        res.status(500).json(erro.sqlMessage);
    });
}


function buscarMedidasEmTempoReal(req, res) {

    var idSala = req.params.idSala;

    console.log(`Recuperando medidas em tempo real`);

    medidaModel.buscarMedidasEmTempoReal(idSala).then(function (resultado) {
        if (resultado.length > 0) {
            res.status(200).json(resultado);
        } else {
            res.status(204).send("Nenhum resultado encontrado!")
        }
    }).catch(function (erro) {
        console.log(erro);
        console.log("Houve um erro ao buscar as ultimas medidas.", erro.sqlMessage);
        res.status(500).json(erro.sqlMessage);
    });
}

function contarSensoresForaPadrao(req, res) {
    const idSala = req.params.idSala;

    medidaModel.contarSensoresForaPadrao(idSala)
        .then(resultado => res.status(200).json(resultado))
        .catch(erro => {
            console.log(erro);
            res.status(500).json(erro.sqlMessage);
        });
}

function contarTotalSensores(req, res) {
    let idSala = req.params.idSala;
    medidaModel.contarTotalSensores(idSala)
        .then(resultado => res.status(200).json(resultado))
        .catch(erro => {
            console.log(erro);
            res.status(500).json(erro.sqlMessage);
        });
}


function buscarParametrosPorSetor(req, res) {
    const idSala = req.params.idSala;

    medidaModel.buscarParametrosPorSetor(idSala)
        .then(result => res.status(200).json(result))
        .catch(erro => {
            console.log(erro);
            res.status(500).json(erro.sqlMessage);
        });
}


function buscarSalasForaDosParametros(req, res) {
    medidaModel.buscarSalasForaDosParametros()
        .then(resultado => {
            res.status(200).json(resultado[0]);
        })
        .catch(erro => {
            console.error("Erro ao buscar resumo de salas:", erro);
            res.status(500).json({ erro: "Erro ao buscar dados das salas." });
        });
}

module.exports = {
    buscarUltimasMedidas,
    buscarMedidasEmTempoReal,
    contarSensoresForaPadrao,
    contarTotalSensores,
    buscarParametrosPorSetor,
    buscarSalasForaDosParametros
};
