
import 'dart:io';

import 'package:acml/src/data/api_services_urls.dart';
import 'package:acml/src/data/cache/cache_repository.dart';
import 'package:msil_library/httpclient/msil_httpclient.dart';
import 'package:msil_library/models/base/base_request.dart';

import '../../src/models/common/symbols_model.dart';
import '../../src/models/watchlist/watchlist_group_model.dart';
import '../../src/models/watchlist/watchlist_symbols_model.dart';

class WatchRepository {

Future<WatchlistGroupModel> getWatchlistGroupsRequest(BaseRequest request) async {

  final groupCacheModel = await CacheRepository.groupCache.get('getGroup');

   if (groupCacheModel != null) {
    return groupCacheModel;

   }else {
    final Map<String, dynamic> resp = await HTTPClient().postJSONRequest(url: ApiServicesUrls.getWatchlistGroups, data: request.getRequest(),);
    final WatchlistGroupModel groupResponse = WatchlistGroupModel.fromJson(resp);
    CacheRepository.groupCache.put('getGroup', groupResponse);

    return groupResponse;
     
   }
}

  Future<WatchlistSymbolsModel?> getWatchlistSymbolsRequest(BaseRequest request, {required String wId}) async {
    final symbolCacheModel = await CacheRepository.watchlistCache.get(wId);
    if (symbolCacheModel != null) {
      if (symbolCacheModel is WatchlistSymbolsModel) {

        return WatchlistSymbolsModel(symbolCacheModel.getSymbols().map((symbol) => Symbols.copyModel(symbol)).toList(),);
      }

    } else {
      final HTTPClient httpClient = HTTPClient();
      final Map<String, dynamic> resp = await httpClient.postJSONRequest(url: ApiServicesUrls.getSymbols, data: request.getRequest());
      CacheRepository.watchlistCache.put(wId, WatchlistSymbolsModel.fromJson(resp));

      final WatchlistSymbolsModel groupSymbolResponse = WatchlistSymbolsModel.fromJson(resp);

      return groupSymbolResponse;
    }

    return null;
  }

}

// class WatchRepository {

//    String userUrl = 'http://5e53a76a31b9970014cf7c8c.mockapi.io/msf/getContacts';

//   Future<List<UserModel>> getUsers() async {
    
//     Response response = await get(Uri.parse(userUrl));

//     if (response.statusCode == 200) {

//             final List result = jsonDecode(response.body);
//       return result.map((e) => UserModel.fromJson(e)).toList();

//     }else {
//       throw Exception(response.reasonPhrase);
//     }
//   }

// }