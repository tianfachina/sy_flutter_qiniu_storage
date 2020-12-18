import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sy_flutter_qiniu_storage/sy_flutter_qiniu_storage.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _process = 0.0;

  @override
  void initState() {
    super.initState();
  }

  _onUpload() async {
    String token = 'Sw9cBvAZ42ZAsfkKNFbhIvOEncnEBnJcs4y94-OA:20cHeriHBA4fIOOonw8EixsV5X0=:eyJzY29wZSI6Im5lc3RjaWFvLXBob3RvIiwiZGVhZGxpbmUiOjE2MDgyNzc5NjUsInJldHVybkJvZHkiOiJ7XCJrZXlcIjogJChrZXkpLCBcInNpemVcIjogJChmc2l6ZSksIFwidHlwZVwiOiAkKG1pbWVUeXBlKSwgXCJoYXNoXCI6ICQoZXRhZyksIFwid2lkdGhcIjogJChpbWFnZUluZm8ud2lkdGgpLCBcImhlaWdodFwiOiAkKGltYWdlSW5mby5oZWlnaHQpLCBcIm9yaWVudGF0aW9uXCI6ICQoaW1hZ2VJbmZvLk9yaWVudGF0aW9uLnZhbCksIFwiY29sb3JcIjogJChleGlmLkNvbG9yU3BhY2UudmFsKSwgXCJ2aWRlb0R1cmF0aW9uXCI6ICQoYXZpbmZvLnZpZGVvLmR1cmF0aW9uKSwgXCJ2aWRlb1dpZHRoXCI6ICQoYXZpbmZvLnZpZGVvLndpZHRoKSwgXCJ2aWRlb0hlaWdodFwiOiAkKGF2aW5mby52aWRlby5oZWlnaHQpLCBcInZpZGVvUm90YXRlXCI6ICQoYXZpbmZvLnZpZGVvLnRhZ3Mucm90YXRlKSwgXCJ1cmxcIjogXCJodHRwczovL2ltZy5pbW9sYWNuLmNvbS8kKGtleSk_dmZyYW1lL2pwZy9vZmZzZXQvMS93LzY2MC9oLzY2MFwiLCBcIm9yaWdpbmFsVXJsXCI6IFwiaHR0cHM6Ly9pbWcuaW1vbGFjbi5jb20vJChrZXkpXCJ9IiwicmV0dXJuVXJsIjpudWxsLCJzYXZlS2V5IjoibmVzdGNpYW8vJChldGFnKSJ9';
    PickedFile file = await ImagePicker().getVideo(source:ImageSource.gallery);
    if (file == null) {
      return;
    }
    final syStorage = new SyFlutterQiniuStorage();
    //监听上传进度
    syStorage.onChanged().listen((dynamic percent) {
      double p = percent;
      setState(() {
        _process = p;
      });
      print(percent);
    });

    //上传文件
    var result = await syStorage.upload(file.path, token, _key(file));
    print(result);
  }

  String _key(PickedFile file) {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        '.' +
        file.path.split('.').last;
  }

  //取消上传
  _onCancel() {
    SyFlutterQiniuStorage.cancelUpload();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('七牛云存储SDK demo'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              LinearProgressIndicator(
                value: _process,
              ),
              RaisedButton(
                child: Text('上传'),
                onPressed: _onUpload,
              ),
              RaisedButton(
                child: Text('取消上传'),
                onPressed: _onCancel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
