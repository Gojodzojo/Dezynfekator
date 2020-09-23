String tryb = "menu";  
IntDict aktywneKlawisze = new IntDict();
float j;  //jednostka
Gracz gracz;
ArrayList<Wirus> wirusy = new ArrayList<Wirus>();
ArrayList<Wirus> noweWirusy = new ArrayList<Wirus>(); // wirusy, które pojawią się w następnej fali
ArrayList<Czasteczka> czasteczki = new ArrayList<Czasteczka>();
Wirus[] dostepneWirusy = new Wirus[4];
int nrFali;
int czasFali = 30;
float obecnyCzas;
ArrayList<NagrodaNaZiemi> nagrody =  new ArrayList<NagrodaNaZiemi>();
ArrayList<Nagroda> dostepneNagrody =  new ArrayList<Nagroda>();
float szansaNaNagrode = 0.4;
JSONArray tabelaWynikow;
int uzyskaneMiejsce;
String nazwaGracza = "Wpisz swoje imię";

void setup() {
  surface.setTitle("Dezynfekator");
  fullScreen(P2D);
  frameRate(60);
  imageMode(CENTER);
  ellipseMode(CENTER);
  //size(1000,1000);
  j = height/20;
  
  aktywneKlawisze.set("w",0);
  aktywneKlawisze.set("s",0);
  aktywneKlawisze.set("a",0);
  aktywneKlawisze.set("d",0);
  
  dostepneWirusy[0] = new zwyklyWirus();
  dostepneWirusy[1] = new szybkiWirus();
  dostepneWirusy[2] = new silnyWirus();
  dostepneWirusy[3] = new twardyWirus();
  
  dostepneNagrody.add(new PlynDez());
  dostepneNagrody.add(new Apteczka());
  dostepneNagrody.add(new Troj());
  dostepneNagrody.add(new Rykoszet());
  dostepneNagrody.add(new Shotgun());
  dostepneNagrody.add(new Wzmocnienie());
  dostepneNagrody.add(new Karabin());
  dostepneNagrody.add(new Bazooka());
  dostepneNagrody.add(new Snajperka());
}

void draw() {
 cursor(ARROW);
 
 switch(tryb) {
   case "gra":
     gra();
     break;
   case "menu":
     menu();
     break;
   case "porazka":
     porazka();
     break;
   case "tabelaWynikow":
     tabelaWynikow();
     break;
 }
}

void mouseClicked() {
 switch(tryb) {
   case "menu":
     menuPrzyciski();
     break;
   case "porazka":
     porazkaPrzyciski();
     break;
   case "tabelaWynikow":
     tabelaWynikowPrzyciski();
     break;
 }
}

void keyPressed() {
  aktywneKlawisze.set(str(key), 1);
  
  if(tryb == "porazka") {
    if(nazwaGracza == "Wpisz swoje imię") {
      nazwaGracza = ""; 
    }
    if(keyCode == 8 && nazwaGracza.length() > 0) {
      nazwaGracza = nazwaGracza.substring(0, nazwaGracza.length() - 1);  
    }
    else if(keyCode != 16 && keyCode != 19 && keyCode != 17 && nazwaGracza.length() <= 10) {
      nazwaGracza += key;
    }
  }
}

void keyReleased(){
  aktywneKlawisze.set(str(key),0);
}

void mouseWheel(MouseEvent event) {
  if(event.getCount() > 0) {
    gracz.obecnaBron++; 
  }
  else {
    gracz.obecnaBron--; 
  }
  
  if(gracz.obecnaBron > gracz.bronie.size() - 1)
  {
    gracz.obecnaBron = 0;
  }
  else if(gracz.obecnaBron < 0) {
    gracz.obecnaBron = gracz.bronie.size() - 1;
  }
}
