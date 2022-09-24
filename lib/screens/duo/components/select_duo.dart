import 'dart:developer';

import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:moeen/components/CustomShowCase.dart';
import 'package:moeen/components/list_item.dart';
import 'package:moeen/components/streak_progress_widget.dart';
import 'package:moeen/helpers/dio/API.dart';
import 'package:moeen/helpers/general/constants.dart';
import 'package:moeen/helpers/models/duos_model.dart';
import 'package:moeen/screens/duo/components/duo_shimmer.dart';
import 'package:moeen/screens/werds/werds_screen.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:square_percent_indicater/square_percent_indicater.dart';

class SelectDuo extends StatefulWidget {
  const SelectDuo({Key? key}) : super(key: key);

  @override
  State<SelectDuo> createState() => _SelectDuoState();
}

class _SelectDuoState extends State<SelectDuo> {
  List<DuosModel> duos = [];
  bool loading = true;
  @override
  void initState() {
    super.initState();
    fetchDuos();
  }

  Future<void> fetchDuos() async {
    try {
      final Api api = Api();
      var response = await api.getDuos();
      if (mounted) {
        setState(() {
          duos = response;
          loading = false;
        });
      }
    } on Dio.DioError catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const ShimmerLoading();
    }
    if (duos.isEmpty) {
      return const Center(child: Text("لا يوجد لديك ثنائيات"));
    }
    return Container(
      padding: const EdgeInsets.all(20),
      child: RefreshIndicator(
        onRefresh: fetchDuos,
        child: ListView.builder(
            itemCount: duos.length,
            // separatorBuilder: (context, index) => const Divider(
            //       thickness: 0.8,
            //       height: 1,
            //       color: Color(0xffe4e4e7),
            //     ),
            itemBuilder: (context, index) {
              return DuoCard(duo: duos[index]);
            }),
      ),
    );
  }
}

class DuoCard extends StatelessWidget {
  const DuoCard({
    Key? key,
    required this.duo,
  }) : super(key: key);

  final DuosModel duo;

  @override
  Widget build(BuildContext context) {
    return ListItem(
        leading: Hero(
            tag: "duo_${duo.id}",
            child: StreakProgressWidget(latestWerd: duo.latestWerd)),
        // index: index,
        title: Text("${duo.username}"),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => WerdsScreen(
                duoID: duo.duoID,
                username: duo.username,
                reciterID: duo.id,
                latestWerd: duo.latestWerd,
              ),
            )),
        subtitle: Text("رقم المعرف: ${duo.id}"),
        trailing: Icon(
          Icons.chevron_right,
          color: Theme.of(context).colorScheme.primary,
        ));
  }
}

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) {
            return const DuoShimmer();
          }),
    );
  }
}
