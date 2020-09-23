class Gracz {
 int hp, hpMax, obecnaBron;
 float x, y, szybkosc, dez, lufaX, lufaY, katLufy, katPostaci;
 ArrayList<Bron> bronie = new ArrayList<Bron>();
 ArrayList<Pocisk> pociski = new ArrayList<Pocisk>();
 
 Gracz(){
   x = width/2;
   y = height/2;
   dez = 100;      //ilość płynu dezynfekującego
   hpMax = 100;
   hp = 100;
   szybkosc = j/5;
   obecnaBron = 0;
   bronie.add(new PistNaWod());
 }
 
 void wyswietlPostac() {
   
   //chodzenie
   if(aktywneKlawisze.get("d") == 1)       x += szybkosc;
   else if(aktywneKlawisze.get("a") == 1)  x -= szybkosc;
   if(aktywneKlawisze.get("s") == 1)       y += szybkosc;
   else if(aktywneKlawisze.get("w") == 1)  y -= szybkosc;
   
   x = constrain(x, 0, width);
   y = constrain(y, 0, height);
   
   //Kąt między myszą a postacią
   katPostaci = atan2(mouseY - y, mouseX - x);  
   
   //wyświetlanie postaci   
   translate(x, y);
   rotate(katPostaci + HALF_PI);
   image(bronie.get(obecnaBron).obraz, j, 0, j, j*2);
   rectMode(CENTER);
   fill(0,255,0);
   rect(0, 0, j*2, j);
   fill(173, 77, 3);
   rect(0, 0, j, j);
   resetMatrix();
 }
 
 void wyswietlPociski() {
   //wyświetlanie pocisków i usuwanie gdy są poza ekranem
   fill(0,0,255);
   for (int i = 0; i < pociski.size(); i++) {
     if(pociski.get(i).wyswietl() == false){
         pociski.remove(i);
     }
   }
 }
 
 void wyswietlInterfejs() {
   int przerwa = 5;
   rectMode(CORNER);
   noFill();
   stroke(255);
   strokeWeight(2);
   rect(j, j, j*10 + przerwa*2, j + przerwa*2);
   noStroke();
   fill(255, 0, 0);
   rect(j + przerwa, j + przerwa, (1.0 * hp/hpMax) * j*10, j);
   fill(255);
   textSize(j/2);
   textAlign(CENTER, CENTER);
   text(hp + "/" + hpMax, j + przerwa + j*5, j*1.5 + przerwa);
   text(bronie.get(obecnaBron).nazwa, j + przerwa + j*5, j*2.5 + przerwa);
   textAlign(LEFT, CENTER);
   text("Płyn dez.: " + int(dez), j* + przerwa*2 + j*1.2, j*1.5 + przerwa);
   textAlign(RIGHT);
   text("Czas: " + int(obecnyCzas), width - j, j);
   text("Numer fali: " + nrFali, width - j, j*2);
 }
 
 void strzel() {
   Bron bron = bronie.get(obecnaBron);
   
   //kąt i pozycja lufy broni
   lufaX = cos(katPostaci) * (j) - sin(katPostaci) * (j) + x;
   lufaY = sin(katPostaci) * (j) + cos(katPostaci) * (j) + y;
   translate(lufaX, lufaY);
   katLufy = atan2(mouseY - lufaY, mouseX - lufaX);
   resetMatrix();
   
   //dodawanie pocisków
   if(mousePressed && bronie.get(obecnaBron).przeladowanie >= bron.szybkostrzelnosc && dez - bron.koszt > 0) {
     bron.strzal();
     
     bronie.get(obecnaBron).przeladowanie = 0;
     dez -= bron.koszt;
   }
   else if(bron.przeladowanie < bron.szybkostrzelnosc) {
     bronie.get(obecnaBron).przeladowanie += 1/frameRate; 
   }
 }
 
}
