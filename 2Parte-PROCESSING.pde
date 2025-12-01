import processing.serial.*;

Serial port;
final int BAUD_RATE = 9600;

String estadoPulsadores = "00";
boolean L1_ON = false;
boolean L2_ON = false;

//INTERFAZ
final int X_BASE = 150;
final int Y_ENTRADA = 100;
final int Y_SALIDA = 200;
final int ANCHO = 60;
final int ALTO = 40;
final int RADIO_L = 40; 

void setup() {
    size(400, 300); //tamaño de la ventana
    
    println(Serial.list());
    
    port = new Serial(this, Serial.list()[0], BAUD_RATE); 
    port.bufferUntil('\n');
}

void draw() {
    background(255); //fondo blanco
    
    //DIBUJAR ETIQUETAS
    textSize(18);
    //etiqueta entradas
    fill(180, 200, 255); // azul claro
    rect(30, 30, 100, 30);
    fill(0);
    text("Entradas", 40, 52);

    //etiqueta salidas
    fill(255, 200, 180); // rosa claro
    rect(30, 160, 100, 30);
    fill(0);
    text("Salidas", 40, 182);

    //DIBUJAR ENTRADAS (E1 y E2)
    dibujaEntrada(X_BASE, Y_ENTRADA, ANCHO, ALTO, estadoPulsadores.charAt(0) == '1', "E1");
    dibujaEntrada(X_BASE + 100, Y_ENTRADA, ANCHO, ALTO, estadoPulsadores.charAt(1) == '1', "E2");

    //DIBUJAR SALIDAS (L1 y L2)
    dibujaSalida(X_BASE, Y_SALIDA, RADIO_L, L1_ON, "L1");
    dibujaSalida(X_BASE + 100, Y_SALIDA, RADIO_L, L2_ON, "L2");
}

void serialEvent(Serial port) 
{
    try 
    {
        estadoPulsadores = port.readStringUntil('\n').trim();
    } 
    catch (Exception e) 
    {
        println("Error leyendo Serial: " + e.getMessage());
    }
}

void mousePressed() 
{
    if (dist(mouseX, mouseY, X_BASE, Y_SALIDA) < RADIO_L) 
    {
        L1_ON = !L1_ON;
        if (L1_ON) 
        {
            port.write('A');
        } 
        else 
        {
            port.write('a');
        }
    }
    
    if (dist(mouseX, mouseY, X_BASE + 100, Y_SALIDA) < RADIO_L) 
    {
        L2_ON = !L2_ON;
        if (L2_ON) 
        {
            port.write('B');
        } else
        {
            port.write('b');
        }
    }
}

void dibujaEntrada(int x, int y, int w, int h, boolean activo, String label) 
{
    pushStyle();
    if (activo) 
    {
        fill(0, 255, 0);
    } 
    else 
    {
        fill(200);
    }
    rectMode(CENTER);
    rect(x, y, w, h);
    fill(0);
    textSize(16);
    textAlign(CENTER, CENTER);
    text(label, x, y);
    popStyle();
}

void dibujaSalida(int x, int y, int r, boolean activo, String label) 
{
    pushStyle();
    if (activo) 
    {
        fill(255, 0, 0); //rojo = ON
    } 
    else 
    {
        fill(200); //gris = OFF
    }
    ellipse(x, y, r * 2, r * 2);
    fill(0);
    textSize(16);
    textAlign(CENTER, CENTER);
    text(label, x, y);
    popStyle();
}

