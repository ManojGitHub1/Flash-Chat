
void main() {

  Square mysquare = Square();
  mysquare.color = "red";
  Square mysquare2 = Square();
  mysquare2.color = "blue";
  // creating a object just to call a static var(only used once)
  // print(Square().noOfSides);
  // by adding static
  print(Square.noOfSides);

  // creating a Object
  // Circle circle = Circle();
  // circle.Perimeter(radius: 10.3);

  // Circle().Perimeter(radius: 18.3);
  // If we add static so Perimeter is a method associated with class
  // rather then object constructed with the class
  Circle.Perimeter(radius: 28.3);


}

class Square{
  // int noOfSides = 4;
  static int noOfSides = 4;
  late String color;
}

class Circle{
  // const in constant in whole file, so to create const for a class use static
  static const pi = 3.14;

  static void Perimeter({required double radius}) {
    double circumference = 2 * pi * radius;
    print(circumference);
  }

}