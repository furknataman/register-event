class ImageHelper {
  static String getImageForBranch(String? branch) {
    // ibAlani değerine göre görsel mapping
    const branchImageMap = {
      'DP': 'assets/lesson_images/EYS-IB-Banner-DP.jpg',
      'MYP': 'assets/lesson_images/EYS-IB-Banner-MYP.jpg',
      'PYP': 'assets/lesson_images/EYS-IB-Banner-PYP.jpg',
      'GENERAL': 'assets/lesson_images/EYS-Genel.jpg',
    };

    // Branch mapping'den kontrol et
    if (branch != null && branchImageMap.containsKey(branch)) {
      return branchImageMap[branch]!;
    }

    // Fallback: GENERAL görselini döndür
    return branchImageMap['GENERAL']!;
  }
}
