enum Entity {user,shop}

extension EntityValue on Entity {
  String get value {
    switch (this) {
      case Entity.user:
        return 'user';
      case Entity.shop:
        return 'shop';
    }
  }
}
