class UrlService {
  static String url = 'yugoauto.com';

  static List<String> whitelistedDomains = [
    'https://www.google.com/recaptcha',
    'https://google.com/recaptcha',
    'https://yugoauto-302db.firebaseapp.com',
    UrlService.mainUrl(),
    UrlService.mainUrl(withWww: true)
  ];

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

  static bool matchDomain(String requestedSite) {
    bool allowNavigation = false;
    whitelistedDomains.forEach((domain) {
      if (requestedSite.startsWith(domain)) {
        allowNavigation = true;
      }
    });

    return allowNavigation;
  }
}
