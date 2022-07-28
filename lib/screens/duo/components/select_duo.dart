import 'package:dio/dio.dart' as Dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moeen/helpers/dio/API.dart';
import 'package:moeen/helpers/models/duos_model.dart';

class SelectDuo extends StatefulWidget {
  const SelectDuo({Key? key}) : super(key: key);

  @override
  State<SelectDuo> createState() => _SelectDuoState();
}

class _SelectDuoState extends State<SelectDuo> {
  late final List<DuosModel> duos;
  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDuos();
  }

  void fetchDuos() async {
    try {
      final Api api = Api();
      var response = await api.getDuos();
      setState(() {
        duos = response;
        loading = false;
      });
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
      return const Center(
        child: Text("لا يوجد لديك ثنائيات"),
      );
    }
    return Container(
      padding: const EdgeInsets.all(20),
      child: ListView.separated(
          itemCount: duos.length,
          separatorBuilder: (context, index) => const Divider(
                thickness: 0.8,
                height: 1,
                color: Color(0xffe4e4e7),
              ),
          itemBuilder: (context, index) {
            int num = index + 1;
            return ListTile(
              tileColor: Colors.white,
              leading: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: const Color(0xffecfdf5),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: const Color(0xffd1fae5))),
                child: Center(
                    child: Text(
                  num.toString(),
                  style:
                      const TextStyle(color: Color(0xff047857), fontSize: 12),
                )),
              ),
              title: Text("${duos[index].username}"),
              subtitle: Text("رقم المعرف: ${duos[index].id}"),
              trailing: const Icon(
                Icons.chevron_right,
                color: Color(0xff059669),
              ),
            );
          }),
    );
  }
}
