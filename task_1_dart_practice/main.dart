void main() async{
  //simple print statement
  print("1" + "5");
  print("1"*5);

  //variables

  int x1 = 10;
  int x2 = 20;
  int x3 = x1*x2;
  print("First number is : $x1" );
  print("Second number is : $x2" );
  print("Multiplation gives :$x3 ");

  dynamic val1 = "String";

  print("Val1 is a dynamic variable with runtime-type : ${val1.runtimeType} ");

  String str1 = """this is a 
  multiline string """;

  print(str1);

  //const and final
  final test1 = DateTime.now();
  const test2 = 10;

  print(test1);
  print(test2);

  //nullable variables

  String? nullV ;
  print(nullV);
  print(nullV?.length??0);


  //if statements

  int age = 10 ;
  bool allowed = true;

  if(age>=20){
    if(allowed) {
      print("Yes you're allowed to watch the movie");
    }
  }
  else if (age>=16){
    if(allowed) {
      print(
          "yes you're allowed to watch the movie BUT with an elder sibling !");
    }
  }

  else {
    print("You're not allowed to watch the movie in any SCNEARIO ! ");
  }

  //for loops

  for(int i = 0 ; i<5 ; i++){
    print("Hello from iteration $i");
  }

  String test3= "Hello World";
  int i = 0;

  while(i<=11)
    {
      if(i==5){
        i++;
        break;
      }
      else {
        print(test3[i]);
        i++;
      }
  }

  //functions

  String name = "Dayyan";
  var helper = printHelper(name);
  print(helper);
  print("Age is ${printHelper(name).$1}");

  //Classes

  Dog dog1 = Dog("Husky","Small");
  dog1.makesNoise();

  dog1.size="Big";
  print("Now the dog is ${dog1.size}");

  print("Color of the dog is ${dog1.color}");


  //lists

  List<Dog> dogs = [Dog("Husky","Small"),Dog("German","Small"),Dog("Husky","Small"),Dog("Rot","Small")];

  dogs.add(Dog("Russian","Big"));
  dogs.removeLast();

  for (int i = 0 ; i<dogs.length;i++)
    {
      print(dogs[i].name);
  }

  final huskies = dogs.where((dog) => dog.name == "Husky").toList();

  for(int i = 0 ; i < huskies.length;i++)
    {
      print(huskies[i].name);
  }


  //maps

  Map marks = {
    "English" : 98,
    "Maths" : 75,
    "Urdu" : 65,
  };

  marks["Computer"]=100;

  marks.forEach((key,value){
    print("${key} : ${value}");
  });

  //Exception handling

  try {
    print(10 ~/ 0);
  }catch(e){
    print(e);
  }finally{
    print("I dont care, i will execute");
  }

  print("Dayyan");

  //Future and aysnc wait

  var a = await getTotal(10,15);

  print("The awaited result is : $a");



  //Streams

  countDown().listen((val){
  print(val);
  });

  //Higher-order functions
  firstFunction(secondFunction);


}

//functions for practicing higher-order functions
void firstFunction(Function fun2){
  fun2();
}

void secondFunction(){
  print("I am the second function in the higher-order functions.");
}

//function for future - async wait
Future<int> getTotal(int a,int b) {
  return Future.delayed(Duration(seconds:2),()=>a+b);
}


//function for stream
Stream<int> countDown() async*{
  for (int i =0; i <5;i++)
  {
    yield i ;
    await Future.delayed(Duration(seconds:1));
  }

}


class Animal{
  String color = "white";
}

abstract class Animal2{
  void makesNoise();
}




class Dog extends Animal implements Animal2{
  String name;
  String size;

  Dog(this.name,this.size){
    print("Dog constructor has been called");
    //getting the color from the animal class from inheritance and then overriding it in the dog class
    color = "Yellow";
  }

  void makesNoise(){
    bark();
  }


  void bark(){
    print("${name} is barking");
  }

}


(int,String) printHelper(String name){
  return (21,name);
}
