class ImageInfoModel {
  final String image;
  final String title;
  final String subtitle;
  final String? package;

  ImageInfoModel({
    required this.image,
    required this.title,
    required this.subtitle,
    this.package,
  });
}
