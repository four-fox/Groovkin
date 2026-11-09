import 'dart:io';
import 'dart:typed_data';

import 'package:groovkin/Components/mediaModel.dart';

const eventVideoRejectedMessage =
    'Video uploads are not supported for events. Please select an image.';

const eventUnsupportedFileMessage =
    'Please select a JPG, PNG, or PDF file.';

const eventBannerRejectedMessage =
    'Please select a JPG or PNG image.';

/// Image types the event banner and gallery already upload.
const eventImageExtensions = <String>{'jpg', 'jpeg', 'png'};

/// Negotiation attachments already accept PDF alongside images.
const eventAttachmentExtensions = <String>{'jpg', 'jpeg', 'png', 'pdf'};

const eventVideoExtensions = <String>{
  'mp4',
  'mov',
  'avi',
  'mkv',
  'webm',
  '3gp',
  'm4v',
  'mpeg',
  'mpg',
  'wmv',
  'flv',
  'ts',
  'm2ts',
};

enum EventMediaPurpose { banner, attachment }

class EventFileVerdict {
  const EventFileVerdict({
    required this.accept,
    required this.isVideo,
    this.extension,
  });

  final bool accept;
  final bool isVideo;
  final String? extension;

  String get message => isVideo
      ? eventVideoRejectedMessage
      : (extension == 'pdf'
          ? eventBannerRejectedMessage
          : eventUnsupportedFileMessage);
}

EventFileVerdict classifyEventFile({
  required String path,
  String? mimeType,
  List<int>? header,
  EventMediaPurpose purpose = EventMediaPurpose.attachment,
}) {
  final extension = _extensionOf(path);
  final mime = (mimeType ?? '').toLowerCase().split(';').first.trim();
  final sniffed = _sniff(header);

  if (_mimeIsVideo(mime) ||
      sniffed == _Sniff.video ||
      eventVideoExtensions.contains(extension)) {
    return EventFileVerdict(accept: false, isVideo: true, extension: extension);
  }

  final image = sniffed == _Sniff.jpeg ||
      sniffed == _Sniff.png ||
      _mimeIsJpegOrPng(mime) ||
      eventImageExtensions.contains(extension);
  final pdf = sniffed == _Sniff.pdf ||
      mime == 'application/pdf' ||
      extension == 'pdf';

  if (purpose == EventMediaPurpose.banner) {
    if (image && !pdf) {
      return EventFileVerdict(accept: true, isVideo: false, extension: extension);
    }
    return EventFileVerdict(
      accept: false,
      isVideo: false,
      extension: extension,
    );
  }

  if (image || pdf) {
    final resolved = pdf ? 'pdf' : (extension ?? sniffed.name);
    return EventFileVerdict(accept: true, isVideo: false, extension: resolved);
  }

  if (mime == 'application/octet-stream' || mime.isEmpty) {
    return EventFileVerdict(accept: false, isVideo: false, extension: extension);
  }

  return EventFileVerdict(accept: false, isVideo: false, extension: extension);
}

class EventMediaGate {
  const EventMediaGate({
    required this.canSubmit,
    this.message,
    this.rejected = const [],
    this.clearBanner = false,
  });

  final bool canSubmit;
  final String? message;
  final List<MediaClass> rejected;
  final bool clearBanner;
}

Future<EventMediaGate> guardEventUploads({
  required List<MediaClass> attachments,
  String? bannerPath,
  Future<List<int>> Function(String path)? readHeader,
}) async {
  final rejected = <MediaClass>[];
  var sawVideo = false;
  var sawOther = false;

  for (final item in attachments) {
    final path = item.filename;
    if (path == null || path.isEmpty) {
      rejected.add(item);
      sawOther = true;
      continue;
    }
    if (_markedVideo(item)) {
      rejected.add(item);
      sawVideo = true;
      continue;
    }
    final header = await _safeHeader(path, readHeader);
    final verdict = classifyEventFile(
      path: path,
      header: header,
      purpose: EventMediaPurpose.attachment,
    );
    if (!verdict.accept) {
      rejected.add(item);
      if (verdict.isVideo) {
        sawVideo = true;
      } else {
        sawOther = true;
      }
    }
  }

  var clearBanner = false;
  if (bannerPath != null && bannerPath.trim().isNotEmpty) {
    final header = await _safeHeader(bannerPath, readHeader);
    final verdict = classifyEventFile(
      path: bannerPath,
      header: header,
      purpose: EventMediaPurpose.banner,
    );
    if (!verdict.accept) {
      clearBanner = true;
      if (verdict.isVideo) {
        sawVideo = true;
      } else {
        sawOther = true;
      }
    }
  }

  if (rejected.isEmpty && !clearBanner) {
    return const EventMediaGate(canSubmit: true);
  }
  return EventMediaGate(
    canSubmit: false,
    rejected: rejected,
    clearBanner: clearBanner,
    message: sawVideo
        ? eventVideoRejectedMessage
        : (clearBanner && !sawOther
            ? eventBannerRejectedMessage
            : eventUnsupportedFileMessage),
  );
}

bool eventAttachmentIsVideo(MediaClass item) {
  if (_markedVideo(item)) return true;
  final path = item.filename ?? '';
  if (path.isEmpty) return false;
  return classifyEventFile(path: path).isVideo;
}

Future<List<int>> readEventFileHeader(String path) async {
  final file = File(path);
  if (!await file.exists()) return const [];
  final stream = file.openRead(0, 32);
  final builder = BytesBuilder(copy: false);
  await for (final chunk in stream) {
    builder.add(chunk);
    if (builder.length >= 32) break;
  }
  final bytes = builder.takeBytes();
  if (bytes.length <= 32) return bytes;
  return bytes.sublist(0, 32);
}

bool _markedVideo(MediaClass item) {
  final type = (item.fileType ?? '').toLowerCase();
  if (eventVideoExtensions.contains(type)) return true;
  if (type.startsWith('video')) return true;
  final thumb = item.thumbnail;
  if (thumb != null && thumb.isNotEmpty && !eventImageExtensions.contains(type)) {
    return type != 'pdf';
  }
  return false;
}

Future<List<int>?> _safeHeader(
  String path,
  Future<List<int>> Function(String path)? readHeader,
) async {
  try {
    return await (readHeader ?? readEventFileHeader)(path);
  } catch (_) {
    return null;
  }
}

String? _extensionOf(String path) {
  final name = path.split(RegExp(r'[\\/]')).last;
  final dot = name.lastIndexOf('.');
  if (dot <= 0 || dot == name.length - 1) return null;
  final ext = name.substring(dot + 1).toLowerCase();
  if (ext.contains('?') || ext.length > 5) return null;
  return ext;
}

bool _mimeIsVideo(String mime) => mime.startsWith('video/');

bool _mimeIsJpegOrPng(String mime) =>
    mime == 'image/jpeg' || mime == 'image/jpg' || mime == 'image/png';

enum _Sniff { jpeg, png, pdf, video, unknown }

_Sniff _sniff(List<int>? header) {
  if (header == null || header.length < 3) return _Sniff.unknown;
  if (header[0] == 0xFF && header[1] == 0xD8 && header[2] == 0xFF) {
    return _Sniff.jpeg;
  }
  if (header.length >= 8 &&
      header[0] == 0x89 &&
      header[1] == 0x50 &&
      header[2] == 0x4E &&
      header[3] == 0x47) {
    return _Sniff.png;
  }
  if (header.length >= 4 &&
      header[0] == 0x25 &&
      header[1] == 0x50 &&
      header[2] == 0x44 &&
      header[3] == 0x46) {
    return _Sniff.pdf;
  }
  if (header.length >= 12 &&
      header[4] == 0x66 &&
      header[5] == 0x74 &&
      header[6] == 0x79 &&
      header[7] == 0x70) {
    return _Sniff.video;
  }
  if (header.length >= 4 &&
      header[0] == 0x1A &&
      header[1] == 0x45 &&
      header[2] == 0xDF &&
      header[3] == 0xA3) {
    return _Sniff.video;
  }
  if (header.length >= 12 &&
      header[0] == 0x52 &&
      header[1] == 0x49 &&
      header[2] == 0x46 &&
      header[3] == 0x46 &&
      header[8] == 0x41 &&
      header[9] == 0x56 &&
      header[10] == 0x49) {
    return _Sniff.video;
  }
  return _Sniff.unknown;
}
