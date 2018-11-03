//Visualizador Sonoro de Entrada de Áudio
//Trabalho desenvolvido por Pedro (ArtFicer) Ventura para IF Sudeste MG Campus Juiz de Fora (TCC)
//Objetivo de demosntração de FFT 
//Variação do Visualizador Sonoro de Arquivo pré Gravado (VSAG),
//Lado direito e esquerdo exibidos de forma espelhada

//Bibliotecas
import ddf.minim.*;
import ddf.minim.analysis.*;
//---------------------------------------

//Criando objetos das bibliotecas
Minim minim; //obtem entradas de audio
AudioPlayer audio; //carrega e controlar arquivo de audio

//para entrada de audio comente AudioPlayer e todas suas funções, e descomente funções de AudioInput
//AudioInput audio;

//---------------------------------------

//Criando objetos de análise do audio (FFT)
FFT[] fft=new FFT[3]; //analisador do fast fourrier transform. [0]-> mix(direito e esquerdo, [1]->esquerdo, [2]->Direito
//---------------------------------------


//presets 

float height2; //posição em Y para segunda parte da tela
float largura; //posição em X para dividir a tela em 3 no eixo x
float escalaDoEspectro = 3; //O espectro é muito pequeno para se vizualisar, então ele é multiplicado por X vezes (essa variavel) para melhor compreenção 
float centroDaFrequencia = 0; //variavel para exibir a frequência do audio em tempo real
color cor=color(255, 0, 0);
//--------------------------------------



void setup() {
  size (1536, 480); //tamanho da janela, 2D
  background(0); //cor do fundo

  //variaveis para controlar posição em Y em relação ao tamanho da janela
  height2 = height/2; //1/2 do tamanho da janela para começar no segundo quadrante 
  //--------------------------------------

  //carregando os objetos
  minim=new Minim(this);//importa a classe pra analisar o som
  audio =minim.loadFile("Som.mp3", 1024);//carrega o som
  //--------------------------------------

  //inicializando o player de audio
  audio.play(); //toca o audio
  audio.loop(); //coloca o audio em loop
  //audio = minim.getLineIn(); //descomente caso queira capturar entrada de audio
  //--------------------------------------

  //carregando as funções de análise de audio
  for (int i=0; i<3; i++) {
    fft[i] = new FFT( audio.bufferSize(), audio.sampleRate() );//cria o objeto fft, passando o tamanho do buffer do próprio audio (power of 2), lembrando que o tamanho da frequencia é sempre a metade dela em si (nyquist)
    fft[i].linAverages( 30 );//faz uma média e divide os valores da frequencia em um espaço de (X) (partição da frequência)
  }

  rectMode(CORNERS); //para poder desenhar retangulos
}


void draw() {
  background(0);//fundo
  //carregando
  fft[0].forward(audio.mix);//analisa e constroi o fft de um audio. .mix para direita e esquerda, .left esquerda, .right direita. Em caso de mais de uma variavel com fft, podemos utilizar para outras análises
  fft[1].forward(audio.left); //audio esquerdo
  fft[2].forward(audio.right);//audio direito
  //----------------------------------------------

  //construindo a exibição das amostras
  for (int j = 0; j < 3; j++) {//primeiro laço para percorrer os canais de áudio 1->mix, 2->3squerda, 3->direita
    int  w = int((width*1/3)/fft[j].avgSize());//pega um terço da média da tela
    if (j==0) {
      largura=0; //início do primeiro quadrante
      cor=color(255, 0, 0); //transforma a cor do mix quarante em vermelho)
    }

    if (j==1||j==2) {
      largura=width*2/3;//início do terceiro quadrante
      cor=color(0, 255, 0); //cor do lado esquerdo de verde

      if (j==2) {
        cor=color(0, 0, 255);//cor do lado direito azul
      }
    }
    if (j==1)largura--;//cria uma pequena separação entre as exibições da seguda etapa
    //primeiro efeito,construção de toda a frequencia
    for (int i = 0; i < fft[j].specSize(); i++) //percorre todo tamanho do spectro do audio (513)
    {   
      // função para pintar o mouse de vermelho na amplitude sobre o eixo x do mouse
      if ( i+largura == mouseX  && j!=1)//compara a posição do mouse com a posição do spectro desenhado
      {
        centroDaFrequencia = fft[j].indexToFreq(i);//pega a frequencia da posição sobre o spectro
        stroke(cor);
        fill(255, 128);
        text("Média da frequência do spectro: " + centroDaFrequencia, largura+100, height2 - 100);//exibe a frequencia do ponto específico pegado anteriormente
      } else
      {
        if (largura-i == mouseX  && j==1) {
          stroke(cor);
          fill(255, 128);
          text("Média da frequência do spectro: " + centroDaFrequencia, width*1/3+100, height2 - 100);//exibe a frequencia do ponto específico pegado anteriormente
        } else {
          stroke(255);//volta a coloração branca
        }
      }
      if (j==0 || j==2)line(i+largura, height2, i+largura, height2 - fft[j].getBand(i)*escalaDoEspectro); //primeiro campo é o eixo x, no caso i, que é qual parte do spectro , depois a posição y, x, depois inverte Y * escala do spctro
      if (j==1)line(largura-i, height2, largura-i, height2 - fft[j].getBand(i)*escalaDoEspectro); //primeiro campo é o eixo x, no caso i, que é qual parte do spectro , depois a posição y, x, depois inverte Y * escala do spctro
    }
    //--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    //início do desenho onde definimos o tamanho da partição da frequencia, no caso 30
    if (j==1)largura-=w;//por conta do espelhamento do lado esquerdo, para evitar que haja interceção entre os primeiros plots, recuo uma casa (w)
    for (int i = 0; i < fft[0].avgSize(); i++)//percorre a partição
    {

      if ( mouseX >= i*w+largura && mouseX < i*w + w+largura  && j!=1)
      {
        centroDaFrequencia = fft[0].getAverageCenterFrequency(i);//pega a frequencia da posição sobre o spectro

        fill(255, 128);
        text("Média Linear da frequência do spectro: " + centroDaFrequencia, largura+100, height - 100);//exibe a frequencia do ponto específico pegado anteriormente

        fill(cor);
      } else
      {
        if ( mouseX >= largura-i*w && mouseX <  w+largura - i*w && j==1)
        {
          centroDaFrequencia = fft[0].getAverageCenterFrequency(i);//pega a frequencia da posição sobre o spectro

          fill(255, 128);
          text("Média Linear da frequência do spectro: " + centroDaFrequencia, width*1/3+100, height - 100);//exibe a frequencia do ponto específico pegado anteriormente

          fill(cor);
        } else {
          fill(255);
        }
      }
      noStroke();
      if (j==0 || j==2)rect(i*w+largura, height, i*w + w+largura, height - fft[j].getAvg(i)*escalaDoEspectro);//desenha igual ao anterior, só que respeitando a partição
      if (j==1)rect(largura-i*w, height, w+largura-i*w, height - fft[j].getAvg(i)*escalaDoEspectro);
    }
  }
}
