const int PIN_PULSADOR1 = 2; 
const int PIN_PULSADOR2 = 3; 
const int PIN_LED1 = 9;  
const int PIN_LED2 = 10; 

int estadoL1 = LOW;
int estadoL2 = LOW;

void setup() 
{
    //PULLUP (pulsado = LOW)
    pinMode(PIN_PULSADOR1, INPUT_PULLUP);
    pinMode(PIN_PULSADOR2, INPUT_PULLUP);

    //leds
    pinMode(PIN_LED1, OUTPUT);
    pinMode(PIN_LED2, OUTPUT);
    
    digitalWrite(PIN_LED1, LOW); 
    digitalWrite(PIN_LED2, LOW);
    
    Serial.begin(9600);
}

void loop() 
{
    if (digitalRead(PIN_PULSADOR1) == LOW) 
    {
        estadoL1 = HIGH; //Pulsador presionado
    } 
    else 
    {
        estadoL1 = LOW;  //Pulsador NO presionado
    }
    
    if (digitalRead(PIN_PULSADOR2) == LOW) 
    {
        estadoL2 = HIGH; 
    } else 
    {
        estadoL2 = LOW;
    }
    
    //comunicacion entre processing y arduino (recibir)
    recibirComandoSerial();

    //actualiza el hardware
    digitalWrite(PIN_LED1, estadoL1);
    digitalWrite(PIN_LED2, estadoL2);

    //comunicacion arduino entre processing (enviar)
    enviarEstadoPulsadores();
    
    delay(50);
}

void recibirComandoSerial() 
{
    while (Serial.available() > 0) 
    {
        char comando = Serial.read();
        
        switch (comando) 
        {
            case 'A': //L1 ON
                estadoL1 = HIGH;
                break;
            case 'a': //L1 OFF
                estadoL1 = LOW;
                break;
            case 'B': //L2 ON
                estadoL2 = HIGH;
                break;
            case 'b': //L2 OFF
                estadoL2 = LOW;
                break;
        }
    }
}

void enviarEstadoPulsadores() 
{
    String mensaje = "";
    
    mensaje += (digitalRead(PIN_PULSADOR1) == LOW) ? "1" : "0";
    
    mensaje += (digitalRead(PIN_PULSADOR2) == LOW) ? "1" : "0";

    Serial.println(mensaje);
}
