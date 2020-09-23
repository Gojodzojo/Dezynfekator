interface Nagroda {
  PImage zwrocObraz();
}

class NagrodaNaZiemi {
  Nagroda nagroda;
  float x,y;
  
  NagrodaNaZiemi(Nagroda Nagroda, float X, float Y) {
    nagroda = Nagroda;
    x = X;
    y = Y;
  }
  
  void wyswietl() {
    float wysokosc;
    float szerokosc = j;
    if(nagroda instanceof Bron) {
      wysokosc = j*2;
    }
    else {
      wysokosc = j;
    }
    
    image(nagroda.zwrocObraz(), x, y, szerokosc, wysokosc);
  }
  
  void podnies(int numerNagrody) {
    if(dist(gracz.x, gracz.y, x, y) <= j*2) {
      if(nagroda instanceof Apteczka) {
        int wyleczoneHp = round( random(10, gracz.hpMax) );
        gracz.hp += wyleczoneHp;
        gracz.hp = constrain(gracz.hp, 0, gracz.hpMax);
      }
      else if(nagroda instanceof Wzmocnienie) {
        float poczatkowaCzescHp = 1.0 * gracz.hp / gracz.hpMax;
        int dodatkoweMaksymalneHp = round( random(10, gracz.hpMax * 2) );
        gracz.hpMax += dodatkoweMaksymalneHp;
        gracz.hp = int(poczatkowaCzescHp * gracz.hpMax);
      }
      else if(nagroda instanceof PlynDez) {
        int iloscPlynu = round( random(10, 100) );
        gracz.dez += iloscPlynu;
      }
      else {
        Bron nowaBron = (Bron) nagroda;
        gracz.bronie.add(nowaBron); 
      }
      nagrody.remove(numerNagrody);
    }
  }
}

//////////////////////////////////////////////////////////////////////

class Apteczka implements Nagroda {
  PImage obraz;
  
  Apteczka() {
    obraz = loadImage("./img/apteczka.png");
  }
  
  PImage zwrocObraz() {
    return obraz; 
  }
}

class Wzmocnienie implements Nagroda {
  PImage obraz;
  
  Wzmocnienie() {
    obraz = loadImage("./img/wzmocnienie.png");
  }
  
  PImage zwrocObraz() {
    return obraz; 
  }
}

class PlynDez implements Nagroda {
  PImage obraz;
  
  PlynDez() {
    obraz = loadImage("./img/plynDez.png");
  }
  
  PImage zwrocObraz() {
    return obraz; 
  }
}
