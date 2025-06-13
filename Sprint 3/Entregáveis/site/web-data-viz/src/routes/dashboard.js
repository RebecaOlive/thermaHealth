var express = require("express");
var router = express.Router();

var dashboardController = require("../controllers/dashboardController");

router.get("/kpi1/:email/:nomeSala", function (req, res) {
    dashboardController.primeiraKPI(req, res);
})

router.get("/sensores-fora/:idSala", function (req,res) {
    dashboardController.contarSensoresForaPadrao(req, res);
})

router.get("/total-sensores/:idSala", function (req,res) {
    dashboardController.contarTotalSensores(req, res);
})
/* 
router.get("/:idSala", function (req,res) {
    dashboardController.buscarParametros(req, res);
}) */

router.get('/salas-fora', function (req,res) {
    dashboardController.buscarSalasForaDosParametros(req, res);
});

module.exports = router;