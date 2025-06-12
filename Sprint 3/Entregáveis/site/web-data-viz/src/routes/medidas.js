var express = require("express");
var router = express.Router();

var medidaController = require("../controllers/medidaController");

router.get("/ultimas/:idSala", medidaController.buscarUltimasMedidas);
router.get("/tempo-real/:idSala", medidaController.buscarMedidasEmTempoReal);

router.get("/sensores-fora/:idSala", medidaController.contarSensoresForaPadrao);
router.get("/total-sensores/:idSala", medidaController.contarTotalSensores);

router.get("/:idSala", medidaController.buscarParametros);

router.get('/salas-fora', medidaController.buscarSalasForaDosParametros);

module.exports = router;
