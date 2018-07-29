import 'dart:io';
import 'dart:convert';
import 'dart:async' show Future;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' show basename;
import 'package:async/async.dart' show DelegatingStream;

import 'package:fteste/models/user.dart';
import 'package:fteste/utils/constants.dart';

class AuthenticationApi {
  Future<bool> login(User user) async {
    // final response = await http.post(
    //   Constants.loginUrl,
    //   body: json.encode({
    //     'email': user.email,
    //     'senha': user.password
    //   }));

    // if (response.statusCode == HttpStatus.ok) {
    //   return true;
    // } else {
    //   return false;
    // }
    return true;
  }

  Future<bool> register(User newUser) async {
    // final response = await http.post(
    //   Constants.registerUrl,
    //   body: json.encode({
    //     'email': newUser.email,
    //     'senha': newUser.password,
    //     'telefone': newUser.phone,
    //     'endereco': newUser.address,
    //     'estado': newUser.state,
    //     'cpf': newUser.cpf,
    //     'nome': newUser.name,
    //   }));

    // if (response.statusCode == HttpStatus.ok) {
    //   return true;
    // } else {
    //   return false;
    // }
    return true;
  }

  uploadPhoto(File imageFile) async {
    var stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse(Constants.uploadPhotoUrl);

    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));

    request.files.add(multipartFile);
    request.send().then((response) {
      if (response.statusCode == HttpStatus.ok)
        print("Photo Uploaded!");
    });
  }
}