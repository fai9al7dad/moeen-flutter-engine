import 'package:flutter/material.dart';
import 'package:moeen/common/presentation/atoms/CustomAppBar.dart';
import 'package:moeen/common/presentation/atoms/list_item.dart';
import 'package:moeen/helpers/dio/api.dart';
import 'package:moeen/providers/auth/auth_provider.dart';
import 'package:provider/provider.dart';

class DeleteUserScreen extends StatefulWidget {
  const DeleteUserScreen({Key? key}) : super(key: key);

  @override
  State<DeleteUserScreen> createState() => _DeleteUserScreenState();
}

class _DeleteUserScreenState extends State<DeleteUserScreen> {
  bool showConfirmDialog = false;
  bool loading = false;
  void triggerDialog() {
    setState(() {
      showConfirmDialog = !showConfirmDialog;
    });
  }

  void deleteAccount() async {
    final api = Api();
    setState(() {
      loading = true;
    });
    await api.deleteAuthUser();
    Provider.of<AuthProvider>(context, listen: false).logout();
    setState(() {
      loading = false;
    });
    triggerDialog();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green[200],
        content: Text(
          'تم حذف الحساب بنجاح',
          style: TextStyle(color: Colors.green[900]),
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          title: 'حذف الحساب',
        ),
        body: SingleChildScrollView(
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  ListItem(
                      title: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            textAlign: TextAlign.right,
                            "هل أنت متاكد من حذف الحساب؟",
                            style: TextStyle(
                                fontSize: 13, fontFamily: "montserrat-bold"),
                          ),
                          SizedBox(height: 20),
                          Text(
                            textAlign: TextAlign.right,
                            "في حال حذفك للحساب سيتم حذف جميع البيانات المرتبطه به، وجميع الثنائيات والأوراد فيه  سيتم حذفها أيضاً - الأوراد المقبولة من المسمع ستبقى عنده وستحذف من حسابك. -",
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  )),
                  const SizedBox(height: 20),
                  ListItem(
                    onTap: () => triggerDialog(),
                    title: const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Center(
                          child: Text("حذف الحساب",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.red)),
                        )),
                  )
                ],
              ),
            ),
            if (showConfirmDialog)
              AlertDialog(
                actions: [
                  loading
                      ? const CircularProgressIndicator(
                          strokeWidth: 2,
                        )
                      : TextButton(
                          child: const Text(
                            'حذف الحساب',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            deleteAccount();
                          },
                        ),
                  TextButton(
                    child: Text(
                      'الغاء',
                      style: TextStyle(color: Colors.blueGrey.shade500),
                    ),
                    onPressed: () {
                      setState(() {
                        showConfirmDialog = false;
                      });
                    },
                  ),
                ],
                title: const Text("هل فعلا تريد حذف الحساب ؟"),
                content: const Text(
                  "! اذا حذفته لا يمكنك التراجع",
                  textAlign: TextAlign.right,
                ),
              ),
          ]),
        ));
  }
}
