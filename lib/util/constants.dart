class Constants{

  static const accessKey = 'UGnGyfi6KilSuU2gTqE38gHldCWpHfZQZeHTaU5RswA';

  static const baseUrl = 'https://api.unsplash.com/';

  static const getTopicsUrl = baseUrl + 'topics?client_id=UGnGyfi6KilSuU2gTqE38gHldCWpHfZQZeHTaU5RswA&per_page=20';

  static String getPhotosByTopicUrl( String topic ){

    return topic + '?client_id=UGnGyfi6KilSuU2gTqE38gHldCWpHfZQZeHTaU5RswA&per_page=30';
  }


  static String searchPhotosUrl( String query ){
    return 'https://api.unsplash.com/search/photos?query=$query&orientation=portrait&client_id=UGnGyfi6KilSuU2gTqE38gHldCWpHfZQZeHTaU5RswA&per_page=30';
  }

}