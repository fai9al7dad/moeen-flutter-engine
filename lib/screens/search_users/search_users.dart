import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:moeen/components/CustomAppBar.dart';
import 'package:moeen/components/CustomInput.dart';
import 'package:moeen/components/list_item.dart';
import 'package:moeen/helpers/dio/api.dart';
import 'package:moeen/helpers/models/duos_model.dart';

class SearchUsers extends StatefulWidget {
  const SearchUsers({Key? key}) : super(key: key);

  @override
  State<SearchUsers> createState() => _SearchUsersState();
}

class _SearchUsersState extends State<SearchUsers> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController searchController = TextEditingController();
  bool loading = false;
  List<SearchUserModel>? searchResult = [];
  bool searched = false;

  Api api = Api();
  void searchUser({query}) async {
    setState(() {
      loading = true;
    });
    List<SearchUserModel>? res = await api.searchUsers(query: query);
    setState(() {
      loading = false;
      searched = true;
      searchResult = res;
    });
  }

  void sendInvite({toUserID}) async {
    setState(() {
      loading = true;
    });
    try {
      await api.sendInvite(toUserID: toUserID);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green[200],
          content: Text(
            "تم إرسال الدعوة بنجاح",
            style: TextStyle(color: Colors.green[900]),
            textAlign: TextAlign.right,
          )));
    } on DioError catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red[200],
          content: Text(
            e.response?.data["message"],
            style: TextStyle(color: Colors.red[900]),
            textAlign: TextAlign.right,
          )));
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "البحث", showLoading: loading),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomInput(
                    prefixIcon: Icons.search_outlined,
                    controller: searchController,
                    label: "ابحث...",
                    textInputAction: TextInputAction.search,
                    onFieldSubmitted: (v) {
                      searchUser(query: v);
                    },
                    validator: (v) => null),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "يمكن البحث بواسطة اسم المستخدم أو رقم المعرف",
                  style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (searched)
                  searchResult != null
                      ? Expanded(
                          child: ListView.separated(
                            itemCount: searchResult!.length,
                            separatorBuilder: (context, index) => const Divider(
                              thickness: 0.8,
                              height: 1,
                              color: Color(0xffe4e4e7),
                            ),
                            itemBuilder: (context, index) {
                              return ListItem(
                                  index: index,
                                  title:
                                      Text("${searchResult![index].username}"),
                                  onTap: () => sendInvite(
                                      toUserID: searchResult![index].id),
                                  subtitle: Text(
                                      "رقم المعرف: ${searchResult![index].id}"),
                                  trailing:
                                      const Icon(Icons.touch_app_outlined));
                            },
                          ),
                        )
                      : Column(
                          children: const [
                            SizedBox(
                              height: 10,
                            ),
                            Text("لا يوجد نتائج تطابق بحثك"),
                          ],
                        )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
