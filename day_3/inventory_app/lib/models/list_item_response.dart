import 'dart:convert';
import 'item.dart';

class ListItemResponse {
  final String? status;
  final String? message;
  final ListItemData? data;

  ListItemResponse({
    this.status,
    this.message,
    this.data,
  });

  factory ListItemResponse.fromRawJson(String str) =>
      ListItemResponse.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  factory ListItemResponse.fromJson(Map<String, dynamic> json) =>
      ListItemResponse(
        status: json['status'] as String?,
        message: json['message'] as String?,
        data: json['data'] == null
            ? null
            : ListItemData.fromJson(json['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}

class ListItemData {
  final int? currentPage;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final List<Link>? links;
  final String? nextPageUrl;
  final String? path;
  final int? perPage;
  final String? prevPageUrl;
  final int? to;
  final int? total;
  final List<Item>? items;

  ListItemData({
    this.currentPage,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
    this.items,
  });

  factory ListItemData.fromRawJson(String str) =>
      ListItemData.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  factory ListItemData.fromJson(Map<String, dynamic> json) => ListItemData(
        currentPage: json['current_page'] as int?,
        firstPageUrl: json['first_page_url'] as String?,
        from: json['from'] as int?,
        lastPage: json['last_page'] as int?,
        lastPageUrl: json['last_page_url'] as String?,
        links: json['links'] == null
            ? []
            : List<Link>.from((json['links'] as List)
                .map((x) => Link.fromJson(x as Map<String, dynamic>))),
        nextPageUrl: json['next_page_url'] as String?,
        path: json['path'] as String?,
        perPage: json['per_page'] as int?,
        prevPageUrl: json['prev_page_url'] as String?,
        to: json['to'] as int?,
        total: json['total'] as int?,
        items: json['items'] == null
            ? []
            : List<Item>.from((json['items'] as List)
                .map((x) => Item.fromJson(x as Map<String, dynamic>))),
      );

  Map<String, dynamic> toJson() => {
        'current_page': currentPage,
        'first_page_url': firstPageUrl,
        'from': from,
        'last_page': lastPage,
        'last_page_url': lastPageUrl,
        'links': links == null
            ? []
            : List<dynamic>.from(links!.map((x) => x.toJson())),
        'next_page_url': nextPageUrl,
        'path': path,
        'per_page': perPage,
        'prev_page_url': prevPageUrl,
        'to': to,
        'total': total,
        'items': items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class Link {
  final String? url;
  final String? label;
  final bool? active;

  Link({
    this.url,
    this.label,
    this.active,
  });

  factory Link.fromRawJson(String str) =>
      Link.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json['url'] as String?,
        label: json['label'] as String?,
        active: json['active'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'url': url,
        'label': label,
        'active': active,
      };
}
