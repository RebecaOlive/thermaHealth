var express = require("express");
var router = express.Router();

var salaController = require("../controllers/salaController");

router.get("/hospital/:idHospital", function (req, res) {
  salaController.buscarSalasPorHospital(req, res);
});

router.post("/cadastrar", function (req, res) {
  salaController.cadastrar(req, res);
})

router.get("/resultadoBuscarSetores/", function (req, res) {
  salaController.contextualizarSetores(req, res);
})

module.exports = router;