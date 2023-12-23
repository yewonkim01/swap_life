//김진영 작성//
import 'package:http/http.dart' as http;

//function의 url 삽입
class FirebaseAuthRemoteDataSource {
  final String url = 'https://us-central1-swap-life.cloudfunctions.net/createCustomToken';

  Future<String> createCustomToken(Map<String, dynamic> user) async {
    final customTokenResponse = await http
         .post(Uri.parse(url), body:user);
    return customTokenResponse.body;
  }
}