import 'package:flutter/material.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InstalledAppsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Installed Apps")),
      body: FutureBuilder<List<AppInfo>>(
        future: InstalledApps.getInstalledApps(true, true),
        builder:
            (BuildContext buildContext, AsyncSnapshot<List<AppInfo>> snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? snapshot.hasData
                  ? ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        AppInfo app = snapshot.data![index];
                        sendData(app);
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Image.memory(app.icon!),
                            ),
                            title: Text(app.name!),
                            subtitle: Text(app.getVersionInfo()),
                            onTap: () =>
                                InstalledApps.startApp(app.packageName!),
                            onLongPress: () =>
                                InstalledApps.openSettings(app.packageName!),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                          "Error occurred while getting installed apps ...."),
                    )
              : Center(
                  child: Text("Getting installed apps ...."),
                );
        },
      ),
    );
  }

  sendData(AppInfo appInfo) {
    final db = FirebaseFirestore.instance;
    final apps = <String, String>{
      "name": appInfo.name.toString(),
      "package name": appInfo.packageName.toString(),
      // "icon": appInfo.icon.toString(),
    };

    db
        .collection("childApps")
        .doc("03OGY07FlEFgq2PMptrQ")
        .set(apps)
        .onError((e, _) => print("Error writing document: $e"));
  }
}
