
program SymbolGame;

uses
sysutils,crt,windows;

var
hr, min, sec, ms: Word;

m1d,m1e,m1t, st1d,st1e,st1t, ps1d,ps1e,ps1t, fn1d,fn1e,fn1t,
m2d,m2e,m2t, st2d,st2e,st2t, ps2d,ps2e,ps2t, fn2d,fn2e,fn2t,
m3d,m3e,m3t, st3d,st3e,st3t, ps3d,ps3e,ps3t, fn3d,fn3e,fn3t, skd,ske,skt,
m4d,m4e,m4t, st4d,st4e,st4t, ps4d,ps4e,ps4t, fn4d,fn4e,fn4t, cs1d,cs1e,cs1t,
m5d,m5e,m5t, st5d,st5e,st5t, sts1d,sts1e,sts1t, sts2d,sts2e,sts2t, cs2d,cs2e,cs2t
:string;

Rect: TSmallRect;
Coord: TCoord;

c:integer; {color}

y_temp,x_temp,x_rows,y_rows,ratio,code_length,sure:integer;

codepreview:char;

status:integer;
{
 status=0 pasif hal
 status=1 main menu donme istegi
 status=2 1. oyunu kazanma durumu
 status=3 2. oynunu da kazanma durumu /skor tablosu direk gecis
}

x,y,i,j,k,asciirand:integer;

timebegin,timecount:real;

zeroCount,imax,jmax,dp_ort,zeroRatio,ratioCount_opt,warn:integer;

zeroCountFix,ratio_opt:real;

colorpreview:char;

jenerik,jenerik2:integer;
{
olasi karisikliklari onlemek icin her menu icin farklı bir degisken
atadim boylece ibrenin nerede kaldigida saklanmis oluyor

  char alınan key aynı olabilirdi
  ancak okuma kolaylıgı ve anlasilabilirlik adina farkli degiskenler verdim
}





keypress:char; keyingame:integer;

presspause,pause,        pressmenu,menu,           presslang,lang,

presssetting,setting,     pressascii,asciiarrow:integer;

x_zeroCount:array[1..100] of integer;{harita uretimi için elzem}

Dpcoded:array[1..100,1..200] of char;   {cerceve ve kapali bloklar}
Dpencoded:array[1..100,1..200] of integer; {sayilar}

ascii:array[1..20] of integer; {kod}

playername:array[1..10] of string;   {skor ekrani kullanici isimleri}
playerscore:array[1..10] of real;    {skor ekrani kullanici skorlari}

scoretemp:real;
nametemp:string;

header:array[1..10] of string;  {oyun basligi}

{burada oyun ici ekranlarda guzel bir gorunum yakalama amaciyla olusturulmus
prosedurler var elbette daha iyileri yapilabilrdi ancak alttakilerde biraz
is görebiliyor}

procedure sc(); {renkle imlec(acik mavi)}
begin
textcolor(11);
end;
{_______________________________________}
procedure scb();{renk beyaz}
begin
textcolor(15);
end;

{_________________________ortali yazdirma ugruna adanmis prosedürler______________________________}

procedure bosluk(var tane:integer);
var
foricin:integer;
begin
for foricin:=1 to tane do
  write(' ');
end;
{_______________________________________}
procedure i_ort(var tane:integer);
var
foricin,temp:integer;
begin
temp:=tane;
temp:=40-temp div 2;
for foricin:=1 to temp do
  write(' ');
end;

procedure s_ort(var str:string);
var
foricin:integer;
nicin:integer;
begin
nicin:= 40-(length(str) DIV 2);
for foricin:=1 to nicin do
write(' ');
end;
{_______________________________________}
procedure boslukstring(var str:string);
var
foricin:integer;
nicin:integer;
begin
nicin:=length(str);
for foricin:=1 to (25-nicin) do
write(' ');
end;
{_______________________________________}
procedure tirestring(var str:string);
var
foricin:integer;
nicin:integer;
begin
nicin:=length(str);
for foricin:=1 to (40-nicin) do
write('-');
end;
{_______________________________________}
procedure bdef();
begin
write('                ');
end;
{_______________________________________}
procedure altbar();
begin
   writeln;
   writeln('                                    __________');
   writeln('                                ===(SymbolGame)===');
   writeln();
end;
{_______________________________________}
begin

{ekranin sabit kalabilmesi icin bulabildigim bir kod windows komut istemi pence kontrolunu sagliyor}
Rect.Left := 0;
  Rect.Top := 0;
  Rect.Right := 80;                                                       // 80 birim en
  Rect.Bottom := 40;                                                 // 40 birim boy
  Coord.X := Rect.Right + 1 - Rect.Left;
  Coord.y := Rect.Bottom + 1 - Rect.Top;
  SetConsoleScreenBufferSize(GetStdHandle(STD_OUTPUT_HANDLE), Coord);
  SetConsoleWindowInfo(GetStdHandle(STD_OUTPUT_HANDLE), True, Rect);


{varsayilan seyler---------------------------------------------------------}
 header[1]:=' ____  _  _  _  _  ____   __   __       ___   __   _  _  ____ ';
 header[2]:='/ ___)( \/ )( \/ )(  _ \ /  \ (  )     / __) / _\ ( \/ )(  __)';
 header[3]:='\___ \ )  / / \/ \ ) _ ((  O )/ (_/\  ( (_ \/    \/ \/ \ ) _) ';
 header[4]:='(____/(__/  \_)(_/(____/ \__/ \____/   \___/\_/\_/\_)(_/(____)';

colorpreview:=#219;

m1t:='Oyna';m1e:='Play';
m2t:='Ayarlar';m2e:='Settings';
m3t:='Jenerik';m3e:='Credits';
m4t:='Cikis';m4e:='Exit';
m5t:='skorlar';m5e:='Scores';

skt:='skor';ske:='score';

st1t:='tas orani';st1e:='stone ratio';
st2t:='satir sayisi';st2e:='line number';
st3t:='sutun sayisi';st3e:='calumn number';
st4t:='harita rengi';st4e:='board color';
st5t:='kod uzunlugu';st5e:='Ascii  length';

ps1e:='  PAUSED';ps1t:='  DURDURULDU';
ps2e:='Time Passed';ps2t:='Gecen Zaman';
ps3e:='Main Menu';ps3t:='Ana Menu';
ps4e:='Return';ps4t:='Geri don';

sts1e:='congratulations you went to stage 2';sts1t:='Tebrikler 2. asamaya gectiniz';
sts2e:='press any key to continue';sts2t:='devam etmek icin herhangi bir tusa basin';

fn1e:='press space to reveal code for 1 sec';fn1t:='kodu 1 saniyeligine gormek icin bosluk tusuna basin';
fn2e:='cost of +10 secs';fn2t:='+10 saniye ekler';
fn3e:='Predict The Code:';fn3t:='Kodu Tahmin Edin';
fn4e:='wrong codes add +5 sec';fn4t:='yalnlis girisler 5 sn ekler';

cs1e:='YOU HAVE BEAT THE GAME';cs1t:='OYUNU KAZANDINIZ';
cs2e:='Enter Your Name:';cs2t:='Adinizi Girin:';

for i:=1 to 10 do
begin
playername[i]:='Player'; 

end;

for i:=1 to 10 do
begin
playerscore[i]:=1.1736111111063259E-0005*85207; {Sistem saati bazinda yaklasik 24.59.59}
end;








{def degerler-----------------------------------------------------------------------------------------}

x_rows:=5; {icerde islenecek  daha}
y_rows:=10;   {icerde islenecek  daha}
ratio:=20; {yüzdeli}
code_length:=5;

sure:=5;{kod ilk gosterim suresi}

c:=15; {color def}

lang:=0;  {lang def}

warn:=0;

randomize();

repeat
begin

   clrscr;

   writeln();
   writeln();

   if lang=0 then begin sc(); write('>'); end; writeln('Turkce'); scb();

   if lang=1 then begin sc(); write('>'); end; writeln('English'); scb();
  
  keypress:=readkey;
  presslang:= ord(keypress);
  if presslang=0 then
          begin keypress := readkey;
		  presslang:= ord(keypress);  
                if presslang=72 then lang:=lang+1
                else
                if presslang=80 then lang:=lang-1;
         lang:=abs(lang mod 2);
          end;
end;
until (presslang=13) OR (presslang=27);

    if presslang=27 then halt
    else
    begin {dil deger atama------------------------------------------}
	if lang=0 then 
	   begin 
            m1d:=m1t;
            m2d:=m2t; 
            m3d:=m3t; 
            m4d:=m4t;
            m5d:=m5t;
            skd:=skt;
            st1d:=st1t;
           st2d:=st2t;
           st3d:=st3t;
           st4d:=st4t;
           st5d:=st5t;
           ps1d:=ps1t;
           ps2d:=ps2t;
           ps3d:=ps3t;
           ps4d:=ps4t;
           sts1d:=sts1t;
           sts2d:=sts2t;
           fn1d:=fn1t;
           fn2d:=fn2t;
           fn3d:=fn3t;
           fn4d:=fn4t;
           cs1d:=cs1t;
           cs2d:=cs2t;
	   end
	   else
	   begin
           m1d:=m1e;
           m2d:=m2e; 
           m3d:=m3e;
           m4d:=m4e;
           m5d:=m5e;
           skd:=ske;
           st1d:=st1e;
           st2d:=st2e;
           st3d:=st3e;
           st4d:=st4e;
           st5d:=st5e;
           ps1d:=ps1e;
           ps2d:=ps2e;
           ps3d:=ps3e;
           ps4d:=ps4e;
           sts1d:=sts1e;
           sts2d:=sts2e;
           fn1d:=fn1e;
           fn2d:=fn2e;
           fn3d:=fn3e;
           fn4d:=fn4e;
           cs1d:=cs1e;
           cs2d:=cs2e;
	   end;
    end;
    	
	{menu giris-----------------------------------------------------MENU-------------------}
menu:=0;
repeat { son geri donus icin rep}
begin	
    repeat{ayar jenerik vs icin rep //ara cikis}
    begin

       repeat{menu display}
       begin
 clrscr;
 textcolor(c);
 for i:=1 to 4 do
 begin
 s_ort(header[i]);writeln(header[i]);
 end;
 scb();
 writeln();
 writeln();
 writeln();
 writeln();

s_ort(m1d); if menu=0 then sc();writeln(m1d); scb();
writeln();
s_ort(m2d); if menu=1 then sc();writeln(m2d);  scb();
writeln();
s_ort(m3d); if menu=2 then sc();writeln(m3d);  scb();
writeln();
s_ort(m5d); if menu=3 then sc();writeln(m5d);  scb();
writeln();
s_ort(m4d); if menu=4 then sc();writeln(m4d);  scb();

	keypress:=readkey;
	pressmenu:=ord(keypress);
	if pressmenu = 0 then
	   begin
	   keypress:=readkey;
	   pressmenu:=ord(keypress);
	   if pressmenu=80 then menu:=menu+1
	   else
	     if pressmenu=72 then menu:=menu-1;
		end;
        if menu < 0 then menu:=4;
        if menu > 4 then menu:=0;

    end
    until(pressmenu=13) OR (pressmenu=27);
    if  pressmenu = 27 then halt;
	if menu=1 then{ayarlar giris---------------------------------------------}
	   begin
       setting:=0;
	     repeat
		 begin
		 clrscr;
s_ort(m2d); textcolor(white); writeln(m2d); scb();
s_ort(m2d);writeln('_______');
   writeln();
   writeln();
	;
bdef(); boslukstring(st1d);if setting=0 then sc();write(st1d);  scb();
                   if setting=0 then sc();      write(':         <');
    if warn=1 then textcolor(12);
    write(ratio);
    scb();
                   if setting=0 then sc();
          writeln('>'); scb();
			 writeln();
bdef(); boslukstring(st2d);    if setting=1 then sc();write(st2d);  scb();
                       if setting=1 then sc(); write(':         <');
    write(x_rows);
          writeln('>'); scb();
             writeln();
bdef(); boslukstring(st3d);if setting=2 then sc();write(st3d);  scb();
                   if setting=2 then sc();     write(':         <');
    write(y_rows);
          writeln('>'); scb();
             writeln();
bdef(); boslukstring(st4d);if setting=3 then sc();write(st4d);  scb();
                   if setting=3 then sc();write(':         <');
    textcolor(c) ;write(colorpreview);;write(colorpreview); scb(); if setting=3 then sc();
          writeln('>');scb();
             writeln();

bdef(); boslukstring(st3d);if setting=4 then sc();write(st5d);  scb();
                   if setting=4 then sc();     write(':         <');
    write(code_length);
          writeln('>'); scb();

	keypress:=readkey;
	presssetting:=ord(keypress);
	if presssetting = 0 then
	   begin
	   keypress:=readkey;
	   presssetting:=ord(keypress);
	   if presssetting=80 then setting:=setting+1
	   else
	     if presssetting=72 then setting:=setting-1
		else
		begin
        if presssetting=77 then{sag++++++++++++++++++++++++++++++++++++}
		begin
		if setting=0 then 
  begin
        ratio:=ratio+10;
        if ratio>100 then ratio:=10;
  end
		else 
		if setting=1 then 
  begin
	    x_rows:=x_rows+1;
        if x_rows >18 then x_rows:=1;
  end
		else
		if setting=2 then
  begin
		y_rows:=y_rows+1;
        if y_rows > 36 then y_rows:=1;
  end
		else
		if setting=3 then
  begin
		c:=c+1;
        if c>15 then c:=2;
        if c=11 then c:=12;
  end
        else
        if setting=4 then
  begin
        code_length := code_length+1;
        if code_length >10 then code_length :=1;
  end;
        end;
		if presssetting=75 then{sol-----------------------------------}
		begin
		if setting=0 then 
  begin
        ratio:=ratio-10;
        if ratio <10 then ratio:=100;
  end
		else 
		if setting=1 then
  begin
	    x_rows:=x_rows-1;
        if x_rows <1 then x_rows:=18;
  end
		else
		if setting=2 then
  begin
		y_rows:=y_rows-1;
        if y_rows <1 then y_rows:=36;
  end
		else
		if setting=3 then
  begin
		c:=c-1;
		if c <3 then c:=15;
        if c=11 then c:=10;
  end
        else
        if setting=4 then
  begin
        code_length := code_length -1;
        if code_length <1 then code_length:=10;
  end;
		end;
  {no solution fix------------------------------------------FIX--BEGIN}
  {anlasilabilirlik acisindan kodu mantiksal olarak kisaltmadim-------}

   zeroCountFix:=y_rows/x_rows;//cozum icin satır basi 0 orani

   if (zeroCountFix)>(y_rows DIV x_rows) // tam degerler almali
   then
   ratioCount_opt:=(y_rows DIV x_rows)+1
   else
   ratioCount_opt:=(y_rows DIV x_rows);

   ratio_opt:=100*(ratioCount_opt/y_rows);//yuzdeye cevirirsek

   if(ratio < ratio_opt) then warn:=1 //-----------------------------------------------------------------
   else warn:=0;
   while (ratio < ratio_opt) do       //Ratio her zaman buyuk ya da esit
     begin                           //olmali optimal degerden ki cozum olsun
      ratio:=ratio+10;
     end;

   {no solution fix------------------------------------------FIX--END}

        end;
		
        if setting < 0 then setting:=4;
        if setting > 4 then setting:=0;
		
        end;
	    end;
		 until(presssetting=27) OR (presssetting=13) OR (presssetting=32) OR  (presssetting=8);
	   end
    else
    if menu=2 then
       begin
         for jenerik:=1 to 30 do
         begin
         clrscr;
         jenerik2:=60-jenerik;
         if jenerik>=30 then writeln();
         if jenerik>=29 then writeln();
         if jenerik>=28 then writeln();
         if jenerik>=27 then writeln();
         if jenerik>=26 then writeln();
         if jenerik>=25 then writeln();
         if jenerik>=24 then writeln();
         if jenerik>=23 then  begin bosluk(jenerik2); writeln('    END...'); end;
         if jenerik>=22 then writeln();
         if jenerik>=21 then writeln();
         if jenerik>=20 then  begin bosluk(jenerik2); writeln('Copyright © 2016');end;
         if jenerik>=19 then  begin bosluk(jenerik2); writeln('All Rights Reserved'); end;
         if jenerik>=18 then  begin bdef();bosluk(jenerik); writeln(''); end;
         if jenerik>=17 then  begin bosluk(jenerik); writeln('Manager & Director'); end;
         if jenerik>=16 then  begin bosluk(jenerik); writeln('fthelbsn'); end;
         if jenerik>=15 then  begin bosluk(jenerik); writeln(''); end;
         if jenerik>=14 then  begin bosluk(jenerik2); writeln('Chief Engineer'); end;
         if jenerik>=13 then  begin bosluk(jenerik2); writeln('fthelbsn'); end;
         if jenerik>=12 then  begin bosluk(jenerik); writeln(''); end;
         if jenerik>=11 then  begin bosluk(jenerik); writeln('Design By'); end;
         if jenerik>=10 then  begin bosluk(jenerik); writeln('fthelbsn'); end;
         if jenerik>=9 then  begin bosluk(jenerik); writeln(''); end;
         if jenerik>=8 then  begin bosluk(jenerik2); writeln('Art Director/Animator'); end;
         if jenerik>=7 then  begin bosluk(jenerik2); writeln('fthelbsn'); end;
         if jenerik>=6 then  begin bosluk(jenerik); writeln(''); end;
         if jenerik>=5 then  begin bosluk(jenerik); writeln('Main Idea:'); end;
         if jenerik>=4 then  begin bosluk(jenerik); writeln('M. Amac Guvensan'); end;
         if jenerik>=3 then  begin bosluk(jenerik); writeln(''); end;
         if jenerik>=2 then  begin bosluk(jenerik2); writeln('Thanks to writer pascal..'); end;
         if jenerik>=1 then  begin bosluk(jenerik2); writeln('Niklaus Wirth'); end;
         delay(150);

         end;

         readkey();
       end
    else
    if menu=3 then status:=3
    else
    if menu=4 then halt;
    
	end; 
	until(menu=0) OR (status=3);

if (menu=0) then
begin

{setup begin    ----------------------------------------------------------SETUP}

 clrscr();
 writeln();
 writeln();
 writeln();
 writeln();
 writeln();
 writeln('                    _____________________loading_____________________');
 writeln();

{standart setup-----------------------------------}
x:=2;
y:=2;

dp_ort:=40-y_rows;

status:=0;

imax:= 2 * x_rows + 1;
jmax:= 2 * y_rows + 1;

zeroRatio:=((ratio*y_rows) DIV 100);//bir satirda kac 0 olmalidir

 for i:=1 to imax do       //bloklar
 begin
   for j:=1 to jmax do
   begin
   dpcoded[i,j]:=#219;
   end;
 end;

 for i:=1 to imax do  //cerceve1
 begin
   for j:=1 to jmax do
   begin

   dpcoded[i,j]:=#205;

   end;
   i:=i+1;
end;


for i:=1 to imax do             //cerceve2 + kesisimler
begin
   for j:=1 to jmax do
   begin

   if dpcoded[i,j]=#205 then dpcoded[i,j]:=#206
   else                      dpcoded[i,j]:=#186;

   j:=j+1;
   end;
end;


  for j:=1 to jmax do              //kenar fix1
  begin
  dpcoded[1,j]:=#203;
  dpcoded[imax,j]:=#202;
  j:=j+1;
  end;

  for i:=1 to imax do               //kenar fix2 
  begin
  dpcoded[i,1]:=#204;
  dpcoded[i,jmax]:=#185;
  i:=i+1;
  end;

  dpcoded[1,1]:=#201;        //koseler
  dpcoded[1,jmax]:=#187;
  dpcoded[imax,1]:=#200;
  dpcoded[imax,jmax]:=#188;

  for i:=2 to imax do
  begin
  if i mod 2 = 0 then x_zeroCount[i]:=0;
  end;

  write('                    |||||||');
  delay(200);{buralarda amacsiz bir bekleyis var ancak kotu durumdaki pcleri de
  dusundugumuz vakit buralar degerlenebilir o zamana dek delay() kullandim ki
  gozle gorulebilsin ne oldugu
  }




  { harita uretmek--------------------------------------------------------------------------------------------------MAP GEN------}

   for i:=2 to imax do
   begin
      if i mod 2 =0 then
      begin
        //repeat
        zeroCount:=0 ;
          for j:=1 to jmax do
          begin
            if j mod 2 =0 then
            begin
            dpencoded[i,j]:=random(3)+1;
            //if dpencoded[i,j]=0 then
            //zeroCount:=zeroCount+1;
            end;
          end;
        //until(ratio <= ((100*zeroCount) DIV x_rows ));
      end;
   end;
                write('||||||||');
     delay(75); { <= hakkinda bir yazi var yukarda}

   for j:=2 to jmax do
   begin
     if j mod 2 = 0 then
     begin
       repeat
         x_temp:=(random(x_rows)+1)*2;
       until(x_zeroCount[x_temp]<zeroRatio);

         dpencoded[x_temp,j]:=0;
         x_zeroCount[x_temp]:=x_zeroCount[x_temp]+1;
     end;
   end;
              write('|||||||');
   delay(100);  { <= hakkinda bir yazi var yukarda}

   for i:=2 to imax do
   begin
     if i mod 2 = 0 then
     begin
       for zeroCount:=x_zeroCount[i]+1 to zeroRatio do
       begin
         repeat
         y_temp:=(random(y_rows)+1)*2;
         until(dpencoded[i,y_temp]<>0);
         dpencoded[i,y_temp]:=0;
       end;
     end;
   end;
              write('|||||||||||||||');
   delay(150);  { <= hakkinda bir yazi var yukarda}
   {map gen end----------------------------------------------------------}


  {ascii kod uretim merkezi-------------------------------------}

  for i:=1 to code_length do
     begin
     repeat
     asciirand:=random(75)+48;
     until
     ((48<=asciirand) AND (asciirand<=57))
     OR
     ((65<=asciirand) AND (asciirand<=90))
     OR
     ((97<=asciirand) AND (asciirand<=122));

     ascii[i]:=asciirand;

     end;

     write('||||||||||||');
     delay(200); { <= hakkinda bir yazi var yukarda}

 {setup end-----------------------------------------------------}


 {zamanin baslangici--------------------------------------------}

 timebegin:=time();
 timecount:=0;

{display & gameplay below}

 repeat{cheat olayi icin}
 begin
  repeat   {surekli key icin rep}
  begin

   textcolor(c);
   clrscr;
{display-------------------------------------------------block--begin}
 for i:=1 to imax do
 begin
   writeln();
   bosluk(dp_ort);
   for j:=1 to jmax do
   begin
   if (x = i) AND (y = j)

   then begin sc(); write(dpcoded[i,j]); textcolor(c) end

   else write(dpcoded[i,j]);
   end;
 end;
 altbar();
{display--------------------------------------------------block--end}
  


 keypress:=readkey;
   keyingame:=ord(keypress);
   if keyingame=0 then
       begin
       keypress:=readkey;
       keyingame:=ord(keypress);
       if keyingame=72 then
       begin
       x:=x-2;
       if x<2 then x:=2*x_rows;
       end
       else
       if keyingame=80 then
       begin
       {80 ayni zamanda P nin ascii kodudur,girdinin sadece P tuşuna basildiginda 80 olmasi gerekir}
       keyingame:=0;
       x:=x+2;
       if x>(2*x_rows) then x:=2;
       end;
       end;

   end;
   until(keyingame=27)
   OR (keyingame=13)
   OR (keyingame=67)
   OR (keyingame=99)
   OR (keyingame=112)
   OR (keyingame=80)
   OR (keyingame=77)
   OR (keyingame=8)
   OR (keyingame=32);

   if(keyingame=13) OR (keyingame=77) OR (keyingame=32) then
   begin

     clrscr;      {rakam acma ekrani}
{display-------------------------------------------------code--begin}
 for i:=1 to imax do
 begin
   writeln();
   bosluk(dp_ort);
     for j:=1 to jmax do
     begin
       if (x = i) AND (y = j)

       then begin sc(); write(dpencoded[i,j]); textcolor(c) end

       else write(dpcoded[i,j]);
     end;
end;
altbar();
   delay(200);  {ms bazinda acik kalma suresi}

{ilerleme gerileme mantigi----------------------------------------------------}
   if dpencoded[x,y]=0 then 
   begin
   dpcoded[x,y]:=#176;
   y:=y+2;
   if y>2*y_rows then status:=2  // 2. asamaya gecme durumu
   end
   else
   y:=y-2*(dpencoded[x,y]);      //gerileyis

   if y<2 then y:=2;  {ekrandan da atmamali olmali}

   end;
{===================================================================cheat Dp}
    if (keyingame=67)
    OR (keyingame=99)
    then
    begin
{cheat display------------------------------------------------cheat--begin}
    clrscr;
   textcolor(15);
for i:=1 to imax do
begin
writeln();
bosluk(dp_ort);
   for j:=1 to jmax do
   begin
   if (i mod 2 = 0) AND (j mod 2 = 0)
   then
   begin
   if (dpencoded[i,j]=0) then textcolor(10)
   else
     if (dpencoded[i,j]=1) then textcolor(13)
     else
       if (dpencoded[i,j]=2) then textcolor(14)
       else
         if (dpencoded[i,j]=3) then textcolor(12);

   if (x=i) AND (y=j) then sc();
      write(dpencoded[i,j]); textcolor(15); end
      else   write(dpcoded[i,j]);
   end;
end;
altbar();
{cheat display------------------------------------------------cheat--end}
   keypress:=readkey();
   keyingame:=ord(keypress);
   if keyingame=0 then readkey;
   end
   else
   if(keyingame=27)   {pause olayı---------------------------------PAUSE BEGIN}
   OR (keyingame=112)
   OR (keyingame=80)
   OR (keyingame=8)
   then
   begin
   timecount:=timecount+(time()-timebegin); {gecen sureyi kaydetme}
   pause:=0;
     repeat
   scb();
   clrscr;
   writeln();
   s_ort(ps1d);writeln(ps1d);
   writeln();
   s_ort(ps2d);writeln(ps2d);
   writeln();

   s_ort(ps2d); write('   ');
   DecodeTime(timecount,hr, min, sec, ms);
    write (format('%d:',[hr]));
    write (format('%d:',[min]));
    write (format('%d',[sec]));
                  writeln();
                  writeln();
                  writeln();
                  writeln();
 s_ort(ps4d); if pause = 0 then begin sc(); write('>');end; writeln(ps4d); scb();
    writeln();
 s_ort(ps3d); if pause = 1 then begin sc(); write('>');end; writeln(ps3d); scb();
    writeln();
 s_ort(m4d); if pause = 2 then begin sc(); write('>');end; writeln(m4d); scb();

    keypress:=readkey;
	presspause:=ord(keypress);
	if presspause = 0 then
	   begin
	   keypress:=readkey;
	   presspause:=ord(keypress);
	   if presspause=80 then pause:=pause+1
	   else
	     if presspause=72 then pause:=pause-1;
		end;
        if pause < 0 then pause:=2;
        if pause > 2 then pause:=0;

    textcolor(c);
    until( presspause=13) OR ( presspause=27) OR ( presspause=8);

    timebegin:=time();     {pause end olayi-------------------------------END PAUSE}

    if  presspause=13 then
      begin
      if pause=2 then halt
      else
      if pause=1 then status:=1;
      end;

    end;

    end;
    until(status=1) OR (status=2);  {display cikis}
    {status 1 kosulu menu donme istegidir...}

   clrscr;

   {stage 2---------------------------------------------------}

   if (status=2) then

   begin

   timecount:=timecount+(time()-timebegin);{zaman gecen}
   scb();
   writeln();
   writeln();
   writeln();
   writeln();
   writeln();
   writeln();

   s_ort(sts1d);writeln(sts1d);
   writeln();
   writeln();

   s_ort(ps2d);writeln(ps2d);

   s_ort(ps2d); write('   ');
   DecodeTime(timecount,hr, min, sec, ms);
    write (format('%d:',[hr]));
    write (format('%d:',[min]));
    write (format('%d',[sec]));
                  writeln();
                  writeln();

   s_ort(sts2d);writeln(sts2d);

   readkey();

   clrscr;

for j:=1 to sure do
begin
    writeln();
    writeln();
    writeln();
    writeln();
    writeln();
    i_ort(code_length);
      for i:=1 to code_length do
      begin
      codepreview:=chr(ascii[i]);
      write(codepreview);
      end;
    writeln();
    writeln();
    writeln();
    s_ort(m1d);
    writeln(sure-j);
    delay(800);
    clrscr;

end;
   asciiarrow:=1;
   timebegin:=time();{sure baslıyor *tekrar }
   scb();
   repeat
   clrscr;
   writeln();
   writeln();
   writeln();
s_ort(fn3d); writeln(fn3d);
   writeln();
   writeln();
   writeln();
   writeln();
   i_ort(code_length);
   for i:=1 to code_length do
     begin
     if asciiarrow <i then
     write(colorpreview)
       else
    if asciiarrow = i then
       begin
       sc();
       write(colorpreview);
       scb();
       end
    else
       begin
       codepreview:=chr(ascii[i]);
       write(codepreview);
       end;
   end;

   writeln();
   writeln();
   writeln();
   writeln();
   s_ort(fn4d);writeln(fn4d);
   writeln();
   writeln();
   s_ort(fn1d);writeln(fn1d);
   writeln();
   writeln();
   s_ort(fn2d);writeln(fn2d);
   writeln();




    keypress:=readkey;
	pressascii:=ord(keypress);
   if pressascii=32 then   {kodu 2. gosterisi}
   begin
   timecount:=timecount+0.00012;{10 sn  yaklasik deger}
    clrscr;
    writeln();
    writeln();
    writeln();
    s_ort(ske); writeln('CODE:');
    writeln();
    writeln();
    i_ort(code_length);
    textcolor(13);
      for i:=1 to code_length do
      begin
      codepreview:=chr(ascii[i]);
      write(codepreview);
      end;
    scb();
      writeln();
      writeln();

   write('                    ');
   DecodeTime(timecount,hr, min, sec, ms);
   bdef(); write (format('+ %d:',[hr]));
    write (format('%d:',[min]));
    write (format('%d',[sec]));
                  writeln();
                  writeln();
      delay(1500);

   end
   else

   if (pressascii=ascii[asciiarrow]) then
    begin
    asciiarrow:=asciiarrow+1;
    if asciiarrow > code_length then
    status:=3;                                                  //oyun kazanildi skor ekranina yonlendirtme
    end
    else
    begin
    timecount:=timecount+0.00006; {yaklasik 5 sn ceza}
    textcolor(lightred); s_ort(m1d); write('!!!!'); delay(250); scb();
    end;
   until(pressascii=27) OR (status=3);
  









 if status=3 then
   begin
   timecount:=timecount+(time()-timebegin);{zaman hesabi}
   scoretemp:=timecount;
   clrscr;
   writeln();
   writeln();
   writeln();
   s_ort(cs1d); writeln(cs1d);
   writeln();
   writeln();

    bdef(); bdef(); write(skd);   DecodeTime(scoretemp,hr, min, sec, ms);
   bdef(); write (format('+ %d:',[hr]));
   write (format('%d:',[min]));
   write (format('%d',[sec]));

   writeln();
   writeln();
   writeln();
   bdef(); bdef();write(cs2d);readln(nametemp);

   {score siralama------------------------------------------------------------------}
   j:=10;
   i:=10;
   if  scoretemp < playerscore[10] then
   begin
       while (i<>0) AND (scoretemp < playerscore[i]) do
       begin
         i:=i-1;
       end;
   i:=i+1; {bir altinda yer almasi lazim}

       for k:=10 downto i do  {sondan *sonuncu skoru cikartarak}
       begin
         playerscore[k]:=playerscore[k-1];
         playername[k]:= playername[k-1];
       end;

   playerscore[i]:=scoretemp;
   playername[i]:= nametemp;

   end;

   writeln();
   writeln();

   end;//stage 3 end
   end;//stage 2 end
   end;//menu 0 end

   end;//menu restart end //ara cikis



   if(status=3) then    {kazanma sonu/skor tablosu------------------------------------------------------------}
   begin
   clrscr;

   writeln();
   writeln();
   writeln();
   writeln();
   s_ort(m5d);writeln(m5d);
   bdef();writeln('__________________________________________________');
   writeln();
   for i:=1 to 10 do
   begin
   bdef();write(playername[i]);tirestring(playername[i]);

   DecodeTime(playerscore[i],hr, min, sec, ms);
   write (format('+ %d:',[hr]));
   write (format('%d:',[min]));
   write (format('%d',[sec]));

   writeln();
   writeln();

   status:=0; {menu durumu sıfırlama}
   end;

   readkey;

   end;
   until(status=4);  {ana menu cikisi}
   {final cikis--------------------------------------------------}

end.
