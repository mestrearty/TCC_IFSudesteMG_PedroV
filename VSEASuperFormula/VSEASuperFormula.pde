//Visualizador Sonoro de Entrada de Áudio utilizando Super Fórmula
//Cores podem ser alteras apertando r,g,b,p,a e vértices inseridas ou removidas com botão esquerdo e direito do mouse
//Trabalho desenvolvido por Pedro (ArtFicer) Ventura para IF Sudeste MG Campus Juiz de Fora (TCC)


//Bibliotecas
import ddf.minim.*;
import ddf.minim.analysis.*;

float tempo=0;
int m=6;
char var='w';

Minim minim;
//AudioPlayer audio;//descomentar para usar mp3
AudioInput audio;
FFT fft;

void setup() {
  size (500, 500);

  //Pegando entrada de áudio
  minim = new Minim(this);
  audio = minim.getLineIn();

  //descomentar para usar mp3
  //audio = minim.loadFile("Som.mp3", 1024);
  //audio.play();
  // audio.loop();

  fft = new FFT(audio.bufferSize(), audio.sampleRate());


  noFill(); //sem preenchimento
  stroke(255);//borda
  strokeWeight(2);//largura da borda
}



void draw() {
  background(0);
  fft.forward(audio.mix);

  translate(width / 2, height /2); //reposiciona na tela

  //desenhando a super fórmula

  beginShape(POINTS);
  for (int i=0; i<10; i++) //percorrendo as 10 primeiras frequências
    //obs, se inserir um valor a cima de 30, dependendo do computador pode não conseguir processar
    //em tempo hábil, causando delay
  {
    cor(i);
    for (float theta = 0; theta <= 2 * PI; theta +=0.01) {
      float rad = sFormula(theta, 
        2, //a - X
        2, //b - Y
        m, //m - pontos de divisão do poligono
        1, //n1 suavidade das pontas
        sin(fft.getBand(i)/2)*0.5+0.5, //n2 
        cos(fft.getBand(i)/2)*0.5+0.5  //n3
        );
      float x = rad * cos (theta)*50;
      float y = rad * sin (theta)*50;
      vertex (x, y);
    }
  }
  endShape();
  tempo += 0.05;
}

//superfórmula
float sFormula (float theta, float a, float b, float m, float n1, float n2, float n3) {
  return  pow(pow(abs(cos(m * theta/4.0)/a), n2) + pow(abs(sin(m * theta/4.0)/b), n3), -1.0 / n1);
}

void mousePressed()
{
  if (mouseButton == LEFT) {
    m+=2;
  }
  if (mouseButton==RIGHT) {
    m-=2;
  }
}

void cor(int j)
{
  if (keyPressed) {
    var=key;
  }
  if (var=='r') {
    stroke(int(fft.getBand(j)*1000)%255, 0, 0);
  }
  if (var=='g') {
    stroke( 0, int(fft.getBand(j)*1000)%255, 0);
  }
  if (var=='b') {
    stroke( 0, 0, int(fft.getBand(j)*1000)%255);
  }
  if (var=='p') {
    stroke(int(fft.getBand(j)*1000)%255, 0, int(fft.getBand(j)*1000)%255);
  }
  if (var=='a') {
    stroke(0, int(fft.getBand(j)*1000)%255, int(fft.getBand(j)*1000)%255);
  }
  if (var=='w') {
    stroke(255);
  }
}
