// ==========================================================
// ASTRAREACH LITE - VERSÃO FINAL AMARELA
// Braço Robótico de Coleta de Amostras
// Docking & Retrieval - Microgravidade
// OpenSCAD
//
// Compatível com:
// - Arduino Uno
// - 2 servomotores SG90/MG90S
// - Monitor Serial: U, D, O, C
// - Exportação STL
// ==========================================================

$fn = 72;

// ==========================================================
// PARÂMETROS AJUSTÁVEIS
// ==========================================================

servo_x = 23;
servo_y = 12;
servo_z = 24;

base_d = 82;
base_h = 22;
turret_h = 14;

arm_length = 130;
arm_width = 28;
arm_height = 14;

finger_length = 72;
finger_height = 12;

pivot_d = 6;

// Alturas principais
base_top_z = base_h + turret_h;
shoulder_pivot_z = base_top_z + 18;
arm_z = shoulder_pivot_z - arm_height / 2;
gripper_z = arm_z - 1;

// Coordenadas principais
arm_start_x = 0;
arm_end_x = arm_start_x + arm_length;

// ==========================================================
// CORES
// ==========================================================

// Cor principal do braço, base e garra
body_color = [1.00, 0.65, 0.05];      // amarelo/dourado técnico
gripper_color = [1.00, 0.65, 0.05];   // amarelo/dourado técnico

// Cor metálica dos eixos, horns, bielas e servos
metal_color = [0.75, 0.75, 0.75];     // prata claro

// ==========================================================
// UTILITÁRIOS
// ==========================================================

module screw_hole(d=3.2, h=30){
    cylinder(d=d, h=h);
}

module pivot_hole(d=pivot_d, h=30){
    cylinder(d=d, h=h);
}

module servo_cutout(){
    translate([-servo_x/2, -servo_y/2, -servo_z/2])
    cube([servo_x, servo_y, servo_z]);
}

// ==========================================================
// BASE ROTATIVA COM ENCAIXE SG90
// Servo 1: movimento UP / DOWN do braço
// ==========================================================

module space_base(){

    difference(){

        union(){
            // base circular principal
            cylinder(d=base_d, h=base_h);

            // torre superior da base
            translate([0,0,base_h])
            cylinder(d1=64, d2=52, h=turret_h);
        }

        // passagem central de eixo/cabos
        translate([0,0,-1])
        cylinder(d=10, h=80);

        // cavidade para servo 9g dentro da base
        translate([0,0,12])
        rotate([90,0,0])
        servo_cutout();

        // furos de fixação da base
        for(a=[0:90:270]){
            rotate([0,0,a])
            translate([30,0,-1])
            screw_hole(d=4, h=20);
        }
    }

    // detalhes visuais externos
    for(a=[0:45:315]){
        rotate([0,0,a])
        translate([20,-2,base_h])
        cube([14,4,8]);
    }
}

// ==========================================================
// DISCO / HORN DO SERVO PRINCIPAL
// ==========================================================

module servo_horn_disc(){

    color(metal_color)
    difference(){
        cylinder(d=30, h=7);

        translate([0,0,-1])
        cylinder(d=5, h=20);

        for(a=[0:90:270]){
            rotate([0,0,a])
            translate([9,0,-1])
            cylinder(d=2.2, h=20);
        }
    }
}

// ==========================================================
// SUPORTE EM U DO OMBRO
// Fica sobre a base e abraça o elo principal
// ==========================================================

module shoulder_bracket(){

    color(body_color)
    difference(){

        union(){
            // placa inferior do suporte
            translate([-17,-22,0])
            cube([42,44,6]);

            // lateral esquerda do U
            translate([-17,-22,0])
            cube([42,6,34]);

            // lateral direita do U
            translate([-17,16,0])
            cube([42,6,34]);

            // reforço frontal
            translate([19,-22,0])
            cube([6,44,22]);
        }

        // furo do eixo do ombro
        translate([0,0,18])
        rotate([90,0,0])
        cylinder(d=6.4, h=60, center=true);

        // alívio para o elo entrar no suporte
        translate([-3,-12,8])
        cube([26,24,18]);
    }
}

// ==========================================================
// PINO DO OMBRO
// ==========================================================

module shoulder_pin(){

    color(metal_color)
    translate([0,0,shoulder_pivot_z])
    rotate([90,0,0])
    cylinder(d=6, h=52, center=true);
}

// ==========================================================
// ELO PRINCIPAL DO BRAÇO
// ==========================================================

module main_arm(){

    difference(){

        hull(){
            cylinder(d=arm_width, h=arm_height);

            translate([arm_length,0,0])
            cylinder(d=arm_width, h=arm_height);
        }

        // vazado interno para reduzir massa
        translate([10,0,3])
        hull(){
            cylinder(d=arm_width - 12, h=arm_height);

            translate([arm_length - 20,0,0])
            cylinder(d=arm_width - 12, h=arm_height);
        }

        // furo do pivô inicial
        translate([0,0,-1])
        pivot_hole(d=6.4, h=30);

        // furo do pivô final
        translate([arm_length,0,-1])
        pivot_hole(d=6.4, h=30);

        // cortes estruturais/visuais
        for(i=[24:20:108]){
            translate([i,-18,arm_height/2])
            rotate([0,45,0])
            cube([8,36,8], center=true);
        }
    }
}

// ==========================================================
// DEDO DA GARRA
// ==========================================================

module gripper_finger(){

    difference(){

        union(){
            hull(){
                cylinder(d=16, h=finger_height);

                translate([finger_length,0,0])
                cylinder(d=12, h=finger_height);
            }

            // ponta arredondada
            translate([finger_length + 3,0,0])
            cylinder(d=16, h=finger_height);
        }

        // furo do pivô
        translate([0,0,-1])
        cylinder(d=5.2, h=24);

        // vazado interno
        translate([16,0,2])
        hull(){
            cylinder(d=7, h=12);

            translate([42,0,0])
            cylinder(d=5, h=12);
        }
    }

    // dentes internos para segurar amostras
    for(i=[20:9:60]){
        translate([i,-5,4])
        rotate([0,0,45])
        cube([4,4,5]);
    }
}

// ==========================================================
// BIELA VISUAL DA GARRA
// ==========================================================

module linkage_bar(){

    color(metal_color)
    difference(){

        hull(){
            cylinder(d=7, h=5);

            translate([25,0,0])
            cylinder(d=7, h=5);
        }

        translate([0,0,-1])
        cylinder(d=3, h=10);

        translate([25,0,-1])
        cylinder(d=3, h=10);
    }
}

// ==========================================================
// BASE DA GARRA COM ENCAIXE SG90
// Servo 2: OPEN / CLOSE
// ==========================================================

module gripper_base(){

    color(gripper_color)
    difference(){

        union(){
            // corpo circular principal da garra
            cylinder(d=56, h=16);

            // bloco traseiro que encaixa na ponta do elo
            translate([-46,-18,0])
            cube([56,36,16]);

            // reforços laterais
            translate([-44,-23,0])
            cube([20,5,16]);

            translate([-44,18,0])
            cube([20,5,16]);
        }

        // eixo central do horn da garra
        translate([0,0,-1])
        cylinder(d=10, h=30);

        // pivôs dos dedos
        translate([17,14,-1])
        cylinder(d=5.2, h=30);

        translate([17,-14,-1])
        cylinder(d=5.2, h=30);

        // cavidade para servo 9g da garra
        translate([-12,0,8])
        rotate([90,0,0])
        servo_cutout();

        // encaixe da ponta do elo dentro da garra
        translate([-48,-10,4])
        cube([34,20,8]);
    }
}

// ==========================================================
// GARRA FUNCIONAL DE 2 DEDOS — MAIS ABERTA
// ==========================================================

module space_gripper(){

    gripper_base();

    // hub central do servo da garra
    color(metal_color)
    translate([0,0,16])
    difference(){
        cylinder(d=22, h=7);

        translate([0,0,-1])
        cylinder(d=5, h=20);
    }

    // dedo superior mais aberto
    translate([17,14,8])
    rotate([0,0,6])
    color(gripper_color)
    gripper_finger();

    // dedo inferior mais aberto
    mirror([0,1,0])
    translate([17,14,8])
    rotate([0,0,6])
    color(gripper_color)
    gripper_finger();

    // biela superior
    translate([2,8,20])
    rotate([0,0,8])
    linkage_bar();

    // biela inferior
    mirror([0,1,0])
    translate([2,8,20])
    rotate([0,0,8])
    linkage_bar();
}

// ==========================================================
// MONTAGEM FINAL
// ==========================================================

module astrareach_lite(){

    // BASE ROTATIVA
    color(body_color)
    space_base();

    // DISCO DO SERVO PRINCIPAL
    translate([0,0,base_top_z])
    servo_horn_disc();

    // SUPORTE EM U SOBRE A BASE
    translate([0,0,base_top_z])
    shoulder_bracket();

    // PINO DO OMBRO
    shoulder_pin();

    // BRAÇO PRINCIPAL ENCAIXADO NO SUPORTE
    translate([arm_start_x,0,arm_z])
    color(body_color)
    main_arm();

    // GARRA ENCAIXADA NA PONTA DO BRAÇO
    translate([arm_end_x + 42,0,gripper_z])
    space_gripper();
}

// ==========================================================
// EXPORTAÇÃO
// ==========================================================

// Para exportar partes individuais, descomente uma por vez:
//
// space_base();
// main_arm();
// space_gripper();
//
// Para exportar o modelo completo:

astrareach_lite();