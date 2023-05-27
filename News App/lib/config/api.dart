class Api {
  static var key = 'acbd10be6415485d82f788679e57f183';
  static var home_page_treading_1 = 'https://newsapi.org/v2/everything?q=trending&from=';
  static var home_page_treading_2 = '&sortBy=publishedAt&language=en&apiKey=${Api.key}';

  static var home_page_carousel_1 = 'https://newsapi.org/v2/everything?q=latest&from=';
  static var home_page_carousel_2 = '&language=en&pageSize=6&apiKey=${Api.key}';

  static var category_view_1 = 'https://newsapi.org/v2/everything?q=';
  static var category_view_2 = '&sortBy=publishedAt&language=en&apiKey=${Api.key}';

  static var search_page_1 = 'https://newsapi.org/v2/everything?q=';
  static var search_page_2 = '&sortBy=popularity&apiKey=${Api.key}';
}


