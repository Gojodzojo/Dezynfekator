void menu() { //<>//
  background(255, 213, 150);
  noStroke();
  rectMode(CENTER);
  textAlign(CENTER, CENTER);

  //tytuł
  textSize(height/5);
  fill(255);
  text("Dezynfekator", width/2, height/7);

  nowyPrzycisk(width/2, height/2, width/3, height/7, j*1.5, "Graj");
  nowyPrzycisk(width/2, height - height/3.1, width/3, height/7, j*1.5, "Tabela wyników");
  nowyPrzycisk(width/2, height - height/7, width/3, height/7, j*1.5, "Wyjdź");
}

void menuPrzyciski() {
  //przycisk "Graj"
  if (najechanie(width/2, height/2, width/3, height/7)) {
    tryb = "gra";
    gracz = new Gracz();
    nrFali = 0;
    obecnyCzas = 10;

    wirusy.clear();
    noweWirusy.clear();
    noweWirusy.add(new zwyklyWirus());
    noweWirusy.add(new szybkiWirus());
  }
  //przycisk "Tabela wyników"
  else if (najechanie(width/2, int(height - height/3.1), width/3, height/7)) {
    tabelaWynikow = loadJSONArray("tabelaWynikow.json");
    tryb = "tabelaWynikow";
  }
  //przycisk "wyjście"
  else if (najechanie(width/2, height - height/7, width/3, height/5)) {
    exit();
  }
}

void gra() {
  background(255, 213, 150);

  for (int i = 0; i < nagrody.size(); i++) {
    nagrody.get(i).wyswietl(); 
    nagrody.get(i).podnies(i);
  }

  for (int i = 0; i < czasteczki.size(); i++) {
    czasteczki.get(i).wyswietl();
    if (czasteczki.get(i).czasZycia <= 0) {
      czasteczki.remove(i);
    }
  }

  gracz.wyswietlPociski();
  gracz.wyswietlPostac();
  gracz.strzel();
  if (gracz.hp <= 0) {
    sortowanieWynikow();
    nazwaGracza = "Wpisz swoje imię";
    tryb = "porazka";
  }

  for (int i = 0; i < wirusy.size(); i++) {
    wirusy.get(i).wyswietl();
    wirusy.get(i).atak();

    if (wirusy.get(i).hp <= 0) {
      wirusy.get(i).losujNagrode();
      wirusy.get(i).dodajCzasteczki();
      wirusy.remove(i);
    }
  }

  gracz.wyswietlInterfejs();
  obecnyCzas -= 1/frameRate;

  if (obecnyCzas <= 0) {
    obecnyCzas = czasFali;
    nrFali++;
    wirusy.addAll(noweWirusy);
    noweWirusy.clear();

    //losowanie wirusów, które pojawią się w przyszłej turze
    new Thread(losowanieWirusow()).start();
  }
}

void porazka() {
  rectMode(CENTER);
  fill(14, 217, 240);
  rect(width/2, height/2, j*25, j*17, j);
  textAlign(CENTER, CENTER);
  textSize(height/10);
  fill(255);
  text("Zostałeś zainfekowany", width/2, height/7);

  float pozycjaY;
  String text = "Pokonałeś " + nrFali + " fal wirusów.\n";
  if (uzyskaneMiejsce == 0) {
    text += "Nie uzyskałeś żadnego miejsca w tabeli wyników."; 
    pozycjaY = height/2;
  } else {
    text += "Uzyskałeś " + uzyskaneMiejsce + " miejsce w tabeli wyników.";
    pozycjaY = height/3;
    rect(width/2, height/2 + j*2, j*20, j*2.5, j*1.25);
    fill(0);
    text(nazwaGracza, width/2, height/2 + j*2 - height/100);
  }

  textSize(j);
  fill(255);
  text(text, width/2, pozycjaY);
  nowyPrzycisk(width/2 - j*6, height - height/7, j*10, j*2, j, "Wyjdź do menu");
  nowyPrzycisk(width/2 + j*6, height - height/7, j*10, j*2, j, "Spróbuj ponownie");
}

void porazkaPrzyciski() {
  //przycisk "Wyjdź do menu"
  if (najechanie(width/2 - j*6, height - height/7, j*10, j*2)) {
    if (uzyskaneMiejsce != 0) {
      zapisywanieWynikow();
    }
    tryb = "menu";
  }
  //przycisk "Spróbuj ponownie"
  else if (najechanie(width/2 + j*6, height - height/7, j*10, j*2)) {
    if (uzyskaneMiejsce != 0) {
      zapisywanieWynikow();
    }

    tryb = "gra";
    gracz = new Gracz();
    nrFali = 0;
    obecnyCzas = 10;

    wirusy.clear();
    noweWirusy.clear();
    noweWirusy.add(new zwyklyWirus());
    noweWirusy.add(new szybkiWirus());
  }
}

void tabelaWynikow() {
  float odstep = 1.6;
  background(255, 213, 150);
  fill(52, 137, 235);
  textSize(j);
  text("miejsce", width/5, j*odstep);
  text("nazwa gracza", (width/5) * 2, j*odstep);
  text("liczba fal", (width/5) * 3, j*odstep);
  text("data", (width/5) * 4, j*odstep);

  for (int i = 0; i < tabelaWynikow.size(); i++) {
    JSONObject rekord =  tabelaWynikow.getJSONObject(i);
    stroke(52, 137, 235);
    strokeWeight(3);
    line((width/8), (i + 1) * j*odstep + j*0.9, (width/8) * 7, (i + 1) * j*odstep + j*0.9);
    text(i + 1, width/5, (i + 2) * j*odstep);
    text(rekord.getString("nazwa"), (width/5) * 2, (i + 2) * j*odstep);
    text(rekord.getInt("fale"), (width/5) * 3, (i + 2) * j*odstep);
    text(rekord.getString("data"), (width/5) * 4, (i + 2) * j*odstep);
  }
  noStroke();
  nowyPrzycisk(2*j, 2*j, j, j, j, "←");
}

void tabelaWynikowPrzyciski() {
  tabelaWynikow = null;
  tryb = "menu";
}

void nowyPrzycisk(float x, float y, float w, float h, float wielkoscTekstu, String text) {
  color kolorTekstu = color(0);
  color kolorPrzycisku = color(0);

  if (najechanie(x, y, w, h)) {
    cursor(HAND);
    kolorTekstu = color(255);
    kolorPrzycisku = color(52, 137, 235);
  } else {
    kolorTekstu = color(52, 137, 235);
    kolorPrzycisku = color(255);
  }

  fill(kolorPrzycisku);
  rect(x, y, w, h, h/2);
  textSize(wielkoscTekstu);
  fill(kolorTekstu);
  text(text, x, y - wielkoscTekstu * 0.1);
}

boolean najechanie(float x, float y, float w, float h) {
  if (mouseX >= x - w/2 && mouseX <= x + w/2 && mouseY >= y - h/2 && mouseY <= y + h/2) return true;
  return false;
}

Runnable losowanieWirusow() {
  return new Runnable() {
    public void run() {
      int trudnoscDocelowa = nrFali*5;
      int obecnaTrudnosc = 0;

      while (obecnaTrudnosc < trudnoscDocelowa) {
        int nrNowegoWirusa = round( random(0, dostepneWirusy.length -1) );
        Wirus nowyWirus = new Wirus(dostepneWirusy[nrNowegoWirusa]);
        int mnoznikTrudnosci = round( random(1, nrFali) );
        nowyWirus.modyfikujTrudnosc(mnoznikTrudnosci);

        if (nowyWirus.trudnosc + obecnaTrudnosc <= trudnoscDocelowa) {
          obecnaTrudnosc += nowyWirus.trudnosc;

          noweWirusy.add(nowyWirus);
        }
      }
    }
  };
}

void sortowanieWynikow() {
  tabelaWynikow = loadJSONArray("tabelaWynikow.json");
  uzyskaneMiejsce = 0;
  if (tabelaWynikow.size() < 10) {
    uzyskaneMiejsce = tabelaWynikow.size() + 1;
  }
  for (int i = 0; i < tabelaWynikow.size(); i++) {
    int wynikWTabeli = tabelaWynikow.getJSONObject(i).getInt("fale");
    if (wynikWTabeli <= nrFali) {
      uzyskaneMiejsce = i + 1;
      i = tabelaWynikow.size();
    }
  }
}

void zapisywanieWynikow() {
  if (tabelaWynikow.size() == 10) {
    tabelaWynikow.remove(9);
  }
  for (int i = tabelaWynikow.size() - 1; i >= uzyskaneMiejsce - 1; i--) {
    JSONObject staryWynik = tabelaWynikow.getJSONObject(i);
    tabelaWynikow.setJSONObject(i + 1, staryWynik);
  }
  JSONObject nowyWynik = new JSONObject();
  nowyWynik.setInt("fale", nrFali);
  nowyWynik.setString("nazwa", nazwaGracza);
  nowyWynik.setString("data", day() + "-" + month() + "-" + year());
  tabelaWynikow.setJSONObject(uzyskaneMiejsce - 1, nowyWynik);
  saveJSONArray(tabelaWynikow, "tabelaWynikow.json");
  tabelaWynikow = null;
}
