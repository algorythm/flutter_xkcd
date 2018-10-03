class Xkcd {
  final int number;
  final String title;
  final String img;
  final String alt;

  // Xkcd(int number, String title, String img, String alt) {
  //   this.number = number;
  //   this.title = title;
  //   this.img = img;
  //   this.alt = alt;
  // }
  Xkcd({this.number, this.title, this.img, this.alt});

  factory Xkcd.fromJson(Map<dynamic, dynamic> json) {
    return Xkcd(
      number: json["num"],
      title: json["title"],
      img: json["img"],
      alt: json["alt"]
    );
  }
}