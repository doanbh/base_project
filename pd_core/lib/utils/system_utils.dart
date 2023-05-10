import 'dart:async';
import 'dart:developer' as dp show log;
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pd_core/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../error/errors.dart';

class SystemUtils {
  static Future<void> _launchUrl(String url) async {
    if (await canLaunch(url)) await launch(url);
  }

  static Future<void> openUrlInBrowser(String url) => _launchUrl(url);

  static Future<void> openUri({
    required AppStoreUri appStoreUri,
    String? url,
  }) async {
    if (Platform.isAndroid && appStoreUri.androidId != null) {
      if (await canLaunch(appStoreUri.nativeAndroid!))
        await launch(appStoreUri.nativeAndroid!);
      else
        openUrlInBrowser(appStoreUri.androidWeb!);
    } else if (Platform.isIOS && appStoreUri.iosId != null) {
      if (await canLaunch(appStoreUri.nativeIos!))
        await launch(appStoreUri.nativeIos!);
      else
        openUrlInBrowser(appStoreUri.iosWeb!);
    } else if (url != null) await SystemUtils.openUrlInBrowser(url);
  }

  static Future<void> openFile(FutureOr<String> filePath) async {
    final OpenResult result = await OpenFile.open(await filePath);

    switch (result.type) {
      case ResultType.noAppToOpen:
        // throw UnsupportedError('Không có ứng dụng khả dụng để mở file này!');
        throw 'Không có ứng dụng khả dụng để mở file này!';
      case ResultType.fileNotFound:
        // throw FileSystemException(
        //     'Đã có lỗi xảy ra, không tìm thấy file được yêu cầu!');
        // throw 'Đã có lỗi xảy ra, không tìm thấy file được yêu cầu!';
        // throw 'Không tìm thấy file!';
        throw FileNotFound();
      case ResultType.permissionDenied:
        throw PermissionDenied('Vui lòng cấp quyền truy cập!');
      default:
        break;
    }
  }

  static Future<void> launchPhoneUrlScheme(String url) => _launchUrl(url);

  static Future<Uint8List?> getCachedImageAsByte(String url) async {
    var cached = await DefaultCacheManager().getFileFromCache(url);
    if (cached == null) return null;

    return await cached.file.readAsBytes();
  }

  /*
  static bool _hasAndroidSdkNumberLoaded = false;
  static int? _androidSdkInt;
  static int get _androidSdkNumber => _androidSdkInt ?? 29;

  static String _externalStoragePublicPathToDownloadDirectory =
      '/storage/emulated/0/Download';

  static Future<String?> getFirstAvailablePathToDownloadDirectory() async {
    if (Platform.isAndroid) {
      if (_hasAndroidSdkNumberLoaded == false) {
        AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
        _androidSdkInt = androidInfo.version.sdkInt;
        _hasAndroidSdkNumberLoaded = true;
      }

      if (_androidSdkNumber < 29)
        return _externalStoragePublicPathToDownloadDirectory;

      return (await getExternalStorageDirectories(
              type: StorageDirectory.downloads))?[0]
          .path;
    }

    return null;
  }
  */

  static Future<String> getAppDirectory() async {
    if (Platform.isAndroid)
      return (await getExternalStorageDirectory() ??
              await getApplicationSupportDirectory())
          .path;
    else
      return (await getApplicationSupportDirectory()).path;
  }

  static Future<String> getDeviceTemporaryDirectory() async {
    return (await getTemporaryDirectory()).path;
  }

  static Future<String> getPathToDownloadFolder() async =>
      await getAppDirectory();

  static Future<String> getPathToDownloadedCvFolder(String folder) async =>
      await getPathToDownloadFolder() + "/downloaded_cv/$folder";

  static Future<String> getChatFilePath(String fileName) async =>
      await getPathToDownloadFolder() + "/chat/$fileName";

  static debugLog(String source, String message) {
    if (kDebugMode) dp.log(message, name: source);
  }

  static List getLastArrayInArray(List list, int countGet) => list.length < countGet ? list : list.sublist(0, countGet - 1);

  static String formatPriceVND(dynamic price){
    // if (price is String){
    //   price =
    // }
    return NumberFormat("#,###", "en_US").format(price ?? 0) + 'đ';
  }

  static String formatPriceNotVND(dynamic price){
    return NumberFormat("#,###", "en_US").format(price ?? 0);
  }

  static String getMaxItemList(List<int> listItem){
    return listItem.fold(0, max).toString();
  }

  static String getMinMaxItemList(List<int> listItem){
    return "${listItem.fold(0, min).toString()} - ${listItem.fold(0, max).toString()}";
  }

  static String getMinMaxItemListString(List<String> listItem){
    final List <num> listItemConvert = listItem.map(num.parse).toList();
    return "${listItemConvert.fold(0, min).toString()} - ${listItemConvert.fold(0, max).toString()}";
  }

  static String getMaxItemListString(List<String> listItem){
    final List <num> listItemConvert = listItem.map(num.parse).toList();
    return listItemConvert.fold(0, max).toString();
  }
}
