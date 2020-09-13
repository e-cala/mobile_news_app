import 'package:flutter/cupertino.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:newsapp/src/models/category_model.dart';
import 'package:newsapp/src/models/news_models.dart';

final _NEWS_URL = 'https://newsapi.org/v2';
final _APIKEY = '360946e3626942d48c26c0dcb54d53e2';
/**TODO: AÑADIR VARIABLE DE PAIS */

class NewsService with ChangeNotifier {
  List<Article> headline = [];

  String _selectedCategory = 'business';

  List<Category> categories = [
    Category(FontAwesomeIcons.building, 'business'),
    Category(FontAwesomeIcons.tv, 'entertainment'),
    Category(FontAwesomeIcons.addressCard, 'general'),
    Category(FontAwesomeIcons.headSideVirus, 'health'),
    Category(FontAwesomeIcons.vials, 'science'),
    Category(FontAwesomeIcons.volleyballBall, 'sports'),
    Category(FontAwesomeIcons.memory, 'technology')
  ];

  Map<String, List<Article>> categoryArticles = {};

  NewsService() {
    this.getTopHeadlines();

    categories.forEach((i) {
      this.categoryArticles[i.name] = new List();
    });
  }

  get selectedCategory => this._selectedCategory;
  set selectedCategory(String valor) {
    this._selectedCategory = valor;
    this.getArticlesByCategory(valor);
    notifyListeners();
  }

  List<Article> get getArticulosCategoriaSeleccionada =>
      this.categoryArticles[this.selectedCategory];

  getTopHeadlines() async {
    final url = '$_NEWS_URL/top-headlines?apiKey=$_APIKEY&country=ca';
    final resp = await http.get(url);
    final newsResp = newsResponseFromJson(resp.body);
    this.headline.addAll(newsResp.articles);
    notifyListeners();
  }

  getArticlesByCategory(String category) async {
    if (this.categoryArticles[category].length > 0) {
      return this.categoryArticles[category];
    }

    final url =
        '$_NEWS_URL/top-headlines?apiKey=$_APIKEY&category=$category&country=ca';
    final resp = await http.get(url);
    final newsResp = newsResponseFromJson(resp.body);
    this.categoryArticles[category].addAll(newsResp.articles);

    notifyListeners();
  }
}
