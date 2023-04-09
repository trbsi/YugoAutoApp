class UrlService {
  static String url = 'yugoauto.com';

  static String mainUrl({bool withWww = false}) {
    if (withWww) {
      return 'https://www.${url}';
    }
    return 'https://${url}';
  }

  static String mainUrlWithRedirect({bool withWww = false}) {
    if (withWww) {
      return 'https://www.${url}/open-and-redirect';
    }
    return 'https://${url}/open-and-redirect';
  }
}
