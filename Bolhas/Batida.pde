class Batida {

  BeatDetect beat;

  float x=0, y =0;
  float diametro=0;
  float yspeed;
  float r=200, g=r, b=r;
  float a=3;


  Batida(BeatDetect bd, float diametro) {
    beat=bd; //passa a batida
    x=random(width);//começa em um ponto X aleatório
    y=height;//começa na parte inferior da janela
    this.diametro=diametro;//tamanho do diâmetro da bolha
    yspeed=random(0.1, 2);//velocidade em que a bolha sobe
  }

  void batida () {

    for (int i = 0; i < beat.detectSize(); ++i)
    {
      // test one frequency band for an onset
      if ( beat.isRange(1, beat.detectSize()-1, 10 ))
      {
        cor();
        stroke(0);
        fill(this.r, this.g, this.b, this.a);
        ellipse(x, y, 70, 70);
      } else {
        ellipse(x, y, diametro, diametro);
      }
    }
  }

  void cor ()
  {
    this.r=int(random(0, 255));
    this.g=int(random(0, 255));
    this.b=int(random(0, 255));
    this.a=random(0, 10);
  }


  void subir() {
    if ( beat.isRange(1, beat.detectSize()-1, 10 ))
    {
      y-=random(0, 0.5);
      //garante que a bolha não suma caso alcanse alguma estremidade.
      if (y+30<0)y=height;
    }
    x+=random(-0.7, 0.7);
    if (x>width) x-=diametro;
    if (x<0) x+=diametro;
  }

  float getX() {
    return this.x;
  }

  float getY() {
    return this.y;
  }


  void setX(float x) {
    this.x=x;
  }

  void setY(float y) {
    this.y=y;
  }

  float getDiametro() {
    return this.diametro;
  }
}
