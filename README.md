# Braço Robótico para Manipulação de Objetos

## Integrantes

- Lucca Vilaça - 551538
- Pedro Henrique Farath - 98608
- Luana Cabezaolias - 99320
- Juliana Maita - 99224
- Joao Vitor - 550453
---

## Descrição do Projeto

Este projeto consiste no desenvolvimento de um braço robótico controlado por Arduino Uno, capaz de realizar movimentos de subida, descida e acionamento de uma garra para manipulação de objetos. O sistema foi desenvolvido utilizando servomotores para movimentação das articulações e um LED indicador de status.

---

## Acesso ao Simulador

**Link público do Wokwi:**

> Cole aqui o link do seu projeto:
>
> https://wokwi.com/projects/465288311884875777

---

## Guia de Operação

Após abrir o Monitor Serial, envie os seguintes comandos:

| Comando | Função |
|----------|----------|
| U | Move o braço para cima (1 estágio) |
| D | Move o braço para baixo (1 estágio) |
| O | Abre a garra |
| C | Fecha a garra |

### Limites de Movimento

- O braço possui até **2 estágios de subida**.
- O braço possui até **2 estágios de descida**.
- A garra pode ser aberta ou fechada a qualquer momento.

---

## Software de Modelagem 3D

As peças mecânicas do braço robótico foram modeladas utilizando:

**OpenSCAD**

O software foi utilizado para desenvolver:

- Base do braço
- Suportes dos servomotores
- Elos articulados
- Garra robótica
- Componentes de encaixe para impressão 3D

---

## Especificações Técnicas

### Alimentação

- Arduino Uno alimentado via USB.
- Servomotores alimentados por fonte de **5V DC**.
- LED indicador operando em 5V.

### Pinagem Utilizada

| Componente | Pino Arduino |
|------------|-------------|
| Servo da Articulação | D9 |
| Servo da Garra | D10 |
| LED Indicador | D13 |

### Componentes Utilizados

- 1x Arduino Uno
- 2x Servomotores SG90
- 1x LED Vermelho
- 1x Resistor 220 Ω
- Jumpers
- Fonte 5V

---

## Estrutura do Projeto

```text
Projeto_Braco_Robotico/
│
├── src/
│   └── sketch.ino
│
├── model/
│   ├── GS - Braço Robótico.scad
│   └── GS - Braço Robótico.stl
│
├── images/
│   ├── Braço Mecanico 1.png
│   ├── Braço Mecanico 2.png
│   ├── Braço Mecanico 3.png
│   └── wokwi.png
│
└── README.md
```

- **src/**: código-fonte do Arduino.
- **model/**: arquivo de modelagem OpenSCAD e arquivo STL exportado.
- **images/**: imagens do modelo 3D e do circuito eletrônico.
- **README.md**: documentação principal do projeto.

---

## Funcionamento

O usuário controla o braço robótico através do Monitor Serial do Arduino. Os comandos enviados permitem movimentar as articulações e controlar a abertura e fechamento da garra, simulando operações básicas de manipulação de objetos.

