import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}


class _HomepageState extends State<Homepage> {

  List<String> imagePaths = [];
  Future<List<String>> loadAllImagePaths() async {
    final manifestString = await rootBundle.loadString('AssetManifest.json');
    final manifest = json.decode(manifestString) as Map<String, dynamic>;

    final imageKeys = manifest.keys.where((key) => key.startsWith('images/image-with-names/')).toList();
    return imageKeys;
    /*This method:

    Loads the AssetManifest.json file, which contains information about included assets.
    Decodes the JSON data into a map.
    Filters the keys (asset paths) starting with 'images/' to identify image assets.
    Returns a list of filtered image asset paths.
*/
  }

  @override
  void initState() {
    super.initState();
    loadAllImagePaths().then((paths) {
      setState(() {
        imagePaths = paths;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //Use the rootBundle object to access the asset bundle:
    final rootBundle = DefaultAssetBundle.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        child: Align(
          alignment: const AlignmentDirectional(-1, -1),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Hi, Ankit',
                            style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Flexible(
                        child: Align(
                          alignment: const AlignmentDirectional(1, 0),
                          child: Container(
                            width: 52,
                            height: 52,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child:  InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {print("User Ankit");},
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: const Image(
                                  image: AssetImage('images/a.png'),
                                  width: 300,
                                  height: 300,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Opacity(
                  opacity: 0,
                  child: Container(
                    width: 368,
                    height: 34,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: 267,
                          height: 119,
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(40),
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(40),
                            ),
                          ),
                          child: Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Padding(
                              padding:
                                  const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Align(
                                    alignment: AlignmentDirectional(0, 0),
                                    child: Text(
                                        'Find recipes based on what you have already home',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Poppins')),
                                  ),
                                  Opacity(
                                    opacity: 0,
                                    child: Container(
                                      width: 100,
                                      height: 13,
                                      decoration:
                                          const BoxDecoration(color: Colors.white),
                                    ),
                                  ),
                                  const Align(
                                    alignment: AlignmentDirectional(-1, 0),
                                    child: Text('Let\'s Try ',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Readex Pro',
                                            color: Colors.deepOrange)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Opacity(
                  opacity: 0,
                  child: Container(
                    width: 417,
                    height: 41,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Fridge',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'See all',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

               Expanded(child:Padding(
                 padding: const EdgeInsets.all(16.0),
                 child: GridView.builder(
                   itemCount: imagePaths.length,
                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                     crossAxisCount: 2, // Two columns
                     mainAxisSpacing: 12.0, // Spacing between rows
                     crossAxisSpacing: 12.0, // Spacing between columns
                   ),
                   itemBuilder: (context, index) {
                     final imagePath = imagePaths[index];
                     return vegCard(imagePath);

                   },
                 ),
               ),
               )

              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget vegCard(String imagePath) {
  return Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      color: Colors.black12,
      borderRadius: BorderRadius.circular(20),
      shape: BoxShape.rectangle,
    ),
    child: Stack(
      children: [
        InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () async {},
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image(
              image: AssetImage(imagePath),
              width: 375,
              height: 518,
              fit: BoxFit.cover,
            ),
          ),
        ),
      /*  Align(
          alignment: AlignmentDirectional(0, 0),
          child: Text(
            'Hello World',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),*

        /
       */
      ],
    ),
  );
}
