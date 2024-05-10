import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<String> uploadImageToImgur(File imageFile, String clientId) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('https://api.imgur.com/3/image'),
  );

  request.headers['Authorization'] = 'Client-ID $clientId';

  request.files.add(
    await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
    ),
  );

  var response = await request.send();
  var responseJson = jsonDecode(await response.stream.bytesToString());

  if (response.statusCode == 200) {
    return responseJson['data']['link'];
  } else {
    throw Exception('Failed to upload image: ${responseJson['data']['error']}');
  }
}
