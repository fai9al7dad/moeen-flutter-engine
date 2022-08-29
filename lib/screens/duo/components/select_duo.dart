import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:moeen/components/CustomShowCase.dart';
import 'package:moeen/components/list_item.dart';
import 'package:moeen/helpers/dio/API.dart';
import 'package:moeen/helpers/general/constants.dart';
import 'package:moeen/helpers/models/duos_model.dart';
import 'package:moeen/screens/werds/werds_screen.dart';
import 'package:showcaseview/showcaseview.dart';

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
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (duos.isEmpty) {
      return const Center(child: Text("لا يوجد لديك ثنائيات"));
    }
    return Container(
      padding: const EdgeInsets.all(20),
      child: RefreshIndicator(
        onRefresh: fetchDuos,
        child: ListView.separated(
            itemCount: duos.length,
            separatorBuilder: (context, index) => const Divider(
                  thickness: 0.8,
                  height: 1,
                  color: Color(0xffe4e4e7),
                ),
            itemBuilder: (context, index) {
              return ListItem(
                  index: index,
                  title: Text("${duos[index].username}"),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WerdsScreen(
                            duoID: duos[index].duoID,
                            username: duos[index].username,
                            reciterID: duos[index].id),
                      )),
                  subtitle: Text("رقم المعرف: ${duos[index].id}"),
                  trailingIcon: Icons.chevron_right);
            }),
      ),
    );
  }
}
