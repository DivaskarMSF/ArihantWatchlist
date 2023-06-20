import 'package:acml/changes/bloc/watch_bloc.dart';
import 'package:acml/changes/models/sorting_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_logger/logger.dart';

import '../constants/new_constants.dart';
import 'custom_button.dart';
//import 'package:watchlist_contact_app/blocs/users_bloc.dart';
//import 'package:watchlist_contact_app/blocs/users_event.dart';

class FilterBottomSheet extends StatelessWidget {

 
  int selectedTabIndex;
  FilterBottomSheet({required this.selectedTabIndex, super.key});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 350,
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            ColoredBox(
              color: Colors.black,
              child: TabBar(
                onTap: (index) {
                  //  widget.selectedTabIndex = index;
                },
                tabs: const [
                  Tab(child: Text('Sort By', style: TextStyle(color: Colors.white, fontSize: 18)),),
                  Tab(text: 'Filter By'),
                ], //widget.tabs,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.white,
                indicatorColor: Colors.blue,
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.black,
                child: TabBarView(children: [body(selectedTabIndex), body(selectedTabIndex)]),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget body(int selectedTabIndex) {

    bool isBtn1Selected = false;
    bool isBtn2Selected = false;
    bool isBtn3Selected = false;
    bool isBtn4Selected = false;

    if (SingletonCls.shared.sortingType == SortingType.aToZ) {
      isBtn1Selected = true;
      isBtn2Selected = false;
    }else if (SingletonCls.shared.sortingType == SortingType.zToA) {
      isBtn1Selected = false;
      isBtn2Selected = true;
    }else if (SingletonCls.shared.sortingType == SortingType.highToLow) {
      isBtn3Selected = true;
      isBtn4Selected = false;
    }else if (SingletonCls.shared.sortingType == SortingType.lowToHigh) {
      isBtn3Selected = false;
      isBtn4Selected = true;
    }else {
      isBtn1Selected = false;
      isBtn2Selected = false;
      isBtn3Selected = false;
      isBtn4Selected = false;
    }


    List<SortingModel> sortingModel = [
      SortingModel(title: 'A-Z      Alphabetically', btnTitle1: 'A to Z',      btnTitle2: 'Z to A', isBtn1Selected: isBtn1Selected, isBtn2Selected: isBtn2Selected),
      SortingModel(title: 'LTP Change (Percentage)', btnTitle1: 'High to Low', btnTitle2: 'Low to High', isBtn1Selected: isBtn3Selected, isBtn2Selected: isBtn4Selected),
    ];

    return ListView.builder(
        itemCount: 2,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
            child: Card(
              color: Colors.black,
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(sortingModel[index].title,
                      style: const TextStyle(color: Colors.white, fontSize: 17)),
                ),
                subtitle:
                   Row(
                    children: [
                     
                      CustomButton(
                          selectedTabIndex: selectedTabIndex,
                          onPress: () {

                            if (sortingModel[index].btnTitle1 == 'A to Z') {

                              SingletonCls.shared.sortingType = SortingType.aToZ;

                            }else if (sortingModel[index].btnTitle1 == 'High to Low') {

                              SingletonCls.shared.sortingType = SortingType.highToLow;
                            }

                            BlocProvider.of<WatchBloc>(context).add(SortEvent(selectedTabIndex: selectedTabIndex, 
                            sortType: sortingModel[index].btnTitle1));

                            Navigator.pop(context);
                          },
                          text: sortingModel[index].btnTitle1,
                          isBtnSelected: sortingModel[index].isBtn1Selected,
                          
                          ),
                          

                      const SizedBox(width: 50),

                      CustomButton(
                          selectedTabIndex: selectedTabIndex,
                          onPress: () {

                            if (sortingModel[index].btnTitle2 == 'Z to A') {
                            
                              SingletonCls.shared.sortingType = SortingType.zToA;
                            }else if (sortingModel[index].btnTitle2 == 'Low to High') {
                              SingletonCls.shared.sortingType = SortingType.lowToHigh;   
                            }

                           BlocProvider.of<WatchBloc>(context).add(SortEvent(selectedTabIndex: selectedTabIndex, 
                           sortType: sortingModel[index].btnTitle2),
                         
                           );
                         //    context.read<WatchBloc>().add(SortEvent(selectedTabIndex: selectedTabIndex, sortType: 'asc'));
                            Navigator.of(context).pop();
                          },
                          text: sortingModel[index].btnTitle2,
                         isBtnSelected: sortingModel[index].isBtn2Selected,
                          ),
                   
                    ],
                  ),
                
              ),
            ),
          );
        });
  }

}


  


