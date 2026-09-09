import 'package:dio/dio.dart' as form;
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Components/Network/backend_error.dart';
import 'hashtagCollectionModel.dart';

class HashtagCollectionRepository {
  Future<List<HashtagCollection>> getHashtagCollections({String? type}) async {
    final query = type == null ? '' : '?type=$type';
    final response = await API().getApi(
      url: 'my-tags-collection$query',
      isLoader: false,
    );
    if (response.statusCode == 200) {
      return HashtagCollectionResponse.fromJson(response.data).data;
    }
    throw HashtagApiException.fromResponse(response);
  }

  Future<HashtagCollection> getHashtagCollection(int id) async {
    final response = await API().getApi(
      url: 'my-tags-collection-by-id/$id',
      isLoader: false,
    );
    if (response.statusCode == 200) {
      final data = HashtagCollectionResponse.fromJson(response.data).data;
      if (data.isNotEmpty) return data.first;
    }
    throw HashtagApiException.fromResponse(response);
  }

  Future<HashtagCollection> createHashtagCollection(
    CreateHashtagCollectionRequest request,
  ) async {
    return _saveCollection(request.toFormData());
  }

  Future<HashtagCollection> updateHashtagCollection(
    UpdateHashtagCollectionRequest request,
  ) async {
    return _saveCollection(request.toFormData());
  }

  Future<HashtagCollection> _saveCollection(form.FormData data) async {
    final response = await API().postApi(
      data,
      'add-tag-collection',
      showProgress: false,
    );
    if (response.statusCode == 200) {
      final parsed = HashtagCollectionResponse.fromJson(response.data).data;
      if (parsed.isNotEmpty) return parsed.first;
    }
    throw HashtagApiException.fromResponse(response);
  }

  Future<CollectionRemovalResult> removeHashtagCollections(
    List<int> collectionIds,
  ) async {
    final data = form.FormData();
    for (final id in collectionIds) {
      data.fields.add(MapEntry('collection_ids[]', id.toString()));
    }
    final response = await API().postApi(
      data,
      'remove-tag-collection',
      showProgress: false,
    );
    if (response.statusCode == 200) {
      return CollectionRemovalResult.fromJson(response.data);
    }
    throw HashtagApiException.fromResponse(response);
  }

  Future<Map<String, dynamic>?> removeEventHashtag({
    required int eventId,
    required String name,
  }) async {
    final response = await API().postApi(
      form.FormData.fromMap({
        'event_id': eventId,
        'name': cleanHashtag(name),
      }),
      'remove-event-hashtag',
      showProgress: false,
    );
    if (response.statusCode == 200) {
      final data = response.data is Map ? response.data['data'] : null;
      return data is Map ? Map<String, dynamic>.from(data) : null;
    }
    throw HashtagApiException(
      backendErrorMessage(response, field: 'hashtags'),
      statusCode: response.statusCode,
    );
  }
}

class HashtagApiException implements Exception {
  HashtagApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  factory HashtagApiException.fromResponse(dynamic response) {
    return HashtagApiException(
      backendErrorMessage(response),
      statusCode: response?.statusCode,
    );
  }

  @override
  String toString() => message;
}
