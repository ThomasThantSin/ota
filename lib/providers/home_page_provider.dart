// ignore_for_file: unnecessary_getters_setters

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:ota/data/model/ota_mode.dart';
import 'package:ota/data/model/ota_mode_impl.dart';
import 'package:ota/data/vos/article_vo/article_vo.dart';
import 'package:ota/data/vos/banner_vo/banner_vo.dart';
import 'package:ota/data/vos/light_novel_vo/light_novel_vo.dart';
import 'package:ota/data/vos/manga_vo/manga_vo.dart';

class HomePageProvider extends ChangeNotifier {
  final OTAModel _otaModel = OTAModelImpl();
  List<BannerVO>? _bannerVOList;
  List<MangaVO>? _mangaVOList;
  List<LightNovelVO>? _lightNovelList;
  List<ArticleVO>? _articleList;
  bool _isNoInternet = false;
  bool? _isFavorite;

  void setisFavorite(String mangaID) {
    if (_otaModel.isFavorite(mangaID) ?? false) {
      setFavorite = true;
      notifyListeners();
    } else {
      setFavorite = false;
      notifyListeners();
    }
  }

  void changeFavorite(String managaID, bool isFavorite) {
    if (isFavorite) {
      _otaModel.removeFavorite(managaID);
    } else {
      _otaModel.saveIsFavorite(managaID, !isFavorite);
    }
    setFavorite = !isFavorite;
    notifyListeners();
  }

  get getIsFavorite => _isFavorite;
  set setFavorite(bool isFavorite) => _isFavorite = isFavorite;
  set setBannerList(List<BannerVO>? bannerVOList) =>
      _bannerVOList = bannerVOList;

  List<BannerVO>? get getBannerList => _bannerVOList;

  set setMangaList(List<MangaVO>? mangaVOList) => _mangaVOList = mangaVOList;

  List<MangaVO>? get getMangaList => _mangaVOList;

  set setNoInternetStatus(bool isNoInternet) {
    _isNoInternet = isNoInternet;
    notifyListeners();
  }

  bool get getNoInternetStatus => _isNoInternet;

  Future getWifiOrMobielStatus() async {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setNoInternetStatus = true;
      } else if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        setNoInternetStatus = false;
      }
    });
  }

  set setLightNovelList(List<LightNovelVO>? lightNovelList) =>
      _lightNovelList = lightNovelList;

  List<LightNovelVO>? get getLightNovelList => _lightNovelList;

  set setArticleList(List<ArticleVO>? articleList) =>
      _articleList = articleList;

  List<ArticleVO>? get getArticleList => _articleList;

  HomePageProvider({String mangaID = ''}) {
    setisFavorite(mangaID);
    getWifiOrMobielStatus();
    _otaModel.getBannerFromPersistent().listen((banners) {
      setBannerList = banners;
      notifyListeners();
    }, onError: (error) => print(error));

    _otaModel.getMangaFromPersistent().listen((mangas) {
      setMangaList = mangas;
      notifyListeners();
    }, onError: (error) => print(error));

    _otaModel.getLightNovelFromPersistent().listen((lightNovel) {
      setLightNovelList = lightNovel;
      notifyListeners();
    }, onError: (error) => print(error));

    _otaModel.getArticleFromPersistent().listen((article) {
      setArticleList = article;
      notifyListeners();
    }, onError: (error) => print(error));

    _otaModel.getArticleFromNetwork().then((article) {
      setArticleList = article;
      notifyListeners();
    }).catchError((error) => print(error));
  }
}
