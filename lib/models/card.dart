class PlayingCard {
  final int? id;
  final String cardName;
  final String suit;
  final String? imageUrl;
  final int folderId;

  PlayingCard({
    this.id,
    required this.cardName,
    required this.suit,
    this.imageUrl,
    required this.folderId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'card_name': cardName,
      'suit': suit,
      'image_url': imageUrl,
      'folder_id': folderId,
    };
  }

  factory PlayingCard.fromMap(Map map) {
    return PlayingCard(
      id: map['id'],
      cardName: map['card_name'],
      suit: map['suit'],
      imageUrl: map['image_url'],
      folderId: map['folder_id'],
    );
  }
}
