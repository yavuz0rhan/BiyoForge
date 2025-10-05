
import processing.serial.*;

Serial myPort;
String gelenVeri;

float suSeviyesi = 0;
float gazSeviyesi = 0;

void setup() {
  size(450, 500);
  surface.setTitle("BiyoForge Data");
  String portName = "COM5";
  
  try {
    myPort = new Serial(this, portName, 9600);
    myPort.bufferUntil('\n');
  } catch (Exception e) {
    System.err.println("Hata: " + portName + " portu bulunamadi veya kullanilamiyor.");
    exit();
  }
}

void serialEvent(Serial p) {
  gelenVeri = p.readStringUntil('\n');
  if (gelenVeri != null) {
    gelenVeri = trim(gelenVeri);
    String[] sensorVerileri = split(gelenVeri, ',');
    if (sensorVerileri.length == 2) {
      try {
        suSeviyesi = float(sensorVerileri[0]);
        gazSeviyesi = float(sensorVerileri[1]);
      } catch (Exception e) {
        println("Veri formatı hatası: " + e.getMessage());
      }
    }
  }
}

void draw() {
  background(240, 243, 245);
  
  fill(50);
  textSize(24);
  textAlign(CENTER);
  text("Su Seviyesi", 115, 60);
  noStroke();
  fill(60, 150, 255);
  float barYuksekligi = map(suSeviyesi, 0, 100, 0, 300);
  rect(65, 400 - barYuksekligi, 100, barYuksekligi);
  noFill();
  stroke(50);
  strokeWeight(4);
  rect(65, 100, 100, 300);
  fill(50);
  textSize(22);
  textAlign(CENTER, CENTER);
  text(nf(suSeviyesi, 0, 0) + "%", 115, 425);

  fill(50);
  textSize(24);
  textAlign(CENTER);
  text("Gaz Yoğunluğu", 325, 60);

  textSize(50);
  text(nf(gazSeviyesi, 0, 0) + "%", 325, 150); 
  
  float havaDurumRengi_R = map(gazSeviyesi, 0, 100, 0, 255); 
  float havaDurumRengi_G = map(gazSeviyesi, 0, 100, 255, 0); 
  
  stroke(50);
  strokeWeight(4);
  fill(constrain(havaDurumRengi_R, 0, 255), constrain(havaDurumRengi_G, 0, 255), 0);
  ellipse(325, 280, 120, 120);
  
  fill(255);
  textSize(20);
  if (gazSeviyesi < 50) { 
    text("NORMAL", 325, 280);
  } else {
    text("YÜKSEK", 325, 280);
  }
}
