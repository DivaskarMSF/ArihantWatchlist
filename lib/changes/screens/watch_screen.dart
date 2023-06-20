import 'dart:ffi';

import 'package:acml/changes/bloc/watch_bloc.dart';
import 'package:acml/changes/repository/watch_repository.dart';
import 'package:acml/changes/widgets/watchlist_tab.dart';
import 'package:acml/src/data/repository/watchlist/watchlist_repository.dart';
import 'package:acml/src/models/watchlist/watchlist_group_model.dart';
import 'package:acml/src/ui/screens/base/base_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../src/models/common/symbols_model.dart';
import '../../src/models/watchlist/watchlist_symbols_model.dart';
import '../../src/ui/styles/app_images.dart';
import '../constants/new_constants.dart';
import '../widgets/filter_bottomsheet.dart';

class WatchScreen extends BaseScreen {

  WatchlistGroupModel? groupModel;
  late int selectedTabIndex = 0;
  List<Widget> tabs = const [
    Tab(text: ''),
    Tab(text: ''),
    Tab(text: ''),
    Tab(text: ''),
    Tab(text: '')
  ];
  List<Symbols> symbols = [];
  List<WatchlistSymbolsModel> symbolsModelList = [];
  List<Widget> listOfWidgets = [];

  WatchScreen({super.key});

  @override
  WatchScreenState createState() => WatchScreenState();
}

class WatchScreenState extends State<WatchScreen>
    with SingleTickerProviderStateMixin {

  late TabController tabController;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // fetchData();

    // tabController = TabController(length: 4, vsync: this);
  }

  void fetchData() {}

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          // title: Row(
          //   children: const [
          //     Text('Watchlist',
          //         style: TextStyle(color: Colors.white, fontSize: 25)),
          //   ],
          // ),
          actions: <Widget>[
           
              const SizedBox(width: 15),
            Column(
              children: const [
                  SizedBox(height: 10),
                 Text('Watchlist',
                    style: TextStyle(color: Colors.white, fontSize: 27, ) ),
              ],
            ),
            const SizedBox(width: 60),

            Expanded(
              child: TextField(
                // textAlign: TextAlign.center,
                controller: searchController,
                onChanged: (newText) {
                  context.read<WatchBloc>().add(SearchEvent(
                      searchText: newText,
                      selectedTabIndex: widget.selectedTabIndex));
                  //   BlocProvider.of<WatchBloc>(context).add(SearchEvent(searchText: newText));
                },
                style: const TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  prefixIcon:
                      const Icon(Icons.search, color: Colors.white, size: 23),
                  filled: true,
                  contentPadding: const EdgeInsets.all(12),
                  hintStyle:
                      const TextStyle(color: Colors.white, fontSize: 18.0),
                  hintText: "Search",
                  fillColor: const Color.fromARGB(255, 27, 27, 27),
                  focusedBorder: OutlineInputBorder(
                    // borderSide: const BorderSide(color: Colors.yellow),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            // Center(child: Material(
            //   borderRadius: ,
            //   child: InkWell(splashColor: Colors.black,
            //   onTap: () {

            //   },
            //   child: Ink.image(image: AssetImage(''), height: 200, width: 200, fit: BoxFit.cover,),
            //   ),
            // ),
            // ),


            CircleAvatar(
                radius: 30,
                backgroundColor: Color.fromARGB(255, 36, 36, 36),
                child: IconButton(
                  icon: AppImages.filterIcon(context, isColor: true, color: Colors.white), 
                  onPressed: () {
                    showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (ctx) => BlocProvider.value(
                        value: BlocProvider.of<WatchBloc>(context),
                        child: FilterBottomSheet(
                            selectedTabIndex: widget.selectedTabIndex,)));
                  },
                ),
              ),
           

          ],
          // bottom: TabBar(
          //     onTap: (index) {
          //       print(index);
          //     },
          //     tabs: widget.tabs),
        ),
        body: BlocBuilder<WatchBloc, WatchState>(
          builder: (context, state) {
            if (state is WatchLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is WatchLoadedState) {
              // widget.symbols = state.watchlistSymsModel.symbols;

              widget.tabs = getTabs(state.watchlistGroupModel);
              widget.symbolsModelList = state.symbolsModelList!;
              widget.listOfWidgets = blocBody(state.symbolsModelList!,
              widget.selectedTabIndex, state.watchlistGroupModel!);
              widget.groupModel = state.watchlistGroupModel;
            }

            if (state is WatchChangeState) {
            
            }


            return SingleChildScrollView(
              child: Column(
                children: [
                  ColoredBox(
                    color: Colors.black,
                    child: TabBar(
                      onTap: (index) {
                        widget.selectedTabIndex = index;
            
                        SingletonCls.shared.selectedTabIndex = index;
                        SingletonCls.shared.sortingType = SortingType.none;
                       
                       if (widget.groupModel?.groups != null) {
                          SingletonCls.shared.wId = widget.groupModel!.groups![index].wId;
                       }
                       // SingletonCls.shared.wId = widget.groupModel?.groups[index].wId;
                          
                      },
                      tabs: widget.tabs,
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.white,
                      indicatorColor: Colors.blue,
                    ),
                  ),
                       
                    
                      Container(
                        height: MediaQuery.of(context).size.height,
                          color: Colors.black,
                          child: TabBarView(children: widget.listOfWidgets),
                      ),
                    
                 
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> blocBody(List<WatchlistSymbolsModel> symbolsModelList,
      int tabIndex, WatchlistGroupModel groupModel) {
    return symbolsModelList.map((element) {
      return WatchlistTab(
          selectedTabIndex: tabIndex,
          watchlistGroupModel: groupModel,
          symbolsModel: element);
    }).toList();
  }

  List<Tab> getTabs(WatchlistGroupModel? model) {
    List<Tab> tabsList = [];

    model?.groups!.forEach((element) {
      tabsList.add(Tab(
        child: Text(
          '${element.wName}',
          style: const TextStyle(fontSize: 18),
        ),
        // text: '${element.wName}',
      ));
    });

    return tabsList;
  }

/*
  Widget blocBody(List<Symbols> symbols) {
    // return ListView.separated(itemBuilder: itemBuilder, separatorBuilder: separatorBuilder, itemCount: itemCount);

    return ListView.separated(
        itemCount: symbols.length,
        shrinkWrap: true,
        separatorBuilder: (_, index) {
          return Divider();
        },
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
            child: Card(
              color: Colors.black,
              child: ListTile(
                title: Text('${symbols[index].dispSym}',
                    style: const TextStyle(color: Colors.white, fontSize: 15)),
                subtitle: Row(
                  children: [
                    Text('${symbols[index].companyName}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 11)),
                  ],
                ),
                trailing: Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${symbols[index].ltp}',
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 18)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${symbols[index].chng}',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15)),
                          const SizedBox(
                            width: 10,
                          ),
                          Text('(${symbols[index].chngPer}%)',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

*/
}
