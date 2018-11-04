//Visualizador Sonoro de Entrada de Áudio, com efeitos de bolhas que se movimentam, expandem e trocam de cor
//ao detectarem batidas
//Trabalho desenvolvido por Pedro (ArtFicer) Ventura para IF Sudeste MG Campus Juiz de Fora (TCC)

import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
//AudioPlayer som; //descomentar caso queira testar com mp3
AudioInput som;
BeatDetect beat;
FFT fft;

Batida[] bolha = new Batida[10];

void setup()
{
  //size(displayWidth, displayHeight); 
  size(600, 400);

  minim = new Minim(this); //instanciando biblioteca
  //som = minim.loadFile("Som.mp3");//carregando música, descomentar caso queira testar com mp3
  som = minim.getLineIn(); 
  beat = new BeatDetect(som.bufferSize(), som.sampleRate()); //batidas
  fft = new FFT(som.bufferSize(), som.sampleRate());

  for (int i=0; i<bolha.length; i++) {
    bolha[i] = new Batida(beat, random(20, 40));
  }
  //som.loop(); //musica em loop //descomentar caso queira testar com mp3
  //som.play(); //toca a musica //descomentar caso queira testar com mp3
}

void draw() {
  beat.detect(som.mix); //passa a o som vigente para o detector de batidas
  background(255); 

  for (int i=0; i<10; i++)
  {
    bolha[i].batida();
    bolha[i].subir();
  }
}
