import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sky_scrapper/helpers/api_helper.dart';
import 'package:sky_scrapper/providers/internet_check_provider.dart';
import 'package:intl/intl.dart';
import 'package:sky_scrapper/utils/globlal_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  TextEditingController searchController = TextEditingController();
  PageController pageController = PageController();
  @override
  void initState() {
    super.initState();
    Provider.of<InternetCheckProvider>(context, listen: false)
        .checkConnectivity();
    getApi = ApiHelper.apiHelper.whetherApi(searchTerm: 'London');
    loadPrefs();
  }

  setPrefs(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    globalSet.add(value);
    prefs.setStringList('favorite', globalSet.toList());

    globalList = globalSet.toList();
    setState(() {});
  }

  removePrefs(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    globalSet.remove(value);
    prefs.setStringList('favorite', globalSet.toList());

    globalList = globalSet.toList();
    setState(() {});
  }

  loadPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedFavorites = prefs.getStringList('favorite');
    if (savedFavorites != null) {
      globalSet = savedFavorites.toSet();
      globalList = globalSet.toList();
    }
    setState(() {});
  }

  late Future<Map?> getApi;
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final internetCheck = Provider.of<InternetCheckProvider>(context)
        .internetCheckModel
        .isNetworkAvailable;
    return Scaffold(
      body: (internetCheck == false)
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No INTERNET'),
                  CircularProgressIndicator(),
                ],
              ),
            )
          : PageView(
              controller: pageController,
              onPageChanged: (val) {
                selectedIndex = val;
                setState(() {});
              },
              children: [
                SafeArea(
                  child: CustomScrollView(
                    slivers: [
                      const SliverAppBar(
                        centerTitle: true,
                        title: Text(
                          'Sky Scrapper',
                          style: TextStyle(fontSize: 30),
                        ),
                        elevation: 5,
                      ),
                      SliverToBoxAdapter(
                        child: SafeArea(
                          child: FutureBuilder(
                            future: getApi,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text('Error ${snapshot.error}'),
                                );
                              } else if (snapshot.hasData) {
                                Map? whetherApi = snapshot.data;
                                List? furtherForecast = whetherApi!['days'];

                                List<String> dayNames =
                                    furtherForecast!.map<String>((day) {
                                  DateTime date =
                                      DateTime.parse(day['datetime']);
                                  return DateFormat('EEEE')
                                      .format(date); // Convert date to day name
                                }).toList();
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    Center(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                whetherApi['address']
                                                    .toString()
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                    fontSize: 30,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              (globalList.contains(
                                                      whetherApi['address']))
                                                  ? IconButton(
                                                      onPressed: () {
                                                        removePrefs(whetherApi[
                                                            'address']);
                                                      },
                                                      icon: const Icon(
                                                        Icons.favorite,
                                                        color: Colors.red,
                                                      ),
                                                    )
                                                  : IconButton(
                                                      onPressed: () {
                                                        setPrefs(whetherApi[
                                                            'address']);
                                                      },
                                                      icon: const Icon(
                                                        Icons
                                                            .favorite_border_outlined,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                          Text(
                                            '${whetherApi['resolvedAddress']}',
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                          const SizedBox(
                                            height: 25,
                                          ),
                                          Text(
                                            '${whetherApi['days'][0]['temp']}',
                                            style:
                                                const TextStyle(fontSize: 30),
                                          ),
                                          const SizedBox(
                                            height: 25,
                                          ),
                                          Text(
                                            '${whetherApi['days'][0]['conditions']}',
                                            style:
                                                const TextStyle(fontSize: 30),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: SizedBox(
                                        height: 200,
                                        child: Card(
                                          elevation: 5,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8.0),
                                                child: Text(
                                                  'TODAY\'S FORECAST',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 17,
                                                child: GridView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 3,
                                                    mainAxisExtent: 150,
                                                  ),
                                                  itemCount: 3,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          '${furtherForecast[index + 2]['hours'][index + 2]['datetime']}',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 20),
                                                        ),
                                                        Text(
                                                          '${furtherForecast[index + 2]['hours'][index + 2]['temp']}',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 20),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(18.0),
                                      child: SizedBox(
                                        height: 530,
                                        child: Card(
                                          elevation: 5,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8.0),
                                                child: Text(
                                                  '7-DAY FORECAST',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Expanded(
                                                child: ListView.separated(
                                                    separatorBuilder:
                                                        (context, i) {
                                                      return const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    18.0),
                                                        child: Divider(),
                                                      );
                                                    },
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount: 7,
                                                    itemBuilder: (context, i) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    18.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                dayNames[i],
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            20),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                '${whetherApi['days'][i]['tempmax']}',
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            20),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                whetherApi['days']
                                                                            [i][
                                                                        'conditions']
                                                                    .toString()
                                                                    .split(
                                                                        ',')[0],
                                                                style:
                                                                    const TextStyle(
                                                                  fontSize: 20,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              }
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height / 1.2,
                                alignment: Alignment.center,
                                child: Text(
                                  '${searchController.text} Not Found',
                                  style: const TextStyle(fontSize: 25),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: searchController,
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                getApi = ApiHelper.apiHelper
                                    .whetherApi(searchTerm: value);
                                selectedIndex = 0;
                                pageController.animateToPage(0,
                                    duration: const Duration(milliseconds: 350),
                                    curve: Curves.easeInOut);
                                setState(() {});
                              }
                            },
                            textInputAction: TextInputAction.search,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder()),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 18,
                        child: ListView.builder(
                            itemCount: globalList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(globalList[index]),
                                onTap: () {
                                  pageController.animateToPage(0,
                                      duration:
                                          const Duration(milliseconds: 350),
                                      curve: Curves.easeInOut);
                                  getApi = ApiHelper.apiHelper.whetherApi(
                                      searchTerm: globalList[index]);
                                },
                                trailing: IconButton(
                                    onPressed: () {
                                      removePrefs(globalList[index]);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    )),
                              );
                            }),
                      )
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (val) {
          pageController.animateToPage(val,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search')
        ],
      ),
    );
  }
}
