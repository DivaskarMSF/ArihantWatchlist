

enum SortingType { 
   none,
   lowToHigh, 
   highToLow, 
   aToZ, 
   zToA 
}


class SingletonCls {
  
  String? wId;
  int? selectedTabIndex;
  SortingType sortingType = SortingType.none;
  static final SingletonCls shared = SingletonCls._privateConstructor();

  SingletonCls._privateConstructor() {  // Private Constructor 
    // initialization logic
  }
}