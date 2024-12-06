import 'package:animated_icon/animated_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_evdeai/Applications/core/colors.dart';
import 'package:flutter_application_evdeai/Applications/pages/AddBusScreen/add_bus_bloc/add_bus_bloc.dart';
import 'package:flutter_application_evdeai/Applications/pages/busOpratorLoginScreen/Login_with_email/Login_email_bloc/login_email_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:icons_plus/icons_plus.dart';

class BusListWrapper extends StatelessWidget {
  const BusListWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AddBusBloc()..add(FetchBusData()),
        ),
        BlocProvider(
          create: (context) => LoginEmailBloc(),
        ),
      ],
      child: BusListOperator(),
    );
  }
}

class BusListOperator extends StatefulWidget {
  const BusListOperator({super.key});

  @override
  State<BusListOperator> createState() => _BusListOperatorState();
}

class _BusListOperatorState extends State<BusListOperator> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<LoginEmailBloc>(context);
    return BlocListener<AddBusBloc, AddBusState>(
      listener: (context, state) {},
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: backGroundColor,
          actions: [
            AnimateIcon(
              height: 30,
              width: 30,
              onTap: () async {
                authBloc.add(LogOutEvent());
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/buslogin', (route) => false);
                });
              },
              iconType: IconType.animatedOnTap,
              animateIcon: AnimateIcons.signOut,
              color: Colors.green,
            )
          ],
        ),
        floatingActionButton: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/addbuspage');
            },
            child: Icon(EvaIcons.plus, size: 30),
          ),
        ),
        backgroundColor: backGroundColor,
        body: BlocBuilder<AddBusBloc, AddBusState>(
          builder: (context, state) {
            if (state is AddBusLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is FetchBusDataError) {
              return Center(child: Text('Error: ${state.error}'));
            } else if (state is LoadedBusData) {
              final List<Map<String, dynamic>> busDataList = state.busData;

              if (busDataList.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(25),
                  child: ListView.builder(
                    itemCount: busDataList.length,
                    itemBuilder: (context, index) {
                      final busData = busDataList[index];
                      final startDestination =
                          busData['startDestination'] as Map<String, dynamic>?;
                      final endDestination =
                          busData['endDestination'] as Map<String, dynamic>?;

                      return SingleChildScrollView(
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/busstand',
                                arguments: busData);
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: backGroundColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            height: 122,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blue,
                                        Colors.purple,
                                        Colors.cyan
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(3),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.asset(
                                      'assets/images/bus1.png',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                const Gap(10),
                                SingleChildScrollView(
                                  child: Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          busData['busName']
                                                  ?.toString()
                                                  .toUpperCase() ??
                                              '',
                                          style: TextStyle(
                                            color: textColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          busData['busNumber']?.toString() ??
                                              '',
                                          style: TextStyle(
                                            color: textColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          startDestination?['stopname'] ?? '',
                                          style: TextStyle(color: textColor),
                                        ),
                                        Text('To'),
                                        Text(endDestination?['stopname'] ?? ''),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                Future.microtask(() {
                  Navigator.pushReplacementNamed(context, '/bushome');
                });
                return Center(child: Text('No bus data available.'));
              }
            }

            return Center(child: Text('No bus data available'));
          },
        ),
      ),
    );
  }
}
