//we use model so that utilization and maniplation of data can be easier

class Brew {
//the list of brew objects we want to get from our snapshot are just a list of these objects in the document

  final String name;
  final String sugars;
  final int strength;
  
  Brew({required this.name, required this.sugars, required this.strength});


}
