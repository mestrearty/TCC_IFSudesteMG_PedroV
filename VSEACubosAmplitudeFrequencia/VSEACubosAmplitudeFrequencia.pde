//Visualizador Sonoro de Entrada de Áudio com Cubos por Amplitude na Frequência
//Cores podem ser alteras utilizando amplitude em 5 espaços da frequência
//Trabalho desenvolvido por Pedro (ArtFicer) Ventura para IF Sudeste MG Campus Juiz de Fora (TCC)
import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
//AudioPlayer audio;//decomentar para ler mp3
AudioInput audio; //comentar para ler mp3

FFT fft;

void setup() {
  size (720, 480);
  background(0);

  minim = new Minim(this);
  audio = minim.getLineIn(); //comentar para ler mp3
  //audio = minim.loadFile("Som.mp3", 1024); //descomentar para ler mp3
  //audio.play();
  //audio.loop();

  //carregando as funções de análise de audio
  fft = new FFT( audio.bufferSize(), audio.sampleRate() );//cria o objeto fft, passando o tamanho do buffer do próprio audio (power of 2), lembrando que o tamanho da frequencia é sempre a metade dela em si (nyquist)
}

void draw() {
  background(0);//fundo
  //carregando
  fft.forward(audio.mix);//analisa e constroi o fft de um audio. .mix para direita e esquerda, .left esquerda, .right direita. Em caso de mais de uma variavel com fft, podemos utilizar para outras análises

  //----------------------------------------------

  for (int i =0; i<fft.specSize(); i++) {
    stroke(255);
    if (i<fft.specSize()/5)
    { 
      fill(int(fft.getBand(i)*1000)%255, 0, 0);
      rect(50, 100, 100, 100);
    }

    if ((i<fft.specSize()/5)&&(i<fft.specSize()*1/5))
    {
      fill(0, int(fft.getBand(i)*1000)%255, 0);
      rect(250, 100, 100, 100);
    }
    if ((i>fft.specSize()*2/5)&&(i<fft.specSize()*3/5))
    {
      fill(0, 0, int(fft.getBand(i)*1000)%255);
      rect(450, 100, 100, 100);
    }
    if ((i>fft.specSize()*3/5)&&(i<fft.specSize()*4/5))
    {
      fill(int(fft.getBand(i)*1000)%255, 0, int(fft.getBand(i)*1000)%255);
      rect(150, 250, 100, 100);
    }

    if ((i>fft.specSize()*4/5)&&(i<fft.specSize()))
    {
      fill(0, int(fft.getBand(i)*1000)%255, int(fft.getBand(i)*1000)%255);
      rect(350, 250, 100, 100);
    }
  }
}
