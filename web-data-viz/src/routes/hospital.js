var express = require("express");
var router = express.Router();

var hospitalController = require("../controllers/hospitalController");

//Recebendo os dados do html e direcionando para a função cadastrar de usuarioController.js
router.post("/cadastrar", function (req, res) {
    hospitalController.cadastrar(req, res);
})

router.get("/buscar", function (req, res) {
    hospitalController.buscarPorCnpj(req, res);
});

router.get("/buscar/:idHospital", function (req, res) {
  hospitalController.buscarPorId(req, res);
});

router.get("/listar", function (req, res) {
  hospitalController.listar(req, res);
});

module.exports = router;