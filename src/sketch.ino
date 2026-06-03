#include <Servo.h>

// Servos
Servo servoBraco;
Servo servoGarra;

// Pinos
const int PIN_SERVO_BRACO = 9;
const int PIN_SERVO_GARRA = 10;
const int PIN_LED_STATUS = 13;

// Estágios do braço
// 0 = baixo, 1 = meio, 2 = cima
const int BRACO_BAIXO = 120;
const int BRACO_MEIO = 90;
const int BRACO_CIMA = 45;

int estagioBraco = 1; // Começa no meio

// Ângulos da garra
const int GARRA_ABERTA = 30;
const int GARRA_FECHADA = 95;

int anguloGarra = GARRA_ABERTA;

void setup() {
  Serial.begin(9600);

  servoBraco.attach(PIN_SERVO_BRACO);
  servoGarra.attach(PIN_SERVO_GARRA);

  pinMode(PIN_LED_STATUS, OUTPUT);

  servoBraco.write(BRACO_MEIO);
  servoGarra.write(anguloGarra);

  Serial.println("=== Braco Robotico de Coleta de Amostras ===");
  Serial.println("Comandos disponiveis:");
  Serial.println("U - Sobe o braco em ate 2 estagios");
  Serial.println("D - Desce o braco em ate 2 estagios");
  Serial.println("O - Abre a garra");
  Serial.println("C - Fecha a garra");
  Serial.println("--------------------------------------------");
}

void loop() {
  if (Serial.available() > 0) {
    char comando = Serial.read();

    // Ignora quebra de linha do Monitor Serial
    if (comando == '\n' || comando == '\r') {
      return;
    }

    comando = toupper(comando);

    digitalWrite(PIN_LED_STATUS, HIGH);

    switch (comando) {
      case 'U':
        if (estagioBraco < 2) {
          estagioBraco++;
          moverBracoPorEstagio();
          Serial.print("Comando U: braco subiu para o estagio ");
          Serial.println(estagioBraco);
        } else {
          Serial.println("Comando U: braco ja esta no estagio maximo.");
        }
        break;

      case 'D':
        if (estagioBraco > 0) {
          estagioBraco--;
          moverBracoPorEstagio();
          Serial.print("Comando D: braco desceu para o estagio ");
          Serial.println(estagioBraco);
        } else {
          Serial.println("Comando D: braco ja esta no estagio minimo.");
        }
        break;

      case 'O':
        anguloGarra = GARRA_ABERTA;
        servoGarra.write(anguloGarra);
        Serial.println("Comando O: garra aberta.");
        break;

      case 'C':
        anguloGarra = GARRA_FECHADA;
        servoGarra.write(anguloGarra);
        Serial.println("Comando C: garra fechada.");
        break;

      default:
        Serial.println("Comando invalido. Use U, D, O ou C.");
        break;
    }

    delay(200);
    digitalWrite(PIN_LED_STATUS, LOW);
  }
}

void moverBracoPorEstagio() {
  if (estagioBraco == 0) {
    servoBraco.write(BRACO_BAIXO);
  } else if (estagioBraco == 1) {
    servoBraco.write(BRACO_MEIO);
  } else if (estagioBraco == 2) {
    servoBraco.write(BRACO_CIMA);
  }
}