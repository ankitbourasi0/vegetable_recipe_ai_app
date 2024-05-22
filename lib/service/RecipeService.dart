import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:vegetable_app_major/model/ResponseModel.dart';

abstract class RecipeServiceRepository {
  Future<dynamic> askAI(String prompt);
}

class RecipeServiceImplementation extends RecipeServiceRepository {
  final String? token = dotenv.env['token'];
  String APITOKEN = "AIzaSyD9NTJz00BEtWaDc3Z9foBImb8nwuQ8dI0";
  @override
  Future<dynamic> askAI(String ingredients) async {
    // print(APITOKEN);
    print(ingredients);

    final model = GenerativeModel(model: 'gemini-pro', apiKey: APITOKEN!);

    final prompt =
        'get some indian recipe with ${ingredients} or recipe which include ${ingredients}. it is mandatory to give recipe which is already exist on the internet, do not generate from yourself [also give hindi translation]';
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    print("status: ${response.candidates[0]}   response ${response.text}");
    return response.text;
  }
}

class Recipe {
  final String title;
  final String instructions;
  final String imageUrl;

  Recipe(
      {required this.title,
      required this.instructions,
      required this.imageUrl});

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        title: json['text'].split('\n').first,
        instructions: json['text'].substring(json['text'].indexOf('\n') + 1),
        imageUrl: json['parts'][0]['url'], // Assuming first part is the image
      );
}
// Future<String> getRecipe(List<String> vegetable) async {
//   const apiKey = 'YOUR_API_KEY'; // Replace with your API key
//   final prompt =
//       " get some indian recipe with ${vegetable.toString().split(" ").join(',')}. it it mandatory to give recipe which is already exist on the internet, do not generate from yourself [also translate the recipe to hindi or hinglish]";

//   final response = await http.post(
//     Uri.parse('https://api.openai.com/v1/chat/completions'),
//     headers: {
//       'Content-Type': 'application/json',
//       'Authorization': 'Bearer $apiKey',
//     },
//     body: '{"prompt": "$prompt", "max_tokens": 150}',
//   );

//   if (response.statusCode == 200) {
//     return response.body;
//   } else {
//     throw Exception('Failed to load recipe');
//   }
// }
