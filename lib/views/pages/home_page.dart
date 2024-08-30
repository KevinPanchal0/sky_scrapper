import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sky_scrapper/helpers/api_helper.dart';
import 'package:sky_scrapper/providers/internet_check_provider.dart';
import 'package:intl/intl.dart';

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
                          'Sky Scrapper APp',
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
                                          Text(
                                            '${whetherApi['address']}',
                                            style: const TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold),
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
                                                                '${whetherApi['days'][0]['tempmax']}',
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            20),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                whetherApi['days']
                                                                            [0][
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
                              return Center(
                                  child: Container(
                                      alignment: Alignment.center,
                                      child:
                                          const CircularProgressIndicator()));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SafeArea(
                  child: TextField(),
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
