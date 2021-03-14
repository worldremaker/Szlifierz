program szlifier;
uses crt2,graph;
var
   ster,tryb,x,y,z,timex,timey,licznik,kolor,maxx,maxy,maxz,liczprog,licznikprog:integer;
   ustawprogram : array [1..30] of integer;
   czujnik,koniec:char;
   wx,wy,wz,wmx,wmy,wmz:string;

procedure prawo;
          begin
               port[$378]:=1;
          end;

procedure lewo;
          begin
               port[$378]:=2;
          end;

procedure dol;
          begin
               port[$378]:=4;
          end;

procedure gora;
          begin
               port[$378]:=8;
          end;

procedure podnies;
          begin
               port[$378]:=16;
          end;

procedure opusc;
          begin
               port[$378]:=32;
          end;

procedure dzwonek;
          begin
               port[$378]:=64;
          end;

procedure starta;
          begin
               port[$278]:=1;
          end;

procedure startb;
          begin
               port[$278]:=2;
          end;

procedure startc;
          begin
               port[$278]:=4;
          end;

procedure stop;
          begin
               port[$378]:=0;
          end;

procedure silnikstop;
          begin
               port[$278]:=0;
          end;

procedure ustawienie;
          begin
               textcolor(white);
               liczprog:=0;
               repeat
                     for licznik:=1 to 30 do
                         begin
                              clrscr;
                              writeln('Ustaw, jaki chcesz wykonywac program.');
                              writeln;
                              writeln('1. Szlifowanie dookola zgodnie ze wskazowkami zegara.');
                              writeln('2. Szlifowanie dookola przeciwnie do wskazowek zegara.');
                              writeln('3. Szlifowanie wezykiem wzdluz.');
                              writeln('4. Szlifowanie wezykiem poprzecznie.');
                              writeln('5. Zygzak');
                              writeln('6. Koniec programowania.');
                              writeln('Pozostalo ',31-licznik,' pozycji.');
                              write('Podaj program na pozycje ',licznik,': ');
                              read(ustawprogram[licznik]);
                              if ustawprogram[licznik]=6 then licznik:=31;
                              if (ustawprogram[licznik]<1) or (ustawprogram[licznik]>6) then licznik:=licznik-1;
                              if ustawprogram[licznik]=3 then maxx:=1;
                              if ustawprogram[licznik]=4 then maxy:=1;
                              liczprog:=liczprog+1;
                         end;
               if maxx=1 then
                  begin
                       writeln;
                       writeln('Podaj czas w sekundach, jaki bedzie potrzebny do przejscia szlifierki ');
                       write('do nastepnego rzedu szlifowania w programie szlifowania wzdluznym: ');
                       readln(timex);
                  end;
               if maxy=1 then
                  begin
                       writeln;
                       writeln('Podaj czas w sekundach, jaki bedzie potrzebny do przejscia szlifierki ');
                       write('do nastepnej kolumny szlifowania w programie szlifowania poprzecznym: ');
                       readln(timey);
                  end;
               clrscr;
               writeln('Twoj program szlifowania:');
               for licznik:=1 to 30 do
                   begin
                        write(licznik,'. ');
                        if ustawprogram[licznik]=1 then writeln('Szlifowanie dookola zgodnie ze wskazowkami zegara.');
                        if ustawprogram[licznik]=2 then writeln('Szlifowanie dookola przeciwnie do wskazowek zegara.');
          if ustawprogram[licznik]=3 then writeln('Szlifowanie wezykiem wzdluz z czasem przejscia ',timex,' sekund.');
          if ustawprogram[licznik]=4 then writeln('Szlifowanie wezykiem poprzecznie z czasem przejscia ',timey,' sekund.');
                        if ustawprogram[licznik]=5 then writeln('Zygzak');
                        if ustawprogram[licznik+1]=6 then licznik:=30;
                   end;
               writeln;
               writeln('Czy potwierdzasz powyzszy program? [t/n]');
               czujnik:=readkey;
               until (czujnik='t') or (czujnik='T');
          end;

procedure wspolrzedne;
          begin
               str(x,wx);
               str(y,wy);
               str(z,wz);
               setcolor(15);
               outtextxy(220,430,wx);
               outtextxy(220,440,wy);
               outtextxy(220,450,wz);
          end;

procedure wymaz_wspolrzedne;
          begin
               setcolor(0);
               outtextxy(220,430,wx);
               outtextxy(220,440,wy);
               outtextxy(220,450,wz);
          end;

procedure alarm_zmiana_biegu;
          begin
               dzwonek;
               sound(700);
               delay(500);
               nosound;
               stop;
          end;

procedure alarm_start;
          begin
               dzwonek;
               sound(700);
               delay(3000);
               nosound;
               stop;
          end;

procedure rozpoznanie; {czyli bieg glowicy bez opuszczania}
          begin
               setcolor(15);
               outtextxy(100,400,'Rozpoznanie wielkosci plyty...');
               alarm_zmiana_biegu;
               prawo;
               repeat
                     wspolrzedne;
                     x:=x+1;
                     putpixel((x+10),(y+10),15);
                     delay(1000);
                     if keypressed then
                        if readkey='d' then czujnik:='d';
                     wymaz_wspolrzedne;
               until (czujnik='d');
               stop;
               setcolor(red);
               maxx:=x;
               str(maxx,wmx);
               outtextxy(450,430,'Granica boczna: 0 - ');
               outtextxy(610,430,wmx);
               alarm_zmiana_biegu;
               dol;
               repeat
                     wspolrzedne;
                     y:=y+1;
                     putpixel((x+10),(y+10),15);
                     delay(1000);
                     if keypressed then
                        if readkey='s' then czujnik:='s';
                     wymaz_wspolrzedne;
               until czujnik='s'{ or czujnik='esc'};
               stop;
               wspolrzedne;
               setcolor(red);
               maxy:=y;
               str(maxy,wmy);
               outtextxy(434,440,'Granica gora/dol: 0 - ');
               outtextxy(610,440,wmy);
               for licznik:=x downto 0 do
                   begin
                        putpixel((licznik+10),(y+10),15);
                        delay(10);
                   end;
               for licznik:=y downto 0 do
                   begin
                        putpixel((10),(licznik+10),15);
                        delay(10);
                   end;
               setcolor(0);
               outtextxy(100,400,'Rozpoznanie wielkosci plyty...');
               setcolor(15);
               outtextxy(100,400,'Rozpoznano wielkosc plyty.');
               delay(2000);
               outtextxy(100,410,'Odkladam glowice na pozycje startowa.');
               alarm_zmiana_biegu;
               lewo;
               repeat
                     if keypressed then
                        if readkey='a' then czujnik:='a';
               until czujnik='a';
               stop;
               alarm_zmiana_biegu;
               gora;
               repeat
                     if keypressed then
                        if readkey='w' then czujnik:='w';
               until czujnik='w';
               stop;
               setcolor(0);
               outtextxy(100,410,'Odkladam glowice na pozycje startowa.');
               setcolor(15);
               outtextxy(100,410,'Odlozono glowice na pozycje startowa.');
               delay(2000);
               setcolor(0);
               outtextxy(100,400,'Rozpoznano wielkosc plyty.');
               outtextxy(100,410,'Odlozono glowice na pozycje startowa.');
          end;
procedure uruchomienie;
          begin
               setcolor(15);
               outtextxy(100,400,'Uruchomienie silnika 33%...');
               alarm_zmiana_biegu;
               starta;
               delay(10000);
               setcolor(0);
               outtextxy(100,400,'Uruchomienie silnika 33%...');
               setcolor(15);
               outtextxy(100,400,'Uruchomienie silnika 67%...');
               alarm_zmiana_biegu;
               startb;
               delay(10000);
               setcolor(0);
               outtextxy(100,400,'Uruchomienie silnika 67%...');
               setcolor(15);
               outtextxy(100,400,'Uruchomienie silnika 100%...');
               alarm_zmiana_biegu;
               startc;
               delay(10000);
               setcolor(0);
               outtextxy(100,400,'Uruchomienie silnika 100%...');
               setcolor(15);
               outtextxy(100,400,'Silnik uruchomiony.');
               alarm_start;
               delay(8000);
               setcolor(0);
               outtextxy(100,400,'Silnik uruchomiony.');
          end;

procedure dookola_zgodnie_z_zegarem;
          begin
               wymaz_wspolrzedne;
               setcolor(2);
               outtextxy(100,400,'Program: Dookola zgodnie z zegarem...');
               outtextxy(100,410,'Aktualny bieg: Gora w prawo...');
               alarm_zmiana_biegu;
               prawo;
               repeat
                     wspolrzedne;
                     putpixel((x+10),(y+10),2);
                     x:=x+1;
                     delay(1000);
                     if keypressed then
                        if readkey='d' then czujnik:='d';
                     wymaz_wspolrzedne;
               until czujnik='d';
               stop;
               setcolor(0);
               outtextxy(100,410,'Aktualny bieg: Gora w prawo...');
               setcolor(2);
               outtextxy(100,410,'Aktualny bieg: Prawa strona w dol...');
               alarm_zmiana_biegu;
               dol;
               repeat
                     wspolrzedne;
                     putpixel((x+10),(y+10),2);
                     y:=y+1;
                     delay(1000);
                     if keypressed then
                        if readkey='s' then czujnik:='s';
                     wymaz_wspolrzedne;
               until czujnik='s';
               stop;
               setcolor(0);
               outtextxy(100,410,'Aktualny bieg: Prawa strona w dol...');
               setcolor(2);
               outtextxy(100,410,'Aktualny bieg: Dol w lewo...');
               alarm_zmiana_biegu;
               lewo;
               repeat
                     wspolrzedne;
                     putpixel((x+10),(y+10),2);
                     x:=x-1;
                     delay(1000);
                     if keypressed then
                        if readkey='a' then czujnik:='a';
                     wymaz_wspolrzedne;
               until czujnik='a';
               stop;
               setcolor(0);
               outtextxy(100,410,'Aktualny bieg: Dol w lewo...');
               setcolor(2);
               outtextxy(100,410,'Aktualny bieg: Lewa strona w gore...');
               alarm_zmiana_biegu;
               gora;
               repeat
                     wspolrzedne;
                     putpixel((x+10),(y+10),2);
                     y:=y-1;
                     delay(1000);
                     if keypressed then
                        if readkey='w' then czujnik:='w';
                     wymaz_wspolrzedne;
               until czujnik='w';
               stop;
               setcolor(0);
               outtextxy(100,410,'Aktualny bieg: Lewa strona w gore...');
               setcolor(0);
               outtextxy(100,400,'Program: Dookola zgodnie z zegarem...');
          end;

procedure dookola_przeciwnie_do_zegara;
          begin
               wymaz_wspolrzedne;
               setcolor(3);
               outtextxy(100,400,'Program: Dookola przeciwnie do zegara...');
               outtextxy(100,410,'Aktualny bieg: Lewa strona w dol...');
               alarm_zmiana_biegu;
               dol;
               repeat
                     wspolrzedne;
                     putpixel((x+10),(y+10),3);
                     y:=y+1;
                     delay(1000);
                     if keypressed then
                        if readkey='s' then czujnik:='s';
                     wymaz_wspolrzedne;
               until czujnik='s';
               stop;
               setcolor(0);
               outtextxy(100,410,'Aktualny bieg: Lewa strona w dol...');
               setcolor(3);
               outtextxy(100,410,'Aktualny bieg: Dol w prawo...');
               alarm_zmiana_biegu;
               prawo;
               repeat
                     wspolrzedne;
                     putpixel((x+10),(y+10),3);
                     x:=x+1;
                     delay(1000);
                     if keypressed then
                        if readkey='d' then czujnik:='d';
                     wymaz_wspolrzedne;
               until czujnik='d';
               stop;
               setcolor(0);
               outtextxy(100,410,'Aktualny bieg: Dol w prawo...');
               setcolor(3);
               outtextxy(100,410,'Aktualny bieg: Prawa strona w gore...');
               alarm_zmiana_biegu;
               gora;
               repeat
                     wspolrzedne;
                     putpixel((x+10),(y+10),3);
                     y:=y-1;
                     delay(1000);
                     if keypressed then
                        if readkey='w' then czujnik:='w';
                     wymaz_wspolrzedne;
               until czujnik='w';
               stop;
               setcolor(0);
               outtextxy(100,410,'Aktualny bieg: Prawa strona w gore...');
               setcolor(3);
               outtextxy(100,410,'Aktualny bieg: Gora w lewo...');
               alarm_zmiana_biegu;
               lewo;
               repeat
                     wspolrzedne;
                     putpixel((x+10),(y+10),3);
                     x:=x-1;
                     delay(1000);
                     if keypressed then
                        if readkey='a' then czujnik:='a';
                     wymaz_wspolrzedne;
               until czujnik='a';
               stop;
               setcolor(0);
               outtextxy(100,410,'Aktualny bieg: Gora w lewo...');
               setcolor(0);
               outtextxy(100,400,'Program: Dookola przeciwnie do zegara...');
          end;

{procedure zygzak;
}

procedure wezyk_wzdluzny;
          begin
               czujnik:='n';
               wymaz_wspolrzedne;
               setcolor(5);
               outtextxy(100,400,'Program: Wezyk wzdluzny...');
               repeat
               setcolor(5);
               outtextxy(100,410,'Aktualny bieg: W prawo...');
               alarm_zmiana_biegu;
               prawo;
               repeat
                     wspolrzedne;
                     putpixel((x+10),(y+10),5);
                     x:=x+1;
                     delay(1000);
                     if keypressed then
                        if readkey='d' then czujnik:='d';
                     wymaz_wspolrzedne;
               until czujnik='d';
               stop;
               setcolor(0);
               outtextxy(100,410,'Aktualny bieg: W prawo...');
               setcolor(5);
               outtextxy(100,410,'Aktualny bieg: W dol...');
               alarm_zmiana_biegu;
               dol;
               for licznik:=1 to timex do
                   begin
                        wspolrzedne;
                        putpixel((x+10),(y+10),5);
                        y:=y+1;
                        delay(1000);
                        if keypressed then
                           if readkey='s' then
                              begin
                                   czujnik:='s';
                                   licznik:=timex;
                              end;
                        wymaz_wspolrzedne;
                   end;
               stop;
               setcolor(0);
               outtextxy(100,410,'Aktualny bieg: W dol...');
               if czujnik<>'s' then
                  begin
                       setcolor(5);
                       outtextxy(100,410,'Aktualny bieg: W lewo...');
                       alarm_zmiana_biegu;
                       lewo;
                       repeat
                             wspolrzedne;
                             putpixel((x+10),(y+10),5);
                             x:=x-1;
                             delay(1000);
                             if keypressed then
                                if readkey='a' then czujnik:='a';
                             wymaz_wspolrzedne;
                       until czujnik='a';
                       stop;
                       setcolor(0);
                       outtextxy(100,410,'Aktualny bieg: W lewo...');
                       setcolor(5);
                       outtextxy(100,410,'Aktualny bieg: W dol...');
                       alarm_zmiana_biegu;
                       dol;
                       for licznik:=1 to timex do
                           begin
                           wspolrzedne;
                           putpixel((x+10),(y+10),5);
                           y:=y+1;
                           delay(1000);
                           if keypressed then
                              if readkey='s' then
                                 begin
                                      czujnik:='s';
                                      licznik:=timex;
                                 end;
                              wymaz_wspolrzedne;
                       end;
                       stop;
                       setcolor(0);
                       outtextxy(100,410,'Aktualny bieg: W dol...');
                  end;
               until czujnik='s';
               setcolor(0);
               outtextxy(100,400,'Program: Wezyk wzdluzny...');
          end;

procedure wezyk_poprzeczny;
          begin
               czujnik:='n';
               wymaz_wspolrzedne;
               setcolor(6);
               outtextxy(100,400,'Program: Wezyk poprzeczny...');
               repeat
               setcolor(6);
               outtextxy(100,410,'Aktualny bieg: W dol...');
               alarm_zmiana_biegu;
               dol;
               repeat
                     wspolrzedne;
                     putpixel((x+10),(y+10),6);
                     y:=y+1;
                     delay(1000);
                     if keypressed then
                        if readkey='s' then czujnik:='s';
                     wymaz_wspolrzedne;
               until czujnik='s';
               stop;
               setcolor(0);
               outtextxy(100,410,'Aktualny bieg: W dol...');
               setcolor(6);
               outtextxy(100,410,'Aktualny bieg: W prawo...');
               alarm_zmiana_biegu;
               prawo;
               for licznik:=1 to timey do
                   begin
                        wspolrzedne;
                        putpixel((x+10),(y+10),6);
                        x:=x+1;
                        delay(1000);
                        if keypressed then
                           if readkey='d' then
                              begin
                                   czujnik:='d';
                                   licznik:=timey;
                              end;
                        wymaz_wspolrzedne;
                   end;
               stop;
               setcolor(0);
               outtextxy(100,410,'Aktualny bieg: W prawo...');
               if czujnik<>'d' then
                  begin
                       setcolor(6);
                       outtextxy(100,410,'Aktualny bieg: W gore...');
                       alarm_zmiana_biegu;
                       gora;
                       repeat
                             wspolrzedne;
                             putpixel((x+10),(y+10),6);
                             y:=y-1;
                             delay(1000);
                             if keypressed then
                                if readkey='w' then czujnik:='w';
                             wymaz_wspolrzedne;
                       until czujnik='w';
                       stop;
                       setcolor(0);
                       outtextxy(100,410,'Aktualny bieg: W gore...');
                       setcolor(6);
                       outtextxy(100,410,'Aktualny bieg: W prawo...');
                       alarm_zmiana_biegu;
                       prawo;
                       for licznik:=1 to timey do
                           begin
                           wspolrzedne;
                           putpixel((x+10),(y+10),6);
                           x:=x+1;
                           delay(1000);
                           if keypressed then
                              if readkey='d' then
                                 begin
                                      czujnik:='d';
                                      licznik:=timey;
                                 end;
                              wymaz_wspolrzedne;
                       end;
                       stop;
                       setcolor(0);
                       outtextxy(100,410,'Aktualny bieg: W prawo...');
                  end;
               until czujnik='d';
               setcolor(0);
               outtextxy(100,400,'Program: Wezyk poprzeczny...');
          end;

procedure alarm_zmiana;
          begin
               for licznik:=1 to 3 do
               begin
                        dzwonek;
                        sound(700);
                        setcolor(1);
                        outtextxy(100,400,'Ladowanie programu...');
                        delay(500);
                        nosound;
                        stop;
                        setcolor(0);
                        outtextxy(100,400,'Ladowanie programu...');
                        delay(500);
               end;
          end;

procedure alarm_awaria;
          begin
               silnikstop;
               {glowica do gory}
               kolor:=4;
               licznik:=500;
               repeat
                     setcolor(kolor);
                     outtextxy(300,200,'ALARM!!! AWARIA!!!');
                     outtextxy(300,230,'ZATRZYMUJE DZIALANIE SZLIFIERKI!!!');
                     if (licznik mod 500)=0 then
                        if kolor=4 then kolor:=0
                                        else kolor:=4;
                     licznik:=licznik+10;
                     sound(licznik);
                     dzwonek;
                     if licznik=3000 then licznik:=500;
               until keypressed;
               nosound;
               stop;
          end;

procedure wylacz;
          begin
               setcolor(15);
               outtextxy(100,400,'Wylaczanie automatu...');
               outtextxy(100,410,'Wylaczanie silnika...');
               alarm_zmiana_biegu;
               silnikstop;
               setcolor(0);
               outtextxy(100,410,'Wylaczanie silnika...');
               setcolor(15);
               outtextxy(100,410,'Odkladanie glowicy na pozycje startowa...');
               podnies;
               repeat
                     wspolrzedne;
                     z:=z-1;
                     delay(1000);
                     if keypressed then
                        if readkey='q' then czujnik:='q';
                     wymaz_wspolrzedne;
               until czujnik='q';
               stop;
               alarm_zmiana_biegu;
               repeat
                     wspolrzedne;
                     x:=x-1;
                     delay(1000);
                     if keypressed then
                        if readkey='a' then czujnik:='a';
                     wymaz_wspolrzedne;
               until czujnik='a';
               stop;
               alarm_zmiana_biegu;
               gora;
               repeat
                     wspolrzedne;
                     y:=y-1;
                     delay(1000);
                     if keypressed then
                        if readkey='w' then czujnik:='w';
                     wymaz_wspolrzedne;
               until czujnik='w';
               stop;
               setcolor(15);
               outtextxy(100,400,'Wylaczanie automatu...');
          end;

procedure ust_glowicy;
          begin
               setcolor(7);
               outtextxy(100,400,'Ustawianie glowicy...');
               outtextxy(100,410,'Ustaw glowice na plycie i nacisnij [u].');
               repeat
                     czujnik:=readkey;
               until czujnik='u';
               setcolor(0);
               outtextxy(100,410,'Ustaw glowice na plycie i nacisnij [u].');
               setcolor(7);
               outtextxy(100,410,'Aktualny bieg: Glowica w gore...');
               alarm_zmiana_biegu;
               podnies;
               repeat
                     wspolrzedne;
                     z:=z+1;
                     delay(1000);
                     if keypressed then
                        if readkey='q' then czujnik:='q';
                     wymaz_wspolrzedne;
               until czujnik='q';
               stop;
               wspolrzedne;
               setcolor(red);
               maxz:=z;
               str(maxz,wmz);
               outtextxy(442,450,'Granica glowicy: 0 - ');
               outtextxy(610,450,wmz);
               setcolor(0);
               outtextxy(100,410,'Aktualny bieg: Glowica w gore...');
               setcolor(7);
               outtextxy(100,410,'Aktualny bieg: Glowica w dol...');
               alarm_zmiana_biegu;
               wymaz_wspolrzedne;
               z:=0;
               opusc;
               for licznik:=1 to maxz do
                   begin
                        wspolrzedne;
                        z:=z+1;
                        delay(1000);
                        wymaz_wspolrzedne;
                   end;
               stop;
               setcolor(0);
               outtextxy(100,400,'Ustawianie glowicy...');
               outtextxy(100,410,'Aktualny bieg: Glowica w dol...');
          end;

procedure reset;
          begin
               setcolor(8);
               outtextxy(100,400,'Pozycjonowanie do zmiany programu...');
               outtextxy(100,410,'Aktualny bieg: Glowica w gore...');
               alarm_zmiana_biegu;
               podnies;
               for licznik:=maxz downto maxz-3 do
                   begin
                        wspolrzedne;
                        z:=z-1;
                        delay(1000);
                        wymaz_wspolrzedne;
                   end;
               stop;
               setcolor(0);
               outtextxy(100,410,'Aktualny bieg: Glowica w gore...');
               setcolor(8);
               outtextxy(100,410,'Aktualny bieg: W lewo...');
               alarm_zmiana_biegu;
               lewo;
               repeat
                     wspolrzedne;
                     x:=x-1;
                     delay(1000);
                     if keypressed then
                        if readkey='a' then czujnik:='a';
                     wymaz_wspolrzedne;
               until czujnik='a';
               stop;
               setcolor(0);
               outtextxy(100,410,'Aktualny bieg: W lewo...');
               setcolor(8);
               outtextxy(100,410,'Aktualny bieg: Do gory...');
               alarm_zmiana_biegu;
               gora;
               repeat
                     wspolrzedne;
                     y:=y-1;
                     delay(1000);
                     if keypressed then
                        if readkey='w' then czujnik:='w';
                     wymaz_wspolrzedne;
               until czujnik='w';
               stop;
               setcolor(0);
               outtextxy(100,410,'Aktualny bieg: Do gory...');
               setcolor(8);
               outtextxy(100,410,'Aktualny bieg: Glowica w dol...');
               alarm_zmiana_biegu;
               opusc;
               for licznik:=0 to 3 do
                   begin
                        wspolrzedne;
                        z:=z+1;
                        delay(1000);
                        wymaz_wspolrzedne;
                   end;
               stop;
               setcolor(0);
               outtextxy(100,400,'Pozycjonowanie do zmiany programu...');
               outtextxy(100,410,'Aktualny bieg: Glowica w dol...');
          end;




begin
     repeat
     koniec:='n';
     ustawienie;
     x:=0;
     y:=0;
     z:=0;
     DetectGraph(ster,tryb);
     InitGraph(ster,tryb,'E:\Bp\Bgi');
     setcolor(15);
     outtextxy(100,430,'Wspolrzedne X=');
     outtextxy(100,440,'Wspolrzedne Y=');
     outtextxy(100,450,'Wspolrzedne Z=');
     rozpoznanie;
     ust_glowicy;
     wymaz_wspolrzedne;
     x:=0;
     y:=0;
     wspolrzedne;
     uruchomienie;
     for licznikprog:=1 to liczprog do
         begin
              alarm_zmiana;
              czujnik:='n';
              reset;
              czujnik:='n';
              case ustawprogram[licznikprog] of
                   1 : dookola_zgodnie_z_zegarem;
                   2 : dookola_przeciwnie_do_zegara;
                   3 : wezyk_wzdluzny;
                   4 : wezyk_poprzeczny;
                   {5 : zygzak;}
              end;
         end;
     wylacz;
     CloseGraph;
     writeln('Zakonczono szlifowanie.');
     writeln('Czy chcesz zakonczyc program? [t/n]');
     koniec:=readkey;
     until koniec='t';
end.