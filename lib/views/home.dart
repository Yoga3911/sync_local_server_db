import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:tugas_paa/provider/user_provider.dart';
import 'package:tugas_paa/routes/routes.dart';
import 'package:tugas_paa/services/user_service.dart';
import 'package:tugas_paa/widgets/custom_loading.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _username;
  late TextEditingController _email;

  bool isEdit = false;

  File? _img;
  String? _imgUrl;
  String? _imgName;
  final DateTime _date = DateTime.now();

  Future<void> fromGallery() async {
    XFile? result = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (result != null) {
      _img = File(result.path);
      _imgName = result.name;
    }
    setState(() {});
  }

  Future<void> getImgUrl({String? imgName}) async {
    _imgUrl = await FirebaseStorage.instance
        .ref("products/$imgName")
        .getDownloadURL();
  }

  Future<void> uploadImg({String? imgName, File? imgFile}) async {
    try {
      await FirebaseStorage.instance.ref("products/$imgName").putFile(imgFile!);
      log("Image uploaded");
    } on FirebaseException catch (e) {
      log(e.message!);
    }
  }

  @override
  void initState() {
    final user = Provider.of<UserProvier>(context, listen: false);
    _username = TextEditingController();
    _email = TextEditingController();
    _username.text = user.getResponse?.username ?? "";
    _email.text = user.getResponse?.email ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = Provider.of<UserProvier>(context);
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "edit",
              backgroundColor: const Color(0xFF7967ff),
              onPressed: () async {
                isEdit = !isEdit;
                if (!isEdit) {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (_) => const CustomLoading(),
                  );

                  (_img != null)
                      ? await uploadImg(
                          imgFile: _img,
                          imgName: "$_imgName${_date.millisecond}")
                      : null;
                  (_img != null)
                      ? await getImgUrl(
                          imgName: "$_imgName${_date.millisecond}")
                      : null;

                  UserService().update(
                    context: context,
                    email: _email.text,
                    username: _username.text,
                    image: _imgUrl ?? user.getResponse!.image,
                    token: user.getToken,
                  );
                  return;
                }
                setState(() {});
              },
              child: (isEdit)
                  ? const Icon(Icons.save_rounded)
                  : const Icon(Icons.edit_rounded),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              heroTag: "refesh",
              backgroundColor: const Color(0xFF28c8fd),
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.main,
                (route) => false,
              ),
              child: const Icon(Icons.refresh_outlined),
            ),
          ],
        ),
        body: ListView(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: size.height * 0.3,
                  margin: EdgeInsets.only(
                    bottom: size.height * 0.11,
                  ),
                  width: size.width,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Color(0xFF9d39ff),
                        Color(0xFF7967ff),
                        Color(0xFF28c8fd),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      const Center(
                        child: Text(
                          "Hidup seperti Patrick",
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                      ),
                      (isEdit)
                          ? Align(
                              alignment: const Alignment(0.9, 0.85),
                              child: SizedBox(
                                height: 30,
                                width: 220,
                                child: TextField(
                                  controller: _username,
                                  decoration: InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Align(
                              alignment: const Alignment(0.9, 0.85),
                              child: Text(
                                user.getResponse?.username ?? "Blank",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(100),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Alert"),
                              content:
                                  const Text("Apakah anda yakin ingin keluar?"),
                              actions: [
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Tidak"),
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0xFF7967ff),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    final pref =
                                        await SharedPreferences.getInstance();
                                    pref.remove("token");
                                    showDialog(
                                      context: context,
                                      builder: (_) => const CustomLoading(),
                                    );
                                    await Future.delayed(
                                        const Duration(seconds: 1));
                                    log("Berhasil logout");
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      Routes.auth,
                                      (route) => false,
                                    );
                                  },
                                  child: const Text("Ya"),
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0xFF7967ff),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(100),
                        child: const Padding(
                          padding: EdgeInsets.all(7),
                          child: Icon(
                            Icons.logout_rounded,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: (isEdit) ? size.height * 0.23 : size.height * 0.2,
                  left: size.width * 0.1,
                  child: CircleAvatar(
                    radius: (isEdit) ? size.height * 0.07 : size.height * 0.1,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius:
                          (isEdit) ? size.height * 0.065 : size.height * 0.095,
                      backgroundColor: const Color(0xFF28c8fd),
                      child: ClipOval(
                        child: (isEdit)
                            ? Stack(
                                children: [
                                  (_img != null)
                                      ? Image.file(
                                          _img!,
                                          fit: BoxFit.cover,
                                          height: double.infinity,
                                          width: double.infinity,
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: user.getResponse!.image,
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                  Container(
                                    color: const Color.fromARGB(
                                        110, 158, 158, 158),
                                    height: double.infinity,
                                    width: double.infinity,
                                    child: IconButton(
                                      onPressed: () {
                                        fromGallery()
                                            .then((_) => setState(() {}));
                                      },
                                      icon:
                                          const Icon(Icons.camera_alt_rounded),
                                      color: Colors.white,
                                      iconSize: 34,
                                    ),
                                  ),
                                ],
                              )
                            : CachedNetworkImage(
                                imageUrl: user.getResponse!.image,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                ),
                (isEdit)
                    ? Positioned(
                        top: size.height * 0.31,
                        right: size.width * 0.03,
                        child: SizedBox(
                          height: 30,
                          width: 220,
                          child: TextField(
                            controller: _email,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              fillColor: const Color(0xFF7967ff),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Positioned(
                        top: size.height * 0.31,
                        right: size.width * 0.05,
                        child: Text(
                          user.getResponse?.email ?? "Blank",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 45, 45, 45),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Terakhir diubah",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user.getResponse?.updateAt.toString() ?? "Blank",
                    style: const TextStyle(
                      color: Color.fromARGB(255, 94, 94, 94),
                      fontSize: 13,
                    ),
                  ),
                  TimelineTile(
                    alignment: TimelineAlign.start,
                    isFirst: true,
                    indicatorStyle: IndicatorStyle(
                      padding: const EdgeInsets.only(bottom: 5),
                      width: 20,
                      iconStyle: IconStyle(
                        iconData: Icons.school_rounded,
                        color: Colors.white,
                      ),
                      color: const Color(0xFF9d39ff),
                    ),
                    beforeLineStyle: const LineStyle(
                      color: Color(0xFF9d39ff),
                      thickness: 6,
                    ),
                    endChild: Container(
                      padding: const EdgeInsets.only(left: 10),
                      constraints: const BoxConstraints(
                        minHeight: 100,
                      ),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("SD Negeri Asal Ada 1 Greenland"),
                      ),
                    ),
                  ),
                  TimelineTile(
                    alignment: TimelineAlign.start,
                    indicatorStyle: IndicatorStyle(
                      padding: const EdgeInsets.only(bottom: 5, top: 5),
                      width: 20,
                      color: const Color(0xFF9d39ff),
                      iconStyle: IconStyle(
                        iconData: Icons.school_rounded,
                        color: Colors.white,
                      ),
                    ),
                    beforeLineStyle: const LineStyle(
                      color: Color(0xFF9d39ff),
                      thickness: 6,
                    ),
                    endChild: Container(
                      padding: const EdgeInsets.only(left: 10),
                      constraints: const BoxConstraints(
                        minHeight: 100,
                      ),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("SMP Negeri Asal Ada 1 Greenland"),
                      ),
                    ),
                  ),
                  TimelineTile(
                    alignment: TimelineAlign.start,
                    indicatorStyle: IndicatorStyle(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      width: 20,
                      color: const Color(0xFF9d39ff),
                      iconStyle: IconStyle(
                        iconData: Icons.school_rounded,
                        color: Colors.white,
                      ),
                    ),
                    beforeLineStyle: const LineStyle(
                      color: Color(0xFF9d39ff),
                      thickness: 6,
                    ),
                    endChild: Container(
                      padding: const EdgeInsets.only(left: 10),
                      constraints: const BoxConstraints(
                        minHeight: 100,
                      ),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("SMA Negeri Asal Ada 1 Greenland"),
                      ),
                    ),
                  ),
                  TimelineTile(
                    alignment: TimelineAlign.start,
                    isLast: true,
                    indicatorStyle: IndicatorStyle(
                      padding: const EdgeInsets.only(top: 5),
                      width: 20,
                      color: const Color(0xFF9d39ff),
                      indicator: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                            color: Color(0xFF9d39ff), shape: BoxShape.circle),
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    beforeLineStyle: const LineStyle(
                      color: Color(0xFF9d39ff),
                      thickness: 6,
                    ),
                    endChild: Container(
                      padding: const EdgeInsets.only(left: 10),
                      constraints: const BoxConstraints(
                        minHeight: 100,
                      ),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Universitas Asal Ada Greenland",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
