// Hardcoded sample data seeded into the in-memory `mockFirestore` at startup.
//
// MVP mode: no real backend. These records are what every screen reads.
// Adds/edits at runtime go into the same `mockFirestore` instance and live
// until the next process restart.
//
// Schema parity is what the existing `*Record` and `*Struct` classes expect.
// Ingredient field keys: `ingr_name` / `ingr_quantity` / `ingr_unit`.
// Procedure field key: `steps`.

const String demoUserUid = 'demo-user-uid';
const String demoPartnerUid = 'demo-partner-uid';

/// The signed-in user the app pretends to be.
Map<String, dynamic> demoUserDoc() => {
      'email': 'demo@plateitup.app',
      'display_name': 'Demo User',
      'photo_url':
          'https://res.cloudinary.com/hz3gmuqw6/image/upload/c_fill,q_auto,w_512/f_auto/plating-food-phpsUAQLM',
      'uid': demoUserUid,
      'created_time': DateTime(2024, 1, 1),
      'phone_number': '',
      'unique_code': 'DEMO-1234',
      'cover_photo_url': '',
      'old_email': '',
    };

/// A second user so the pairing UI has someone to render.
Map<String, dynamic> demoPartnerDoc() => {
      'email': 'partner@plateitup.app',
      'display_name': 'Sample Partner',
      'photo_url':
          'https://res.cloudinary.com/hz3gmuqw6/image/upload/c_fill,q_auto,w_512/f_auto/plating-food-phpsUAQLM',
      'uid': demoPartnerUid,
      'created_time': DateTime(2024, 1, 2),
      'phone_number': '',
      'unique_code': 'PRTR-5678',
      'cover_photo_url': '',
      'old_email': '',
    };

// Ingredient/procedure helpers — keep the seed below readable.
Map<String, dynamic> _ing(String name, String qty, String unit) => {
      'ingr_name': name,
      'ingr_quantity': qty,
      'ingr_unit': unit,
    };

Map<String, dynamic> _step(String text) => {'steps': text};

/// Ten starter recipes covering the home page's category filters
/// (Breakfast, Lunch, Dinner, Dessert, Snacks, Drinks). The full
/// `meal-recipe` schema has a dozen+ fields — anything unset here
/// falls back to the record's per-field defaults.
List<Map<String, dynamic>> demoRecipes(
  String authorDocPath, // e.g. "users/demo-user-uid"
) =>
    [
      {
        'meal_recipe_id': 'recipe-1',
        'title': 'Classic Pancakes',
        'banner':
            'https://images.unsplash.com/photo-1528207776546-365bb710ee93?w=800',
        'duration': '20 mins',
        'category': ['Breakfast'],
        'videolink': '',
        'isPublic': true,
        'isReady': true,
        'admin_approved': true,
        'isRecipeReported': false,
        'dateCreated': DateTime(2024, 6, 1),
        'attribution': 'Demo Kitchen',
        // `prep_time` is read raw via dateTimeFormat('Hm', ...) — only the
        // hour:minute is used. Encode the recipe's prep duration as the
        // time-of-day on an arbitrary date so 25 mins prep -> "0:25".
        'prep_time': DateTime(2024, 1, 1, 0, 25),
        'ingredient': [
          _ing('Flour', '1.5', 'cups'),
          _ing('Milk', '1.25', 'cups'),
          _ing('Egg', '1', 'large'),
          _ing('Sugar', '2', 'tbsp'),
        ],
        'procedure': [
          _step('Whisk dry ingredients together.'),
          _step('Add wet ingredients, mix until smooth.'),
          _step('Cook on a hot griddle until golden.'),
        ],
      },
      {
        'meal_recipe_id': 'recipe-2',
        'title': 'Avocado Toast',
        'banner':
            'https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?w=800',
        'duration': '10 mins',
        'category': ['Breakfast', 'Snacks'],
        'videolink': '',
        'isPublic': true,
        'isReady': true,
        'admin_approved': true,
        'isRecipeReported': false,
        'dateCreated': DateTime(2024, 6, 2),
        'attribution': 'Demo Kitchen',
        // `prep_time` is read raw via dateTimeFormat('Hm', ...) — only the
        // hour:minute is used. Encode the recipe's prep duration as the
        // time-of-day on an arbitrary date so 25 mins prep -> "0:25".
        'prep_time': DateTime(2024, 1, 1, 0, 25),
        'ingredient': [
          _ing('Sourdough bread', '2', 'slices'),
          _ing('Avocado', '1', 'whole'),
          _ing('Lemon juice', '1', 'tsp'),
        ],
        'procedure': [
          _step('Toast bread until golden.'),
          _step('Mash avocado with lemon juice and salt.'),
          _step('Spread on toast and serve.'),
        ],
      },
      {
        'meal_recipe_id': 'recipe-3',
        'title': 'Caesar Salad',
        'banner':
            'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=800',
        'duration': '15 mins',
        'category': ['Lunch'],
        'videolink': '',
        'isPublic': true,
        'isReady': true,
        'admin_approved': true,
        'isRecipeReported': false,
        'dateCreated': DateTime(2024, 6, 3),
        'attribution': 'Demo Kitchen',
        // `prep_time` is read raw via dateTimeFormat('Hm', ...) — only the
        // hour:minute is used. Encode the recipe's prep duration as the
        // time-of-day on an arbitrary date so 25 mins prep -> "0:25".
        'prep_time': DateTime(2024, 1, 1, 0, 25),
        'ingredient': [
          _ing('Romaine lettuce', '1', 'head'),
          _ing('Parmesan cheese', '0.5', 'cup'),
          _ing('Croutons', '1', 'cup'),
          _ing('Caesar dressing', '4', 'tbsp'),
        ],
        'procedure': [
          _step('Chop and wash lettuce.'),
          _step('Toss with dressing.'),
          _step('Top with parmesan and croutons.'),
        ],
      },
      {
        'meal_recipe_id': 'recipe-4',
        'title': 'Spaghetti Carbonara',
        'banner':
            'https://images.unsplash.com/photo-1612874742237-6526221588e3?w=800',
        'duration': '25 mins',
        'category': ['Dinner'],
        'videolink': '',
        'isPublic': true,
        'isReady': true,
        'admin_approved': true,
        'isRecipeReported': false,
        'dateCreated': DateTime(2024, 6, 4),
        'attribution': 'Demo Kitchen',
        // `prep_time` is read raw via dateTimeFormat('Hm', ...) — only the
        // hour:minute is used. Encode the recipe's prep duration as the
        // time-of-day on an arbitrary date so 25 mins prep -> "0:25".
        'prep_time': DateTime(2024, 1, 1, 0, 25),
        'ingredient': [
          _ing('Spaghetti', '200', 'g'),
          _ing('Eggs', '2', 'large'),
          _ing('Pancetta', '100', 'g'),
          _ing('Parmesan', '50', 'g'),
        ],
        'procedure': [
          _step('Cook spaghetti to al dente.'),
          _step('Fry pancetta until crisp.'),
          _step('Toss pasta with egg, cheese, and pancetta off heat.'),
        ],
      },
      {
        'meal_recipe_id': 'recipe-5',
        'title': 'Chicken Stir-fry',
        'banner':
            'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=800',
        'duration': '30 mins',
        'category': ['Dinner', 'Lunch'],
        'videolink': '',
        'isPublic': true,
        'isReady': true,
        'admin_approved': true,
        'isRecipeReported': false,
        'dateCreated': DateTime(2024, 6, 5),
        'attribution': 'Demo Kitchen',
        // `prep_time` is read raw via dateTimeFormat('Hm', ...) — only the
        // hour:minute is used. Encode the recipe's prep duration as the
        // time-of-day on an arbitrary date so 25 mins prep -> "0:25".
        'prep_time': DateTime(2024, 1, 1, 0, 25),
        'ingredient': [
          _ing('Chicken breast', '300', 'g'),
          _ing('Bell pepper', '1', 'whole'),
          _ing('Soy sauce', '3', 'tbsp'),
          _ing('Garlic', '2', 'cloves'),
        ],
        'procedure': [
          _step('Slice chicken and vegetables thinly.'),
          _step('Stir-fry chicken until cooked through.'),
          _step('Add vegetables and soy sauce, toss to coat.'),
        ],
      },
      {
        'meal_recipe_id': 'recipe-6',
        'title': 'Chocolate Lava Cake',
        'banner':
            'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=800',
        'duration': '35 mins',
        'category': ['Dessert'],
        'videolink': '',
        'isPublic': true,
        'isReady': true,
        'admin_approved': true,
        'isRecipeReported': false,
        'dateCreated': DateTime(2024, 6, 6),
        'attribution': 'Demo Kitchen',
        // `prep_time` is read raw via dateTimeFormat('Hm', ...) — only the
        // hour:minute is used. Encode the recipe's prep duration as the
        // time-of-day on an arbitrary date so 25 mins prep -> "0:25".
        'prep_time': DateTime(2024, 1, 1, 0, 25),
        'ingredient': [
          _ing('Dark chocolate', '100', 'g'),
          _ing('Butter', '100', 'g'),
          _ing('Eggs', '2', 'whole'),
          _ing('Sugar', '50', 'g'),
          _ing('Flour', '30', 'g'),
        ],
        'procedure': [
          _step('Melt chocolate and butter together.'),
          _step('Whisk eggs and sugar, fold into chocolate.'),
          _step('Add flour, pour into ramekins, bake 10 mins at 200°C.'),
        ],
      },
      {
        'meal_recipe_id': 'recipe-7',
        'title': 'Trail Mix',
        'banner':
            'https://images.unsplash.com/photo-1599599810769-bcde5a160d32?w=800',
        'duration': '5 mins',
        'category': ['Snacks'],
        'videolink': '',
        'isPublic': true,
        'isReady': true,
        'admin_approved': true,
        'isRecipeReported': false,
        'dateCreated': DateTime(2024, 6, 7),
        'attribution': 'Demo Kitchen',
        // `prep_time` is read raw via dateTimeFormat('Hm', ...) — only the
        // hour:minute is used. Encode the recipe's prep duration as the
        // time-of-day on an arbitrary date so 25 mins prep -> "0:25".
        'prep_time': DateTime(2024, 1, 1, 0, 25),
        'ingredient': [
          _ing('Almonds', '0.5', 'cup'),
          _ing('Raisins', '0.25', 'cup'),
          _ing('Dark chocolate chips', '0.25', 'cup'),
        ],
        'procedure': [
          _step('Combine all ingredients in a bowl.'),
          _step('Toss to distribute evenly.'),
        ],
      },
      {
        'meal_recipe_id': 'recipe-8',
        'title': 'Iced Matcha Latte',
        'banner':
            'https://images.unsplash.com/photo-1515823064-d6e0c04616a7?w=800',
        'duration': '5 mins',
        'category': ['Drinks'],
        'videolink': '',
        'isPublic': true,
        'isReady': true,
        'admin_approved': true,
        'isRecipeReported': false,
        'dateCreated': DateTime(2024, 6, 8),
        'attribution': 'Demo Kitchen',
        // Matches the "5 mins" duration; displays as "0:05" via
        // dateTimeFormat('Hm', ...) on the recipe card.
        'prep_time': DateTime(2024, 1, 1, 0, 5),
        'ingredient': [
          _ing('Matcha powder', '1', 'tsp'),
          _ing('Hot water', '50', 'ml'),
          _ing('Cold milk', '200', 'ml'),
          _ing('Ice', '1', 'cup'),
        ],
        'procedure': [
          _step('Whisk matcha with hot water until smooth.'),
          _step('Fill a glass with ice and milk.'),
          _step('Pour matcha over and stir.'),
        ],
      },
      {
        'meal_recipe_id': 'recipe-9',
        'title': 'Margherita Pizza',
        'banner':
            'https://images.unsplash.com/photo-1604068549290-dea0e4a305ca?w=800',
        'duration': '40 mins',
        'category': ['Dinner'],
        'videolink': '',
        'isPublic': true,
        'isReady': true,
        'admin_approved': true,
        'isRecipeReported': false,
        'dateCreated': DateTime(2024, 6, 9),
        'attribution': 'Demo Kitchen',
        // `prep_time` is read raw via dateTimeFormat('Hm', ...) — only the
        // hour:minute is used. Encode the recipe's prep duration as the
        // time-of-day on an arbitrary date so 25 mins prep -> "0:25".
        'prep_time': DateTime(2024, 1, 1, 0, 25),
        'ingredient': [
          _ing('Pizza dough', '1', 'ball'),
          _ing('Tomato sauce', '0.5', 'cup'),
          _ing('Fresh mozzarella', '150', 'g'),
          _ing('Fresh basil', '8', 'leaves'),
          _ing('Olive oil', '1', 'tbsp'),
        ],
        'procedure': [
          _step('Roll out dough on a floured surface.'),
          _step('Spread tomato sauce and tear mozzarella over the top.'),
          _step('Bake at 250°C for 8-10 minutes, finish with basil and olive oil.'),
        ],
      },
      {
        'meal_recipe_id': 'recipe-10',
        'title': 'Greek Yogurt Parfait',
        'banner':
            'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=800',
        'duration': '5 mins',
        'category': ['Breakfast', 'Snacks'],
        'videolink': '',
        'isPublic': true,
        'isReady': true,
        'admin_approved': true,
        'isRecipeReported': false,
        'dateCreated': DateTime(2024, 6, 10),
        'attribution': 'Demo Kitchen',
        // `prep_time` is read raw via dateTimeFormat('Hm', ...) — only the
        // hour:minute is used. Encode the recipe's prep duration as the
        // time-of-day on an arbitrary date so 25 mins prep -> "0:25".
        'prep_time': DateTime(2024, 1, 1, 0, 25),
        'ingredient': [
          _ing('Greek yogurt', '1', 'cup'),
          _ing('Granola', '0.5', 'cup'),
          _ing('Mixed berries', '0.5', 'cup'),
          _ing('Honey', '1', 'tbsp'),
        ],
        'procedure': [
          _step('Layer yogurt, granola, and berries in a glass.'),
          _step('Repeat for a second layer.'),
          _step('Drizzle with honey and serve.'),
        ],
      },
    ]
        .map((r) => {
              ...r,
              // Stamped at seed time so author refs resolve back to demoUserDoc.
              'author_path': authorDocPath,
            })
        .toList();

/// A paired-user record so the partner-pairing UI has something to render.
Map<String, dynamic> demoPairedUserDoc({
  required String userPath,
  required String partnerPath,
}) =>
    {
      'user_a': userPath,
      'user_b': partnerPath,
      'is_active': true,
      'created_time': DateTime(2024, 6, 1),
    };
