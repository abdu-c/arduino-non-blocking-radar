import processing.serial.*;

Serial myPort;
String angle = "";
String distance = "";
String data = "";
String noObject;
float pixsDistance;
int iAngle, iDistance;
int index1 = 0;

void setup() {
  size(1280, 720);
  smooth();
  
  myPort = new Serial(this, "COM9", 9600); 
  myPort.bufferUntil('.');
}

void draw() {
  noStroke();
  fill(0, 4); 
  rect(0, 0, width, height - height * 0.065); 
  
  fill(98, 245, 31);
  drawRadar(); 
  drawLine();
  drawObject();
  drawText();
}

void serialEvent(Serial myPort) {
  data = myPort.readStringUntil('.');
  if (data != null) {
    data = trim(data);
    if (data.length() > 0 && data.charAt(data.length() - 1) == '.') {
      data = data.substring(0, data.length() - 1);
    }
    index1 = data.indexOf(",");
    if (index1 > 0) {
      angle = data.substring(0, index1);
      distance = data.substring(index1 + 1, data.length());
      try {
        iAngle = Integer.valueOf(trim(angle));
        iDistance = Integer.valueOf(trim(distance));
      } catch (NumberFormatException e) {
        // İlk paket yarım gelirse programın çökmesini engeller
      }
    }
  }
}

void drawRadar() {
  pushMatrix();
  translate(width / 2, height - height * 0.074);
  noFill();
  strokeWeight(2);
  stroke(98, 245, 31);
  
  arc(0, 0, (width - width * 0.0625), (width - width * 0.0625), PI, TWO_PI);
  arc(0, 0, (width - width * 0.27), (width - width * 0.27), PI, TWO_PI);
  arc(0, 0, (width - width * 0.479), (width - width * 0.479), PI, TWO_PI);
  arc(0, 0, (width - width * 0.687), (width - width * 0.687), PI, TWO_PI);
  
  line(-width / 2, 0, width / 2, 0);
  line(0, 0, (-width / 2) * cos(radians(30)), (-width / 2) * sin(radians(30)));
  line(0, 0, (-width / 2) * cos(radians(60)), (-width / 2) * sin(radians(60)));
  line(0, 0, (-width / 2) * cos(radians(90)), (-width / 2) * sin(radians(90)));
  line(0, 0, (-width / 2) * cos(radians(120)), (-width / 2) * sin(radians(120)));
  line(0, 0, (-width / 2) * cos(radians(150)), (-width / 2) * sin(radians(150)));
  popMatrix();
}

void drawObject() {
  pushMatrix();
  translate(width / 2, height - height * 0.074);
  strokeWeight(9);
  stroke(255, 10, 10);
  
  pixsDistance = iDistance * ((height - height * 0.1666) * 0.005); 
  
  if (iDistance > 0 && iDistance < 200) {
    line(pixsDistance * cos(radians(iAngle)), -pixsDistance * sin(radians(iAngle)), 
         (width - width * 0.505) * cos(radians(iAngle)), -(width - width * 0.505) * sin(radians(iAngle)));
  }
  popMatrix();
}

void drawLine() {
  pushMatrix();
  strokeWeight(9);
  stroke(30, 250, 60);
  translate(width / 2, height - height * 0.074);
  line(0, 0, (height - height * 0.12) * cos(radians(iAngle)), -(height - height * 0.12) * sin(radians(iAngle)));
  popMatrix();
}

void drawText() {
  pushMatrix();
  if (iDistance == 0 || iDistance >= 200) {
    noObject = "Menzil Disi";
  } else {
    noObject = "Nesne Tespit Edildi";
  }
  
  fill(0, 0, 0);
  noStroke();
  rect(0, height - height * 0.0648, width, height);
  fill(98, 245, 31);
  textSize(18);
  
  text("50cm", width - width * 0.3854, height - height * 0.0833);
  text("100cm", width - width * 0.281, height - height * 0.0833);
  text("150cm", width - width * 0.177, height - height * 0.0833);
  text("200cm", width - width * 0.0729, height - height * 0.0833);
  
  textSize(24);
  text("Non-Blocking Radar", width - width * 0.875, height - height * 0.0277);
  text("Aci: " + iAngle + " °", width - width * 0.48, height - height * 0.0277);
  
  if (iDistance > 0 && iDistance < 200) {
    text("Mesafe: " + iDistance + " cm", width - width * 0.26, height - height * 0.0277);
  } else {
    text("Mesafe: ---", width - width * 0.26, height - height * 0.0277);
  }
  popMatrix();
}
