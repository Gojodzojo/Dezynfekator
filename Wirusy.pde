class Wirus {
  int hp, obrazenia, trudnosc;
  float predkosc, promien, zasieg, x, y, przeladowanie;
  PImage obraz = loadImage("./img/koronaWirus.png");
  color kolor;
  int liczbaCzasteczek = 50;
  
 Wirus(int Trudnosc, int Hp, int Obrazenia, float Predkosc, float Promien, float Zasieg, color Kolor) {
   obrazenia = Obrazenia;
   trudnosc = Trudnosc;
   predkosc = Predkosc;
   promien = Promien;
   zasieg = Zasieg;
   kolor = Kolor;
   hp = Hp;
   
   losujSciane();
 }
 
 Wirus(Wirus oryginal){
   obrazenia = oryginal.obrazenia;
   trudnosc = oryginal.trudnosc;
   predkosc = oryginal.predkosc;
   promien = oryginal.promien;
   zasieg = oryginal.zasieg;
   kolor = oryginal.kolor;
   hp = oryginal.hp;
   
   losujSciane();
 }
 
 void losujSciane() {
   int nrSciany = round( random(1, 4) );
   switch(nrSciany) {
     case 1:
       x = random(-promien, width + promien);
       y = -promien;
       break;
     case 2:
       x = width + promien;
       y = random(-promien, height + promien);
       break;
     case 3:
       x = random(-promien, width + promien);
       y = height + promien;
       break;
     case 4:
       x = -promien;
       y = random(-promien, height + promien);
       break;
   }
 }
 
 void wyswietl() {
    if(gracz.x > x && gracz.x - x > promien + j/2) {
      x +=  predkosc;
    }
    else if(gracz.x < x && x - gracz.x > promien + j/2) {
      x -=  predkosc;
    }
    if(gracz.y > y && gracz.y - y > promien + j/2) {
      y +=  predkosc;
    }
    else if(gracz.y < y && y - gracz.y > promien + j/2) {
      y -=  predkosc;
    }
    
    tint(kolor);
    image(obraz, x, y, promien*2, promien*2);
    noTint();
 }
 
 void atak() {
   if(dist(gracz.x, gracz.y, x, y) <= promien + j + zasieg && przeladowanie >= 1) {
      gracz.hp -= obrazenia;
      przeladowanie = 0;
    }
    else if(przeladowanie < 1) {
      przeladowanie += 1/frameRate; 
    } 
 }
 void modyfikujTrudnosc(int mnoznik) {
   trudnosc = mnoznik * trudnosc;
   obrazenia *= mnoznik;
   hp *= mnoznik;
 }
 
 void losujNagrode() {
   if(random(0, 1) <= szansaNaNagrode) {
     float liczbaSzans = 0;
     for(int i = 1; i < dostepneNagrody.size() + 1; i++) {
       liczbaSzans += i;
     }
             
     int los = round(random(1, liczbaSzans));
     int szansa = 0;
     for(int i = 1; i < dostepneNagrody.size() + 1; i++) {
       szansa += i;
       if(los <= szansa) {
         Nagroda nagroda = dostepneNagrody.get(dostepneNagrody.size() - i);
         nagrody.add(new NagrodaNaZiemi(nagroda, x, y));
         
         if(nagroda instanceof Bron) {
           dostepneNagrody.remove(dostepneNagrody.size() - i);
         }
         i = dostepneNagrody.size() + 1;
       }
     }
   }
 }
 
 void dodajCzasteczki() {
   for(int i = 0; i < liczbaCzasteczek; i++) {
     czasteczki.add(new Czasteczka(x, y, kolor));
   }
 }
}

class Czasteczka {
  color kolor;
  float czasZycia;
  float x;
  float y;
  float odlegloscPrzemieszczenia = 0.15 * j;
  float wielkoscCzatseczki = 0.5 * j;
  
  Czasteczka(float X, float Y, color Kolor) {
    kolor = Kolor;
    x = X;
    y = Y;
    czasZycia = random(0.5, 2);
  }
  
  void wyswietl() {
    x += random(-odlegloscPrzemieszczenia, odlegloscPrzemieszczenia);
    y += random(-odlegloscPrzemieszczenia, odlegloscPrzemieszczenia);
    fill( color(red(kolor), green(kolor), blue(kolor), 255 * czasZycia) );
    ellipse(x, y, wielkoscCzatseczki, wielkoscCzatseczki);
    czasZycia -= 1/frameRate;
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class zwyklyWirus extends Wirus {
  zwyklyWirus() {
    super(1, 20, 2, j/15, j, j/2, color(85, 181, 111)); 
  }
}

class szybkiWirus extends Wirus {
  szybkiWirus() {
    super(2, 5, 5, j/8, j/2.5, j/3, color(85, 147, 181)); 
  }
}

class silnyWirus extends Wirus {
  silnyWirus() {
    super(5, 50, 20, j/10, j*1.5, j/2, color(102)); 
  }
}

class twardyWirus extends Wirus {
  twardyWirus() {
    super(8, 250, 15, j/20, j*3, j/1.5, color(181, 85, 85)); 
  }
}
