class Bron implements Nagroda {
  float obrazenia, predkosc, szybkostrzelnosc, przeladowanie, koszt;
  PImage obraz;
  String nazwa;
  Bron(float Obrazenia, float Szybkostrzelnosc,float Predkosc,float Koszt,String Nazwa){
    obrazenia = Obrazenia;
    szybkostrzelnosc = Szybkostrzelnosc;        //liczba sekund między strzałami
    przeladowanie = Szybkostrzelnosc;
    predkosc = Predkosc;
    koszt = Koszt;                              //ilość dezynfekatora do jednego strzału
    obraz = loadImage("./img/" + Nazwa + ".png");
    nazwa = Nazwa;
  }
  
  void strzal() {}    //to co ma się stać przy strzale
  
  PImage zwrocObraz() {
    return obraz; 
  }
}

interface Callback {
  void trafienie(Pocisk staryPocisk);
  void sciana(Pocisk staryPocisk);
}

class Pocisk {
 PVector wektorRuchu;
 float x, y, obrazenia;
 Bron bron;
 Callback callback;
 Pocisk(PVector WektorRuchu, float X, float Y, float Obrazenia, Callback Callback) {
   wektorRuchu = WektorRuchu;
   x = X;
   y = Y;
   obrazenia = Obrazenia;
   
   if(Callback != null) {
     callback = Callback;  
   }
   else {
     callback = new Callback() {
       void trafienie(Pocisk staryPocisk){};
       void sciana(Pocisk staryPocisk){};
     }; 
   }
   
  }
 
 boolean wyswietl() {
   x += wektorRuchu.x;
   y += wektorRuchu.y;
   
   if(x < 0 || y < 0 || x > width || y > height) {
     callback.sciana(this);
     return false; 
   }
   
   for(int i = 0; i < wirusy.size(); i++) {
     Wirus wirus = wirusy.get(i);
     if(dist(wirus.x, wirus.y, x, y) <= wirus.promien) {
       callback.trafienie(this);
       wirusy.get(i).hp -= obrazenia;
       return false;
     }
   }
   
   ellipse(x,y,height/100,height/100);
   return true;
 }
}

/////////////////////////////////////////////////////////////////////////////////////////

class PistNaWod extends Bron{
  PistNaWod(){
    super(2, 0.5, j/4, 0,"Pistolet na wodę");
  }
  
  void strzal() {
    PVector wektorRuchu = PVector.fromAngle(gracz.katLufy);
    wektorRuchu.mult(predkosc);
    
    gracz.pociski.add(new Pocisk(wektorRuchu, gracz.lufaX, gracz.lufaY, obrazenia, null));
  }
}

class Shotgun extends Bron {
  int iloscPociskow = 15;
  float obszarStrzalu = QUARTER_PI;
  Shotgun(){
    super(3, 1, j/6, 8, "Shotgun");
  }
  
  void strzal() {
    for(int i = 0; i < iloscPociskow; i++) {
      float odchylenie = random(-obszarStrzalu, obszarStrzalu);
      float predkoscPocisku = random(predkosc/2, predkosc);
      PVector wektorRuchu = PVector.fromAngle(gracz.katLufy + odchylenie);
      wektorRuchu.mult(predkoscPocisku);
      
      gracz.pociski.add(new Pocisk(wektorRuchu, gracz.lufaX, gracz.lufaY, obrazenia, null)); 
    }
  }
}

class Troj extends Bron {
  float przerwa = 0.05;  //czas między dwoma strzałami
  int liczbaPociskow = 3;
  Troj() {
    super(5, 1, j/5, 2, "Trójstrzałowiec");
  }
  
  void strzal() {
    
    //wykona się asynchronicznie
    new Thread(new Runnable() {
      public void run() {
        for(int i = 0; i < liczbaPociskow; i++) {
          PVector wektorRuchu = PVector.fromAngle(gracz.katLufy);
          wektorRuchu.mult(predkosc);
          
          gracz.pociski.add(new Pocisk(wektorRuchu, gracz.lufaX, gracz.lufaY, obrazenia, null));
          delay( int(przerwa * 1000) );
        }
      }
    }).start();
    
  }
}

class Bazooka extends Bron {
  float liczbaPociskow = 30;      //liczba pociskow po uderzeniu we wroga
  float predkoscWybuchu = j/5;  //prędkosc pocisków po uderzeniu we wroga
  Bazooka(){
    super(5, 1.5, j/10, 10, "Odkażająca bazooka");
  }
  
  //tworzenie nowych pocisków po uderzeniu we wroga i w sciane
  void wybuch(Pocisk staryPocisk) {
    for(int i = 0; i < liczbaPociskow; i++) {
      float kat = TWO_PI * (i / liczbaPociskow); 
      PVector wektorRuchu = PVector.fromAngle(kat);
      wektorRuchu.mult(predkoscWybuchu); 
      gracz.pociski.add(new Pocisk(wektorRuchu, staryPocisk.x, staryPocisk.y, obrazenia, null));
    }
  }
  
  void strzal() {
    
    Callback callback = new Callback() {
      public void trafienie(Pocisk staryPocisk) {
        wybuch(staryPocisk);
      }
      public void sciana(Pocisk staryPocisk) {
        wybuch(staryPocisk);
      }
    };
    
    //tworzenie pocisku po wytrzale
    PVector wektorRuchu = PVector.fromAngle(gracz.katLufy);
    wektorRuchu.mult(predkosc);
    
    gracz.pociski.add(new Pocisk(wektorRuchu, gracz.lufaX, gracz.lufaY, obrazenia, callback));
  }
}

class Karabin extends Bron {
  float obszarStrzalu = QUARTER_PI/8;
  Karabin(){
    super(3, 0.1, j/2, 0.5, "Dezynfekujący karabin");
  }
  
  void strzal() {
    float odchylenie = random(-obszarStrzalu, obszarStrzalu);
    PVector wektorRuchu = PVector.fromAngle(gracz.katLufy + odchylenie);
    wektorRuchu.mult(predkosc);
    gracz.pociski.add(new Pocisk(wektorRuchu, gracz.lufaX, gracz.lufaY, obrazenia, null)); 
  }
}

class Rykoszet extends Bron {
  float obszarStrzalu = QUARTER_PI/8;
  Rykoszet(){
    super(5, 0.3, j, 1, "Rykoszet");
  }
  
  void strzal() {
    
    Callback odbicie = new Callback() {
      public void trafienie(Pocisk pocisk){}
      
      //dodanie nowego, odbitego pocisku
      public void sciana(Pocisk pocisk) {        
        PVector wektorOdbicia = new PVector();
        if(pocisk.x > width || pocisk.x < 0) {
          wektorOdbicia. x = -pocisk.wektorRuchu.x;
          wektorOdbicia. y = pocisk.wektorRuchu.y;
        }
        else {
          wektorOdbicia. x = pocisk.wektorRuchu.x;
          wektorOdbicia. y = -pocisk.wektorRuchu.y;
        }
        gracz.pociski.add(new Pocisk(wektorOdbicia, pocisk.x, pocisk.y, obrazenia, this)); 
      }
    };
    
    float odchylenie = random(-obszarStrzalu, obszarStrzalu);
    PVector wektorRuchu = PVector.fromAngle(gracz.katLufy + odchylenie);
    wektorRuchu.mult(predkosc);
    gracz.pociski.add(new Pocisk(wektorRuchu, gracz.lufaX, gracz.lufaY, obrazenia, odbicie)); 
  }
}

class Snajperka extends Bron {
  Snajperka(){
    super(150, 1.5, j*2, 10, "Snajperka");
  }
  
  void strzal() {
    PVector wektorRuchu = PVector.fromAngle(gracz.katLufy);
    wektorRuchu.mult(predkosc);

    gracz.pociski.add(new Pocisk(wektorRuchu, gracz.lufaX, gracz.lufaY, obrazenia, null)); 
  }
}
