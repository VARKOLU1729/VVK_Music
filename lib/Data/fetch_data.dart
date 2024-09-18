import 'package:http/http.dart' as http;
import 'dart:convert';

Future<dynamic> fetchData(
    {required String path, String? limit, String? offset}) async {
  var url = Uri(
      scheme: 'https',
      host: 'api.napster.com',
      path: 'v2.2/$path',
      queryParameters: {
          if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
        'apikey': "OTYxNDY3NTItZmM1Zi00MTMzLTllN2UtMDk2ZTBlMzIyYTZm"
      });
  var res = await http.get(url);
  return json.decode(res.body);
}
