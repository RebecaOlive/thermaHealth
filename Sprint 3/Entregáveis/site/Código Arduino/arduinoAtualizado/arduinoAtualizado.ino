#include "DHT.h" //  chamar biblioteca 

#define TIPO_SENSOR DHT11 // definir o sensor DHT11
const int PINO_SENSOR_UMIDADE_DHT11 = A2; // variável para armazenar a saida na porta analógica
const int PINO_SENSOR_TEMPERATURA_LM35 = A0; // variável para armazenar a saída na porta analógica
float temperaturaCelsius; // variável para armazenar a temperatura lida

DHT sensorDHT(PINO_SENSOR_UMIDADE_DHT11, TIPO_SENSOR);
void setup(){
// configura taxa de transferência em bauds
Serial.begin(9600); // inicia a comunicação serial a 9600 bauds(bits por segundo)
sensorDHT.begin();
}

// Função que será executada de forma continua
void loop() { //Leitura analógica da porta A0
float umidade = sensorDHT.readHumidity();
int temperatura = analogRead(PINO_SENSOR_TEMPERATURA_LM35); // precisão do A/D ->
temperaturaCelsius = (temperatura * 5.0 / 1023.0) / 0.01; // 5 se refere aos volts ; 1023 a unidade ; 0.01 mV 

if (isnan(temperaturaCelsius) || isnan(umidade)) { // condição para iniciar 
  Serial.println("Erro ao ler os dados do sensor");
}else {
 // inicia a impressão dos dados 
Serial.print(umidade); // valor do dado do sensor
Serial.print(";");
Serial.println(temperaturaCelsius);

}
delay(1000); // tempo para realizar outra leitura
}